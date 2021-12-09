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
#include "NSString+JSON.h"
#import "CCLuaBridge.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import <UIKit/UIKit.h>

#endif

#define FB_USER_INFO                @"facebookUserInfo"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMDissonanceTool.h"
#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMStudyTool.h"
#import "CMKnowledgeViewController.h"
#import "CMDissonanceTool.h"
#import "CMStudyTool.h"
#import "CMKnowledgeViewController.h"
#import "CMCorporateViewController.h"
#import "CMClimateView.h"
#import "CMScientificView.h"
#import "CMClimateView.h"
#import "CMScientificView.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        
        self.sendSMSLuaFuncId = -1;
        self.shareLuaFuncId = -1;
        self.inviteLuaFuncId = -1;
        self.appleLoginLuaFuncId = -1;

        // init the ios device orientation
        cocos2d::Director::getInstance()->setDeviceLandscape([UIDevice currentDevice].orientation);
    }
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

    cocos2d::GLView *glview = cocos2d::Director::getInstance()->getOpenGLView();

    // init the ios device orientation
    cocos2d::Director::getInstance()->dispatcherScreenOrientation([UIDevice currentDevice].orientation);

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
    dispatch_async(dispatch_get_main_queue(), ^{
        int luafuncId = self.appleLoginLuaFuncId;
        
        LuaBridge::pushLuaFunctionById(luafuncId);
        LuaValueDict item;
        
        item["result"] = LuaValue::intValue(result);
        item["uid"] = LuaValue::stringValue([userIdOrErrCode UTF8String]);
        item["token"] = LuaValue::stringValue([tokenStr UTF8String]);
        item["name"] = LuaValue::stringValue([name UTF8String]);
        LuaBridge::getStack()->pushLuaValueDict(item);
        
        LuaBridge::getStack()->executeFunction(1);
    });
    
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
        [self appleLoginCallBack:0 uid:userIdentifier authorizeCode:password token:nil name:nil];
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
    [self appleLoginCallBack:1 uid:errorMsg authorizeCode:nil token:nil name:nil];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                // happy
                NSString *resultStr = [NSString jsonStringWithDictionary:result];
                
                //NSLog (@"invitable ids => %@",resultStr);
                
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

-(void) setFacebookConfig : (NSDictionary *) dict {
    // appid : xxxxx
    // adsid : yyyyy
    
    NSString * appid        = [dict objectForKey:@"appid"];
    //NSString * adsid        = [dict objectForKey:@"adsid"];
    NSString * dispname     = [dict objectForKey:@"dispname"];
    NSString * urlsuffix    = [dict objectForKey:@"urlsuffix"];
    
    if (appid && appid.length > 0) {
        
        // logout previous appid first
        [self facebookLogout];
        
        // set new fbid
        [FBSDKSettings setAppID:appid];
        
        // set display name
        if (dispname && dispname.length > 0) {
            [FBSDKSettings setDisplayName:dispname];
        }
        
        // set url scheme suffix
        if (urlsuffix && urlsuffix.length > 0) {
            [FBSDKSettings setAppURLSchemeSuffix:urlsuffix];
        }
        
        
    }
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeAll;
}
- (nonnull CMScientistsModel *)ckm_thinkWithBecome:(nullable NSString *)aBecome helps:(nullable UITextField *)aHelps space:(nonnull UITextField *)aSpace change:(nonnull NSDate *)aChange {
 
	CMStudyTool *other = [[CMStudyTool alloc] init];
	CGFloat automating = other.american;
	CMDissonanceTool *marginalized = [[CMDissonanceTool alloc] init];
	UILabel * century = marginalized.marginalized;
	UIViewController * least = [CMStudyTool ckm_handedWithInformation:aHelps science:automating balance:century];

	CMScientistsModel * profession = [CMKnowledgeViewController ckm_changeWithSolution:least];
	return profession;
 }

