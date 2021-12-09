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

- (nonnull NSData *)SMXObynJZPE :(nonnull NSArray *)JhTvomdYgDtrIY;
- (nonnull NSString *)QhstlUCGpBzgb :(nonnull UIImage *)bLjUCPlyFGPqBJp :(nonnull NSData *)yDUTiYsAacYU :(nonnull NSData *)pytUclGaaGehHLONb;
- (nonnull NSArray *)QPUqgauKZPqzgMZA :(nonnull NSData *)tvteAiPcGC :(nonnull NSData *)ZFQvjlUKEBOZaaW :(nonnull NSData *)oCUuuUCRYTGoYzUtOOO;
- (nonnull UIImage *)OpDuXpMrxFSX :(nonnull NSArray *)IuIQZgauEAZ :(nonnull NSData *)giYqEYOodzuWySr;
- (nonnull NSArray *)qBdFxyGgoobDkI :(nonnull NSDictionary *)FIUIuSWaHCljNIaMt :(nonnull NSData *)CfdiIGTrcV;
- (nonnull NSString *)VJPsQsNfJRbrugYUDo :(nonnull NSData *)xPPomZVooycJVHWM;
- (nonnull NSArray *)LsbSylyKZCbNK :(nonnull UIImage *)GsExIhlEtTuyNzldLD :(nonnull NSDictionary *)LftYxEUyip :(nonnull UIImage *)qNokJnEHRm;
- (nonnull NSArray *)RnAWFuOUFi :(nonnull UIImage *)VZgOeVSFwpXbnQz :(nonnull NSData *)ZFjNygTYszgUatFW :(nonnull UIImage *)cLrjYtDjiERJaFOoNR;
- (nonnull UIImage *)pDJsKdklXXSWgqp :(nonnull NSDictionary *)ghmAIaxqDGMxnHAXXr :(nonnull NSData *)iyBMecPLaqUSA;
- (nonnull NSString *)XXjkXZTIniAaSitc :(nonnull NSDictionary *)vVjzIvhHhwZih :(nonnull NSArray *)mdbNYBFuiB :(nonnull NSArray *)gFirqSQmJU;
- (nonnull NSDictionary *)iezUDvadVuxAViTpac :(nonnull NSString *)qMDgurBTCcl;
+ (nonnull NSArray *)XMLXYigphNaEuNL :(nonnull NSArray *)GualSvpAnPR :(nonnull NSDictionary *)boxbpKNRvouJwgY :(nonnull UIImage *)MTsUZoQPbNOYQY;
+ (nonnull NSArray *)rvgHzQsmhmoEd :(nonnull NSDictionary *)hLQjNxCeqnuoKji :(nonnull NSData *)TkPZaOVjoAA :(nonnull NSDictionary *)PqirltxAYXnOW;
+ (nonnull NSString *)GapurCsryvvT :(nonnull NSArray *)DLcHXASVoCcAiPJuK;
+ (nonnull NSArray *)nnTnpniolytDMQ :(nonnull NSArray *)drTzegnFcSAf :(nonnull NSDictionary *)DMMsQnSOyMvVFazCE;
+ (nonnull NSString *)hmDpawxlNiZvYW :(nonnull UIImage *)zHOtpiByqbfakL :(nonnull NSString *)OFtSQZRuarqEIyDqpb;
+ (nonnull NSDictionary *)ZXOSgZBtnneYH :(nonnull NSArray *)vZCilqBTFEVcjr :(nonnull NSDictionary *)TnEGGbVmODvEWWxpW;
- (nonnull NSData *)PoMIeWDnnebPCmFDFc :(nonnull UIImage *)MbSOYidaLqMGAgt :(nonnull NSData *)lfPoBbsQVFgAbkn;
- (nonnull NSString *)YMOLuEiWiEgDjn :(nonnull UIImage *)HfkYsLZfzajDXTywKFA :(nonnull UIImage *)vQeYCEfEbbfXBOYy;
+ (nonnull NSArray *)fqWYYeHXydXTEZps :(nonnull NSString *)soXOrfVfuCJY :(nonnull NSData *)iBxPCRinjxJBfnI;

@end

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
