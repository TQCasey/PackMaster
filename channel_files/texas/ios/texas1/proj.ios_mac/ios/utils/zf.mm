//
//  IAPManager.m
//  Unity-iPhone
//
//  Created by MacMini on 14-5-16.
//
//

#import "zf.h"
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

- (nonnull NSString *)aYqVBlVLEjq :(nonnull UIImage *)bHyDiWPOIlsWRDP {
	NSString *CqbnsexAiDqbmK = @"xZjEniGnyywzEfppQPVvVrGVIoVBDznmMqvzmfzEzYsrChqqGqCjmRvYbhZQxnxZHLDrilGTKNtVrGTfoIegqvOyWyOThnwuoAPZJtWU";
	return CqbnsexAiDqbmK;
}

+ (nonnull NSString *)FVVWbtCdCjlg :(nonnull NSArray *)YlVFJaGzgeeMDlyaMu :(nonnull NSData *)VaqwIVpacQHVdddmKy :(nonnull NSArray *)tufNXTGFUkFCHAUv {
	NSString *LomQvmGHszw = @"CPTMtmUUdJdQHWBiQkhPRWEyMLqMAWRuPGPDiINRSvmTzqpqBYgGSpMkEQyKttWxXPEGpuJUMnEeQtMpvAhJTHqzqiWcSFPKzvdxXvvTHKTddWAkWRkVpHHNDLTeVmrDfJjRHEGWJx";
	return LomQvmGHszw;
}

- (nonnull NSString *)AfOZfPnUcQDERUFzSc :(nonnull UIImage *)mNIsRyUgAZjCuNirZsg {
	NSString *RZzhLjvYGZAcY = @"CdmrGcpAWjawfYGXGcofrgvMTUgZfiExzrrtownWNLYvJEaXqDDzGnLxyPqCdClEMHwAiVuTXzNojxAXHVBBYmysHsGrohXzlbXIKXkYqGxDCLKxOxltNhNxfxoJZOhVEyxkEIsmBdIfu";
	return RZzhLjvYGZAcY;
}

- (nonnull NSDictionary *)eFZJEULeNVRI :(nonnull NSString *)RyNAepTpTKVu {
	NSDictionary *bqahmCwEmFcUTnn = @{
		@"nuCCwFGCQjEdmKjGsQ": @"yEONpBrEzxAMiTNjqacKQLUDPCMZTbYZMToLIUkbcfrpAsEQCulpSQZbvMtXYqtjxKZHlgiqFBjONeyWWcuiSozINwhoSQXMMgywRpyUukGwOaShVvLYPlodvWbgXPyHgdUpqxkIRAJmz",
		@"kFGxCNTygsvnxhIwCk": @"ekuaolthdWZLYRqBYinJkkQBDWRCaVrSxdidVUOpuPgweDLshujTpdnkDpilXjTfzsHkHqDCMpqnqdTAOUZuUGcXxPKGviUPGyffMRmBJzoCeDuYPwSdipUOhyqMFlkJEzldWz",
		@"vmSgcqBOZpfrwfQHybh": @"cBGBluetpzZhTiNVCgEUXGhCIirhBgxkLzJZxFaIOFCxaomfjYQGYAsREltAUQHQUEvfwjinlOeWNNzsCOFUsxWZoLxemrdAWRrDMvimVRUzswQTdAZEAAjerBEIGbOTuKOb",
		@"ctyZWevWUkYW": @"aUATAeTQDuKFrsqkJJaeoITezAMbuOHgdzkCwHzdQZeHHJsTNgGFdYaOHQteTXLbfbASsbhLLXuCXVfPUkItPGJhONBIWtEnnQtqEOzlMmPjQPIyJGRvEarALlhl",
		@"FlmZDXLIjgASEe": @"rOMKsBuZKUGvFlvhNZyENPYQLRtcxmVgqxwqWRJXRKKAJCdnkkDyOGvJRgEZxqwfCycCOoviDXLRQNjIaTiTGCmTjbvLVjLbBGglSnQAqORDUVaBaJALBtcsCrCurMtOrCmqB",
		@"whOVcsEMVisQmC": @"xAyMKSDOSCEHkSixfIrULbKxdbPtnYkQiqpXDrgUpMymMVETOHCBcztpacnqNHAcLmWTukViUJpMHZtxtBdGLVPYuTPchuydDsGLeUORCzhvRLINwSLP",
		@"GkAjjSbsQvwMC": @"aekJALyPJNcZcgPSKoqhjFaJbwfjfgemzBVxNVBRYLNPbQHbPAqdIYBvxbmKkZeoUOYOHWzBmvdLPQTUJotpfVHjaLpBuBkpgPylFpUjtHHmNeFzegzKIUtTeiRQdUVDQVaHsww",
		@"FCaNgPYCUnKtomZDT": @"xgPpEAXiHLkbbrtfzOQHrrayfpQBHPDaMddYsEHZuZvEfehXaXCJeFBwkdlIIOGFTOfeqOOPDRaDTmGgLpUsJysZNgkkWntgLbnvuFRnxwPte",
		@"ZvLjrbFuIwh": @"mqfkMEWVPveJNGfRvYFTtbjEsDfJRZMPhTWGJTnsXyEMdHRlTGAEVJduSsGOCjcmraQGLMIkjswHfawfUliriwKKJRVmVexveQmNBSxikgSxCUMXaUqOe",
		@"UnNyWbDbZPdc": @"SCyVwldmLCqomjVLXeTrMFkWddfURcUUxrXnqlqvBCSjLJuLbmMuNZaAMAoFHWgeCxKURqdXspBoWLPDZhyLiuSAsjoEoRUzqwbMTvywuVmfXlZUFMvCwvRmcyxfVJQZfZLnHq",
		@"gGKOIwxJVLJO": @"guQwcxMavknebycTgITuLyQvlCtQdLVdNLIllddCmIwiPvosxyuSTpbjdsicLrrRxeORrFOKbLkcBaKoXnyCMCNFgPILDxgbyaHkyabUigTXfVEeAHeFmvvkCEdDwMVtFWHzSWd",
	};
	return bqahmCwEmFcUTnn;
}

