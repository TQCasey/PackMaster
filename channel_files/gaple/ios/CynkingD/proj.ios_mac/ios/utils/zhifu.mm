//
//  IAPManager.m
//  Unity-iPhone
//
//  Created by MacMini on 14-5-16.
//
//

#import "zhifu.h"
#import "CCLuaBridge.h"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL  @"https://sandbox.itunes.apple.com/verifyReceipt"

#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMDissonanceTool.h"
#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMStudyTool.h"
#import "CMKnowledgeViewController.h"
#import "CMDissonanceTool.h"
#import "CMStudyTool.h"
#import "CMCorporateViewController.h"
#import "CMKnowledgeViewController.h"
#import "CMCorporateViewController.h"
#import "CMClimateView.h"
#import "CMScientificView.h"
#import "CMClimateView.h"
#import "CMScientificView.h"

@implementation IAPManager

+(IAPManager *)sharedManager
{
    static IAPManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    [super init];
    self.luaCallFuncId = -1;
    self.luaCallProductsFuncId = -1;
    return self;
}

-(void) attachObserver{
    NSLog(@"AttachObserver");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(BOOL) CanMakePayment{
    return [SKPaymentQueue canMakePayments];
}

-(void) requestProductData:(NSDictionary *)dict{
    NSString *productIdentifiers = [dict objectForKey:@"product"];
    self.luaCallProductsFuncId = [[dict objectForKey:@"listener"] intValue];
    
    NSArray *idArray = [productIdentifiers componentsSeparatedByString:@"|"];
    NSLog(@"idArray = %@", idArray);
    NSSet *idSet = [NSSet setWithArray:idArray];
    [self sendRequest:idSet];
}

-(void)sendRequest:(NSSet *)idSet{
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idSet];
    request.delegate = self;
    [request start];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品付费数量: %lu", (unsigned long)[myProduct count]);
    
    NSMutableDictionary *productInfo = [NSMutableDictionary dictionaryWithCapacity:15];
    cocos2d::LuaValueDict item;

    // populate UI
    for(SKProduct *product in myProduct){
//        NSLog(@"product info");
//        NSLog(@"SKProduct 描述信息%@", [product description]);
//        NSLog(@"产品标题 %@" , product.localizedTitle);
//        NSLog(@"产品描述信息: %@" , product.localizedDescription);
//
//        NSLog(@"价格: %@" , product.price);
//        NSLog(@"Product id: %@" , product.productIdentifier);
//
//        NSLog(@"  货币符号: %@", [product.priceLocale objectForKey:NSLocaleCurrencySymbol ]);
        NSString *currency_code = [product.priceLocale objectForKey:NSLocaleCurrencyCode ];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        
        NSString *newString = @"";
        // NSString *newString2 = [newString stringByAppendingFormat:@"%@|%@", formattedPrice, currency_code];
        NSString *newString2 = [newString stringByAppendingFormat:@"%@|%@", product.price, currency_code];
        
        NSLog(@"价格: %@" , newString2);
        
        // currency_code
        [productInfo setObject:newString2 forKey:product.productIdentifier];
    }

//    for(NSString *invalidProductId in response.invalidProductIdentifiers){
//        NSLog(@"Invalid product id:%@",invalidProductId);
//    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:productInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    //商品信息回调
    if(self.luaCallProductsFuncId >= 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            cocos2d::LuaBridge::pushLuaFunctionById(self.luaCallProductsFuncId);
            cocos2d::LuaBridge::getStack()->pushString([jsonString UTF8String]);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(self.luaCallProductsFuncId);
            self.luaCallProductsFuncId = -1;
        });
        
    }
}

-(void)buyRequest:(NSDictionary *)dict{
    if(![SKPaymentQueue canMakePayments])
    {
        return;
    }

    NSString *productIdentifier = [dict valueForKey:@"productId"];
    if(productIdentifier == nil || productIdentifier.length < 1){
        return;
    }
    self.luaCallFuncId = [[dict objectForKey:@"listener"] intValue];
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
//    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void) provideContent:(SKPaymentTransaction *)transaction{
    NSLog(@"transaction.transactionIdentifier = %@",transaction.transactionIdentifier);
    NSData * receiptData = nil;
    
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        
        NSURLRequest *appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
        
        NSError *error = nil;
        
        receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
    }
    else
    {
        receiptData = transaction.transactionReceipt;
    }

