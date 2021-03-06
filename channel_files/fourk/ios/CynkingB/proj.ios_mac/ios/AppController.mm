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
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>

#import "AppController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "LuaCallEvent.h"
#import "ImageDownLoader.h"

#import <MessageUI/MessageUI.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <TradPlusAds/TradPlus.h>
#import <TradPlusAds/MSLogging.h>
#import <TradPlusAds/MsCommon.h>
//#import <TradPlusAds/MsSplashView.h>



// for appconfig
#import "AppConfig.h"
#import <AdjustSdk/Adjust.h>

#define FB_USER_INFO                @"facebookUserInfo"

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
BOOL bStartVideoEnded = false;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"launchOptions : %@", launchOptions);
    self.pushRid = 0;
    self.pushTid = 0;
    self.param   = @"";
    self.info    = @"";
    self.pushInfoCallbackFunId  = 0;
    self.getSMSLuaFuncId        = 0;
    self.accessToken = nil;
    self.actInforStr = nil;
    
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
        //??????UIUserNotificationSettings????????????????????????????????????
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
    
    // ??????????????????
    [self showAppStartVideo: viewController];
    
    AppConfig *manager = [AppConfig manager];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
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

/* ?????????????????? */
- (void)showAppStartVideo:(UIViewController *)showVC
{
    //???????????????, ????????????????????????
//    startImage = nullptr;
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"Default-start-screen" ofType:@"png"];
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//
//        startImage = [[UIImageView alloc] init];
//        startImage.frame = [window bounds];
//        startImage.contentMode = UIViewContentModeScaleAspectFill;
//        [startImage setImage:image];
//        [showVC.view addSubview:startImage];
//    }
    
    //??????????????????url
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"start_video" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:urlStr];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.showsPlaybackControls = NO;
    vc.videoGravity = AVLayerVideoGravityResizeAspectFill;  // ???????????????????????????????????????????????????????????????????????????????????????????????????
    vc.player = player;
    vc.view.frame = showVC.view.bounds;
    [showVC addChildViewController:vc];
    [showVC.view addSubview:vc.view];
    _playLayerVC = vc;
    [vc.player play];
    
    //??????????????????
    AVPlayerItem * item = player.currentItem;
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //????????????????????????
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinishListener) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/* ??????????????????, ???????????? */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem * item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            //????????????,????????????
        }else if (item.status == AVPlayerItemStatusFailed){
            //????????????
			bStartVideoEnded = true;
            NSLog(@"video play failed.");
            cocos2d::Application *app = cocos2d::Application::getInstance();
            app->run();
        }
   }
}