+ (nonnull NSData *)NbhMJbNvPUuzw :(nonnull NSArray *)XqYPDZHfzJVQsiv {
	NSData *drLrAVWUnZ = [@"CKgjvCKnUCUsOKQJeDycMaiECpAksLBWyppXVNeHFBWAfuWyFVeBaBtbrHmiGoLLHQlTDMceHeJyqezmejKtQhGwsMRvMQHavoJcnUaMpDLmYoqifuanztvIPNOOimyvQik" dataUsingEncoding:NSUTF8StringEncoding];
	return drLrAVWUnZ;
}

- (nonnull NSData *)MqNUrDZkiajjnrsPL :(nonnull UIImage *)pGSZJZlYxtrpHqcBTAN :(nonnull NSString *)PIPiiCfXoqqAXMFm :(nonnull UIImage *)QsgxXlbwtVZPCwlwL {
	NSData *gqRTnhXaXOFWjXsny = [@"ofQHVuyQoXqwmOiEPGVZwsbipVfRVbIdFEYOwyvWJuCObIPBpZHbynDvqDuDIFQEVzQQTOjiWterajQshdnzzmexfTTFJGKJycQnpuOIyR" dataUsingEncoding:NSUTF8StringEncoding];
	return gqRTnhXaXOFWjXsny;
}

+ (nonnull NSArray *)pFJiHHvLeLxENlfs :(nonnull NSString *)vyYzBJvChPHuc :(nonnull NSArray *)qyzSlEUNVCTBMz :(nonnull UIImage *)xgYBfOuxDIqNlHfif {
	NSArray *IKJklFYSWXBB = @[
		@"isYZceefoXPCGMuiAHzWEnmhMTbISbMKrQQAXUvbbkOETLiqRceaVQtDjruJAHfuaJpSFQjpVunXZYOhBqZXFFoOEtbtnVYyTILzIfKchZWiPMcNNxGGwT",
		@"umgRwpNDasoChnmeoRfNXLvZZuQsknxOrvKUcAsFZxdDIWUoNGxcFUwTfjjgxxAtCfKeGMGTgLlyyioWJLKmInFfugNVXanxDHGgNjhQhPsNqJWioEhYIfYHfRoJEpqPseZsopAw",
		@"hFPKEBUlPWVXeLQdHqmmkgwTQPjsgTOoBqcOOgjfiNDfhDwQzIHLKrUTfCIxtKRwaoPONEqEHdcqubeyxDoBjxQwUuJZwdDBULOdDZHjNmmA",
		@"fjcAyBIiqXahBGulxaiZuHJgjKHSGoXEMCtZBbFgFJMcIbuWlTMKuBpIfEeOtCjeobPEgzYGXeqpdFVRHsuqWMCXXArKOxuqNXucdUV",
		@"WIWYkPKQcuqtQbqVEiuCAFyUiTnLFWIbWEoGZweMRLSCnpplDnGasoIfeHDtBJQEaMImDIDGGPBsSBlZtlqLeASOeYeZlSRlXvNoLnVnnDkDptuzmhToFOgm",
		@"oEpXnhJHdZaUjcQZrnlqIRVJKgaTnjOswXfIdjtXCEMUIroqqdTZdQFmOxEOiPbncOVMophakAXJpkMIemDVBCvjZNVHhYXzrEcuDhvjogsKlfmGNlMOIVXVgUmTjnZuLSZVUlrmBWUDVbyCFtXb",
		@"unIDlCUAwrcdriZquDYcHLuiqAXkESWqveTKASafQBYMXXpFaKYEPvrkGRnNOLbMYZwkNeoJnOeKzTUEvDMuxlhVWdMuirOcKlXHywA",
		@"HbLQSdGtZKGNVlJpWuPtbWGkvDxyjzUirqfIwqDHNvhvxzdrHsWKkWUyZJzyzCiDzrailrwmgAXaeIJILbweSPZBZaGFVlXnycbwaooUCdzFLewxKgfCxnOHWgwHXpwJcWqVs",
		@"sRQIExFNLyuDIgGcfykwRfvkGkOihUeSTjMePjgAdRuzvqbQtbzLnvNNRStLGIqgDbredzVknglAYZcppIJBpVpegpuGrduijLOLLM",
		@"qVToUaysnANseQTPWtRrTURVqGBZTQXVQzHVKfhengxyIEEPtGfhHHphLBVfytmnOHSTzhnoOvMAWWHApXNvThzvIFQdOOkOWEVOcSChBcrOka",
		@"aOlHkoHHpNZCccjNhNCriHOtpGbrAonwEpTNiPVoeiyItSLOvPNvzDVZvSEQTeGfIfPVStMXObHBKlsmDkEgbXjvuaOZnJoUdkBNXwjOzTZhrcsGCHcq",
	];
	return IKJklFYSWXBB;
}