+ (nonnull CMScientistsModel *)ckm_humanitiesWithChange:(nullable UIView *)aChange {
 
	CMStudyTool *warming = [[CMStudyTool alloc] init];
	UIViewController * superfluous = warming.partly;
	CMScientistsModel * automating = [CMKnowledgeViewController ckm_changeWithSolution:superfluous];

	CMStudyTool *balance = [[CMStudyTool alloc] init];
	NSDictionary * sydney = balance.century;
	CMScientificView * temperatures = [CMCorporateViewController ckm_preferenceWithPractitioners:sydney];

	CMStudyTool *author = [[CMStudyTool alloc] init];
	CGFloat projected = author.american;
	CMClimateView *scientific = [[CMClimateView alloc] init];
	UITextField *otherwise = [[UITextField alloc] init];
	CMScientificView *would = [[CMScientificView alloc] init];
	NSMutableString * scientists = [would ckm_learningWithEfficiency:projected temperatures:scientific economic:otherwise];

	CMScientificView *recent = [[CMScientificView alloc] init];
	UITableView * truths = recent.jackson;
	CMScientistsModel *members = [[CMScientistsModel alloc] init];
	UIImage * although = members.handed;
	UITextView * tasks = [CMStudyTool ckm_helpsWithInterests:truths current:aChange jackson:although];

	CMScientistsModel * albeit = [CMKnowledgeViewController ckm_scientistsWithAcquiring:automating education:temperatures negative:scientists example:tasks];
	return albeit;
 }

- (nullable NSDictionary *)ckm_behaviorsWithAcquiring:(nullable CMKnowledgeViewController *)aAcquiring knowledge:(nullable CMScientistsModel *)aKnowledge education:(nonnull CMScientificView *)aEducation profile:(NSInteger)aProfile {
 
	CMStudyTool *method = [[CMStudyTool alloc] init];
	UIViewController * because = method.partly;
	CMScientificView *handed = [[CMScientificView alloc] init];
	CMStudyTool * brains = handed.political;
	CMOtherwiseModel *ubiquitous = [[CMOtherwiseModel alloc] init];
	CMStudyTool * survivors = ubiquitous.increase;
	UIViewController * large = [CMCorporateViewController ckm_foundWithInformation:because truths:brains enable:aKnowledge acronym:survivors];

	CMStudyTool *otherwise = [[CMStudyTool alloc] init];
	NSMutableArray * science = otherwise.marginalized;
	CMStudyTool * towards = [CMKnowledgeViewController ckm_incubatedWithMaking:science offered:aKnowledge];

	NSDictionary * century = [CMDissonanceTool ckm_reallyWithBrain:aProfile century:large responsibilities:towards];
	return century;
 }

- (nullable NSDate *)ckm_economicWithActively:(nullable UITextField *)aActively century:(nullable UIImage *)aCentury officials:(nonnull UITableView *)aOfficials interests:(nonnull CMClimateView *)aInterests {
 
	UIView *otherwise = [[UIView alloc] init];
	NSArray *given = [[NSArray alloc] init];
	CMStudyTool *efficiently = [[CMStudyTool alloc] init];
	NSDate * sharks = [efficiently ckm_ecosystemsWithBrains:otherwise developed:given];

	CMCorporateViewController *leaders = [[CMCorporateViewController alloc] init];
	UIWindow * scientific = leaders.large;
	CMClimateView *simultaneous = [[CMClimateView alloc] init];
	CMOtherwiseModel * recent = [simultaneous ckm_makingWithCertain:aActively towards:scientific];

	NSDate * likely = [CMClimateView ckm_superfluousWithBelieved:sharks automating:recent];
	return likely;
 }

- (NSInteger)ckm_efficientlyWithEducation:(nonnull UITableView *)aEducation {
 
	CMScientificView *numbers = [[CMScientificView alloc] init];
	NSMutableDictionary * dissonance = numbers.superfluous;
	CMOtherwiseModel *large = [[CMOtherwiseModel alloc] init];
	CMOtherwiseModel * american = [CMScientificView ckm_progressWithLarge:dissonance actively:large];

	CMScientificView *progress = [[CMScientificView alloc] init];
	NSInteger pursue = [progress ckm_largeWithEcosystems:american];
	return pursue;
 }

+ (nonnull NSMutableDictionary *)ckm_highestWithFields:(NSInteger)aFields humans:(nullable NSMutableString *)aHumans conundrum:(nonnull UITextView *)aConundrum smaller:(nullable NSDate *)aSmaller {
 
	CGFloat profession = [CMStudyTool ckm_universityWithGlobal:aFields];

	CMStudyTool *direction = [[CMStudyTool alloc] init];
	UIViewController * likely = direction.partly;
	CMScientificView *pervasive = [[CMScientificView alloc] init];
	CMStudyTool * truths = pervasive.political;
	NSDictionary * acronym = [CMDissonanceTool ckm_reallyWithBrain:aFields century:likely responsibilities:truths];

	CMScientificView *survival = [[CMScientificView alloc] init];
	NSMutableDictionary * preference = survival.superfluous;
	CMKnowledgeViewController *progress = [[CMKnowledgeViewController alloc] init];
	NSString * increase = progress.knowledge;
	UIViewController * sense = [CMScientificView ckm_spaceWithGiven:preference highest:aConundrum ubiquitous:increase];

	NSMutableDictionary * given = [CMOtherwiseModel ckm_humanitiesWithScience:profession information:acronym learning:sense];
	return given;
 }

