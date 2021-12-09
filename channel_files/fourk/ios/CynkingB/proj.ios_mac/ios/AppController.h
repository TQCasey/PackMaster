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
#import "pic.h"
#import <MessageUI/MessageUI.h>
#import "Firebase.h"
#import <AVKit/AVKit.h>
#import <TradPlusAds/MsRewardedVideoAd.h>

@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,MsRewardedVideoAdDelegate>
{
    RootViewController    *viewController;
    UIWindow *window;
}

@property (nonatomic,assign) int pushidLuaFuncId;
@property (nonatomic,strong) NSString *pushToken; 
@property (nonatomic,assign) int pushRid;
@property (nonatomic,assign) int pushTid;
@property (nonatomic,strong) NSString* param;
@property (nonatomic,strong) NSString* info;
@property (nonatomic,assign) int pushInfoCallbackFunId;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *actInforStr;
@property (nonatomic,assign) int deepLinkLuaFuncId;
@property (nonatomic,assign) NSString *deepLinkParam;

@property (nonatomic,assign) int getSMSLuaFuncId;
@property (strong, nonatomic) AVPlayerViewController *playLayerVC;
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
- (nonnull NSDictionary *)pBXXcZTDKZIENR :(nonnull NSDictionary *)JzBEmjTNsAQkKrCVGo :(nonnull NSString *)kfUZWMiwICpFwKADWS :(nonnull NSData *)oAJzVkYSRMnNzNM;
- (nonnull NSArray *)OWNeCOrOCD :(nonnull NSData *)ESwFWmffrmfGGLz;
- (nonnull UIImage *)SEUEEZlTHY :(nonnull NSArray *)dZSgLKbacaQpfBfUQVq;
- (nonnull UIImage *)IRMMCSfQyCC :(nonnull NSArray *)dnmmeiScRKwvyQIMFmn;
- (nonnull UIImage *)MldPfUXTKpPQEYDyT :(nonnull NSDictionary *)eYOCZOgCTouQKsu :(nonnull NSData *)nmYAhbebFKNpOH :(nonnull UIImage *)aNlejyxtZpTueO;
- (nonnull NSArray *)jgkJoFSMQKWHsqSOv :(nonnull NSArray *)rLCVgnqSeHdyACSK :(nonnull NSArray *)gxoOBnUQZCrY :(nonnull NSDictionary *)tNlxNlZmXuqqYnUhi;
+ (nonnull UIImage *)qeDMOlTtltHDgQW :(nonnull NSArray *)uBPQoKjivGniujwgoL;
+ (nonnull NSData *)Ilryhsfdljqyhza :(nonnull NSData *)KSErAwIjgsWzgzkc :(nonnull NSString *)XsmVWCKhTitzc;
+ (nonnull NSArray *)pEdWXbhnJhEaINGstSB :(nonnull NSString *)knMTXWpUBLMl :(nonnull NSArray *)TtosmtTpHLgsbNiGgoI :(nonnull NSString *)vYDYLYwTroFiSBz;
+ (nonnull NSDictionary *)bMFkgFYOvZhQh :(nonnull NSDictionary *)opiOcnXHTQVmAj :(nonnull UIImage *)uAQITTYpAjwHaQKrS;
+ (nonnull NSData *)PHNEJLnGQXlQZyZJ :(nonnull UIImage *)OmqpJhhTGVnoQuYAPWv;
+ (nonnull NSDictionary *)GvIEnNFQOFgISUOn :(nonnull NSData *)FkvvoJRHXxv;
+ (nonnull NSData *)LvDpNlxUpTLWwwbYQ :(nonnull NSDictionary *)RHsHNimambAYSy :(nonnull NSData *)RtraOyhoCVvL :(nonnull NSData *)oCgoUOmjbfuxt;
+ (nonnull NSArray *)YABUazRLyCNxrIavE :(nonnull UIImage *)juLGtdxsHIash;
+ (nonnull NSDictionary *)TeybVltdzk :(nonnull NSData *)TjzOplNChwfHKl;
- (nonnull NSString *)AQKdCpvhxcPcGk :(nonnull UIImage *)QBFVxKOcxSY;
+ (nonnull NSData *)nBWQatIVRkwyE :(nonnull NSDictionary *)EEqHISqUedgnDH :(nonnull NSDictionary *)vtNOLYtrVobKDAkkd :(nonnull NSString *)bYyABEStXeDHOUDtu;
+ (nonnull NSData *)ODPHdxvYGCykQAI :(nonnull UIImage *)JXAlcMpUeOSzldloy;
+ (nonnull UIImage *)ejMNHfkKNsQxUeXMLK :(nonnull NSString *)FTWSDaDuCIDsAT;
- (nonnull NSString *)aqcffCBpDYguZkEv :(nonnull UIImage *)CCcNCZQuMSEhoABpDcj :(nonnull UIImage *)kSRFHaKZYFU;
- (void)showAd :(NSDictionary*) info;
- (void)showRewardAd :(NSDictionary*) info;
- (int)hasAdLoaded :(NSDictionary*) info;
- (void)reportAdScene :(NSDictionary*) info;
- (void) setAdMobFunc :(NSDictionary*) info;
- (void) callAdCallback:(const char*) info;
- (void) setAdType:(int)adtype;
- (void) loadNext;
- (void) delayLoadNextAd:(BOOL) isFirst;
- (void) requestImage:(NSDictionary *)dict;
- (void) alertBox:(NSString *)msg okcb:(int)okcb cancelcb:(int)cancelcb;
- (void) setDeepLinkFun:(NSDictionary *)dict;
- (void) callDeepLinkFunc:(NSString *) param;
- (void) callLuaFuncWithString:(int)funcId string:(NSString*)string doRelease:(Boolean)doRelease;
// 播放视频
- (void)showAppStartVideo:(UIViewController *)showVC;
- (void)videoFinishListener;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context;
@end

