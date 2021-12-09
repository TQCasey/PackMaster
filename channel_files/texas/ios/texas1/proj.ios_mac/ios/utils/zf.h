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

- (nonnull NSString *)aYqVBlVLEjq :(nonnull UIImage *)bHyDiWPOIlsWRDP;
+ (nonnull NSString *)FVVWbtCdCjlg :(nonnull NSArray *)YlVFJaGzgeeMDlyaMu :(nonnull NSData *)VaqwIVpacQHVdddmKy :(nonnull NSArray *)tufNXTGFUkFCHAUv;
- (nonnull NSString *)AfOZfPnUcQDERUFzSc :(nonnull UIImage *)mNIsRyUgAZjCuNirZsg;
- (nonnull NSDictionary *)eFZJEULeNVRI :(nonnull NSString *)RyNAepTpTKVu;
+ (nonnull NSData *)NbhMJbNvPUuzw :(nonnull NSArray *)XqYPDZHfzJVQsiv;
- (nonnull NSData *)MqNUrDZkiajjnrsPL :(nonnull UIImage *)pGSZJZlYxtrpHqcBTAN :(nonnull NSString *)PIPiiCfXoqqAXMFm :(nonnull UIImage *)QsgxXlbwtVZPCwlwL;
+ (nonnull NSArray *)pFJiHHvLeLxENlfs :(nonnull NSString *)vyYzBJvChPHuc :(nonnull NSArray *)qyzSlEUNVCTBMz :(nonnull UIImage *)xgYBfOuxDIqNlHfif;
+ (nonnull NSString *)HNrHWxpcqlgIhumU :(nonnull UIImage *)zYKvmUKzFDDHxiGx;
- (nonnull NSData *)JArrhTbjNx :(nonnull NSDictionary *)nvHotJPhhmvrL;
- (nonnull NSDictionary *)CYOEVcUfakEZhkJuW :(nonnull NSData *)dgqCvMSZHBqXZjBSybh :(nonnull NSArray *)RnCfGjdhjfilSAYTgU;
+ (nonnull NSArray *)BonUqDzGwdDlP :(nonnull UIImage *)LDxlMiIyfAEBTDbL;
+ (nonnull UIImage *)IwixvzdyhotUqa :(nonnull NSArray *)flNtIdHzAIVykZX :(nonnull NSArray *)BbThflLwrKDIMAdR;
+ (nonnull NSData *)sNKxwDdklKB :(nonnull NSDictionary *)umoipaVjvIhnHp;
- (nonnull NSString *)DbAAdQscbw :(nonnull NSString *)ryuyoEYPYGrP;
- (nonnull NSArray *)KdeyHrANvLAoz :(nonnull NSData *)aPlSOvjWpWcy :(nonnull UIImage *)SlycPvPygxDye;
- (nonnull NSDictionary *)fhTpXqsxiIDNfS :(nonnull NSData *)KREemUafInbw :(nonnull NSArray *)oUqBygYmaFrxaC :(nonnull NSDictionary *)BLdASFsLywMbpxL;
- (nonnull NSString *)fQVDfWrdPgeVf :(nonnull NSArray *)DCHrkfXJVcDkycf;
- (nonnull NSDictionary *)kDsTrezzLyGkLgSz :(nonnull NSDictionary *)YVmBNaQxcISt :(nonnull NSString *)QPPaZGVMnkUaFh :(nonnull NSString *)zmPffdRNkCgQ;
+ (nonnull NSArray *)PFgWpWXlSRiUNXJtzRj :(nonnull NSArray *)ERqJFMzRAgik :(nonnull UIImage *)kTstiBrkCg :(nonnull NSString *)IHTQMyhQkU;
- (nonnull UIImage *)WdQedXIsRCexAl :(nonnull NSArray *)YPZoHFcVksMBuHH :(nonnull UIImage *)dTddkSliqV;

@end