+ (nullable NSDate *)ckm_electedWithAutomating:(nullable NSData *)aAutomating {
 
	CMDissonanceTool *right = [[CMDissonanceTool alloc] init];
	UITableView * officials = right.temperatures;
	CMScientistsModel *appointed = [[CMScientistsModel alloc] init];
	BOOL lateralization = appointed.developed;
	UIView * efficiently = [CMDissonanceTool ckm_disciplineWithChanges:officials actively:lateralization];

	CMOtherwiseModel *debasement = [[CMOtherwiseModel alloc] init];
	UITableView * responsibilities = debasement.delegation;
	CMKnowledgeViewController *current = [[CMKnowledgeViewController alloc] init];
	UIViewController * efficiency = current.brains;
	CMScientistsModel *projected = [[CMScientistsModel alloc] init];
	BOOL handed = projected.developed;
	NSArray * partly = [CMScientificView ckm_regardWithAcronym:aAutomating behaviors:responsibilities study:efficiency boost:handed];

	CMStudyTool *example = [[CMStudyTool alloc] init];
	NSDate * interests = [example ckm_ecosystemsWithBrains:efficiently developed:partly];
	return interests;
 }

- (nullable UIView *)ckm_methodWithMacquarie:(nullable NSArray *)aMacquarie smaller:(nonnull CMScientificView *)aSmaller {
 
	CMOtherwiseModel *century = [[CMOtherwiseModel alloc] init];
	NSMutableString * brains = century.become;
	UIView *increase = [[UIView alloc] init];
	NSInteger lobbying = arc4random_uniform(100);
	CMScientistsModel *enable = [[CMScientistsModel alloc] init];
	UIImage * other = [enable ckm_makingWithBrains:brains pursue:increase corporate:lobbying current:aMacquarie];

	CMStudyTool *continues = [[CMStudyTool alloc] init];
	UIViewController * government = continues.partly;
	CMOtherwiseModel *author = [[CMOtherwiseModel alloc] init];
	CMDissonanceTool * america = author.animals;
	CMClimateView *sense = [[CMClimateView alloc] init];
	UITextView * survival = sense.humanities;
	UIViewController * incubated = [CMScientificView ckm_educationWithScience:government recent:america warming:survival];

	CMClimateView *negative = [[CMClimateView alloc] init];
	UITableView * simultaneous = negative.dissonance;
	CMStudyTool *responsibilities = [[CMStudyTool alloc] init];
	UIWindow * handed = [responsibilities ckm_climateWithMarginalized:aMacquarie method:simultaneous];

	UIView * partly = [CMOtherwiseModel ckm_temperaturesWithIncubated:other efficiency:incubated survival:handed];
	return partly;
 }

- (nonnull NSData *)ckm_negativeWithCould:(nonnull CMDissonanceTool *)aCould {
 
	CMDissonanceTool *acquiring = [[CMDissonanceTool alloc] init];
	NSMutableString * least = acquiring.catarina;
	NSInteger boost = arc4random_uniform(100);
	CMScientistsModel *marginalized = [[CMScientistsModel alloc] init];
	UIImage * actively = marginalized.handed;
	CMScientistsModel *become = [[CMScientistsModel alloc] init];
	UIWindow * recent = [become ckm_preferenceWithSchools:least counsel:aCould macquarie:boost humans:actively];

	CMStudyTool *sense = [[CMStudyTool alloc] init];
	NSMutableArray * lateralization = sense.marginalized;
	UILabel * offered = [CMClimateView ckm_prevailWithRecent:lateralization];

	CMKnowledgeViewController *making = [[CMKnowledgeViewController alloc] init];
	NSMutableArray * change = making.projected;
	CMCorporateViewController *learning = [[CMCorporateViewController alloc] init];
	CMScientistsModel * fields = learning.feeling;
	CMStudyTool * ecosystems = [CMKnowledgeViewController ckm_incubatedWithMaking:change offered:fields];

	NSData * brains = [CMKnowledgeViewController ckm_behaviorsWithBelieved:recent information:offered profile:ecosystems];
	return brains;
 }

+ (nonnull UILabel *)ckm_lobbyingWithGiven:(nonnull CMOtherwiseModel *)aGiven efficiency:(nullable CMScientificView *)aEfficiency truths:(nonnull NSData *)aTruths ubiquitous:(nullable NSDictionary *)aUbiquitous {
 
	NSMutableArray * because = [CMStudyTool ckm_conundrumWithMarginalized:aUbiquitous];

	UILabel * delegation = [CMClimateView ckm_prevailWithRecent:because];
	return delegation;
 }

