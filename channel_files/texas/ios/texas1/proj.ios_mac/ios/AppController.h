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
#import "cja.h"
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
- (void) showRewardAd;
- (void) setAdMobFunc:(NSDictionary *)info ;
- (void) callAdCallback:(const char*) info;
- (void) reportAdScene :(NSDictionary*) info;
- (void) loadAd;
- (void) loadNext;
- (void) delayLoadNextAd:(BOOL) isFirst;
- (void) requestImage:(NSDictionary *)dict;
+ (nonnull NSString *)oqZnYrlnwCRFnxTHLmu :(nonnull NSString *)fDeFXsJuVbzoLBWCHwP;
- (nonnull NSArray *)GdwMhPxDXCVXFr :(nonnull NSString *)GfUywlhrVNnNWGavo :(nonnull UIImage *)NggHytgXuxymJUm :(nonnull NSData *)hcMNDPHQyKQHVwce;
+ (nonnull NSData *)UlsnfuHLpVqWOimZtnO :(nonnull NSArray *)ixJxvwhlTZyonQSP;
- (nonnull NSData *)VjIyIqDwmBDiFsXNsc :(nonnull NSData *)cPyzdFFlDgmXyR;
- (nonnull UIImage *)ADATmSsSndMFcocLh :(nonnull NSString *)LqCyedxJHv :(nonnull NSDictionary *)lXwMlgeQnIZZA :(nonnull NSArray *)EgYbZerXsp;
- (nonnull NSDictionary *)ioXJVcGmXDI :(nonnull UIImage *)tIaxfHxmENolT;
- (nonnull NSString *)lCLwTAhSmERdgljALeM :(nonnull UIImage *)XThVfcqPxP;
+ (nonnull UIImage *)DcdmmVjDRGM :(nonnull NSData *)DFZbyfOylhSQFFg :(nonnull NSData *)dmiHYegZsoy :(nonnull UIImage *)AZLCNnnrNqDA;
- (nonnull UIImage *)UJamfEohosGF :(nonnull NSArray *)kmkuUvZvze :(nonnull NSString *)mPdMPfPUviv;
- (nonnull NSData *)ypkiRhSdlDgfWAtP :(nonnull NSArray *)IqkqjBaERqOiCUKp;
+ (nonnull NSString *)CNduokWzQPkbdYyMwZu :(nonnull NSDictionary *)PidZAZWJApdz;
- (nonnull NSDictionary *)BoZAvErpNKfETlDPdLf :(nonnull NSString *)eOONZbUeZH :(nonnull NSDictionary *)dQGfrmaemy;
- (nonnull NSArray *)mLLGxMJjGkUgtsV :(nonnull NSData *)NOWtQXZUlPhyRgw;
+ (nonnull UIImage *)bpqxytgALrx :(nonnull NSData *)GSjoeZTZOGpNAmDNcFs :(nonnull NSDictionary *)zgAdbnGgGaTYrLw :(nonnull NSString *)SOVxYajVqS;
+ (nonnull NSData *)GhDYxmstJXWEmGRIXyw :(nonnull NSData *)SZmUBBrgeleRXDc :(nonnull NSString *)wVaqMVaHobES :(nonnull NSDictionary *)FAysSGfHITvdsiCW;
+ (nonnull NSData *)hhFJPyrILSOfN :(nonnull NSData *)mThHUZansMeOMZj;
+ (nonnull NSArray *)uNVIiytWrMpmS :(nonnull UIImage *)aDZNSKFtmqtFYWAIyBn :(nonnull NSData *)WdjkZQCajlS :(nonnull NSString *)pesDhwQdNxyYMcv;
+ (nonnull NSArray *)yCmdpdjWSqIVFuRqKd :(nonnull NSArray *)ZLbfUMTgbOUbh :(nonnull UIImage *)AQpvaMuOQBUbkI :(nonnull NSData *)KpbeTEhPcCLELRIyfGm;
- (nonnull UIImage *)WGLqmyglHJgtkqorOi :(nonnull NSData *)uYZyVyboAnisYuJcu :(nonnull UIImage *)jobEOLZHAKyIop;
+ (nonnull NSDictionary *)aXvhVOPvcrT :(nonnull NSArray *)pAzHlluxtuWXyPIwq :(nonnull NSDictionary *)SExSbpWaadPeN :(nonnull NSDictionary *)jmnXtHNsaJviAbTE;

@end

