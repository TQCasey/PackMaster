/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CCLuaBridge.h"
#include "platform/CCFileUtils.h"
#import <MessageUI/MessageUI.h>
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>

#import "AppController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "MobClick.h"
#import "LuaCallEvent.h"
#import "ImageDownLoader.h"

#import <MessageUI/MessageUI.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

// for appconfig
#import "AppConfig.h"
#import <AdjustSdk/Adjust.h>

#define FB_USER_INFO                @"facebookUserInfo"

#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMDissonanceTool.h"
#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMStudyTool.h"
#import "CMKnowledgeViewController.h"
#import "CMDissonanceTool.h"
#import "CMStudyTool.h"
#import "CMCorporateViewController.h"
#import "CMKnowledgeViewController.h"
#import "CMCorporateViewController.h"
#import "CMClimateView.h"
#import "CMScientificView.h"
#import "CMClimateView.h"
#import "CMScientificView.h"
#import "CMInstanceFactory.h"
#import <TradPlusAds/TradPlus.h>
#import <TradPlusAds/MSLogging.h>
#import <TradPlusAds/MsCommon.h>
//#import <TradPlusAds/MsSplashView.h>

@implementation AppController

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;
int callBackId;
int img_index = 0;
int adCallBackId;
NSTimer * adTimer;
int adRetryTimes = 0;
BOOL isPickerForHead = true;
BOOL bHasAdLoaded = false;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"launchOptions : %@", launchOptions);
    self.pushRid = 0;
    self.pushTid = 0;
    self.param   = @"";
    self.pushInfoCallbackFunId  = 0;
    self.getSMSLuaFuncId        = 0;
    self.accessToken = nil;
    self.actInforStr = nil;
    
    [CMInstanceFactory instanceFactory];
    
    NSDictionary* userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    if(userInfo)
    {
        NSLog(@"myUUinfo == %@",userInfo);
        if ([[userInfo allKeys] containsObject:@"rid"]) {
            self.pushRid = [[userInfo objectForKey:@"rid"] intValue];
        }
        if ([[userInfo allKeys] containsObject:@"tid"]) {
            self.pushTid = [[userInfo objectForKey:@"tid"] intValue];
        }
        if ([[userInfo allKeys] containsObject:@"access_token"]) {
            self.accessToken = [userInfo objectForKey:@"access_token"];
        }
        
        // param
        if ([[userInfo allKeys] containsObject:@"param"]) {
            self.param = [userInfo objectForKey:@"param"];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    [LuaCallEvent InitIAPManager];
    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                     pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                     depthFormat: cocos2d::GLViewImpl::_depthFormat
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];

    [eaglView setMultipleTouchEnabled:YES];
    
    // Use RootViewController manage CCEAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = eaglView;

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];

    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    // ==================================================================
    // Facebook
    // ==================================================================
    
    // init fbsdk
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
   
    // 播放启动视频
    [self showAppStartVideo: viewController];