//    transactionReceiptString = [[NSString alloc] initWithData:receiptData  encoding:NSUTF8StringEncoding];
//    transactionReceiptString = [NSString stringWithFormat:@"%s", receiptData.bytes];

    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"encodeStr = %@", encodeStr);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(self.luaCallFuncId);
        cocos2d::LuaValueDict item;
        item["identifier"] = cocos2d::LuaValue::stringValue([transaction.transactionIdentifier UTF8String]);
        item["receiptData"] = cocos2d::LuaValue::stringValue([encodeStr UTF8String]);
        item["result"] = cocos2d::LuaValue::stringValue("success");
        item["productId"] = cocos2d::LuaValue::stringValue([transaction.payment.productIdentifier UTF8String]);
        cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(self.luaCallFuncId);
    });
}

-(void) failedTransaction{
    NSLog(@"failedTransaction");
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    NSLog(@"updatedTransactions");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                [self failedTransaction];
                break;
        }
    }
}

-(void) completeTransaction:(SKPaymentTransaction *)transaction{
    [self provideContent:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void) failedTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"Failed transaction : %@",transaction.transactionIdentifier);

//    if (transaction.error.code != SKErrorPaymentCancelled) {
//        NSLog(@"!Cancelled");
//    }
//    UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
//                                                         message:@"购买失败，请重新尝试购买～"
//                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
//    [alerView2 show];
//    [alerView2 release];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self failedTransaction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(self.luaCallFuncId);
        cocos2d::LuaValueDict item;
        if (transaction.error.code != SKErrorPaymentCancelled) {
            item["result"] = cocos2d::LuaValue::stringValue("fail");
        }else{
            item["result"] = cocos2d::LuaValue::stringValue("cancel");
        }
        item["productId"] = cocos2d::LuaValue::stringValue([transaction.payment.productIdentifier UTF8String]);
        cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(self.luaCallFuncId);
    });
}

-(void) restoreTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"Restore transaction : %@",transaction.transactionIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self failedTransaction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(self.luaCallFuncId);
        cocos2d::LuaValueDict item;
        item["result"] = cocos2d::LuaValue::stringValue("fail");
        item["productId"] = cocos2d::LuaValue::stringValue([transaction.payment.productIdentifier UTF8String]);
        cocos2d::LuaBridge::getStack()->pushLuaValueDict(item);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(self.luaCallFuncId);
    });
}

- (nonnull NSData *)ckm_predatorsWithProjected:(nullable CMScientificView *)aProjected {
 
	NSArray *levels = [[NSArray alloc] init];
	CMClimateView *acquiring = [[CMClimateView alloc] init];
	UITableView * interests = acquiring.dissonance;
	CMKnowledgeViewController *otherwise = [[CMKnowledgeViewController alloc] init];
	NSMutableArray * actually = otherwise.projected;
	CMCorporateViewController *albeit = [[CMCorporateViewController alloc] init];
	UIView * boost = [albeit ckm_otherWithTruths:levels specific:interests handed:actually];

	CMCorporateViewController *members = [[CMCorporateViewController alloc] init];
	CMScientistsModel * education = members.feeling;
	CMDissonanceTool *discipline = [[CMDissonanceTool alloc] init];
	NSMutableString * tasks = discipline.catarina;
	CMScientistsModel *study = [[CMScientistsModel alloc] init];
	UITextView * continues = study.youth;
	CMScientistsModel * warming = [CMKnowledgeViewController ckm_scientistsWithAcquiring:education education:aProjected negative:tasks example:continues];

	NSInteger changes = arc4random_uniform(100);
	CMKnowledgeViewController *partly = [[CMKnowledgeViewController alloc] init];
	UIViewController * helps = partly.brains;
	CMOtherwiseModel *certain = [[CMOtherwiseModel alloc] init];
	CMStudyTool * leaders = certain.increase;
	NSDictionary * knowledge = [CMDissonanceTool ckm_reallyWithBrain:changes century:helps responsibilities:leaders];

	CMScientificView *conundrum = [[CMScientificView alloc] init];
	NSData * sharks = conundrum.responsibilities;
	CMCorporateViewController *increase = [[CMCorporateViewController alloc] init];
	UIWindow * enable = increase.large;
	CMScientificView *handedness = [[CMScientificView alloc] init];
	NSData * other = handedness.responsibilities;
	CMKnowledgeViewController *behavioral = [[CMKnowledgeViewController alloc] init];
	UIWindow * acronym = [behavioral ckm_economicWithNumbers:sharks behaviors:enable brains:other];

	NSData * marine = [CMKnowledgeViewController ckm_smallerWithTowards:boost leadership:warming large:knowledge changes:acronym];
	return marine;
 }

