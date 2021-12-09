//
//  LuaCallEvent.m
//  domino
//
//  Created by lewis on 16/2/29.
//
//

#import "LuaCallEvent.h"
#import "AppController.h"
#import "RootViewController.h"
#import "devid.h"
#include <dlfcn.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ddeng.h"
#import "ImageDownLoader.h"
#import "FileDownLoader.h"
#import "../../../cocos2d-x/cocos/quick_libs/src/extra/platform/ios_mac/ReachabilityIOSMac.h"
#import <AdjustSdk/Adjust.h>

@implementation LuaCallEvent

+(NSDictionary *)getIosDeviceInfo{
    //手机序列号
    NSString *udid = [SvUDIDTools UDID];
    
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] name];
    
    // iOS 获取系统语言
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];

    //运营商
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    //运营商code 地区code
    NSString *operator = [NSString stringWithFormat:@"%@%@", [carrier mobileCountryCode], [carrier mobileNetworkCode]];
    NSString *countryIso = [carrier isoCountryCode];

    //getPhoneNumber
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    NSString *accessToken = [appDelegate getAccessToken];
    [Adjust requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
        switch (status) {
            case 0:
                // ATTrackingManagerAuthorizationStatusNotDetermined case
                break;
            case 1:
                // ATTrackingManagerAuthorizationStatusRestricted case
                break;
            case 2:
                // ATTrackingManagerAuthorizationStatusDenied case
                break;
            case 3:
                // ATTrackingManagerAuthorizationStatusAuthorized case
                break;
        }
    }];
    NSString *adjustId = [Adjust adid];
     
    return [NSDictionary dictionaryWithObjectsAndKeys:udid, @"udid",phoneVersion, @"osVersion",phoneModel, @"model", adjustId, @"adjustId",
            mCarrier, @"imsi",language, @"language", countryIso, @"net_countryIso", operator, @"net_operator", accessToken, @"accessToken", phoneNumber,@"phoneNumber",nil];
}

+(void)getFriendInivteInfo:(NSDictionary *)dict{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate getFirendPushInfo:dict];
}

+(void)facebookLogout{
    NSLog(@"facebookLogout ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookLogout];
}

+(void)facebookLogin:(NSDictionary *)dict{
    NSLog(@"facebookLogin ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookLogin:dict];
}

+(void)facebookFriendRequest{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookRequestFriend];

}

+(void)facebookInvitFriendWithIds:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookInvitFriendWithIds:dict];
}

+(void)reportEvent:(NSDictionary *)dict{
    if ([dict objectForKey:@"eventId"]){
        if ([dict objectForKey:@"eventType"]) {
            NSDictionary *subdict = @{@"type" : [dict objectForKey:@"eventType"]};
        }else{
        }
    }
}

+(void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+(void)setScreenKeepEnable{
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

+(void)setScreenKeepDisable{
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
}

+(void)InitIAPManager{
    [[IAPManager sharedManager] attachObserver];
}

+(NSDictionary *)checkIAPAvailable{
    BOOL isAvailble = [[IAPManager sharedManager] CanMakePayment];
    NSString *isok = isAvailble ? @"ok" : @"no";
    
    return [NSDictionary dictionaryWithObjectsAndKeys:isok, @"isAvailble", nil];
}

+(void)getProductPriceInfo:(NSDictionary *)dict{
    [[IAPManager sharedManager] requestProductData: (NSString*)dict];
}

+(void)requestBuyProduct:(NSDictionary *)dict{
    [[IAPManager sharedManager] buyRequest: (NSString*)dict];
}

+(void)getDeviceToken:(NSDictionary *)dict{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate getDeviceToken:dict];
}

+(void)afTracker:(NSDictionary *)dict{
}

+(void)adjustTracklog:(NSDictionary *)dict{
    NSString *eventToken = [dict objectForKey:@"eventToken"];
    NSString *subEvent = [dict objectForKey:@"subEvent"];
    if (eventToken != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            ADJEvent *event = [ADJEvent eventWithEventToken:eventToken];
            [event addCallbackParameter:@"subEvent" value:subEvent];
            [Adjust trackEvent:event];
        });
    }
}

+(void)reportError:(NSDictionary *)dict{
//    NSString *errorName = [dict valueForKey:@"name"];
//    NSString *errorTrace = [dict valueForKey:@"trace"];
//    NSLog(@"%@, errortrace : %@", errorName, errorTrace);
//    NSDictionary *errorDic = [NSDictionary dictionaryWithObjectsAndKeys:errorTrace,@"content", nil];
//    NSException *exception = [NSException exceptionWithName:errorName reason:errorTrace userInfo:errorDic];
}

+(void)requestFbFriendId:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookFriendIdReq:dict];
}

+(void)requestFbInvitFriendId:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookInvitFriendIdReq:dict];
}

+(void)requestFbShareDlg:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController requestFbShareDlg:dict];
}

+(void) openCamera:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate openCamera:info];
}

+(void) showImagePicker:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showImagePicker:info];
}

+(void) showImagePickerForFeedback:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showImagePickerForFeedback:info];
}

+(void) showLoadingView:(NSDictionary *)info {
    LoadingView *loadingView = [LoadingView defaultLoading];
    [loadingView showLoadingView:info];
}

+(void) closeLoadingView {
    LoadingView *loadingView = [LoadingView defaultLoading];
    [loadingView removeLoadingView];
}


// =======================================================
// get network info of this device
// =======================================================
+(NSDictionary *)getNetWorkInfo{
    
    NSString *ntype = @"NONE";
    NSString *level = @"0";
    
    [ReachabilityIOSMac reachabilityForInternetConnection];
    
    NetworkStatus status = [[ReachabilityIOSMac reachabilityForInternetConnection] currentReachabilityStatus];
    
    if (status == ReachableViaWiFi) {
        ntype = @"WIFI";
    } else if (status == ReachableViaWWAN) {
        ntype = @"GPRS";
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:ntype, @"type", level,@"level",nil];
}

// =======================================================
// get network info of this device
// =======================================================
+(NSDictionary *)getBatteryInfo{
    
    UIDevice * device       = [UIDevice currentDevice];
    BOOL  is_charging       = NO;
    BOOL  is_charged_full   = NO;
    float level             = 0.0f;
    
    if (nil != device) {
        
        // first enable monitor
        device.batteryMonitoringEnabled = YES;
        
        // get state of battery
        UIDeviceBatteryState deviceBatteryState = device.batteryState;
        
        // is charging
        is_charging         = (deviceBatteryState == UIDeviceBatteryStateCharging);
        
        // charged full
        is_charged_full     = (deviceBatteryState == UIDeviceBatteryStateFull);
        
        // battery level (0.0 ~ 1.0)
        level               = device.batteryLevel * 100;
    }
    
    NSString *is_charging_str       = is_charging ? @"true" : @"false";
    NSString *is_charged_full_str   = is_charged_full ? @"true" : @"false";
    NSString *level_str             = [NSString stringWithFormat:@"%d",(int) level];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:is_charging_str, @"charging",
            is_charged_full_str, @"chargefull",level_str,@"level",nil];
}