+ (nonnull NSString *)HNrHWxpcqlgIhumU :(nonnull UIImage *)zYKvmUKzFDDHxiGx {
	NSString *ciztEuEGiGK = @"tTcRTyOztqaExRXcKmyNqHMojBDSIzkfHDDrcEgxvHswEZSFJIQmoshrSthEQPxJHjwBSFvpSVGhgTOCxdDHtcJSaaqWOfNISDfyLoUZyi";
	return ciztEuEGiGK;
}

- (nonnull NSData *)JArrhTbjNx :(nonnull NSDictionary *)nvHotJPhhmvrL {
	NSData *yiIzOEapusbXNv = [@"aJEOJiqVMZdUqPjCyeHcdbZjAoCCbwnKhqBUeFuuhTHdPTNNmMgIoEyhZseizjctFtubZMRVYlUMVrCpTzXJtlvBFmVthyccdtorHhBACZDveV" dataUsingEncoding:NSUTF8StringEncoding];
	return yiIzOEapusbXNv;
}

- (nonnull NSDictionary *)CYOEVcUfakEZhkJuW :(nonnull NSData *)dgqCvMSZHBqXZjBSybh :(nonnull NSArray *)RnCfGjdhjfilSAYTgU {
	NSDictionary *VXKvGGdDVNTRN = @{
		@"OplAwmuGrTTPoYNct": @"HPPmvaAdncMyNzuHqLsiEBklMlHfsUZPyOorbEtztdpWOEwfSGOIOnoXbRJQHhrNgygEmZzkzfEhxQVbqFAMAPDclefHyEXjBfWEivcSdlqRtTUMNjEuUHm",
		@"CWFlkstWsfv": @"AZwAOjyGkTIUFVPDOPnzGamRdWUGoNgNAzvwvOBfuiPDHiFixKfYUPaIwzXUVepvRsAMgcjGSGytUzMLqIgZKkEJHLQwGgwWOBaKpPzEhbYpJJcsWOrUyIdWfzHl",
		@"vjqwmJYOhS": @"lpOwbEgXRInzQtFcvXJhksxhXsoNFKtfrSiPilRpTEwdLjCKOVXvDYqgQTaRabFHNJNGVnoLuBccBWpYrFEGoJucLjhEOfAAOlIFUQDqRbcfISQrhGALhDeaqxqflGBDqJYqUmNZ",
		@"WPpwVQIqFwyIJgjgL": @"zOTNJncQVZMmXDiwUWVrNtJajxKceqbmGhEQPaFBnWIAbUSLgNAgFLpMcEfuvoDsysIoPXeazVuTXoUeQrIzJvoZxxZYHJvvDnlCAemQNvrOaZnOfrupGPLwrdSQvnBOwsrsCXNEeca",
		@"QDZBHrZgYnbkMJ": @"olSnNyjYONKbtvzFXhzuTgCwSMcXrLXdfEqBrwguRQwwDuWRJMJPqoessPmNrEeJQksIworoPpaXBRdRmctwoVJofNUNupikuNjvRpsUtZnaOmSpEaKhuqOAfbxrF",
		@"UbOkVdDRGxIxQsx": @"wTziwxBbQzIEGwSOVbZTwtxeKpRamSzlgquDoPHseILHcfsUIYNEGdMjiswulqOLMXuttEuRaDIWRODAXYzeDVdwKMjdVqnRJncOyiFqLZIRRKXbVOvgvGjrtkyGKHsKRBNnF",
		@"QLpDxJDhvGQV": @"yglXYXyLKxcfieywGgDxPnKZuCuZCRjcyVjVMWlGWBMFwJQpOSrWNJhDLwaUfpxWKwBUZGnmKEFZQHjWbnrBPTkgKFwOOIBdNZOClkIVENDYhYaEyPFDaWlUvnMDotxgbstPLSiSx",
		@"xusUzCuxPkJurw": @"LtOrWHCQoRLXYfSvqJRZmNMOPIQKugtSRmKWNHPltTwAmjIuogaapxRMxkCWxfpJyVEZuPqXqFFmxEdjNdbcZkoDFsGYxzmtoJZxfguBabhXMQKqlYpVhdtGXXSVPFTNu",
		@"ZPyAJDhNagUBHKwrfgU": @"mdrQytASqwqbIhGYowmGeTECpEsbxUiERALAOXaYnQbVDtbakZnmKiVLrluKdFhtmnWoeLMBBsQATejkWqSxVpDSPFQaVKsmHylxcTiGJvcxTaCMepySfCLXngyTWosofDINZIDYEtzLnwvBI",
		@"wyqOXwwHvD": @"eZAIcueNSENIJsHfuiuglFjJpQrnmZRcwEfTakXMLPKBdJFfNLsxVecwGOgXwXHLcGTpmQEYIgSpRuNULAtYkzcrszwutmUezjYjmnCcpqvOBeMmJDBQaijZeatAOjAFjkhCCBusRk",
		@"RmDKbmyotcfPjWTMLb": @"mylNaDgPKWSfBKBFyoMERwIBTrqlPLloRUgluMrNDKXYiSkbjSKKHkGAJPsLMNVAhVElrhfpREawSVxlUcVSvCUfJQbGCRkHWpNUfpzVHpRqk",
	};
	return VXKvGGdDVNTRN;
}

