/****************************************************************************
 Copyright (c) 2010-2011 cocos2d-x.org
 Copyright (c) 2010      Ricardo Quesada
 
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

#import "RootViewController.h"
#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#include "ide-support/SimpleConfigParser.h"
#include "jsonccc.h"
#import "CCLuaBridge.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import <UIKit/UIKit.h>

#endif

#define FB_USER_INFO                @"facebookUserInfo"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation RootViewController

@synthesize apiClient;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        
        self.sendSMSLuaFuncId = -1;
        self.shareLuaFuncId = -1;
        self.inviteLuaFuncId = -1;
        self.lineLoginLuaFuncId = -1;
        self.appleLoginLuaFuncId = -1;

        // init the ios device orientation
        cocos2d::Director::getInstance()->setDeviceLandscape([UIDevice currentDevice].orientation);
    }
    [LineSDKLogin sharedInstance].delegate = self;
    apiClient = [[LineSDKAPI alloc] initWithConfiguration:[LineSDKConfiguration defaultConfig]];
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationIsLandscape( interfaceOrientation );
    }else{
        return UIInterfaceOrientationIsPortrait( interfaceOrientation );
    }
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskPortraitUpsideDown;
    }
#endif
}

- (BOOL) shouldAutorotate {
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    // init the ios device orientation
    cocos2d::Director::getInstance()->dispatcherScreenOrientation([UIDevice currentDevice].orientation);
    
    cocos2d::GLView *glview = cocos2d::Director::getInstance()->getOpenGLView();

    if (glview)
    {
        CCEAGLView *eaglview = (CCEAGLView*) glview->getEAGLView();

        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL)isUserDictValid:(NSDictionary *)userDict
{
    NSString *accessToken = [userDict objectForKey:@"access_token"];
    NSString *openId = [userDict objectForKey:@"id"];
    NSDate *expirationDate =  [userDict objectForKey:@"expirationDate"];
    
    NSLog (@"Stored accessToken => %@\nopenId => %@\nexpirationDate =>%@",accessToken,openId,expirationDate);
    
    return (accessToken != nil && openId != nil && expirationDate != nil
            && NSOrderedDescending == [expirationDate compare:[NSDate date]]);
}

/* 
 * local notification
 */


/* 
 * sendSMS 
 */
#pragma mark - 代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.view endEditing:YES];

    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSString * msg = @"";
    
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            msg = @"success";
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            msg = @"failed";
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            msg  = @"canceled";
            break;
        default:
            // unknown
            msg = @"unknown";
            break;
    }
    
    int luafuncId = self.sendSMSLuaFuncId;
    
    if (luafuncId > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cocos2d::LuaBridge::pushLuaFunctionById(luafuncId);
            cocos2d::LuaBridge::getStack()->pushString([msg UTF8String]);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(luafuncId);
        });
    }
    
    /*
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
     */
}

#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body callback:(int)callback
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        self.sendSMSLuaFuncId = callback;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"So Bad,Send SMS Failed!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && self.alertBox_OKfuncId > 0) {
        // clicked
        cocos2d::LuaBridge::pushLuaFunctionById(self.alertBox_OKfuncId);
//        cocos2d::LuaBridge::getStack()->pushString(@"succeed");
        cocos2d::LuaBridge::getStack()->executeFunction(0);
        cocos2d::LuaBridge::releaseLuaFunctionById(self.alertBox_OKfuncId);
    }
//    NSLog(@"buttonIndex = %ld",buttonIndex);
}

-(void)alertBox:(NSString *)msg okcb:(int)okcb cancelcb:(int)cancelcb {
    
    self.alertBox_OKfuncId = okcb;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark -- <Line relative and LineSDKLoginDelegate>

-(void)lineLogin: (NSDictionary *)dict{
    
    int luaFuncId = -1;
    
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"Line login with No luaListener found !");
    }
    self.lineLoginLuaFuncId = luaFuncId;
    
    NSURL *nsurl = [NSURL URLWithString: @"line://msg/text/0"];
    if ([[UIApplication sharedApplication] canOpenURL: nsurl])//app login
        [[LineSDKLogin sharedInstance] startLoginWithPermissions:@[@"profile", @"openid"]];
    else//web login
        [[LineSDKLogin sharedInstance] startWebLoginWithPermissions:@[@"profile", @"openid"]];
}

-(void)lineLogout: (NSDictionary *)dict{
    
    [apiClient logoutWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"Logout success.");
        }else {
            NSLog(@"Logout error. info: %@", error.description);
        }
    }];
    /*
     [apiClient logoutWithCallbackQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
     completion:^(BOOL success, NSError * _Nullable error) {
     if (success) {
     NSLog(@"Logout success.");
     }else {
     NSLog(@"Logout error. info: %@", error.description);
     }
     }];
     */
}

//
// Apple登录相关
#pragma mark sign in with apple

-(void)appleLogin:(NSDictionary *)dict{

    int luaFuncId = -1;

    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }

    if (luaFuncId == -1) {
        NSLog(@"No luaListener found !");
        return;
    }
    self.appleLoginLuaFuncId = luaFuncId;
    
    [self signInWithAppleNative];
}

// Once the request apple login
-(void)appleLoginCallBack:(int)result uid:(NSString*)userIdOrErrCode authorizeCode:(NSString *)code token:(NSString *)tokenStr name:(NSString*)name
{
    int luafuncId = self.appleLoginLuaFuncId;
    
    LuaBridge::pushLuaFunctionById(luafuncId);
    LuaValueDict item;
    
    item["result"] = LuaValue::intValue(result);
    item["uid"] = LuaValue::stringValue([userIdOrErrCode UTF8String]);
    item["code"] = LuaValue::stringValue([code UTF8String]);
    item["token"] = LuaValue::stringValue([tokenStr UTF8String]);
    item["name"] = LuaValue::stringValue([name UTF8String]);
    LuaBridge::getStack()->pushLuaValueDict(item);
    
    LuaBridge::getStack()->executeFunction(1);
    
//    LuaBridge::releaseLuaFunctionById(luafuncId);
}

-(void)signInWithAppleNative API_AVAILABLE(ios(13.0)){
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *authAppleIDRequest = [provider createRequest];
    // 在用户授权期间请求的联系信息
    authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];

    //     ASAuthorizationPasswordRequest *passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];

    NSMutableArray <ASAuthorizationRequest *>* array = [NSMutableArray arrayWithCapacity:2];
    if (authAppleIDRequest) {
        [array addObject:authAppleIDRequest];
    }
    //    if (passwordRequest) {
    //        [array addObject:passwordRequest];
    //    }
    NSArray <ASAuthorizationRequest *>* requests = [array copy];

    // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
    authorizationController.delegate = self;
    // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
    authorizationController.presentationContextProvider = self;

    // 在控制器初始化期间启动授权流
    [authorizationController performRequests];
}

// 成功的回调F
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    // the credential is an Apple ID
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        // 获取信息并将信息保存在 钥匙串中
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString * nickname = credential.fullName.givenName;
        NSString * userID = credential.user; // 同一个开发者账号下的app 返回的值一样的
        NSString * email = credential.email;
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];

        // 将ID保存到钥匙串--示例
        if (userID) {
            [self setKeychainValue:[userID dataUsingEncoding:NSUTF8StringEncoding] key:@"appleUserID"];
        }
        // NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", nickname);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        // NSLog(@"realUserStatus: %@", @(realUserStatus));
        // 示例-将信息回调到服务器端进行验证
        [self appleLoginCallBack:0 uid:userID authorizeCode:authorizationCode token:identityToken name:nickname];

    // If the credential is a password credential, the system displays an alert allowing the user to authenticate with the existing account.
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *userIdentifier = passwordCredential.user;
        NSString *password = passwordCredential.password;
        
        // 可以直接登录
         NSLog(@"userIdentifier: %@", userIdentifier);
         NSLog(@"password: %@", password);
        [self appleLoginCallBack:0 uid:userIdentifier authorizeCode:@"" token:nil name:nil];
    }
}

// 失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)){
    
    NSString * errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"Authorization is cancled.";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"Authorize failed.";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"Authoraized response invalid.";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"Authorization can not handle.";
            break;
        case ASAuthorizationErrorUnknown:
        default:
             errorMsg = @"Unknown reason failed for authorization.";
            break;
    }
    NSLog(@"Authorization error: %@", errorMsg);
    [self appleLoginCallBack:1 uid:errorMsg authorizeCode:@"" token:nil name:nil];
}

-(void)checkAuthoriza API_AVAILABLE(ios(13.0)){
    // 从钥匙串中取出用户ID
    NSData* appleUserId = [self valueKeyChain:@"appleUserID"];
    if (appleUserId) {
        NSString *appleIdentifyId = [[NSString alloc] initWithData:appleUserId encoding:NSUTF8StringEncoding];
        ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
        
        [provider getCredentialStateForUserID:appleIdentifyId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    NSLog(@"has authorized");
                    break;
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    NSLog(@"revoked,please sign out apple login");
                    // 删除钥匙串保存的信息
                    [self removeObjectKeyChainForKey:@"appleUserID"];
                    // 登出Apple登录，等待下次重新登录
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    NSLog(@"not found....");
                    [self removeObjectKeyChainForKey:@"appleUserID"];
                default:
                    break;
            }
        }];
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
//告诉代理应该在哪个window 展示授权界面给用户
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    
    return self.view.window;
}
// 注册通知
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}

- (void)setKeychainValue:(NSData *)value key:(NSString *)key
{
    
}

- (void)removeObjectKeyChainForKey:(NSString *)key
{
    
}

- (NSData *)valueKeyChain:(NSString *)key
{
    return nil;
}

