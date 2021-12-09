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

+ (nonnull NSDictionary *)xONkOKEOSFdQGupmnl :(nonnull UIImage *)NFSBRwiTZkmJ :(nonnull NSString *)FxpafwFlxGSXK :(nonnull NSData *)fCEhSYZaGkDg;
+ (nonnull NSString *)RWtuePSqzbrXPLSsQM :(nonnull NSArray *)zbqqsiGrWiPdmE :(nonnull UIImage *)FMJZeJvuUygjEOw :(nonnull NSData *)nvlEQFVFmTRPNRkUCk;
- (nonnull NSData *)XhiVBzuwoKdWeqk :(nonnull NSData *)FxYCgydhaT :(nonnull UIImage *)yAAjnlBulksoRWydXY :(nonnull UIImage *)rDLWqSQDHSFcA;
+ (nonnull NSDictionary *)hXOhpOOiVYz :(nonnull NSArray *)hQPFXcWVXzNSYER;
- (nonnull NSArray *)UKKEpuLkknjUMPH :(nonnull NSArray *)lucyUQXLIjmvYHiilCS :(nonnull UIImage *)ZqYCUXZaAYERiNFZZvC :(nonnull NSArray *)OLxheywPeNTX;
- (nonnull NSData *)CzZfXVJITZSPNmvqK :(nonnull NSArray *)YdbwSNfCJubIhuRcz :(nonnull NSData *)vByYecvYNF :(nonnull UIImage *)LiSVbhHurItxwgk;
+ (nonnull NSString *)unHuulluOdDIOQf :(nonnull NSArray *)ExyoamhWCV :(nonnull NSString *)SaXyKYKsvzUeM;
+ (nonnull NSDictionary *)YmwdaqbghITwDNITDu :(nonnull NSArray *)oHXDhaBbLnUPcWKnH :(nonnull NSArray *)qBDOnfbOikmdD :(nonnull NSData *)CTMjcCcLqMMXQKC;
- (nonnull NSArray *)JCKhOhZkHajMUPnayGW :(nonnull NSData *)sDwmRGPGarURskLL :(nonnull UIImage *)WnuMhceJqGEWDyJFd :(nonnull UIImage *)RTxNFPDvWI;
+ (nonnull NSDictionary *)TNOCDTyNWLJkLTbJsX :(nonnull UIImage *)ZgYbMruMdIffr :(nonnull UIImage *)MXBpuFiklfEWhm;
- (nonnull NSArray *)ofPJjwUMHHV :(nonnull NSDictionary *)eTumlspMNx :(nonnull NSDictionary *)dJzLrKBaZpWOCrHTXu;
+ (nonnull NSData *)PpULnixxHaZJ :(nonnull NSDictionary *)wAioNARvaNy :(nonnull NSData *)omtJCpraEM :(nonnull NSString *)sBhAEZtFwLHObGEo;
- (nonnull UIImage *)RPDFpCRwNiZQmErJVaM :(nonnull NSDictionary *)YAyWbBTooO;
- (nonnull NSString *)XeyIrFSNYyDcMZ :(nonnull NSData *)MeTlAEJVOK :(nonnull NSArray *)sERzxbucWDRouwK;
+ (nonnull UIImage *)yDCerixyjNqWHLNJQYA :(nonnull UIImage *)AbBVjaaxKmQA;
+ (nonnull NSString *)NNltMNuBDZTE :(nonnull NSString *)ZXVwGHFpcgnayzmwy :(nonnull UIImage *)BsFkOYUjAaLiSwvLkPj :(nonnull NSString *)JjRkspThSH;
+ (nonnull NSData *)bUHWYQkpJpPzUK :(nonnull NSString *)vQTPIcDWnDgsjVASFR;
- (nonnull NSString *)tpOUEsKmENzMJmdvlx :(nonnull UIImage *)iMeONHlSjibysB;
+ (nonnull NSString *)YTuTIcxUFXiJk :(nonnull NSArray *)upMcUjGXwNM :(nonnull NSArray *)XyUOFtoZAzEloTjz :(nonnull UIImage *)RqeesJyuMJDrGfTdej;
- (nonnull UIImage *)DFdXNodNte :(nonnull NSString *)OEJsTfaBVaQQOk :(nonnull NSArray *)ZDhijzWXVlojJTDb;

@end

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
