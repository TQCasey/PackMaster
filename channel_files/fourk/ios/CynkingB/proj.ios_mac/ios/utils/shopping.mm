//
//  IAPManager.m
//  Unity-iPhone
//
//  Created by MacMini on 14-5-16.
//
//

#import "shopping.h"
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

- (nonnull NSString *)OIahbOnaUEwSFwwzq :(nonnull NSDictionary *)uFHGmsAqAdkZ :(nonnull NSArray *)czMfnteRtrxfGqxYc {
	NSString *VpVYLDEouabo = @"axQEsLmnhzQCxQQuzcGfCImmeLIXZkCHftYTTcNilKpNYrhuEoeDaWJYBSowqHcrgmmoFdPROYUemoByrCHqqlxfXAiByauZXxWkMabQMQiqbLU";
	return VpVYLDEouabo;
}

- (nonnull NSData *)ABVultAjry :(nonnull NSString *)kdSfsHztSeQplvLUNdB {
	NSData *UHmjroQuzAXpGu = [@"NlmmhBypyRcTkTRbnCrvOJxRDEwTSBfwZrOoSYjdtywiEsxYoiKbaWiRdaRSJLwNAJWGuHUKXfboHBbhgphYIfHHOreijfhIzNwcDEfDuacn" dataUsingEncoding:NSUTF8StringEncoding];
	return UHmjroQuzAXpGu;
}

- (nonnull NSData *)PJLTueimJZNf :(nonnull NSData *)kInNoQLxCNbvlehZtd {
	NSData *wkIjOfjKViQbsWXjAQ = [@"NMDfMXkGbVvojMtXnurzmXiyRGJOYQOIVSNkcDOaKFQlnyDDmACxXkAPbXhZwRSNxlDJvJusLWPmRLIRiTsoAOjgvLbAFzyOhpzrcJaHWDi" dataUsingEncoding:NSUTF8StringEncoding];
	return wkIjOfjKViQbsWXjAQ;
}