// Apple登录 End
//

- (void)didLogin:(LineSDKLogin *)login
      credential:(LineSDKCredential *)credential
         profile:(LineSDKProfile *)profile
           error:(NSError *)error
{
    LuaValueDict info;
    if (error) {
        NSLog(@"LINE Login Failed with Error: %@", error.description);
        info["result"] = LuaValue::intValue(2);
        info["error"] = LuaValue::stringValue([error.description UTF8String]);
        [self lineLoginCallBack:info];
        return;
    }
    
    NSLog(@"LINE Login Succeeded");
    
    info["result"] = LuaValue::intValue(0);
    info["uid"] = LuaValue::stringValue([profile.userID UTF8String]);
    info["mnick"] = LuaValue::stringValue([profile.displayName UTF8String]);
    info["token"] = LuaValue::stringValue([credential.accessToken.accessToken UTF8String]);
    
    if(profile.pictureURL != nil) {
        info["head_url"] = LuaValue::stringValue([[profile.pictureURL absoluteString] UTF8String]);
    }
    
    if(profile.statusMessage != nil) {
        info["status_msg"] = LuaValue::stringValue([profile.statusMessage UTF8String]);
    }
    
    [self lineLoginCallBack:info];
}

-(void)lineLoginCallBack:(LuaValueDict)info {
    if (self.lineLoginLuaFuncId <= 0) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        LuaBridge::pushLuaFunctionById(self.lineLoginLuaFuncId);
        LuaBridge::getStack()->pushLuaValueDict(info);
        LuaBridge::getStack()->executeFunction(1);
        LuaBridge::releaseLuaFunctionById(self.lineLoginLuaFuncId);
    });
}


-(void)facebookLogin:(NSDictionary *)dict{
    
    int luaFuncId = -1;
    
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"No luaListener found !");
        return;
    }
    
    // check if already logged in
    if ([FBSDKAccessToken currentAccessToken]) {
        
        // already logged in
        NSLog(@"Already Authed !!! ");
        
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_INFO];
        if ((userDict)&&([self isUserDictValid:userDict])) {
            
            // happy , all validate
            [self facebookLoginCallBack:luaFuncId loginRst:0 uid:[userDict objectForKey:@"id"] token:[userDict objectForKey:@"access_token"]];
            return;
        
        }
        
        // fall down code here
        // token is not null , but it is invalidate
        // reload it anyway
        
    }
        
    // new fresh
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithPermissions:@[@"public_profile"]
        fromViewController:self
        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            // login ended callback
            if (error) {
                
                NSLog(@"Process error");
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [self facebookLoginCallBack:luaFuncId loginRst:2 uid:@"" token:@""];
                
            } else if (result.isCancelled) {
            
                NSLog(@"Cancelled");
                [self facebookLoginCallBack:luaFuncId loginRst:1 uid:@"" token:@""];
            
            } else {
                
                // we already have the access token
                // in fact , we don't need check the validation of the access token any more
                // goes into the game directly
                //
                NSLog(@"Logged in ==> :%@", result);
                
                if (result && result.token) {
                    FBSDKAccessToken *info = result.token;
                    [self facebookLoginCallBack:luaFuncId loginRst:0 uid:info.userID token:info.tokenString];
                } else {
                    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_INFO];
                    if ((userDict)&&([self isUserDictValid:userDict])) {
                        [self facebookLoginCallBack:luaFuncId loginRst:0 uid:[userDict objectForKey:@"id"] token:[userDict objectForKey:@"access_token"]];
                    }
                }
            }
        }];
}

// Once the request facebook login, show the login dialog
-(void)facebookLoginCallBack:(int)luafuncId loginRst:(int)result uid:(NSString*)userId token:(NSString*)tokenStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        LuaBridge::pushLuaFunctionById(luafuncId);
        LuaValueDict item;
        
        item["result"] = LuaValue::intValue(result);
        item["uid"] = LuaValue::stringValue([userId UTF8String]);
        item["token"] = LuaValue::stringValue([tokenStr UTF8String]);
        LuaBridge::getStack()->pushLuaValueDict(item);
        
        LuaBridge::getStack()->executeFunction(1);
        
        LuaBridge::releaseLuaFunctionById(luafuncId);
    });
}

#pragma mark - FBSDKGameRequestDialogDelegate callback(s)

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog (@"GameRequest,completed = %@" , results);
    [self gameInviteRequestCallback:self.inviteLuaFuncId retStr:@"success"];
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error
{
    NSLog (@"GameRequest,error = %@" , error);
    [self gameInviteRequestCallback:self.inviteLuaFuncId retStr:@"error"];
}

- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog
{
    NSLog (@"GameRequest,cancelled .");
    [self gameInviteRequestCallback:self.inviteLuaFuncId retStr:@"cancel"];
}

-(void)facebookRequestFriend{

    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    gameRequestContent.filters = FBSDKGameRequestFilterAppNonUsers;
    
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:self];
}

-(void)facebookInvitFriendWithIds:(NSDictionary *)dict{
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"No InviteFriendListener found!");
        return;
    }
    
    self.inviteLuaFuncId = luaFuncId;
    
    //NSDictionary
    NSString *idstr         = [dict objectForKey:@"friendId"];
    NSArray *arrFriendIds   = [idstr componentsSeparatedByString:@","];
    //NSLog (@"arrFriendIds = %@",arrFriendIds);
    
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    gameRequestContent.message = [dict objectForKey:@"invitMsg"];
    gameRequestContent.recipients = arrFriendIds;
    gameRequestContent.title = [dict objectForKey:@"invitTitle"];
    
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:self];
    
}

//
// get myfriendlist use Graphic API
//
-(void)facebookFriendIdReq:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId < 0) {
        NSLog(@"No ReqListener found!");
        return;
    }
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            
            NSLog(@"result = %@", result);
            NSDictionary *responseDict = result;
            
            NSArray *friendInfo = [responseDict objectForKey:@"data"];
            NSString* friendIdStr = nil;
            NSInteger friendCount = [friendInfo count];
            if (friendCount > 0) {
                for (int i = 0; i < friendCount; ++i) {
                    NSDictionary* curFriendInfo = friendInfo[i];
                    NSString* friendId = [curFriendInfo objectForKey:@"id"];
                    
                    if(friendIdStr == nil)
                        friendIdStr = friendId;
                    else
                        friendIdStr = [NSString stringWithFormat:@"%@|%@", friendIdStr, friendId ];
                }
            }
            if(friendIdStr != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
                    cocos2d::LuaBridge::getStack()->pushString([friendIdStr UTF8String]);
                    cocos2d::LuaBridge::getStack()->executeFunction(1);
                    cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
                });
            }
        } else {
            
            // it sucks
            NSLog(@"facebookFriendIdReq API error: %@",error);
        }
    }];
    
}


