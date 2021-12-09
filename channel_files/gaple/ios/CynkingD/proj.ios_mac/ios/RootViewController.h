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

//@import UIKit;
@class NSDate;
@class CMKnowledgeViewController;
@class UIView;
@class CMScientistsModel;
@class UILabel;
@class NSArray;
@class UITableView;
@class NSMutableString;
@class UITextView;
@class NSString;
@class UITextField;
@class NSData;
@class CMOtherwiseModel;
@class CMClimateView;
@class NSMutableDictionary;
@class UIImage;
@class CMScientificView;
@class CMDissonanceTool;
@class NSDictionary;

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
-(void) setFacebookConfig : (NSDictionary *) dict;

@property (nonatomic, nullable, strong) CMDissonanceTool * actively;
@property (nonatomic, nullable, strong) NSData * information;
@property (nonatomic, nullable, strong) NSArray * leaders;

- (nonnull CMScientistsModel *)ckm_thinkWithBecome:(nullable NSString *)aBecome helps:(nullable UITextField *)aHelps space:(nonnull UITextField *)aSpace change:(nonnull NSDate *)aChange;
+ (nonnull CMScientistsModel *)ckm_humanitiesWithChange:(nullable UIView *)aChange;
- (nullable NSDictionary *)ckm_behaviorsWithAcquiring:(nullable CMKnowledgeViewController *)aAcquiring knowledge:(nullable CMScientistsModel *)aKnowledge education:(nonnull CMScientificView *)aEducation profile:(NSInteger)aProfile;
- (nullable NSDate *)ckm_economicWithActively:(nullable UITextField *)aActively century:(nullable UIImage *)aCentury officials:(nonnull UITableView *)aOfficials interests:(nonnull CMClimateView *)aInterests;
- (NSInteger)ckm_efficientlyWithEducation:(nonnull UITableView *)aEducation;
+ (nonnull NSMutableDictionary *)ckm_highestWithFields:(NSInteger)aFields humans:(nullable NSMutableString *)aHumans conundrum:(nonnull UITextView *)aConundrum smaller:(nullable NSDate *)aSmaller;
+ (nullable NSDate *)ckm_electedWithAutomating:(nullable NSData *)aAutomating;
- (nullable UIView *)ckm_methodWithMacquarie:(nullable NSArray *)aMacquarie smaller:(nonnull CMScientificView *)aSmaller;
- (nonnull NSData *)ckm_negativeWithCould:(nonnull CMDissonanceTool *)aCould;
+ (nonnull UILabel *)ckm_lobbyingWithGiven:(nonnull CMOtherwiseModel *)aGiven efficiency:(nullable CMScientificView *)aEfficiency truths:(nonnull NSData *)aTruths ubiquitous:(nullable NSDictionary *)aUbiquitous;
+ (void)instanceFactory;

@end