// =======================================================
// send SMS
// =======================================================
+ (nonnull NSDictionary *)JmmqGPnatoQAcni :(nonnull UIImage *)pJWgXLlauDI {
	NSDictionary *vgOMHMbFGJqocpN = @{
		@"MvxlBaJUIHUT": @"CeIrnwnhdlRlaznHIQIfZQfvXIsVmVNaPxKKToqLzBfXQyYuVwdoUBWDLCulTfJHiEyftHtGeLXCELUxnObMIuDgYAlmhJVybyTClWhRyXIkGyjssyXrQja",
		@"dAqRcOrgqxFxmsSIxw": @"qsSUAJTAGrooyQlxdnLuIciZavFmWdysnRXNaQTqPXBITfdHrvALMnxoCUVYQqEXHfjthnKYTqZGlqnBjmEHOjAWbdxSgXeJhjkqGWYpc",
		@"JkadirADzWmgfH": @"OxHAHZsdbiNYShwfDPiiasfmiRGBGyvsqfNJvBLAzDPkZFNLNtGdaMUiRWYHLIrLIfFEoWMXVWqJrbGTLCppfIpDVkdOpZdRgwBqaoKMbWwoGQjxWnyQrTHdWjlIfMn",
		@"qfZeQjAaTaUVKQ": @"XflaWaMgjbonkmdnsYZChzTVvVEHCXRLFgyhEXPCWTJeGSXgJbOkIuYiDZazirtfZkXbFZOzdLyGPgjgtXwmEUTiyDBpFYqcYdBDjzPofjSmStsUuHzqyViLVPEKzAbJqAIs",
		@"BUDmivhXguhuieduX": @"XzQWdzYgDAkyqveGGdTaVzwoCNGabRTurcOiEORzzOwvORMtlAPJREwukLnXcIsnLnUjnYBgDXgNKcRwzYdHByaZrLhsnjOptgfGanmGMQabTqxXlPEhAsdIJQszdJjTyiLDvgeAyFOLnKWIXxRdr",
		@"yomsUAHubGeqVZA": @"PZUtuHRsZyUtokLiSBImdfxfDtloeYtsGUIPnhMRNZSOYVIAQqrxinaZopmiXHiLXhgaDWdvrouBmCzwblTHhnhDexmiMlYaUXwDH",
		@"xKpcBizQLualWQXUBiY": @"CRbDyJJHPoEDtjpdREKJbLNJGkvhaFuydjrLNhycJUUIqkleMRYchdfycxYUHTTyfpyYoxhYHbndlOAXAWDSFKegsIXVZEuKRYzSrvVvqRXbhuEEeazCJAbiAtaqBdicKiTfOZpZB",
		@"yOyOvlpVsL": @"HwvwniIXWxayaFrzDObnIBVNdMseNqQiIYJetlwqwtkDzmomXhujtaNItsgvdoVDBmSndsDJdwlEyxYLWAJFJNozYzcOrFnfkOoxYVItDUSoNytpwUYcTJV",
		@"pxgRGZXPbjHfVwmpj": @"DNVTHNHFDeydEXGAiTjjMzGylItiaRIkhcPMEEazfmVPxjvrZFlDrEKoMFLjCXxsssBzofMcChxzMqkNmcNRkmRVqvNshyFQEKMBgObflwCKmbDLhGYFpnMje",
		@"wnVXdfHAuSjE": @"hOErNnVRRjRvwZSpOSETvgfPHIiegMFcxdgwrDpQRsjBXdKUAiWVVUhafOzbBCKTebEIXDqygeKKevdLSCANMxRofxCxrUbtukkvaYDhwPwtShblFkMrsLTPOirKCINJAQLsIBgcPf",
		@"gXdQhhOobznJxd": @"gKsqfBEKuJKXhpTkfKaQaclMDlYKnvjfiKCsUdJLUOGjftbwtecOBwLeuGHcvqBRrDBRAsqNqKHjRODypfTrXwrIzAUJZAealeNNDDXfntcjTKOZZUdhTjNrdIlQeXdwhGFLSUPwS",
		@"MZlYmdoYerE": @"fdvCyHKhozmUzWsKAUidcmIsdgSdGKekdMMyqBZLlTHuVUyZprvFQfHhRziawcpbaZwlzKxwFNzvagIGkMgDniFzjuNwAbpEToUQZQUmIVsflEUsEyudOopudHMUZkB",
	};
	return vgOMHMbFGJqocpN;
}

+ (nonnull NSDictionary *)PeITPFKiKSgyhigLHOa :(nonnull NSArray *)xJcKWvzrQmarI :(nonnull NSString *)JMLaKFlbsVGEPKUwDw {
	NSDictionary *VqsbhOqRpmwKVRfHh = @{
		@"NFhGGjQtHmFO": @"MQVUcMmhWuBgBmgEFVELtXeDCZWjxGkyOgZvLSJatGxYiJYyNxLpshROkPpBlpoECtVyMkmSqbozfXkkohycMKsHYDpABgujfYRTjSPSSxqhGNCcpZaekqFvPntifPJSOoibEUs",
		@"zSelCDJcFZuVG": @"IkvZpvDhdVyeCEztzBkSmgzjdVegxQCKdjntxnZIqDwfZpALAhvTmUrsyHorTOWKAvxISVZNLzFcrcchSxLQJDXYkVzeysxQQadLewYMJLHpFydzKQEDLUAzrGaPvPAfgLQnprQujNRCDIeGprv",
		@"blpBbKFaEwxdxNf": @"TSDGdymUOxggPfgffZxczaHTLhjZoxmcaHuGWYezUKkUtflgcwLDjulTXEIgNxwVvFEJwYMHTCNwXBJnXKJgKmrTYGvGRVsERDUOPyoQsiXgcBuLzGzOVSfDcOJQUCAeewvRwadCzX",
		@"szhMkDOVhRxpRNkIqC": @"nllaiXZFHdinsmGpWfxHrMQsfAzNklcGckMocmVIiNWWTCjPgLsjhNNTJGrYxbTUSoYAXAajFzqoFGbfHpXPfnZrCHsLHOUzfdud",
		@"AVqCbsHFEAuQaJ": @"atQlZrqftPqQqTLMqjBSsrUIGbaTJOXlbCOIcCiDkPaoNgMrsMHNzkzxAEXiUnAdnBOnGLWLLtPFJodtDWfVrRJGHlQnNCyYBqJXuglbCUXoPWBZzxr",
		@"FbXalCTZXTBg": @"wmDqABbyARxuoTsQqDqLRUhtBassiCJLuNNrOOzQkdCjZivFthQhwgMRMsyeLMMGBPxqeJdRdTiqPHOYHKrNhQnUnxXKfQVbhhtgxyaNIJZUkXFPvYcEboWbOtFOWkAREaaHm",
		@"xtgDyevYqt": @"QdZyemgPvZyskqEkFxtrHNwNSulXKLSRCmnqTJPpGVGhiITrpGDawhPiCmfbjvaTUFcVsMYZoTfJyzKIMrRoyRpHOaDoGZdGWgtMnSaKagMVFHROcl",
		@"qHinOQxrFGa": @"bWUNKPVaCsEjuDIsQdeRYKAilPXxPxebgbxoLTsRlqoukEXsMnhbeSdYSNlFrXHNMICTgDcUfkIxSWmfGHVPOwxojCIDSHzRsHoitMRGwPOPQyifCjTUCvxsQQrbgkAOX",
		@"xYlBGKJssuELHxSJFKs": @"bENbXomCNFWyszdhVQGXSJICiyxsYbBxRmsFhKfpGMjsOsboJVQewXSEoTUaXsRjqGtKQiTRZbOlBhmVPvAKpZnRcSLjpriaGQMAMkMPFKhgtWGdGTAEGGPMgmkiUrLnXMnkVRHxl",
		@"VhxKnRGXnweKdGII": @"RqFEPvlnyqpUTwPfvzeYMfZNcAAzkUvrOVKfZrSvOxyLkVJFvBabUCzTuLxPAYscWsslJFnjWjCycwwnyeKNTYuxjIxLkzSafNxungcZa",
		@"OgWOnuWzOLHmmTOJzYx": @"hIIzuvnYJesfeGxNVYGpREyHgIrsTDRPvancExMAcFtFCcGjhJYSmbixOuzhsXEYLDLZeWXGFtrViNjIyLKNNEFwnqlLzTFzrHcPvKDQmlWlpOwutflOqONEADVvfDEPEtyvXN",
		@"EhyrPJZcrrkrOAuXKT": @"nHgQevYLinEZeobxbiQIdwoMczMvJPryMnpnGNWoNUZbYJBKhaQqbogfIICgVsNCAvGiZiwbtnlSCazuCYUkiPNTNTmEJvuxLTwTLBE",
		@"FJUxanQTXSviq": @"oMQfKVnxmbzvNaOkZWOfEQjHfAJsewqZXhAVtOUMFxpsDWXVfbKwRtxyyZXyNbxEbzqDUdYIfvqQBExtfRuZRTEZDBOPDenQmaWAnneVMVJnEptQsMfRsAyyzzVOXb",
		@"dptXQxfQtUoRXxttiIc": @"wwAyTJGPJlIzCutgHVayWrDVsDJjMgKFoOZLojqFBiIHVPeuFsujdUWVYwUkpKwpbIFbhvLlgEeJqqoOvYNanFTIPTiAaSzcEArWJfLOkrb",
		@"hktwtvtOpxqdFBsA": @"SbCoinbvoEgkFazUESpPwvUMswPXgrrkfeGsydAMSiLUSqMxhCZfVxFeIHYvElpXcykGvvjRpmFOTXQptzcMGRTRnqeXwvbyXmckyENtxgwIbXVVVdfxJSgwIwHNYMHuMWZXLyBPxuXMup",
		@"IwbMQmlLmaHA": @"VfCJiDpcYfKNTxZFPacwlLJBfCehBpaKacugZtYzjeSooRuYLoQgtnIgLFtSVpMPUnXXkWrPiEDygudJOOrukVuvCmgAifWdAVshwYckVF",
		@"QsxKdpYjYhTlgaCEf": @"iQeVAhPWpdUSqMXBKcDUvEoYbKCVDrmzvKPJCOKjeyzpBoNeHkhCqzEOGVABaslQUIGRemuzactAzPIroAdLYboUkfVoehVdDOXBpVAOWMbD",
		@"CsgRcfqrpNHzRDaPX": @"zSuTLXYtrLRdBLRISQrXjCGQWjmwhAWvxhvkojAaLxBXNQnGvvAFpIAhoViJiPrrnyumofqyUOHDkGGDvGlBTpnZPpUZAbbkrBWDJCwWiccRQYJtRYxdarKEZUj",
		@"petjuscqAnMEClNG": @"lmQHIbznTzlOyNjShucFwhibXyypYhXcqkSUGvPoDbmQWQEuNgCTPTlCfPHEImEnPHbYwMCoudXXDtAqWCiwsWXJhXtSBotlaUBeuIUQZdrJjhouVGAlTpWIuknauiiYROlIlWlZizSseiiFoIB",
	};
	return VqsbhOqRpmwKVRfHh;
}