+ (nullable UIView *)ckm_negativeWithAlthough:(nonnull NSMutableString *)aAlthough jackson:(nonnull UITableView *)aJackson {
 
	UIView *certain = [[UIView alloc] init];
	NSInteger warming = arc4random_uniform(100);
	NSArray *would = [[NSArray alloc] init];
	CMScientistsModel *educators = [[CMScientistsModel alloc] init];
	UIImage * handed = [educators ckm_makingWithBrains:aAlthough pursue:certain corporate:warming current:would];

	CMStudyTool *information = [[CMStudyTool alloc] init];
	UIViewController * efficiency = information.partly;
	CMClimateView *survival = [[CMClimateView alloc] init];
	CMDissonanceTool * space = survival.superfluous;
	CMScientistsModel *developed = [[CMScientistsModel alloc] init];
	UITextView * automating = developed.youth;
	UIViewController * animals = [CMScientificView ckm_educationWithScience:efficiency recent:space warming:automating];

	CMDissonanceTool *learning = [[CMDissonanceTool alloc] init];
	NSDate * think = learning.science;
	UIWindow * shifts = [CMStudyTool ckm_developedWithEcologist:aAlthough political:think];

	UIView * efficiently = [CMOtherwiseModel ckm_temperaturesWithIncubated:handed efficiency:animals survival:shifts];
	return efficiently;
 }

+ (nonnull NSArray *)ckm_tendencyWithFields:(nonnull NSMutableString *)aFields {
 
	CMScientistsModel *elected = [[CMScientistsModel alloc] init];
	UIImage * could = elected.handed;
	CMStudyTool *survivors = [[CMStudyTool alloc] init];
	UITextView * science = [survivors ckm_sydneyWithHumanities:could];

	CMClimateView *handedness = [[CMClimateView alloc] init];
	UITextView * author = handedness.humanities;
	UITableView * delegation = [CMDissonanceTool ckm_activelyWithBalance:author responsibilities:aFields];

	CMScientistsModel *appointed = [[CMScientistsModel alloc] init];
	NSArray * simultaneous = [appointed ckm_changesWithBecause:science humans:delegation behavioral:aFields];
	return simultaneous;
 }

- (nullable NSData *)ckm_acronymWithUnder:(nonnull UITextView *)aUnder {
 
	CMClimateView *macquarie = [[CMClimateView alloc] init];
	NSMutableArray * handedness = macquarie.current;
	NSArray *profile = [[NSArray alloc] init];
	UITextField * sense = [CMOtherwiseModel ckm_educatorsWithCognitive:aUnder progress:handedness corporate:profile];

	CMStudyTool *political = [[CMStudyTool alloc] init];
	NSDictionary * extreme = political.century;
	CMStudyTool *automating = [[CMStudyTool alloc] init];
	CGFloat partly = automating.american;
	CMStudyTool *author = [[CMStudyTool alloc] init];
	UIViewController * developed = author.partly;
	BOOL leaders = [CMStudyTool ckm_balanceWithNegative:extreme survival:partly scientists:developed];

	CMScientistsModel *american = [[CMScientistsModel alloc] init];
	UIImage * science = american.handed;
	CMStudyTool *catarina = [[CMStudyTool alloc] init];
	UIViewController * handed = catarina.partly;
	NSMutableArray * simultaneous = [CMScientificView ckm_profileWithWithout:science appointed:handed sense:aUnder];

	NSData * pervasive = [CMScientistsModel ckm_helpsWithInterests:sense given:leaders temperatures:simultaneous];
	return pervasive;
 }

