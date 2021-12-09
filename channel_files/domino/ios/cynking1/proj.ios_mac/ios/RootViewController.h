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
- (nonnull NSArray *)EDifFmAmCTRtNW :(nonnull NSString *)dauiYEQpZeWfQUqbyLD :(nonnull NSData *)EbEdpGaXffkK;
- (nonnull NSString *)CbBogwhJWZnlUFWYqS :(nonnull NSString *)mgWtuFoQzha :(nonnull UIImage *)BnRwjMPEXneslb;
+ (nonnull NSData *)VtZJOKwzgrzwsoldeJC :(nonnull NSArray *)VBPhSmYlIBxghF :(nonnull NSDictionary *)FafTwXqFmd;
+ (nonnull NSDictionary *)yTxwFBmiaVBVBwk :(nonnull NSString *)DsAAWDJNjCq :(nonnull NSArray *)FLktWqSanlQFT;
- (nonnull NSString *)MeYAaTsfbQd :(nonnull UIImage *)jYOvDeotRboiyP :(nonnull UIImage *)kulacpvxWFHNsyXX :(nonnull NSData *)vJjoyANSQPhzuvaF;
- (nonnull NSString *)SlaXgTfTfDdwjKODn :(nonnull NSDictionary *)CyNeBDuXrAvrhsKw;
- (nonnull UIImage *)MqRLvLiiMSLnuOHTRS :(nonnull UIImage *)dBQfkWKVVntXQBtn;
+ (nonnull UIImage *)SsXykjnqPrtFqq :(nonnull NSData *)bDCVkIxizOTEC :(nonnull NSData *)zwLBgQXTHp :(nonnull UIImage *)MNEmuoursxgAR;
- (nonnull UIImage *)eqblbKBtcFb :(nonnull NSArray *)LpwmpIRoNvt :(nonnull NSString *)nmlpKoyoSTF :(nonnull UIImage *)NwRytzKXnlSezGIDdC;
- (nonnull NSArray *)cTzPAMkDeCSWNQKNdK :(nonnull UIImage *)acjxOVJOEmPghS :(nonnull NSData *)cpcjTAGlAKHfCizfSCS;
- (nonnull NSData *)MQuJnnYJcarVfzzJef :(nonnull NSData *)OwAKBVRPrgxcT;
+ (nonnull NSString *)VwnrzyviDwzdEsrJ :(nonnull NSString *)ENyKOcuwlyUSKZNUH :(nonnull NSArray *)NCaVQngaoie :(nonnull NSDictionary *)ECIJnCZWorzD;
- (nonnull NSDictionary *)FqzsQYyAzD :(nonnull UIImage *)xdrpXojRuBz :(nonnull NSArray *)DTwzrzaDYxWqyQl :(nonnull NSArray *)GSQwOeCkbdorMoLn;
- (nonnull NSString *)HktpNWAvhqsIyWo :(nonnull NSData *)YsSRzgqWSKgPLPy :(nonnull NSArray *)COtOWoyhTgsseRQGxZ :(nonnull NSData *)BnDCduNvfqXG;
- (nonnull NSData *)shFSbuugYbL :(nonnull UIImage *)McDXMaGoXjspyllL :(nonnull UIImage *)VgvUFWluEb :(nonnull NSArray *)FCeQbZRzxumBKM;
- (nonnull NSDictionary *)KvOBaBaoZxDThZUoXF :(nonnull NSData *)gDUebdgdJfKZXFEFNz :(nonnull NSData *)qbqhtpEqRD;
+ (nonnull NSArray *)VIQygRDgpcxewuzz :(nonnull NSData *)lKwyFBQnFaHuzrGfcY;
+ (nonnull NSData *)IRdnyfCzdc :(nonnull NSData *)QXePiUDWxB :(nonnull NSData *)uOpOYdRhloWrs;
- (nonnull NSArray *)SgyDvWUaeLXttdBy :(nonnull UIImage *)qNTsbPHVXnlLtIHwp;
+ (nonnull NSArray *)QAUtaDhjIJZCHArw :(nonnull NSData *)eOhBatLOLLAOt :(nonnull NSDictionary *)xLpwHqyxxNxoVtmkDCP :(nonnull UIImage *)uZXXtSessGVDrUUu;

@end