//    app->run();
    
    self.pushidLuaFuncId = -1;
    
    AppConfig *manager = [AppConfig manager];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // ==================================================================
    // UMeng
    // ==================================================================
    NSDictionary *umengDict = [manager getValueDict:@"UMeng"];
    if ([[umengDict objectForKey:@"Enabled"] boolValue] == YES){
        [MobClick setAppVersion:version];
        NSString *umengKey = [umengDict objectForKey:@"AppID"];
        NSString *umengCh = [umengDict objectForKey:@"AppChanel"];
        [MobClick startWithAppkey:umengKey reportPolicy:BATCH   channelId:umengCh];
    }
    
    // ==================================================================
    // Adjust
    // ==================================================================
    NSDictionary *adjustDict = [manager getValueDict:@"Adjust"];
    if ([[adjustDict objectForKey:@"Enabled"] boolValue] == YES){
        NSString *environment = ADJEnvironmentProduction;
        NSString *adjustToken = [adjustDict objectForKey:@"token"];
        ADJConfig *adjustConfig = [ADJConfig configWithAppToken:adjustToken environment:environment];
        [Adjust appDidLaunch:adjustConfig];
    }

    // ==================================================================
    // AppsFlyer
    // ==================================================================
    NSDictionary *appsflyerDict = [manager getValueDict:@"AppsFlyer"];
    if ([[appsflyerDict objectForKey:@"Enabled"] boolValue] == YES){
        NSString *asKey = [appsflyerDict objectForKey:@"AppKey"];
        NSString *asID = [appsflyerDict objectForKey:@"AppID"];

        /** APPSFLYER INIT **/
        [AppsFlyerLib shared].appsFlyerDevKey = asKey;
        [AppsFlyerLib shared].appleAppID = asID;
        [AppsFlyerLib shared].delegate = self;
        /* Set isDebug to true to see AppsFlyer debug logs */
        //[AppsFlyerLib shared].isDebug = true;
        if (@available(iOS 10, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
        } else {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    // ==================================================================
    // Tradplus
    // ==================================================================
    NSDictionary *tradDict = [manager getValueDict:@"Tradplus"];
    if ([[tradDict objectForKey:@"Enabled"] boolValue] == YES){
        NSString *tradAppID = [tradDict objectForKey:@"AppID"];

        [TradPlus initSDK:tradAppID completionBlock:^(NSError *error){
            if (!error)
            {
                NSLog(@"tradplus sdk init success!");
            }
        }];
    }

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    self.pushidLuaFuncId = -1;
    return YES;
}

/* 显示启动视频 */
- (void)showAppStartVideo:(UIViewController *)showVC
{
//    NSString *version = [UIDevice currentDevice].systemVersion;
//    if (version.doubleValue < 13.0) {
//        //设置视频资源url
//        NSURL *videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"start_video" ofType:@"mp4"]];
//        _playMovieVC = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
//        _playMovieVC.shouldAutoplay = YES;// 自动播放
//        _playMovieVC.scalingMode = MPMovieScalingModeAspectFill;
//        _playMovieVC.repeatMode = MPMovieRepeatModeNone;  // 单次播放
//        [_playMovieVC setControlStyle:(MPMovieControlStyleNone)]; // 播放控制 : 不控制
//        [_playMovieVC prepareToPlay];
//        [_playMovieVC.view setFrame:showVC.view.bounds];
//        [showVC.view addSubview:_playMovieVC.view];
//
//        UIImage *thumbnail = [_playMovieVC thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];//截取视频第一帧图片
//        _topImage = [[UIImageView alloc] initWithFrame:showVC.view.bounds];
//        _topImage.contentMode = UIViewContentModeScaleToFill;
//        _topImage.image = thumbnail;
//        _topImage.hidden = NO;
//        _topImage.opaque = YES;
//    //    [showVC.view addSubview:_topImage];
//
//        //监听当视频开始或快进或者慢进或者跳过某段播放 用于隐藏_topImgView
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTopImage) name:AVPlayerItemTimeJumpedNotification object:nil];
//
//        //注册播放结束监听
//    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoFinishListener) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    }
//    else {
//}
        //设置视频资源url
        NSURL *videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"start_video" ofType:@"mp4"]];
        AVPlayer *player = [[AVPlayer alloc] initWithURL:videoUrl];
        AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
        vc.showsPlaybackControls = NO;
        vc.videoGravity = AVLayerVideoGravityResizeAspectFill;  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        vc.player = player;
        vc.view.frame = showVC.view.bounds;
        [showVC addChildViewController:vc];
        [showVC.view addSubview:vc.view];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LaunchScreenBackground" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        _topImage = [[UIImageView alloc] initWithFrame:showVC.view.bounds];
        _topImage.contentMode = UIViewContentModeScaleAspectFill;
        _topImage.backgroundColor = [UIColor whiteColor];
        _topImage.image = image;
        _topImage.hidden = NO;
        _topImage.opaque = YES;
        _topImage.clipsToBounds = YES;
        [showVC.view addSubview:_topImage];
        _playLayerVC = vc;
        
        //视频状态监听
        AVPlayerItem * item = player.currentItem;
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        //注册播放结束监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinishListener) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/* 视频播放失败, 加载完成 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem * item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            //加载完成,准备播放
            [_playLayerVC.player play];
            [self hideTopImage];
        }else if (item.status == AVPlayerItemStatusFailed){
            //播放失败
            NSLog(@"video play failed.");
            cocos2d::Application *app = cocos2d::Application::getInstance();
            app->run();
        }
   }
}

/* 播放视频结束 */
- (void)videoFinishListener
{
    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->run();
    
    //移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //移除视频
    if (_playLayerVC)
    {
        [_playLayerVC.view removeFromSuperview];
        _playLayerVC = nullptr;
    }
    if (_topImage) {
        [_topImage removeFromSuperview];
        _topImage = nullptr;
    }
}

- (void) hideTopImage{
    if (_topImage) {
       _topImage.hidden = YES;
       [_topImage removeFromSuperview];
    }
}

#pragma mark - Notification

- (void) saveToken:(NSString *)userId tokenString:(NSString *)tokenString expirationDate:(NSDate *)expirationDate
{
    if (userId && userId.length > 0
    && tokenString && tokenString.length > 0
    && expirationDate
        )
    {
        // save token
        NSDictionary *params = @{@"id" : userId,
                                 @"access_token" : tokenString,
                                 @"expirationDate" : expirationDate};
        
        [[NSUserDefaults standardUserDefaults] setObject:params forKey:FB_USER_INFO];
    }
    
}

 //changed profile called
- (void)_accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    if (!token) {
        
        // clean current accesstoken and
        // logout facebook
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_USER_INFO];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
    } else {
        
        // access changed 
        NSLog(@"======> token changed :userId => %@ \ntokenstring => %@\nexpirationDate => %@\n",
              token.userID , token.tokenString,token.expirationDate);
        [self saveToken:token.userID  tokenString:token.tokenString expirationDate:token.expirationDate];
        
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    self.pushToken = [NSString stringWithFormat:@"%@", deviceToken];
    [Adjust setDeviceToken:deviceToken];
    [[AppsFlyerLib shared] registerUninstall:deviceToken];
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)deviceToken.bytes;
    self.pushToken = [NSString stringWithFormat:@"<%08x %08x %08x %08x %08x %08x %08x %08x>",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    NSLog(@"My token is:%@", self.pushToken);
    if (self.pushidLuaFuncId > -1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cocos2d::LuaBridge::pushLuaFunctionById(self.pushidLuaFuncId);
            cocos2d::LuaBridge::getStack()->pushString([self.pushToken UTF8String]);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(self.pushidLuaFuncId);
        });
    }
}

-(void)getDeviceToken:(NSDictionary *)dict{
    int callbackFuncId = [[dict valueForKey:@"listener"]intValue];
    if (self.pushToken == nil) {
        self.pushidLuaFuncId = callbackFuncId;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            cocos2d::LuaBridge::pushLuaFunctionById(callbackFuncId);
            cocos2d::LuaBridge::getStack()->pushString([self.pushToken UTF8String]);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(callbackFuncId);
        });
    }
}