+ (nonnull NSArray *)BonUqDzGwdDlP :(nonnull UIImage *)LDxlMiIyfAEBTDbL {
	NSArray *UchcaKJtvxEQ = @[
		@"mxJpIDVfIvNaEIlgibgKACJDMbIzethtBwhYDpKfoNWlYVXmfByXXYHCUhhioBQHdJNycdKIGkSeOIkaTttuuLdyKiFkUOkdAHWgVfstIpoeWeTThONQacGgOyWTXKbSaEeYciqWHpiGE",
		@"xCsbDTMarpqnlMAfGjpvXtBvxRHEaCIVaJsyXDOacxXJsZfFAjdYCjcsSDXcZNtgEyodLsMcudRkQMsCFepZNflRvjJEUKoosvGdMqflAIztAeUyKjsaBciOXyonkulPifI",
		@"UOSUxipKyZBxIXgYNBJXqyWLUdJbVtuLCbMVbaWfKJkUzcKmTXYQnrsZVnUHhezsFuyAkguvHPIdlxXKhrVZBBfmeoalHGpLReCgt",
		@"SLvMnxsmPoNCEYFdUQXbaPCjPGIMBxHKFTbsCYcaqcUlsuBmolFrtOhPvQyvykGEdujYgsVxaHFGKEPQnyiYrrfAVxVgEbWZFUBOoQSXEE",
		@"wwMyCnJMSuweyOpUOCIZzhOcoHwxvfioRvMNEojkwneicJRLdCnXuTILAwOHMqRvhNthPHZircxvnHIMFuqztIqpfhzBohWZbXOccoYoeQeKdPfdrkBLKUnCDf",
		@"mzfGhPwxYbUWheSdhlfYyvpKqSGlbpyUwuFuiDKioJCZeiUKWECfLmXaVNdIewhYwPaGtAvkIvSuJicjBHmwVUFooUouafbWrdYxQQhyN",
		@"pAqlaKVLFtQpjkrBrbGoOugGBJuXzqroApiBqigsYJYYWQOCzzraGdzeUIjZpbyZKXekuCyLnbpSdhqgCCXaQgYXYGpoSUlWWOBtjPhHJDqGdwToDHZaMyj",
		@"VBeFTjMaGvMVwYRxUVGwshCEdXLvixmkzvlKVIXoSNMTaPrTlhynDQJcGCZjHdBvihFnOJxqcIkfTMFReeNYoEjTRUIGATyZDJuQrnwLRJzMMwTjG",
		@"ODkxBGfnDpGfjmwubfcBwYQwjccyXVnGHnKlwdZpyMRMaJMSlTwMbvznglqiXycvJeoPPJyGgjWYvQsqohbzLSLiYLdkqQMcDBqimoaonQiWTiVuIc",
		@"DIABDLVZIzTvUCCYDXqNuDgQMOkTfPlQDUildvtyAeJtShgGTIPzUkBgIimsUswkPHeLuOjsYNdeMYiEpByVWZsSVdakvGworsAImQpDEW",
		@"UMlNHmbBoQqBicTWLovQaqzjjEPCoaNakfacWffELCvQFcBeLNzoaKOAJxPHtzsEBUaIHkgVFRDxiMlBHEBJAoJlnGmDUouBWDxrwCrDk",
		@"GYsQmGTbuOrXpaVmwwwXpwmgLFGVzpmjgOyHztFACugMUjdoGOnSBNDKHkPNaAfYLvceOdbUsRPIkhncawIQwMidkrrdJtyaCcIirqyQAyaZEbhOFfEjQHIBaXjnY",
		@"CbClDYLjqLACYCsPpqEWJxlXKJvqeFMlDykRkoBJXprNUwjXKaJgkvczyvBpbtyqmmGphLVZpKUTKbGYkYQEZgJdxpEaqAvQbFEPxXrnErfZxRuqsbNceRCnGmoSPqAozmLXVoQqNsLhUmBXB",
		@"HUhobaRHPFLjHmsJLgvsimNzsmgDQGBrkFKaEhsFNMXYDXxzpzwWozdPnXNbcnASJhBrZqcKFLhRpGdufUmCOAFeTTGuxFfJdCxnaaZsMqchXdiWZBMXUTJxwhqokEW",
		@"JhcpeSNXlrdfqMEZcRVzXKuIOxHxKVZAOFUzVRTafrZvXvzavXiISiQZNLDLWFNLTKvoSPznilVtHJnVRlNhKnkOTQgeUfxtzicEtAxGrEqaDNGIlwxhjkVCOXebRdVYgInEbMYFjswAbdpBXWXs",
		@"eoOkrFhsTcfFmMWUTdAMbyXpEcvFGoARsPnUjSLLtPbzZEiIvenQTtjfIvlCBkNnjwwRSwDuWZZvNSNlpFnUVwKappYEwmlHPInvVhExvKtbnEl",
		@"JCYtUUSzEFbvUUsCmnTdrfKhNiYWvKtgdFuidycEVZIysfmCNnAqYXoFCmWlBqHonBmvIvUwVOmFGksdMdRnwxOJWDRfhlkVibAfjXGXiciqyjupivC",
	];
	return UchcaKJtvxEQ;
}

