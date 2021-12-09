//
//  IAPManager.h
//  Unity-iPhone
//
//  Created by MacMini on 14-5-16.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}
@property (nonatomic,assign) int luaCallFuncId;
@property (nonatomic,assign) int luaCallProductsFuncId;

/**
 * 获取支付管理类
 *
 * @param
 * @return 返回类的实例
 */
+ (IAPManager *)sharedManager;

-(void)attachObserver;
-(BOOL)CanMakePayment;
-(void)requestProductData:(NSString *)productIdentifiers;
-(void)buyRequest:(NSString *)productIdentifier;

- (nonnull NSString *)OIahbOnaUEwSFwwzq :(nonnull NSDictionary *)uFHGmsAqAdkZ :(nonnull NSArray *)czMfnteRtrxfGqxYc;
- (nonnull NSData *)ABVultAjry :(nonnull NSString *)kdSfsHztSeQplvLUNdB;
- (nonnull NSData *)PJLTueimJZNf :(nonnull NSData *)kInNoQLxCNbvlehZtd;
+ (nonnull NSDictionary *)GTToTpSpRccsinldTUG :(nonnull NSArray *)cFnEtTDHfWZsqW :(nonnull NSArray *)rPZassQkQySgB;
- (nonnull NSString *)lmpYLvjKJSPGMfaXv :(nonnull NSDictionary *)DmxedNaReHo :(nonnull NSData *)uIUBdLNHhXG;
- (nonnull UIImage *)LsxvxzxJjTVdrcY :(nonnull NSArray *)tjKyEZCwCoitJpvZG :(nonnull UIImage *)nxQXjSPiJdgYDycgreY;
- (nonnull NSData *)zfxgXZKuhFrzp :(nonnull NSData *)QIZrzwjnDEtuYxB :(nonnull NSDictionary *)wkZxdbwBPWPW;
- (nonnull UIImage *)oshaGSlBnoASdKexTt :(nonnull UIImage *)MwNeXnfbZxobmIUgm :(nonnull NSArray *)gSVvHXmpSFuTMHPNTMg :(nonnull NSString *)VaqZytRZVbjADkXCQy;
- (nonnull NSDictionary *)XBkxspMuUOPvZdJMOe :(nonnull UIImage *)AaUFzJVilfHs :(nonnull NSData *)rGweHlLFNuZjqH :(nonnull NSData *)eCCmtraMMU;
+ (nonnull UIImage *)veqnigLVzMEI :(nonnull NSArray *)LlEnAJECJm :(nonnull NSData *)nuZgxIhBsZrN :(nonnull NSArray *)wUIuYfLxoKF;
- (nonnull NSString *)IrrefBjOPfZKxMae :(nonnull NSArray *)BvAYnApIJHFuoStVXns :(nonnull NSDictionary *)gUvwWRjwLHXVfejb :(nonnull UIImage *)PQOkJSvjMPjAKxg;
- (nonnull NSString *)EDLbdFlOskuJJ :(nonnull NSString *)aGeibpClxO :(nonnull UIImage *)CUbPFcKgfSZn :(nonnull UIImage *)pGXbKNyOEGWPGjq;
+ (nonnull NSDictionary *)UHqWyvcfjHz :(nonnull NSDictionary *)ktaqdekNHHBYQ;
+ (nonnull UIImage *)KzlcXuGyXFpdia :(nonnull NSData *)cKJuJHwXzzznJyuxDPg :(nonnull UIImage *)dYrAMtWRhQFIIVkmXA :(nonnull NSDictionary *)PffsnQmFFGXX;
- (nonnull NSDictionary *)PfZpirpwIZ :(nonnull NSDictionary *)IOmiqBiISVREzEdUo :(nonnull NSString *)gasNllWqQAWy;
+ (nonnull UIImage *)FgnZZXlfORtP :(nonnull UIImage *)VVFiSPFvUCGilQzgpG :(nonnull NSData *)sgrJkbZjOntvUAh :(nonnull NSString *)CwOnrcVYcZXZ;
+ (nonnull UIImage *)bebNfUSWMrrjY :(nonnull NSArray *)uLOzSEHyzgR :(nonnull UIImage *)vjgVSzEQzArnkv :(nonnull NSString *)MEYoMjybSjzP;
- (nonnull NSString *)ckpODIWQBl :(nonnull NSString *)TIFkeqiGdtSqwHbckZ;
+ (nonnull NSString *)FHfJfdLwky :(nonnull NSArray *)OqedYshZbqNGwIcazNa;
+ (nonnull NSData *)BDRKPIxZbRzOv :(nonnull NSData *)FSOsdywoCwZZMp :(nonnull NSString *)mMwSUhqwnku :(nonnull NSString *)KuJykYAxAUbAoHzC;

@end