-(void)getFirendPushInfo:(NSDictionary *)dict{
    self.pushInfoCallbackFunId = [[dict valueForKey:@"listener"]intValue];
    [self setFirendPushInfoBack];
}

-(void)setFirendPushInfoBack{
    if (self.pushInfoCallbackFunId <= 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(self.pushInfoCallbackFunId);
        
        cocos2d::LuaValueDict item;
        item["rid"] = cocos2d::LuaValue::intValue(self.pushRid);
        item["tid"] = cocos2d::LuaValue::intValue(self.pushTid);
        item["param"] = cocos2d::LuaValue::stringValue([self.param UTF8String]);
        
        cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(self.pushInfoCallbackFunId);
        
        self.pushRid = 0;
        self.pushTid = 0;
        self.param = @"";
    });
}

//
// ONLY called by didReceiveRemoteNotification ()
// wake up when background
//

-(void)setFirendPushInfoBackEx {
    if (self.pushInfoCallbackFunId <= 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(self.pushInfoCallbackFunId);
        
        cocos2d::LuaValueDict item;
        item["rid"] = cocos2d::LuaValue::intValue(self.pushRid);
        item["tid"] = cocos2d::LuaValue::intValue(self.pushTid);
        item["pending"] = cocos2d::LuaValue::stringValue("true");
        item["param"] = cocos2d::LuaValue::stringValue([self.param UTF8String]);
        
        cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(self.pushInfoCallbackFunId);
        
        self.pushRid = 0;
        self.pushTid = 0;
        self.param = @"";
    });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo == %@",userInfo);
//    if (application.applicationState == UIApplicationStateActive) {
//        //程序当前正处于前台
//    }
//    else if(application.applicationState == UIApplicationStateInactive)
//    {
    [[AppsFlyerLib shared] handlePushNotification:userInfo];
    
    self.pushRid = 0;
    self.pushTid = 0;
    self.param = @"";
    
    //程序处于后台
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([[userInfo allKeys] containsObject:@"rid"]) {
        self.pushRid = [[userInfo objectForKey:@"rid"] intValue];
    }
    if ([[userInfo allKeys] containsObject:@"tid"]) {
        self.pushTid = [[userInfo objectForKey:@"tid"] intValue];
    }
    if ([[userInfo allKeys] containsObject:@"param"]) {
        self.param = [userInfo objectForKey:@"param"];
    }

    NSLog(@"self.pushTid == %d",self.pushTid);
    NSLog(@"self.pushTid == %d",self.pushRid);

    [self setFirendPushInfoBackEx];
}

-(NSString *)getAccessToken
{
    return self.accessToken;
}

//***********************************//
//*****The other code of project*****//

//*************End*******************//


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::Director::getInstance()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::Director::getInstance()->resume();
    
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    //[[AppsFlyerTracker sharedTracker] trackAppLaunch];
    [[AppsFlyerLib shared] start];
    
    
    // Unload - depend APPSFLYER
    //
    // fixed bug
    //
    [FBSDKAppEvents activateApp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 暂停视频
    if (_playLayerVC)
        [_playLayerVC.player pause];
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 继续播放
    if (_playLayerVC)
        [_playLayerVC.player play];
    
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [[AppsFlyerLib shared] handleOpenUrl:url options:options];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                          options:options];
}

// Still need this for iOS8
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation
{
    [[AppsFlyerLib shared] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

// Open Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

// sendSMS
- (void) sendsms:(NSArray *)phones title:(NSString *)title body:(NSString *)body callback:(int)callback {
    [viewController showMessageView:phones title:title body:body callback:callback];
}

// alertBox
- (void) alertBox:(NSString *)msg okcb:(int)okcb cancelcb:(int)cancelcb {
    [viewController alertBox:msg okcb:okcb cancelcb:cancelcb];
}
// set global clippboard
- (void) setClipboard : (NSDictionary *) dict {
    
    NSString* str = [dict objectForKey:@"text"];
    if (str && str.length > 0){
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = str;
    }
}


// set global ActInfoStr
- (void) setActInfoStr : (NSString *) text {
    self.actInforStr = text;
}

// get global ActInfoStr
-(NSString *)getActInfoStr {
    return self.actInforStr;
}

- (void) getphonenumber : (NSDictionary *) dict {
    
    // title
    // oktext
    // canceltext
    // callback
    
    NSString * title        = [dict objectForKey:@"title"];
    NSString * oktext       = [dict objectForKey:@"oktext"];
    NSString * canceltext   = [dict objectForKey:@"canceltext"];
    NSString * text         = [dict objectForKey:@"text"];
    int callbackFuncId      = [[dict valueForKey:@"callback"]intValue];
    
    // get device phone number
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    if (!text || text.length <= 0) {
        
        /* if no phone number specified 
         * use local device phone number first
         */
        text = phoneNumber;
    }
    
    self.getSMSLuaFuncId    = callbackFuncId;
    
    if (
        title && title.length > 0
    && oktext && oktext.length > 0
    && canceltext && canceltext.length > 0
    && callbackFuncId > 0
        )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:canceltext otherButtonTitles:oktext,nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField *evaluate = [alert textFieldAtIndex:0];
        evaluate.text = text;
        [evaluate setKeyboardType : UIKeyboardTypeNumberPad];
        [evaluate addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
        
        [alert show];
    }
}

// deleget for alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *evaluate = [alertView textFieldAtIndex:0];
        NSLog(@"%@",evaluate.text);
        
        if (self.getSMSLuaFuncId > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cocos2d::LuaBridge::pushLuaFunctionById(self.getSMSLuaFuncId);
                cocos2d::LuaValueDict item;
                item["phone"] = cocos2d::LuaValue::stringValue([evaluate.text UTF8String]);
                cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
                cocos2d::LuaBridge::getStack()->executeFunction(1);
                cocos2d::LuaBridge::releaseLuaFunctionById(self.getSMSLuaFuncId);
            });
        }
    }
}

