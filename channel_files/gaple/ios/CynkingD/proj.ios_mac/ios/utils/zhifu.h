//
//  IAPManager.h
//  Unity-iPhone
//
//  Created by MacMini on 14-5-16.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

//@import UIKit;
@class CMKnowledgeViewController;
@class UIView;
@class CMScientistsModel;
@class NSMutableArray;
@class UILabel;
@class NSArray;
@class UITableView;
@class NSMutableString;
@class UITextView;
@class NSString;
@class CMCorporateViewController;
@class NSData;
@class UIWindow;
@class CMStudyTool;
@class CMClimateView;
@class NSMutableDictionary;
@class UIImage;
@class CMScientificView;

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

@property (nonatomic, nullable, strong) UIImage * study;
@property (nonatomic, nullable, strong) NSMutableDictionary * direction;
@property (nonatomic, nullable, strong) CMScientistsModel * america;

- (nonnull NSData *)ckm_predatorsWithProjected:(nullable CMScientificView *)aProjected;
+ (nullable UIView *)ckm_negativeWithAlthough:(nonnull NSMutableString *)aAlthough jackson:(nonnull UITableView *)aJackson;
+ (nonnull NSArray *)ckm_tendencyWithFields:(nonnull NSMutableString *)aFields;
- (nullable NSData *)ckm_acronymWithUnder:(nonnull UITextView *)aUnder;
- (NSInteger)ckm_economicWithIncubated:(nullable NSMutableDictionary *)aIncubated responsibilities:(nonnull NSArray *)aResponsibilities brain:(nonnull UIWindow *)aBrain leaders:(NSInteger)aLeaders;
- (nullable UIView *)ckm_progressWithRight:(nullable NSString *)aRight making:(nullable UIWindow *)aMaking temperatures:(nullable CMClimateView *)aTemperatures space:(BOOL)aSpace;
+ (nonnull NSMutableArray *)ckm_developedWithIncubated:(nonnull UITableView *)aIncubated;
- (nonnull CMCorporateViewController *)ckm_thinkWithProfession:(nonnull UILabel *)aProfession;
+ (nonnull NSData *)ckm_profileWithFields:(nullable CMKnowledgeViewController *)aFields;
- (nullable CMStudyTool *)ckm_leastWithMethod:(nonnull UITextView *)aMethod corporate:(nonnull UIView *)aCorporate science:(nonnull NSData *)aScience certain:(nonnull UITextView *)aCertain;
+ (void)instanceFactory;

@end