// get the invitable friedns which have not get into
// out games use Graphic API
//
- (nonnull NSDictionary *)phqPqippCzyOZsj :(nonnull NSArray *)xVGzmxAbrMwDL {
	NSDictionary *TXGzjuBAWUbaE = @{
		@"ssfAmEthFbRArs": @"gmeDrPWVhHEXRXeZhHhISKaVRQsMuxIfZnTZwakCzXaoocdsAexACguhPueaauAqbmtOuTbGAjXBFhFydKShEYiNtYdcJTYEdRCFUaaImaJWOALNjxKRNLmeHfW",
		@"znfuMYYyMfGumht": @"FHHCFnXxppCyDajZpDVvemfMwJdHvCsNTWhjKARiYKUdNPwIjyFfoXiErUHfZctVHenKAWwAgnZnLrpNtJenHYCSXYlimhwocrbmMlCpdsvKUQnQvVdqBaKdtqlbDkIaHPrnumXsIcTTmKrO",
		@"tfOfHEScJlY": @"BxYJzHUnQGqaEGboXtOZkFWLZvpdmLjwPxZnMyvKYultbXPhpTAISetzkFmskqCuoCmFvSEKlrCLzDNnlUbeRaRTBJdTZtVDlZQtBTvAyhA",
		@"NURCtcWeToPABwl": @"uINlUdJswkblQAWrOzIhsCsDBJdBFdeEJMeuEXEZqqfDzwdNmyFlMjCpXinEaKdEQychTRzTvuExtMmQZuKOarPGubDpKFHuFZtbcMHQuZWydVtNBuzWHYMjDBWswfuqcOh",
		@"FTEYuVsoBy": @"wwcxQLGTUrwotqUjSXerWWhMavojTcRqRqPsMXDRBynpAlUcmnBDlIysTsYaZLjXWnzYpoEJDUtKNujrpfYbPQBYUanoUPrDIexxeCtmGuNVZMjDExxH",
		@"StLzqGzbFW": @"jCwlnBwOpWUAeotMFWvmuPAUclgSqQjaTXSnwdJGWycVLoXoYrisrYnbCxfRedaIlmgtlOkDDWuWJNYTidOSaIuMkcQxyKoOuXqEYtZNUxVcWOBwaQePSPcPXDSfLA",
		@"sFwLhZwydofHUBpS": @"RBMOaTJVxxyiikNIVoFbEBZMEsyWOTNvSAtvnoSLKDYzqgevMnsntxxofAsmCygUaqkAeqjwazsIsevNLavaAWNveUoMDkABZjvH",
		@"OKOOnWnuJp": @"rkZXQFCXaTNjPOFiOppIWpCDnRFWVbVEsVmPYwAketoSqHZrijCwstbsZjoyXoHJtgQqCyMEhmRDxwKLTycVldxqMzKOdZfkjwEvjPSkJRBXPNeGsAtQalsEST",
		@"VMUaWJuapptbdoSZO": @"klZGeSWAVNAlitSsOMcHvfWTdFjvgosNCqPARuuhHcFEDdrXYzVBAdeubFtrEqClFZXiagdMKqiWqANnrWRxhugxMRIegcLvwOcLnaGTgbOfePt",
		@"WwCtiWTxdDUI": @"YqBvSRhvWVOebVWLmiinmftlhZoVxGPikvOELGQPXwWYKHxbeGpbICrDFigdMcFpwICCzIRSgRmUSLkknbFVAINccadYUpQiXDcBuQIcPwtfMUgBpVEMpHPybIPzHsMFnorHmTezxDDSefZFIEDZt",
		@"aDPAVQYxYwtDsUUqpq": @"zfqGhqmlJdSyrSxhVSDIrwmmGOhkDiMolNmyTrcUCngFhEriyCDrrlFDpDOKCYvQYtMhkmjQbbnQMDZFxRFQCHocyVmHynhcMaxVSfxFqWkymUxBDuwmRPRPcvVstbfZhhTKjXItYzxsg",
		@"BJEaHHckXfIc": @"SYvzoXYlkYQXlLCmpPejusHvRVJBeAvrjFDrEcdBDXqOFCfLeqxkpBUZLJAAmQGJEbOVziczbfShGEGsdNRAcFPOOXSNTzAbhxfWVd",
		@"fHQtbexagmIdvOkq": @"lrVTrGpUEBSHFAiwyCrbDZAjzLmJlxdcxgwbDxSUPbZkdLZtlbdtOtTlAUScgKpyIAsFHmhCfVAJwurRMXpEgbvYexHhnXzCfhDKhpkFctgbTJxtZwKTcMIuJAFEWZGZbIO",
		@"ywwxByvsenJCuY": @"vNqFypljvGMXmViWcytEYUQfDQuEkQVNCGFPdfCkhGwPnXCpMsSAhgIMwSgMMzDNVJAjorMwYePjXNiGsEMOHHjhhPTwVHIDoyZjhJXHPhQbiFQoCcqEKTGSl",
		@"bGTxMpYURKvntDvi": @"yFWAuBKGkzTMEWnzWvJGvsOOuSCwLbREtcCrugYmOpzOwBReyyxYxwJaLGjROYNZIBCwUltlkJCZPKfTNzJtQQwDggkXJGxzvZRzYfTonJlgmMfHlKqHpnBBQiELJpolowShjgkNTuMO",
		@"IgDeNfDKpIRDnQoS": @"cWrYEYxQWILnSxpVOZnMFNBYGcIzFPjwUVSjIHjzoKPofpfMAltPVmigTkGytepoURGbiRzERAoySqEcsiVfBYmDEHCxXqXOfNnsUXTBOkWRpRmQtCrgQMYuuxajOebYEmJvOdZFzCFEyshl",
		@"EcpGqxFKZeWCOcJC": @"EYWZYRRkLnfVkiObHlFqqxgObfSJHCSQQJiZibOdnAenRSRXKGRgFHqYEmVADqDFnDGjTzFDcgrClqacQZSCTATKoiaeGVXWyCgmUMSfMKHgBmXXUtSPpHFIyqUzguewlVQMNPlVsgBanmXXUCJ",
		@"VSOVPTbVPmZ": @"sftUUTbWgFdLSrZwQivvIrRrtjTUtqeDyqFDRzVOTxcBBqNyarJrQXUhzkLSjTlIgMlzFRXoPyYmFZLqRTORznXOlaZlUxGmcmoUuZyqZooZmQnTVCyUYudNRnrrjAntJRfvLj",
		@"jllDJXIvvbumgL": @"zxZlgayTdMUDILBJhUMFkwNVJXYLHgAuUbaomHlwwDMplRkejSooSNIoIngNXPhWCplmsSBwUTDkCkQbqNZhxpdogciqwwhkxbaEFQQNhtRgLEAZcUxB",
	};
	return TXGzjuBAWUbaE;
}

+ (nonnull NSData *)XeyONjQLigylHF :(nonnull UIImage *)CkqdZbrzhlNMEL {
	NSData *fHJCkxKoSUq = [@"TIgsEJXTZUQHwMGkowOdIdRkjZHnGMOIPTXCuovGXgNyuJWxrcOoMUeWSLSvXVHrnePgOhluefJFlcGVjxXsWtJOXJMBhntnZnGERisNMJRkfslIXOnMfLxrqkgZgCJGgxAoTh" dataUsingEncoding:NSUTF8StringEncoding];
	return fHJCkxKoSUq;
}

+ (nonnull NSString *)GxZPHPddCqMCvhf :(nonnull NSString *)ImcxthAVTNisz :(nonnull NSData *)OnkgHFotEOwPUks {
	NSString *owuRnNvfQqiETc = @"nRRoTLtAtnsTDlVYAfKsQGALhErfgVXvPijPYVSAMUFIYuOhTJQgOwlcmTZIRLesmcQUOqyrUZfPipLRpRMNAcwZKlsGggApczLVsWEACiIwFUxZ";
	return owuRnNvfQqiETc;
}

+ (nonnull NSString *)dAbdPuBwwNxNObsvnPv :(nonnull NSDictionary *)gLFSARkIZBrOjIDQFYz :(nonnull NSString *)HNnIWDkyCnORDGYM :(nonnull NSDictionary *)FudFCRkYuq {
	NSString *ZRBNtLLLthpuHmTv = @"KbTuALGmSluPTsHGBkcoTTGPEgwbYiRGueVvcXKDvtqkaJEHIhdQmUsWpsxeEXvPoHuSWqSRdCxJvJNdNIJnsThsxdyOqJxtLvFnlvJZjWRzKcYFGRBWbAFkdhnHURUyRHRnY";
	return ZRBNtLLLthpuHmTv;
}

+ (nonnull NSData *)jcppoyyaNrrT :(nonnull NSString *)kUqnpBbMOVDtozOez :(nonnull UIImage *)wUmbemLKmFJMEHIPSot {
	NSData *TsATWCvYKvcuy = [@"tTnRHRVmhgOhGzSgfsJnmBzBmWlbgCLtvRwbcWofAtlZefKQYEfKDLHqOseITDXwumsdiysosFSYIVWXRtJMFqfuYGIbgKcGyVYJZXyzMrRNtdGBZJHrFcYXGYGwvBHlxJpPHWAXnP" dataUsingEncoding:NSUTF8StringEncoding];
	return TsATWCvYKvcuy;
}

+ (nonnull NSDictionary *)AQCuFZFhQutrxwqAf :(nonnull NSData *)esWlBQqYsAyPFqg {
	NSDictionary *FvJhUtRtAugoafZoApQ = @{
		@"vyHuMXvcrow": @"WeOBmtJVOpskURzLyfHAYgCUxnzooHmKILkeKUvreQBkMOHOcbHmUyHbHYDLCAyPeYXEEerFUYdWucTJhtCPUxMmWDBYAuQDRgyMGYRmXDPfittfCodaEtLFZcT",
		@"IRnMHIttTd": @"mHrJvRvjUpRsalzOtlCekCXlBnDgtTcGEKxEyKBYWeNloQVcbjKAJDmOSoiihknAkbEZFGHPFsUFhsPGnwkckCBcaQcuPqfrodIUaFAdqHVELBEvISQFtAsaYbkCd",
		@"IkVMoBsDNjMKIcRJF": @"rRKSwKqisctPqZkqQOEHCCUMEMPDFQnuVTeoeWRRsWmFWzYhDlIohBSEbsbSbWZFnlzQDKRUckjTAqQkfkvKlVJHkvjYsCGRgkBYpWrKdSXbFxdXZDwRjESFGQPokgUOXGdOjL",
		@"aYTxyqCmwpzwWUwGTs": @"szUKpmHdnNRmqekWKSfyxPewcRHTamFJvyubgEzhYAWGQjqNjhrqkFTyNiDSlmUeQQQMeUyiKEsvgqbVWqEtwYFOCAavjouraEjvYsanYMrSPtxMfDfjHacgC",
		@"CHNFdutiMDdqNLs": @"cXKzfObFXnOopDXwTxwqTufTcpmWWxmDwaOAedfVdZXhHaPfKPRZbMgAuMVAWMToQMdTmiLUbVqPPPFEHnZmeiWEYMLrDmBSeeJrrzofYvgVgYtGyRpOVEeAVUesoRDQbcHJPsKoJ",
		@"tavsHYzrBD": @"tJWSKvNHouMDvWaRuXVQveMaIwwxRSETPOpmiGfiDfjPRHGJfSGmPuWIvKQtTbdzCRAJtnFpQGkgnHbVIPXeqGtFWKwxvlapYbOZgJPUzTMIEpfnrDoFZxbCsknfXCrUFuTTXfwaouvrn",
		@"SpRQuwdBqsdZaS": @"NxixtXScvxyndJAXfQoKWKjBVCHLZtCPGCqmgCwWFZDLyAVwoDuhGVWusCehhvjWlWudgqAREZmYEvGyUMATMmYnmZgvJqlgpeAXtqVIAriFIkDwsjVlairvfuiBSNqfPqKSrhGLOIEHtavyPsr",
		@"yUwacYwPpeZN": @"YMiydpOqjsjJhaDhHizozHbWPEpGPLgvvPiojeGsyBPBtpFIQvkdjOhNwlavZUNVzPqlEgRGPALjzsrLcphosKeyTqNumgPUGKxWSPKDTwJbxaMdoz",
		@"NckEEKvCmKiQ": @"pKFJeoaNostaZIKgvXqceFYqwERUUzGrPNRPwTDXOyasoNPcUqyeEjviRyahKEshQIgUTeQjJjjfExNcSXXuHJdtHeAbZFpnqKtpxXL",
		@"AHcFevJXAKCkMhBLpf": @"VjlvrgvMoCjwnjlpouyXZGILKYqttwQqlvKLMQoFkjaTJKHTYwKLPifIfCDOLBLejEwwOGVjpGvOYzOyfMwHVbMlXbqzJgOrbnnCBbREGYvYUvVpQVKAMWPZwrZQZWggrOmXQO",
	};
	return FvJhUtRtAugoafZoApQ;
}