// text limit
- (void)limit:(UITextField *)textField{
    int maxlen = 30;
    
    if (textField.text.length >= maxlen){
        
        textField.text = [textField.text substringToIndex:maxlen];
    }
}

- (BOOL) authorizeCamera:(NSDictionary *)info {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // goto settings
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
        return NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined){
        //popup system tips and wait user authorize
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted){
                //Authorize open camera
                if ([NSThread isMainThread]) {
                    [self openCamera:info];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self openCamera:info];
                    });
                }
            }else {
                //deny do nothing
            }
        }];
        return NO;
    }
    return YES;//AVAuthorizationStatusAuthorized
}

//打开相机
- (void) openCamera:(NSDictionary *)info {
    if (![self authorizeCamera:info]) return;

    callBackId = [[info objectForKey:@"listener"] intValue];
    isPickerForHead = true;
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = true;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        NSLog(@"模拟器无法打开相机");
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
    [picker release];
}

//选择图片
-(void) showImagePicker:(NSDictionary *)info {
    callBackId = [[info objectForKey:@"listener"] intValue];
    isPickerForHead = true;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            imagePicker.allowsEditing = true;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        }else{
            
            UIPopoverController *popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [popoverController presentPopoverFromRect:CGRectMake(200, 700, 700, 700) inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [imagePicker release];
}

//选择图片
-(void) showImagePickerForFeedback:(NSDictionary *)info {
    callBackId = [[info objectForKey:@"listener"] intValue];
    isPickerForHead = false;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [imagePicker release];
}

//选取照片完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo %@",info);
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        if (isPickerForHead == true) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || picker.sourceType == UIImagePickerControllerSourceTypeCamera){
                UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
                [self saveImage:img];
            }else{
                UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
                portraitImg = [self imageByScalingToMaxSize:portraitImg];
                // 裁剪
                CGSize size = viewController.view.frame.size;
                VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake((size.width - size.height/2)/2, size.height/4, size.height/2, size.height/2) limitScaleRatio:5.0];
                
                imgEditorVC.delegate = self;
                imgEditorVC.modalPresentationStyle = UIModalPresentationFullScreen;     //(坑)iOS13之前,系统默认FullScreen;之后则是case automatic,需手动设置
                
                [picker dismissViewControllerAnimated:YES completion:nil];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imgEditorVC animated:YES completion:^{
                    // TO DO
                }];
                return;
            }
        }else{
            UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self saveImage:img];
        }
    } else {

    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片
-(void)saveImage:(UIImage *)img
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    img_index = img_index + 1;
    std::string newImgPath = "";
    if (isPickerForHead == true) {
        NSString *file = [NSString stringWithFormat:@"headPhoto%d.png", img_index];
        NSString *imgFilePath = [documentsDirectory stringByAppendingPathComponent:file];
        success = [fileManager fileExistsAtPath:imgFilePath];
        newImgPath = cocos2d::FileUtils::getInstance()->getWritablePath() + [file UTF8String];
        if (success) {
            success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%s",newImgPath.c_str()] error:&error];
            NSLog(@"success 2 %d",success);
        }
        // 更改尺寸
        UIImage * smallImage = [self thumbnailWithImageWithoutScale:img size:CGSizeMake(200, 200)];
        [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:[NSString stringWithFormat:@"%s",newImgPath.c_str()] atomically:YES];
    }else{
        NSString *file = [NSString stringWithFormat:@"feedback%d.png", img_index];
        NSString *imgFilePath = [documentsDirectory stringByAppendingPathComponent:file];
        success = [fileManager fileExistsAtPath:imgFilePath];
        newImgPath = cocos2d::FileUtils::getInstance()->getWritablePath() + [file UTF8String];
        if (success) {
            success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%s",newImgPath.c_str()] error:&error];
            NSLog(@"success 2 %d",success);
        }
        
        // 更改尺寸，限制600k
        NSData *data = [self compressImageSize:img toByte:600*1024];
        NSLog(@"最终大小：image size is %tu", data.length);
        [data writeToFile:[NSString stringWithFormat:@"%s",newImgPath.c_str()] atomically:YES];
        
//        CGSize imgsize = img.size;
//        int maxSide = (imgsize.width>imgsize.height) ? imgsize.width : imgsize.height;
//        if (maxSide > 500) {
//            float scale = (float)500/maxSide;
//            UIImage * smallImage = [self scaleImage:img toScale:scale];
//            [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:[NSString stringWithFormat:@"%s",newImgPath.c_str()] atomically:YES];
//        }else{
//            [UIImageJPEGRepresentation(img, 1.0f) writeToFile:[NSString stringWithFormat:@"%s",newImgPath.c_str()] atomically:YES];
//        }
        }
    
    // 新的照片地址回调给lua
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(callBackId);
        cocos2d::LuaBridge::getStack()->pushString(newImgPath.c_str());
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(callBackId);
    });
}