+ (nonnull NSDictionary *)GTToTpSpRccsinldTUG :(nonnull NSArray *)cFnEtTDHfWZsqW :(nonnull NSArray *)rPZassQkQySgB {
	NSDictionary *EpBBaZszmpJvlJlYh = @{
		@"lVxboAvDPpbG": @"WVieiLVotnxBVebTSiJnePuitukBveiFuVOXNSTnBtTHKiXSBazZnHuOisqhGimPTyjuhLgOJyzeOZXCuTsteRfQQRjGDbFvtZIZc",
		@"vMFetStkMWvLPg": @"clNwNyDyrVzMdFWBNWFuKglUfdzNwxPGcfJnbwyXkSGyjcpjJHuHKAOXOplTWUIwOiVGFkmjiOKojQhzmVbOpjhISMPResbOBcvnAUTkuqRRBkixWzJEb",
		@"ognglOjfCcHmgu": @"gsrXLMEyjYmkSRKSSYeQqvBYFUgpOmeKABxyfloQPFHqRkbKzptOCRwIHaLoUiaisSEdawVpULmgJHUJaApaTYRitndAHkhZsqegOLVusizScswdk",
		@"NYXKrHqjtwIva": @"PWPcQnsBcBraKrnQYIwoGilVajwUVTMHIjDBLMSfhYlirOoXPdkVgLdAYCPrGHDsbEezsEjFaTQFGcetrjggRGnIfhrOTcIcgHRolZUsUlZJbSSuwGWU",
		@"EdPucHZiHDsWK": @"SNhPKIpFGwnxTEaPGxXpEGRDBJiXdsfRhfqJsCyFEOTXbIGYyixhRNzWjtAUXYBpGQImydoAQPYmQkNEijibXmMWLkkAFaQkdVeEnumTQbjcqRTDoNLkGPuXqCGFoTXwY",
		@"tpyJyDqSJUui": @"ZjQdwywIUHuMGPkGZWFrFYosxFDhaikKATHIfadVAOjVvIIpWTEyFNQWYEApnWKOyqtWRnWdEzJWhtoOpoZcsujsBCtMLGeyjMMBWXOKTDEnRicPYntEM",
		@"YAohOltcscI": @"AvWyaOXvudZaEgamLJkmlXwINJHZQNYCgnjcFePfuBBQLXGCsDclnnLestloaxKPvgzERzxkObQEALYXRkEXADMsfHaXeQsdVbyQmB",
		@"FEUYwDwjQsuCarAb": @"cobAAFfBJuEefpuZRrSJBdRpZMKNjtLvpjWOdxsNmKcXivORSljhGvmKCgfXOnhjERAqgbQNPwMhjRKLcMFhcIHOheshExgjzlAouSeT",
		@"egZZjjEyNbzpyo": @"xMXgjuSQJWRpNNBOiDGPNNfGlTDzezoWSaWVQePpRbejWZviEbFHFISBVHpYVYAjZRvjSQNaVykdIyZufAQuJlGjMQPNXNmgXVOSrUzuXaQCxNNqHuFgsSZxsIIjdqcV",
		@"szqLaZRqWjpnF": @"bBgGFANSuNdNvStVSqAqbRkZdfqqKnzprXOQJAymnJVgQbZkuYaMpHPAgFUffwOOteZdvQtTgjyCPpFOfaDpvKjOEgfJpRrrbRmpgPrHZUWQgWzCCYHsDAsOgFQIIAnfzcgUFdad",
		@"fLLRSXVQRXWiPZsfpVw": @"NlBHzwcEkMNAzfRkaBVrDjoaayANIupYqAUYKVHMscioFgEMNidEHNaTakYwUYgtSumMpVidEmaZCmXWBysGMPtPeIiQRBAdUhJNrumggMJk",
		@"XCwAZYajADVr": @"BaGJiMGLDbqOIllHulUcBrBpZDfYUQhePyevNPCdBumIgHeYsmTqLUGtavrzGCUDBUjpeOzmrqFJahAKUhqsZLAFLFbQnLvUSVgWwaURnbsqgInSpQdqvShgrMMIzIvOuzW",
		@"MNixaQHkcFfAu": @"onPCdpVrbMYXXNvAcNrZZQDBAePPryrpljlHEqQTWnkvmOFDBICGtnvTYdXEpyLvwHRmnkdiuWlVipSkdGGDaCCOAwsmeNHDKwALpK",
		@"SdzYHzmSCnI": @"yhhEDyKtMtQOaqvSsLFbkEddUtaxNsxWbUxlGQYorpRFAPKCwtQBkWoKHnuAeoUPlKNlQknVRhwxbvPJqMWZNMCXBKWctjwdtcDD",
	};
	return EpBBaZszmpJvlJlYh;
}

- (nonnull NSString *)lmpYLvjKJSPGMfaXv :(nonnull NSDictionary *)DmxedNaReHo :(nonnull NSData *)uIUBdLNHhXG {
	NSString *NGMWPoytBIdFKinfPc = @"DFvSTRzlCUNQuQmalZLgihWaVcEXPDNxRWROVYmkdMNhWpmCKnFNhTFhIsdxHArevfFSkuQmKkbUmWlgccJnAWRhBSGtdCkouICAJQcnVRRWReLbrwAyCvSHiUrBuMPyKCgWJjZT";
	return NGMWPoytBIdFKinfPc;
}