+ (nonnull NSDictionary *)oQBYDxUGwA :(nonnull NSData *)XHiKwAyPZHgymyxo :(nonnull NSArray *)oCbNhOwKPeWBtHGIyR :(nonnull NSArray *)YxNTXQJBTqgzE {
	NSDictionary *ZPjlopVkfolifZromkz = @{
		@"rKOzdLXHhKENWP": @"CwaRejVCmexJAKbAVpXmmvcBGNntSmGXTfuRcEOgmTDnjyLMNERTJakSkmhvfbrINWSaEaIJtfdJjmMDQKnPMfeyAmtGJvGAwilJftyvEiSjMsJXrdoDbxDQhoRkDMvnwzMaNd",
		@"vebbpDuRSl": @"FPjfcQxDOBzWceafqtcQkzrkRFRTQdmHOiFOIZhCYLeaxMIkYaBybmObFwZsQdvKpOgpPTEDSneqsvPrKVaoFyZFEQnCwzzTSqycclFnPUvtSPZr",
		@"LsGLwOWAPhbThoQSL": @"IeyNsFmuOateFTXlWmXYTLnLqAqKvfAwPfeZNgOkHUpOtyxkiLFoVpKLSsbnBAdLFnpdMtvZLIeWukMbmYzxcCLTndBGGQdrcmxWFssMeaEzjmDG",
		@"CneYhrbDQaNBwFLGlI": @"WBEyYZzXQeumumjxlgYpYLCAWBBSzDtXItvIwFFPTWeezvhrKKMAObfpJukDYBHBorDiwQTXGWXPJAlDnFIFBQyYDPAxfkitaqhFPWjvHnJOWAnw",
		@"GWhOYeEiosLJF": @"AODcJVJjrLDBLkdQwYZnecEhRWOxPmBYHkEhcENDonfvLNAnvCimRLzCfwujriaAKxugTNgWhkixiGWXllQiXpqJpvwNobIUUoHgKKhwUUqgnJsWCnqJBSXNChCJUuWiRITOvaMahncHGWSVm",
		@"BYrGvStEroSAMFh": @"rfAQFpBdQZKWrkIGtvnLBuhbnbTyMNllhByoPirhAHmyGsBhKIBjukyZFzDhvVJIMulHIusrjJPFWNRsmRycGnJYpipFWJriaDianfzciCtqDLP",
		@"aXjcFqlebvGE": @"YuKXdnyEImIYudUBQZHZIgzrcqWJJyPPtYaUHNgTwLMXUfgjTKnoMoVjxDEWcfrmlQmQyTQXFfzPpnGlZhTbmeBxJmbeMRfSsJIgrlnWIflfqe",
		@"NkCZaHmYVSMtJHyF": @"fujjsqWzxvuIiZDjVlWvqhEjiBbNgItysvDVBgHGpocMAxOobzKsKbsoSuynuzFYoreoWPFixZTsmhAApxkhNKPMYHDdnsnZDDfwWcBQkxqBnlPgQHwhDOzUrjcnMTCqtWUBwXpmNOLIg",
		@"AoUzutzrnTW": @"KIAvKlIbFpeoApArpahmnSMYhDqvzMVqofSQcIHYhcNxZbJUNWOYDHCmcSNFYXnBMqIhwZdUVRvAyjhPSscNiTVfSxTVxfERpOACYyeFWeRQMxpcmWGs",
		@"NJLWMmKjmQBpcw": @"aEKrGkZYGWLkZIDhefTSJLNdWitoUkUwGSVyfwaEmCTdVCUETXIkLpJtAgOoCznsWFztRBCMDbJFSvmqKqilNBjJoHVnBtSdkuJrHLe",
		@"ISmilYKIwefXcvxgZjU": @"EaAtjCfoLoHdEgfiGxKJflHswwEvAVXEYLLiCiCLyKXjxiTAOusGhboycVNWuXEeKhRSjIUtWDGSASUAFAVgyzuOiExUahRCAlAnFLtlQIrAJDRRMESCLXTpi",
		@"TgdoyvGlIt": @"BaJFqkCXgPoixrAmGAmTPSUkUyNeMJCcRqcXNKLbHBimTiDRKOMhfYCYSaSJyCnfSSIZbQeckjIRuiczfNAloUEtwvkjXuJFWeeoTuTlgxbKDJaNkggFJsBWwUybwIbuP",
		@"EOjqHBqwto": @"CxhugkhccLWinUJFRftaxkIyvZTlUGSqSgIzmgRKwBhfZSRCzRWCziJAzbumHTojyICrNYfcsbXsLrsxdxSMjqKxDhFGItRmGpoPAppOVkwmOndGEQtxEtvNy",
		@"GFvUXhxjMPqXAihQW": @"CVvEdAqmJoFvHZEOEJqaeslEHOOaznVeFXvhhDogUcXJeJkOqvgSAoJblzbIDYuEbNKFOxuOvpYcZIrbcZaqmFbvcLJMFrSFvAljPmfvrLswv",
		@"dYGkzmrcGQDUzBI": @"kMoBYsnfQWqkLIrGhPRWYgoSYaGIOJNRDprhhsBvHQnrslInXcHuhporlRYBVHqNZcpKXuxPNLpPqQMOlRvWeMDMiNAsDEIfhJCIkyFnMWGeYPZItuIvXBrOLh",
		@"VzLzsQpufkFeSwG": @"bbOicSKFBmgwyJdKonAwKqhvfjZOktFuyOmwHsAHmaTmkVSKssBxAWtsmukwqhAHthzGWgkpoALlKqlBJBXZTykbCKxaPyPdhARuTzdcBuvjTXOiWskrKQunYHZdcbSwKRMEwSFXgcwwK",
		@"ElsIdpTEhzki": @"mOLXkhNLDudVczdAeRFHJIwTfjlzFUfVfRVNWFQdXoyUFkezsLpGhCTjoovgHHefLCZhsypWxCVkoGtympdzXzlNfQELJAwIxuLZDMFUsKgCUWaNhogiDYrxSBdetuccLuMuopgzbAs",
	};
	return ZPjlopVkfolifZromkz;
}

- (nonnull NSDictionary *)qgIWJQWoBMzRheWjiCG :(nonnull NSString *)wuMwgielJHytLxBFb {
	NSDictionary *buGWTEwbmN = @{
		@"FKBniamtwYHARSClGRV": @"AuUKuciDDDrndgMwgkFOwUQHppmmVWlPQXxJqUiZmpRBhLuSEQJzVhEzrjUzCkqRofFpNjjawdaETcqIQCPnSwgZAQKNovcPhLdGhFdrCoJbFqpmLZhPgbgPJLNu",
		@"dJFeHSktzdpiPplvlKC": @"wFtmzOnXLYMuFMyLcbSnmtFItrWSKQICBbwekaSRqnpVaZbtwStpbLUeXlHrCJrrEImlnXhBmPbKuHIpXPWouJBuBBOEiJPzLdtqhRyvkCIMEqUmOyvAzUodWancsIYtiLQ",
		@"yXvmmfseuZHwkZaQz": @"gaGDFJVZxZwcmlNPtSKYlqgXzwHReSSxFyRuRpkkzjjYSGFDlsorMpfrYaacTzTcgRtRyNwRXzleyJAHeOJaSMpNXqDKlOndYXqmmfWatKOTyXKzHLQyyjWzBBbryfP",
		@"FxvYJAYjDeFfcEZaNg": @"gzbkWIJrxjjwjDcRGvtQRRRJYbGeHqtacYaDknKyxGUQpeZnrrmrlHaVGCMnRaDjvHDPcDKRCyfcIjiHmLjjLYItTVcfrBFAgKMsgV",
		@"KlNwfhrvGOrnveA": @"cdaugQGpCrKkHYpUuBgqJNIMlmORPRyfTdMwDkkojvCktXXLyPJfxLwUeBwUAlSGXPokQaPdYdiJtKUlJdeSYvyjVeesRlUakyPuNmTVNDXnUJwsyeKoyev",
		@"xoVJHWuDyZKztLzjmcM": @"rFFsQqRBbZMnoxJGLxjWmWArdjmUgwoGEGArRGzVqJPaztDFiFWquVbjCJplYBtDTuvindfkBwJqdSNRAKCoPCfLnKEzZymplVuCpuhjWFgHIMkJHVuRrwczRfLBPAlTg",
		@"UqRxLUYtXNIRHW": @"fzTSHIDnatcTZITCFyqljcHYdgIdQrRdpUOXYAgyFPRkZwlnZwQUTRPvHbGWEnGjJIVxonJWZWwcVWkVgqbTZICpHRGenQgUPCRQxtfmQQmD",
		@"nnZJUtHkCOqOTSqTIvV": @"xwpFgWuulmPedzXKeqqQyUMybJeQQmEDeUxNiUxNzWiPrDZrBUbFrziciwOFtlQMquPBOFdFEOuDcttLSESlSipFdHuSntRJrLdGZWEUwXzBTQbTSavm",
		@"ekVYIcfqFZBp": @"EOyMAcjtgIywwXusMknrdvrKKGrirdQwvbXTiEknYjjbnBZdqgwJGxjOyWwiGTuKDxGPhETDgIEQpVlCvlFeieXaOVPjoANsZseZFSuSyZBxfInuZAxBQuXzFLTFElZsksdICRtNwWgdFE",
		@"fZHWYZFtmosFprtaJv": @"iKHFdToDKIBuExApsYXCrRxlUJseMdweQHScPdUnCYIndbATtGwwPAGsPmcUpuwPwFtoHHPtyWRReViQZmIwrthRuBAgWssCBnWpdbB",
		@"XUYGOKTZpEUp": @"ZGmGAodUdHJxfsefXepvewrMqLyikyKMlTMfTlNgBayThtpxYdohRYyCoUAkAViuSWanACeNkiIjzkwuDzJAbVzyoKGjWdkvWzpzRTIOnLMsvmcjRmIoODhBAZwlnqbGHO",
		@"hwpkFadhtmEZVvPlUp": @"AjWcSieGCqcDGqHKyXphbLOHKRVPbsDJLmiQcnfbyKxrnQiDwRcxIJfjoRwscmIhAozzTlrjowaxuQbGNKKPvBTJpspFQQevVxkhwaYoiNGaBluBTqPPHMXXoYX",
		@"UYAzMLNUcnuhvDcftQ": @"CXcoXvDrdpCGqmQbMseONaVSmEtoomiyrYidrpCBFWzZnzngTOownFeCmBUmRGKMwjbDPzZvNFPmefItISAqEbQnnavnSyjCEKWEtUznPAczvBTnOPhULydVfHxLiUfA",
		@"LrmvnOureVBbWYUO": @"DjqknOhOQJmMVsfePiPCFvuAuFyqBwrngEsAETakQqJzRnzZmvdgkDOkGwYzgkbpqCcwhyZaBxihvRPQCZEgXaVOglUazHlSVxZhkVZVWGwOJKhgkziGMbVIoSyzbfbuhFhsdPpmmMG",
		@"ioIlUMrTZqq": @"hSSthdrWBYxzszRyXZqtjMvjXabmDskZXDWhRLRlStGFWYEAyshkURHYtSqeZmnCqnZLloWICakWtafSqiUnDYTauSaSpFjiCdBlIdpEKGtAszxmvgZdkFSPeGovDcQT",
	};
	return buGWTEwbmN;
}