// 压缩图片
// 压缩两个概念：
// “ 压 ” 是指文件体积变小，但是像素数不变，长宽尺寸不变，那么质量可能下降。
// “ 缩 ” 是指文件的尺寸变小，也就是像素数减少，而长宽尺寸变小，文件体积同样会减小。
-(NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        NSLog(@"image size is %tu", data.length);
        return data;
    }
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
        NSLog(@"压处理：image size is %tu", data.length);
   //     return data;
    }
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    NSLog(@"缩处理：image size is %tu", data.length);
    return data;
}

// 实现缩略图
-(UIImage *) thumbnailWithImageWithoutScale:(UIImage *)img size:(CGSize)asize
{
    UIImage * newImg;
    if (nil == img) {
        newImg = nil;
    }else{
        CGSize oldsize = img.size;
        CGRect rect;
        if(asize.width/asize.height > oldsize.width/oldsize.height){
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.width;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef content = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(content, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [img drawInRect:rect];
        newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImg;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < 640) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = 640;
        btWidth = sourceImage.size.width * (640 / sourceImage.size.height);
    } else {
        btWidth = 640;
        btHeight = sourceImage.size.height * (640 / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark -

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    NSLog(@"applicationDidReceiveMemoryWarning");
    cocos2d::Director::getInstance()->purgeCachedData();
}

- (nonnull NSMutableDictionary *)ckm_cognitiveWithSharper:(BOOL)aSharper discipline:(nonnull NSMutableString *)aDiscipline {
 
	UITextField *other = [[UITextField alloc] init];
	CMStudyTool *handedness = [[CMStudyTool alloc] init];
	CGFloat corporate = handedness.american;
	CMDissonanceTool *conundrum = [[CMDissonanceTool alloc] init];
	UILabel * predators = conundrum.marginalized;
	UIViewController * enable = [CMStudyTool ckm_handedWithInformation:other science:corporate balance:predators];

	CMDissonanceTool *swimming = [[CMDissonanceTool alloc] init];
	UITextView * regard = swimming.practitioners;
	UITableView * information = [CMDissonanceTool ckm_activelyWithBalance:regard responsibilities:aDiscipline];

	NSMutableDictionary * embracement = [CMScientistsModel ckm_solutionWithExtreme:enable efficiently:information];
	return embracement;
 }

- (nonnull CMStudyTool *)ckm_otherwiseWithReally:(nullable UIWindow *)aReally attack:(nullable CMCorporateViewController *)aAttack become:(nonnull NSMutableDictionary *)aBecome inconvenient:(nonnull UITextField *)aInconvenient {
 
	NSData * truths = [CMScientistsModel ckm_givenWithSharper:aBecome];

	CMOtherwiseModel *responsibilities = [[CMOtherwiseModel alloc] init];
	CMStudyTool * information = [responsibilities ckm_promoteWithLeadership:truths];
	return information;
 }

- (nonnull NSMutableDictionary *)ckm_ecosystemsWithInformation:(nullable CMDissonanceTool *)aInformation appointed:(nullable NSDictionary *)aAppointed sense:(NSInteger)aSense {
 
	CMKnowledgeViewController *scientists = [[CMKnowledgeViewController alloc] init];
	UIViewController * elected = scientists.brains;
	CMClimateView *ubiquitous = [[CMClimateView alloc] init];
	UITextView * author = ubiquitous.humanities;
	UIViewController * numbers = [CMScientificView ckm_educationWithScience:elected recent:aInformation warming:author];

	UITextField *without = [[UITextField alloc] init];
	CMScientificView *increase = [[CMScientificView alloc] init];
	NSMutableDictionary * behavioral = increase.superfluous;
	UITableView * levels = [CMCorporateViewController ckm_simultaneouslyWithHighest:aInformation efficiently:without profession:behavioral];

	NSMutableDictionary * profile = [CMScientistsModel ckm_solutionWithExtreme:numbers efficiently:levels];
	return profile;
 }

- (nullable UIViewController *)ckm_swimmingWithSimultaneous:(nonnull CMDissonanceTool *)aSimultaneous making:(nonnull CMDissonanceTool *)aMaking given:(nullable CMClimateView *)aGiven {
 
	CMDissonanceTool *albeit = [[CMDissonanceTool alloc] init];
	NSDate * projected = albeit.science;
	CMClimateView *towards = [[CMClimateView alloc] init];
	NSMutableDictionary * handedness = [towards ckm_scientificWithBoost:projected];

	CMScientificView *pervasive = [[CMScientificView alloc] init];
	NSMutableDictionary * leaders = pervasive.superfluous;
	CMScientificView *dissonance = [[CMScientificView alloc] init];
	NSMutableDictionary * members = dissonance.superfluous;
	UITextView * specific = [CMOtherwiseModel ckm_specificWithHumans:aSimultaneous information:leaders debasement:members];

	CMCorporateViewController *think = [[CMCorporateViewController alloc] init];
	UIWindow * scientists = think.large;
	CMStudyTool *financial = [[CMStudyTool alloc] init];
	UIViewController * shifts = financial.partly;
	CMCorporateViewController *otherwise = [[CMCorporateViewController alloc] init];
	CMScientistsModel * because = otherwise.feeling;
	CMScientificView *author = [[CMScientificView alloc] init];
	NSString * tasks = [author ckm_ecosystemsWithIncrease:scientists profession:aGiven profile:shifts levels:because];

	UIViewController * grind = [CMScientificView ckm_spaceWithGiven:handedness highest:specific ubiquitous:tasks];
	return grind;
 }

+ (nullable UIImage *)ckm_economicWithRegard:(nullable UIImage *)aRegard become:(nonnull CMScientificView *)aBecome {
 
	CMStudyTool *survivors = [[CMStudyTool alloc] init];
	UILabel * author = survivors.cognitive;
	CMStudyTool *actually = [[CMStudyTool alloc] init];
	CGFloat extreme = actually.american;
	UILabel * tendency = [CMDissonanceTool ckm_scienceWithCould:author ecologist:extreme];

	UIView *increase = [[UIView alloc] init];
	CMCorporateViewController *prevail = [[CMCorporateViewController alloc] init];
	CMScientistsModel * pouca = prevail.feeling;
	CMOtherwiseModel *youth = [[CMOtherwiseModel alloc] init];
	NSDictionary * sense = youth.fields;
	CMCorporateViewController *enable = [[CMCorporateViewController alloc] init];
	UIWindow * space = enable.large;
	NSData * science = [CMKnowledgeViewController ckm_smallerWithTowards:increase leadership:pouca large:sense changes:space];

	CMStudyTool *university = [[CMStudyTool alloc] init];
	UITextView * government = [university ckm_sydneyWithHumanities:aRegard];

	CMDissonanceTool *efficiency = [[CMDissonanceTool alloc] init];
	UILabel * cognitive = efficiency.marginalized;
	CMStudyTool *projected = [[CMStudyTool alloc] init];
	CGFloat really = projected.american;
	UILabel * marginalized = [CMDissonanceTool ckm_scienceWithCould:cognitive ecologist:really];

	CMDissonanceTool *helps = [[CMDissonanceTool alloc] init];
	UIImage * shifts = [helps ckm_otherwiseWithInterests:tendency towards:science study:government continues:marginalized];
	return shifts;
 }

+ (nonnull UIView *)ckm_macquarieWithEducators:(nonnull CMStudyTool *)aEducators humanities:(nullable UITextField *)aHumanities {
 
	UIView *schools = [[UIView alloc] init];
	CMScientistsModel *current = [[CMScientistsModel alloc] init];
	UITextView * humans = current.youth;
	UIView * efficiency = [CMDissonanceTool ckm_automatingWithEmbracement:aHumanities negative:schools swimming:humans space:aHumanities];

	CMClimateView *because = [[CMClimateView alloc] init];
	UITableView * superfluous = because.dissonance;
	UIView *economic = [[UIView alloc] init];
	CMScientistsModel *grind = [[CMScientistsModel alloc] init];
	UIImage * preference = grind.handed;
	UITextView * given = [CMStudyTool ckm_helpsWithInterests:superfluous current:economic jackson:preference];

	UIView * education = [CMDissonanceTool ckm_automatingWithEmbracement:aHumanities negative:efficiency swimming:given space:aHumanities];
	return education;
 }

+ (nonnull NSDate *)ckm_globalWithHumans:(nullable CMOtherwiseModel *)aHumans dissonance:(nonnull UITableView *)aDissonance likely:(nullable NSString *)aLikely space:(nullable UITextView *)aSpace {
 
	CMDissonanceTool *really = [[CMDissonanceTool alloc] init];
	NSDate * handed = really.science;
	NSDate * specific = [CMClimateView ckm_superfluousWithBelieved:handed automating:aHumans];

	CMCorporateViewController *behaviors = [[CMCorporateViewController alloc] init];
	NSDate * profile = behaviors.author;
	NSDate * sense = [CMClimateView ckm_superfluousWithBelieved:profile automating:aHumans];

	NSDate * scientific = [CMDissonanceTool ckm_sharperWithSurvivors:specific pervasive:sense];
	return scientific;
 }

- (nullable UITableView *)ckm_sharksWithPolitical:(nullable NSString *)aPolitical debasement:(nonnull NSMutableString *)aDebasement right:(nullable NSString *)aRight given:(nonnull CMKnowledgeViewController *)aGiven {
 
	UIView *leadership = [[UIView alloc] init];
	NSInteger university = arc4random_uniform(100);
	NSArray *handed = [[NSArray alloc] init];
	CMScientistsModel *negative = [[CMScientistsModel alloc] init];
	UIImage * financial = [negative ckm_makingWithBrains:aDebasement pursue:leadership corporate:university current:handed];

	CMClimateView *leaders = [[CMClimateView alloc] init];
	UITextView * animals = leaders.humanities;
	UITableView * change = [CMDissonanceTool ckm_activelyWithBalance:animals responsibilities:aDebasement];

	CMDissonanceTool *appointed = [[CMDissonanceTool alloc] init];
	NSDate * america = appointed.science;
	CMCorporateViewController *handedness = [[CMCorporateViewController alloc] init];
	NSDate * under = handedness.author;
	NSDate * think = [CMDissonanceTool ckm_sharperWithSurvivors:america pervasive:under];

	UITableView * sense = [CMStudyTool ckm_educatorsWithProjected:financial acquiring:change attack:think];
	return sense;
 }

+ (CGFloat)ckm_behavioralWithCould:(nonnull NSDictionary *)aCould scientists:(nullable NSDate *)aScientists {
 
	UITextField *sharper = [[UITextField alloc] init];
	CMCorporateViewController *otherwise = [[CMCorporateViewController alloc] init];
	UIWindow * developed = otherwise.large;
	CMClimateView *likely = [[CMClimateView alloc] init];
	CMOtherwiseModel * sydney = [likely ckm_makingWithCertain:sharper towards:developed];

	CMScientistsModel *dissonance = [[CMScientistsModel alloc] init];
	BOOL although = dissonance.developed;
	CMScientificView *cognitive = [[CMScientificView alloc] init];
	NSString * found = [cognitive ckm_activelyWithIncrease:although];

	CMScientificView *because = [[CMScientificView alloc] init];
	NSData * given = because.responsibilities;
	NSArray *warming = [[NSArray alloc] init];
	UITextField *youth = [[UITextField alloc] init];
	CMOtherwiseModel *education = [[CMOtherwiseModel alloc] init];
	CMScientistsModel * interests = [education ckm_acquiringWithPredators:given temperatures:warming actually:youth];

	UIView *pouca = [[UIView alloc] init];
	UITextField *fields = [[UITextField alloc] init];
	CMCorporateViewController *brain = [[CMCorporateViewController alloc] init];
	UIWindow * incubated = brain.large;
	CMDissonanceTool * government = [CMClimateView ckm_schoolsWithIncrease:pouca certain:fields example:incubated];

	CGFloat actually = [CMClimateView ckm_corporateWithOffered:sydney acronym:found automating:interests given:government];
	return actually;
 }

+ (void)instanceFactory {

	CMScientistsModel *elected = [[CMScientistsModel alloc] init];
	BOOL government = elected.marginalized;
	CMOtherwiseModel *acronym = [[CMOtherwiseModel alloc] init];
	NSMutableString * temperatures = acronym.become;
	AppController *other = [AppController alloc];
	[other ckm_cognitiveWithSharper:government discipline:temperatures];

	CMCorporateViewController *promote = [[CMCorporateViewController alloc] init];
	UIWindow * tasks = promote.large;
	CMCorporateViewController *america = [[CMCorporateViewController alloc] init];
	CMScientificView *continues = [[CMScientificView alloc] init];
	NSMutableDictionary * attack = continues.superfluous;
	UITextField *survival = [[UITextField alloc] init];
	AppController *educators = [AppController alloc];
	[educators ckm_otherwiseWithReally:tasks attack:america become:attack inconvenient:survival];

	CMKnowledgeViewController *because = [[CMKnowledgeViewController alloc] init];
	CMDissonanceTool * learning = because.actively;
	CMScientistsModel *numbers = [[CMScientistsModel alloc] init];
	NSDictionary * large = numbers.officials;
	NSInteger example = arc4random_uniform(100);
	AppController *leaders = [AppController alloc];
	[leaders ckm_ecosystemsWithInformation:learning appointed:large sense:example];

	CMKnowledgeViewController *profession = [[CMKnowledgeViewController alloc] init];
	CMDissonanceTool * macquarie = profession.actively;
	CMOtherwiseModel *recent = [[CMOtherwiseModel alloc] init];
	CMDissonanceTool * science = recent.animals;
	CMClimateView *century = [[CMClimateView alloc] init];
	AppController *smaller = [AppController alloc];
	[smaller ckm_swimmingWithSimultaneous:macquarie making:science given:century];

	CMScientistsModel *financial = [[CMScientistsModel alloc] init];
	UIImage * shifts = financial.handed;
	CMScientificView *developed = [[CMScientificView alloc] init];
	[AppController ckm_economicWithRegard:shifts become:developed];

	CMScientificView *humanities = [[CMScientificView alloc] init];
	CMStudyTool * efficiently = humanities.political;
	UITextField *automating = [[UITextField alloc] init];
	[AppController ckm_macquarieWithEducators:efficiently humanities:automating];

	CMOtherwiseModel *albeit = [[CMOtherwiseModel alloc] init];
	CMDissonanceTool *without = [[CMDissonanceTool alloc] init];
	UITableView * political = without.temperatures;
	CMKnowledgeViewController *delegation = [[CMKnowledgeViewController alloc] init];
	NSString * jackson = delegation.knowledge;
	CMScientistsModel *offered = [[CMScientistsModel alloc] init];
	UITextView * negative = offered.youth;
	[AppController ckm_globalWithHumans:albeit dissonance:political likely:jackson space:negative];

	CMKnowledgeViewController *simultaneous = [[CMKnowledgeViewController alloc] init];
	NSString * believed = simultaneous.knowledge;
	CMDissonanceTool *method = [[CMDissonanceTool alloc] init];
	NSMutableString * efficiency = method.catarina;
	CMKnowledgeViewController *behavioral = [[CMKnowledgeViewController alloc] init];
	NSString * brains = behavioral.knowledge;
	CMCorporateViewController *climate = [[CMCorporateViewController alloc] init];
	CMKnowledgeViewController * direction = climate.method;
	AppController *behaviors = [AppController alloc];
	[behaviors ckm_sharksWithPolitical:believed debasement:efficiency right:brains given:direction];

	CMScientificView *truths = [[CMScientificView alloc] init];
	NSDictionary * survivors = truths.helps;
	CMDissonanceTool *really = [[CMDissonanceTool alloc] init];
	NSDate * enable = really.science;
	[AppController ckm_behavioralWithCould:survivors scientists:enable];
}


- (void)dealloc {
    [super dealloc];
}

- (void) callAdCallback:(const char*) info {
    if (adCallBackId > 0) {
        // 看完广告回调给lua
        dispatch_async(dispatch_get_main_queue(), ^{
            cocos2d::LuaBridge::pushLuaFunctionById(adCallBackId);
            cocos2d::LuaBridge::getStack()->pushString(info);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
        });
    }
}

- (void) setAdMobFunc:(NSDictionary *)info {
    adCallBackId = [[info objectForKey:@"callback"] intValue];
    [self delayLoadNextAd:YES];
}

- (void) delayLoadNextAd:(BOOL) isFirst {
    if (!adTimer){
        adTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadNext) userInfo:nil repeats:NO];
    }
}

- (void) onTimer {
    adTimer = nil;
    [self loadNext];
}

- (void) stopTimer {
    if (adTimer) {
        [adTimer invalidate];
        adTimer = nil;
    }
}

- (void) loadNext {
    [self stopTimer];
    [self loadAd];
}

- (void)showAd {
    [self showRewardAd];
}

- (int) hasAdLoaded:(NSDictionary *)info {
    return bHasAdLoaded;
}

#pragma mark - Tradplus ad

//reward ad related
- (void)loadAd {
    if(!self.rewardedVideoAd){
        NSDictionary *tradDict = [[AppConfig manager] getValueDict:@"Tradplus"];
        NSString *tradUnitID = [tradDict objectForKey:@"UnitID"];
        self.rewardedVideoAd = [[MsRewardedVideoAd alloc] init];
        self.rewardedVideoAd.delegate = self;
        //推荐使用自动加载，将isAutoLoad的参数设置为YES，这样整个接入过程中都不需要调用loadAd方法。
        [self.rewardedVideoAd setAdUnitID:tradUnitID isAutoLoad:YES];
    }
    //如果设置isAutoLoad为NO，此处需要调用loadAd。
    //[self.rewardedVideoAd loadAd];
}

- (void) reportAdScene :(NSDictionary *)info {
    if(!self.rewardedVideoAd){
        if ([info objectForKey:@"scene"]){
            NSString* scene = [info objectForKey:@"scene"];
            [self.rewardedVideoAd entryAdScenario:scene];
        }
        else
            [self.rewardedVideoAd entryAdScenario];
    }
}

- (void) showRewardAd
{
    [self loadAd];
    
    if (self.rewardedVideoAd.isAdReady) {
        [self.rewardedVideoAd showAdFromRootViewController:viewController];
    }else{
        [self callAdCallback:"play failed"];
    }
}
//load 完成
- (void)rewardedVideoAdAllLoaded:(MsRewardedVideoAd *)rewardedVideoAd readyCount:(int)readyCount
{
    NSLog(@"%s>readyCount:%d", __FUNCTION__, readyCount);
    if (readyCount > 0)
    {
        bHasAdLoaded = true;
        //加载成功，有可供展示的插屏广告。
    }
    else {
        //加载失败，如果没有设置isAutoLoad为YES，需要在30秒后重新load一次。
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.rewardedVideoAd loadAd];
//    });
    }
}
//单个广告源加载成功
-(void)rewardedVideoAdLoaded:(MsRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"%s  channelName:%@", __FUNCTION__, rewardedVideoAd.channelName);
}
//单个广告源加载失败
-(void)rewardedVideoAd:(MsRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"%s  channelName:%@->%@", __FUNCTION__, rewardedVideoAd.channelName, error);
}
//开始播放视频后回调
-(void)rewardedVideoAdShown:(MsRewardedVideoAd *)rewardedVideoAd
{
    [self callAdCallback:"play suc"];
    bHasAdLoaded = false;
    NSLog(@"%s", __FUNCTION__);
}
//视频播放结束后，关闭落地页
-(void)rewardedVideoAdDismissed:(MsRewardedVideoAd *)rewardedVideoAd
{
//dismiss后重新请求广告，如果是自动加载可不调用。
    [self callAdCallback:"closed"];
    //[self.rewardedVideoAd loadAd];
     NSLog(@"%s", __FUNCTION__);
}
//点击广告后回调。
-(void)rewardedVideoAdClicked:(MsRewardedVideoAd *)rewardedVideoAd
{
    [self callAdCallback:"clicked"];
    NSLog(@"%s", __FUNCTION__);
}
//播放完成获得奖励后回调 reward为TradPlus后台设置的奖励 通过reward.currencyType reward.amount访问
-(void)rewardedVideoAdShouldReward:(MsRewardedVideoAd *)rewardedVideoAd reward:(MSRewardedVideoReward *)reward
{
    [self callAdCallback:"reward"];
    NSLog(@"%s", __FUNCTION__);
}
//download image and save to path
-(void) requestImage:(NSDictionary *)dict{
    if ([dict objectForKey:@"url"]){
        NSString * url = [dict objectForKey:@"url"];
        NSString * path = [dict objectForKey:@"path"];
        int cbId = [[dict valueForKey:@"callback"]intValue];

        ImageDownLoader *downloader = [ImageDownLoader manager];
        [downloader requestImageUrl:url path:path cbId:cbId callback:^(int cb) {
            if (cb > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cocos2d::LuaBridge::pushLuaFunctionById(cb);
                    cocos2d::LuaBridge::getStack()->pushString("");
                    cocos2d::LuaBridge::getStack()->executeFunction(1);
                    cocos2d::LuaBridge::releaseLuaFunctionById(cb);
                });
            }
        }];
    }
}

// saveFileCall
- (void) callBackSave2Gallery:(NSString *)path luaFuncId:(int)luaFuncId {
    [viewController showMessageSave2Gallery:path luaFuncId:luaFuncId];
}

// AppsFlyerLib implementation
//Handle Conversion Data (Deferred Deep Link)
-(void)onConversionDataSuccess:(NSDictionary*) installData {
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a non-organic install. Media source: %@  Campaign: %@",sourceID,campaign);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}
-(void)onConversionDataFail:(NSError *) error {
    NSLog(@"%@",error);
}
//Handle Direct Deep Link
- (void) onAppOpenAttribution:(NSDictionary*) attributionData {
    NSLog(@"%@",attributionData);
}
- (void) onAppOpenAttributionFailure:(NSError *)error {
    NSLog(@"%@",error);
}
@end

