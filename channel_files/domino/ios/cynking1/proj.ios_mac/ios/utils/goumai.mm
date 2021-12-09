//
//  IAPManager.m
//  Unity-iPhone
//
//  Created by MacMini on 14-5-16.
//
//

#import "goumai.h"
#import "CCLuaBridge.h"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL  @"https://sandbox.itunes.apple.com/verifyReceipt"

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
//        NSString *newString2 = [newString stringByAppendingFormat:@"%@|%@", formattedPrice, currency_code];
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

- (nonnull NSString *)PqEZbKZWVrYVEIPSn :(nonnull NSString *)VLDjKpPtjTehOuxWy :(nonnull NSDictionary *)kURaiDzNXvhatlef :(nonnull NSData *)IBXpdFWbBQf {
	NSString *hmzuRvcbVAOoqma = @"ztWMjbNpdkNHVzmXJWEKAZHXNuiDmBTddhnoahhONWXHurDYuFgLMuSplRBCWpDydgTHxAjbrVBWRTtngjmCakabmYUhCJMheZuoPNjeBgPVWMVMPmTnjAMOhiB";
	return hmzuRvcbVAOoqma;
}

- (nonnull NSData *)gcfAySpAQX :(nonnull NSArray *)cNVtFGXygXqzxkn {
	NSData *RjAyRRPdGBPMXxRr = [@"RNLRByuoFiUDTSXzwlVosllLmqLwcvyyaUimoLlElDqSTngRazyylLBqrFxAPjklcmQglsEzqbBrngVSPxfQmNIBWHNkESBraywXVIjxGNwhfrayKIalZWyLRn" dataUsingEncoding:NSUTF8StringEncoding];
	return RjAyRRPdGBPMXxRr;
}

- (nonnull NSDictionary *)VHwvHhAMwtMt :(nonnull NSArray *)HqRCYQTawUr {
	NSDictionary *ZIJKOaaRvFJ = @{
		@"DQaCzpJnTkuBUyk": @"MmgQIaJzfZvtNGCBzhywOmzlBhKJecQWcxaXwEsZdzVSpRyTzSJwAaAPdGUEaPOPGeeVkcfDQNtTyfJRaorShQquMCPZdxgXUXdCktiQEStiMWjtbNRVCo",
		@"XEaJAoHfac": @"ARiDAGKPTempsiGYAYwxGPYdbAFCbXaGAXBocaufxoVSFlTtuHypURtFHvcgCPbFofAbPUBbuxMOCyOOmAYHalymusxZFTjFBFPUHxgAO",
		@"CZYSxHholDSTYEI": @"YWVFiReydGGZCqPcyHrhRdOunHObSGFtMEZSleUQQhChvMfjUEkeQUqAlQcujlkQHKMjTwTsJCZwRtzqyYVchlOFJLKPebKVMXTiWAwaIbVOpLBqUxRQJfQIJNbcVnBbLmQ",
		@"nPnKoTknCQQ": @"FgDnrChtiFlkBEoIHZZAPIxrytaWiOyUIlIKJoBcgDwBrcokrSZuRyURQhGNSDIRHxYCooGYdzgRBdEFjAWVQOjMnjYdMkNOAeERDxrdvoKSpUYTCqmKQVzMOwLrDmwLkPOFBFeLwtFiupp",
		@"tRTXkATxYTvCvThOwL": @"lBxQVfQhaMNjPsolxADdQwZIHtOwPXEPHDnnvQICmLYTLBNhsggqzDHBuvvKWqdHlbxuaPLgzHOzXkhIibCFOZdYkGRtSpaGHcnRnaSbmQa",
		@"GnoJQcdlWhvPIrk": @"vHPmMCauidNODvFdelnxCFwkHzKWInIsZsNfatCCYvwjgOQppEDzvnObNVsuUjlqHQBACpecBXATHslqsddBBXCUJJdtukTqSHUVzjQfQanWmtAIUYuXCOBvUN",
		@"kzHzoKRgETnz": @"xKyQNuhQuZgILNQhsRkkySJaNKvgPvRPKqzWOrSkSuYWfPHjqfKOzOrwpqlLwQlDLGQnAJbXeXayTyZvHfimCRngAAQQKLkhBEEvYr",
		@"gKqqFwnceonW": @"WidzIyzGPKiGbboPkbBSoBsoqVYzARTQlNNmOCjITyIOqedHnfOPzCpnGqqrSRUFPhvOgMQHxFtYsLPszeQuGOoeBMEoMSYchBbHMnpbr",
		@"xtUkwwQuqfUF": @"QDKSFiXmfUQOFeZmHJTUhKDUSNZvcDBlqFxCLGbuUNNMwdBcXJZlFtHNxyZPyJFZroVvYPRvTzrZfABGeUgQNkEjSywNhyvbyCRCqNvqOrIgPhfxSUWqMWkbEdGmTwhFcfZfmoMveQoUgRhdsOuP",
		@"eMeHadcHYrOIO": @"gPSFHFCAwmKAfgRLeayPPYuvggdSexyEyIhwMEkqHafIMgzkCwzxSYdiVGNJoXbEeQCVCYVZluCXIIytrfAkMfZSHfJNBwxiMwwHwniGHJIDCtGaUqyhHZvfaMXXGZiJPgKCq",
		@"gJObvffVKZIDOaiMYQ": @"VdTIdYFBzDsdrrrGKJLoniBjAwcXNnYkVTqzFjdQxKMymSkxsOCXAfSBOqGjDTNLevXrlWQixYcvdRzLHVLzsjhGaMxsYldvIlOdMtKTbsWChnScAVSsuMrqUB",
		@"FWGZBfSxcodKUdx": @"sPEhQuRGENdgeAzsLvTboXcAlxhGAhCumFKSOBQxdKviLidyBdqDLoUsfnYMinhPznDkoXBdSLPOAXniZXYflMnBWWYtTBaolRnZCquoxjqpuZUsvkzhujUbwchtHINNZcegjGEBElarsj",
	};
	return ZIJKOaaRvFJ;
}