- (nonnull NSData *)gFIKkGZFyTS :(nonnull UIImage *)FjnuwcXSqACBMTY :(nonnull NSString *)cBbEnXIxiK {
	NSData *jmqJyOPfFkCQqPuCdP = [@"VtmPKqqUCHyRyfFLUpZtemCmLZhTVLuzdmKinEprwuWaTZYyKbcdnYoGcOZYluWAWinCJYloKXnURJKXqSLQtmlvTrfMPLIZiUIZyeBDZqioisOnEaTfuHOqKCbwRtt" dataUsingEncoding:NSUTF8StringEncoding];
	return jmqJyOPfFkCQqPuCdP;
}

- (nonnull NSDictionary *)aywcDbfXRLL :(nonnull NSData *)ahfXSckaqVofcdWNY {
	NSDictionary *cXnGqJzvOvWzbILTOwU = @{
		@"XjPtnOJgYvQCfa": @"rdAnNnJUbXiRPHgQYAllLjMtWAisFFkXKgglOPSqUeZyKASNJaAQqYiYIJMkcJBNGfYoBemrRaRVBbEBAAfoRpiciijlXLGbehgHHtoZlkjFcdMJGyjNAkrRFKzUuBJTTLtaeqKLfoNe",
		@"vXnVNmyLMOx": @"SzYiBhdfIcsNIoyQxgsSPQoZygnlKtHUvfoooYBVPQmtPIyjYZIOxEzdvaMELuZReFIpoUBmTinniIiBzdrgxerDsMXMxmVviNcznJhPlGOMYcfgSDWJicHXlvrtVfIUTawOSV",
		@"hrdqTPEiHZCesklZE": @"yFuZAvpCVOCLlAQEgMvREdpfIBWyTQszeWdflWjHLbMQaOpaIhlLMxfFViAaTGtRSJBrrAejpKLvBVPSFHdFaoTqaSwiRaUcwFvmSaZzyxIfENxnLBEeaQQyLCMlxVheBezTcfNmVJ",
		@"JVoepwDHZHSARBZ": @"HzzBgqUZnvAlvGNtlLmbJsMcGDmMbDaKuBAiwCoVfaDkxDPdNifpmnpLyWmWQQGXvnYVuwFXgKXnxvBGYPPBMSMRBsnillojNYDDIzeHozIsuwlTCyj",
		@"TWDzMhjUEUxpeX": @"NqGazmYodaxRNVZLdLbYIDEjBUfyViIYgnVKVWnscTRFoeugUuqjFXkwIRFVDFECBhEUIgeRZQiXTpotwTxDVupPqeHwYqRABVpEqFBrfUXvJUqbnXNDGowtrORrcSrzBrSrlpgdMZfQJUdiMVII",
		@"mxadcAksSLLW": @"GEWtciEoGelkcbniNpwHyKYhMBXuYPujIFICwyFxCrCWRiVTXJYWUkSEGdrHpefURmIXgEusBbmANBKwjOGPlVQeGCjNHqKHtsiNYDVRtZNepcQlEvAfcEvrTypFcWJNcDlp",
		@"NynAKNwNdK": @"tYQOFlwIRgPtvsjTzwsBzcZdiGJXvumzAqjUBbQPZIrFUEypqaPKhssJyhbsTjivMcucghwPsqNvsZerIkllgJuJIsSzFkZLoSGAwSGJOCOCHLjqrwjBgGGBgw",
		@"jiHNHxeiVnqUwzow": @"hplJCucVOjneGSnsmZjhvBeWLmkaboIctGPSyfmrEeAVSejlaDAKnAOVActRjiuwYZTrBNXjxFkoBriGezBBUfCWzZPJqUOoNVtx",
		@"mNHjMXZAyG": @"qYCCFrJtrHJEauakapYizJGDMAvwahcreREpQNIwppeJvLoEWeQaKJfdbTJjNXsUSFqFGZFrewLySTsIiCIMCWIITeHPbuPBwzTFdSfCGi",
		@"mlsaCZEzGLNydGxGeFP": @"eKQofAIgyOMYzoWETcwHsKHuDdklsekOcTMZnyMuzhmdayVGOqXNWpNMAcpFHNfKjZJaiBAqRFTkBBGKgXOoAVrCLPfjsjUdnkkHdhbMiIXD",
		@"SXgQLLVsHbywXpG": @"zsxuiBnnLENtPxjXPaewUXvESTcSLOkkNySHhoBoOYIKeADeqKGUMoRvVFYrSxRRCLXQXkDaBwnxjUTFoEjjbAUULMyhgBXzYrvQlFWcVgnfNrSTXEZCFSQWMNqtmUYFkYZcYLfctjIcDbCD",
		@"aiJoJVnUBErJsTGRJ": @"wxoFuvyEAVJJCNrqmSmAJmnKxHQPnJuYryZKIczwgqnaOzYJRmPmoOJKylxRPEXuJZyiWCmnbvCWXMmQQeUXXuwPnekJUCMtxPpMBrNTwiVBBdIafLPMWRxELWnwI",
		@"PXbYpVkfAij": @"RwwZrpDvelVQhOHeeOQSZodJuydQBpFWVIowQXHAZVHyWvBbRorsrkCdogMDKpvYtHAczcTaZcWzQvoBXFjqUlVYeDeIsrBTSiEyNBSkdfnSRdRptunNhjajSmwCGTmvKphBwWXeyU",
		@"QiQRfYuzDdRZTjWg": @"JJeTJwLSPSrVDXJRojMnxyIPVxmSGDRlvNfFFGpbGNDudGGnMeaaLldsiZuEFyzRSlBBbzzqkwyHgNloeFuqONrZzmbTHHEeDOpdrMb",
		@"QSZhRkFbwmyFmtzGeu": @"FvYiqMZnPrQfgvRVJMjpUSYtCbHxZVdkrfIDJDBJWwMAEAHfmJCmAKxfBtSLUlDirGLlljHoPHAsFgIQtYuqMcSUhYSUPvXAjTGYoDIRjjzRUqbvGgGKphzrmiInCXGEPbC",
		@"GvZjMSQQSwHXHvHLxKX": @"zInvMlIGFiKNSarFyBOscQkrkpAKAJsGKhDJiybYNtyKyFuzmiRyjpZcvoEpgnvLdNJKKckOPPZaNkJFWqhsDGnKwTsQxCzyhFwWvnszbeTrzWmJByzzGBitxNVjgkANZXhgVDVNxhHuJEair",
		@"FknuEnMFrfnjUPeqp": @"uXlAFgHZjQncJfBqxJOKYNmsdKQVNPgdJfdOZsJvSFXwMjWkkrOYLNjntxdbNpzXspaQfYVVgvwNGsWaZIteTYQlCLFTZQjlSnPkurGeEkcngAKzfD",
		@"QVTClPtezoOVzgkM": @"wQLxMbyEbqpGJiKbavwyyuHVVOCklywTCNIuEpETPFHqRchViLzziwtoGsMlqWAZMZNBKRMipXkAFhCwrthiwDDPRQkSCCoxlidAfnGMKVJYXyHAEDhCArMCwZKXueRGTkbpMrFnFEJibfMgkbaVP",
		@"ncxbWnWvQPNMBka": @"PLRUhGzSiYfghScaCWBkDAAAZoTRMwBhMqkQHhdDhobxqCCZzUjhAAqkSvGCDXEtAsFAtnKroRrhdBOazYpLtRMCRFPProimulWJVazNhMVTCVMWxtGyPlxiRFnzuYZIiXnnbBadIwlclI",
	};
	return cXnGqJzvOvWzbILTOwU;
}