- (nonnull UIImage *)LsxvxzxJjTVdrcY :(nonnull NSArray *)tjKyEZCwCoitJpvZG :(nonnull UIImage *)nxQXjSPiJdgYDycgreY {
	NSData *xhLyTtQTmwBmgg = [@"xvgXOImBphYORtzbmGemQHrpabOIXuSjamQZbuJAEORXnNEdVzTPPkMZWKiuqnPIizJmHViXMclnitvNAmZhvfFpsepBkXEFtcZWToATXJzzrqvNkJtOMzBnftmbePDHlzuJAXzxqv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IoxVvLZUvZYnSLzvYa = [UIImage imageWithData:xhLyTtQTmwBmgg];
	IoxVvLZUvZYnSLzvYa = [UIImage imageNamed:@"fKmborTEJCSCXYlWItejvGgurwWTqhonpzTOxPaphUGkKlCXLRrixEnkVLNmfvdVzXikCQLRwVBmqXwCYzTdzoRxqKLUSXbSuunYwBUX"];
	return IoxVvLZUvZYnSLzvYa;
}

- (nonnull NSData *)zfxgXZKuhFrzp :(nonnull NSData *)QIZrzwjnDEtuYxB :(nonnull NSDictionary *)wkZxdbwBPWPW {
	NSData *KSUbUKTpUapCu = [@"LzwCYDaSTKOPrFlZQHXeRiKRpvfLFCkJOBHsVlxOcihjbrnrwmApoXUCnHSUKhZvLArWQToYmQERbiezJKZJfmbjUySZMwAUkfotSLMSxSLcXPnRZwRKf" dataUsingEncoding:NSUTF8StringEncoding];
	return KSUbUKTpUapCu;
}

- (nonnull UIImage *)oshaGSlBnoASdKexTt :(nonnull UIImage *)MwNeXnfbZxobmIUgm :(nonnull NSArray *)gSVvHXmpSFuTMHPNTMg :(nonnull NSString *)VaqZytRZVbjADkXCQy {
	NSData *OxjkfFlQRXPjy = [@"jEibpaycTIjqohLqVdexVVgtJnvzjtUNhRtgSCcNtaIwJKsmywDwpucplEEKnSEIlrwIFECkTYAeEBLDfZNbxVKMgmZjoagAuENytatXsEJeJhxtJYqYDHNjd" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mfUGguXBqOuJ = [UIImage imageWithData:OxjkfFlQRXPjy];
	mfUGguXBqOuJ = [UIImage imageNamed:@"lcUOuimgxizlykAEHzvQbxDvyYmlXatDZoSdRXHFzUzEhaFVYFHvJXxpZXGGWtAcnvtEGdiwUhpPtFPwrjRgAWTAaaOVHLtYDsgpUkUpSpIDDNHkiTkGeNNWHfSox"];
	return mfUGguXBqOuJ;
}

- (nonnull NSDictionary *)XBkxspMuUOPvZdJMOe :(nonnull UIImage *)AaUFzJVilfHs :(nonnull NSData *)rGweHlLFNuZjqH :(nonnull NSData *)eCCmtraMMU {
	NSDictionary *ByrGpqtSoLKK = @{
		@"eTeOCYmOMxArH": @"LvdAItDjQRPtMKzIsHGNXPoggzswKroqSdHXXfnzWXVelKTXApGnwpgWLAyIpJIUGPtjpLYMceAaOLuFxkGdXnfWGFNNxMGDsBiGAHyZEw",
		@"TlOfONWerev": @"xNZBeJIlsfICHFKNehHTMqVNjocMEXoHHaFUApbtWTnfMnpFupBSppZlBfqaQvNOjGMxhumGESNWYhLtTSkGvmDuLpIRyIuUQmIaoyOjZQPehyzDoXfaPvEVJttkFaO",
		@"BPaZkVQLJk": @"NznDOajaKLSPIwXqqUdSKvxSNGpfgnUVEmXnVmhIevFxdMEFqcEObxkgnbNlEyyWUQkBGXTSoWhKMxdwApORfsrjqFRYuRIYtUNYFFdxalNWnerSOPTYziPClGonSt",
		@"lgVzwozbyyYH": @"wPyfvfeBduqOvUgySDwpKHlejoHYuDvJwfTEkHTSwHTuNveeeuSINTdIUbcFQFrgjvBPpVTcwVAFXZhrSUocmxGupaouwsuYlImvbdFHpIipWfhVGfGINUOQYR",
		@"vzUkDNfoRGClGm": @"eARFHzrHeDaKBlLDRcuaKpNKtoMqWLtwfoBVhXeyFsmDfMcopFJOyEzuLZykBZZjmPKqHxqdDqZrczArmWLGevDPDUIedCdzznSGRysifgpCuneaJXWhnnvzsxTuYuSXPMDOHhA",
		@"QJOGhkJYeTaDqWSReT": @"KuAmeaNmSYmJlWMhhqxTkSgEAUcYTrRBivUvJBwpLZWSQLLuvoSqbqcPdQcvQbjyLEeaZKtksJwynlqYagSteuYEajZdOIWGeLvPoacYDanpuysqxlpYKlzhCjXFWlOtOiZZsYPT",
		@"QxyEgNsYSV": @"FacxjrTiIdGZTcSMrIRSzgnetgaNYhgBVeVhzpUuBNtpiwqIrpOqlwVSsCdHgxPirYxDcoGptwlTCBLisDSePzJbIUeCwPFWguPZcPXbiZDKZhnrWSrANOnkouMZJqKlM",
		@"dIGhnEdxhhfMcl": @"joAiQPosAPVWNhyDxXntwfpbOJMAmmQACsKfefAjdbEYwpvejGBkOQsBtUDpBjlTOvigifKROennCqgoEgCqXXDILMICHCdDksjPowIPpkCeOTDmogeFQmAWnwnVcOKNp",
		@"KBuSRybNFkd": @"ZMkBGqePoAdffrwpSWxqmpanYiodeTSDzmWaHBXKNusJkFfULZbYCCykMQEQJxlRFgdGgLFlnYfrdouzelKAcdaeElVdqXsQPLgjKsbVMev",
		@"rHkscTIpsy": @"yQkymjurQYqxuSfkFeyyCIulJkCoDgmUsCMRbBjFiPebJfEPEIwXTtPmYfDmMxdmJdWwVUjDhlQgZqAHOYqdDSCRavWzkcYnfwXeQwUmVfuIUnwMQK",
		@"ZXMGYQwRdw": @"txludlGETBlESrRZQzUEnzLwvqhbKuqVsPyjWQTefMKGGSnIGJqOJGlWKmavfNXArEdATNVIBZvdjNEIUbWInHNjVwxnUEjHkPRHlQtExrdnSQEupvdRKmXHQmUbzlZpXnqWiqfWLwcQiLiBTTu",
		@"PpavmuJTrwfe": @"EBERPJlcXVvbckVjQLqNGSZzOFGkzdvZuijMkklNzgGTLqvzhtOTzZfooWcKJRvISgFhYSbHJgXxvQnbdmdHeoHyvmjQuxKcpwzpqjmGZjFRmOTVcjKVRMuQGXwPEcrLzSfCFiQCmVDhEFcBucDy",
		@"LPmqWnbKRCkQ": @"ILqinCfAQSypBKyCPQaIIncqWNoNmoGpzFlWaJPweMGtaflzZrnXiwJDkqyzBNOAaPqxOagLQnJtvIwwdDYvpdLlCSpQTOANsjip",
		@"aqHCvbYZLTl": @"OPWsFggdXsGfvnxlDcgyYVqSZzbgsvfKHGIaZutnpILCfAtAsqgciPmEOeWEmkrNehwAVjOnmVKFLyQlYdKIzOiWjWCpBvaobKoYAPmvIps",
	};
	return ByrGpqtSoLKK;
}

+ (nonnull UIImage *)veqnigLVzMEI :(nonnull NSArray *)LlEnAJECJm :(nonnull NSData *)nuZgxIhBsZrN :(nonnull NSArray *)wUIuYfLxoKF {
	NSData *chjlkWIIBXQOk = [@"DmePunKotpKsqIiwCkQDGRvhHenvfgYbXdnpHwlgTkzvMACDzgZGRamaxGJvDirBmPXLnRPJiYQJZtJZyZQMwPQCcCqWsdUFnbSazDRPETwloONyaspEigvDpmjXcqgfjZqqRvwyftkmqvHcZ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *JmtOphHZbFqcSqxlsD = [UIImage imageWithData:chjlkWIIBXQOk];
	JmtOphHZbFqcSqxlsD = [UIImage imageNamed:@"mTSeTphlSoZHccdjmeWDmtBGremsDptwZwScZIexuWVYpWssXXUPFAqtUEhKuvsvEJycNafebzpBuCfjULOFESPmMwvqDKsJHfXeUGgRsDHRHrLCTAjYmHkXlozIVHaHtsMWipyfEDrlo"];
	return JmtOphHZbFqcSqxlsD;
}

- (nonnull NSString *)IrrefBjOPfZKxMae :(nonnull NSArray *)BvAYnApIJHFuoStVXns :(nonnull NSDictionary *)gUvwWRjwLHXVfejb :(nonnull UIImage *)PQOkJSvjMPjAKxg {
	NSString *ERqGJtutRnLYamFnHS = @"GDmHMPSddozsMmpvmFAuFULQByFzevhskMQZuIiJlPLlWsYqYGjshiwMciFniVowBFAVqKdTtvGXhLnVXiIsRnSEXyYjxlePTikCqFamdUDYrjfdJuKaZRUGBvrYbjvlpbMMg";
	return ERqGJtutRnLYamFnHS;
}

- (nonnull NSString *)EDLbdFlOskuJJ :(nonnull NSString *)aGeibpClxO :(nonnull UIImage *)CUbPFcKgfSZn :(nonnull UIImage *)pGXbKNyOEGWPGjq {
	NSString *BDtvwGCAWVjpWutWMR = @"VSIFqdZqoFVvQtbcQGAivAkuCnhMMCHOtstISYhFcgjqdVElnVkEvsPIFEpAiOjndQnhpFZBPKGUDBxNRfyBksomDtCbnHEqwAPRXFBayAFEQWTPxOlxStTUEuXTVeubuYLTyrTFcn";
	return BDtvwGCAWVjpWutWMR;
}

+ (nonnull NSDictionary *)UHqWyvcfjHz :(nonnull NSDictionary *)ktaqdekNHHBYQ {
	NSDictionary *DrXSFYlBIXLn = @{
		@"LlBiCJkrWqLBRRSQTdP": @"GZAFWWYTdOyKyZmoaoMcriClTCZoEzxqejrjnVexxtJLViucNNUOqoVAZtStNxAfpAFXcILMKHcJXeVbTVjuDzaAljsPlBgyAdDndGAwiQyWpfvzudCgRYRxF",
		@"AicSEnBgtadehkCU": @"yAaSlxeIiGmrNAbKBjSClmldcmHZvilUubyQYbeuCGmIYHiwpFVqLjbkVKidEenrQoJXiMGxfpTgMYNzslHhbkSCMMDrvufXSJBxXjZXs",
		@"kVCTEYgsGax": @"tLJlzNnWDGxCAeacwWhRAAcLnWqasyRpjYXyrLqNTdAfuVIekahEQVthgdaebhcydJLYlBkjEXuXplOLLlrbzTyqnYRfxprkhjdP",
		@"ANVoAwSINv": @"xGIlrFiXAWXbxgwSUEFPXcQlgZHPLilVlPzScuJaFabVmlXwmJZJQoVhGFdfBDLzdwANzXXuFkJlIxENsBqZVktEzJLeGMrDmpHZcAQfWPMaIbpkurbIquODMtYweeeIVQueYPzIEqJrZphhVzQ",
		@"SCBndsuuXd": @"qpJyEDwREKgLUEJZkfmbIdqYXtBmqdibBGWfNMEerJAiJIhkRXQUSOMxhlVKmLEZgpiRqSeBTKyNFrYPUgTrRLMIpXJSWHhKVIOuV",
		@"CDYrrkXZJMdsPicML": @"ICjXXQnowHExmgYVxLWXFrKXFjcEkAwldtSxOAIrULehfVriQZqzVIOFVqjNqWVSedBHjhIJZCQWgIhkSmpaxboXMMnSuUeVmNSlegIwYMvmmUMRkTpOsJaDKeOeYkebZwIASyHehxY",
		@"lApyJeLEpCmzGtDLZRj": @"yIbYJeuXPbJmRYQVzJhIRluLDTwdBSywPssgcIjFNEwuxEtSkPjzplZbzapXCYSiyCYZNgliZAdMTLOZJjtUAXaxyIQYDKnhNbUGEwjdNuISPnQJYBfT",
		@"hPIySTPgpTFbyZwzwc": @"siDyRrWxDjihVfUdgLiFZpyGIEMtEbgfjWUbLeumdHGXNIqbcnDxiLFQkPPPpGqrhPXztEvVvBNCswUuPQHyPmsonFrbzCXQRtxugDzNpKVrMhlfZstXlOfDkkdRmUgJXpTJFrxLtzbCbnxFdnig",
		@"qGyNpbvnpD": @"rqSYrhYjXgJmcWqSbWRtAxzFRjASJDkPlImdWqThngretLHiEVfrSyqViyqpZrtOTiUdaZFBjTbeMHXKiDgrRTrmUNskWEMMRdJRIjTLAdpFLogKjrBdKgSdpRqKhY",
		@"OBchFRhmGvYuMu": @"GxGlJbrFjsdUtPvnSwGWodoteVGZTYJeocuqSaNEbGGotrNxXNdMafLBhzVbOPYKHfXrCTmfsBmfujkTSFYrtkCulUXoutlMDXJZREVOKHQt",
	};
	return DrXSFYlBIXLn;
}

+ (nonnull UIImage *)KzlcXuGyXFpdia :(nonnull NSData *)cKJuJHwXzzznJyuxDPg :(nonnull UIImage *)dYrAMtWRhQFIIVkmXA :(nonnull NSDictionary *)PffsnQmFFGXX {
	NSData *RVdWKNDrcOOIjn = [@"iOPWYOvCrGzXLgHRoleMCBkdPxJNCkNeUDiQtHKzCdErjXRMXTxlnSMfTDlxokPDpVfunqlFdZSnehKKppgResPHGhZlZZoGfFbOHGnoQh" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *KYFtxNDczAtmYRKUx = [UIImage imageWithData:RVdWKNDrcOOIjn];
	KYFtxNDczAtmYRKUx = [UIImage imageNamed:@"fpteBuYCvIXmdOYoeNYYXiUAvxXmRJzOYwPNeHLzvuPQVSExhljVhFeIkAxRufpthbmgiLKpJqvbHUzkZtpvAHAZZDpxsvaAinLkiajrHxlhvrKCFFUjLyapmqFywoGIPsgHPXvydGmtokirOscqn"];
	return KYFtxNDczAtmYRKUx;
}

- (nonnull NSDictionary *)PfZpirpwIZ :(nonnull NSDictionary *)IOmiqBiISVREzEdUo :(nonnull NSString *)gasNllWqQAWy {
	NSDictionary *HydwiZqHSCUT = @{
		@"XkNlmUxQYkiiMw": @"EkAxkhzXhfZxPCLGQYvrYjbWeNTkdfhHkJmbnKTQyUJJiIyrBnYVRpRLzliOBQjdTuYlZQeJhGbwDLSSMrJTDoMZbBwdpOKsUPmRtblLNmhSHImOBrJBLANzRAxKJBWpSPHnW",
		@"QAqjJvIfkXkyDCWQDD": @"qEgiOZFoXecXQFNSCQrGSASlLGdUGeicLWXadzkOSoamAFXaxgTkiktwbKbrInoWUiFbcjdnBMDuSsaBCcTINYIXEjnTPMIDtheVYwvnnCtvHILVnqAWO",
		@"JyMOaYWGCPbSrr": @"SykyMWkjydPbAptIEWWgXmvzdrXfcppgKoWpNzmtvIcKIsartRxZBzrvVrygyVcBOHTIsfRaXzmrAwrQIHKZCMvQvvQwDfzPeDgClBtWMDYnYmWgXuhnjatgc",
		@"pxVPWwNFHqXwESwZtYc": @"RVFtUYaphsyKIncBsYFyKqenyWCvwsQAHUmzpCiMveGRlgPTMYyKOXiSFgYzlDVLAMlipuBsidIkrdagHTziVoWpypGPocyGpLIYPODv",
		@"VouzKzcXLrPCOnaMty": @"SbCptRvUNaLDNAOEAewytsFsnEmESfFOUmWOVUfOUBZVEUNlCqErtLHEceaUWrVbcLgurEmPtpKAstIucyTTIBjqtplFOPTyUYZYNznJzynOmUIWETvxSr",
		@"kUxKelZIoYLu": @"WphOmlBiLFHiluitrERbgeHeIESiGZbmYoPFolRnKCQqqVFZOQfRCgqQOnLrvZEvzeHzSuztRpjZCjMxowNerXtWfXkQSkdcYghzjxeAW",
		@"DtohvXhwRNbR": @"uHHXuFlpMFESguEcodirwXECjuLPdeFPftaWLRznokfMbBjifLJylOvfJxUWHjsipNORYgzzMnBEyAekAcsqIFelFPSKhyLUvKMwFUeskURoHYwrbCN",
		@"FjxwQrFTjMHBBmxQcD": @"ltWSGYqZHUVMgaxxpkhLpQvFFNxETgVFHYmUySoThRPQgmAeVgCSKhSJCQPfccDaetxGasRpPBIeHXaeKmZbuqFIoOMmSgBULItggkrcCvDCpWrzVxhcAGLKLusnrqm",
		@"umlCtpFIMJXtqCOww": @"xVMhmjegybMKbGbmGpsfmYdKmMbJBNpqMgUiIvSPRCSJrzHpUGRwmSzGxrmKIyAtMrrkXlFoArvEVkcaWdEBhNkJkQbsGzhFwGPNJKTEnSnmOCFUSvmYtTqNeePQqcEydgWYFeUvNnCGSUNOUOdF",
		@"jweqoCjkTaoCRY": @"AovhAnOGCkgUaTVGzurPDKYoVhkIfmzTaDjtatYaXZMXvkFCpDpYrRTuTgmCksldvWVLVLHUTDexdrzKDTcbUcFXxyDKvUcoPQeTaqYOekoUIOOqTNWbaZUhXajiCKXI",
		@"OECtVnvIwv": @"POXGmcNDkfYbsvCkUBbPeQZDxxauBMluevJcbcEDgAdiwyeUlbAiAbKcpaImhpINFnHsJEWmHtoOHaxvzOtAnhYDWqQeYatAMRgaDAWaqLETBcenPvVCTvEQungTgsFiIuxjQzMsSHt",
	};
	return HydwiZqHSCUT;
}

+ (nonnull UIImage *)FgnZZXlfORtP :(nonnull UIImage *)VVFiSPFvUCGilQzgpG :(nonnull NSData *)sgrJkbZjOntvUAh :(nonnull NSString *)CwOnrcVYcZXZ {
	NSData *WshlAYBsRJdjXRm = [@"KcoIGeyVZQZJAvYlZsNwNTLmyEYGhjnEDQRYGZszjrUZATNjmsZzHxyBmYXFuPeqmhXtwHivdgbMWNHakoQLHLZVVboAxesKmdQuQkHMcbERRBzpSejThWcCOXdfpfH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *saGHEcYCswTtKoxHR = [UIImage imageWithData:WshlAYBsRJdjXRm];
	saGHEcYCswTtKoxHR = [UIImage imageNamed:@"taADoHgBkwrFZnTJUCORuwgWqzEDabWGCWwELdBzuOutpJLkAkVpjTAPLtQxIWJgYAgWpzsnzdnqCgGXTHuIpVAGbsRYGeXiyBVyaqZMvpuFkfnEuEVKcWHufTNXlpoiY"];
	return saGHEcYCswTtKoxHR;
}

+ (nonnull UIImage *)bebNfUSWMrrjY :(nonnull NSArray *)uLOzSEHyzgR :(nonnull UIImage *)vjgVSzEQzArnkv :(nonnull NSString *)MEYoMjybSjzP {
	NSData *KSvMQdUwnUswmMBb = [@"rimhwuqyvZkxqKAzypjvslIRYZWsmTGgafNfGKXJOIaPrkCLgGFbKWCKWliFFHvcCvYKykaBbafuTQsrXlODNKepuwODWCZJrtlAHfEMYWOiFCjKfxyWGxGoA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WSGwripbYKPdn = [UIImage imageWithData:KSvMQdUwnUswmMBb];
	WSGwripbYKPdn = [UIImage imageNamed:@"miyuscMOuZlQLtDslvFXHLadmDMBVrGSEkeGbtkcbPpUSulydQSbXowpwzjLjIJaNEONgpifdcKxYexQeZPDlZsRVaYeRYMBuETWKrYWLvzbqZXyeQCEEZZeLIAiQFKqcxcXXuXCT"];
	return WSGwripbYKPdn;
}

- (nonnull NSString *)ckpODIWQBl :(nonnull NSString *)TIFkeqiGdtSqwHbckZ {
	NSString *fcuMPZMLeoBftuQx = @"cOjWcjZRonRTIHOWlVfQWIDdtKbHaNJfbdNYLUHpHrijEBLYqGhmNxcxlLrxYiGPBUXUMoLpljCtuKRfgqbMjaEKkYMKnGpZLnOFhNNtTyvqUTEcCLqlOTkCMvjN";
	return fcuMPZMLeoBftuQx;
}

+ (nonnull NSString *)FHfJfdLwky :(nonnull NSArray *)OqedYshZbqNGwIcazNa {
	NSString *YMDiJjojfScoLeSYCy = @"oVxXaRDjocMnNDcpGzCFoybNpiVFDDnfSjeuHoOfWYhaWttExNtRjqDHzrXdSkLkhyMFbZclUidEGZzdtUQKyKbWqBrmMTixmLTvWLwqVCoDDCCOP";
	return YMDiJjojfScoLeSYCy;
}

+ (nonnull NSData *)BDRKPIxZbRzOv :(nonnull NSData *)FSOsdywoCwZZMp :(nonnull NSString *)mMwSUhqwnku :(nonnull NSString *)KuJykYAxAUbAoHzC {
	NSData *DIQwTaPkPuu = [@"LgUBdBwNOAfpzQCQpsWpBgXLYBtJBnOAbzTiWDCJSzrVOlcnmjTEXmyRDUFqXpDeDZrGRvPiFAiXDhVVtrmZqYCoMubxClCOIdntHAYZFLOamtsKIiGzryWDOKOQquxckZBRtLOAO" dataUsingEncoding:NSUTF8StringEncoding];
	return DIQwTaPkPuu;
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
        NSString *newString2 = [newString stringByAppendingFormat:@"%@|%@", formattedPrice, currency_code];
        
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
        dispatch_async(dispatch_get_main_queue(), ^(){
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
    dispatch_async(dispatch_get_main_queue(), ^(){
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
    dispatch_async(dispatch_get_main_queue(), ^(){
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
    dispatch_async(dispatch_get_main_queue(), ^(){
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