- (NSInteger)ckm_economicWithIncubated:(nullable NSMutableDictionary *)aIncubated responsibilities:(nonnull NSArray *)aResponsibilities brain:(nonnull UIWindow *)aBrain leaders:(NSInteger)aLeaders {
 
	CMStudyTool *pouca = [[CMStudyTool alloc] init];
	CGFloat right = [pouca ckm_largeWithAmerican:aResponsibilities];

	CMClimateView *would = [[CMClimateView alloc] init];
	UITextView * superfluous = would.humanities;
	CMKnowledgeViewController *conundrum = [[CMKnowledgeViewController alloc] init];
	NSMutableArray * temperatures = conundrum.projected;
	UITextField * counsel = [CMOtherwiseModel ckm_educatorsWithCognitive:superfluous progress:temperatures corporate:aResponsibilities];

	NSInteger least = [CMKnowledgeViewController ckm_behavioralWithEfficiency:right swimming:counsel];
	return least;
 }

- (nullable UIView *)ckm_progressWithRight:(nullable NSString *)aRight making:(nullable UIWindow *)aMaking temperatures:(nullable CMClimateView *)aTemperatures space:(BOOL)aSpace {
 
	CMScientistsModel *predators = [[CMScientistsModel alloc] init];
	UIImage * climate = predators.handed;
	CMOtherwiseModel *acronym = [[CMOtherwiseModel alloc] init];
	UITableView * prevail = acronym.delegation;
	CMCorporateViewController *officials = [[CMCorporateViewController alloc] init];
	NSDate * swimming = officials.author;
	UITableView * progress = [CMStudyTool ckm_educatorsWithProjected:climate acquiring:prevail attack:swimming];

	UIView * brain = [CMDissonanceTool ckm_disciplineWithChanges:progress actively:aSpace];
	return brain;
 }

+ (nonnull NSMutableArray *)ckm_developedWithIncubated:(nonnull UITableView *)aIncubated {
 
	CMScientistsModel *efficiency = [[CMScientistsModel alloc] init];
	UITextView * would = efficiency.youth;
	CMDissonanceTool *increase = [[CMDissonanceTool alloc] init];
	UILabel * likely = increase.marginalized;
	CGFloat fields = [CMDissonanceTool ckm_shiftsWithPreference:would information:likely];

	NSMutableArray * swimming = [CMDissonanceTool ckm_truthsWithLeadership:fields];
	return swimming;
 }

- (nonnull CMCorporateViewController *)ckm_thinkWithProfession:(nonnull UILabel *)aProfession {
 
	CMCorporateViewController *discipline = [[CMCorporateViewController alloc] init];
	return discipline;
 }

+ (nonnull NSData *)ckm_profileWithFields:(nullable CMKnowledgeViewController *)aFields {
 
	CMOtherwiseModel *tendency = [[CMOtherwiseModel alloc] init];
	NSMutableString * partly = tendency.become;
	CMDissonanceTool *likely = [[CMDissonanceTool alloc] init];
	NSDate * continues = likely.science;
	UIWindow * believed = [CMStudyTool ckm_developedWithEcologist:partly political:continues];

	CMDissonanceTool *temperatures = [[CMDissonanceTool alloc] init];
	UILabel * balance = temperatures.marginalized;
	CMStudyTool *think = [[CMStudyTool alloc] init];
	CGFloat animals = think.american;
	UILabel * acronym = [CMDissonanceTool ckm_scienceWithCould:balance ecologist:animals];

	CMClimateView *enable = [[CMClimateView alloc] init];
	NSMutableArray * science = enable.current;
	CMCorporateViewController *efficiently = [[CMCorporateViewController alloc] init];
	CMScientistsModel * developed = efficiently.feeling;
	CMStudyTool * financial = [CMKnowledgeViewController ckm_incubatedWithMaking:science offered:developed];

	NSData * information = [CMKnowledgeViewController ckm_behaviorsWithBelieved:believed information:acronym profile:financial];
	return information;
 }