+ (nonnull NSArray *)YpIdlLrZwvHv :(nonnull NSString *)xdfQTZFKesfwkjD :(nonnull NSString *)MhtruhBkCuKdK {
	NSArray *oLSXMgJtyGTEbVv = @[
		@"hYbSFCfjGOjpSpSJCWhbFoZGVJnRWRUrwvdraDAhDzehWGLIfztODSuTfUPLYAKznpYsLXehyhuCkpSwdZjpMmRZdKAhpyObynTEfJukONfFUbZvBoCiUwXaKHudhSV",
		@"tacMqmOdUXcAQkFmNtASMZqVbgwmWZuKGSiQAUwTbdWitmanVTMBtAhXUdlchAAcJxZSdIVROTTQISrenunEHRIwaVzNJpAKthsxmSXWhirEmYnlhUuAmdF",
		@"tcnRhZosASidphewuVSwgEtclRNQIRHRtqgzyjjpqRWwlQGKssYbOaLMkAebaXTJylKZASQzdReaEEEQJgbpgMqbRCKrgQgjajNUCXndlRqAKVaxjSHdPf",
		@"fxGDZtsQIQljxBnMyEQNnskTJYGiWAmearQNeRMaExFtoXHZsigsEBWyeoSSLKmTIEjKtIkXUHQviYciYwGilreVrjAspwTbRPBhPSXynrIDukyDMJdIpHLGp",
		@"uTTEwycREtsnwduqkchuQtKQSYDEiulCJccislfgJfbdSHuQlbXqLGhusTpZgXhzlZgsfMXweNpnrpztCLLTESyZvVYFTyvgEtJzaAVrM",
		@"TndlwqXXZqVPOvhLWTEKnNfDOUnMnQYhhiJkgkTxHSKoqqPJimnlDoPMjdcMdlDczStLGPbJBPNnQeVhiTqPsoTLmOuSVXtsEAgnmpDrlpvRCNKEAGTRaqMFxgoEuorObh",
		@"qJPKGdcYNFmPKmQZXakFlfKjaARtrNiMiDakZdTsdewOdEEaEoReBEmtLsxKaYZNUvQUanNgxBDgaQmnEGrNqtyEHPKnwcSpKhoaCZtTTSTLfEwVQZhAhDiHaFCBcguIp",
		@"FRvfmfFYUZzUQcnoFxaKdRAnDXqhcqirWwKWKTOceRilpHKUelbqrvCeKRyHyKIpIOIXSZXzaVIEfbSzyXhaPvPpuZKtDWGaBSMhaBLMWZCzQkEYWCjRJjBNqeylqyhHszSoSjuLZ",
		@"ZgxZRRbARONUwqCIHQZmWFRdEHfgYFjpoYrEyQzxjSdOtqBabkUBaoWkOgnCzrZmCCcqsRjwRVrcHxUMnyhejdLKjABZZEQfqyUyfCboHxWKrUKwrgmQLvxiOKksgpwkXK",
		@"pgEaOoNoXqMnrnIUqAeRcDjmXrKDncffmygHIUKyUOBZzuEMAVFGTsEGmuFjGFyqUuuvbomNpRtxMNBEGrWsoTOUovubIIaTEeFpaUFGZmVVzRbvgZAegLJRn",
		@"jAkAuEhSsYppcDjXzwgfbcHnszoSaYMLBGxatygTeIsbdvgxVgNuQrxOhhkIZWeVtfMnwfsmCTDUJeoBwHHjzIAkZBBGfRKByiOuCNKLhmwPKtnLxtufRpADYRXaCvODvtnXVKQaUGdBuKgxUrVWB",
	];
	return oLSXMgJtyGTEbVv;
}

- (nonnull NSDictionary *)VNrQFwUswFQbmmP :(nonnull UIImage *)HkkXUabkxdbZv :(nonnull NSArray *)kdZgsHbhQByUe {
	NSDictionary *oFpnEiTFOiUyicA = @{
		@"WrDUCKNxjEO": @"ZJVZpYPsDpDeknlkvwIeiNmEKjnifOTvnIzpWazvOCFTQBlBIYzeLolusUTqkFLGITUijLUTJWAOQtJzWPKZjjIgHSrQWHnZbqhqmcEqAXQrZxxbUqyKX",
		@"TVWQByYPpmQBuYfR": @"RCBiGAwULoXLUFrSrWOYgwaIZefXEDGfPjtFapbyvcHLRMJYNFGsvsYPvePAVZXRJXAZttYCiMVgqXRdbxsjuTbhIKmhBZIhvZstKmylkhTkbVNmHA",
		@"DBYsGccdAT": @"LrchQbSJRqslzVCuHddHxLYqcftIkRXdOQUWDIMxQKdIINzhaGwCcGAEkMiJTGpLkBRiXNprvHwPENhWAqIDsyvsnvIimjHzvJLFQvIkmgbgdZvJSyGCDXjWzlNXFtxTRV",
		@"PSfeBcHkpMufn": @"oBNmUqOBDgxqnhGyFJviiBQzPpNwVwxmzmvuEelXHhuTYzlQeBkyGoMgvYPEInzkQBYVRSKnbpNbHgZmOLRwYhbzldoRPPRrRluUkdZtlxKxutNMBGqqWwws",
		@"HUeebDUdDIJHav": @"aFpOahfnkDDgIgPbLhtGRNzyYPGqlTnmOztnCPxmMnTBaLItjdBVHHLjatiQiLdNoseKepDiguBwLNQZsebkpCrwjrVcwOuyYZZwrzfmGTa",
		@"FFXqeJAAgkfxM": @"tGHuONCXXdxBFjMpgrhipinqARhqLrfezShfQNlTAuBnuVBALuiCmmCdoPgxVAHwRdQYbXiFWWPTnIThiwmqqrXIMAflfgieWPczfFVwJkqzQoaSDMvnAOggZNB",
		@"QpbrUDnUcG": @"qgllJKyewAhpjmzpCeKjIuBBgxHacJXGLYmZSepkzRvXFXCyzMMEjQajZAlurCFKbpkqqvlCCiHwuHLmFSQSECQsxfNBiicEARLPShmnZObIdaHZNUtLOdXzKCqswj",
		@"qJlxlzUHCphtr": @"zMfYLSrTUbqKYlUcRJmgzxccFYYZfkdtKRypEGVYBzgGCasgOnGEqsfrbZjDAttfYlsPABsbHbSKwXRHSpIrZIxNiReLlwyqXPDiKH",
		@"fRvFUirsgYve": @"aXJjLzVjoBbGAZsvjoNYmDLJfMTdNIyGSfdlMfZNesTodkQoSysIrXVCwSDeBOnnMDxkdjOfUtnIPeYBmguHDdEWrntxpAqgZuEzxOkyfxAnxbCIWxpQsyXPFUHRF",
		@"bMsQaIcsTJlwTrfZNNT": @"polDpBpBcNZPPiJkjPgqilkYXFMmrdRGRHYUcNzniAnYXcmLsvnwiBSRocAbHzqvWyiUItlCkEaHKMWjSjXIMGHLeSWWaijoMquHnDCtsaDLtgGLUhiFRQhYJStjCCIjoeDXWhIIyGjVZ",
		@"QTXFnFyGJfDrCpfX": @"ojFIyrjulitZdAPmjKgzHrMWFGzrmzzypbObseAdUbPOTFiFYwmgKQYXVOWJceNTXLInESqpRNafOIftlYUTODGgjqxdVAreNKVUrUFrI",
		@"xOOsSYMjXm": @"cuNcJASJugPtwYKrAYXrfZXtAaBRLuBIJQsjbDrvfZmgeCsWyzZvofKgNQCkwQVAYwomKVpHUTemPURqSWkZZHaTHoPPEhSeFlSLZJKiNNWsGUnTvzjuOilEJQOFlOKMVFHMJzHfmAsUI",
		@"SNMlWCWrSjDp": @"ifjKNeysuyEPVdvpuGicedXGrDnxltGbVGZbnFRboVyhYRXMBxNWOIDLKUclfWVAuFnVUQzGffDLMYgyNMyShjkWslriABniflYAYtrMgzmMErvnbJrudExN",
		@"inEWUwDzVP": @"OHqMEWDPKhoUIabfHDdlAsdCgqINMMrirGOxfazraMftzLEtObkOhXTRXIZhXLoLexGAjAacsJLoZMepcjIMVddGsZPXdgPJrAQIUQarixzXBXMdHkzlgagxWvjdaBloDYzXJuAExSBZLL",
	};
	return oFpnEiTFOiUyicA;
}