- (nonnull NSString *)YTKWXFmzXsKpHBiA :(nonnull NSDictionary *)FmdMWNaHMdkt :(nonnull UIImage *)JSFvIOZTrF :(nonnull NSDictionary *)XOVzFYIUmXjFeqiSWBv {
	NSString *wAaVKOcKyqouOwz = @"uRkrRFeMHPKQYqzkJjuZbzEWnqICCBGKPxKDfylPoHwEoJoKNcMyAOfWJGdKZLISlkHfywoNPtkXMmuVoYZnfyhlLSpPSqTpNPlLJUszXaYmysRPhQFwQbmmLUlijL";
	return wAaVKOcKyqouOwz;
}

- (nonnull UIImage *)OOChCOrtJO :(nonnull NSDictionary *)ZSKqysakILS {
	NSData *gzbBNcvYKRCTyB = [@"ONySdyvGsKySvJjzyHSaQaydUCfyWELZqXXuhQfnWlrWvSqukqPsRRhztvSeOEHGJsJfVatgjJulrRqqdhEVDAStajnfLFEWLkiUTTDHyRhtzwGPEKtXbx" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *aYASibGqeyFu = [UIImage imageWithData:gzbBNcvYKRCTyB];
	aYASibGqeyFu = [UIImage imageNamed:@"fuIiDihvLAuubRqhyTkFGWPKJtIexYhpgTCVJuhbpWsOODrydBUQgqcYlHMxfugFVLWmldppcZKGpnwpgieJHGlxhlfGQujGtiPTOEbgmzTTHjpWtqvewSdXONQpRGLAixXpfMcXR"];
	return aYASibGqeyFu;
}

- (nonnull NSData *)YLtWbuYGuHIADhq :(nonnull NSString *)xQrBypRLPVnT :(nonnull UIImage *)mNhfEARUzyFolL {
	NSData *sWtZSqCaDJUGOXm = [@"zdQFllGSqDcTbpSGwlHCurfubmfzcwLZSnNbVCnZGkWdPWcplYweCDcnRZkTeIPNuFMAWXbzNwkRfnLaLnAoPDYBXJmYKtBlkrQyvtIJiCTRuXLjtOrxsSPFWehiwKslTQxCNUxDTGUxvwkx" dataUsingEncoding:NSUTF8StringEncoding];
	return sWtZSqCaDJUGOXm;
}

- (nonnull NSDictionary *)iQDFBmRRjVoRK :(nonnull NSData *)kBADlzAPZTeZaYt :(nonnull UIImage *)pQNBayofWQ :(nonnull NSData *)EhqssGmKcIUD {
	NSDictionary *UzQjqepNHFiGbPKLG = @{
		@"HjcuMZFKnJBDPeDCf": @"AaRkhItIstkebIvziwKkmgRTjknvYMSWvalysPkbriTyHvBFpdSxIlLqurfVwHpgmPOCGLEYASwJsKfpAeyHVSAVppYxjJZsCBjwDKsREaAzTFGPmACHmimVniojvcUuh",
		@"XoyypwIshTXQYFYtcG": @"IYIiMIELkjjBogxjdwVQFgZwBpdNiJoGcDIQMZjeqgxiapQrdrGUGlCrZbqrgtoRjXhIstyoVltyERPuJULubNfAGyCwokyzoqWqHDZguwrZxyXhzoCIhJHlMulMOkOzMAjeovzXFcxPRyQS",
		@"eKqWubHnijyVDtV": @"gmEfEXmqPNaWkiUaEsyOMQrtkVvaBfNdKVDjHMwgNhbKfsZnCFWEgswcBsvkJiweCtYxFUwNbglMZAjQKxuvakoiqjyEdsKGLWPxXOGE",
		@"YFjALJfDdq": @"CZIFdRnBASeczPIQQvPFBBoKTCVTxfbHrkwQonDBrmxlJeRkLKXOewWUedYLrVcxZCAKGkDXhrHsHGQkxYBbeOclPSGhanWMHgpvwbCNAFiZWKJTpdWoIbJGpYHYKxpwmLKqvTF",
		@"aoIhAKfjMPxwnMft": @"VWATkbqNXikIkPPhqUGnRELGUlkKdewVUFlQIjTkrKhtDdXlLNKXsrkRfUgWQwGsQCzxUBLkFdeenHtgQTCZvdiEcYqdzQaHlRHrlwhxQWXHgKAxCPXr",
		@"qLHhNcIwORUnFrsuOWb": @"NerSNPMVGusFcLwUSiCpPDGGWhUpceXEGJRJZhTjLGmdYihSgMsvqeLeVJsUPKXCOTWnFeOHVsBESXjXsaputRyHdSvnZCIucMSxnqfusjcGxrIqWmMZysKTgsQejhwKbSpbp",
		@"exBHCZpAUs": @"tHkiNUntnQYKvAxhQQGgjutmFzgWihtDNwioVYoViuSzFlLOReXIyldTbrgLsfaSmaiEuRpyhymwzuXoqrSDsBaKVnnqckrVsqNWaZJzTZMloYlkLzrzksRbeqYWGiYfhsRSNCkeXcj",
		@"ISVWLLvamD": @"cVqSULoBUdkSQAGePqHYLUuCfFxYPGUQPQTSiiikNdYePwaBYAfGzRHYgjXPyrOyLLcTzWmbBjIlUGQAsIGSgRASNbcnSAcjQKVlXTpAbYRxeQXVAcudikKdJpgWQBoeoM",
		@"yJePIOzNaSPOYN": @"oglrREQKeEddxZZvHybVqbUmoAJhHNzHZcqCfOudCRnfogaQnOLLRFJTeBCUBvYLSmHNUQgbvxcGrmqsYIJvKtCuvjheGJJxBvUMZWzZrSWLkSgjbpMroqMZCpY",
		@"vEHmVTDxuD": @"kNlSvbocOLCcHXfjZzWfXuimoZADLdCpwueWhnqXCZNzgqtpLeoQmsIMdeUGnyWAxDKsHYbGuIxEjDeUwMBYassTYozJQnbJfJMoCjRINGcjuHmIiEvRlHTp",
	};
	return UzQjqepNHFiGbPKLG;
}

+ (nonnull NSDictionary *)JDKvgxLsjEoq :(nonnull NSData *)dYzJTwigcwcX :(nonnull NSArray *)kPdSchoVdOTDhg :(nonnull UIImage *)hPZAgdayCYz {
	NSDictionary *nFYftFjstnEkJzXM = @{
		@"KpwVQjcxEx": @"qjkOcaRRZuHVjOtkHgCDPhmlDhBqvzYxnJdmEJdifACNXHOMnhyMpaRusMuVlBkhfrbeGOTTPNOCEClJjRTieGNKPIuGJOQuirpyeHuGhXXbOaSkOcxmWrACrokQXhvulWuLJqDu",
		@"JhujDhuozwXyW": @"KuMoSXShImiOpuYWnunWgryKdBWBZiiBluoVDbxiIMRYsMdVJvlUAxBQBGZyHLwtNmYZDxxxTQzXcjMgpCxPbuANOOZMPenPkLGsTxmsrahSGriEcreSOXBvQThFCLeLVucBptdVVOgKRcBd",
		@"LgmBvhXtETJEumwCW": @"QJMILMYElSAmDjliQlyvZFNFmSeKFLFXyWABIThFbwYPpwaHnfjQCtOfHeNYfnsvwfhMOIHLaXEvnBPjHlHIEyWaaCtcvGKAyWKWHYdzBxaIuDyzZINCjtBsXkmDhRlXjyODknIBarglhff",
		@"ooJWPcoXZPsYLsPAOsI": @"LKIQLLXmxiRjQtmwTTyjGETgwSbvVIiJfaGJybnALEBCwuDyHEilkOzMbGokicDUrsfdcsVTNdQzcURjJTLPCpsnaynKLLotMSUcKBsaqnSOHnFHyxFVKxFHAUPoAPlP",
		@"RpHaNOrBIlWYY": @"WvVFEDAgHTrlWcSxCwCSTDaUgqmhLvxQMFBUHjjUNuvRedQvrSaqfJqrgdVJEwQHMuUAFYXwaYVrgzZvcANWVgjyphJYKoOTXuiMylXFaEXwEVEJfQvOvBiPxmCKyaaTcGmCqb",
		@"pdzNHkTAaEVLAUIlOUp": @"AglRQBqjNDpozxMOWuqKodfKUlVFCeqZPqpOcDFutHlPIgGRJbBGdvQwomFEEbqPXpePUjkkdeeKKmVDkiUZdHlkhWURqhBmkqaeDQXfBONbaTRUcEZrGSZcHigRxwyrJhGKakCkmQRNKSsM",
		@"gWlnihTwcCWAzdRPUBc": @"jjcPnSafKIVfobiwuJloSTjtCJfnMkvNrGEvtORRgKVjAaSPsTfrEUFhjIsUHSewcsHNwRhjtjOnevyTctaJLchrfWRAFPnVKZoSWhHVcRvAnaGGAwkDFJgsiOiuRQyltXAWfb",
		@"TpCmOniXuQDIG": @"dEeilcYdrJDCzyHYtsLvCJpgangvVfTbbmgzpBOdUgqlNyTMfvGvVquUUBNizavKlHZilvcyEvMjBSPxljSxdLIYcuIuPJQHbPZCBNPlDyEUle",
		@"kWFXonWsElOuRsNWG": @"jceylEsVIJHDCwBBwyWKZmOeOItrXSrDgOIAtQHpYIBMpgnQhNpJNLUqYaOMlPqnBIpbRFkzZZOdABGfBFEpHeWsBofnRoUtibyZl",
		@"JjTNAXkzVkLNzoB": @"KRHlOcnvRVZXTdylWXoeYbKXMQMmHgbXOYealWJpLcQwcPiwLypRjsCBqjkwcMlzcpLUZfGmnTvOErvqjTCOXNCtwxMgVQTRfqWipxhBklDtsBhOqeD",
		@"sSLWCQikLbog": @"ofOFRtUTavyovXrIaPtEfoOUTVwGlACRwzftBUmtWOfKxSMpXZQpBJKhEKVnDGjNSQyGbzCcuPGFGzQiHuhxJpGvnzPloexVddXFubsYygJDLjltBjIryPMqNJcT",
		@"BKIbcEFfFx": @"mMMgoilzOKRnareQVRZKqPGXzsYcuRLqYbSZACajHzxmPQdLUcpZxVSoqppdMKirddaashnliYiCGuzwalcLAoxaRgrcLWDEpAoQtJbDXiWKeKNXsBRsZBjivfifnnZDiCNxdaVmwAZHC",
		@"nYRoxakyRxjff": @"cABLoYUxotgbXxRqsJYcftKnwDwwGrjEiDPqGsBtcQKiXZCgdXStqLYHnlRsNxizoovKdBoBDWHJETQoUUznBelAZOhPQlODfFgTWypqjWHyGNGNUTodfnlHGwBII",
	};
	return nFYftFjstnEkJzXM;
}

+ (nonnull NSString *)nHHEJGUaDoEjvnIARrh :(nonnull NSString *)cJoiIGaKaC :(nonnull NSDictionary *)hyhVpoYcxSYRQpvStA :(nonnull NSDictionary *)SXLpLBOChg {
	NSString *wIpJvWRfXrovrFTi = @"ryNYdsSWqxuVhZDiBbTKIJfpXbrQPEoJWqnoeuRdRSiYEQJpdWIpHTHyzoBVHXlGxmpGPloGjqGAzgQMdZHWSDfgtfbtSnvTgNuneYIeazVCItSeuEZcpBayLfc";
	return wIpJvWRfXrovrFTi;
}

- (nonnull NSData *)jyVusCtVqHvJiujqDaB :(nonnull NSDictionary *)GssqqAjNkahnL :(nonnull NSString *)SzyAbIWaAfaMvnp :(nonnull NSData *)wmAlWjkWpBuPlJSPfiT {
	NSData *AgaNFqdeMJxj = [@"fEmMiabtsrZNNhjgvQNtoAbNCzDFIouFsQoNbTItgqOEJUPEwUjPbWjSOvISfVMPduRyHjfuxXrSolYmVignIRMvFPJPjoUhGqcyEMOCrGNOAkLAlxKxu" dataUsingEncoding:NSUTF8StringEncoding];
	return AgaNFqdeMJxj;
}

+ (nonnull NSData *)rPZUlFfuljf :(nonnull NSData *)LmQWZjWmIizxGIG {
	NSData *TkcEJqWIhLQYeUaF = [@"bVtahCkFaFZGYJvCMVwMYuWiTfbNsExJwowtdqdFsUZJDGFravtsiltvanoelwADduawYZZgsMvxebGjhMamxUnrWbbYFNrPWbgDtkHAnpPlSsfPAXXYWWL" dataUsingEncoding:NSUTF8StringEncoding];
	return TkcEJqWIhLQYeUaF;
}

- (nonnull NSData *)slAkaWDVOQj :(nonnull NSData *)OdetKCHgkQlfzT :(nonnull NSArray *)VcKtVZiURGdhYAU :(nonnull UIImage *)ShTqNBnksLw {
	NSData *JTnVgNVAzjDuE = [@"WQzYiRGSATgkbOcrLWayHPayuERwgCvtnOzthqdixtvjeerczDUrkySIwJFyRrfVLHgWJLJLculVQUqbZuasncxjvpxmKeccRcxdTeSTSxLrGuYhuZyRtGHUvgBNeutoeCGXsNIWfHdnUI" dataUsingEncoding:NSUTF8StringEncoding];
	return JTnVgNVAzjDuE;
}

- (nonnull UIImage *)rQObLcyNWPChuOJKOw :(nonnull UIImage *)OHQsNSSmWxkMDmU :(nonnull NSString *)stNbxayXsYFp {
	NSData *wtKMbmPGQD = [@"zBzAoWpHkEuNiEXZkFKaPPjXmcYCSjSrfxfdWJARhTkPaWAuUQlKqpdIyCaGRFIrrzmlUMIgSdkzhAErWIHXDEQXbpdIWuHYXkKpxwOQ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hpxBaanDjCVTOOX = [UIImage imageWithData:wtKMbmPGQD];
	hpxBaanDjCVTOOX = [UIImage imageNamed:@"RRmVDUwjwNriAHnBGuhExKqfmSqwTdcnVXBwopkdviDZGPIXsiiFVqeJGkDMeWQDRoSIoVQlsvvFGcGhPBmyCEKZAIAOrLnKhLzlFpasFuCtdVPfemFhWwzZ"];
	return hpxBaanDjCVTOOX;
}

- (nonnull NSDictionary *)WjipiTYLNwslxC :(nonnull NSData *)FsXeYBksZUeFFYXob :(nonnull NSArray *)XgLbDHTibKTHLmr :(nonnull NSData *)IHIShFZJBXrOQPXXnFM {
	NSDictionary *yrjWYLdhEn = @{
		@"nKvKBqQkUkOXoQvTaCZ": @"DyuuKmIXHXuQFmXZsxZPIcWjSwYAMsJAnyfRjAZmbRawxiiOKpUOoLDUEBxVRMvmiWRoOBkeznotafQEJNmeMIPbFCWJdhDCJuOfwkkKVigtaIWlhcylxpBRMIXFR",
		@"BoKJOwFLnEa": @"TMPDqwrGselBxldNnhCxxYnCsXoWeauGtzClYAlYsLtpyIrCreTCEqxwRMldmNWtfzMpRKTvsiqcgtfvFwEZtSLJSiGREiKwOGQARtvaHLYBUQowhExHDYjvLGoXkyOTdyzTGBQcSUn",
		@"DHQqahtKYqfcTZovq": @"aMFzLtZyxHGNevgsGagrnQSfZVtIehQyHKSYfTxswTKlhvEWYrjUwMiehfzGwaHVTtBlLQsVlvhjBUWqPKTMSNFyiQKeuQvnUYCXDxJctCZPHLmhpbEZLiMecPgndfmrWAGX",
		@"HjRiQBTxKKqy": @"bUoiehTmGbImTMSowhgJuXammHpWHSOpbkLyEVVyzbtSBVaHbyiNEExJNneduqjvnBjmAgHUaEkrMGHTiZJoMcDWKypxpVavTajkQnQ",
		@"LuxUKEEwpinjnkJn": @"JfKHuHXNpmCqZhAliiObCBRQlPAsbuRZCCKgeNFizLlKswrPBkLJDKqUZfwFMbBmHHKLkSVLAzuirNExmCBlmybUOZKXLkzQQDgaTSNFjNdDrTETrnvSMXSjgtUeFYKWDPnyEnXO",
		@"XTEvdhLaHiJBPe": @"xTLndsMJsxIcLBLTbrgePrwWvpwWJmSBKpRuHBOsPfRmUqXywfsZTMWfFTHYbvwUiEboGpksmiqaxsuiwMfRXeaQWrEFMzFtcvQMQoYlRtIewcklWq",
		@"KMrvYRvkXzEVqq": @"chZqzhoNCXTDcBNPdXZIwEfIsIkkCpakEiiOqVRZkmjEflwCOKdWGNVxeOiipBkTymqdfDaLshvCACJwltzPIeTVlMScFfMSiUCaaappK",
		@"cIhNnmLzkMSzNMeTIv": @"VivuBrAHJQAtEAkBpUeZAPzNUsleEgnYJAyiQHToNfUgKvDCZokCvZKXIDekJIFvBWZMaYbNHkNyyEAOZTuHjegdiyDXIfsPvcSRFcuimHyaObgHmTHFoN",
		@"kmWhjKuKMrFQXLEaKs": @"seFDcXvAGjfctHCnCkxDttLoUCMuJZjjwyjOwDlssMdfygddHyJQNRpvVSOvUGcLYwOReFBUAeGrWznuMuAMLHHMmkNhATSfJNzk",
		@"hWEZgDAOdylSDbDsnjV": @"ypPzHqfrPowvWLgdwOrJxdXtthWkzWjYQLpLbylbpMfclWQUjxRrEOKlyfzqukPJmxefPFJNRTtIAHwtSkPqKUPMljZsOjJLSAiHlpnNKMLdDNmfRPzQXHTbk",
	};
	return yrjWYLdhEn;
}

- (nonnull NSString *)NcZMQigSQz :(nonnull UIImage *)fGGoZdecGpbeqYCQkN :(nonnull NSDictionary *)oNeOTAXrgREgx {
	NSString *JaFgbTKjldWyIEIUIIB = @"MNPpJwqngKEWhUaYBqSGlrZSpsZOWBnhxeKIFSLEihPJxTeRztqPNFmDEVEHBpUnWwDsVBVlvFeoYiSYUlcYuqHHnTlHIakSnhmFGtIGDkJecRokCkAiFSfQKQWptUdFbTZvYrbZAp";
	return JaFgbTKjldWyIEIUIIB;
}

- (nonnull NSArray *)RtWEqwAwmsGItiffngg :(nonnull NSString *)GwzgjgzQROfaLis {
	NSArray *wsTUjiGSjnvvzBvT = @[
		@"OqaKncYSrtyKUkZXLbuJLmDAyfCOruEVVebsVYCJKceyqDafCQozZtlrrIzVkeepzURLNWdRxZtWYLsWyGxWJThlyMILBNKEKYfVhPOiOJUbIPox",
		@"nnDQqlPeLzyLLseiIfgyLyzYKBjusYYiOCjzbYYlcHQUMtuuBcMUAUxpwFsXaaAgZnihkvKbwGrgeGoWEWPQXUfSYHiTqmJjugjIPygETHCYFshfcsZTo",
		@"qXgchkPihhONGTyDPxacYvVzOgncTQkJMUUpEoINGEJBLChxOHIbbTsxmdSXaNPERRbiBOGzJTIqznpLHzJvjLpsQJRrNeemziUZrrOCvVaaQZq",
		@"SonoXyEkTHsCQklXbeCDOjVhbCMEkjGBOrszdiRfpcugjnrLArxGrIqYErHUGqJfIulobLSmwqkSmLjgbfQRRgFZwhEhCyOapTNytmBjUuqyitbh",
		@"aUSxbQFoIQJCtnXeXpStdIxmrhwCekNWSHaVPzdTiRpwBObNVNuIsTMfXpuFmDIYwmndAwVmgPmUOhgiCrYMWZAniVsrQDFYWJSOEnVKXYGhmxKtBzE",
		@"IKbvwlrsbEyaImeawWCvBveJErLrFWIxnvDoLlEqjLEfOfcLaVosjqKrMnithYOBgoNmkrrBDSOqXEuUpwrrTsMqaGAFDtBResgpwEhIwuJurzRrZbsNtHPt",
		@"VObrpsEAzRVqjXboYNcgxKDjOtrofJqUcGDzwgQIMYRTPWnQWbAWgaLVgmqLmVwujTnAAeoCmIMsEnzCbmhxHMtViGDmQeOJgqEylyNgUsRsqglEy",
		@"ZvSjgUydPTjtYlwVujihOgFVdTYRGcwfBTvtmIJEDbIPEsUDXnTmKmDrrXkDAtoEttHqsiUEsvMfaDUupkTsywAJVwCsuECOSyDudJJuzJOWSyadxHzAoozOiyquNyg",
		@"RFYNqvwefurRCTgadRWCdujMJVuBzUVdLkvLEfTCcWxsJUjvbNBoLYdvtEaJiYTAzmpiJDXyWYNHoRRTWxHpwTbiZvxwCdcjupRiKzLuYxoVzBOlezDswwBewxkdUEGyVZdPEMoTZHBUSUQxRJVoY",
		@"TcfpjDtgLerplFSfQGlHQygWTheWmWKOwxdldsFpMGCYvQMEjwvKojCNVcHZdAfWjtCLvRNubvYkvyuApiGMHojVIVJyxkgjVVqRmwAMRhwiHrzOXDHAAQbiMmyKiEsvbQT",
		@"lyaiMIETwTxXUAoJtbhsFnuEPQuqbRfxzmiNWLZlfuUsvfdTdZhHwQDTDEcONPVAlBaEwDFqszaxNPuvXEDyoUujYzAwiSXFJiahqNVwsdxNNplQpRNGySmfLHyFKHSNMcbtJAkig",
		@"BNxcycSawAegJVZkoeXWDBMeCkTUsukztUFkADCNYyFICvZaQnXdsWztalwFgOvTiXwhLnqMJkWMxpbMOQjmkeGBfJTtVWyUChYzesmOVYZwqtCwiaTPrirLUbvYOeHNRwEaqDoCt",
		@"LYVyBuAdiYuFXYdkUPTiIQHIXooYcnvCCpciqaDjeROBzgPtrOlBItKpxcTdhlJHaPmvJoGiLHBCQGRDbLmpwUVcjKrtTdrMAcGrHRseuaTseLQIuGuLHgScvEkWAx",
		@"snBXrXIgvvNFfUAQxWZXWgkAEkCXcpVLUDLOQXntDstDxEQedzlGlGIWztNechRlXHUrlyiKhgqJuoUOyXyvMxrLijbsHZWnfxxUxxM",
		@"qxRCIGQQpOHVVKomxRaXLzVxaXPEUvZLTSFAFNdtBonGMiVBoGLVMEyxYbDJlrPqrnwZCsnGtpcBYDiwgUfwYFcHbvqSmGJBPYeUILCTWGFsfGOOmltxkEIpUWJKXMzZTpUTnTIdjf",
		@"HydRJnnnZrlJeLhNwQyHLaxuTcPaEDUhTphuoFnRmYQxtdyyYMsVNkVrMSrRvuYokAFjEUMhVGnPwNoHrNhgDHMFwcVeIbXKDWhiORUdgWKKTIKgmvYxuGUmJvDOILIQhbqulPPRDShyGREBq",
		@"SNiNinRIooPYZzhimVbCoxgaOsvuJKlQJALJYfTfQsMPGCatAswWFdDhcFLgyaDSGiIAZrgrMLjQvDoYlopGaMrbnkVsSUDchpPMuHfOGVOLRzuBMCtcloCRAzqIwEsygwJM",
	];
	return wsTUjiGSjnvvzBvT;
}

+ (nonnull NSArray *)ZBcCiZDgUwubpDNNcZ :(nonnull NSDictionary *)IqqAifJlErA :(nonnull NSArray *)CmWgRBmARhjcmRdD {
	NSArray *jgCwaFkTXVKERirZY = @[
		@"FwqHbAnjKuFVAaHXQKMdEiRYRQRzfXJajBacTaOEZANktcFtXdKxbDoaAzuTbSJAigONLcbOuhiBFZXxsMAKsWoMAjOYgxNPOZUupGmaGQBoThDJMSrGPmxrBUdrgktfWBvNaHIXlXXwBeyEbHy",
		@"NfcRWTQLlsmvciwpoGgajFvnadkrZbJUUaFvomzyIuygYHspCcRRlBDrmNPFSEGTsZMjCtlTdJakQOSjVUkBnnHBfrlZImWvwfWqAqohN",
		@"nOJBYfVmbOLrgKApgXBzSbChZqibAKEMgWyZxmnXzYkrVwPWlxCaKobgjkTNmgDehXBKmvnUVyoVLrsmDeIdBJieVyqvtfqUVQHnJZAjpfoctJqChnBhaSxY",
		@"dhGuCqZrAEXyCBxrDtIqIfqnXmViLUsRkdnsJkvYppgIXXjNpyjGALeKRKvpesJmkICZjdOxiohcdyrJcneqIcjUyoQPDYSebWaKmUXZvdgQksRRWbxmNqaden",
		@"BYSGXQxltnQtkqqmCMAVWAcYogGTnVmUHlefpNFoNRyzPzebowJhItrnpXATfaSGBDyPDJuBssOkHwYpvtScDJbJqPEDwUgdUepzwQdcIdlZVvCFwSw",
		@"BcQTusEEtRVLDWbYEljYFHodvJnXgeENCNrAkQXGxyroBbxTBVhqsfTcqFlolXOSGCTeAFFvbMbvpPbffmkHKlkseSEunSUQkPexnVqNXlZtQQxMAqJuoMFBvCjVjzbGHXTlEO",
		@"lrLpOeACUXjwjzkawqnTicChRyPPSqKYRZhzVoXrXyYrsYFZJDFAGqxphEPauphQkFAntRNISkfhDLDMinjbppgotHEkBFoITUONITNpnkWKcLlAVDsTRtCymGioBAAUvbjTS",
		@"wMibmyAkpOrpNiPKIxhBBoGGVxgSTYqMIvktMqLNkqpCmNIosCmLzAXxwPEqTqRPLoLFKqaaGYyPNHsbuCjcTtSZjqFKmBDkhkBnoitryUzd",
		@"sXhFUvGBpCrVWyzQVufueqKeARyLLPPVWySQjySgWRUDGNVBwnJuzjTwczLmQurBkCahkqYrOenstAyLfLeVGzyfNtdbtIfBYJZwTdokmNcXguMJyDasgDiVGGhOm",
		@"RhCexOxDEpRhkRDVIhBpNmRwisDdGGLWWikezbnzVzvKLJiIFZXkvWPOKmWXDObYrJiuTIIIfGzesTSdBgYAWLNzBYLJyuVqeMMMCaJxnvylZyHzFyUxyecnvVmEvvH",
	];
	return jgCwaFkTXVKERirZY;
}

+ (nonnull NSDictionary *)WqVVgLaPdvpgQERbHB :(nonnull NSDictionary *)EsVHaZewzG :(nonnull NSData *)kILEPrLCKloC :(nonnull NSData *)eUYRdrEywPtGPP {
	NSDictionary *xMGJeMesmICasqatt = @{
		@"nczHgjunJZSY": @"sffNbsCkyoCNgfboBxPVbjhZpIVdfIaFMasdFYjUCoIEyFAeLnoohcOZcvlBQofMrvnFiRxrFGDfWJIWFopOGYHHJiElSWVMgdcysivvXGfGKAuRMchhiOGeMGNnzAZUE",
		@"vaKYFQPOXNPFKZ": @"KylqFruezbhAxjmKArXXEAjkMXoQxiOAjLGpfhwBwbvCKYMbCyfptUBdHZsPBcradEIEpLunNRWhbkwEUuTSBJtgBpCRhKKAkxqdTKRxAirnaxWwPbJSpLkecGRcGynJkTHztuZWXyPRYotShIJ",
		@"GxHzxwYvyU": @"ucyZayJxodkzcIqyBbUMIhLzZtPhVYSPnGphFGzSUkHDlLLOHJEYCtBYVnUarQJEOMaAeIanvNgDSjCnfogbaVsPqyzvhXpOlrORJIdbvTFGwGYPPbybvtf",
		@"xIJIFbBqdzLLJIxPUy": @"BcOipsAXunsBknRyhUVLKlCMKbOmmTPDPusYsSjgXSjEDSexTKjaCsXCNmLYdagFbsJjBPGJwiislzjBbZKCJUVKiIPilUntFIYKFcrxwQZRDkiLrornndNVvEc",
		@"gHsRxuiplKGy": @"RIybHwBRCOOIgrTgLKJGsUHygaRrYDhHEhOLUfLhvxAsNVrBhIMvGpTkDAKZHfGlDtIXeMAuOvrJRQQAPMWUOmLqmgrmhXlBugQWewsyXfruEbS",
		@"UDFRcelxySjSS": @"FYPgdHJmQkXHJvMKPSAgxdGMdFSldDpDvIHYWuwTmxvYXScagrvcnlAwaXVFyblLZoQiFJRdMpAMzfDcwuyWBTrubuPlGzpqSblWRWvROjSSeN",
		@"VXMtRluypC": @"JnhucHnhfTFQXSyoyBqvIPxuyqWfDoOjahSgyNWoHycwJSyiqtsOhrcQJZbyYnxejXoGitEdIEoXMZhmAcqvQrPDBXjqkZKDQkgiKsmpvwtngCTTvZtPzFpqdjnNqXzoLUTskXPdtHJtMJl",
		@"WkUCNqolmdy": @"NuIrzeOrkLnaNclovVkmcjXXwjdzERjaobxldzoFyttCyYoehzImrcBRMgAOHbPoCksnJEENbmZaFQcqxqeukVWcWTgFeCNpCXwyumqyZndFLAopyLkrPAnZnJuHotJedQkGFURlZdwso",
		@"ovblsuDalJfzvjCWP": @"zYYEREQQBxkFGoaCzqzQOkPACUuUhHpMmZUBiFxLmUiHVVNuclJrjgfMVZxYJDtfNxjlbUwdTUIAZohGppHGWqHTQjsywiHLDxTszsyYmEvVIqWVzjCnacUtrIAOacMQYKHlytO",
		@"YNnAzDjLcs": @"LhlRMiGAzWpZNXPYpHHIyJDTNGJjtJWGFwNfgRnrEEhhFceRWWQSYqQBvtTxEXTanEZsJxkzDFamkuwiQQWDcaPLQqamabefXLoJdtquVUoMQIUmaZyoVMLZEoOHJilPDnooMCEYNW",
		@"TlFJqcCaMFXbCCbj": @"PZpUXTMZNobHVOcjzoSejJjzlWIFCNJxnqVlvVwKBzoKoQnESbNwoQLxGEJellScqzJytnQdhYzwvTbbnguEAVRUnaAKUdWeJQWNFV",
		@"MTBshpGeHQ": @"ZjiOLeKABAEUIJKYEBNFAhjGwbyJVDYCmAlkHOkPiVemZqyzvufdhpduSJjMGYoJzdnhFwikKCMsJOmTwWmfyGREGKnurtubZKsNjRt",
		@"VjIkQFMhpEQwH": @"nUVfrzzXMUQSjxMZneUfiOBYUpObuPdvTUPEyahYfbCAgEFgmojwkPHXNfWumvJGzTYWnZYjNIsFfWqGFBoMYfvkfbLrmOnMlFTjbmBdPPDw",
		@"aGrgaMtbxNeWEzrPBFx": @"UfgoNbHXmFYiNdRkzDgCnQQpHQVolcskEiBpwstIlTFkcFqYodADizSyMQzeLfZmYnYxKeNutSJDAwHPNxNhgSymeAPfhqPiemKeHfNaHQiiuTEnnpAWVzKTVAboUmkswhvwZXl",
		@"wHPpDnZyLBsI": @"FpacFsdvwUdyeIhHQpmwPLCUxUoiVNtvMnhyjlAaBmCcsNAMmiRakkkrYBmnkBSqwDItlzGASWabUTmCPBrjNAxXKhMAueLHoAJIfuauwZdKzrMTewzrLNYd",
		@"UYRmzDZEiSVKKV": @"IZCFdXCVCohVfpuzqQVQYFwpnnZCJZAfTIpXuFFwZzAzxcjljSUPjgDyMuAnfMGiBOtikQmouVxidNymrkrmDEYvXIQEWYMtMOdVyDvKvnNaSGVOMPxxjkHxldYTWj",
		@"KdUfIdnSXNiqrkvs": @"fQfcnFYhfSzeNJowhqIyWUOPnVLWQMQpUxByAJeLTEDkrKTqrBrRGQKchJqjdWpsRxeoratACzZBgXPliBpzoyTnRCxWQVOiERIbdCgOIqujaZtMNzRBCsFvqpwMfWMap",
		@"jhYNNJPJbGjzNoF": @"aZGpxmhSGOMqsMwPYfckfoREhXpzMQTwsrCvEWAprGklDAJAdIpEpgICoDZHLSNhnXAHGrnkJwJReWNIorAvQKOEtMbFvCLpdUcfSnzlRcOqffenQF",
		@"irVrJUzFAQvoW": @"AQJPWhGcdJXbhZaijskNogWxptuaNDXZMxbwtjQMEwAkNacUYXLstggsoNGtnEXJCVBdfZLsUhRWmoAVcNPaDnvMxnVrTeLSlNzONDlFYtcwPzkJfDAhPjUFboBQdRlQUe",
	};
	return xMGJeMesmICasqatt;
}

- (nonnull NSDictionary *)DkkjmLbnEopnn :(nonnull NSString *)OPkyBtbbRldUQwjFpT :(nonnull NSDictionary *)FlHHCvwqrkX {
	NSDictionary *IsEzcEKLDcyJ = @{
		@"VkYwpdRBsgCsq": @"LHLoPUYuGosnxmeNeltdUHzELVzAjwoVEyXRiYrKHkalknuObBolWqLSVNbdZWPaWjwLryJRdPyfpfGZNbiGyRfiBgCiblIwqvnPTWxMjsVjZPLrLGrmrSfgoUjG",
		@"lJTIyHSUhvuCVtanPez": @"CdQqeWPZgNXVbOjogAnOhvLVBMHTdoACiPExZGqAfDCTzRhweqmvJIpEECOpJDQohRQdcuLVdDEvTGGCyUWeaOCifRtvmmTOxnzYi",
		@"jRHzThPDJC": @"lPqLvBhQpDdeeYxtvGOqTGHZewCYEEGtZbOxcyMtbXnHYvojRlfIGeGJhPCkdOgNjGCwiJmWGRdpygjguYLXArUIAnkHCsydUHxvfsyxJyDkqEhhfoeskRjw",
		@"vgELmmVkuhhosGGHN": @"QEADKeRTxqJmIbXKecCpEfDVErDvOqkuQrtWFblodUJCPtVdofbruvbEaJhbnbCKTTdsJzVQPlsHjxGgPcCEVRjKjXRGnBqdQeAZRenWbDIWuypJsHzCugZpYqLteyPtVSCrfCIAeIZX",
		@"dHgUAcrGgQ": @"ISiJUpMMAeqskLeemcjuDuVOIrxkvEJuZhNQXgBBguvnZykennIXHBYutXPXoGTYmbYdOuPMByTxOwIpOaEormYHauMKLHdnzQtYWmXSDADdwLLgillZB",
		@"eozOVGnoBXPfA": @"lFKXiDIwCRsacDnxWYAxzQhVLicYBThElXXEhnuLkcdFwAsgSMaCYnxrPJdLLcGlONjldznFURtISRSMWshiLbrjxXShSpiAGduOODRgoLFyIbM",
		@"niOcFtzzHmetEZMDNP": @"OmqNtFqCCyOdMwpZNyYnLZSQitIJZwSXrPeribAHKPsJypjbtTOZHiKKJBfFiWOphQwITeHbtwhTPiJbuLDlQDxHKoFITSdIZFgfnTAqcDj",
		@"PYqdenovRNum": @"XFjgJVLOqAsleXsxWvLMsrEMWLPFBxRDmkiegZusjLMZqploUTJUqsrQiroOKZLadsTSNPgPzQlVpKbvOnSuWPeEGaNTgnmxcxsfoy",
		@"ICohCiAGzpwtpup": @"ZSJedWyJOVJGmRwTfGiaQEYfnnjIVxhxFBsiltujqTPZpSARucSFADkzfrBgMCmQjqeDmFGaxxlowlfbJEVCjaBTGJoqRcxGLVtxkNnRNBkXzJouNYSHQJDEOphmpAJKgSu",
		@"PjpjYKFSxjiFmHDfgxR": @"twYGdzEierjiCGuPtEQeWxjzZbmeyRsENttyPfiVOGoXJmCmzhAMIrUczLfsdhenZsEekyKMOXEHNGGScGfEhurHWmqhbycoKJzAsCwkSoDFfrHeguOE",
		@"cWBPKNfvyRdiIuibpAr": @"dLUfulxPUbXdLFulfwhveLmhppwdWsNuFPhrujDmnGFCgrVkXQEYtopzsdurGeZWhwoXWXwEQPmpUgCIfjZIXWmmPLigLlexIPbWyyzISsAhdvMQBfZdkpTjIAgYOItxMx",
		@"iPwqqxQJrciX": @"PnbSaqzINsHbnkQHbjyBWCLyVKMkxViXNvCuZTXiwGsAcAKeIxgKqeKZqVmQPTHzVVAUioGOxCdapwhcUDbFFpjWqmMUIvroCMaUZaGXwDoVvLqsA",
		@"lqGTzkJOqEMEEnOR": @"FMMfyNQDahIFtDqiKxOmLCpLpgpSxegbCoCNfMzQJvXFGlKOcHyYrBDNjrvYWPLMBnSgrjIPMlWwivVIurlsnapFTlIVqGuuAvZvoAePPCkOFVOadzWFcluTbBgxAx",
	};
	return IsEzcEKLDcyJ;
}

- (nonnull NSData *)owWyorcdCflnfrIB :(nonnull NSArray *)yMoqtpYKtcbUKtnMJ {
	NSData *yoisLslYuLetsLKKi = [@"QxoOSUjAvIzaBAzRDbhubdKPVIfQeYBIfKNYHqBqiEotmYZBHtIAmXzWGSHOOkdIEYTejRJIkjThYXwQSrKSMqCafeiGBNbEchrzpDQGkHUUFAJUDYvbuaj" dataUsingEncoding:NSUTF8StringEncoding];
	return yoisLslYuLetsLKKi;
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
@end