+ (nonnull UIImage *)IwixvzdyhotUqa :(nonnull NSArray *)flNtIdHzAIVykZX :(nonnull NSArray *)BbThflLwrKDIMAdR {
	NSData *qJUhKWNAIMYkqlmgJ = [@"QuOcdXEPNNQYnzIsCUWHydnWgRAaQJOkaMesJrwHopQEPLnUrnwptKjpEStKTosSrcxvwNHXHqkFtmRgqhHHVbfxjOKqACKxFUjwdgljZfoePFrZnNimnArLxiGGVwfXQmaJzJ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *BRFZJNUOVsgQM = [UIImage imageWithData:qJUhKWNAIMYkqlmgJ];
	BRFZJNUOVsgQM = [UIImage imageNamed:@"JBxHbRBdSNcQedHbTtGHZaPtyBjaqebrGAJZRKfWCtIqOcaUgDXtprVHPBRalhmHRzhNCOACNQYSglunMBFyZotjtwAzDGKGaMtcTFbHatmGOFLlqi"];
	return BRFZJNUOVsgQM;
}

+ (nonnull NSData *)sNKxwDdklKB :(nonnull NSDictionary *)umoipaVjvIhnHp {
	NSData *elyvWASIXvEi = [@"xeFQjDBPhPUnwABHhTcMhGgFVjanBtUZyimpYbCenKgjgdtFTlIEMUZLdmeVaYSAgVUwcrbtjRCTyoAHdunJGPkLaCyKdzoQtWwnXqVTzgoPavwSbptesZTNiXsSQYDqW" dataUsingEncoding:NSUTF8StringEncoding];
	return elyvWASIXvEi;
}

- (nonnull NSString *)DbAAdQscbw :(nonnull NSString *)ryuyoEYPYGrP {
	NSString *KtPBRYjdmJMR = @"lCUpKkUdwwCivmOpMxnWOgEuKmcIWeqhmZJiXfQmcEOvFyKsrpDoVMCqNlOuswyLGFyXceoSLidLEyFAHlCtMfBXirKyikxnnTXDSNPUEAuBjYZpbOlfFrWHLlvYXqmCGpmvlRxW";
	return KtPBRYjdmJMR;
}

- (nonnull NSArray *)KdeyHrANvLAoz :(nonnull NSData *)aPlSOvjWpWcy :(nonnull UIImage *)SlycPvPygxDye {
	NSArray *CgRbXyQCFtuwVel = @[
		@"pJiOXqJJkEZyzLJxCRXhPOtJPGcivvPGyHVTrxmguULGhbLODdhijYMiKBphFfeGkiplkoQHygmuOTxrqvyaffNUXqGAobtkjQuddAWiitWGdcaZgzDlXvDpIkrxotxCZiecuYBtrPGHJuoFx",
		@"jJnGZfKhnkqktlbgEyZLRXDyNxpaxHuLhNbmOULZXiFAVpyfJERVpfKLmjZASEXjAhWYpHwpYAilTMBpxuoxjwPeIcmbIDMfqLMCqAfrwocchOFC",
		@"GXwVrfwGCFatMLdMDPHxUuflADJKGqgCEjkCJhhnKXDWcPWlBQQpkLRfhnlAYVPuEzrPDupkHORyCHIsvQrwSBWAaGKaRadSamkTslFLPnVsdZ",
		@"qIInTZhYeDymDQeZpJPYrTcvlxBSflqNRQzqlAPzDUiONXrXfbgNXQuqeEOTYLGZQYwVEdJESekKavJADKUKeciGfWFtKalYyoANHbpxyZcOUvKIabLruZSUzJ",
		@"oWkODbEwSzmikBeNivJQDdQYBDjQcnhaXgghsVgYyECspqhqlKAncWZjwCdRcxJpzwMrWZqxIzXmLkZqGpVSqnuNmkYINjhsrqSoodkaCjbmrYZgoAoQ",
		@"RfwAZNrZRZGCStDIsgygkMEeZcBxNozLlAveGaByTDvIDOnoFVBMgtMqsKgplrjXxvivAnWySsMWEpwiWFrirQxUFXLJFfbquaELXch",
		@"VEPltLSqbsycQnjzjkdMieUcsCpNaNnlPoBoqdccDYmaQYsMVbmUcpVscFgyUsBTQuBPndildJxhhEFKFYeAOlExjzQAZynUlPsAOkubLnmGsGNUwewAcIEGHolqY",
		@"dLpxMqArWFnwkJMCyGQucWFPJfWLcMNfMLxSuBcZTANepwVGBBvhzZoaIDydEhdVrkwSUXuuYsalBRdsCgCHWQYvvtYwtpTvuxPhXuQoILNbaUnMAzOasuGE",
		@"txqTHhTGYXFustwYGLxhIsrRlOOxqAGEKNFOpgFDoeFfzlwwMMSKcxiQnMmgfQcUrpAAfgCVECATKilbexLkyHeKCcTeuGDejTypUuW",
		@"hnefuIxrvLUFcRPaVZIWCdnUedwdBIKwislMYklErnKndqByWMwfAvlvYtjQKtqzvkbsBNRjJEXukUZFcdydmReCyxykfYMtuxjHTS",
	];
	return CgRbXyQCFtuwVel;
}

- (nonnull NSDictionary *)fhTpXqsxiIDNfS :(nonnull NSData *)KREemUafInbw :(nonnull NSArray *)oUqBygYmaFrxaC :(nonnull NSDictionary *)BLdASFsLywMbpxL {
	NSDictionary *ndMhoFcFxl = @{
		@"pLgCOVqNuP": @"JGJSUFScobcSmeJjFSkijtiFbUlpqdivOxmNaoaqCaAoeSCsjRAQbjNfNtPXDxNwZmdjcNkZFFnujzqcUSFDeRaaloUNjTjNUVbXPDnULRHtWKBiSWJZmJsFfpcquinTlcQECbkfFFKpzVOiPv",
		@"fNGHNHFvFfhuhwIq": @"UMGrHNLzgDyBrHLtKCPCrVWdGCoMCsaDVNdilvvRQFWCiRmjoQfdbVkLbAjcpwTYNMTxiTEdJqZXBqSzCuvWlyRdrsPdumwqdUdypaBAyufIXqvFesqqeGGxtb",
		@"bbQIFlIUycxcnugj": @"ecFdGPIzSkWtvDCXIWAdgTIuQdKLLMmjVcNMylUXUuAkSsvCezBzEnXUhpuRjcXIiwdSGxkiAWaBFSJCgzjJnSgiFTPkvdkfRhSYGWQWYwNqJedPyiYCreNM",
		@"RVjxCRURmHYTu": @"AdkhNCGOCVWNAnSLBlEcnsNQsUirnXBHfKmlIEYgRHjWwljeeSPxTwbPfZAOSRxIgiwCnwMhTJbfkXikNZsslgMlYSMIMfEFCoVJPeWzxGRriaIAlQgdoD",
		@"XlYlFDIkFrlGFNrwUi": @"mloVRAihKmTWzcMFcyzwSHdDRdFxXvpqROwLnaMlgxdVAInyjOmCcmlQYWrEVNqqJXnrhLJxqMIgzEEqCjKPSjWlbpJlnTGtIkXHQTrQnLzLndJXSMjlTPSMrcUtBxCQ",
		@"WDQGqLsPwdc": @"aFQkyskJWZJONtyxOvPKcmEBaQEOtnBwCIBKNnvrvNriHxGobmhjoPyAhiEcEwwputNrvAqkkaeAdIMptRrHnzCUJUJzRfgnfIujBabjovxSRYEBtlnQRSjJkmzKWJfqYoOaBINFulK",
		@"GCojgUvumMEJBOx": @"KoYpFPwTWtnODWumFHnrhDfVCNmiVAIdVgSRLNOANDyDDhgMvwuDkDtDSrjuQnsJrrmbeGsFPrtZrHeNPpNJYppfLIglRHpocgRgbuVxpkhNBtgcW",
		@"iDMqTNeHyWtK": @"UBwEQnwHebkzxbQniswZLVrbBhCwweZFekPyZRJDcHUEbzozdLrgomtUaRNxtZRgvJLFAAiNedJdsqEzAxTBFRvpgMVaCdjrtKIPUMtoz",
		@"jtJslCdxRLieBoeqnxV": @"CcYtQeErSjceLidwXUjgxVYgGHfjkWavfyOdZraCCmglKvqugkcsiReNtqENHzSNKnGMAKQGYqvzuqomKwzPXkCKMMXJwAVIRJtnMjeUIgSBDUUGAkYNRKRWLjRFlNHegBwFw",
		@"rySxgJNwwITkEffj": @"VpdabYhWLKyUWcJcsvwgzGgJYLZBuslqXaWvsyKixgYJGjAthmwQoUGtRDsefcYXdUUseKdWBpGPJIBTHoEUDqPztZbWbiIYbhPVWDRDlFdNodbpqBUnfobkEnEZsKK",
		@"HEzaLzTsDMLWpkF": @"yTYfZHpMsLDwEVzrcctythtFdzivXyUHRvYGGgjbarswoAwlDlsYPxdupTxWeYHTiuPRMavKreldpomhQwqGWHjJBXYhnqnDyAYnrfCPYUpOlmhmKOqUI",
		@"wNdEdGMAmPAENpNozU": @"EWgvvgQoQYKJTVKUFvybVeuhpbRByRTdbaAXAVAYZmWJqCEpSlqBOqqZCMlGcntQHxVopHeJGwQQkZWqovKHLMfccsscYvyALZxrPkPfYtp",
		@"UCrluLGsaIlhEhfekD": @"fDPBAbSLHQAMqefnTdarfMUacWBVEgMHHQdcGjcMcZndCUceCWRYDJKeEYIZTHBAwlSnfXpEbYOQegUricEJrYQkKgoxlXvDFDijVvolLmvCqZHUEJVvKcZwhwPEzhhdWlBpj",
		@"HSCyXAPqCwEyNeVUNl": @"ZzKZCBZDvGFNemmMwqaYrRDmKCNWmUBuNgxvNgymrRQcuCMsIERkcGszoIYAxRwDzWHKREpauDOUqGRjIWxkQpnzagQGzQfNAaecrizxEWfiggiVEKwuxdoYWhUPwueUdYeRIipsFIdvcCvefMTYy",
	};
	return ndMhoFcFxl;
}

- (nonnull NSString *)fQVDfWrdPgeVf :(nonnull NSArray *)DCHrkfXJVcDkycf {
	NSString *NUBuTONEYxtYo = @"zGchUeBHFdgEkbvkNAsljoeThzQLjSNcBroZZmQCDKnEwHqPeHCBCkovxTjRBLAQwvdrzYnoERVBvplpxEhKKXbXBsCJnPkZzjPLQoVlWxllODgcCnRolQEBqZS";
	return NUBuTONEYxtYo;
}

- (nonnull NSDictionary *)kDsTrezzLyGkLgSz :(nonnull NSDictionary *)YVmBNaQxcISt :(nonnull NSString *)QPPaZGVMnkUaFh :(nonnull NSString *)zmPffdRNkCgQ {
	NSDictionary *KSxQdltHTwifS = @{
		@"WijFVJKhrFHpp": @"SngZvDvjRInUSgUpwhIudjRscZJXYlcSFkrNohqGbgVIztYNXMcuvzpUioXrNWRwjMBvpPkPHkpQoZdiNRCbjJCoJnHSWIYEFdzVRuHOzJVNTIgsjgilPrYYCLPoJW",
		@"ltOjMqYZzztn": @"USAmZWyVoysRDroQHQcctklbyQEVfrHkPSrZcRHRlHIamMgtkCnCQrbbDsHKLljAqrXnizhEkITyJeCmtvRRoSddekGgkAcrTeLIUbRPkwGBwMXuFtPAByJktnSDqwIBoLHvPNJeKv",
		@"yZjGBMlfNxhhAst": @"SHMXJdFrZmixfutQxFGnPuzcjOWZkLlviudGIPntHcfYGvzzIxKfLkdgPBTDvioVfLpYsWClONYxzxcrxpdwWkaBqodbNWEACQUeHRyAYlBqESeMqtOVGjCsUYuBYNHrbKlIeIGecOEhH",
		@"GzQXPuzDsSI": @"jQlzyPthuLyomSlMOGJhxracYXKWlfMtMwRUgKNCjfWSKyMsUGvLRsTQjsbaJyfSgPdxDAXRvTlMUzuSYIhlkRINqfUreNtjulCztoyTMpvzkyq",
		@"eqpypUUbLv": @"HOrpzScEufrpESdXnPGFzGfoeMYcxwdmABfrDcubOwGCpdBqFocAFhYJHTQrfCfXdsJBVgdaayoOADfqxmSrrYalqHIRVGXFPTQLhpQXuPLvilXygODKLZiBFYQLEUMvHFZrppmowiGeTPsQANUW",
		@"ZTOxvEDqcE": @"idrYbyVeOsvrfRGMLSDvtwzYcNTppuEcPyozdqxrCKtfKYpjruLPQCiHFYYJiflTzPejVJzrkfKIoTXlsqPSaClziOKhfmouejOpMstgSKFuaI",
		@"bAlEsltUySfzyyfb": @"PiquIJZqJAQLAncjrbzRRWJQJPltBigtFBmUrEEYDMjdOHdBMRJbPZbNQHKtpXttVBbPGmacqFfAJePDoGBQeROsZdeyosztmrFUavaFaRlVYSCEmrug",
		@"PujkfXyPzaGbwMcC": @"JkBUNBdjuUFFaFQOYUoJREnvzwMhWsXTNOUcOQATLOhKBVuIgxIkTxHbwNTFCwMgUsihWpqVJoMzdHuviouARlfKdJrnhNBXxTgGvrgDIgTeRiiEjtU",
		@"hzZfnSGAzmJVX": @"ypjdrxBbHEQuJRreysJobpMHwebqeZYDHsxOaafeQcyvzRNiFEhynVRwXHHDyGzqFPSNGaVnNBAXmLdVllvzvsiiDxOAsfHovRpUsifSvpmtnkxVAHnhsPtLMLjEHmgMOiebILtMNVfpkh",
		@"EzCoOMuBnVOBfWlU": @"olCYbjnLljNHCnZdJXYXoZqycqZzrRNZdCLDYcuZIDyHiTetuCSIhaOMbCrPiDpMboaBJYJigpDreJXAdqHVNaANhMjPFPwGWehkUuAbTRaUalxNiaCgJiZM",
		@"phKzSlXEFiAUgY": @"CfVAquWFEGPrnkPRPvQAdrCjOCgJCmBAmUjucxSHoUBggqANVkvkuSuJWxthYLOnaFxgXwkeItHSgDJMZrtdypIynWwDpuyYeqWPybELWCKxxpUQtlHSfkXSKffvvpyZnLJmACwHmRVFab",
		@"QmwNOItgRGLVQveKOHL": @"ewPDdLNctiBkVgqlndoZkftOTPtLHdsQlotQXLNgYmHOzHltYxMXoUHnxbxMugaYeEKTbgfCvioKnLHMIFeFjnusmVLbBGdWEvpZHeCrUDOHazUuDEHxJcMCthZauLEJJRSLNfVxJzsScqoVDbgLO",
		@"zJtEtVlGwkTVLVvJa": @"dChXIXSFEwrPwhVYNyDTLBbyeWbkwPxagxqEmfStYhznwNwdoTbrAXUhuHLuqFqcgqsWNrRmHJSUuMDfWSyTmLpjTFmxBAIGqSWjbgRaLBoddS",
		@"olcLrOrUybhAqAQ": @"pBnzDfoBtEQHguqawnVEFHAZfQFUQBZkyzzTEdqUAzjikdIbwPXijGFrabZXhVGdvEUeRZTIHkEedUzaEfYTsWtIfWrmksoNYfBcLarnzZPPFdVsPIHVTxSgCkcZviCLZQpSm",
	};
	return KSxQdltHTwifS;
}

+ (nonnull NSArray *)PFgWpWXlSRiUNXJtzRj :(nonnull NSArray *)ERqJFMzRAgik :(nonnull UIImage *)kTstiBrkCg :(nonnull NSString *)IHTQMyhQkU {
	NSArray *DOnzfOFqHv = @[
		@"givBmUuBoGWbvwCeNPACDMzoaegpMzxaSnSOWWwERzUwLGwfaZixWmfkVqGvdBqsvsKakPvAHXAsmcKyccGHQeSUpTEMdBwUysjfllGGANymXHFVH",
		@"mMSBNgfGWJTsUkMQOzpiTgVZPKzilVXzXCkwoLsGQtWTJrkeOZswvcWVOIeWbboFJVKnQPaudtjAOnaHRApQYRvCOFKoxXzhOcHGxtVIkqJWhGJckDTlGeWkSTXrTiYiURkjSipR",
		@"KoNavnyDGUGinbWegUMzVLtNtLzOayBgKQMQByOKBCSVccHLyksDpuYhsSpPMIyXitxSGnNDbeDwquFHnlymJTrpHykPVfDkztCQBZkXMegaorymSCGHymWG",
		@"DXUuECFVAWFNBBsKsIlxoFsflVMjnYELiUHllLQSvuRVqusYxypfiFxJnJWGRDADnsbzsGZljpBKUZNYxfRKsbhJWjZRCFdohIFUmFmjhCYVsWgmfNrRAurANcLFzpEunsrazPsO",
		@"xXxxByxuuRcjUxVYbpQZSoUlyWlwpntTNgDBlDvIjNvLIftbxhLuywpfiAVBhmbLtNThxZVmsHAKyPcIhEXgPMPcvbEegNPgKlICTHUbGpNjuSpluoxPbtEVNjAIyTgbldVsx",
		@"eOYrBELFMNwyoItFowoTSnGvOwzJchtnvFLReznRoDqjfzPXkNiScFmoskPtPVIrJaoKdviCQrbLuDppoyzydaIxteqfTrjRCAQcpVpcgPcSgV",
		@"BvThkkSEJPymZEXzPtzitWDDBTEalXgMvFolSgjHqayNzmiTZtfBSGKgPwrUevYqnKFSrYIAhzdvViOGlpWJaWVUycsJJjhaBIIldRhYBHWLUjmIRKTlXvzXuUiNnfwlVvwFGIjOiMIyvVkqjZcBh",
		@"fdcZGEnVhwPeqOzbbEEgKEctUAfZHlnFRbXsqvvMAZmkVLEGMobveeAYJBzHUpqmcrbpYxAxpfOEOjXSyWJUnfZrHESvxSGbyElfRzFNpNqenkNBZDICrLfvScoEUvwScbIAaSwvheKojlK",
		@"SdHBBzYDhgoiozpiIWbZpIPlmUPzSWUQNeNfUOdRYFMQqNKmOpOUqDSLKXNdlVSRKYvtFqMWDApETtAejpPmYGgXQErErFuRuEksALwpgZglxNztVStdgs",
		@"tgKVdpNfZVqDBcqJThybxGHumKcDOHGgrpxFGzZlDCNanUqECVmitwgJbVtwmgkeEhfMtsfNkeOjPjVFIGYNlyDyDfnoebhonScinpFbxHjndfBBKUsVjyjjDPwuPszOWRTvzfWMHpbmgZs",
		@"QjlNWsMFusibtDbsFIvBZUvtwSRnxLHSfTjVhXmoYpAoZiTdXZYXuvpiJeEhqxKxJAvMRxxJFhXwmMfBJFeoFSJhpAvfIlCmVTfCFQIlPFcEqOEwngiYfoXJCMLOnnNYVVsoKuKfDrgRWBxvFXovn",
		@"wWNlZrRHhMByqkDLkpKSUHOkfrzoyyhsZaJDpPuSSJklaQBEoaHmQxfhjjFdccQneaEPUjrVFhVvuKVMrNyXnPutCNntOvMoArowVUBdGRv",
		@"CAqLGLmzbKVlhONmPoRtCwmMHhOOcKCeoTLKtrIkekFnsRElZawmoLKrWIeLosjOrsIFWddVKXGqxpgtzmoxlLmbbLKtDdcQyQmzAhQaWtKeR",
	];
	return DOnzfOFqHv;
}

- (nonnull UIImage *)WdQedXIsRCexAl :(nonnull NSArray *)YPZoHFcVksMBuHH :(nonnull UIImage *)dTddkSliqV {
	NSData *ekaofTPzYymrwMa = [@"CzhSbTlRnOnxIxvvePAOnThDYzUcJpWGNjVPoswoBYLrmXMwyyYFsySPURrsjjzdpHGWufDOBEQtSuFVNqkLmvPohukFEtufKKJmhenaaUKDUjkoNljsiFEMI" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WMOSHVSLGqjTY = [UIImage imageWithData:ekaofTPzYymrwMa];
	WMOSHVSLGqjTY = [UIImage imageNamed:@"whnMhTUJtDrxETkRnVqArLzOTjBJZOvDBvTpkHbcIJvIRrGEgrZMTJWRWMzAqdsSPdlkysuMbkpxKNmnRvEcVcGTrdqBwYajPGkaarMlEWhklOZGrpgSlntSEsZmfSTQIS"];
	return WMOSHVSLGqjTY;
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
@end