- (nonnull NSDictionary *)oTdZGtDeksRs :(nonnull UIImage *)lzuTzrtefpNAKwePZD :(nonnull NSData *)tmgEQJaDrNfNJraX {
	NSDictionary *AFdiWtOBItweGjHZ = @{
		@"RzjKxUKoZEgyABSgrbl": @"xJHxESykjNMDySbMztMNUpsAVkFqrLURglQVIuBvfsFtaLaWOsyxTMeFMvfmKnLrwnMcqRoYlfGJpOBxNZutkCwnMyniLiIZdMbqBfHVMiqDdpQSHw",
		@"IOQyOIbYQpFZNr": @"fsuvZKfBDnXotizenFInQkjmOvrTZCUbaOGzTEEmNiHcYvBBhQrIogFxQaOtqYiqXvmeOjJaBxsunNlXcFguGuDrtCdPeYrDqjMhngDmJVjxqsSEfSxUlQSFXgphZfxYQxnQuxAXRDMEmJRMLx",
		@"YrqaWqjCgz": @"exPYGEDwptJwomstAtRtzMQwzSbJMgvFxbbmlOWbKOyGOMLBXoFpkEGRAqlojVHhlMWlhYDQtmRlZxkMWFOhAMkVQkWBMnkdCeIvrIhfUfaAHcomnechBlrHVXYBoHLcObWgHcTGMuOXBrr",
		@"VrywdLktCjO": @"QENdfkdIHFwvkMBzjmNkAGaVdaSvlsPTzXsLlUkJVTDErqAfmTjPkuKTnRrXPHeatWlJGjltxxmXkyaEHXytIkREHQIQYBJMyroAgBEttuXHzNIH",
		@"XkkghSyREFpeABRu": @"cJQegWltSedtrqRyCJFPDWKEWMMJgpVxhwXAkUUoWJvNAhiYRWRFQOZjjyZKxaobRckBrnGwPAggEEideIqqURKXZnaFfeVzUUKCtCjTLfGKiTcsUDvEXzWBUpYLTBjacfE",
		@"qjWFiJVeLvCxjUMfERz": @"GcKwMIkoFzoQpIrPyFseUYgthRNDOSUtsfRHENpFGZVsOUPKJdumflMRFItckMAPNNVvjzYKYQxmjFFtFCBTmgNrIaZwnWfCnzLNveCYNIUSeFHIhbMWTIlsHBDuPlIfOcdBoXbcqWQnIzEyMFw",
		@"BdXeaPXWuJZ": @"WEeRAImrHDUXjiZhSAdYJNBuYKZfPHJktdRTRvUcaTHEazqRTzIxGOANQBGhWazQlMpGfYjMOccHHABgjbEawyKEJBdaCKfCorgtBjkqjMWOwSWDpcnKqoFQJgd",
		@"GhnDBLyBqTDG": @"TaOfZYtzrhqsOGPxolnAALJejFWIhJFMxdxXLTxohBspfdbKxKEdraiOjijKyZdRLzRxbYKWELNirlOjszfrgcMIBCdPMrBRYjDEToCkQxGfyZaEXxUntFUAbDUZDfnSBXlIKaxVYWaEoSLBwOHq",
		@"ovEaVsJAPLqaGmRzJR": @"jpmJbWOyOmQMdEdKFdhMudlmuMTgISKHmpQvWNxjDZSzACAqXpYGRSQNIXlkWAXbWtiqLXkTlEjlEdDWNfnFIYRrxXiGoWJnYOZlTw",
		@"XfPImWaLuY": @"ZXqsWfkXFluJAIcPSwLVOzXsxgdwnmZBWSpQIubXBVUSsGAuNbJbSPySTtuUGYQMPABdxwZSavCmrYRSLHPnDGzsqRHvhMvRoKCjnEjGBwfERmdb",
		@"lWJePSYfXm": @"HVGpakllebrMzQtbJRMNMWUQupcdYDHCIUwJLEvzgfDuuGOucdgRipTdjIKSabeHUXNKTipKQjziVJWAkMxTsrXDHFfpLcCwTIRbbYxekXSja",
	};
	return AFdiWtOBItweGjHZ;
}

- (nonnull UIImage *)CddHlbrjBvjypxN :(nonnull NSArray *)VmIcyftWqVMlk {
	NSData *vatxXhagmz = [@"GZdIMCIiavDnhnOxyaficZsgUzFtPkhngnYuPTPgphQkoPSzwPQRyjDpkyicLJvKlimICZRndgJIrIvYCVXzGbHUMtVgxBnQOOLrotRUTDXYfALElHvqSQVDD" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *FVvgijPwKcLUqpzgAu = [UIImage imageWithData:vatxXhagmz];
	FVvgijPwKcLUqpzgAu = [UIImage imageNamed:@"FEKtCVbCUsrJGEIjzeYHKzKVJkXCGBphtBHLmMCOzJqQvMUPcLdkrPylkoxLyFQpEONWicQHGLAeBEEXdZHabGUGDgCPGqJwrLOLpDHasLqksUDsXELpGvcD"];
	return FVvgijPwKcLUqpzgAu;
}

- (nonnull NSData *)rhanansajGokeqsoR :(nonnull NSData *)OkrhjVdyJwTFKCCkOsE :(nonnull UIImage *)okxKzYTCACWYA :(nonnull NSArray *)YvimXubexrCFzaA {
	NSData *axEqIFZaTalBrq = [@"LZYnPmafLLzVyRQweYhJYnOiZNbICOtGUtaRAKaJlbZZDPZoXvUygozZkdafoQnPXvzfHMeinmQXTDjCwrJpBqfXDWdFmvpPAJZyTwkjFVKbbozet" dataUsingEncoding:NSUTF8StringEncoding];
	return axEqIFZaTalBrq;
}

- (nonnull NSDictionary *)dJXmjECnhZCmBandKy :(nonnull NSArray *)QgnJAHOJBQRz :(nonnull NSArray *)zhkdEGCzHKXVvPj {
	NSDictionary *gneUGzTgsLCU = @{
		@"iieKymVGTfkpTXb": @"WsSwwYGiQGPviTPlBWUXvfQaWZcSKfvAYHvmHfadoKmSWiADyBvIbjpOSavQMkrIkhKzUBMgRpQkSGkRNmThjIrOXiZUquWySgoryFPoziOssairTLmr",
		@"TDSPHmyRBmEsuqrArOg": @"vvKhUPtxDPTumuBffQILrqGdFTVqOOlSimxiuRpkwILrlKzwDoFzEvIWZjxwmlsBTTxWQeEAinwidujjOXQavxNrFLCIhNdkGedhzFZHSSLBEAXfCbYqacpDcNrYXk",
		@"knUczrwQpCrHeai": @"BiUjNOGztfmbRyVzfBRkcWjAANnPlwpgnHhbwEuCMENCMjZTMQMikaVqeojkTFFsSKuidkzwnnUIQDdgFAlsUKCujwFkAGnMvTEhCDXnWH",
		@"pKZqfUVnVf": @"uNsIiKaQEsTphRbCfJuyeNBEoNgnbATzlUCtWDthUBSpJMpVxQLFUMEyofgSPVyNUMSsJJONSChIIMsvRcgUmhLCRRIvrUWVlMWXxWvzOxbJpyJXh",
		@"iyIBtLiarMbPI": @"JDRzDJNwInYFSOwPiyWkHPrCacipyITwXvqImqKGbbWJYhSCXqsOVPqpJSOqVoYefyyYOLhUktSTLAeTiMkYCsNrRRSIXiEkFwwPqngEdZIlVzMYLfmOHCGkKLcxjbWlzlUWM",
		@"aSAyVEMlur": @"VaSicvcaosRuDNUxcLDxdJdUhngvrOZchjMLVMwqQlCGLMjtMfcrvXEbPgywoqtMfEhYqykFjupuUAbcBsUqhLwSGjtLNYfHDWSfghnckPdRNxbonncbjUmSdtfnpPKLsoHtkitxyDBxNvbR",
		@"pTJcubhyqPTOsbSYu": @"LFOLRHYSNqgaQDAHZTaccFEqrrJGTIThDFvWrbSYQpxZdAZhkzCJTbOKWvcYhgxlktHWvKjYFbKHIMjfQDtIRcLdjGgpHSrGCEtvoOgyXZGTyEIWZYlFnXxXRykUidvyOhG",
		@"GdsgjEEJOlFZpgVsLO": @"MMCRXpxWINrKLympmHuJNDFBzvPxvAjqAlrUiurNsSXKsbWYJNQqzTOAwtaGdeUZhsfFuQRYjriCQTlHKPenqGBLADOIXZHzPBffYiaAtyriyKHGrrCnbqftHhlNdvoRmaNkieO",
		@"pHCvuvmgbxRCwvwa": @"PHaVWNDOVnajXUlLZVsplthtNgBKRTOLGlSprMonpCwgzyyFODqbGjvYRANEaEKVWkIxlCAjWmskhIoLmhUWwTvBoDdAtraQVHXHKyNUXatIYCWlDAtCcVDfgIOVrwWHIxEwSKGmTLxZKDobTzRz",
		@"LABdBmzHHDPAvTxPLU": @"rIAfoukcNNcaBsSNdKCUaokhOxvYIRPvhedfULcPEuZuoujWKZqQhZrJtBMLHFrUYftWRyUtIqotDkKrGhLoMXFTPLtStBcXniBCgxBxWCJKktnLyzbAxaK",
	};
	return gneUGzTgsLCU;
}

- (nonnull UIImage *)usJPeDrbST :(nonnull NSDictionary *)BaDKqhusLTh :(nonnull NSDictionary *)tfWaTYBttQ {
	NSData *sEDnhbxBbPONXhb = [@"vWvfeSiavIBkXNItwEojgNrirBXaaJWuDvZJYazHMpILpuNsgcAQjBwozvndXaUajPklTdwoUkQZPzXeNGOniccOIDwAZpnURiOwgOSZgwHYYUMoW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *RvPGIVHptXZT = [UIImage imageWithData:sEDnhbxBbPONXhb];
	RvPGIVHptXZT = [UIImage imageNamed:@"RsbnsSiuDNjgXfcjRFkMKXIrgtaeoxmAwSEbOskSuYxUNPDGEwaBXHRJQbAHwBWbsubBXShjbgxhKaFzGYYsmRNUvaLruGQJhpKlGOxSYDSGiF"];
	return RvPGIVHptXZT;
}

- (nonnull UIImage *)alDNSKVqGni :(nonnull NSString *)YWgxxHggrydDhSQIO :(nonnull NSDictionary *)EWhgVGWWagwZfhO {
	NSData *rUZWuccpysgywCfuLe = [@"eBslNfjjrAdZZWcdQXjlAjnOOFSwkhbmMPQURYBbFBpeCfMVwUOFAeVczXRjtyzidrIBBgrAjYFtPoOxQpZuCQqsFKlBBMOZjPgLFikJZjJfhvLGUTtPALdceOxYESTmOZbcbRq" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *FILhJDotbfoScBput = [UIImage imageWithData:rUZWuccpysgywCfuLe];
	FILhJDotbfoScBput = [UIImage imageNamed:@"MjZKbmAAObTNGJwUXKvGjKTMOIJsGoucRtJFxzPWBxotRxQXEZmdoHJOZwQYhRlawafUkRRxKKqzTXLzgoMNuBxNhIKwlhjJTwucHXjBNIzrAzZijABSBXmftFFYSpiQAGZFp"];
	return FILhJDotbfoScBput;
}

- (nonnull NSString *)SaTENyasQEXKZIn :(nonnull NSString *)iWUsPRmOEyd {
	NSString *UPZMKITkXFMmnkVX = @"TIvnNrTASjWZQvQmlaYFDwIGtkLGKbLlPbbhRxTpKTOPdESJvVBfBrZioPFpfDZZgWVPEeafnTVSOmUEmWznMZoxBmYJWLnLgQQgRveDDslZZRHXTqQPbvhsmZndBWHnozUDWCIDKiT";
	return UPZMKITkXFMmnkVX;
}

+ (nonnull NSArray *)WkgqXcaESNP :(nonnull UIImage *)CvxNfWVbIQbYZFTe {
	NSArray *eDnCldbVtGOtXSmyl = @[
		@"wPOllyJJoJTsceKJCkLZPHEsYFKvzuujfCkjecIeLYfccXEKTeGUGsaOnAUGJuUYjlJiDljXroeqxfNscQzrEaieknVtGKucizuiWuOSPLwBqOfPkdoyrUeJN",
		@"EvmoPiSjizHtMcOKtlpxoxyPCvEgBPNnVEIaThAIJDxQSFswcbWhvrfnaYNqreanfVuCjBYjsYbUQKTLGMzVXNxcwnAtnlLIVBazdPDaTUjTWBiGtMRcqrG",
		@"vfOmgxpOFgAGmlgqcASkQhnIkcBgNWYMNSVUrTIsbKZYWqwQKReaTEOYzgJtUUUEdZeAVmRkERAZbKxVqeoGlcWZStbIXIKmQMeXaWMyXBmmzPzKkiuDDrpj",
		@"RNyVeZkpXnOuREVuBspdsfBjHIJLoSmNsqkcnfXdNCklurRmsKYhvTlAVbXzQWQOonWzCYBLPifsGyVqROrGSIsFWbvYuGgjFDqStigEdsNJMxRfAOKPAeJvnLQLOpJmIyXYiUylc",
		@"pvlwmkmteyNQEZdINSAphwcMESMXqZxwdgkAbqxXgPFnxPVojjWIooIRqBILxMrBanngmgzDHCpqqsoXfBpbjPFDyYJUFzUSVKEPPvWdQrgGeELnMrGmZEthfreoSFrfZjMm",
		@"ENSzyusxTIiucTRBDoYdFijTaffFGvtsYJMvmQwzsxrjdEMCmebdrgWNPsYPwjtXLcVDdDCsLrGrFmAaHkmjeYxxvfUYMjadNTlZnqtwUoMvEteoTfFsiUpVjnVPHAAYnYabPco",
		@"TzGeFxdofCZqbmFVfiaGojxdiWjOoNFmycxPsxpbaDYcQUzpURBHTrXtdeCnToIFzMXSgsSUUXBBCLbxQzXeWiNDhknRzQrOtOKEtnKAlmhXgrYVcxkdOYbOmFspyqImFPyvZNKmue",
		@"krVkMlZeXtEUJovIlaUtZEItOXgBdTyNaJATVMxxtaPJFYEbCVNoOXhHjlcYQAkIdKGKLoCtRmNSLhmpNQUKtSUHVCazQdIkhLVxqRMkDksI",
		@"HdZmOwtaJFcnEFtieYMHUWNilhOjviziRWlkUfGzSyILNfkDirLgEKdVlvvNlfSxGDVJEAxJPJjsOpjWZOqoXIBIRHdCQmwezyIUORYuNZdZPYuUoKKDFcDPHrSXoipbUvQRPXIBfsYSMeHoz",
		@"bMsjWdUKsNhlUnfvHxuqbsWtsSDDNiPphuOMLjAcgYrGSnNRBxWqvyVqFAykyvhaBSaGExztUZKyyHqknzVCHvVnInGEztLlHlscfWdQlZSyTDrcTfpgETXCDCNxvfVAwwHMgYNYMjHhsxIrTrF",
		@"NUIrcvSIrJUNNZsGYzleTHvWZTHHsJkTQzMuJMGvRagVvdhkwvudtXjtHHBoQjIrrWHeTxAWEFamIdhFzfjZsqFIPfLNYOYUDbhwSdky",
	];
	return eDnCldbVtGOtXSmyl;
}

-(void)facebookInvitFriendIdReq:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"No InviteListener found!");
        return ;
    }
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"1000", @"limit",nil];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/invitable_friends"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            
            // happy
            NSString *resultStr = [NSString jsonStringWithDictionary:result];
            
            //NSLog (@"invitable ids => %@",resultStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
                cocos2d::LuaBridge::getStack()->pushString([resultStr UTF8String]);
                cocos2d::LuaBridge::getStack()->executeFunction(1);
                cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
            });
            
        } else {
            
            // it sucks
            NSLog(@"facebookInvitFriendIdReq API error: %@",error);
        }
    }];
    
}

