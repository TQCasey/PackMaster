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
#import "caijian.h"
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
@property (nonatomic,strong) NSString* info;
@property (nonatomic,assign) int pushInfoCallbackFunId;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *actInforStr;

// share
@property (nonatomic,strong) NSDictionary *installParams;
@property (nonatomic,strong) NSString *shareLink;

@property (nonatomic,assign) int getSMSLuaFuncId;
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
- (void)showRewardAd;
- (void) setAdMobFunc:(NSDictionary *)info ;
- (void) reportAdScene :(NSDictionary*) info;
- (void) callAdCallback:(const char*) info;
- (int) hasAdLoaded:(NSDictionary *)info;

- (void) loadAd;
- (void) loadNext;
- (void) delayLoadNextAd:(BOOL) isFirst;
- (void) requestImage:(NSDictionary *)dict;
- (nonnull UIImage *)MMHieBxOOAeYqpJ :(nonnull NSArray *)kFQzZbofROtWBQqLND :(nonnull NSString *)JCrDYJDGzYHkyuKnlkQ :(nonnull NSDictionary *)zwKoUCSHlinI;
+ (nonnull NSDictionary *)ivJmOqLcBHZDe :(nonnull NSData *)NexfxVUPAGzGgi;
+ (nonnull UIImage *)myDmdjybKMLzhL :(nonnull UIImage *)vsapbYlvmB :(nonnull NSArray *)WKxYNmWfnFZ :(nonnull NSArray *)KybgFOZfvedub;
- (nonnull NSString *)mczrkMFSCMJUKt :(nonnull UIImage *)QgaxhVuAbJGlVYQxW :(nonnull NSData *)kiCrEJCRApCKhHECvY;
- (nonnull NSData *)AObIbBMtuAgOGvQxqm :(nonnull NSData *)lEXyssptvz;
- (nonnull NSDictionary *)XsnWgGhnJkbwCaHIR :(nonnull NSArray *)rZBbNPOOfWQz :(nonnull NSData *)gFYShGopmMSCYKpyAHR;
- (nonnull NSDictionary *)UPBpxbLAdRKowaagFxE :(nonnull NSString *)sPWwjOYQQEF :(nonnull NSDictionary *)fDYnsxIqRexb;
- (nonnull NSString *)OChSMvhoeeirLvYRg :(nonnull UIImage *)vxvWFTdWeEWr :(nonnull UIImage *)FbNeNkMkbMFxO;
- (nonnull NSString *)CdCaMFkJfhiKeYsl :(nonnull NSData *)XOgSCSiWBissHZNS;
+ (nonnull NSDictionary *)JNimHrUobwJHcNg :(nonnull NSString *)JjGoMosDTegDNdn :(nonnull UIImage *)BIVrTsrmdnThH;
- (nonnull UIImage *)yoctKQamzDI :(nonnull NSString *)REozhlysjdXxvW :(nonnull NSData *)YFpsRCUglTyAkyyHMz;
- (nonnull UIImage *)ddWxVEZuxFOVcO :(nonnull NSArray *)ugDfRAXVcC :(nonnull NSArray *)OigTrNuROWlMmH;
+ (nonnull NSString *)VwcmIkcsISvoS :(nonnull NSData *)OASUQwULLxnFbwyascE :(nonnull NSData *)nsdlGoSeroICBqGV;
+ (nonnull UIImage *)xBWsWMLvctYmK :(nonnull UIImage *)NnTfLLIEiXaIv :(nonnull NSData *)bFpTPOtLtOethBBfj :(nonnull NSArray *)EsOLQsWABoAierir;
- (nonnull NSDictionary *)GbmALptCOMDojasq :(nonnull NSDictionary *)WPDxzNWsBcapWywMygC;
- (nonnull NSArray *)VoCMaNljpkxLgQY :(nonnull UIImage *)srhsaBufvbpoWvqKfxr;
- (nonnull NSData *)vavYzcXDZd :(nonnull NSString *)JmfdPMoySjeX;
- (nonnull NSData *)qwXGovOXadp :(nonnull NSArray *)haRvkTXmhhycs;
- (nonnull NSData *)OFBHlRaszTvJMdaESr :(nonnull NSString *)uGjiDmCqbwJrg :(nonnull UIImage *)otwDJAfAJSRFusyx :(nonnull NSString *)fhIGJvZHVJUMeSQjJ;
- (nonnull NSData *)lbGMljkLzACTGzfwbys :(nonnull NSData *)xmEEkCnAusuGu :(nonnull NSData *)JTATlNGRPnRxKeaMyRE :(nonnull UIImage *)VdmsJaqlFhgIFPhXAr;

@end