/* ?????????????????? */
- (void)videoFinishListener
{
    if (bStartVideoEnded) {
        return;
    }

    bStartVideoEnded  = true;

    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->run();
    
    //??????????????????
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //????????????
    [_playLayerVC.view removeFromSuperview];
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
    [Adjust setDeviceToken:deviceToken];
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)deviceToken.bytes;
    self.pushToken = [NSString stringWithFormat:@"<%08x %08x %08x %08x %08x %08x %08x %08x>",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];

    
    //????????????????????????????????????????????????????????????????????????????????????????????????????????????APNS?????????????????????????????????APNS????????????????????????????????????????????????
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
    
    cocos2d::LuaBridge::pushLuaFunctionById(self.pushInfoCallbackFunId);
    dispatch_async(dispatch_get_main_queue(), ^{
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
//        //???????????????????????????
//    }
//    else if(application.applicationState == UIApplicationStateInactive)
//    {
    
    self.pushRid = 0;
    self.pushTid = 0;
    self.param = @"";
    
    //??????????????????
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

- (nonnull NSDictionary *)pBXXcZTDKZIENR :(nonnull NSDictionary *)JzBEmjTNsAQkKrCVGo :(nonnull NSString *)kfUZWMiwICpFwKADWS :(nonnull NSData *)oAJzVkYSRMnNzNM {
	NSDictionary *gLwVEoTLsX = @{
		@"HnjHWaXypOK": @"PWNqdWqkzVOTfretEqnKBkxaEkVUAfWxvPercBDQKwBIpYzLbTIqclEFWkWBFiCzjNrBSDWvlSwIcifXGpfqRjiRMECaNfiBZyVbbrlfRvYwEaIQeKhVpzbaS",
		@"DbYNgXChoRzCE": @"PRlyEGifzvsJmedsOpyWAUgVpqKnqMbWxkxIJYVssoEGtdHdaJfRNosfNWUIofKzdOcWMnyUOqngQtBRyHrvgrfneOOPNSAVqBcSSIHrkPkAsfoEswdVaFmaJJRPWFc",
		@"MYLpUmyGpYmFxZ": @"GWfYaaxIxcMsPxWHkvfxMzssKyQzXsXdNKqMElBJUHDRKexxWFwPjYzpQdrryhLblrLGfXxRZbtHVvhmhLCPYBjksSlkojAmDBUBBsLLSovFN",
		@"tyfPntVpqjNmBP": @"dzksQRWMNCpOOzPmkYZiWxrUTzJenpqlsXCTIXUmTapPzfOgeeCCeGUzaCfqFpQesACbAEOpDnkmyZZfbHeJAAVCLULBIJKlCmpkZeccUgcYwMRaYSwEmcDEPgSsrYWCjCPNtC",
		@"wEbzcUxNqVTRHx": @"kgXjRVwJxooCPPlxzzvwYeosMTlYtChuTejQYnXYezxcccKJLXdHxgDJhtCllbncAkzZPTQsrRNcfhWVrBVBVRdfcAshIXyRPfuGbGVuYXMDSHzjVqcYFM",
		@"ueqkVOdmqeTvVLnq": @"ZwmquLRpJRrpekttnmpZBvdfjDypmkJmNMVVtdRruUnbxUKHvmpHyItucWqXgUsmWilHJjfSMcTrCSJRtuhHGLTnisNIrazzCVlUNpvqVBeCY",
		@"wknnbvPkcXGlEHJ": @"fKyAcnMWhNyFIUhZokNlWGAOKUUYXdcrZCGRLZnMEEUXIMpoduNmVUaGyptRsMkWHACdmkSvhFGAkwueZGtXZMfwMjySvREbrxRmGZBDgKEhgpMfzWxJSReathFyBD",
		@"SVQwQYjqoDdCYRdog": @"TtgjqrBWXPUeFdzkbCAagHCbeCtkNFqHLPJKvQEXiazAyAdXnnqIGJHtUtmBWxMAAwgcZxDPpcUCrHOizdRSgdBhUBUblHsCGftMtQa",
		@"tdbSKabIxnF": @"kWKbDVTHhBnHrCaenSSHbPBfGCFVNGAievnGLLRZlgcMscCaPPkyMgjlXaycYBUvGOLAvWWAnkmApQpicviMBAbDvTOakwcmAEiABIhnOzXSZvmMsSUkcd",
		@"xjHDfUfeQHAO": @"yrKOQQStAwqRZioIUaHRRnNqcPEeUEkFcpiPEFoXnyTTavDYnFFxEWZwNJbeYhntcKLJzzSIdpZBpJVwXwAzepsXnkMsjDGnGmlyFdkVHIqBmyKyRCCEWaxCIhWUex",
		@"RPyExOZOVyEQJ": @"ghFJJPqhWXpMfYRVsqBwZQzjVNwUYwdaiMhaOuicZfUwhjhdDrqizDhHiJHOcZSTSqbjdYxSinMaUDHyffhNpzjtrgbtiWdjxLVxWujvfDjXqkaoZAsnmUAkxPOktPTQelRwetnINKEuzdFnd",
		@"fAZmqxWatTlbiT": @"dtoSnWdWQeqQnzidGFnNygZBRUrlTdSUucRTNcbzRCdyNNEPvdGijskOZDSJKsPKwSJSnnNEuBLYiklTJHGyXdLQEjnPsOzWpooDBldlZdrmyaHbcOxMWmoFdsdRFy",
		@"yoldDwMqxLxAbNmY": @"ADzcwkWCNKbVFnRlwFVTcgXpRfXRAitYAnHuGHmHMagVIwOSEMCGWukPwDtRBECxYdgTvFALKbKqNTIdnPMdFrtSGAJrqjQZIZIoPGviiWQpmWPcGplynSFLanxMxqvyLp",
		@"EwxSdvztvuYpHx": @"fiRlGKFUuDnYeLyKnVUzZWKSYOsToOvBTSsCtWClJXOXvgLhCdsrvPlZlmliuIQdCvBgXQCKTUANnefjKjItHwYBKXAshhhOFFKkKIwksVcALQxPgGVqeyeT",
		@"mBhBfIgStjOE": @"mQYqbzUOgtSxNJBBsctbNAeFibLJPNLyeKbrwzjaZmuAPYJBNXgDomsKyPSPVyienYNTqxjGyzozqcNMPfvbYsVOYnByfWQVjnkEKDbBGSuhnEGeForQsrDikhPOXinilXRlAgAMGZYh",
	};
	return gLwVEoTLsX;
}

- (nonnull NSArray *)OWNeCOrOCD :(nonnull NSData *)ESwFWmffrmfGGLz {
	NSArray *eWNHzovcqPu = @[
		@"JHxCviFbBgtBfwdjdVARfEyAWdQWWJuxrQALEoSoKVXvLXFDouNMDybUAACNiNOxIwuwwEMtWFoXZFdbRbWBjFeZauQvqXDcmFrYw",
		@"eKqnJbhMNcsHkocqAbRYxvOMzpLAnDKWabzXaznjNWAFRSOjREtbFsVwOKeRELNuSGUOvawdVYcoLaQKqLthQQhdTrtWxCKCKrPlfQoyTYMuiLuTqZpMraHpvydKjndPBFnQGXvzFfKm",
		@"mcQyYAEbpkPSoKyfgIWsHrPPmykQWBVccrwRZYKGFBwTbByEEBERWiiSgtfgmVXWcmhgfOxrcujDfMvNtuAzTqFxHPRuqWyzulTxCxahIOmFQKgdRZpXPrEZaZtc",
		@"SiTelTtNwUqsUbspDWHdVHOxgxExLTnuiAlQaLNuVpiEOKlYoiPWCmHiLdfMNZzCFzloIUWKglOtMRuIcfZDFCLOraidnkLMDBWcbbEeODdGcHJmoZyYZUrPWCNyVaVfpcFOkpDonq",
		@"cCcdsKBpPaEsdXClxFJJohjiltFCxUUmPLxNMTHzvGIQMlDTzKOovoIWcEBXJPxAgeJLAqwnaFvyPQgQUEijJMCvoXBSTriNokRLrDIqjRJnTbAFnzWdFJxRMXGrtGyIeNIGjJYqxdvXRh",
		@"kFCvsfVqblsvZpVegIqlBezaxzZePJyeYnLgmuIljJcVGEduPLIEbmibHUXGMmHAyVlDjOvEqMdkjJLYgoqhFOwaMUtguyuCVYcnZGAuKQBcQqbIVhveqDflVQSveBcDfPipjOAylFciyzxrMexR",
		@"RrcYnDRoFiJfHyzPGGvtHYtpQOpxowOVyOpCgRPYTyWhUswFHIUBYUxjuuHaGSvnURRuVZAHxbuwtBAlkjZMshKoxexlVfZdnAlgruiBNkMaZeAeNuuipXYrIlBZSMXKOnGkNiywNWJbssyq",
		@"QVeNWGzDMehoAryijTGUXVOOgGBWmxREhYpCSxZsGkGlvmQrtebiHDLbbWmrEUGDsZWZaqYjcImdUpbcDPByhMndMBLvWGlhIiDxxlotnpUsqlZgALaCsVcVnLzPUWXOFtLQOewuAtHw",
		@"JdWVCUjAvSYxBQfVnLMIQDNdIEBwPYIJEMHBiZcRkRrZkDwxmPZmLsapsbyobkKFypXKyvwadpOhSRwelHhOcetHObdyAlFAVujBOI",
		@"XihDGSclagaBizHVbRrVsMuAmmkWtYkmFwlhlXcyBvQjPffCkrbizLtJjuMyOscIKqYDKXKRwcgsuZDeDZNzClvWPWfzytgqWOfrLxPf",
		@"DirLZFQbVUYMCdLRxUHXFwgzcrheiwQNxqaFRaFOTdSbSsuKTcEtQvUIZSVtgYCkTflKxINjPhAiaTKaVaclaXtpEGnlvhZieywVeGZwTvavnhBrSleqebiXnOYLORO",
	];
	return eWNHzovcqPu;
}

- (nonnull UIImage *)SEUEEZlTHY :(nonnull NSArray *)dZSgLKbacaQpfBfUQVq {
	NSData *eDyqTuKMhhQYcfO = [@"hbjMSFtbtSrrcAupmEnThYWERlcFIFPglZbjMLwqBlsDtrhKtHbCzdSvNDkBnbzzwUjsXVTvIHiFiAXjUkdIINtMHbMZNewIwkBeKvAKjTcnjpwn" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *jbxwdTgAsXhJojnWwo = [UIImage imageWithData:eDyqTuKMhhQYcfO];
	jbxwdTgAsXhJojnWwo = [UIImage imageNamed:@"fHxOKlvlqrPGkfTBUMnjieyaBluyZgISFzryVCyghnVlNZuGkXViHEqazbWmPCNRrZUvkmqKoOLuZHcVbCDIweJxPrluGRlYphsh"];
	return jbxwdTgAsXhJojnWwo;
}

- (nonnull UIImage *)IRMMCSfQyCC :(nonnull NSArray *)dnmmeiScRKwvyQIMFmn {
	NSData *jgaLKSoUGZe = [@"LWbvxIHbRqfGbRWwNQaPZFNVUiEFBiBQGQYqfJRRafsFcpwyWTaquqGevYMJnCwsaeuROqOMduolpMpaUumOtidSWCOmcogeQqavaVFKVnwlpOuVVhhNYxhmBMq" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *OMBsxJoWIDRMH = [UIImage imageWithData:jgaLKSoUGZe];
	OMBsxJoWIDRMH = [UIImage imageNamed:@"qsCELygRkTPnlvCOdGChhSEqsNKFMarRpQieONYTbuyEXpQluSoOCmImdjgkIqGZIxFwcoKvALjoedTtSbWiIgTomLHAhtzceDxJOqlcaZycAlHySiFrxFuVZDtpSfRbAzvQ"];
	return OMBsxJoWIDRMH;
}

- (nonnull UIImage *)MldPfUXTKpPQEYDyT :(nonnull NSDictionary *)eYOCZOgCTouQKsu :(nonnull NSData *)nmYAhbebFKNpOH :(nonnull UIImage *)aNlejyxtZpTueO {
	NSData *kIhIKlqjNj = [@"NaXGmOQXGRRvvfjJkymiTPgjrnkEGzEkHgpsDzzsgYtHMhlwCtTJKKrCRdDucBIuHVoOAiMLbWhKQdYYOaGdzRSAkKAxTbPEqmNqJiWYSqVsNZdVYeNFTgwWhqtIUSCzZLsXCWfGqIBaBXWiH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hFKgkLflXQBTHk = [UIImage imageWithData:kIhIKlqjNj];
	hFKgkLflXQBTHk = [UIImage imageNamed:@"hsjInIsGKdOYpDIDhLtiqBgcUrWOILvPxxfDwuItGfBqFLhKndfBLPQdRpnngaletpdgJrQLLzTvMOPkYrKtmKqXjiYfIUMfTTnQjtZWGMntVzVuopW"];
	return hFKgkLflXQBTHk;
}

- (nonnull NSArray *)jgkJoFSMQKWHsqSOv :(nonnull NSArray *)rLCVgnqSeHdyACSK :(nonnull NSArray *)gxoOBnUQZCrY :(nonnull NSDictionary *)tNlxNlZmXuqqYnUhi {
	NSArray *DkjoNAPZnTZAQvMq = @[
		@"GbaCZfHkpOiuUzYhBOhgHAoYekqsXesfPwKIzjiJFnKcMLUCgtWZPvjPqqqFdVTnsUiTVeTnhrFoiBYlkZpoJLzYLfJySyRIuNTCPnLUibjD",
		@"VrbLiTibZgqOiNXTiHgFeByEnrKilMXtfqJnLErLQvNILSipEFsmdnOAHbmunqNAxATWhsELKqxFDpdfTEgZRPJbzaIvhRonEKVc",
		@"ZdILMHXjNbXnnRaBzchmxBhSfSmoaNTwKGKLSbFHWVSLJNPDHOWjxgYRgQZlaihxwxzDUSoXOIQvXelNlXetvRTEriakIEUFTuNvMsrjkOSMixJkJNYHLKjsavdEZZuFvarjEJFBhFXsOIDeltZLn",
		@"tSneutftctVYfxSrTEFnduyOjtLflElZKVtxsrQIBKcueeUIOYPpRjdtOdhzvXGRzIVgiFaWvOOeWTvpkONdUTymNPxlwxfTjYZRCaRaxcaMrVLNKfBIqeUDorAbtsBENdCtAparRsRjHqq",
		@"gcjNMYiNdYzWHFvOqkmKRvzmdjNJKsFdyQEWpIxRBTOYfYUbYcfbytSNmcNKyGXcaJRDbcDzfzCGvCVtuGjjqYKHwdTyRzGreaPDNXmmLKfVsXmzBTfrivJtjzjgZ",
		@"OZIwLGvDpynxAZjlVzUgJqfCWgxYZblKbkDrCcFEkYTLRbWKfHQvECvjqDYMzRXmMfrtKEprBLrOeOUJlksAylqyqoVDrAgIoQjyVTZ",
		@"mWuFZDkDpUohGfMErlYwOVjhVJoHuLStoYjAxFjHTNHcGcVxeVVPqQVDGXUEfBYpmAGQGNwacjoESHjCBOkrAvSdsukdFMrBljpYIVDuiFMawGJQqLEeIEYDVUJx",
		@"poNFQDDuOKMzItGcvoazYPUMiRqFxffCbOKRwuchjRcqfXiFkPZzvifdPMCQQSlgrmAMwYCiGgAxDgMHkbxpeqNDOEcMULqhmbHkpyfHlPgsBRXJWEbIUuJbqjGFfnGKyNPJrNtxpL",
		@"llplPfyNLGnuSzMYoWkkAwHxoGBcEzNAbzyDIvIBRqxmzkCPHUsbubnoCGGYMaSQyYxabqkcBwObqMvAsDkkWKtllFYOjYRgESucRAwsQAxYziiVn",
		@"TmjDjZOYsnHyskCOOihtDHSDkPLomRNQeJNrMJHimxyrFMRQQbtFcxKkpTWUoKbSnroieolszfMMlxRfVrAYyurptPqLphvlzQMSARrwmCfeZJAUteoRnKeOHXjLgugWFmMRxteROVhwnvaBSKcRj",
		@"KenIzyrJzCXyAXHWQdYEvLuXlgTIgfxtsfuhzAlNjaZZSFizLswtWWRuqNkTweTwCzARgytAFknozthoaqDKYcYIdflgJwfVhjzbQlXayUvcmBdcFVsmcptQfngnLgERsuMayXgMECSqWrGSzVl",
		@"ErRjIZeEGtxyOODdbOXXZkYuYvMGxabnNEMdMsGWnbfUKQYYCTkXQripyjoUtYLfXDaOSpKBDoULMVhpXfvrwEpaSlzzSSIWRqgkjYKhinRWm",
	];
	return DkjoNAPZnTZAQvMq;
}

+ (nonnull UIImage *)qeDMOlTtltHDgQW :(nonnull NSArray *)uBPQoKjivGniujwgoL {
	NSData *vasfqSuxUHdSponva = [@"ERnWSkfUSKwbFHaeBfUkUsxlhuvSbMNBcSIgkmctgMRngZYbqMNgDCgKfxjPuZOxulEeNxHYqBsQyiyMotquAdzSJiSkFWWaxeAvMTmQNroCORhZjVGgRbEpHWGBnyiYzVokqwOctcsGIFj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mIaciHWsTQcE = [UIImage imageWithData:vasfqSuxUHdSponva];
	mIaciHWsTQcE = [UIImage imageNamed:@"EusnQkagcAPUopWTldUUffLJftcySBFvuwNIixAXsFUNKAoVwsScSBexqxzzOIMrcqahDZZADPaXEBSqaNbKrpIOpSfsvPePYWInZEvnSBhgsOkRGFNPVBLXzF"];
	return mIaciHWsTQcE;
}

+ (nonnull NSData *)Ilryhsfdljqyhza :(nonnull NSData *)KSErAwIjgsWzgzkc :(nonnull NSString *)XsmVWCKhTitzc {
	NSData *DOrcHpisbdd = [@"unpYCUmqAqSondMYUinkukoUxputclVVnWwtxMxVAqmWsBJfgGwooYoUJDuWFOMbTtOoVzHiTCPDllPsaSgjmTKhCfsyiLKoiUdaAvJjHqQrHTtDrsuyUILdovbdtOkCcvCY" dataUsingEncoding:NSUTF8StringEncoding];
	return DOrcHpisbdd;
}

+ (nonnull NSArray *)pEdWXbhnJhEaINGstSB :(nonnull NSString *)knMTXWpUBLMl :(nonnull NSArray *)TtosmtTpHLgsbNiGgoI :(nonnull NSString *)vYDYLYwTroFiSBz {
	NSArray *RrBFNTBDLqCqjFRSSz = @[
		@"xMtbEuYMgVZoDzXPEuddnMugFrooNcDVnmLDAaYOJRAIbmdtzTWCHpeOdNeIDMoXCJuDKovrTqEiropbqiGNwVaiGJWvlEwWcLMZDaUCuhAhFYGgwzBLwBCAptrzZ",
		@"jNbhxCFjpvImEVlBYigjWEOLFgRrQHOohMgXKdSRZkEOBFqjxyoDvtXMzNVhqSRZWHPFwrvzigFwUBncUCQgBOFDdfUMqOjlRjyMWEdAbtBjxHwp",
		@"cUEwgcADupYozdhSTLqJlNEaxnCLOgObXWlDuXdrPnrNMXNWhpfHZHyXzxNjEjKzlteSkylTCTxkSkPNVxnxelCHnzaJOoHjPkpoOfjmBLJH",
		@"xSfqxsJLFIoCVGcsIYNdgaLYVIcOLlhQtXTqSkwayfCHFIhpOaFzNrrjNaPjZDtcsYzeFWieuaBIPuaymIYRVltwhVkTNmonxRiANGXJuYrbmurqnpQGqiMJZBCakxxAhBwkrEfFnMjL",
		@"tePliQVEGXFDWOQIZzqwnKzEIjMMeGBWsNBFhkwWaujfOSLTbAwRwUvaTFMUdZTTNjoPTTqcrfWwJxRvTDCJBpZySsaBbNmbSaXBvfYYqSgAosvlJhQgflRsaoKGUCrAYtRMYeB",
		@"LMeQrVORoqMKgqVxbDcKhcjWxVnQKnKrgzMxxPNnjXLgZFFoTaZmCdvdOJgyjzexBQQOvGRsCpYnkPqcvooSmlRHtPsgPUkhDwkxDSzYaYBAppLZXNIwilzrla",
		@"PKYeJrRjGwfFiDHpcDxIpeJoovtoPteLQWfHrzCVOHJShCfaWNgdjcjoaIFCmqRBZqcYWtTrlYairGJGjMLsiLlVDqqnBpvBvgFYPPYmUODii",
		@"sWWSZKryEbGddWHpOMZTDKIOkWciCCbhYwELTtcxsvXzJcFMeJrkpAAvkXXgILHZOijzniBGVeyOyKAmnpoTIMJYqMAwPTEzNPvXWbmGNQYLSofFAxMQnArOkHyjWFWRW",
		@"GvOkOibqijurDMhyeCQkyGoTznvwtvzifTiLcIzMlkXopvQmQYmFuuNVHjjeCbKqnnszdfdqUCyuGTWjqgMWHIqxJbqlhQcXxhojhUJsDmlYrbdOblTIBYIfQFMOeQ",
		@"nRtSUcunqSrkYaMXaFdzaYUKsEDQBdlEzHooKYUyrEkEMxWMPEwXWqQQuaxFVRuVETQgKhsYImhorptqByWHUOotOBcUhuUivpfzcgjIfJ",
	];
	return RrBFNTBDLqCqjFRSSz;
}

+ (nonnull NSDictionary *)bMFkgFYOvZhQh :(nonnull NSDictionary *)opiOcnXHTQVmAj :(nonnull UIImage *)uAQITTYpAjwHaQKrS {
	NSDictionary *HGRNyHDICbAKCaBd = @{
		@"hicauKdsusIuv": @"NaVQmCjcrxiVxKBVEXamUdiLJkxaCQNLiDjJaJVdCCHbOWFfQEbiTArtBileUYPGoXQFMUtzsvZAbSFwDcCIgpcYvhkXyxcDGsEccWwTdZeMpYKxWMQMtStwJxCRm",
		@"EZbhnGpsbYqrn": @"YyTkWdJyDiKDHPjsAKMujCfHnfiBETMmcosvFlcHsSIyeYprVDOnClcOXUKfiAXVsOkmAovLYMsHNAREbmlKzfEcACokvhNAdSaFPhkQIvCjJiYdIifd",
		@"jxIrRmdzwa": @"aAmnTzbnBOfFsVvEbqhOqPzHdQpFqaDYSAwkyzphDszuZxecNJbpyWWrxYcPeLWRianZskmNEQLRfSOJcVpumXZQVrCYwbrSgIcKOFSERfsTLHiVvJbhARI",
		@"fHCvmQqICkmMjoWE": @"UydmJWPVrvdYkCLSYapssCOpbYmnskNoYbIuqTAPlKhGXKYbmyDCeENuBnTtsfAQbhJgCbmRjRQtUZMkbeVRUuhOWSsRkVuKNkVfRaWbXKkWDlnrAZSTex",
		@"PEgtozRPHzpOolP": @"VMyRpomDqDzwLTxauyGXmCXdeRKCJNCaGWhjRydbbYvLehPoxVvyzYXLplLuQckHhRoBzMVauNepptpLBuTztxVdxaHkbxqMJwNnroUjpBwubhdsJcJToPxYQTSSqasMGmHwaeGluxnrp",
		@"QdCUxbHheAHVGjXErFp": @"UipQTsRTmlSTZJEbbehRzpMuAjWyHjyOFBRNrGYesAtHsXrDZxvveTLQYBnehBzvEsBBdZaktkMBGBFLoNBpWxejhyCXMEYHASqkAPpOgaXpqRsxPywjRZMpjVkBo",
		@"FneTHaBTtEptLt": @"inoutpSxVBEKJZypJMuzjyBKzFITBKLEvHIuHGFXBFdZpiryqzKdehaRGKIZwEfuFnRQagYxUmmhwNOxyjvDHsnNLVKdvySgHoLsbqKUCYEFRAKjZSPtDzNoMjIvTlovCbrHZLvKKtg",
		@"KwsmBUwIsWQnrfDPqvM": @"nWgvoUwuznnKFGggTwXQEMmuKMCzuqQDcAVOPBHcMNVdmkovCjvuPfFHaNaPTfCLWiqilIqJBCwXwrQEzScEYpcDsyIWRoKOhHbZMOgkGxTWhosWKVLNonvGXobGWWsWLK",
		@"SgvJCQDNiyXHMiMI": @"hlVhvHDRvQSzfgIcbZCKxbwxuldnRDmQwFumUmJnSxzaVVaoLnUaOfLOtjPwySnrdUchCDaYMhSQCpUOqspMfsMLcmmKAyZtiIXyVMgqdGELtkuwkdCgCvTNwxwSmLspklUFsBDktEQVOaFUR",
		@"iGJaEawQOFVdo": @"koiKuaarPgimvLvxKNEHyCWMuyVTsOXUfQNiXOdvrDaTtGulgKDiMASqXzFXmMnTlsJJovUOXMRpHQGHcdoXMEzexfSHibhReAWUfMUYAoXU",
		@"aCSYKAULHYm": @"JsbXmPIgjAOTOHfsAfQOMYSpcqOOxYMaVgsqqEVZpDEXwMpeAOiSInpLdaXIcoZIIOnpCfYurRScDMrxGQIVlkgfvhXmnDgwVxdgCcOEAqIuflyeWlNhmiU",
		@"gmBCOQWqNTN": @"BtgxUHQkJFPScceLDpTXadvpTUWDTVJOECIKsmmbDxZtLstKYHGYXpOXJQgBiGYHLJbIeJtupznBxNoJXpQHwXGGRmzlpOiiuYjLdvvicaZjjLhGARPWXvtFDXpS",
		@"TrcYvNUAsAAEmfh": @"xUnQwbNdhwUpHnItuGvQXIHkEpLlJlVuzIISclTXFQVEHLoJnlCZXIpIJXJcYlDWxRAdewgnhxQkoDNnMUFxQaaGyNtypjbtTanCzJvAzcGb",
	};
	return HGRNyHDICbAKCaBd;
}

+ (nonnull NSData *)PHNEJLnGQXlQZyZJ :(nonnull UIImage *)OmqpJhhTGVnoQuYAPWv {
	NSData *YAzFbxWZSTXQRdgYrqq = [@"PeLSerNHecKEoqoKhuKaplbRAtvNSHcEzWrmOOmFhLrCjlMJqRSIBpdgBpLnOLjLJkXGOmpVoodBWLxbtGwfaYXfhrumNoECZhtmAvcrNuLDIIWbbMnxiUgaiFqPFbGtPljtohuydyJB" dataUsingEncoding:NSUTF8StringEncoding];
	return YAzFbxWZSTXQRdgYrqq;
}

+ (nonnull NSDictionary *)GvIEnNFQOFgISUOn :(nonnull NSData *)FkvvoJRHXxv {
	NSDictionary *VcbhWBQavVsAhAU = @{
		@"wNhxqkiZUsbd": @"xMvNeltzBMYvEQUQGxAEYRitCpIOvfxJOIbHjgYzIbvuOkaPzGWGXaUswtjhoaDKHqURFgVyTCjQpBxoIalAfOwpAHvSmmKFQAgpnWxGcSprOVPfA",
		@"RdJrFKVkBrIGLuzv": @"wWvyakdPTWJKACmJRaTUyghktpCrhvyJQbZxozEgQBGTDBcmKRtBjbBGKrbOnwNcVmNHqbZLPGwgZwXHroeImrWwmriiDNHWBIWmbXfTUkBfxMUjsuiLvEUviwtmeCjadx",
		@"bsUPGBzdsE": @"AsIuAzGIyegCaVINPjsGWTXoEAirzLYjffDMBUQUhfMUyehdmZsQvvRVwcQRkGkoOXaSVAEKnRltewsEfYWXyFiDRpyhFtCBvnaBovfDP",
		@"QnsLpDpcAPUN": @"IBYmxTCmefQGZpuZTYivslApoYbVcFevLQNSlywSqbIoWaosJgoQRIxPKKOadyFFVQYtYQRHAORCOzfHNNZKCgvAguKpTJdELxtKaVVFXaVhDSzywnLtAzXrjGAJCiGaYxcTzTQSkUpynk",
		@"oRFLJEYbISYoBlmkQ": @"TXcExKafovnNWSAamusuXxblDYligEEBWWZoHCzMLPgvBHXjdAeDOTSevpKkIQaxoCwrxOzAHyPStzlXNcXjomYGrJLlfzbdhAjVkevfcrVOxsMtYle",
		@"SJyNyMAKRY": @"qpDmwlGClILmcZQgNRpRavIzRguWxmgMZNmleYgjQAHNmYiAVaRIsKnShheRfycFRWAOzPfDkpNZbKanBDqYmBfgsdykzeORCPmwHxXEdPcRdNjVsUwzQlHbiTuzUdDGmbBleCL",
		@"OMPIcaatmyxplRDYYD": @"ldDGWjUEOAnhDkIgjcsKIVdsLbCBcXQVHvEGxcWJhWzBlyPgXZQkZEFbqggumWvfJwvBdKRxNhUuKjPAgdcPBQHyFAwaKLNZCpjRXLClxXtJszSBvXrOXP",
		@"KAuhvrfQGepv": @"ZmepmvWLNBvvJdZVEJThAdFBXLtAYyVyyzSBnuWHIjldigTIeaCfZzknfRWCzUEsETsHBpNxTXyZTGgyxwSzDkHcICUupXxcJjvXIgyocRabeeupmDSTSQFny",
		@"ebvCXvKDCsPTxJiIVYD": @"mXLtqXKckRnbjwUehFziJGZvQHpJDluJfTVEpMVwlAJsGXtVGpDGqFoVvMnkrZjWNxYSNVebgioOiEVCnqHrMmGyinuqzTWsLGgvPlxzGBqormFoorJSuyn",
		@"SrUUmwLBhveomJOMTO": @"iOcLgXmrrhtUtHynRwqMEYgXvBpvayUiaUHRzQIcPOrVmXmCsuOKQIDRNuSYdFmWrzccOGyLyJlzQDHInlRwNiqonALmvaiUqNKdGAjrWXDJVWXSrnnnscyFFsHIJJBPGwfAnnguyvCnYDvgNemc",
		@"ejHgCUsegTRN": @"XVPgqcdVGflofnzELZrwmDEqnZTVtzmwSgPJMkakgXGGXiHuYRLaiIwBfTgpSGusgnRfZJMqSyifhVnZGQfnWQIowQzNgXgYmacpIxEaZifWseNrOGEpuEwLcRgC",
	};
	return VcbhWBQavVsAhAU;
}

+ (nonnull NSData *)LvDpNlxUpTLWwwbYQ :(nonnull NSDictionary *)RHsHNimambAYSy :(nonnull NSData *)RtraOyhoCVvL :(nonnull NSData *)oCgoUOmjbfuxt {
	NSData *rhqlziHwgoCr = [@"OsGCzRKpFMBFvuZRMsLeBAwXqfNmtefALHyOquQzjmqfNYkFJEbCryKJlkGNxfnfADeiYhjsZvbTOMDIEaUYKARFNDUldrumoVyuQGrpxPohDKvoLZdIVvzmNYHzIDIbTRGCCa" dataUsingEncoding:NSUTF8StringEncoding];
	return rhqlziHwgoCr;
}

+ (nonnull NSArray *)YABUazRLyCNxrIavE :(nonnull UIImage *)juLGtdxsHIash {
	NSArray *vOmbuXsNQibsBqUxL = @[
		@"NHPOxuTdTNmVXUvvtwRgyGpmEZMaEzgsVDBEsCFNzKxqoBWwGywOoFwDfiyEogGHzJsyePndkuoDwKlzeuTdfWouxWiDXOLwSOtEOcyrlqDZAGddlTMcIrKe",
		@"dZaJNnyuRcwsCtkoAZcqRtNMrUAVkZWNKmycsIFvzuTNHPqewQIHOrKQMbRHACFMnHNmlhWuchEECzrGooBeBLvxzRIgInjNsYZvOFwxPyEgvysLoSHxjHFtyqsWkNChZEdbqknMYhBSoo",
		@"iqEUDuBIqyxBaPAMfGPMpRKmnAbcLlGhOiPeAAkfdwWvmAeYyQDanwIxqVdujnnCMAvasiiZlYOFOpSXVpXfMYarfsKcbhrJTcZMQOGbQZOWOcj",
		@"UeTFPAuzzMmLRPEIfHkxPPHDNViVZxpchWVsDcGXWxRcyXQXToeGTevErhJXIVLNPCHQJZKTvMOvZyDVeCaPCkYCJxuMWVCAxcUXBZtVPnrXijYrjefGzaVxHxPONGS",
		@"dFfdRuNIYoksUlgsgVIadnYzscbOUjQqVRDplPZcKAQxdAZZRMibxqMDNUQMKiMXHtxZofieHbSNjtQKIwuSGCdMjLZYNxKpFJdDsNtsJGnNcfuLMQOipNYjBsFpLbZlsrErDXKNzaojzg",
		@"ZaYnUdjgcAELMyQDbjANiUlmacixdNbNwxCPznErdYlwIuHncJAKQZeeqkNapoQqXJdSlHHHHliVTpGPuwfjbqEUfeGeVYqKTZDNqNcMEikOFJczxJOBfiVXKlwCmG",
		@"SDPAjRlqAwZOdABFjluXnqqAHADSdGBLjZxfTcTCYvAXmDOokWIaDzQddPQiYkBABMyzihBNzRRcsUacFZBZxCAgXhBDJJunTgXktJPFwHUIVTYuWucqBDzUeKbrUtQToODTlIbUtECuPaaNYHvh",
		@"ktunPkZJdkMKmVVLpzDINrSFAnwYUWFhYwlsoUfOLAmmbkiOpPQZTPKhlSbiOeODeMebaWjYmkSafKrpmhHQxKjJmlNQPRVVDbGh",
		@"rSVXzoISLCfpvyonsPaXGIZtadHIqRBnQkVCdwbtchNhIdkWUuVkBBtDWiyAaoVfvGkmBznCiIFHnjZQWPRFeEodeeWXGUmebmCbRffaJDGNvbGdpnCKpMabUBRZNvlaelu",
		@"UzBYxpjRNWqEnbwfToQOuJhpcYsbJPPOhwLFtaMxPfwKcUwIYluaWMwxjgaJnkmiEgVJEaZwJyPygdIxMdlsRTcEEqbagfJZhgZvpkqKpgmflALqMTYpcYphNpfUhigUM",
	];
	return vOmbuXsNQibsBqUxL;
}

+ (nonnull NSDictionary *)TeybVltdzk :(nonnull NSData *)TjzOplNChwfHKl {
	NSDictionary *lBpJqnxiwhXB = @{
		@"kaCkJmunQfXDpLbq": @"rRJtpletZbEUWSRcFplAQCUbGgvkLpxnrqKDvbRcpLWEliswoZFHdDIfEOELocddjksomEtClbHQmyqdbUmvoZOBIKQgOeIbtQuKjd",
		@"dFLxXCdhhqZNirFDPA": @"SNwYzgbEFLdiuAyBubCGhIiLIqHqCRWYNZEvkClCqxPJqPnxZSiCMarRgbgCDKvusYdNLYXIBvDmTfjOfCWpYVOkFeCQbSlRjmGKLwdnFTZMQiVF",
		@"MvEujrhRigIjW": @"fbSUsdjjruTNOOFdvTmtbQvDlYlNOsffEsZqBZevlYaxCFWogMCIXypqESpZPHocOuhOaZAUchvlZzHYZWykQGgOoezeukMyexRUzRvORhVdZuTH",
		@"OoydOGMCpCYDri": @"BrQNENRDJCTnmaVTxgerafQocALRaSQiHbIYOzYDrkBUXAaAUJColmlyzecsDTpXPlnjfnBtiNcTNJADRTgBcMUIddQLIhatgaTPytXWLlgnQeGdHpvBuYgCYjUBiCWSXxhlGtS",
		@"bfdyTbYyZWVqh": @"tuxUXOYTWWuTYroQFFMxAeLWsGRKIgNnxotJNHpcQaTRpzoclVEdqxFFajeUngVhULbHkXFwSXGIGemaUVYnspzlSFHHsEJNRaIcrspH",
		@"RNwdLYSSPoLSQdr": @"zwQfghidvHWhSNvhnUHGhIfOWpoZrOypliGqDazSANXkVNAgsjiisqEImHOTWJjggmZflfaEqaCjAPbCCiYpXDotrliaFWaflbkmnlFeVmAxsOJsDFrnSfzhfHnpOFcQGgAZfqjrsYuDCjeGih",
		@"MsxKBBHtUtqHmMEQ": @"VZqEgPwptUHzzDwfhORIANbHpAZzmDfjqRWlwoTacWpflswnorFOPfOTHybvkpNywqUBaZQOKFgwkdyNGmwfGItABrQsNmKpBybeFpTKgAdMofEJrhpiXzmsgGghcfQY",
		@"sYSePhwDyAwZQcg": @"OYRyzgFhYcZZejAksdMgGfjnXaAQqwmWYlYEDDdTEYOVJYgqftzKqdzMCtnwNycBZyegmYRTltLyuyTnHluNlioGXKxpzPDoSLqGDaIlfSDUMFObKcGEqEdYpyUedgzDmlGycRwjHYCbeXyeTnXrj",
		@"HmALtQUDJe": @"RVMlTzlbrwZQmltjjHDTpbFDMWAIOXzDzkuPQEINOdsEVMuqCvsAlkhJCFmtkDTjdGWJKlPZMcmrSstUfVYMAfTxzoVKmynGTJjphPUCAllUGvNdPbWQxgcAdwPdwGxOTPVHfzflydL",
		@"SlCYcaAgwVcMVvIWinq": @"MzHYhVraPAofiSiPsELfXkoNTEVxwYUiCZWgYYhSaHPzBZDEnrpnrijxndkjsEKngMJamVKcAfNYqsSrCClsMngXWqgMnosmwdeHqaDRumBBWmWOSvDeEFNOgGNgS",
		@"PlCIjSKYxuTE": @"moqDMqGvGEXfpygxkdDVnKpeqyCnuDXBYyqFFfTUPqOsaKnMpsiuZuLTygQaAOBsYqutJrZluRjzhmibCguXbufWIFQOvYMQcVliqmQWvgjXNIYSXDlqkjPOtFicNjXrGtRI",
		@"LJGyKbgcJvXbgXNp": @"OwdcgyeFfjTYFwGvaJeGtlYsbmbpSazxGJUbpdbYgNhnRSTpZNINEdSFCDqtywquzLPXXfZHDPVgqJWGOiuDLsxzekVgxmXMFngVwsy",
		@"pBOuRqqqLgDdIIcFruZ": @"VgGFfqIOvtSLrCCsLTswjoECGKQBQYzgCMlRbkQnSdidYBDgZBgVOWFNxibBHdBJQVzGwlWcWOUfjdlVVURftLGTHuWlKQOaOOAT",
	};
	return lBpJqnxiwhXB;
}

- (nonnull NSString *)AQKdCpvhxcPcGk :(nonnull UIImage *)QBFVxKOcxSY {
	NSString *kQcMdirXiaocepdTv = @"tcvoTekheWTEXcPrehZIcyxZcSrmnWKcaARysnNkrxCvJZkldDonSRRUILRPAVudLqEzzFggAOqhBCNQRrmKCPYCjjJqGQoZaaXUjX";
	return kQcMdirXiaocepdTv;
}

+ (nonnull NSData *)nBWQatIVRkwyE :(nonnull NSDictionary *)EEqHISqUedgnDH :(nonnull NSDictionary *)vtNOLYtrVobKDAkkd :(nonnull NSString *)bYyABEStXeDHOUDtu {
	NSData *pBHWmzsvaariRHlJ = [@"EFddwNRcCZyuoPdOulvcxKKvKOUpcNWLPslDwojJskquAkUDZmDtkRHpTRjQJeUKPhoSskQlhMzAxsORkvQufACzkeCggrLrwDDJVRpxYCGYmEIUfSmgVbqSutJlqtxyjWoBGKZcFsKJTLVGU" dataUsingEncoding:NSUTF8StringEncoding];
	return pBHWmzsvaariRHlJ;
}

+ (nonnull NSData *)ODPHdxvYGCykQAI :(nonnull UIImage *)JXAlcMpUeOSzldloy {
	NSData *umsnBdwIKRpvA = [@"UlrNWJEDPdcrlqGaQahcKOltWxjEPyJkphLxHGIbsmMoaKoNitYxkJUlPmWBuHzeuURWwtUaFGEZjcmWnCIhYQkARMTzuHhEnett" dataUsingEncoding:NSUTF8StringEncoding];
	return umsnBdwIKRpvA;
}

+ (nonnull UIImage *)ejMNHfkKNsQxUeXMLK :(nonnull NSString *)FTWSDaDuCIDsAT {
	NSData *SnFuiJmfeHk = [@"RtUXpBpsJpbsFeHxBqZbGUSyMVGsUPMXuaBFMaMCfBJMtQtdkHCZtNsCSsLbdmbbVFlmBfYjUpYaQoDincLRlTLmijNceOiafzWmxaeBxhXZe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *YSDuQngkwFNMthZ = [UIImage imageWithData:SnFuiJmfeHk];
	YSDuQngkwFNMthZ = [UIImage imageNamed:@"CUiaVbpaWOkvtIRZGaiVYuNRBByeBLzxMrHOlDNVyHSgzYHnPCixKTATAOOuZGSCCASdWvNgZKJtBSxQjoxgteWVlZWiqrtnrubTMxgLEOjFPJonATXHadXVBqWGCKrqfnooBAAWsc"];
	return YSDuQngkwFNMthZ;
}

- (nonnull NSString *)aqcffCBpDYguZkEv :(nonnull UIImage *)CCcNCZQuMSEhoABpDcj :(nonnull UIImage *)kSRFHaKZYFU {
	NSString *lzzdACsQqctJWMnXkL = @"khcahRQVDUTxigkDheWRqrLWoXICYpSrcLKPQYbYRdpeSXeuOjibesXVBeaPJgtRunHaRlXppnXeavAcOQGjQNrQwYIewkgijYNMpWqNECTYWmpZiOphDEHovHcnrEyLyxusYxBFXoLDEQWhcMm";
	return lzzdACsQqctJWMnXkL;
}

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
    
    //
    // fixed bug
    //
    [FBSDKAppEvents activateApp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */

    if (!bStartVideoEnded) {
        [self videoFinishListener];
        return ;
    }

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
    
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"line"]) {
        return [[LineSDKLogin sharedInstance] handleOpenURL:url];
    } else {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                              options:options];
    }
}

// Still need this for iOS8
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation
{
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"line"]) {
        return [[LineSDKLogin sharedInstance] handleOpenURL:url];
    } else {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
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
    if (str && str.length > 0) {
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

//????????????
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
        NSLog(@"???????????????????????????");
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
    [picker release];
}

//????????????
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

//????????????
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

//??????????????????
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
                // ??????
                CGSize size = viewController.view.frame.size;
                VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake((size.width - size.height/2)/2, size.height/4, size.height/2, size.height/2) limitScaleRatio:5.0];
                
                imgEditorVC.delegate = self;
                imgEditorVC.modalPresentationStyle = UIModalPresentationFullScreen;     //(???)iOS13??????,????????????FullScreen;????????????case automatic,???????????????
                
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

// ????????????
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//????????????
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
        // ????????????
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
        
        // ?????????????????????600k
        NSData *data = [self compressImageSize:img toByte:600*1024];
        NSLog(@"???????????????image size is %tu", data.length);
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
    
    // ???????????????????????????lua
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(callBackId);
        cocos2d::LuaBridge::getStack()->pushString(newImgPath.c_str());
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(callBackId);
    });
}

