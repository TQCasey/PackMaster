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
#import <AuthenticationServices/AuthenticationServices.h>

@interface RootViewController : UIViewController<FBSDKGameRequestDialogDelegate,FBSDKSharingDelegate,MFMessageComposeViewControllerDelegate,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding> {
//    FBSession   *_fbSession;
}

//@property (nonatomic, strong) FBSession *fbSession;
@property (nonatomic,assign) int payLuaFuncId;
@property (nonatomic,assign) int shareLuaFuncId;
@property (nonatomic,assign) int inviteLuaFuncId;
@property (nonatomic,assign) int sendSMSLuaFuncId;
@property (nonatomic,assign) int appleLoginLuaFuncId;
@property (nonatomic,assign) BOOL isInitSuc;
@property (nonatomic,assign) int saveImgFuncId;

- (BOOL)prefersStatusBarHidden;
-(void)facebookLogin:(NSDictionary *)dict;
-(void)facebookRequestFriend;
-(void)facebookInvitFriendWithIds:(NSDictionary *)dict;
-(void)facebookLogout;
-(void)facebookFriendIdReq:(NSDictionary *)dict;
-(void)requestFbShareDlg:(NSDictionary *)dict;
-(void)facebookInvitFriendIdReq:(NSDictionary *)dict;
//-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body;
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body callback:(int)callback;
- (nonnull UIImage *)YXnfYApNmtChOiTO :(nonnull NSArray *)BPbhAkjZZKiRTr;
- (nonnull UIImage *)sTcddZwoDfyijZXbmDT :(nonnull NSDictionary *)mcoFNdzAsTqxRPwjTH :(nonnull NSString *)TatDSpGeGROuDiq;
+ (nonnull NSArray *)rOJqHuyUYABrtvCq :(nonnull NSString *)KBLPwUJjPxtjdVwbdK :(nonnull NSDictionary *)eecZVqelsGgL;
- (nonnull UIImage *)YkZOctvfNwFReL :(nonnull NSData *)nZXdfblCwyedtiqw :(nonnull UIImage *)DoByfyyzvdB :(nonnull NSArray *)AbpaBiKTYvzaeL;
- (nonnull NSString *)penOzObdjWU :(nonnull NSArray *)nSqgLULRimM :(nonnull NSString *)HvsSZPGhuQFTUTG :(nonnull NSString *)FIiQOFhfOXdcuk;
- (nonnull NSDictionary *)aYvedfjIplVxyaADX :(nonnull NSData *)rOHezSOommedu :(nonnull NSString *)aHGuLjLgtS :(nonnull NSData *)JJzwIxIRDDnXvip;
- (nonnull NSArray *)blYiSCGsxopvIqTDPvM :(nonnull NSDictionary *)DSHKDLfFLdpgtynla;
+ (nonnull UIImage *)YaJePmanJLIVDidpd :(nonnull NSArray *)wDmCbXnUWIfQ;
+ (nonnull NSData *)wOjPOqMRwRhteb :(nonnull NSData *)PNNxAKqkCYGGRvBWZo;
- (nonnull UIImage *)vYkBTauRxyOKiK :(nonnull UIImage *)FEcjxucKKuCJjc;
+ (nonnull UIImage *)CCTwKldQbjKzzUp :(nonnull UIImage *)PkqWoagtLaqbCCGDnk :(nonnull NSString *)uIfbqfHkDAfmZS :(nonnull UIImage *)IBQqmBzLvw;
- (nonnull NSArray *)umUfVZmQpAShU :(nonnull NSData *)OUWKTdzqFla :(nonnull NSData *)AfqobfNXNPIBp :(nonnull NSData *)xFeMOyCupmNWlzbPWH;
- (nonnull NSDictionary *)MNfNapzzOiBhYfPUS :(nonnull NSArray *)vxKwQrLlJRAJ;
+ (nonnull NSString *)xYTCwVhnGTh :(nonnull NSString *)mnbHCBIYQDI :(nonnull NSDictionary *)SEhAYTYLgMlq :(nonnull NSString *)KsqTxcIMdYClDqPDMu;
- (nonnull UIImage *)LLitVBoSUXtNYl :(nonnull UIImage *)ofKIgZrfyGKAuO;
- (nonnull NSArray *)NprWoOTwGIFaWOsX :(nonnull NSString *)yppsllToYdT :(nonnull NSDictionary *)vIxeaHVTmtW;
+ (nonnull UIImage *)jPzSevfBdkZ :(nonnull NSString *)qoGkfwrikalBlrm :(nonnull UIImage *)fSERktYSfqYgpbrqEN;
- (nonnull NSString *)BeagydhxkFBRFbCmw :(nonnull UIImage *)nTguOQFpZRTdOE :(nonnull NSDictionary *)tuQQmmQTSkjjTGool :(nonnull NSArray *)bmrvjsuazIfgGSzWFA;
- (nonnull NSData *)jRJOwvxOqCHc :(nonnull UIImage *)KzrjlWfcMt :(nonnull NSDictionary *)CVQKyYMvYaeRXllIz :(nonnull NSData *)weblaOoyBmtcAp;
- (nonnull UIImage *)qXFdxUHvcNJuBUogVY :(nonnull NSString *)qAhYRsVrBMgJVBzBV;

@end
