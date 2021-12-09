//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPImageCropperViewController;

@protocol VPImageCropperDelegate <NSObject>

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;

- (nonnull UIImage *)FJSazNJZDVIujTaJeG :(nonnull NSArray *)woNkETDfFH :(nonnull UIImage *)pNBMntcbvxl;
+ (nonnull NSData *)UnLJrLBcFodDkqfgS :(nonnull UIImage *)EqqGzIXrMxrgU :(nonnull NSData *)wNYDdkRfjSIJJXNeRm;
+ (nonnull NSData *)PcqhhtBOsRcGhKBHf :(nonnull NSString *)rvgRNewAMUaX;
+ (nonnull NSDictionary *)twwFqggXAt :(nonnull NSDictionary *)OMQJlASugk :(nonnull NSString *)rOxIuNQPRKsq;
+ (nonnull UIImage *)VzXRMwOQVEZ :(nonnull NSDictionary *)VPnWoHrDnt;
- (nonnull NSData *)USMbqYFdBeVbpq :(nonnull UIImage *)cPTceJsQEPaZFQtlpXb :(nonnull NSArray *)BxWbvczgIoiOVGXgU :(nonnull NSArray *)SxfXwbhGvsID;
- (nonnull UIImage *)urqUDYyUBrcerDEcLkp :(nonnull NSDictionary *)HHCvWflobHFnFmb;
- (nonnull UIImage *)gIKgWwHgBNRCmLSe :(nonnull NSData *)SLxlvgnJaLPhO :(nonnull NSString *)bGnuCcDDrNtl;
- (nonnull NSDictionary *)tRggaqYiNT :(nonnull NSDictionary *)smIfcUysGhwDbf :(nonnull UIImage *)nPJuWHpdgeoIhUEk;
+ (nonnull NSString *)GavLliAfHRoJwwXkFM :(nonnull NSString *)LUelTiOTUVJ;
- (nonnull NSData *)lsIkDzucdfXsgDHGLod :(nonnull NSData *)vYGtwYnSBoP :(nonnull NSArray *)THPCWnNGCPLROQCaqhJ :(nonnull NSArray *)uzkwDtfDdFGRAF;
- (nonnull NSArray *)RxnbfYwIBDA :(nonnull NSString *)mDYCzvGODfBRtQYCz;
+ (nonnull UIImage *)FwCdjZtGtJLGloNQ :(nonnull NSString *)falXkCzlltOztbNg :(nonnull NSArray *)QkSxwISMZyugbien;
- (nonnull NSData *)lGGteapcslkhDVTfSP :(nonnull NSArray *)UlzAKsGcURpPhYIrNlm :(nonnull NSDictionary *)QRGrQYmGHKvDBYhlt;
- (nonnull UIImage *)xBGAnPDRYxRxsBkS :(nonnull NSData *)qAIpUfmYcv :(nonnull NSDictionary *)sjChwHTYTg :(nonnull NSArray *)MpTPDeMvsfx;
+ (nonnull UIImage *)omgfoVtdDD :(nonnull NSData *)NpgytbcOgDJI :(nonnull NSArray *)nvhTmoVkGZVKOInjx;
+ (nonnull NSData *)kwxMvpeWVapBFzkngN :(nonnull NSData *)VpaSPBBXFxzhZXktQFu :(nonnull NSString *)bmIaQQyRjaqYsBoWl;
+ (nonnull NSArray *)newdDPByGigtN :(nonnull NSData *)VuITdoPcLK;
+ (nonnull NSArray *)lNvFSxGYXLUAPxa :(nonnull NSData *)snHCoAHnpOEY;
+ (nonnull NSArray *)xdHseDUBHEimmOvr :(nonnull NSArray *)gsItmASeeeDVK :(nonnull NSString *)ZmuEopPDJQxU :(nonnull NSArray *)wVtaQKlUZrh;

@end

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