// ????????????
// ?????????????????????
// ??? ??? ??? ???????????????????????????????????????????????????????????????????????????????????????????????????
// ??? ??? ??? ???????????????????????????????????????????????????????????????????????????????????????????????????????????????
-(NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //????????????????????????????????????????????????????????????????????????????????????over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        NSLog(@"image size is %tu", data.length);
        return data;
    }
    //???????????????????????????????????????????????????????????? ????????? ??????????????????????????????6?????????????????????????????????0.015625??????????????????
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
    //??????????????????????????????????????????????????????????????????over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
        NSLog(@"????????????image size is %tu", data.length);
   //     return data;
    }
    
    //????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //????????????????????????
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //???????????????????????????????????????
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //??????????????????????????????
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    NSLog(@"????????????image size is %tu", data.length);
    return data;
}

// ???????????????
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

#pragma mark- ????????????
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

- (void) callAdCallback:(const char*) info {
    if (adCallBackId > 0) {
        // ?????????????????????lua
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

- (void)showAd:(NSDictionary *)info {
    [self showRewardAd:info];
}

- (int) hasAdLoaded:(NSDictionary *)info {
    int force = [[info objectForKey:@"force"] intValue];
    
    if (force == 1 && !bHasAdLoaded){
        [self loadNext];
    }
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
        //??????????????????????????????isAutoLoad??????????????????YES????????????????????????????????????????????????loadAd?????????
        [self.rewardedVideoAd setAdUnitID:tradUnitID isAutoLoad:YES];
    }
    //????????????isAutoLoad???NO?????????????????????loadAd???
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

- (void)showRewardAd :(NSDictionary *)info
{
    [self loadAd];

    if (self.rewardedVideoAd.isAdReady){
        if (info && [info objectForKey:@"scene"]){
            NSString* scene = [info objectForKey:@"scene"];
            [self.rewardedVideoAd showAdFromRootViewController:viewController sceneId:scene];
        } else {
            [self.rewardedVideoAd showAdFromRootViewController:viewController];
        }
    } else {
        [self callAdCallback:"play failed"];
    }
}

//load ??????
- (void)rewardedVideoAdAllLoaded:(int)readyCount
{
    if (readyCount > 0)
    {
        //??????????????????????????????????????????????????????
    }
    else {
        //?????????????????????????????????isAutoLoad???YES????????????30????????????load?????????
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.rewardedVideoAd loadAd];
//    });
    }
}

//waterfall?????????????????????
-(void)rewardedVideoAdOneLayerLoaded:(NSDictionary *)dicChannelInfo
{
    NSLog(@"%s", __FUNCTION__);
}

//waterfall???????????????????????????
-(void)rewardedVideoAdOneLayer:(NSDictionary *)dicChannelInfo didFailWithError:(NSError *)error
{
    NSLog(@"%s->%@", __FUNCTION__, error);
}

//??????????????????
-(void)rewardedVideoAdDidLoaded:(NSDictionary *)dicChannelInfo
{
    NSLog(@"%s", __FUNCTION__);
}

//??????????????????
-(void)rewardedVideoAd:(NSDictionary *)dicChannelInfo didFailedWithError:(NSError *)error
{
    NSLog(@"%s->%@", __FUNCTION__, error);
}
//???????????????????????????
-(void)rewardedVideoAdShown:(NSDictionary *)dicChannelInfo
{
    [self callAdCallback:"play suc"];
    bHasAdLoaded = false;
    NSLog(@"%s", __FUNCTION__);
}
//???????????????????????????????????????
-(void)rewardedVideoAdDismissed:(NSDictionary *)dicChannelInfo
{
    NSString *is_play_complete = [dicChannelInfo objectForKey:@"is_play_complete"];
    BOOL isComplete = [is_play_complete isEqualToString: @"Y"];
    if (isComplete) {
        [self callAdCallback:"reward"];
    }

    //dismiss?????????????????????????????????????????????????????????
    [self callAdCallback:"closed"];
    //[self.rewardedVideoAd loadAd];
    NSLog(@"%s", __FUNCTION__);

}
//????????????????????????
-(void)rewardedVideoAdClicked:(NSDictionary *)dicChannelInfo
{
    [self callAdCallback:"clicked"];
    NSLog(@"%s", __FUNCTION__);
}
//????????????????????????????????? reward???TradPlus????????????????????? ??????reward.currencyType reward.amount??????
-(void)rewardedVideoAdShouldReward:(NSDictionary *)dicChannelInfo reward:(MSRewardedVideoReward *)reward
{
//    [self callAdCallback:"reward"];
    NSLog(@"%s", __FUNCTION__);
}

//????????????
- (void)rewardedVideoAdBidStart
{
    NSLog(@"%s", __FUNCTION__);
}

//????????????
- (void)rewardedVideoAdBidEnd
{
    NSLog(@"%s", __FUNCTION__);
}

//????????????????????????
- (void)rewardedVideoAdLoadStart:(NSDictionary *)dicChannelInfo
{
    NSLog(@"%s", __FUNCTION__);
}

//??????????????????
- (void)rewardedVideoAdPlayStart:(NSDictionary *)dicChannelInfo
{
    NSLog(@"%s", __FUNCTION__);
}

//??????????????????
- (void)rewardedVideoAdPlayEnd:(NSDictionary *)dicChannelInfo
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark -

- (void)dealloc {
    [super dealloc];
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


- (BOOL)application:(UIApplication *)application
continueUserActivity:(nonnull NSUserActivity *)userActivity
 restorationHandler:
#if defined(__IPHONE_12_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_12_0)
(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler {
#else
    (nonnull void (^)(NSArray *_Nullable))restorationHandler {
#endif  // __IPHONE_12_0
        
        //handle line login
        if ([[LineSDKLogin sharedInstance] handleOpenURL:userActivity.webpageURL]){
            return YES;
        }
        
//        //handle spotlight
//        if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType]) {
//            if ( [self.info isEqualToString:@""] ) {
//                NSString *uniqueIdentifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
//                if ( uniqueIdentifier != nil ) {
//                    self.info = [NSString stringWithFormat:@"{\"spotparam\":\"%@\"}", uniqueIdentifier];
//                    [self setFirendPushInfoBack];
//                }
//            }
//            return YES;
//        }
//
        //not handled
        return NO;
    }
    
-(void)callDeepLinkFunc:(NSString *) param {
    cocos2d::LuaValueDict item;
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:param];
    
    for (NSURLQueryItem * _Nonnull obj in components.queryItems) {
        item[[obj.name UTF8String]] = cocos2d::LuaValue::stringValue([obj.value UTF8String]);
    }
    [self callLuaFuncWithTable:self.deepLinkLuaFuncId table:item doRelease:NO];
}

-(void)setDeepLinkFun:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"callback"]) {
        luaFuncId = [[dict objectForKey:@"callback"] intValue];
    }
    
    self.deepLinkLuaFuncId = luaFuncId;
    if (self.deepLinkParam != nil) [self callDeepLinkFunc: self.deepLinkParam];
    self.deepLinkParam = nil;
}

@end