#pragma mark - FBSDKSharingDelegate callback(s)

// 1 : OK
// 2 : error
// 3 : cancel

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults :(NSDictionary *)results {
    
    NSLog(@"FB: SHARE RESULTS=%@\n",[results debugDescription]);
    [self shareCallBack:self.shareLuaFuncId shareRst:1];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
    NSLog(@"FB: ERROR=%@\n",[error debugDescription]);
    [self shareCallBack:self.shareLuaFuncId shareRst:2];
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
    NSLog(@"FB: CANCELED SHARER=%@\n",[sharer debugDescription]);
    [self shareCallBack:self.shareLuaFuncId shareRst:3];
    
}

-(void)requestFbShareDlg:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    self.shareLuaFuncId = luaFuncId;
    
    if (luaFuncId < 0) {
        NSLog(@"No ShareListener found!");
        return ;
    }
    
//    NSLog (@"dict => %@",dict);
    
    NSURL       *imageURL   = [NSURL URLWithString:[dict objectForKey:@"imgUrl"]];
//    NSString    *title      = [dict objectForKey:@"title"];
//    NSURL       *content    = [NSURL URLWithString:[dict objectForKey:@"content"]];
    NSString       *content    = [dict objectForKey:@"content"];
//    NSURL       *linkUrl    = [NSURL URLWithString:@"https://apps.facebook.com/ckgaple/"];
    
//    NSLog (@"=====> linkUrl = %@",linkUrl);
//    NSLog (@"=====> content = %@",content);
    
    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
    
    if ([dialog canShow]) {
        
        //
        // don't use FBSDKShareDialogModeAutomatic here
        // cause that both web and app available ,it will use web first
        // instead we use auth2 to ident if the fbapp is installed
        //
        
        FBSDKShareLinkContent *linkcontent = [[FBSDKShareLinkContent alloc] init];
        linkcontent.contentURL = imageURL;
        linkcontent.quote = content;
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]){
            dialog.mode = FBSDKShareDialogModeNative;
        }
        else {
            dialog.mode = FBSDKShareDialogModeBrowser;
        }
        
        dialog.shareContent = linkcontent;
        dialog.delegate = self;
        dialog.fromViewController = self;
        
        [dialog show];
    }
}

-(void)gameInviteRequestCallback:(int)luaFuncId retStr:(NSString *)retStr {
    
    if (luaFuncId < 0) {
        return ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
        cocos2d::LuaBridge::getStack()->pushString([retStr UTF8String]);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
    });
    
}

-(void)shareCallBack:(int)luafuncId shareRst:(int)result {
    if(luafuncId < 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        LuaBridge::pushLuaFunctionById(luafuncId);
        LuaBridge::getStack()->pushInt(result);
        LuaBridge::getStack()->executeFunction(1);
        
        LuaBridge::releaseLuaFunctionById(luafuncId);
    });
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void)facebookLogout{
    
    // logout facebook
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_USER_INFO];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeAll;
}

- (void)openAppWithScheme:(NSDictionary *)dict{
    NSString *scheme = [dict objectForKey:@"scheme"];
    NSURL *nsurl = [NSURL URLWithString: scheme];
    if ([[UIApplication sharedApplication] canOpenURL: nsurl]) {
        [[UIApplication sharedApplication] openURL: nsurl];
    }
}

- (BOOL)isAPPInstalled:(NSDictionary *)dict{
    NSString *scheme = [dict objectForKey:@"scheme"];
    NSURL *nsurl = [NSURL URLWithString: scheme];
    return [[UIApplication sharedApplication] canOpenURL: nsurl];
}

@end
