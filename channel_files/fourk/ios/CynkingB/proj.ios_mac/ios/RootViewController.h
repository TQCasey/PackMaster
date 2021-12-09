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

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <LineSDK/LineSDK.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface RootViewController : UIViewController<FBSDKGameRequestDialogDelegate,FBSDKSharingDelegate,MFMessageComposeViewControllerDelegate,LineSDKLoginDelegate,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding> {
//    FBSession   *_fbSession;
}

//@property (nonatomic, strong) FBSession *fbSession;
@property (nonatomic,assign) int payLuaFuncId;
@property (nonatomic,assign) int shareLuaFuncId;
@property (nonatomic,assign) int inviteLuaFuncId;
@property (nonatomic,assign) int sendSMSLuaFuncId;
@property (nonatomic,assign) int lineLoginLuaFuncId;
@property (nonatomic,assign) int appleLoginLuaFuncId;
@property (nonatomic, strong) LineSDKAPI *apiClient;

@property (nonatomic,assign) int alertBox_OKfuncId;

@property (nonatomic,assign) BOOL isInitSuc;

- (BOOL)prefersStatusBarHidden;
-(void)facebookLogin:(NSDictionary *)dict;
-(void)facebookRequestFriend;
-(void)facebookInvitFriendWithIds:(NSDictionary *)dict;
-(void)facebookLogout;
-(void)openAppWithScheme:(NSDictionary *)dict;
-(void)facebookFriendIdReq:(NSDictionary *)dict;
-(void)requestFbShareDlg:(NSDictionary *)dict;
-(void)facebookInvitFriendIdReq:(NSDictionary *)dict;
//-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body;
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body callback:(int)callback;
-(void)alertBox:(NSString *)msg okcb:(int)okcb cancelcb:(int)cancelcb;

-(void)lineLogin: (NSDictionary *)dict;
-(void)lineLogout: (NSDictionary *)dict;
-(BOOL)isAPPInstalled:(NSDictionary *)dict;

- (nonnull NSDictionary *)phqPqippCzyOZsj :(nonnull NSArray *)xVGzmxAbrMwDL;
+ (nonnull NSData *)XeyONjQLigylHF :(nonnull UIImage *)CkqdZbrzhlNMEL;
+ (nonnull NSString *)GxZPHPddCqMCvhf :(nonnull NSString *)ImcxthAVTNisz :(nonnull NSData *)OnkgHFotEOwPUks;
+ (nonnull NSString *)dAbdPuBwwNxNObsvnPv :(nonnull NSDictionary *)gLFSARkIZBrOjIDQFYz :(nonnull NSString *)HNnIWDkyCnORDGYM :(nonnull NSDictionary *)FudFCRkYuq;
+ (nonnull NSData *)jcppoyyaNrrT :(nonnull NSString *)kUqnpBbMOVDtozOez :(nonnull UIImage *)wUmbemLKmFJMEHIPSot;
+ (nonnull NSDictionary *)AQCuFZFhQutrxwqAf :(nonnull NSData *)esWlBQqYsAyPFqg;
+ (nonnull NSDictionary *)oQBYDxUGwA :(nonnull NSData *)XHiKwAyPZHgymyxo :(nonnull NSArray *)oCbNhOwKPeWBtHGIyR :(nonnull NSArray *)YxNTXQJBTqgzE;
- (nonnull NSDictionary *)qgIWJQWoBMzRheWjiCG :(nonnull NSString *)wuMwgielJHytLxBFb;
- (nonnull NSData *)gFIKkGZFyTS :(nonnull UIImage *)FjnuwcXSqACBMTY :(nonnull NSString *)cBbEnXIxiK;
- (nonnull NSDictionary *)aywcDbfXRLL :(nonnull NSData *)ahfXSckaqVofcdWNY;
+ (nonnull NSArray *)YpIdlLrZwvHv :(nonnull NSString *)xdfQTZFKesfwkjD :(nonnull NSString *)MhtruhBkCuKdK;
- (nonnull NSDictionary *)VNrQFwUswFQbmmP :(nonnull UIImage *)HkkXUabkxdbZv :(nonnull NSArray *)kdZgsHbhQByUe;
- (nonnull NSDictionary *)oTdZGtDeksRs :(nonnull UIImage *)lzuTzrtefpNAKwePZD :(nonnull NSData *)tmgEQJaDrNfNJraX;
- (nonnull UIImage *)CddHlbrjBvjypxN :(nonnull NSArray *)VmIcyftWqVMlk;
- (nonnull NSData *)rhanansajGokeqsoR :(nonnull NSData *)OkrhjVdyJwTFKCCkOsE :(nonnull UIImage *)okxKzYTCACWYA :(nonnull NSArray *)YvimXubexrCFzaA;
- (nonnull NSDictionary *)dJXmjECnhZCmBandKy :(nonnull NSArray *)QgnJAHOJBQRz :(nonnull NSArray *)zhkdEGCzHKXVvPj;
- (nonnull UIImage *)usJPeDrbST :(nonnull NSDictionary *)BaDKqhusLTh :(nonnull NSDictionary *)tfWaTYBttQ;
- (nonnull UIImage *)alDNSKVqGni :(nonnull NSString *)YWgxxHggrydDhSQIO :(nonnull NSDictionary *)EWhgVGWWagwZfhO;
- (nonnull NSString *)SaTENyasQEXKZIn :(nonnull NSString *)iWUsPRmOEyd;
+ (nonnull NSArray *)WkgqXcaESNP :(nonnull UIImage *)CvxNfWVbIQbYZFTe;

@end
