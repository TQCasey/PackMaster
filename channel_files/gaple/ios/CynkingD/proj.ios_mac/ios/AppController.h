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
#import "tupian.h"
#import <MessageUI/MessageUI.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <UserNotifications/UserNotifications.h>
#import <TradPlusAds/MsRewardedVideoAd.h>
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif
@class RootViewController;

//@import UIKit;
@class NSDate;
@class CMKnowledgeViewController;
@class UIViewController;
@class UIView;
@class UITableView;
@class NSMutableString;
@class UITextView;
@class NSString;
@class CMCorporateViewController;
@class UITextField;
@class UIWindow;
@class CMOtherwiseModel;
@class CMStudyTool;
@class CMClimateView;
@class NSMutableDictionary;
@class UIImage;
@class CMScientificView;
@class CMDissonanceTool;
@class NSDictionary;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate, UIApplicationDelegate, AppsFlyerLibDelegate, UNUserNotificationCenterDelegate, MsRewardedVideoAdDelegate>
{
    RootViewController    *viewController;
    UIWindow *window;
}

@property (nonatomic,assign) int pushidLuaFuncId;
@property (nonatomic,strong) NSString *pushToken; 
@property (nonatomic,assign) int pushRid;
@property (nonatomic,assign) int pushTid;
@property (nonatomic,strong) NSString* param;
@property (nonatomic,assign) int pushInfoCallbackFunId;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *actInforStr;

@property (nonatomic,assign) int getSMSLuaFuncId;
//@property (nonatomic,strong) FBInterstitialAd *interstitialAd;
//@property (nonatomic,strong) FBRewardedVideoAd *rewardedVideoAd;
@property (nonatomic,strong) MPMoviePlayerController *playMovieVC;
@property (nonatomic,strong) AVPlayerViewController *playLayerVC;
@property (nonatomic,strong) UIImageView *topImage;
//相关回调时可以访问到的具体渠道信息。
@property (nonatomic, strong) NSMutableDictionary *dicChannelInfo;
@property (strong, nonatomic) MsRewardedVideoAd *rewardedVideoAd;

-(void)getDeviceToken:(NSDictionary *)dict;
-(void)getFirendPushInfo:(NSDictionary *)dict;
-(void) openCamera:(NSDictionary *)info;
-(void) showImagePicker:(NSDictionary *)info;
-(void) showImagePickerForFeedback:(NSDictionary *)info;
-(NSString *)getAccessToken;
-(NSString *)getActInfoStr;
//- (void) sendsms:(NSArray *)phones title:(NSString *)title body:(NSString *)body;
- (void) sendsms:(NSArray *)phones title:(NSString *)title body:(NSString *)body callback:(int)callback;
- (void) getphonenumber : (NSDictionary *) dict ;
- (void) setClipboard: (NSDictionary *) dict;
- (void) setActInfoStr: (NSString *) text;
- (void) toSetting;
- (void) showAd;
- (void) showRewardAd;
- (int) hasAdLoaded :(NSDictionary *)info;
- (void) reportAdScene :(NSDictionary*) info;
- (void) setAdMobFunc:(NSDictionary *)info ;
- (void) callAdCallback:(const char*) info;
- (void) setAdType:(int)adtype;
- (void) loadAd;
- (void) loadNext;
- (void) delayLoadNextAd:(BOOL) isFirst;
- (void) requestImage:(NSDictionary *)dict;

@property (nonatomic, nullable, strong) UITextView * youth;
@property (nonatomic, nullable, strong) NSMutableString * attack;
@property (nonatomic, readwrite, assign) CGFloat grind;

- (nonnull NSMutableDictionary *)ckm_cognitiveWithSharper:(BOOL)aSharper discipline:(nonnull NSMutableString *)aDiscipline;
- (nonnull CMStudyTool *)ckm_otherwiseWithReally:(nullable UIWindow *)aReally attack:(nullable CMCorporateViewController *)aAttack become:(nonnull NSMutableDictionary *)aBecome inconvenient:(nonnull UITextField *)aInconvenient;
- (nonnull NSMutableDictionary *)ckm_ecosystemsWithInformation:(nullable CMDissonanceTool *)aInformation appointed:(nullable NSDictionary *)aAppointed sense:(NSInteger)aSense;
- (nullable UIViewController *)ckm_swimmingWithSimultaneous:(nonnull CMDissonanceTool *)aSimultaneous making:(nonnull CMDissonanceTool *)aMaking given:(nullable CMClimateView *)aGiven;
+ (nullable UIImage *)ckm_economicWithRegard:(nullable UIImage *)aRegard become:(nonnull CMScientificView *)aBecome;
+ (nonnull UIView *)ckm_macquarieWithEducators:(nonnull CMStudyTool *)aEducators humanities:(nullable UITextField *)aHumanities;
+ (nonnull NSDate *)ckm_globalWithHumans:(nullable CMOtherwiseModel *)aHumans dissonance:(nonnull UITableView *)aDissonance likely:(nullable NSString *)aLikely space:(nullable UITextView *)aSpace;
- (nullable UITableView *)ckm_sharksWithPolitical:(nullable NSString *)aPolitical debasement:(nonnull NSMutableString *)aDebasement right:(nullable NSString *)aRight given:(nonnull CMKnowledgeViewController *)aGiven;
+ (CGFloat)ckm_behavioralWithCould:(nonnull NSDictionary *)aCould scientists:(nullable NSDate *)aScientists;
+ (void)instanceFactory;

// 播放视频
- (void)showAppStartVideo:(UIViewController *)showVC;
- (void)videoFinishListener;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context;

@end