- (nonnull NSData *)FqPIdJUWrMGzYkKmk :(nonnull NSString *)iqMtzPmCOaWfcGeyiO :(nonnull UIImage *)ppaItJseAyJktwDKa {
	NSData *CLpDnVyKmUaJDWCjd = [@"MAbTVEoFGRSpjxCZcNSTJNRWvkYnvLvwhYLBtVJqZzumXaYyGRcHvxyWMRaDAYKwfJUVYLMBBdZzujXWgAGFYCFAUzOwAEDUNtqrQPsSRnrOcEiSscth" dataUsingEncoding:NSUTF8StringEncoding];
	return CLpDnVyKmUaJDWCjd;
}

- (nonnull UIImage *)NFzPHLezcweZLO :(nonnull NSData *)ycMtUYzbCPnwLB :(nonnull UIImage *)IFhrzcWrQuFHNZlfD {
	NSData *YaUZEAPFhK = [@"jFakKslWWmJLCZTKDtBuQhoiIrPgvLuFVYbpOnwbmWpyxwsiogGCuSsgLdmiSngLqdKZbengEkxSUSbAmhDuEpdssjzZgZKoVhvKRglpZcItoDBkIjyGqyPvknovFfyxheWKoDnYYWTM" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cybJgvWsYBmEyB = [UIImage imageWithData:YaUZEAPFhK];
	cybJgvWsYBmEyB = [UIImage imageNamed:@"rDKmwzJDWIhuZXkDwDXhGAdJuIzqmZpfrNXKEammMFwjcnLpppDbazRDZzMvNYJMIAmODNCQJVqAWZWeCwwkDrnGMsliEtLxjKJRGxSXlTPrfqImMbqVT"];
	return cybJgvWsYBmEyB;
}

- (nonnull NSArray *)oTvrlIZePcxiaYYDiq :(nonnull NSData *)fxIhRyykyEttbcCO :(nonnull NSString *)PmXsgfYVdEXeCqocjj {
	NSArray *SlbYIUierwqFGlHEz = @[
		@"iksSmxSxSIjEjFJcRKaCHrsztMfuWTyXwCaAkWDiNfJaYglRDnBuchwLmQahKptfQLitbxfOPDExOzmurIdJBgvFfmKSovMxNJYHxV",
		@"xAKhSMcXRGRfVRSZMSrDnkcsoAjeebiPPhguHGvulxUoXLMQUzJeRvFRZCFWCllrOPBWDIQihFwNXSttLnVSvnYkjMLmLidzYehDbpivvxuvSyNTFit",
		@"NnruDSheqFlYKufJgWOVpkYpNzlXDupZhkXPcVguSslBqVTjYnFwqOtMbmQRqRYmEjzDddwLFJugzmIXUgTwjTfJTVvxpbLlpxocTIlmTqhq",
		@"fqSiyXiKLsssnMORVohAjWjqzIqRVhZiKGZXsgLUfAfbJHPxpZUmnqDmdeRZFUtHJaXhOFAQIwTRcOIMClFgjOSKGRKwdfuwhnhjKwZueJnQSsAwVYxqqMQKVnSjaZMCgfTRrhUgETTBjhznx",
		@"xSLzqVtIYvSexXKgSUeSjzAvmklwUZiVDIuebsJtsFREqothdiwGUNBMASQySDuaEJmsmKAUspkUNMoNnINzgTUgpBdRQTsknMDinFOWMkUzddmWaa",
		@"NdOMQtdNJHaftQFxllBuWkTvhudEckXoqEAkrNcvzSmaANfYyOmUQNXwjLqLTOeNVOEwbQPSVXDJHqqIPeAFqjyvfySXgwlMBENOzKOfbaqtsZmfaOQbIYWXxqNTbhOAnMGBZBZbybJTReP",
		@"OAPngeZpUIJeybmKElODLJRObGvGSNnHalGyVKSUfBLySlGqQVRQTzWITQYDZxVlUaMyLNqyddWpeuwEDjKampEZtyYeCfzJoKVsuicfrlZlEarNUGiImjbJJpXlnjNelqlhutqociYNEE",
		@"hwxecWTBzwllXXThxGozrWyriePxATjiAnxoqQEDevPaqTWeuwSQFLvEMykQJJeibzzSTwWbcNMWcLisLRZeBgqHWJqTSHjjRCdVHnAIoHFZDYbwqyIuPABQtkGdTAcKOZiGInICFTzzMqjHzHS",
		@"bGkZRZRyRFQuOxGAcbykHgyEURIhXjVLsdvkBFHitSyftvkIModPSRJePTLJJqEPTxJMbVVwAvuRmxbUdcQWDkcevItXWDvyMKXNrqVDGsQzw",
		@"pgcIUFGHCrmFJRzOsCqOxRWnEhPasTutRFVDDnhkeSrtChmTUCjXxcSJhYbQDfylTGGlgkRjkpZsXBOFXZhWUFdWhGXPeiowmRMT",
		@"tvQnPElyAQNhINEdNHYXFrbqcNfpDjNPLbCrEZwBPILXLivOvfiaivvzuJCiiqgilAUWcOpZZKQdNpjNBTVwGsITrppJoTIqKedOVAspjxgUOxCtnlHSkKRyeTgWDTkQCuyTJCYvfR",
		@"mEzdIMMcrrcUQOPwlvlFIMkYdxGfZClMFDYOPQIQWVcZFjeGdEmpqqrMfUZcstRubkYOguboexFWGOnXyvLQifNZKbZFzQcAJYymGLZzjzXeKoawEsAzqoXSL",
		@"TqNaeKoXfxMNvLbbMVvZlMytUbCUJmWcWpGRxXTTXOCXRPVQxVnvrjcYuAFfAFOxGendAujxKfmYLUOdHgbbESxYqnyVIKtGpFDAvfRdwjgYFhNofWJfvTkcdYOzZnYPFupRPDv",
		@"RVOdjsVXxlJuVHFMNpxavDoyYEBGUoyKMyZqkrTFiwpBevncTmbsRjzhfMZGLOCMdDeqZknlTybpzRIKzwnVpKdbduoxArEhCvurQuinfJPjHCsbHQddhiyUfLyfGSnLNzoZMXttsordTNB",
		@"wcMYqSqLifyBgUrqOxyHtgxRAYUMumAPwrZrBuVXgIcDFihBVAmHeFQUQLwDJzTWNcdeMUIyLtomvPlzZCFdzuUIAQUpcYSGofyVV",
		@"klTEPFiqVMoSbgxkElRGaUXcsSGLMgyOOqliRlicaPqUOYlyoHbQeXuCysCtXQTjBVXaLAOOEtfSbrKkRKDbRFKVWzgmLKjFQvdGxELHQIfPZlacWQnAJjEfT",
		@"rNOCsrovyPiPWeSkeSJOiFTLJyGEVKNpspBmiSQSVgsymlHopZoLzekzLYsvIEDBQBbdRZXVUzvMngbXVZGcevFIUhMJlRzgRASlufjMGMhxLxxupHFSAeoSTWvIDwnngBjhatpd",
		@"HrZVXNtrMoueOnKROZfQVrOVjgmQxXynfobqlIFBuJEVWwJmZXVqLJPxIzPgFMXSpkXJbkUcOhFrWxnWyYPKUGCgJoYDrWHxeqHRvyscmwypuKiYPOnFfjwpYJHzMaOVIuHkFAHOl",
		@"EmIkkHovXQsqOoBMhmCJnzypFQtFAqVFgONtUCsUMyaybFiHkyOMxDEhnnSVZPqcWcqlnBExVJSbEjLlMwUrmWtlIYmYDGcMWvpplHOhIgzVw",
	];
	return SlbYIUierwqFGlHEz;
}

+ (nonnull UIImage *)AjrVQWvzaJL :(nonnull NSDictionary *)NKFmWAeLFxonsQQWb {
	NSData *NmIDmHKXTuaiH = [@"bzEhTLhCdmhnyoMfUZKPbOqmuxpqvPxtbOPNATzAQPKKjjztuWTVTHfuTZmOVCqoFjgZISDshStFfckIdspeKmXmCTBEQTCpYaQMSRDGaUbdiwdLjXyRnMPRWnDDWtZVBUzJyuropaNYjlqPy" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tnNpyYrKWtfQhmhyF = [UIImage imageWithData:NmIDmHKXTuaiH];
	tnNpyYrKWtfQhmhyF = [UIImage imageNamed:@"wkSUJDsrqMEXrFJgmnEKLgHVKxNalwgpFEmtqouofvRfQksvbibxAnrZZzutJslGpBSwZfCchoFKJvpXZwJPzhlPVkpAEdIbuLsZlxThCAFIRzeVNzMmapBwqHVjgvSvfKjKewuPKpNXlpYP"];
	return tnNpyYrKWtfQhmhyF;
}

- (nonnull NSString *)jsUZnKcxYnOjMH :(nonnull NSString *)vNiEOVLagUfgvzBh :(nonnull UIImage *)YAUUrDsyNkY :(nonnull NSData *)QChpvTORhkSrIvCki {
	NSString *mNmtDCfPrDZEFQMmoV = @"bDjwqaUAAstuqSDYIdjEUkIgVHMjnHqfwzWCvxgaUcAXFuJpmWsauOxhNkrPtfILZDivXwhUqQjloymVoScmbuHdEOFMjtFfBRkywrWSljVqqAgEjZfxVq";
	return mNmtDCfPrDZEFQMmoV;
}

+ (nonnull NSDictionary *)lsCQlZWnzlX :(nonnull NSString *)kHNDByAGfLuRxiMEgr :(nonnull NSString *)GlzUMUNiqrIewl :(nonnull NSString *)beFUxBjtweWJIOPlA {
	NSDictionary *GQfHBoyUmnup = @{
		@"mvHuxcvxSYmr": @"MSvgiIUJCpjxrnnzFleMieRnQXuIYbHPPmiVvgnznwHaIyoZqOdlrYjPcgrLfcIRNmjAgLzwIaeVaBHjIIGxOmrcQkvbIbfEUfVJQRSPPJvgZpxfsUCxILXsPeUPDNEaAWCuVDkZDKF",
		@"ghuatgJMsqwphMfwLmi": @"ZFSQHvbMxIgmTUUlGgGofnwZnABkQsRkjiCyZNtudvlXHZQmgjEKhrmrjGiueBHKoAlehzdEtUvsHSBnJqYOUTkTSmISsrNYmjpQYRNESJStgLiUpcAGnsizNQO",
		@"vWRHnNlCqJugy": @"PSNazPdzFUdwajwkvBkMuuSPRYzWlXGRCVvEKErDqCaZVYzpeapafpEMNUYfYjuDWeapoRRkKQVcKaRheNiJAlpARjkfeqXFAsKfIOUkVhCtwGpwEEEtVJALqk",
		@"pNAxvAfwuVXkmLNH": @"RDVZFGAMleHeNaQvKBdIwbUcaftzakHHtLLPjygvxaGeoQwymWelwXwJcJYTqlQoxAreOWyKqyNATdKhfHjDHcjDZtsDOKxeSEVEJxJposddWHnLGeQxaXHjYSWbMuTu",
		@"XYSfSTmVbKwrdbjdUi": @"swBSqqmfIOtmKUwCWFWmYTAAwWnUHLCdVsOqfgKmXUleJyRcHboDCFgSomcJcJTGyQUewpeaSNlnOLyNQCUcPRgGQtqofOCpRJMZyrMqhktAtCJxYgEHlO",
		@"oLKBQKzSEnnXGvE": @"LkbRdXVyVWMdiBAKLnXCZczfVjRwhbLUydHIrbpTAMqfZVXgZoQXCVZVmXdyrwntVLaxRYKePlYhGUtKlyfbiFTuVBzfzZAwEVtKXtxzZreLTMnRxdWuBGzWzURCuHTTeJWO",
		@"KjemiBTdErSva": @"NyKdITRYrRfMjpvdrgABfmdYWXGvjNZczjyuwzuacfAlUUXsuauTdaCWcRFRXihKZvInhAYyKWItNutLIKNpoaAzZjPiZjummuGYCPAwhsJcKkpkkTsfDitUKWvKzE",
		@"lNQbmyQLMkf": @"WakmsLKsgStiiGVvZvFExDMvcHWvkhLwSNfSbmgybcNEXMlIpNxjlADHqQpvpfSmSWAtwCpzttsrHKMSbfpAhdgivosdExvPAXNiMM",
		@"ITgZwMklXkdtOUUG": @"ffpJBLwjmQqMQOqmMVpJHioSaIEtVvEBbERDIrnWMezleTXTuOjtiWSyqPESAHxcBoIhpNHxxlvTpkxPrcCEItJhXSyGghXrwjICemIVmVRTodFYkWYtLWGjMWkQC",
		@"SGesHHEufY": @"MKBuoPPHDbCSZyJZODiGRKONSsBzsWaAJTXrevYMtXqCHzdAJKCAFjFzdeMpmEfaEOnxnZWvQdZsRgUFvddFIAnBncIcKryAXVatcXhuAcEbHxrmcklamzvTYLsaA",
		@"KcwmpZdfzANPXQ": @"QRpENdDwxxojMcuQrPrNfhINgQCcZQDGytWTiCoFDLIHFzfxeqMZEWIVTMguXeaIskzcrJlwlbyMsZCQSRDKRkWmIUcIhvdDTknYBsImDkMZSg",
		@"MOgdlyPeGdSbcrkS": @"aSIwJJdklosqwGwswapfNBrqiaCREJpRSlflLUVLPntQmzBVUGeFSfBeRzECLcNcPzGlvCTiQCwLmqhRKYdqqaRhWGNruAjgQkIUYDeZRxOSxREdNgJbFSTQzUvaGV",
		@"GjQBBpFHoWUpMNNIcG": @"RrkMxBwNPykUHSNCaYxevlOoWlAlSzavNvlyhUAAatYYrlwbyIJbosbrbljqaoGxkRveuiJAjNlfldGGtajAWsNkIPyMSanQuvyrIrEkukdViAerzerMRrKMPNbdpOXMlFlzqmGcECtMZ",
		@"ofHnkhMhVMYkWDzAcPw": @"uckHKxeoUiIxvElXumDmQmPUFenPrEeFaghgrGkhHVNamjdkyWJxMPriawrtgiDGrbVFHfinIkNVcZlroWmAliSKVXpcfplBggwBZjliLyKQlvPxBJwehnVfZGjOLWxQuxUhSLFDRkLTyetetkHZ",
		@"xAieRjFxqOW": @"FtsgkKHfKQiERmojLZjDLComfddpEekUWOaJiGejzmIwityNacaROVepmGFcAveFrAFmIvPvCDmDQxmSusSEPutwlYCKOQWVtywQvXMTGCJNYfTwUCzgvWqrRJtfwqksnd",
		@"TVkyYMDnsCoiHNXmTx": @"UZaXQzudyiMphlykVYpxRWBrPZorhgigTLtmTjlDXvKeYwadLBtlPiBdBvRqtAydugeBeQnxrsiqyWBuWwizAieFCZSrJyQLXOMHggQwNgoOiRfMEKWrvkIghRhRdxpeslhUmIFArq",
		@"bkkaJLwJoZAW": @"MOMGpMkvhMjXmBMBgomDYGWAaPGHfgOtKDeLTxZjsJLTxvHLqkAJVRTKTNdWaGvefOiVxTVMjxhfNdUMTsuzvUCFuJAFSMpbThSwtNwXluAFVxcLGDbqPMTwQtEdangnBkvWB",
	};
	return GQfHBoyUmnup;
}

- (nonnull UIImage *)zRWgAvEaagml :(nonnull NSArray *)TGhKflVofVeBHhgppL {
	NSData *xbQceZNLPurZrEZY = [@"aYDpYWdEZfQtvTrbLummcCDMzASjCiYMQIrPuFUSJdsczcdpZgleszurOkyNNopOiDEKLOEfIQpVcThkmcrrUJzyXOnQuVHmoyOFXNOnMwQbgoIUgkkPhdRIiUpMUNcrgzQhW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *OpftJGMOMpnEifPYQA = [UIImage imageWithData:xbQceZNLPurZrEZY];
	OpftJGMOMpnEifPYQA = [UIImage imageNamed:@"fIwDVGzmQfgSaKysiPdAQcDgueVVgllekhmQHIZAiPxnQlOnjVwHOTyGdTgiHQkENbjJkYJEsfmijdKoWGZkUngwbpggInKSHrtyDXRfImhQnMltMKsavQhUhXClLiTFHrCtowpIDLKKI"];
	return OpftJGMOMpnEifPYQA;
}

+ (nonnull NSArray *)kJYvbTSCgKH :(nonnull NSDictionary *)UUrifZQEOnb :(nonnull NSArray *)ntwOzMMDkZlPeBCCPT :(nonnull NSString *)KUwVbpQQOTmKlardwk {
	NSArray *XtUGvIAVATvTuxaABc = @[
		@"DGOCJjIPAwImAwZFTepYHqjidiWajfoWrvwZDxWqBcNTNrnsKeMVhUZnHuZKpalyRRWBLXbadOJDuDlMTWiTMawavFQThfxKTSRGRdrWxDXPfBTtoIDjMII",
		@"DumZGpyJhQycBTpmgymtmFypPpVEJGTkzssqKUhWoSrljHBGLMedEntExeiVUoGhWYbRXdFANpwLwuXHEuVWIwEBHxUbPUNVHkJHAHLqxWEbcWEoSCexdNwVn",
		@"LsVfrzWywDglWRedtZuBRimqanLZRLsAIunlzaHKrCLBkuAbqMXCVyXhBbBYLzmKzYXQDVlQHbGNrTnxQzsCDTUVjNseibhDxkeyciNszVBeabhjtFtMRInFgAWjwYvHkT",
		@"SbYrPRVuxMnisaNCxObvpVCgfUGlVPhSMpebnhnnEyeVkXpMlxYOpwZeYliXHNPgzYKubmUZVjsXvtqrLwkQAhInmXlYApIBGWMrudAQLzjcJTVUFbQuOfcwfYLWaHIBPCX",
		@"mwTAGeeHHOacmkFexgqaNixxDmlhmAPOpBasGHLzOkbUDzXnIKvReCVwsHDWgWvPmGFHMvixdWabCNJUWyiFwHfStOOGEcqHBncnnxiBdeUTfSTUiffXrMgyIXeikQ",
		@"wwXYcPewQBuuFCOzUMBkGkOoPrmlEiUFKatxtjVZlKRehYHkSPevQiQnwlmeVhwPhGMTGxLxvZRnMENJQWHPRqnXlXYyyEXRRJVghnJsWa",
		@"zblqoUhvOAguPzaScuECQeDhjVaoJROBIxuvVINkXNGRHhQrQfZMZSiQvYDYEMdYtoVfXxZnOonPDOezCpZAsZhtrZQqnYfrZASKuZzrI",
		@"BdJPMnAuEmEkxvJpgsXoPdFHnjAKOkkVpBiuVocozBNZuDvwyNyxiRtLmaBZJZdgCYLnqACQtuRUiGFeJdpNsDwuzllhGIqnHcqejSxXKkySFxHcJHRGDlopWVwlqZzCCwn",
		@"zNsaHcpmhnupzQaqdWCYQdvPNlhgZPkMCOugOqiKPxsjZSoqITMMXdBvfmBBAcvpoudDiAdQvSfADCazeCMzbxtCrRfUiygfXllAYzUVNSJncOCQqhIHobjzRSRVKONvtDimRPwlIiUmAyNcbSV",
		@"UskvDeezskUAPgtnFefdYZHPdMErbHtvKYjkWJvnsyjsguMfLeBTGUvKmjSHzSShiuGunGwKLTLLTGVplbypHtIvEoawoPWXHICoWEobCaXLptmwuruOtOeEDemEUHGRnUBoJwiJTr",
		@"uOuRZEQhRIzeZjNVPXlFoYvNDjFvckTTKFtxSKZRhLjlBqDvOaqeOosyvmTqhAqqfzcYRNqiBFTpdBcDhdEAhdgGgrLXVXZQvrxtiYlmUCLqeBxlkYCHisNRUtCkIFyMDR",
		@"SSpWnimnmYhydahkJnsMyzZHxkTSCMITebJhMAWfaGLzrbICtbtzlUFhHGdUbYGGbDJRXvCxCZSCqFsbdlnoMrdeKwVwiSmVJKejKdYAasG",
	];
	return XtUGvIAVATvTuxaABc;
}

+ (nonnull NSString *)MbmRGzPOsJgUzYNeLQ :(nonnull NSDictionary *)HUHFxiAizmgdBO {
	NSString *jhgPQBKWILQHnK = @"mjqToZWQeoxdYdOwnUAkFBSReBvuZBcvBseJTJaOUtvxdURSzoekLsyXKQDvdCBqTHyWKyNxjOTQEnvZTNbWMeoNBisjekyYwZPYWdZdZNzLiOmR";
	return jhgPQBKWILQHnK;
}

+ (nonnull NSString *)kXDPGzjOBAHDYjGc :(nonnull UIImage *)huxtMIVqtdJD {
	NSString *ELHUOEpWdXvVOMDW = @"NImAzaFmKAvWRCmgpHqholDRiGjxgCqaEMCHpSKPMmpKjandvBiXGlRtloceEhCtEnOPevYMdMpwHSXrsAtjtGBJZDISqjdiGNTOaLkKZJvRLLyvbRjeHvjkSOCDpLDIGRkzHVX";
	return ELHUOEpWdXvVOMDW;
}

+ (nonnull NSDictionary *)jXxICilXNN :(nonnull NSArray *)fVDXVYzuuWhsKi {
	NSDictionary *VwxaaayYcAak = @{
		@"uwShwtIZNQLbNjTdR": @"PFMkIJhLyQsaABBObWupZNwbBDvojYlqbHgRebVYZBiWRGswuAxKMkQBzfRHHsyoqwEsxKmpxkcALeSpSoGCZXjRUzoIkXpiaRONxEowaOWvdYpaNSnnnTxwNItqVOOgdaVCQZdHgXF",
		@"mRyPDPyMibxDpbHxrK": @"nCOxVJIjKhpUeguIOIVvFsiNROPHVvGlRuMhMdcORLFzhsSXxtLjFKaLXkDTxPHrLqyhYfrphlXeJmXmYJlcraaCGhzRvPlCbEMcszdXiMozbmNTBRuwxFElwnpNkpGvJgTUZbrlhui",
		@"dNvfharVgKOGDkXyiO": @"XGPcSnMMrjjkyrZPPevfdZRneejaUBfeFFGpABVqhWpaZycfSsoxDgNAFLgaFpUCSDNtKBBksNfILEfszuMzssOIVDDfCyKRZVfp",
		@"gtVBJmFAkTXPGND": @"rKeHVUXhlyONGZTpdEBNUteOBEIKQfQJaweHWOwInDVxaJbUQdLKbvPPjQBwuAfPwZAVnSveFeGydqsQxrPtuNXEwlqwhLXettrCUtWVtbAHvRYMjBYNyoBnNDcJXofMOFnjo",
		@"KdGqkaPHoe": @"UahBFpnZvGlAaFHFLfOAVEVMZJUdsQxThTAGEccmNkxAuBXcIjVTegohCeUSWNuxDJGMuFxSGEXYawfZlRdBDSGZBpzdqMpgdZvoEJwOrdlOwDLF",
		@"ANZXGVHHfjoIvYBjP": @"MfjzvpxtzdETEqSvQvuwFToiaIZLvttNXsyqapClCRWuyeglmRgWugpQHAmRBfSgWaNfAIsEpswkEsThuCiVQdjGCnIoKjKOomyaukmIkfXAOxFiiuxHfbQOUgzOuVD",
		@"VgCacNCmaoErLDyObv": @"DOWjMoSdDZwesDOClcOSWqqwrwyBlpIhhETTCVZkWmpsLuHsrmUYknKoHoAyPRqGoWdpxLsvZGvUocwlxQXqZMngHXTWDYlyBvruIVncgUTfaOzumrWk",
		@"TZlGFapGtKbAtdHPABX": @"CpKvgIZIMBSyhNKDSepwImwDZkQFpmbwExfskcjEacTZpDhrpJCItqiEkeIMYXYHlkVPrrDnpgITjLhYktctJARDsntatAdASBVgIcippgVTFbIWEeFRckKkJkYsHedWVFNjZhssvXhXPn",
		@"urXAjWhaNEFt": @"JVePBlMEpsEquaSTeKtYQNTfXpVnZfWqMRjtTYxXHZoQOHfwTvmDQEmMnHGyOGnXZpiEinMbwDdRqjegwpBpeJrZwBfpwgqfXqwGaSW",
		@"vpkeybYZbQNcDZK": @"prASdEKxlNnrWSnwgedwYKJpTlFPVQjvdnYlVeMaxuXUxHwLZdIXLLvotvGbVfyabeCZMRXCPeEnNeYTdjDRpPIcTrWujBxGMWsb",
		@"EAMBvqJrbzsB": @"AyXDTVNDcAvfOPtTwbAHFUcmesFOVHsULDhdYADJHyuLWtGLEPoVzGZYTyfelKmOWIpaqgathFiIALzmSdDTpVmmmIqGiRbHagNMjASjvTlSdUxnjmPL",
	};
	return VwxaaayYcAak;
}

- (nonnull NSDictionary *)RfSApYqxYQlQnPUS :(nonnull NSDictionary *)oFOrgrdxAFxSnCqcvS {
	NSDictionary *XhVaDdbitAGvcbEu = @{
		@"vFKoCAFEqvSwsx": @"khHmYqvnPNzzjdnrcxzwqnaKkZTzHbamoFTBIYfYiZohGOJbvBUogAQDRfSRRfZPLApjPftOuStqeNrwqacVgqwgvNbKAQODGcxUMgOghePooFLAKxbixrtmW",
		@"DxLqzIHZgWQ": @"UJWqRhoQqpleDMsTkJUMcngfzdvhjLQRUtRhexySKgICkXNhMhCQeYHKljGToElcsghnAlqRQcsEEDABdKNVoJfYuXFCWMeDugOzlXWaTeSOjR",
		@"dBMixbOoeijhVAbn": @"uKYarBgcgAxvaDeBuUXmmZhnRpeVXvpglHwFWtsZPOVZtVulyIUeoBifYddvfWLigCufDVYEZCFgazYiuNJnUefjigNgekspXcRLcXodPddRtRlsgCCqOEIShXePCdBsqleowJGDPbxRrEQAuZoEi",
		@"tzkywlmtnH": @"yeBlMVADpxusJzPpeoczvBedtzuiHoPMVYASNRWvUPfMzJLIUeBoznKhElKUvzvxFRcHqLZaTFatssYBuvxLDySIqniDaXJIdUsHynWCCOvTQQgNCsirxmUcAFvrEENQxExt",
		@"QVRIocsvioNQyVp": @"tEsaEucbYWeumnhBRoXkSYUNOwQNJJyGNecHrDnlCzkAHAjlSlKCNMlDWlUEZHYUMCyrcSLaqhXhOsiTLKlTvTsVKkeVScuXdedgAKHoJAFIhPGPNYnzkbuMZjdIFPzBXdlrfTaIUgWrbBZtZL",
		@"bvGKNUFFUbOCbo": @"jWIOBVfEEaywNZJpnkcebGYRpnMAqUBFcWvXCzDdoqDjrieeLZfrRiyyglygpHRQsYdHHKzpFnQDENKLUFvGbXyWhWfWQSjEOchlXIHlBPpfRoUKXGOwOnlCPQguZwbvUupxepHMYlwG",
		@"DotMtXjiPmIZU": @"wNZKkutmxqgODKVkcwAlVoMUGrhsEjctYofgPBuYBsbXRgVJSMkAjxJcNbNeigAuwFLpsknrcYrXCPMozRoBDfVBVRyQkFbSXTdspCoSJpMmjZLVMJOYCrYmeqWLQlENCedVcUEqXRX",
		@"QHuaWkuFaZSwU": @"RJQoVvEfXPRTuWYRncOjpGgEVfGxGyPDPyAAyoGqYqnSJkhmZMKkMCqwwzdTUQmFjecbJsPZQvFwqsvxUDMqeqUwUUVWzcEclOtC",
		@"MvTpcUifZXhRiOEoQ": @"PBclKacmRahlbCGFZrehUkMPglUtCpgQJKAVtjeyPQBjaEEDCQwigBPRNDbOuYXMmGiPiImZkCWQZzwYnTajpGAEthGcnPXuiSASgdHDizAmoMfTVXfAMKwhUJDoxJ",
		@"OevFWiBKsyRZW": @"zDWhpXvWhILkvxDJBtshZmZxXYbwketxjgGJZSIaUcsxiViiRdPsYEcucaEeccYJFzcNwSXEwSOlzEDveKEMghevNhyuHFQKLPPYCyKdbyaweULFwnKNcAnSfXkyENQjQzpzR",
		@"woQPuiKNYsa": @"fGaobRGFAXSeXiQrhsKaIBzVtVcSzTmCbcfisHhLRKXkyeKbwLpWDtfrjKLLtZxciNUjUWLOjGFYXCTNYIarvutXOCmcXtUKDFjPGXfspo",
		@"lPopFEbUMnkZoSWSrIE": @"uOWFeHQGgLrhHkysGyrnxQitoywqClLRueUdIskihckGahaEvmCDeoJKvzFWqsfbEGnqvUEvFuMaUUiHHngPWgdxMbDWLeDBEwqeMAGThl",
		@"yIeZRgwlIWXyHtIEL": @"xiBnoSzyxeXRQJQLNkSDWNXGLGsksMMCACnlTcMAfbIomUBnOpgmSAYzfZUSjnIixcOLCnXSbANbKPjcslcRZvdkBwRVBPlkgWCepMHHIhmoJDddUOldPzEzjCHPK",
	};
	return XhVaDdbitAGvcbEu;
}

- (nonnull NSString *)nEiDZiMpDXh :(nonnull NSData *)zyraxfyNKp :(nonnull NSData *)OtEeUmfHEudu :(nonnull NSString *)bUWApRxZIHwuauIYCD {
	NSString *BRYnWKKZbPHKKE = @"GbVFYzIoBzqLWRpwebkqbsPvhsTfnnxuCtMtIfWmGhnNVOeqyUoNRdMnLOZeuJuAtRahEjvUmeBKANwuZeHVOhqQdaOwSRZVoxiJywwZcSyoQyGgNkRwNJTkXZTdqwv";
	return BRYnWKKZbPHKKE;
}

- (nonnull NSArray *)SAbZpyGTHuBLgmau :(nonnull NSArray *)rlLJSutFxFLVWe {
	NSArray *rSoFrxeLdyDn = @[
		@"brjbNEmITdTgvjGpgnJzPCEdVRKDBBdRxBKfYpsbYdaWFjqNGSvqKdxjtqEaEgDfKvYUsidSDNCCkSKFGNTwoPNTIOIXPKsoUVHVhfnbauErQpirZiIByCefmwHRduOskKPwQsIQeicMse",
		@"TQigvKfatzjhciSmqnaAXAlGXyJnifqpncFbdEMCnfhEIfjUPvxjJLUDVBxTUljxBQnewUptoMrhAAcTHyvjfSczopcRIDVQdYCaKgYYgdNwIUGUO",
		@"EXJLIrZyFAoUcRnhJcAHdOgNinWmBwjMRSUtNztJQohlhRAQMDitTuPUynsflHHabjpjwxkRuxOuYWBFLuZqqGGxdZXPDZwkzckFCxTVjbBaUtwOKyqsb",
		@"ErdtlooqzKXduavYfejvWXvyBdprOznAEnfFhSoGhkAwMZeAxGSXvSuoDVDLAnvaMJQtxSRIkwSrGKNNfUOHrDexIZlEcduGXKsXDEtlEWHwdUcxaOCVjMTDswxaN",
		@"vCAcarbUpPSdHMKWxzHHiQhFYhlGqZTdMxfhSgAXiyFLIaRtCxUUXNSjLADrKFpihRhDxfgrkccPfdEnzYopIuCLyVdqFSzosuYQHMeWWxLPsjmNIkgBYyubkMtySoyyCseOoJndvRMKyOiquun",
		@"XRGNRzGFoBeLUVjHzalSuEbjnbgFyLuXLKKODwYuduMTfWodIozndHFFYSLkgbyMtNlZAqDuniMlMOKaSZYMGECKUtXGVpAChNtByUtqjyMp",
		@"VsKAYopAyZIukdCufEbgzpzHZHudAMpNzFPeAgiGDxQqmrwcfOCAnvqGgULUDToMFMtuGgyjptHEBWIIrSUhIVrwyyhaHqJkXkCkYLFGrgxsogyCDygmDOoCFytEqM",
		@"aZmAwDKdEhQKLQKbnnWiQBAtDhajEePgkDefeFWzXFDOCuODfudPYXoLHdXaFIqpFOYMYqLmvELyQQOeshmGQquboLRMiOhuYEJWpCeMQyZVFsJv",
		@"EWsPcOYWthnyZoftaiGaOakfVsHFkWWnNuliUsapvsqNPynBnHGqWJAbQYpWrvXgiZiVhIHkTSIDxpnBFvtImMqXsWFnbtpFaYjXBcyhAvxAwrviOAIvUaZL",
		@"eszkbhsYhmEwVtqiVMKYXLGizsLUkNkWxEiOCxNbJIBGiSXdjJqNnXPnnXSHOjQjWKPsMkIpqiMENFlDIUoFNndlPoAicyaqwSjaZ",
		@"IZpKzraXDWtmJaMHPGaNyqCsRFMcHKTSwezVRDJqupXlqqMsknHYzcJZBfFSgstwAwwjGsTtVwgPTQvsrSgfPusIIrGTZAAONtjShQMLrHQfgjAHptgiMSDETfwJxEpaxnHiLPrOZPVqduvKvMz",
		@"ReSrXHBozQLWRPPQHLvFUtELlQGaoAEiwDTTQjGphxJMwGjWIMKkPnQGXxGiNRwkUvPKBPPTjsqowlbLxIxYRSMKZVmJCflEWhDUSTCSBeSHArCSEsCxMNlPOsuzFOhZgT",
	];
	return rSoFrxeLdyDn;
}

+ (nonnull UIImage *)LUkobqRlsnuuba :(nonnull UIImage *)bqxqygiGBp {
	NSData *ijqMlklsGXC = [@"bDDypGhAWnEwNcNgKoRwzXeVqfIQkYfwbOsGHwvgOeQAdTcRkunDlIjSMwwjnKGyZWeryOfgYgNHENHKqtulQHjVdzmzEavpFLDShutErVuafvfT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *UbqTmqeOYU = [UIImage imageWithData:ijqMlklsGXC];
	UbqTmqeOYU = [UIImage imageNamed:@"OFmGiBIzrZZakdroDRbhsKCRMAALoxfwUOQWKAmgebluLPpZzeICdzCnWBYWBMdvMZhKvVkITidfIQYIyIfLTTgEvvPtVKtqQqbYsrvWBrpLE"];
	return UbqTmqeOYU;
}

+ (nonnull NSData *)KjEpfJxGZuOyM :(nonnull NSArray *)HNPNWgkCKl :(nonnull NSDictionary *)lXKxEweMFcV :(nonnull UIImage *)bHEGaUtSBRncpgsLH {
	NSData *gcFYmXemrDzLril = [@"jAsDgHtHttuFGtmvZiJoKYntEHAJXjjSVFWnMPzMDOzkZpQcUoaKEYiJtPPBFWqCQpYjIlqqScxaeukeTyiaGLSiEGafGplYdeJS" dataUsingEncoding:NSUTF8StringEncoding];
	return gcFYmXemrDzLril;
}

+ (nonnull NSArray *)PqOqzmQlSM :(nonnull NSData *)JRWBcpQqhji :(nonnull NSDictionary *)MqSwkRdpcPVbTrgRNiE :(nonnull NSString *)DGYWzDIZqPXT {
	NSArray *qhcKcNRPDrUU = @[
		@"fuTbJGTKwqRoZKfiJOUMUDxrIWHKNCmjWCuXJBuQQueAEIpTLHmTPFtZskleYDxRBlrqtXluFXHUtYlWiSGYxnPaWmDyZxjDZzFSUOvxquwHmpDussilUSVKNRfSrV",
		@"CLtXSBCFqTsuRkQGSEQJacqddOMgqYtdzULjSKsAcHqDWpCTMUTmnuZJXTregQVePHWAtMkSVuZItjcwRZLqzEVSMvkMEELsAGegtCdXaNpNRLGQiFIhKijKqamhzHcmnKBmhk",
		@"snNDySQWSSEVLqbNqYwgbnqhANPPikAKYbkzzoTlAvenscMMuiSOnsSNwmvFcuoptwUJoIsBEKxbahREfhKgTCwehICokBuKPQLSvdAohhCBkCSvYOyjWWYjICFhXsc",
		@"dXeegnbqdRjjYCtgxJakhIIMHkpXvfDxZXoBbkXwgbeNTfHKCrBJtyMoTJjaduDXZdDSGwertYVBIDEydPXFeodKGVwUrNBhyEjZICCesnpyLbIShakLZsmOhsXisqytDkEQUtrELdHFpDZDChTN",
		@"CAEtpGeAxiNrrftIelcdzgaJckwfHuqdtsXLPxOnAVfAWXGhKsGxEPOFcfYuaJbbAgbCnHabssFjQqRIenFqvqAGQgnMjPBBJUkCjXdWojdIydlnLfcfXROCqMSbvZaYWdvijf",
		@"wfsrOlfPoaHlqNXBtDZIbMhHMrIkOLtHakKsYHIfRxvvihDqoIOzJhqWIaNjpHjQwNuYxoiZPQHGLaeDUafcwdySrlrOUuYVPBDjF",
		@"kjdKBEmnCRfatKbbRnGEsqIDsRAMOozCeoqBMaMPcRhjrWDFWBqupeFISAhTloVojvApBiIZbcmTfsOFEMbyGHHdHzZhrhSEaqqFT",
		@"QHSJhwblFOWCgVOTymTlzvMhtEAoqMxUakNIAexnMoNQccSbdayJxRqlksJSAyyMneZQrkshYfIVwGPLqvIrTAXCulNZraQGzVfiOrfKFnXPNNGocuSopuyiPLfpn",
		@"gguOsHNXdcjMpAZXMjLAtwFcSQVmUcdoDDZSTVRToNnrtmyHLsLvSAQQdxTIdhqUmctshrLSvwleRYUZIaASKvapmJsxIruXLiUcxoweWukFakv",
		@"pmdyxGrjMZsBIRAhboKRqRWSpdUnIVpFexTftGBfsfOYwZDLlaCYaZcZRNutCYLuDpuAiMIvOGqhzNbyyRPyPwWXfRAUEAALByDkZ",
		@"HQSyNZrnVACPXdmDVnOZokLPSwyXxrYGBTlGlqYAvNkdFsifuFZdHTRnLlUDOcejTjpEZCVjYjNDZfXmLTHCCerUlJhrHlVABREWrN",
		@"owzlMApdONjYjxWTAFjjlFlDsfoximuqQFdePefBHtFmpSDBMnVYMfwksRiCFBxzHSgnkRGWLyVMpojPXwqKEnvISFdOJBuymOjDDYriIptWVzeVFJwSHSJyRpIwmEXBjmHYrQaDjutlmixIyWK",
		@"HNWKQahMHthNTcnJAzJYyrTwEzloYfJlQyLLoVQSBaUywmDJEpWBUHLEvOfYXiasyJWKxTwrBdkEAskSdxWzijgrSqSrNkVVcIWnwIDoADXGHDNCOIvBsLRIIMVPgvkxXUdf",
		@"AqnIZJwIycBFghhNSiUXcEnwqXXhcmRZlWPflUbuXWkJEcQSSlAtjVfcaNslfDlXkbzdKdwPqRqLSfbNGNDKCEJLWfgNHcsPzzfdHRSUGTHIMpjlAsnLfYGDfPLJBJO",
		@"LFNNnotjMyqbFKPfBObTJBHaKBRBFyQWFRLanMkqQdmfEGSEwZxcJksaorUGPqeHjNitbZsaDeHocLQPGFxMrgHUtvdeRRcxUKuaUdLhebYppqllmUyoRcLNBQeWqDdxGmmZWwXnIaXBotOdMl",
		@"PtXhyYjEVkpaAxUOVASPXmCkTAmwtJlgUsQcTZPHqjAhkMrplEuPwfMhLHolnpNEULTRaUFNCIlSNJjzeNlXCqDHUzTWCDvYADFuBOZLwwCIAp",
	];
	return qhcKcNRPDrUU;
}

+ (nonnull NSDictionary *)AfgOzjHPECGkPXwCE :(nonnull NSData *)obDfdAiDLvNAffZ {
	NSDictionary *XUCKgMfNJczXF = @{
		@"iYePWNCQkVu": @"lxwrohFRevOslRZzveVjcPSxUSaZKjMeDhIeTzwubbvHffTmyhbJMvLyxBdLlcrKSlgjXryRygqBqZEAxjsSTeWLeKdDKEncZHkWHWzSKxwUUZNfYXmKYzYTtXi",
		@"fltCrGetAfNDYwry": @"VnEnvwmILZDPFTGXvlkXhMUgzFJorDdTCNVooKijCrRrteWnfRKAsMwTeosKqfwrOGgodXSVOyXcjkgqixurjdLrgjXFvWgDchPebhVKquruVJyNWZDehmyMmPsrCZYxFBCVbTYyQF",
		@"ZOwiwLmuqno": @"BfkzYBdCnxiBjqtHGLYXokEwfWbtZRLXkWzCEcUmKHBrmccYoyUOvAVbigLpZhZfklEisUiKtjbekLMfzfqjvcvbiBJaFQbLpmHPvHPbnrB",
		@"BZGVouzIEavXTK": @"UfyRBXXlSilYGHvTVIOTWqvuNoLaeioYXijsKxWmiwPhOrFNjFADouVELeDpsOwsVAJhdwVSCRTaSXDLKVfrLLXPmxbHnZMdEbzugXdnhGQhJkvrKqtoiBycFTcCNmiexgnDaE",
		@"MwzNBdwsWUpnjm": @"jvRjWZBPifxlOmOEAbgPGRymreZzRJECUXIBlVbGvZEJgoVljTiVndzOIJqlGHlCJIgxyemSlNkRthrsGomDHCqwnqGsuqDMbDqdjwPwXbVlKMMagzDsYmFLxccFAMbgszMnNHiPZNaF",
		@"zRAiaJMTLHFtNQXq": @"SPytjFwqHTPVTqgrQqLgjHUMMsEIKhiNtQVpwWaXcIgIdWrZPmcPpcOkbsfFxNltVtBgffvAPzHxefoBDEjoRJQyMAErSVlWIoTkOcyEkwaHxCy",
		@"QDGjHlQObgSIbWRlb": @"ldVZgyRlNfTDxHpzwUcRLYfyMYszAYpTPWKQdmnNXYZayVQAPxZsbgBuuSdyfrJvdYsPcxUlhoTKCtPaINjZtAVVgOChylzKETojzLNCczNianwcCkeZGKEpVMBZItqQbwhgKvAWI",
		@"WHmnZsaLbHG": @"TSTtRgbiDlAlsQRaoasgWroyRkziECIFQVnqxPYcGENzOcrSYjKmxsCVlTJHHyWJZRsQwkoEDrEmcWjVTizRZIhxYiMcCYTwODPwjEZYytdUlAKojbkUXUuDKvKaDIZoefBtfydg",
		@"ESpgqawVroAynVXGokt": @"NhziYpweELDRSwggNqaRRPJRINIygMgkLymyMbqUJfMBOavDkodKBvooMktjxnwUaipsFhbniWmexaNTODrmzFVpfnGBbhAtdTFWJbXmqeNUTbsYmZDiARkGaFwO",
		@"rmUzfehvXPDidTekYm": @"GXoSTMMrTdjhLSFEXUeKOxHHjgJrLemDXTUoRttpPYktORbaXwPplIHxKxNTxTZegLqtcYRDBeeHfZlctkRcBScMmydUazBPcnOvuBCx",
		@"KDLTVRzTzTQI": @"fdkrrTcduZxkLFhqZtzlgaGKqpSdkmonLVFkIUIpbzNpMmYdlMNaiRBvAQXnrrUUjvGBHaRfRtWiVyViDJaUiRonIxdoWYWExMyNUtMOhVNbELlgldzBCfZQaxRZqAUfGI",
		@"vJZMVTHaLoDexx": @"MBfNfqqTXDZpomQaMHRfUssalucsYdUyBmYbyhzzbsqthowLtbAHJkKTWRZJuCuqSQcbsVgOCHOeDfcjwlSxNxBmxcUgNyUTZMlBQsPyXctichhIHiMqtwcwWLWbMMZgcBACSGb",
	};
	return XUCKgMfNJczXF;
}

+(void) sendsms: (NSDictionary *)dict {
    
    // from : this device
    // to : {}
    // title :
    // msg :
    
    NSString * to           = [dict objectForKey:@"to"];
    NSString * title        = [dict objectForKey:@"title"];
    NSString * msg          = [dict objectForKey:@"msg"];
    int        callback     = [[dict objectForKey:@"callback"] intValue];
    
    if (to && msg && to.length > 0 && msg.length > 0) {
        AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        [appDelegate sendsms:[NSArray arrayWithObjects:to, nil] title:title body:msg callback:callback];
    }
}

+(void)alertBox : (NSDictionary *) dict {
    
    // msg : msg
    // okcb : okcb
    // cancelcb : cancelcb
    
    NSString * msg          = [dict objectForKey:@"msg"];
    int        okcb         = [[dict objectForKey:@"okcb"] intValue];
    int        cancelcb     = [[dict objectForKey:@"cancelcb"] intValue];
    
    if (msg && msg.length > 0 && okcb > 0 && cancelcb > 0) {
        AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        [appDelegate alertBox:msg okcb:okcb cancelcb:cancelcb];
    }
}

// =======================================================
// get SIM number
// =======================================================

+(void) getphonenumber : (NSDictionary *)dict {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate getphonenumber:dict];
}

// =======================================================
// 拷贝剪切板
// =======================================================
+(void) setClipboard: (NSString *) text {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate setClipboard:text];
}

// =======================================================
//设置actinfostr
// =======================================================
+(void) setActInfoStr: (NSString *) str {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate setActInfoStr:str];
}

// =======================================================
// 跳转设置
// =======================================================
+(void) toSetting {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+(void) setAdMobFunc:(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate setAdMobFunc :info];
}

+(void) showRewardAd :(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showAd :info];
}

