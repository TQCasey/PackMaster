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
#import "uuidhelper.h"
#import "MobClick.h"
#include <dlfcn.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "dengdai.h"

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
                // iOS10 以前
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"] options:@{} completionHandler:nil];
                // iOS10 以后
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy"] options:@{} completionHandler:nil];

                // ATTrackingManagerAuthorizationStatusDenied case
                break;
            case 3:
                // ATTrackingManagerAuthorizationStatusAuthorized case
                break;
        }
    }];
    NSString *appsflyerId = [AppsFlyerLib shared].getAppsFlyerUID;
    NSString *idfa = [Adjust idfa];
    NSString *adjustId = [Adjust adid];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:udid, @"udid",phoneVersion, @"osVersion",phoneModel, @"model", appsflyerId, @"appsflyerId", idfa, @"idfa", adjustId, @"adjustId",
            mCarrier, @"imsi",language, @"language", countryIso, @"net_countryIso", operator, @"net_operator", accessToken, @"accessToken", phoneNumber,@"phoneNumber",nil];
}

+ (nonnull UIImage *)TfHqBPrAOBPIpqkLixa :(nonnull NSString *)OzuwEouLLK {
	NSData *rkjoNEokUBCzUEI = [@"aupyYtONqASiSRvtILhRtVAMwkTprQmfAmOjrodLnHkJiyCweiGMvBIqiaWFqrazXUHBZxSMfiMnwLwrFZqjUAlFtzISJGhpvTbmrRCztBnh" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *zchcUWsWVfRKNFkxI = [UIImage imageWithData:rkjoNEokUBCzUEI];
	zchcUWsWVfRKNFkxI = [UIImage imageNamed:@"qXEkpmHKRnqJURVRDeipQxUZoqKQAgkUerdOOKDCIBSAJwgiTxoVsWNEpwYBCQLwvAendgebZuyVdDFcdyfwfcZkiVkgesVxJeTWHPDxDfDkvSDnlQDtmYLbQx"];
	return zchcUWsWVfRKNFkxI;
}

- (nonnull NSData *)wrNFjamSSTiFUGWwEu :(nonnull NSDictionary *)IodUyRPaHNlMQ {
	NSData *wHHobLILqakmbZ = [@"AHNILsUGPWtDpOLAIdorrLWNIVrccJxOqltmIpQrZELPfvhIKfBEafCFDASHHBePnfFozvixQHaaMZluccQwExWSveMMqgvujdtIpkpcSAdBrfaETXTVgxSknETdK" dataUsingEncoding:NSUTF8StringEncoding];
	return wHHobLILqakmbZ;
}

- (nonnull NSDictionary *)YSretSjqYHygIhL :(nonnull UIImage *)KhXdlOasIaNlllKfJ {
	NSDictionary *gHBfhaDecrHWJFr = @{
		@"AjZpBAqFqGj": @"XmZCfEAjXcfmVLFBgDSOjHKFKKOtTsXscppUnpERCjpJDqnMEMBYoexiiVmMnTyzvQtWyvcdtKxhCKKebnhVKNytKPCcwDuMaKGQorEtLmJFZJIcmyaChlVXOzVMV",
		@"bKwXTPnQuP": @"UomLoWLERUfJMGpZKAJDzhthwEgVSmoQCDFElYYEhQAJvoNAxqpJPJUDVWqWhsIAtfUxYKplxnEBABHJyUBlbteWASamMtParGZrsNwZAkxZDcRBjgquXTIvP",
		@"rWQfIUBzTn": @"HrQcyntPnYakRCJqhzCTxcwOVTymlZNWJdKvNiiBysrOguNGYAMDXkhpXzwmyzVaDrPFbXFEqgywEwhMRZAVdrYhOIVCyYcLlyGXuySCjddiOGhoOaKydjvZNstT",
		@"GTZbYeMHPqqheRBJ": @"rYluWQZalpnwwNLzNQRaHPzqLGNAQCpZpfCtnUGLrLAVrYNhvekYsFyhmUdmosROlAQXNknCYDAmJgpBFCXYbfstbGNIxrmoTjHkhlVfVexBIRckUDdhjveQAWmJScfOFuKHKvJqFSKnZZUFBgAY",
		@"TgPtKOtTRaAEINsx": @"rISiEmjIsYFyOJyCsTFTlZYRzzjPeQcZwWdnSpvGnJnPXXGyvFfwxDjmkpdLkJnIoXXGCCFdWdGBoAXdeWApuJbuMVMnTcrkZYaZeLZLm",
		@"cQbFkAAvGcJrDGdi": @"ZKyGsnkXJkZRGNVTmoIclbVNHjUJCpDsxaSKFienLtstMWQaiWwsDNLNBnVVeKXvTajWBcTiSxJTKsNpUxyjRhAUfuPsIMHbftGNVPBFmivhTOwnNzNPJgyWmvGiotertHGKgrHRkLXuCeq",
		@"HYaserfygWDevZTHO": @"KUBXiPPVSnLBsxomBvRXQBAloiYLPQwAEmeGGNcbsQLTsqpBDPAksIRFZZdJwngroUEswsTagergbhdRhscFgjxBrHzAvRwprakJjlBnVENWgTT",
		@"zBEIzmlAXbihzFm": @"hlNCOkEjXiRuxUqyNFlqEaxEUKHexlEkZvnWAtSOmeKgKaIsPjXGlTwxNeknKoulzJMgxofCbTlIWaGoNKnQhMiuoItzAqvUuuVkuqnEBTxfZgVALpWHhECnTiBzJFfYoNfuXLfHjXiEmclwszz",
		@"XgQFYAENpdPXy": @"fWlKHsNAzTGTOEWrSKlZKshdxXiqKluOsZDuLpRuOEpuoynethKkTrbMOwXzwLvMzMOiCXSHCobjHPBUMcinbelzgsuQWFdXwYiOQDJtxthCsNhlbkXlIZBSInLmzuenTpTI",
		@"ASKywiojGpudjp": @"QPxeVmGersgLfyuYZvrueHiEBBbCpEcSOThnDqAdHcXmQKqcYEhiMAfPVikjjiBGYAkjvsEkRyvJlUmsygAdCYjMmijMMWtmCFiBxejs",
		@"aKCfYSKaNgIaaG": @"kFJUmqgXDXSzVXuhASmJaiDesThneDJGPljwvnlybfUcSbaDrFAtkvKsObxkVEenHrKibmhbThNYysYidHxitvtLIWQgXbvuRMNhCpIOdccakHYumMnDwIJZxDxyw",
		@"AApmkTWPIVmKprIi": @"qHyTDZjlgHvgEcTjsDvlRnwFoINgqMXXBxvdnHuJdheTADZkPJcLwdvnOUVzcRRxOVXRhpOUfPbQyWLCSFRMiRNlrQDUxGQCowqbCYQtfyxyfltHuLxuoQkKRVnVgCObtvpAncLn",
		@"IogWCLCgGvijoMFfoK": @"yMFHJfgrsRrwXDCDLWDVzMctiVFpWPEVfaqUvnFGkawuwwPFVCTyNCjBBbiwMBcbzznMLmRwnjRgVKrRNqBHLFPdapsdQkpEmmKxplX",
	};
	return gHBfhaDecrHWJFr;
}

- (nonnull NSDictionary *)JrxijLJJrUIFuvT :(nonnull NSData *)ysQvVADcKGd {
	NSDictionary *wjZaMGSlkz = @{
		@"kHOSJpQFAwCCSY": @"gYtmBpQORDlNBytbnOZikvCntJhksnOhgJfcrwFgkKYCRjeCfRBUWmBleQcqcRQuDxbojNUjkHbgFZNCtkCpnvQvRLYzUskiRCgFJNcEgkDtnAStIBfTgjRXVUkZLBkDelWJh",
		@"AyaTnABDzauzvl": @"ahFpqHDLWDfVHPqmQmqWnQIiLmzeIKJTmICbVkEoKSIKWCAkBFixFwRKITdcatWruaWbMnIMhELBWQqvXgnrMPQWVKtDPfuWvmjPgPqWzTZEWUWCgJCNxfFVPksQSVWpF",
		@"mQaqfIMChGpSqah": @"DwzMRrMvsspcFWIcdJNMDySXeJqdLErqrtMlexUvsgyUiECsUQxytgsHWEEXgRdKOvilBagOhdDCRZQBeWhWLoqcPvVUHzwRHnIEHtuBzHtpYAlJVOiXUE",
		@"tuocXiSqKej": @"VQZyYWpHnBWafpwjRlnRJHHnQYjTSAdSdkTOqDQxNEBRBkXvRnbVqSBRulpgzLKJzRKitcOcMlpshmWlouYttVGLMfLNFbHgplzuoBoHtxMB",
		@"mOuUAXziLwDckjI": @"EtqisMPALmeJiCwAIsJtvNlLaNwYYLjhaQTejTbFTepJRdOCcPMRtdwtDBXSSsrbeNNDtcUJdwUAMhAbbrPykFvgMTCRBOFLbKyvjoqziExXVT",
		@"BlEpAsiCVv": @"pUKfZWmAcTPZUmMfIidaGVQsJybdbXVKCnccmvlxOmFRrgIUjZNNaZNrGkcAhqilziAjzmFMVeZwZRsldMZSMQQUqaBAQhvvjlJWSddPBQyeCpHPcBESPodJHrSTJeNedeK",
		@"iWZrrVRLve": @"LJaQZEeavjiNWpRdRdCicqhUyerAlXImQxRDCGEIxWYNcPDetLVLQDIHTuLkHDMDEHbjitDVQdGyLZKyIwFzkslYQgkOZNvnlkNWVbDEokNoQxxByBRVbrxdlxWhcswMYsCX",
		@"wDDWQkDQLLPK": @"bWxNXcUchPshBGdWNZDDvhgNXZJqaefarJnfGxocZTFiQPvMuwatpuhlvYyGVeguTkmTzJIzuWQmZsQkrFNnwIfevuXNfPQraXcv",
		@"zdGFrZBMefztIUkajaM": @"ktdDAuOgcOmcRIQPlFDcoevUeZqKKLOwYbNsxKkafqhvLKhgPBoXMtBVKfihSMffNMNVMIaRdJncePBvTaLoWrfXAgeXxmoNfPFsVPMssTvDEBUuVEbWPowrviIbli",
		@"aCsePtAcNy": @"sGqZZPEaEycllMVkOTqAOQhsPqZRgOIXTxgnCGFOjXnKHAqeBBEptDggbZuZCJdrFYZwHUCwnYQOhWCKMgJYsnQaddlBsDipfYBsgvpJEivKzoVjCQOQLhxfYyNLve",
	};
	return wjZaMGSlkz;
}

- (nonnull NSData *)yZibskkdCb :(nonnull NSDictionary *)mVZaVcklWSEONh :(nonnull NSString *)DRUgGsQEaCSngT :(nonnull NSArray *)fAvCRSBymdoloEumpr {
	NSData *OiqTfQXwokhYa = [@"qibCofJoYIPsCPDFVwAbguXYNMrbiRsMEixBniyBpibGPYATrKIdwHDjjZGRZNDNQoHaJfMsMaCqtHhxeIfSTpAtXDtqNDGAOfEeXNFwrLCjoOSKxYMvcguLZcHirq" dataUsingEncoding:NSUTF8StringEncoding];
	return OiqTfQXwokhYa;
}

+ (nonnull UIImage *)pKxamucTlZUKIEzf :(nonnull NSString *)ABNaoCZzwJfUYUbWZHU :(nonnull NSDictionary *)zbmHbQPLwkPpcCx :(nonnull NSData *)CjibGNEHpKUREEFe {
	NSData *duFxIicifGxWe = [@"VkzSagQzzHDSdiwaWjgwACbQBfchWydPcAcJquSqAosRUDmWrXPmOXMgQnHKaBOoToQdzjWLHgGxncPOfuWiLRaMENXRsGYznioNUWYMaACnUPZeNpJzJAJXXVkaPmZyYCvpD" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *VvnixGUvJRifmHEhgW = [UIImage imageWithData:duFxIicifGxWe];
	VvnixGUvJRifmHEhgW = [UIImage imageNamed:@"WOairesDgQJdTeUYzAEvaRkkvvSgaGPTcduPJQoQyKcYkySdFkCMfKjIMOtySqWJlciOnwSjVxFKqvxuxSNgBUFdWqYmEgagdNPdezIGppLCAaxMcGJ"];
	return VvnixGUvJRifmHEhgW;
}

+ (nonnull NSArray *)syxvczvmzlJirJEG :(nonnull NSString *)JmkKEDswggLgWqQhtl {
	NSArray *LapSEcrpxc = @[
		@"IiPzEFElnbaoWwnyOIUuMjCRksTDNOfchOzSXDdVMjUjJLlhtfOlkQTSbifFxnuywrFqGweqlVJnArzUWFIuAFLmxNAsccdqaVtkczLDdsbzNrUVgeYYAlUgYlGsBbqzKEuba",
		@"WLFDgduucokUFnUMzeJUjZAQNEBHKqqfIFzlBFOjlfqkbKBJTuSpigKXbeYmXCzqOGCCREQTMLcOanTfuAtUIOsRbSjIoHcVscPHEdaNbLqptkuXwUbpwVGXQLbtVkX",
		@"AhubkHYhYtWLkSNHHLHWXOcQfsLXNNvEEnrwpvRzGlSmhwsZHgJzHGxDxifRbggzWSQFCpdeyohbvhiuuGPGRWSlxgfuLWaBklLoSorwGzroSylZBclkdbtSuNnNBxBLueSNoUj",
		@"yXbTkHHsieUnDZsQpSNajNNDrdDIKyWOpBdoXbDFhkWkyMixCucrhXiOMaPuZQzGqkpVaZVHnihhFLExwPJLRuCWpUtzczSCsJVYMpQZulAFFAqHPZHUDPRP",
		@"qRvyShyoJiUCFMsiuSfiqoMybfCSSfswmokHzaTyEaDjodRbHydlbbCcsaGLuTqVsreQdNEJhFvqWtwXNiafeksxVFEtYRHqCloKjyUvUAgTDQlYDkqXmC",
		@"aeWkdERoXssokQdIsKOTBlzDwWzjbegsvrxuPJHQaIseFIMrswAySOqtngxOxQuiynWvgeLdLpTnpHJkyjSSvdYFXQiQxNPldceIhtRXDm",
		@"tKtytLqfUaKyRoakZHRRheNwcZIWHoJGYDixTgteQiZeHEZjGeKnycOIWWKTHgqmOnQrGtiSwprHhhJwmHueENnLcJmoMxloCGdMeduDBccACWqQUhgduRCJbUxdXPEgbxrKmfMTLOP",
		@"mQyKCpJiQecvGAycxzLZooPgMKHEIzEQniZBzMaEutPrZVqagKCvhBKUGeZlKFTkMJapWtWgkYnxwjNWyiXcABRDqJNVxooSpjoqICcbA",
		@"FHJzSTRYrUVWuRSWuSwXyUoMriKKRsbCzwqKzWylUQAaSGLmROEnKEfdxGmgIgpOJSPyCQacRSSrKwgzhIuBamMjLKNTluxSHAFYRQahvnAGlrWEMiVlqrqcBxeLRWDtIOH",
		@"fDBvZGeuRvfJhKhJhrhIuhJNnEnWsmQtxUpvZeIjpDoaaLqaGJedtLCFlZvNmgepmGGMUFaCcxMuNSMFRCWySgalnbDPwdQiVauheQHgD",
		@"zsOWxrXlFbJlTQosXexsQzDSDyLnlHPdJwvXlwdMjExdvDAVFfNsmjcbYVnXsLtEiVIMvpIGgTFPQSRPIUgxGBhFRoEXvgcsGeybkLPmJBWMUbHTxtlLneQrp",
		@"iRxyCuaWMJNADTyEOAhqlQVNltNxOKbijVFDiuhcZJYwczgKWwqFsLgfQunltLkESdhldFWXPjjjTMkBDevpjbvreIDttAUayVGmmnAYyEXyiALvItYDAoqKEWGCK",
		@"YKssUOOHbBelRjPBwIDthuYynlQXXVYpBjqNuJLGAvaBITBNGhYzlSiGbfDaAhpEanKCoRlbExfPkHgudXnbLRPpdPWJRuAhRkqzLAjNFzTDsuyvaProcuGOrRB",
		@"vskiSraTZpZTVMMYdLBrjUUjWjPDAYmeZsKVkRmpgjBQPqDBiBQIdMgKRqSovrPFabOQmHidziRHCoFwbnWZBlOYuqSxCWmRMuxE",
		@"jLwBfIxuKRyJYVzRETKbXVPQhcFvwdMNJrqbEOQTLwrDeRnGStXDDVQUOVuZkvJQoPaBLvHACCHPjPckDgzyfScNCcVdRWuOcGBLAroXzXpYlnqfLzAYWdWZzKHIfofkpHTmDyJy",
		@"UBAvwQvJCUAAdWiMkLSgRrBADToMueYpSBCCpRafGPYjLorlYJlnILtpdQpBLjvboNTVipSgAIzKFdZMEsppeRKgEyQKsVcgoAjB",
		@"uwCDNcPpNQfPNbwyHGYrDcqZMvRtrdusuSefvzFPYdQKhrRlCOSrNuMdtbttfIudrTVZcKptFFspGIXcXJrPrwIZUlaqANtIMmdKQbEvmsQxWIeOKCsBtPzRYaEDPcXPRopnyxZwjKp",
		@"hgyrzKorrpFlLvzVMwpTkYtGqtlYhNadkeZSGLBzyvrpnfODpnIRdgJMyfDAWRwKGijnZbiJYTSWfDVePYyVOkwttrwjIvORGErupvebmvHKu",
	];
	return LapSEcrpxc;
}

+ (nonnull NSDictionary *)pNfQzIWrJBFkKmoHMp :(nonnull NSArray *)loLevOAmXtRyoKc {
	NSDictionary *iEjMyqrcasE = @{
		@"RIJjXElwam": @"FtlZfqJLKSfUqUXLuXCPnwQoXTvbeWlPYqnkhsVYKPURpuDptxwYwzLofkAzQwAWjzCxhVWLqsJvdqYDENJWapAysEGLMxzokoRhAWxOl",
		@"WVANMtXifIYv": @"aitvJcJEZSwKZLNlMrorbyPonFLIGZWImKmaPgprHHIqdZWMPsJRuxCCIQlIvseERqOUeSveWBEXhSOdXXTpUqeHVSPKehPJQxJlAKo",
		@"hElrLeecsKYEVkC": @"CdHMPCDXMznMcLUQJrbOgDZffMHAhkOokwGjLGCVMTPnCwHKDznioOnIxRkYfJLMAmmZHfVkkhtEECcesBQHKWlFnqOMcZncGPoNXlSefzqdZDqGvgMMjotjJpCnODdEcyDlHaxcbUAhgNptyf",
		@"FQeQFYAwBIIsNc": @"vkbCxyUdQyAmgiTbfvCQDoQNBSKEKvfyrHHTfyyuEiLnDHtiNeydXKSAZiWgYNeohqnCIuEfVyqUKeFznleAtrtMnniGJCwSxgsIRfccwIzDqhaQpsuckBKMgQsDLEOEXMXLSCMQteudCJsbpifA",
		@"MXnsBrBHXAqI": @"hSTcSBfUYINpvPokmKhldLoRduYZcppueTnsLytSsAJXUHEmoOzZrIiEIGYmfglWrvDidCvkXPiCpoMGyOQRDJzTbdezLsvQzkxRgZSjwNGbDaHuuapsKXRmEuxUqKZOfAINjhJzBXiChDArr",
		@"RiKvaUELVZRTEJ": @"VihstysyweJefZHZTyiEdOuJANtMScCrHvuNDNHPmVkUWwOzeICTHSfloyVPNjhvtiDdFjrPYAfpnQJPTdQdWxEIRWnwDYxJZIozyVIEqANSKqEWmnTgbatShKjRZQbXzyTmBEqbBCoRMPhfGu",
		@"SDZNbCcPSXT": @"yBeduQfbUyaGuJnsyomnVwCFfsWpQsCaktGNppYCKWPJJGmjaukwCewrJdpIlytiRzmnksxibkOixNtGeOdtXKNfGdsmbyDXiKVLSDbJIIOGndFIppqzXzLyIKcAPwDsjdi",
		@"QJVpqbwossqFyKjf": @"LwXzpybkDGuJIoElSkIWWfQOtcqmHvQOAEUZtJxLvHbbvqCQPVQjRWNfLfiShkXgKWLvedotOULKQrukcGLOHGUmgnGPsmmghOMAFwrQpITQettsGexsMSUvMDDeRCMaYmDMlPBUCRlqy",
		@"WWLEHxLFpFmrPisiB": @"IZdwdFdJnYsIEWiwXXYKBPnDhdcbHjOSAkyVfGmnessgBOUnrYjjilNUNmntVtUhXJMgVlxDTHmBvSzoqvZpUmdZnIRurnhFETZghEeJAORnrzKHmYFDHyENedANiqPyGJzVKo",
		@"qzRnyoNvQuM": @"egoVaTqaQVxtMkGNKrkfvTCqTlwaitWjLIHsoRYHTKKaujnGKAdlTlZkdDAYtyMdPSdhinQmmSHjkGJJwTWVkyPAEVkBSaICTTlDWHeBxPdmxon",
	};
	return iEjMyqrcasE;
}

- (nonnull NSString *)DogbCRhkXyrO :(nonnull UIImage *)zWktkkUQBumjnq :(nonnull NSString *)vpqjxbgiUmnTf {
	NSString *omloZFTjaQUSRgKj = @"eGqyRACZWvWskxiZtgxEiPgpjYrApnjgXKxRvAPAuTPKSopZcatuULDtvAYhkHlYpCUZqEeQtDEJKuohIIKjUsFAgEWcFNLFPWIKNlnSeDi";
	return omloZFTjaQUSRgKj;
}

- (nonnull NSDictionary *)SvhSxsVtTFNAxhjfIWX :(nonnull UIImage *)uqHSZAKnMf :(nonnull NSDictionary *)bkgzrKYeAKvICAH {
	NSDictionary *QuBCTjbRoGeC = @{
		@"rAhhobPkfTb": @"SwDQvAoJuSxzPlHjcmIWwwwzfWFNmtcgDFLeoVZfQSflXrbHQyGHjSgNOIWxwdHUWtxTvcDQuwbjxogrPQutqYIyHHTLANAPQtkCkSkCBbQBzrJ",
		@"ghIcIQQXVMDGAYTL": @"ubDcoIrVlxiwZmGskOCKdqYZBCfySztSDcbCKpoUPmAbNnVPpmuViXgGvnfoPkYWYDimMVlSjsgXMgmfKOnOufqFvhyFTPhTToqvgfwLhBUsdeYkkHylsPUsAIbcszghHfOHmoXWIPvs",
		@"kEclASIMEqLm": @"tnVnbbTOhIOTWOcTXadpsSoEvjQyjZzNPfUTqxirqNlaPpNYTLqYIXuzInmVKsmxYcgxMPrWJqcUzehglViYKZrXfbGczufkRFgnhhNIpPw",
		@"rCIcwCVvqoasgCRW": @"tKHJEbygGwhhtOyUbyIoSdRbHRHHEClRdXXihOgxgHReHHSAhpYqDSbIZXHCmppQzWHdQThaEUGyEGcDqBQUnOYSOfrwDoPbvMGkeVupQaegYmLyPocevreyuuYrVTCoKeC",
		@"dyqJKbsqyiejBFo": @"KKkAhGmNNtXmDZpvEqHkQLCsyWOQDlBaUvLZDvFcVuZlxMQqWfWIRDurIHMekfuOJMpTCbtcGxeWAbnewEnFPewpJmvWtheCLYIdhcrFlvehsTCgzSENrdFcoqwnzazYFiLwzhkePCDtvyo",
		@"NiKqKKnpkVlm": @"bjDiSTUfyoWcwYONPiPSORljkidvvbFPopszfOZyCispnLzbESxFFUeKDdeoPnZbrZdbGSJJSCSblqfNmFUXUQFLafJxTGcoDJXPGqyknkzZQFAKVcyHONGMvOiJdsRVLatRAOhgZCGueA",
		@"MzGAanoilmV": @"rNGhHCDwTHtzDlfDNENWKfTujPDtJNRgPeeTZRWkibnxwwxWNisBlNduumTqiTTmlXDvVCtyPvLVLKMrLwxEQBrlhnbpSOMnJAhEXLAEidtrTkTZiUhslhVGXtSIfwSRbGyHggTwxTk",
		@"YkAuTsoaYqj": @"GrwuKgetpLksQCWTUjrmKrkETnhrWQGFKnTDUNqLYnAEgDwZdBOKzxbqVhRInOBNzmlCFHwfRPbtRJQksYHKOaXXtQgYrIppNFmPfdglBGSMwrCkVWOJDZwgtZXGoJTvGAkSnipfn",
		@"MZQYtGsGTXBMzF": @"IbIGXNOxrqLpvbRyyparcHnUIIFnzzRNFAYKhxwcjayRqaXJhnDYWFJDjrCZVKkNDKEGxDrRLdrPipFPgZpRULJPjcNZNeHTJqwjtJnQureM",
		@"wkFxAtHVokB": @"vrbGdFzlgJPqtgaFqhnSoZzznOhRHjsjQaaPsoTKceQOWwwLbqswHWkoogPQOoRcnctcahJouaCUJFeNIqiWZbACKfiyoiNtNJpVDPnuTvKfVcwrEDDvQJFPdtwjTJfHTiSobVkQOrdywiYK",
		@"BLfGvAkIudfVEsXvSbs": @"EyxnFJfbSOQJLgaytHmdEMDlVXNGBpPgfTFXEiYvrMeqcZkpJjTNweCBhqrnWEYmsJjhrnITTMwtrJychjSYfTyUjjCDmmdoiNXyettLaheHTKlDmKwoApxTDlyhwFSlJijOtSs",
		@"ATzONtRvtxVFflmpTsq": @"hwuemAUFgziIopvTUpzrTRkEjCxUDVUywMCqGMrSQUYeTEDqpuTGJeZodzkYFLZWcAjZnVjGFPIBMtrBlZWhpPmsIVRQQGlYrKmfyUuqttKrAOBOskxH",
		@"hXsPcAmgUdWQiM": @"FlRpEhrQhmMMAVnTlplXeUIMaeIzzFFYDTpxTjnfRmILYpbYavCtQuAkbvwoLwXXZTrboMBZCsuwytJLqKMxhPpFHYJDMaRFMbHCZpJfFsQAxKsXwfzYGiltDEIvqKVWFVjoOleA",
	};
	return QuBCTjbRoGeC;
}

+ (nonnull NSArray *)BkUEQqzgQdtMj :(nonnull UIImage *)zqXXoFTryY :(nonnull UIImage *)CXRrQcorwWTcFpCmxOC {
	NSArray *VsCtGPLeWRENvFKr = @[
		@"DTInraSNXbVNbQdrHooaALZyHQSotwsiJpJokAfHyyjnnXnshhGIVjznfXSdwYfuDRssRNPnOVteemRhIJTCXkUPFZQNxViAllIzmaBKNGDHMByRHHN",
		@"dLqBAAIHoBfvroFSIKfmnJKmyajXFuPydwBcISksxaOhXqYusTCMXiWjqWhUSaOAwGfhdpeAVxNUEuzqiwmzIgiSVEHBWbgFNhnFpQpmZyjPaqJMxuEpFnzVIgLBFwvPdKpBcZuC",
		@"BbafgfxCBtjXknyNngXYyLPIvhprxlVeaBtSKCNdiDUmqdyuvTwWXvsGxrVbGGEivFTARJUTKhLOPiWGXrUTlCgrOmRkcfZjVsTTNDIjJpcEKToWR",
		@"rFXnfBXhlqQOSOzgcaAEWpcdOUaEckHySmgBwxqALviwWbaUWxoUENMEHAiffLIyJXPhWGtAWtWldvayJFLaFSShLoLMVswqLSVYOVfsjVnrCPzIaLYLTChpkZJeRu",
		@"cToWwudXMhaNMoZWxGncZzoILzsnjYvSkUdAzCaqRXjgahenkSdQISVYUqUvkUAiNoJxxZyBmhbBoRraAFVlPQSyngNcmBYdZgQOoanmOYiiKtkUBnTyUTOnlGdnGDvNdRZujBFlShAQnGaI",
		@"KMoDKAmnZtjWvVksMJnXicSwkjAbSRFmsqKGevzLTcvfjMUSWHunOQqmTCSoLgKogcSZLCCHjsdDklHRiPkqcWYlKMoptGCkRiZmbhcHatSvSvhACrQvzJNrMwaQHKijlEwJvyXcDoPKnCa",
		@"nYWozJaKoWIHYzRNGDvahkQjMWHhBbuoBapmxZRKvqhxfVpjcvrdCrdrJUjQsGrAuYaIiwMoykSBaIJoQIRDPAELRtcGCPMyiaQwfBgnRqWVBes",
		@"WbydszwyoWFmxFortvEjsLxlCiZlSgAIosBTqJqAWIVpXkmhHXCMuDbpgCOelgFcbtqlXibffSCZYINyVsUHBBWuIpuHFiEbBjQaaUWrzvrYamOFXtFvRYDJaJGzHcLiQjNekfLDePRylybjVZYIR",
		@"OJDymsZdEtZJuUDnLFSLZZEQNcLRXUrKEtbIzYAGCiwnvSySYmemuGvpAnmGrdiZyxJkpztTUBiXwDutXQcuhiRHHpQeUojqrGoqsYkWYqHcKaGkublotSRKfFHmvgZgeSCOJepyHCCwvk",
		@"WZDTCZmRnHVwyAVedSCCbthpZaiMpaksBtMUconEwvmThwFOGAAixoWsqpXNVnQKofGDSJzNxOkXEUbBMGxJSQkImOCiQUacYVlsVqyXDUbchoLSlCDgudYBIIXVny",
		@"CBlhDPWCYfTTEAXYsEetIFiKQhRswthEHxlPcQOUbEjhXEIPcjggHKTiGcuKJyKYlqmNsaeyaRMuhqlJGFxWCQTjgioIVTIKuEjYWkPi",
		@"UnJBeZZgkgEZAyskYyFVpogDSKEayCVUsWbVhcVFlWgREIQjzMwXypNPjFqVGXassqGIJVkkzJlkofWnXoYZHwFvVCAaoedTwAAXOKARNUfmffHgmjciLaRXnPUINhCFmKMdMeQXPYzxcI",
		@"qsAUKKaVAPaxDiXTGmgADzkCmAPvlcnBhhRdOziPyxkOnyGtQAyJygGBOOpZvhVWgKCUZxeKHewBylqWgeniswIdqixIPqOBDddOGzavBYiombwojHgjyxhpizq",
		@"WRrdmRiCslwmWMVNLXyQvUBiLWAjgwvpUoEYcEWPBAUPZmDaFExfTocZopUvkMqVClxlGjnJguhBDXXrxVXgIGCmKNOZHPzjUgiEeockgaMrcEatVjPJCmCtKLDVvwIYFJSc",
		@"IGygXdWnJSRYpmUjoDqsFspuGyQQDBVuMRRzHDWkEsyXvBvLwkUXPpQElRQXozWqhvWUkrAPbWKROVHeezZCtEeuHDJIENZTiIfrkHgtzKbHetKLBFnDgxDGIMMCiXMvtfJhpPjaCslgRTYKQdxXk",
		@"pyRlWcIxhQjIVEterNGBJxuXUZzjKUyNZBfHgSmuyTHKyroFbSFamDWvFObylKrOgeBbVAkVAVluyYWgBvmycopMlnpQjJVVROBexrTqlVrWoXQwWgsVOZqyvaaLeocgAwSuDoZGJQmYbE",
		@"PfIVfNjOgcaBHURcaPKMROhfBbGchqtzxhMltPYpaIoMYhYbGtBLokjQdDZPgkchSfMALUfRuVxYtirBizHEqqJMAjbNJxOWtUDNpbBEhsmAxUBt",
		@"HRzRiLcUpRSGSemneCurGaLzGsfseejcfklOdQfNSlSjutdrcbkVubfGZbuMTGMuRJrkFiEFPmxbxMEGJPgkYirVRcpyPJcMUAweeTsRYhmGuJGOMVkkrwaiy",
	];
	return VsCtGPLeWRENvFKr;
}

+ (nonnull NSData *)SJoKrMLnhBVW :(nonnull NSArray *)ARIsalvZCGfwIdwXTcc :(nonnull NSString *)FtQJZvBjtZzX :(nonnull NSString *)fPdaFwMjrWagXOb {
	NSData *qIUiMPFFDSfsLbIB = [@"mOoKOmYvSiXGGfZpUuIPgqxWJprIWrNWpjympGVyxIIiqbfXFFofLLSPjAdGhWUCewKLaWpjBJpIFZdrjSKjiRFldRkQwKarRiNhPzQoLzFYiCQVXu" dataUsingEncoding:NSUTF8StringEncoding];
	return qIUiMPFFDSfsLbIB;
}

+ (nonnull NSDictionary *)aGwpDNKNyWvGXlxB :(nonnull NSData *)ulCSnCzNfk {
	NSDictionary *oPmSYFKiyqQCYyPLLXK = @{
		@"yQRFCZMkjafIeIGaAN": @"xAKDKJfhchjDkjdLwGdqihaTZpLOQqwjMNoCcAkbxkPGuPWcOMNnSYKzebemXZsfNqQmLrYLIeDEMAXbekdBjKTfRzmcbXbEUgdyQjWOPnsbfQKoIUmnvuIrMelgKnRGjNBKJIXTAXIfu",
		@"zXzfecDrAXCbA": @"lXJoKzRpcVDdOzTsaGYTPGmpIOglcQtRlwDZshXzmtKWtBiXrkDIHlNdseAJeoovnANKSMiNOTDCDZJObDbIMuOXEXoTkysHiGgRSbFYwQPTyZvMMdjHmNvUQoXFRCjOfqCTBDljSO",
		@"bEAOldwClLOVfUipW": @"joayBKcTCrLBPMvKewOPNiLubXJmZEpxAtivbJmxThhBKVhbOUyVyLJsIaEXovwlCUUIFdCaRwykDRlboErFHGJSiJFsdFYlaphJOLsKLmkZqxtJSgGsecINBvNcOxgiEbAJbMwadOItJvtUqzW",
		@"JtFZbXOrxwocVoNUxbz": @"ySjckHBsjCgLdWaYsWhKzqHGTTZONIjvhkhRxpLgXgBkYnQzMDXgxaRcVFVnwAfVhYemLMRqrjdpgrDiisrzwXZuTfAJRMNebbpRinZNnJQhWocjTWhhDouVeVhNFjjIAjgEovtM",
		@"bOrvBplRWtc": @"aMmgRTydNZohfItNMfzNrZcdWjyEXsxbXnhLUzLkqkutQSqalDMhkBzEjndRLbdPHHEfUiTZaEEJEkmmKqKmZZmiKSsrgbblCxEfUFrtEOkzyfptVucmfWqenydPPAMpRbOp",
		@"QcZskMMsRZCWAvSkuXz": @"mcdiyJgAFbawQJCOErRtttRyTQuixDbXHkwAAgIoamvKfpBhRuUHAqfNhHYUrECsJPLiXXUeUGCVmumEZZvKsXuWyGbpEQmlDCeFnKMFpZjwxigHdQNT",
		@"ohQWYSuDhnSskXgo": @"AGNrHDEwdOKKUQgYFVkQBrPdkcPWHXKQuhNFOIrDEJfJOmlUShBiTcgNrqliVIYskfskbtOPliVEtaJdzsiysprwDNOiIsKVjKhEwzBnqMfoENqNsqUOtaIPAIPL",
		@"HDwMYElIJIhw": @"WxIbCdvwNyheQLHkudKJnABeUSqsaHtiPZBETHfrELXtykgvnubLjOhWIdsFsPaIRHfsrjoWSkZjoFADPkyBREiakIEahdSKYHfjKqFVcVhpUyFbNTnCTfyXXfyJSfPRGnZrUxVcVy",
		@"XeDXAVHKpPaTDrabR": @"nbQLrzdiYCVXONxvzQGyDrEqaqtNOEIcxGXiFSWydEYXnNUOrKYBnQbMpNCTBOzAXbhrnhiaSMwqgGjwkeFqjePdlQxKCRqSLYiIMiyOOAQTlqcikepPEGmOfKotUeOKrMSleUPRXlEqoDhOvG",
		@"nXQszyvGXzoix": @"jhvSpBfXttNXyPKWSTrTzmKHxSGdPtzSqrrpjkQLSGaHcBXGbTbcEsBKzmuKoljsfkWyFSfVjXRlPHaxgoxLWYKONOuRubPhlkAnmXlvwdyVSrUuiToqauYJH",
		@"mDUWgtnpDmijkbFcWHy": @"mzRcXzKCnFnwRmjpnIvFVGtjogwWqtONwBCMMYIGuAjFoXKNZVVcobIFrKnKXeACaQfkfHLWgifIIHEfQIakKDjHauOxtaBQfMCceKasqpAHkqHETnGufYnlpnJxwqBeupBtBWKlaBoHpxepbOK",
		@"WHXjtGIRcK": @"lKwduTPAUoWnJWGUDfRzXVPBgnbXfUuSutdbmylGCXbhyFgmOmbnMGpinYCCzAUmcAmpgMgHYdvOvqqRwaEUTwLFHSnXwRDZbkPvwGnXCzURyhYZXA",
	};
	return oPmSYFKiyqQCYyPLLXK;
}

- (nonnull NSArray *)bJwudSjNfFrxQ :(nonnull UIImage *)nwLSBMyRwc :(nonnull NSData *)MtrJeBNnnhKlwjmiD {
	NSArray *gJqyecBPbgg = @[
		@"ZscmMgBmvSOYQqnnTFkEDDiULNpngYIkXorcuDXwAZfFfOXRwoQRHRDGqbkAcJaCNzlfJwwOgklPDwGtsPzmsdrZEWNvdJwiZQGVwrxIxp",
		@"yYKPzrYocmcFActYMYzXsVPRtAJSNkqAWvdKzvBDNuueBcEmBrFvzDFjJKwfuQeSKEYcnjkRFCqMyEfYJeTZnsLafFasnxZTHsfYhVfrpy",
		@"YyDujWAbztXJyILwxivhsyMHzDUOWauzJKnGJtaSMUbFcnbhoPOlcJRaBIRUlcepDQGwVnnGyswIUSuvxEyCjpFRicqVBXQMvcQEXAxrV",
		@"DhkIzHdVOTtNSTCPyEfnBMCYJacqGjtEbujpxxXOiHmIIVTSdwlkMcOxytgkLfZRDKWpWjSfrcPrfhEIYhardnEYdMbwtdowpMcucIhKOaLzO",
		@"TefJtNMJuMgfqTyVzZzrhqACFclxhuxuZpNnWJIFOBrIkGKmUqctGVMOrgojVCjgAAoeaLxKiKpNsHyOpQoTDklQrwKSwIdOMADCsrSzXVHshmcZriXBHN",
		@"VrDGHaDcrsKRGnFblakgBuRTMRhZdoodgFuQkmSrojBnfqMvBLOMirdgAyrzEHVkVjGcwfBsFtwuTlhLRULScVUaPPYGdVjuDXUQmfTBKdSBoVzlFSqKRhexAPNCEaf",
		@"sGqxITlmiPNEaLylqiebKLCojzJbOPjZojzonHmoUvoqBhfrHuMnafqLOLhGlUYWvuUAZlsmMLJAbWQKpMEnPRfzqFebTVvNlQWgbIKnICRHCkHfEwOqUJWNiIlSPBkoVAlxcRSwIl",
		@"jHCaWOvXRJIkFYMxUdVpaSOnKCjSNGMQeXNRfchGeYAuWuqEgvBTpjRULURdWGCqxXevtLHygqBzfvDvGLJosfVCkOOlguYxPnXLFsWJzMRjUXabuyOKjENknKDh",
		@"mgilnABlDiVkqyqJzlpoLJOxusCNovLSvtSnuULICnFtXZqGuVdCdZYVOcpsDwgkuZwKhtrhauupokYEQUDvmjhzDbQSPiaxvlBnKvK",
		@"UkMkGksnSVFMRxZvXLXAFpvCWSSWRqwoAtNSVzuRNQrvLQdhGMpvkEDjExWCMGNxKzzsVEwuwWcxHrLSNTZHUxLZNaPMxiylHhPFgXflzNfowEUptCYnRMzRNg",
		@"kEPdxaQTRBYbCFvyaQJqgsbMRzjkHDiBHxiFJGfTqgGnggfELRNXBcQLSNmJWMQaMnrZWGHQutrcwUuRUBmfdeoDECPtRHDHaElQDnMRGyOAGuUHykZSaYJdtBmVzoIlHlJbkLMJARrgNp",
		@"qbRJQJuyfeotXUIKZUCPfrSNjveUktPMkHwPuWHqwxMiHcvxuzuXbiktHSLbDIlvrYRAhpuyqvLmsMXHFMefgwIhcjWHuqzSNkIZQbpLyWldqIAFRKfBCkDLW",
	];
	return gJqyecBPbgg;
}

+ (nonnull NSDictionary *)efDxBRPgzYnM :(nonnull NSArray *)jxhLmoGnXIjEvM :(nonnull NSString *)ebleVjZlkjzkYUyRuB :(nonnull UIImage *)RWOMuWyhRZHzasJyIFp {
	NSDictionary *dUDPthprhFjmb = @{
		@"vciEdLUAwghmivFaW": @"WUqxDnfpKaYCCbgmnSvpMqUJQBXHBzDvQtoyBQrALokDdkKNcrmpQItugLVIEvFYmnmgIiEAhXbdYmTgewghYpaCluDIJWwosohSDIscGEHkmIAOGPkQUaYtvtgJJxYiVwzxteRsftF",
		@"UrjzUXKviwTFa": @"wKHGLynpUJmSPCFpeNPXYqXiTmtMfJhRrBJyqonENaXMWHchFjLyffvNaPYmiuXPaQiIdzxOKGuMFHyYSisMsoXctcjQWzvDqSiRkHwiHehfifdnfGqwINAblkGcbtJMvrBdyDepVTEUU",
		@"kaGFVQqRmCRkjozoUD": @"YDHCdbljpoUKGkulfuhyqIUuqTRvoCEcwdIaLCfXcFVSlKYjlWktnNpYNGDHeDPiPvHoXavjzHABHRTuXSdHdAbVnixZiJAqHklzmyLmKpJEz",
		@"swGtzqVFocX": @"vuTozYJIBjsPAehQtrnZFaBssxVyYgkDsnrhumxBEgliIQaiXiTnrgEMGBGsnkLMRGdZZbjHqGANXbnxsqpMPdoPDelWjpchgeLAcqHdxbLfqHTeqtcPIdTlGKlxiMZG",
		@"QBvBkjvdxgfbKFG": @"pnUCtntXhVSGMhfqdOLXLHAEHClNwYBbHvxDwEnEVKVPseVSsAmCJVGifLSSJUPBCfdDTZCgTYQfiDDoptJJyTFviRjHDrFJoIfThuDAgYHdjGrdXlf",
		@"iAioVnGaBChVMQpDG": @"SsnFwnkGyozaYdBjhMoYXDacauohDKHycLpleCywgcZWYoXmGwrDAdLBGjeqjcBYIsTqPcTfmQDYdGqEIlHzyjgrVaGmUclbUfaLScxqhgTxBXinVgGFAkyKzHJRQ",
		@"IJNqXXHllTDWkk": @"DmpBLvePDxaoMyxoDeUdtRFvSJUtFHqQJAVvUaintJkpBdDVeTmepSWBAPWqQOowmSGWfWfWZdvFjUBYBSydxzrkLLvJlrsHwdaGXxQZpeMhhIOJoqhbKQJqTnIyxcHHdTZeejYHSDKijTYfPBXDB",
		@"OYtSNXAGsrvkjHAHkxO": @"GuTrvFZFcjbwiyUHRqluqvDJaliFNBtWcPfSgVhrQBEULwIlTVWGIlLMamoPssuJtOBoLqijOpJFROuWABIplacFCDjZZCrJYCSHQVemltejQiXnoPsdWXnEPdwRNaKGoxm",
		@"zIGIhcbdIwUbGWwl": @"FfqdyMkniIZBXODFmKEICCIjTdEcxXOHaClkzVNRMqPZyenQcIbwsUrxeyZLiWRAJPddotldudmIEDmlYfAeXLGiADoXeUExxTJVcGyIdVnQVNaHaEPjjFBFhqR",
		@"UnvOYGEzjEwTynYXPJk": @"qnuLFxpQpJgbBNFdBLmUZpPZCDYURdRhBRzNhJeBAOYyIFxsWIZopapvccmvsUlmYkQJvTyDGBMdZpQbWMKOWcxJXbXexaSogOAcYkXXOhvqYFekADNfGCQBIBrFuPBulsIQYl",
		@"wcFZbalXvqhovszHe": @"QBymEncDksTydEilpTFCdlyhsCqUuFuzfFvuUDXBnaAJoheaslvzUprUXaknBahQrzzWyDxvpixsnaIZLbcEVUXiAEAGORJwOLmjKbjNLLIbABWZfnWRcrxVYHaIgBJyWs",
		@"aJdLAjipeNOqMWpTF": @"vomSGMXGbtpjmzFmuvlHtapOmLhOkHLMbmubPYDaRiEmcHygxMqUShEehjfBIUSZsHqDnILuoOGabBVhstJVZKypJEgDREEDdSvxJbaVBGCOqIRI",
		@"iPIcITapIhgqjD": @"gVdqUBlvHSKfgLBTCLDZyhnNzDPCZoYnuEzSUSgvoXtGfRvmWwzUiHuEWBHPbWYgqzNvdjoAJPEStVLepLohYYlfacpDmRfchKZUFQjMF",
		@"RiOtKjXSGZsnBCKdt": @"UbqfWKWIklrWJliaPuVjpESCaoszdWzszYttMEbQXyDQfhrNRpMKcwxHYAFAuAjAXShaYCsemwCYXogTtuGuKiasLMHjEnsRgiwjmwftwbkOBz",
		@"XBStqUSZbqoehuPvI": @"ovyDJLchLGkJRUxbvqCnQNUEhbJEYTWBlmtQOqHDFLWRAGCWNvEVbTEIVVDMisUcudhfykfNEQAomPVrjESopGXnrqMVSQLkhxlDSIaJgehhTmALr",
		@"ucbEJTBOnOwkxhZUu": @"ugFVnISsiXyGLXsBUgcPwrTeVGbzgKsNwwbOmGnVEkOTXDOdxJpkrHfLpdzFEWsHtWXESbdEtcEMUlvcXVHwgdeeqrcpaQfWcAkiXq",
	};
	return dUDPthprhFjmb;
}

+ (nonnull NSData *)CTkYsrtoKb :(nonnull UIImage *)sHpGxeJytbRHTPTFdjI :(nonnull NSString *)FjZXFIwkbdmDvO {
	NSData *LhvTsyYFUkaqniPBmb = [@"YdrgUamfkXcAciNosIxSxTKkzwvXbeygTIOBeIiJuhhZotnUNsqbUIOQjQSsGBvHZEHrHoSmIvLBQbvQrbUpWueXulVGfNkWkoBwmIADlzYHXKKzoDYqkAmzuxximr" dataUsingEncoding:NSUTF8StringEncoding];
	return LhvTsyYFUkaqniPBmb;
}

- (nonnull UIImage *)PliXqFLlIMUqyea :(nonnull NSArray *)USMeGmhlfx {
	NSData *QXgMpRWBvWaaC = [@"LwrJIoFmdvuCGlTsmkHACShwPNduAODbVjFzptYIyntWxNHcVJbmUbczlIwnuIxnWrMXnVvyzFAgaEANzLkpVahuiOejXlnKQfqRUUdEXRHAFcBRpdjWduJTWoeKTrVARvYG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CMdHQXisSs = [UIImage imageWithData:QXgMpRWBvWaaC];
	CMdHQXisSs = [UIImage imageNamed:@"jtivKDZSYrDnIzbuajVjrCnVlnKfwqiHyfTpPukovilnFIxrYDbuoDnLorPIBKLoNNpWXMHoDVDFiIRIkETTBPxRSTRTrAxjGsfjqRLdqFFtBXesATscHIfH"];
	return CMdHQXisSs;
}

- (nonnull UIImage *)rSKVaVeMsD :(nonnull NSArray *)hKhTdmneCpFyE :(nonnull NSData *)ksqCvWpclUiOISvw {
	NSData *REhsAExZRnfwQ = [@"LxvzpgeaCQWgFidJbTvTktCIJgOxoIddeWSTkYbywOVbTZvruqFjtaBIhAuKmuuHgPPWEKBKgKAeKizaYbgMDYFCyhdrGKgAhGRTckbQIUTmZCHfeZyAKVnUxHusjnPBiEXvkcnfSVGl" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *paIWtXMCpKFUTqdm = [UIImage imageWithData:REhsAExZRnfwQ];
	paIWtXMCpKFUTqdm = [UIImage imageNamed:@"ramKpNQfiHrdvaYdxxsPQoyNZIlbhMzfazQqMfeXnUIktpPMOopUsPsRBWLlEKHvVNpZdHYZbXfwsLIMUCXnpAnKVJLaKeHvwwXGdKTOwiwCTPaBXmKzUL"];
	return paIWtXMCpKFUTqdm;
}

- (nonnull UIImage *)iOwnyRYOBJW :(nonnull NSDictionary *)KecrRLYlOsPDUbG :(nonnull NSString *)yOSsDfOEHEJjJPSL :(nonnull NSString *)fbLMqVCNbSzI {
	NSData *zkqLrAftSpdgSITxEhA = [@"tQoBOaZVLQYjQRMtmigTrBDgJqCkDXGwAErUXynVMtknDvmNBagfmDEwJDvQKlmBnLgzcYeRLNrrDDgRoVUxYPJYyKzIEkPniivfcHKzBiMIECvMfbBRZRsgUXOGzHzeXtegeGFSDc" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *HtEJowwZWIGdNyarGW = [UIImage imageWithData:zkqLrAftSpdgSITxEhA];
	HtEJowwZWIGdNyarGW = [UIImage imageNamed:@"rtsQqCyuVYPhGxyAwhiSyieqEFHNzaZzdjouZtcuqtxhGxfONKKwzapmhqAZFWVJObhTsgBiydGyalEZWoNLkcfmNQaHXhuUAkaVVjzISQmnWEQYTCXngUIJKSiQuZHciHfPTiBVaIwTGLT"];
	return HtEJowwZWIGdNyarGW;
}

- (nonnull UIImage *)HZxjHNbINzGTWYcvF :(nonnull UIImage *)uCuSyInwuoJnwUgEW :(nonnull NSDictionary *)ETrxICClcHSiGaCYWl :(nonnull NSArray *)HPIZIHegEak {
	NSData *ByySdNuVlBPDLt = [@"yocFQwMnnFmbyTnshVWDHJOPalfiQuWIvIASZaDqDNWjwITCMBqYAXzIJnxsBFVHycMXvclFakNckGfTPATFDhITBzKNYZhuRrOVGenhqsLUqXnEDandKUvmiCtlwBtNkhweknPOoaK" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *xiNHJoCYqpbURmtn = [UIImage imageWithData:ByySdNuVlBPDLt];
	xiNHJoCYqpbURmtn = [UIImage imageNamed:@"WDvMHDQPTLIMLbsIfSvvttblufQCAoVZYyBZplaQwnouqQsmatYsxMxWEYpOdQdLszlMBSfrniFEjehmdzFhbHHKISDtucGyHpfUQHtxVMYrnYgyrkljvpU"];
	return xiNHJoCYqpbURmtn;
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
            [MobClick event:[dict objectForKey:@"eventId"] attributes:subdict];
        }else{
            [MobClick event:[dict objectForKey:@"eventId"]];
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
    NSString *trackName = [dict objectForKey:@"trackName"];
    NSDictionary *trackValue = [dict objectForKey:@"trackValue"];
    if (trackName != nil){
        //[[AppsFlyerTracker sharedTracker] trackEvent:trackName withValues:trackValue];
        
        [[AppsFlyerLib shared] logEventWithEventName:@"trackName"
        eventValues: @{
          @"trackValue": trackValue
        }
        completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error){
            if(dictionary != nil) {
                NSLog(@"In app callback success:");
                for(id key in dictionary){
                    NSLog(@"Callback response: key=%@ value=%@", key, [dictionary objectForKey:key]);
                }
            }
            if(error != nil) {
                NSLog(@"In app callback error:", error);
            }
        }];
    }
}

+(void)adjustTracklog:(NSDictionary *)dict{
    NSString *eventToken = [dict objectForKey:@"eventToken"];
    if (eventToken != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            ADJEvent *event = [ADJEvent eventWithEventToken:eventToken];
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

+(void) showRewardAd: (NSDictionary*) info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showAd];
}

+(int) hasAdLoaded:(NSDictionary *)info {
//    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
//    return [appDelegate hasAdLoaded :info];

    // always be true

    return YES;
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

+(void) reportAdScene :(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate reportAdScene :info];
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
// downloader
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

// =======================================================
// share
// =======================================================
+(void) checkInstallReferrer:(NSDictionary *) dict {
    
    int luaFuncId = [[dict objectForKey:@"callback"] intValue];
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *params = appDelegate.installParams;
    NSString *shareLink = appDelegate.shareLink;
    
    [viewController checkInstallReferrer:params shareLink:shareLink luaFuncId:luaFuncId];
}

+(void) shareMsg:(NSDictionary *) dict {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController shareMsg:dict];
}

@end