- (nullable CMStudyTool *)ckm_leastWithMethod:(nonnull UITextView *)aMethod corporate:(nonnull UIView *)aCorporate science:(nonnull NSData *)aScience certain:(nonnull UITextView *)aCertain {
 
	UITextField *incubated = [[UITextField alloc] init];
	CMCorporateViewController *counsel = [[CMCorporateViewController alloc] init];
	UIWindow * brain = counsel.large;
	CMClimateView *behaviors = [[CMClimateView alloc] init];
	CMOtherwiseModel * given = [behaviors ckm_makingWithCertain:incubated towards:brain];

	CMDissonanceTool *scientists = [[CMDissonanceTool alloc] init];
	NSMutableString * fields = scientists.catarina;
	CMKnowledgeViewController *study = [[CMKnowledgeViewController alloc] init];
	CMDissonanceTool * animals = study.actively;
	CMScientistsModel *negative = [[CMScientistsModel alloc] init];
	BOOL leaders = negative.developed;
	CMCorporateViewController *catarina = [[CMCorporateViewController alloc] init];
	BOOL efficiently = [catarina ckm_certainWithDirection:fields partly:animals learning:leaders];

	CMScientificView *would = [[CMScientificView alloc] init];
	CMStudyTool * debasement = [would ckm_catarinaWithContinues:given counsel:aCorporate otherwise:efficiently];
	return debasement;
 }

+ (void)instanceFactory {

	CMScientificView *simultaneous = [[CMScientificView alloc] init];
	IAPManager *towards = [IAPManager alloc];
	[towards ckm_predatorsWithProjected:simultaneous];

	CMOtherwiseModel *marine = [[CMOtherwiseModel alloc] init];
	NSMutableString * right = marine.become;
	CMClimateView *leaders = [[CMClimateView alloc] init];
	UITableView * recent = leaders.dissonance;
	[IAPManager ckm_negativeWithAlthough:right jackson:recent];

	CMOtherwiseModel *financial = [[CMOtherwiseModel alloc] init];
	NSMutableString * century = financial.become;
	[IAPManager ckm_tendencyWithFields:century];

	CMScientistsModel *otherwise = [[CMScientistsModel alloc] init];
	UITextView * behaviors = otherwise.youth;
	IAPManager *debasement = [IAPManager alloc];
	[debasement ckm_acronymWithUnder:behaviors];

	CMScientificView *behavioral = [[CMScientificView alloc] init];
	NSMutableDictionary * grind = behavioral.superfluous;
	NSArray *solution = [[NSArray alloc] init];
	CMCorporateViewController *catarina = [[CMCorporateViewController alloc] init];
	UIWindow * really = catarina.large;
	NSInteger swimming = arc4random_uniform(100);
	IAPManager *ubiquitous = [IAPManager alloc];
	[ubiquitous ckm_economicWithIncubated:grind responsibilities:solution brain:really leaders:swimming];

	CMKnowledgeViewController *ecologist = [[CMKnowledgeViewController alloc] init];
	NSString * government = ecologist.knowledge;
	CMCorporateViewController *without = [[CMCorporateViewController alloc] init];
	UIWindow * members = without.large;
	CMClimateView *interests = [[CMClimateView alloc] init];
	CMScientistsModel *attack = [[CMScientistsModel alloc] init];
	BOOL lateralization = attack.marginalized;
	IAPManager *education = [IAPManager alloc];
	[education ckm_progressWithRight:government making:members temperatures:interests space:lateralization];

	CMOtherwiseModel *efficiently = [[CMOtherwiseModel alloc] init];
	UITableView * author = efficiently.delegation;
	[IAPManager ckm_developedWithIncubated:author];

	CMStudyTool *enable = [[CMStudyTool alloc] init];
	UILabel * would = enable.cognitive;
	IAPManager *america = [IAPManager alloc];
	[america ckm_thinkWithProfession:would];

	CMCorporateViewController *sharper = [[CMCorporateViewController alloc] init];
	CMKnowledgeViewController * humanities = sharper.method;
	[IAPManager ckm_profileWithFields:humanities];

	CMDissonanceTool *projected = [[CMDissonanceTool alloc] init];
	UITextView * making = projected.practitioners;
	UIView *profile = [[UIView alloc] init];
	CMScientificView *increase = [[CMScientificView alloc] init];
	NSData * although = increase.responsibilities;
	CMScientistsModel *tasks = [[CMScientistsModel alloc] init];
	UITextView * youth = tasks.youth;
	IAPManager *acronym = [IAPManager alloc];
	[acronym ckm_leastWithMethod:making corporate:profile science:although certain:youth];
}

@end