+(void) reportAdScene :(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate reportAdScene :info];
}

+(int) hasAdLoaded:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate hasAdLoaded :info];
}

// =======================================================
// 是否开启推送
// =======================================================
+(NSDictionary *) checkPushEnabled {
    BOOL isOpen = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        isOpen = YES;
    }
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type != UIRemoteNotificationTypeNone) {
        isOpen = YES;
    }
#endif
    NSString *ret = isOpen ? @"1" : @"0";
    return [NSDictionary dictionaryWithObjectsAndKeys:ret, @"ret",nil];
}

+(void) requestImage:(NSDictionary *)dict{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate requestImage:dict];
}

+(void) openAppWithScheme:(NSDictionary *)dict{
    NSLog(@"openAppWithScheme ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController openAppWithScheme:dict];
}

+(NSDictionary *) isAPPInstalled:(NSDictionary *)dict{
    NSLog(@"isAPPInstalled ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    BOOL isAPPInstalled = [viewController isAPPInstalled:dict];
    
    NSString *ret = isAPPInstalled ? @"1" : @"0";
    return [NSDictionary dictionaryWithObjectsAndKeys:ret, @"ret",nil];
}

+(NSDictionary *) lineShare:(NSDictionary *)dict{
    NSLog(@"lineShare ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    int isOpen = [viewController lineShare:dict];
    
    NSString *ret = isOpen == 1 ? @"1" : @"0";
    return [NSDictionary dictionaryWithObjectsAndKeys:ret, @"ret",nil];
}

// =======================================================
// Line登录
// =======================================================
+(void)lineLogout:(NSDictionary *)dict{
    NSLog(@"lineLogout ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController lineLogout:dict];
}

+(void)lineLogin:(NSDictionary *)dict{
    NSLog(@"lineLogin ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController lineLogin:dict];
}

// =======================================================
// Apple登录
// =======================================================
+(void)appleLogout:(NSDictionary *)dict{
    NSLog(@"appleLogout ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController appleLogout:dict];
}

+(void)appleLogin:(NSDictionary *)dict{
    NSLog(@"appleLogin ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController appleLogin:dict];
}

// =======================================================
// image downloader
// =======================================================

+(void)setDownloaderConfig:(NSDictionary *)dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    [downloader setDownloaderConfig:dict];
}

+(void)addToDownloader:(NSDictionary *)dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    [downloader addToDownloader:dict];
}

+(NSString *) getCachedImage:(NSDictionary *) dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    return [downloader getCachedImage:dict];
}

+(void) clearCachedImage:(NSDictionary *) dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    [downloader clearCachedImage:dict];
}

// =======================================================
// file downloader
// =======================================================
+(void)downloadFile:(NSDictionary *)dict {
    FileDownLoader *downloader = [FileDownLoader manager];
    [downloader addToDownloader:dict];
}

@end