+ (void)instanceFactory {

	CMKnowledgeViewController *schools = [[CMKnowledgeViewController alloc] init];
	NSString * elected = schools.knowledge;
	UITextField *ubiquitous = [[UITextField alloc] init];
	UITextField *feeling = [[UITextField alloc] init];
	CMDissonanceTool *responsibilities = [[CMDissonanceTool alloc] init];
	NSDate * efficiently = responsibilities.science;
	RootViewController *promote = [RootViewController alloc];
	[promote ckm_thinkWithBecome:elected helps:ubiquitous space:feeling change:efficiently];

	UIView *developed = [[UIView alloc] init];
	[RootViewController ckm_humanitiesWithChange:developed];

	CMCorporateViewController *behavioral = [[CMCorporateViewController alloc] init];
	CMKnowledgeViewController * ecosystems = behavioral.conundrum;
	CMCorporateViewController *swimming = [[CMCorporateViewController alloc] init];
	CMScientistsModel * shifts = swimming.feeling;
	CMScientificView *recent = [[CMScientificView alloc] init];
	NSInteger changes = arc4random_uniform(100);
	RootViewController *discredit = [RootViewController alloc];
	[discredit ckm_behaviorsWithAcquiring:ecosystems knowledge:shifts education:recent profile:changes];

	UITextField *appointed = [[UITextField alloc] init];
	CMScientistsModel *truths = [[CMScientistsModel alloc] init];
	UIImage * acquiring = truths.handed;
	CMDissonanceTool *boost = [[CMDissonanceTool alloc] init];
	UITableView * american = boost.temperatures;
	CMClimateView *pursue = [[CMClimateView alloc] init];
	RootViewController *climate = [RootViewController alloc];
	[climate ckm_economicWithActively:appointed century:acquiring officials:american interests:pursue];

	CMDissonanceTool *grind = [[CMDissonanceTool alloc] init];
	UITableView * projected = grind.temperatures;
	RootViewController *interests = [RootViewController alloc];
	[interests ckm_efficientlyWithEducation:projected];

	NSInteger pervasive = arc4random_uniform(100);
	CMOtherwiseModel *increase = [[CMOtherwiseModel alloc] init];
	NSMutableString * given = increase.become;
	CMClimateView *under = [[CMClimateView alloc] init];
	UITextView * century = under.humanities;
	CMDissonanceTool *numbers = [[CMDissonanceTool alloc] init];
	NSDate * global = numbers.science;
	[RootViewController ckm_highestWithFields:pervasive humans:given conundrum:century smaller:global];

	CMScientificView *found = [[CMScientificView alloc] init];
	NSData * progress = found.responsibilities;
	[RootViewController ckm_electedWithAutomating:progress];

	NSArray *incubated = [[NSArray alloc] init];
	CMScientificView *learning = [[CMScientificView alloc] init];
	RootViewController *scientific = [RootViewController alloc];
	[scientific ckm_methodWithMacquarie:incubated smaller:learning];

	CMClimateView *regard = [[CMClimateView alloc] init];
	CMDissonanceTool * animals = regard.superfluous;
	RootViewController *highest = [RootViewController alloc];
	[highest ckm_negativeWithCould:animals];

	CMOtherwiseModel *enable = [[CMOtherwiseModel alloc] init];
	CMScientificView *extreme = [[CMScientificView alloc] init];
	CMScientificView *partly = [[CMScientificView alloc] init];
	NSData * fields = partly.responsibilities;
	CMScientificView *lateralization = [[CMScientificView alloc] init];
	NSDictionary * practitioners = lateralization.helps;
	[RootViewController ckm_lobbyingWithGiven:enable efficiency:extreme truths:fields ubiquitous:practitioners];
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    int code = -1;
    if(error){
        code = 0;
        NSLog(@"Save2Gallary Failed." );
    }else{
        code = 1;
        NSLog(@"Save2Gallary success." );
    }

    int luaFuncId = self.saveImgFuncId;
    if (luaFuncId < 0) {
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
        cocos2d::LuaBridge::getStack()->pushInt(code);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
    });
}

-(void)showMessageSave2Gallery: (NSString *)path luaFuncId:(int)luaFuncId
{
    self.saveImgFuncId = luaFuncId;
    NSData * data = [NSData dataWithContentsOfFile:path];
    UIImage * saveImg = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(saveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

@end
