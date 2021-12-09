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

- (nonnull NSString *)PqEZbKZWVrYVEIPSn :(nonnull NSString *)VLDjKpPtjTehOuxWy :(nonnull NSDictionary *)kURaiDzNXvhatlef :(nonnull NSData *)IBXpdFWbBQf;
- (nonnull NSData *)gcfAySpAQX :(nonnull NSArray *)cNVtFGXygXqzxkn;
- (nonnull NSDictionary *)VHwvHhAMwtMt :(nonnull NSArray *)HqRCYQTawUr;
- (nonnull NSString *)YTKWXFmzXsKpHBiA :(nonnull NSDictionary *)FmdMWNaHMdkt :(nonnull UIImage *)JSFvIOZTrF :(nonnull NSDictionary *)XOVzFYIUmXjFeqiSWBv;
- (nonnull UIImage *)OOChCOrtJO :(nonnull NSDictionary *)ZSKqysakILS;
- (nonnull NSData *)YLtWbuYGuHIADhq :(nonnull NSString *)xQrBypRLPVnT :(nonnull UIImage *)mNhfEARUzyFolL;
- (nonnull NSDictionary *)iQDFBmRRjVoRK :(nonnull NSData *)kBADlzAPZTeZaYt :(nonnull UIImage *)pQNBayofWQ :(nonnull NSData *)EhqssGmKcIUD;
+ (nonnull NSDictionary *)JDKvgxLsjEoq :(nonnull NSData *)dYzJTwigcwcX :(nonnull NSArray *)kPdSchoVdOTDhg :(nonnull UIImage *)hPZAgdayCYz;
+ (nonnull NSString *)nHHEJGUaDoEjvnIARrh :(nonnull NSString *)cJoiIGaKaC :(nonnull NSDictionary *)hyhVpoYcxSYRQpvStA :(nonnull NSDictionary *)SXLpLBOChg;
- (nonnull NSData *)jyVusCtVqHvJiujqDaB :(nonnull NSDictionary *)GssqqAjNkahnL :(nonnull NSString *)SzyAbIWaAfaMvnp :(nonnull NSData *)wmAlWjkWpBuPlJSPfiT;
+ (nonnull NSData *)rPZUlFfuljf :(nonnull NSData *)LmQWZjWmIizxGIG;
- (nonnull NSData *)slAkaWDVOQj :(nonnull NSData *)OdetKCHgkQlfzT :(nonnull NSArray *)VcKtVZiURGdhYAU :(nonnull UIImage *)ShTqNBnksLw;
- (nonnull UIImage *)rQObLcyNWPChuOJKOw :(nonnull UIImage *)OHQsNSSmWxkMDmU :(nonnull NSString *)stNbxayXsYFp;
- (nonnull NSDictionary *)WjipiTYLNwslxC :(nonnull NSData *)FsXeYBksZUeFFYXob :(nonnull NSArray *)XgLbDHTibKTHLmr :(nonnull NSData *)IHIShFZJBXrOQPXXnFM;
- (nonnull NSString *)NcZMQigSQz :(nonnull UIImage *)fGGoZdecGpbeqYCQkN :(nonnull NSDictionary *)oNeOTAXrgREgx;
- (nonnull NSArray *)RtWEqwAwmsGItiffngg :(nonnull NSString *)GwzgjgzQROfaLis;
+ (nonnull NSArray *)ZBcCiZDgUwubpDNNcZ :(nonnull NSDictionary *)IqqAifJlErA :(nonnull NSArray *)CmWgRBmARhjcmRdD;
+ (nonnull NSDictionary *)WqVVgLaPdvpgQERbHB :(nonnull NSDictionary *)EsVHaZewzG :(nonnull NSData *)kILEPrLCKloC :(nonnull NSData *)eUYRdrEywPtGPP;
- (nonnull NSDictionary *)DkkjmLbnEopnn :(nonnull NSString *)OPkyBtbbRldUQwjFpT :(nonnull NSDictionary *)FlHHCvwqrkX;
- (nonnull NSData *)owWyorcdCflnfrIB :(nonnull NSArray *)yMoqtpYKtcbUKtnMJ;

@end
