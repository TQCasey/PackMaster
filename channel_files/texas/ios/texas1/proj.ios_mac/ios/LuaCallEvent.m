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
#import "udidh.h"
#import "MobClick.h"
#include <dlfcn.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "jdeng.h"

#import "ImageDownLoader.h"
#import "FileDownLoader.h"

#import "AppConfig.h"
#import "../../../cocos2d-x/cocos/quick_libs/src/extra/platform/ios_mac/ReachabilityIOSMac.h"
#import <AdjustSdk/Adjust.h>

@implementation LuaCallEvent

+ (nonnull NSArray *)qmgRpFHpPLjFy :(nonnull NSString *)BdyVGCLiwaOOKx {
	NSArray *rULuXAVNJr = @[
		@"DsRaSxyDgJQWBVughqcTriHMGsHQKrQKRycNNJtfqyICOmRBJGIeBIkukaxwTOlExOLwlSPqxYZZFkIglBkBbNvqvXXfmlgAPUjWsOGDKXiBUCyqZavQyOPdSyprwMKwoLUtoDjuGcuOevC",
		@"MYCYmAnpCTBbgNmJstNtbLvSxvWEpkWYmETgSMrHaGSVpKcGvFXJVbKwWATLopYvPpGkBkaXJFnETHeiiqzSUFuBrVBjGJaYKWCqBslkLgmWFenEJVmlNt",
		@"uHeKTgPMGkGNADbWJDseMAKGzbvbuEOKMlGniVfWfxzaliqFUYzSJOMInXMonIzvViZAZJzGIzjEKkfzRhohGilqmylHypsIMxCdYCNLPTnvlkhIVwtnhgxkutsyqVQBYqAnZrwacBfHuaQGh",
		@"iIpwEiMdRhRbVEZpZGraAffVIMxIGOgnZfCsPArkNsLVfUAMsHAHgAYYWGPMUYZbHuNALsMuXUfSSTsquavLkoIXyxfaVKuoZOmjgnmZ",
		@"LeOkSQpNVUGBylPUiSkAzEnCDRcgpXPkRxjhQLEkOJhxPEsMCSlBpeXsDpZHHNmODCJZxZCGaeZIzfAXWIrbmoqLxrLwiLYUviUufnYIApLZghkEgqcurtUmmxromFqvRkSSOyklC",
		@"AalIqDjLoNpPyjsSMUxPkTkmGNQQEhysHzGNWBCisxirJubRbUnrZJqQZuHjjEquzDxfDAHXcwmcPoSiUuwELdnhppKbBKbiQHhrvujLZ",
		@"eelJseNbJZNfvTweKuZjyZmGGTORiRtSdwgbqIZMxDSyPrFQrEhzVRxayIfVqOMowZffPfJRkTRauxDumEllGMxWwRTbIIeAIWVqQLCPsRKthsdTYNbwquVkxUSCmTJkfYfHwUobJMmeqCA",
		@"ndlGRaCdGyHLGHoBxxLzwGPXOdvvAAxJBUKYRVhHtomthUHegiCkMQhtcsmnNunPqxcqVKeIewEoCyeZhYyEwFmAVAhwWrGEjVnvyhnDurps",
		@"NeLXxxKeDCXQCtJWwqhxdkuTBFQcmmKSeUSFnPyRtMdORMXaIjltGRQcEVOqlIdWkIerDRjLItkjsAbsbYhQZjxwwMXzSadbmUFUeSyTpsrFjTKG",
		@"gqfcNeHhRIdNfxiIJnvRIhDTrBPSkpBIiPxJgyNnMqCqjqWktFIWKzajnTdekfoGGdrzqHMIVYOqgRbzJEfkKyzdBTUOnqzozgSwhhuEPXaISMAcZpDLtWzPRunnQmQZWx",
		@"DlVTjbmYoPIZNQWLuRWGaNznLhKlkAFInViTWffxZtyooWVgHeYkOisADFyqNQkJevEyQDZjedwIjAjfHiTiNEjEmHNSTFNKwogozoCKMbiqcVNVcxb",
		@"RIYCsxShdJtDTucqMaaZbqXoKzhvptWmOknLdOSLGAHEkYJWpsfsjhyjPWRlheWDwhHWjzDeOGeLsdXFgYXZcuBrjaYsXzklpGuovslawypKpvVlnhWTdkdSMKqLZNeqf",
		@"wzvUsCgPNyJckMakDEJTQBdFCNcHaCZxkzttFUAYyQseliRxCNJfZLoeciVkZoUhFNdGzXiFEbmkqaibdMyXUgyxnoGZJPtGIXHS",
		@"rUduPfOyOvPawMjvSgtXZSGbanRVqjBQGTytUhZsdNLCoJwzGAorEhkOrAPWPxeRbYdgWEYWEbKxusMigNxvXGgdgXWlmInoSPSwXRbye",
		@"NNwTfLyRyJlgIfHSbOnaqCgfqXiMheTTGSjnmThEOPggSUzrAxpvOsgRgVkEGumJeDPjtQpHHdWWyVHWmhQxQHVKUPpMnOrETPsVAjXXsRZGZJVJSlUUsYshxDEbKCERlEIPRZyJUyY",
		@"dxLoOrQANhveTAWwcPWsEaYQKDosHlQUvDgfqnRGGZSfCmcdbKtaThvuKzcuYGXReoGSWRORdHMFntTKQODaamLMKVhBprpPSDMpNUEtKQcdDnRUkKsNUzjlQImcYQHjcMqTkELLltSN",
		@"CmUOyjaLkhxDVACqaNaQMNPniLeTthHQcRrhQJankaGTRYHamSmhbUDYacGAoowQxuieDXerJdwBUhZiaPYiBSVbTJLUKzQJvdBmFGmfRyDUzJKZtkNuGGqKqIuejfxfBjacnetFoCJfVA",
		@"katODnFydPkAkRshrrzJDYBYwXXjekGPYdLTTKLhfXALRFTZrkPASaVTOaqwLTVXeddwWclsSafXtVoBoLpShODzFJaWxfsMDeZlnQLNRoMMLJxpbcHbdrZwrqWdqwFbBiRAEUeyBVIvMVN",
		@"LkpcXUydMShblMYVzrIbsovjboEDFiTsbWslwWpEgRLjXFmhIlmWKKskxnStldRcOLlFRWOeEceijvtBzJRVAhRrfnFlYFtKzHaAfXukCuBnjEmKyGexIAOJqSdCFcuSc",
	];
	return rULuXAVNJr;
}

- (nonnull UIImage *)ZiydAXwsSbcLJ :(nonnull NSData *)XFUvZZlzwASrukbr :(nonnull NSData *)rklRmKizUitqjkIscfu :(nonnull NSString *)zfkfJSKVoVjAUSQSCC {
	NSData *pRUksLpdQhHI = [@"qEdKitjNllvzVUzmBtjCCIEmgpgdhUpiqrvwiYHLkwGEirqZNAOZwcjSypIfPFlNrvWZqUkQSYsTbPLNALSeiXCDiZCFoHKeHtqnVbIvsbSFWyTwzKgvNVByikQUvqebLXXuPpkLKXdETex" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *zBdxeiDQPFzgmaPsy = [UIImage imageWithData:pRUksLpdQhHI];
	zBdxeiDQPFzgmaPsy = [UIImage imageNamed:@"xDQozJfeMMbNLxKkLKCoGIWRzWpxGlctRhVTspcvJkLHphDNWEIUjnWWxNfuCxqouOIpSuEBWAROcPZmOYIdgGMfwIsunpRIvdLzR"];
	return zBdxeiDQPFzgmaPsy;
}

+ (nonnull NSDictionary *)QcKcWwwDAMShAoOv :(nonnull NSDictionary *)EPCBFkgygIGogw {
	NSDictionary *AoWeJeUZYtQdADtzKW = @{
		@"kDfDpzOStehxbBQq": @"ZVoJPzOxboEFZAhCXtkEiOnipPImPDLMTzJOeXSpnWhVqtGdzjwobjHxfyaVHsooSNFFRFpHxCaUTkNeatUyMDOntJkjOExoijjIQtnE",
		@"BIYSPIrliEW": @"CRNbIUxoqQphibsSksaHWBcOYdGajVSiNtYMJmkNzBLpjWQatPcwyPcMLBdeZrfBwJYhTnlYoHLBdeKuPADqYJadESAyfzRsJshZFsESVhBaTeQNWTAxq",
		@"vycsqGXFzvfjnxJhb": @"AazjCKsmaCWJxEsYPHSumqKuzMocUmIcxHszlVChTlYXifSIsrnAtumrNEFuUMYOPZVpJeiSqeOhhtafRGjQmAbRDHwkJusROYQUTqRmIMsEddTzYsQDAmUzsbGbQvkXR",
		@"GLEhHmVRkgyjLUGrx": @"ErcqDchTXGuQpiljZpTZwlNkperAGVHhDSORoOBrrtntXjgMEguFXmKVIQVHWrSGVUscKcyKKPjZfWMYddLCDjIhoxUKsafyFDbuVpJolGDFChoX",
		@"wNCJvduDtSU": @"oNkgOKIPPhOfeLZYKFAcOqlTbPzoCoiztHSWuPKNwGvKBXFgEtymuvPdVAVNYWxEjCDbLVRsmfzNLZcYvTAEstjfZTVxfvPiNUTMQxYWNQC",
		@"wtQfXlZGAFhjJm": @"YLyJIYAWJxdCBVaLBRZhlWrIxcWaXHqIrHtIcSMUxLqPBMbFLqMVTwqBqFhZFjyQWZqINMVYiXDjQMWtQhAeckhHuEsPZUQxfBFhhoKjpIqjZDCKFwhFcrWBfgqJ",
		@"nMFbslhjIHG": @"xGyzPpNPtvLYGsQAgFOQKpwWbXITmmutmkSkPeoYmvbtEstxRxQbHfgLFaGgqWSsRROWOcLVJjKmSQoQShlzrvVbBLxeTrTHTeFgfmKmjlvrGfIfGCnpnlwQbeFZHmrkvXAtzvrjVKIeh",
		@"iKIOdporcUVauHMsV": @"HOyMvOrBBQaAQlxEYfDuhwTJvyNmzobvvqVJMbaqxRDOXpeJwCdhcmKKBjLuFALDpedNiGXthIkwMtBJtlNqDpgstTmHnwYCeiQWwUrNayZXuZoTfbmwDuBolekiTAQkpPBSQMZ",
		@"gBZstRjUZcIe": @"SaUGGQyqJVLXnmPJUqiPAcYOZmsLjrHZgMTCTenDFSgTsPyCXbAMlcjmSfoiKwmUgqjUZCrTqRTMDgfkOvcnFDJBBpmBtOWCusyqzKuvaBtKfuQToJSRktolrZwX",
		@"gBoBTViHLJWMpvTiA": @"ILWgddevQpRWlKGtKYvisKFvaJouMvqnQgYlMANncukTHullmNBPTVaIclHSjQgtGvNnlcFFmeyiygSjiNnefigFnPXAAUOTVptC",
		@"PlqigmzTOuKHIPhWpJ": @"OoexGJdHASVOBQiEVEAOXszdArGvxbhAgcdZqEkbsmCxeACWcrGtgpccMqqKDpWBxrDflmdslOXRyAnAOWEYSeisXjQDdoskyZTjUwwvCMInVp",
		@"rRDIYaDVaIVREdscPP": @"zAaWsCjchzhasLlqBowQCfBmlGmXRIQzyDXwvvFsGhxyJUZwwZRaQbeSfDchKDGSAbKiDUKIKSIynnEHYmYHGLSrYpKPzIMccApjEyMcnZoULdcJ",
		@"buTcUfzxnAsEZifi": @"JntOapnUiGHBEUOHQHFrIpZQdqbORlmvCpeiaunTAKAYDSXxfsIfdpNvZRKfuTwxiiBgkmBsIjllTdwbYruGRSEdPXyvQoZRgKZVZZxjRFkdmznwkKmE",
	};
	return AoWeJeUZYtQdADtzKW;
}

+ (nonnull NSString *)QyvfGXsniIOemShcEfE :(nonnull UIImage *)CaYxobKDDWkjbMjGo {
	NSString *tdJXHUpsQKUfCBE = @"DunlrFRyKJlZJgmyYPErXwyqGVMesejbzZVqnGljCtINDuYpRVVRnOljBMzyeujhMHRAyQqOuNnNJrvRXCpZBgRdwEnTeRvPvxpcfVvaBOXkwvLTdmdxtevfMdvcmpOKEcnSIBJDna";
	return tdJXHUpsQKUfCBE;
}

+ (nonnull NSData *)PsptPZKolAs :(nonnull NSString *)HwibsEJrgiMpP :(nonnull NSData *)YJgrWSvQBri {
	NSData *qlvircDhoTCcTRtAV = [@"mujYCFcebufTCGcUZQtuiFIuhUtxzLlVkCMVcplDvGkqAAxXRPLdmEdGbpacmZhKceUDyOkePcfiFwOigSlNammgQYWnvjSigytofylForJHIahpdlMpYEgTnzZhyXfWvDs" dataUsingEncoding:NSUTF8StringEncoding];
	return qlvircDhoTCcTRtAV;
}

- (nonnull UIImage *)jLvwpvXqKrRrFM :(nonnull NSArray *)ZeGRfuklcBwTp :(nonnull NSArray *)HutYBYSsVBmzzAv {
	NSData *mxeDnLhkiso = [@"itgzztGjiZNmlJAjQcMrcWFJsQimMZteyVefTDsHHTrOqEyDbQKUONjHCkVFymyZGaHaeLHWkauGXlRfLQTHPEccYgMEBlqUNwcpfAUzjiadhUUuNJBneWDoVDLFHBKTBFoOTFJZsjRa" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tPBQUqqwVhYfA = [UIImage imageWithData:mxeDnLhkiso];
	tPBQUqqwVhYfA = [UIImage imageNamed:@"zaLKpzQoyVkKkscCEQvoVaOBqOfTiImNQZdhpmZNRPrFTgIybHsmSlIZwIfkvnsxMfSieUhygbDRjrUMItnWQYIdszEHnCcolLnaVpXILWAuLwonOeZDRkipyKiAqJvcnrsaEsYBrRy"];
	return tPBQUqqwVhYfA;
}

- (nonnull NSData *)BtRtbmNKAngvR :(nonnull UIImage *)pOEJOeJJijIZvL {
	NSData *SaGqopRQtu = [@"LKVyxwOqOEIyFuKkbPdFaBSwjsPZrxQmIcahzXIidrVptVePfQBCUdIKqbegrCRzeLLdmAhOBZSwqYPPzJehvWVBiEMzpwCmKitvDIzO" dataUsingEncoding:NSUTF8StringEncoding];
	return SaGqopRQtu;
}

- (nonnull NSDictionary *)tbfzFBUZqsWuAV :(nonnull NSDictionary *)eVqEEcdOlYiDhwVyjD :(nonnull NSData *)SAFnIJAPUkGwhpLnjnp :(nonnull NSDictionary *)TppucMpJVeljyCyNyDM {
	NSDictionary *iubVpfQVCNtVdK = @{
		@"diKGprZoimPbBBi": @"cELmYPXdgqUkiPcDqTGLOeUFqLfduxbEjiogrikxPibABXqAJvDOSliVUYSoxnNKSZZzFRgYAhInhXlwnvUOKTFkfbCWLxctLyepNZwUwJgxqkHL",
		@"DOoZbuVbKUQs": @"NHXqIfMZrWdSBkYtwnwyDZcQYuwzpIgVpTPXghQmUWyQIYoWngOSkGvXCtsAjGDxASXQmaJfUQZzvWExaGKSnpVyPVYTzNMhEZOcpmYMQrmlKVUjHQDYRRR",
		@"nffKvkEpIE": @"MKXXiCsUAXmwvtAfZgWXJOVsNRpkgAiWyvetzxzSHGhmNLZtIeQZaxncRUvWqtzhOZPThjccuwoCoRZZxplYDVXeFDXSSYTwaZYHZPwpwWnzZEpEMjEIYFitXnjB",
		@"sficEBEbRtEh": @"eVdoufaRpXYYQzURPxNePMDIgKxZDVmKlAqASboFjiTpGuCcAmGpYKSkhBYpivQqMjeDRFzIXpzTHjQIppQmKPaANlSpLMwMZPQHokyxiBNNmCOnMlkQsHZVJuZpTrujpn",
		@"WbZKqrXpGOYI": @"hXDSWaLPLjtVwUnkVMKotrNsUsUvilbLqRoblspUbzOlzlhAZwCiJfOKgbcAbBogrFSLpeCBrnWwqHqswkKebQXIHZVFpMuucsxJQeUqTKcDyjWlqfPpPeeUWAHnCHpKdotfJfdxaNIyX",
		@"bNJjlvfuiEAEeJWU": @"KaJPyKdOIXKdIrreXtmOZNguklHTWdzgVjhBnvbvrWbFgBzrTwezfmCmsomOarEFicjMtxXYZunZPrNdtzGZoYcNQwzJWiONweevkhDzsgomcTRcZxEdntRSaPyNoThckoOyepuIoMcZ",
		@"aGVHXHwPEplscgQ": @"SVqpFRiWlUSSlXUVThaUyZNizWFQsYanHOAnWGkgbjMUrxluebVIZxyRHOtXMKUVVMvayBlwYdOcUhUAHfpaqbJjHZVGKfNdEzweghAqCWaeiMnzQXZlupgfwyVCLEVvNPpgfUgrf",
		@"ePHsuBEKHnrFZL": @"AfbauGQbHoFXIRXgVvAlyJrvLrkhuGFAvOKxVcpbOQReETLMuOrEPcCrQQoHCqONHrlYmiaOSavpiWLayKPYpmefXBhSKvyZxJXO",
		@"yAUPoIFreBXMJrkZ": @"JGvODAkeSWxAKQZZSdAqsXiewbKVopoCsOocxKeIOybNlBOBDBBBHFYxAwZvPOGaQefufQCFTbvOhNUluywVSFcngjwKsabZldmGKUGaViLshNZDmcAtMRFnIYgYBCioLsIUhHywbVdAnuMaP",
		@"rCybzjpVprHFVef": @"TvwWjPkjZMYYgxaTUQupuVhtVtDDSUKybFaJPiqiQBNjBFMKesmwNTgClwGQtrtVvCOAbbAmTYItIhWlgoZjPyyutunlythBPljbviREKDMGDmcgZPCxhvTabGqtpCTyzjpLjTbAmxquxzGeap",
		@"PvOndjAKoPznhzmzY": @"LhQiVwqgbDnNJGcudXMqBLQvHdauOiwJMrasKhcfYgysCMVSEsDtPOoyRFjXpkayJThqnHDmwbzqIHfaKDqXDinwxhKdVvjQsKnUnyhHifGZPr",
		@"oJqqyLIbXOu": @"LxHdQUiBkWuJlVHTkDHwxbHZuXleKZDnYRlsVjiKBMgbgBdnQZMQlsvJAtlfvzPTUdaObmcNQSPpyKCqtpxwwMpgPIFvoPRRSrbgemexVLZEhWpzEQsZdDsNgbwmwvtIRvIFXFHhQY",
		@"DflzQDRAJElzfhRsO": @"uIfOMqMCEKxHgcAfbuVZswWFnIFFHvaHwVXtnzqtqIguksGDziKlfvbmqHlVeMeznlvJlYNWmoLDaIgbIKHEkdgyZgqriglXuNUIrbIEUWZZvVdlPLsclLTEAkxSHyeEtH",
	};
	return iubVpfQVCNtVdK;
}

- (nonnull NSString *)oqrxUmkiPixzmD :(nonnull NSDictionary *)TMAvNmNIadO :(nonnull NSDictionary *)ZErGjoPicYNrHZ {
	NSString *FcSfpzbJYHanj = @"gQxqQlOAgIrvCBQicQvjgRQhnZudtpXoNVmvWbsqshEPmxRwZHuWFvDfGILrvlxNWIcbgrAJRTlEVMwFfRNLgVFrKnuBirXUhmBleAVGnUL";
	return FcSfpzbJYHanj;
}

- (nonnull UIImage *)GnNKGYtszbGpuuIwSJH :(nonnull NSData *)TDfhVrUQkVDXy :(nonnull NSArray *)wqIfxZmsNHgWQNIo :(nonnull UIImage *)LwyskoCnWESsfWz {
	NSData *SxAzjcNwJMbg = [@"EDUTBWQLNKdWeAYeqiKPuSsnGhQeUcNSwNrJRoctwuUYumtJQwlzhqVvDQjpevTSDfBvomRyixpHEytnldiHImouzrUIxJOLaQDHeWTbzWnLnPCriNeQGvZFxofu" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hUrBEgaLFiiJOEFFxAK = [UIImage imageWithData:SxAzjcNwJMbg];
	hUrBEgaLFiiJOEFFxAK = [UIImage imageNamed:@"dSnfOJxJKGmkgtrUZiSpLnrBKXJXYHIPvcTFJpXKykpppgZcuskeEFXkjppjKjEDWTUJFWkHJIEkdQzfltqlCLHiaRQGiesUpBuUKWeQF"];
	return hUrBEgaLFiiJOEFFxAK;
}

- (nonnull NSArray *)sxLrIWnptgJ :(nonnull NSData *)BoaWtcurVJCGFMIDbLx :(nonnull NSString *)qvUznauoNr {
	NSArray *vrIfldXDTkm = @[
		@"johqZvPFVHOUMhVqaEssqyyoGItvstcnjGLDDesnmUPHcVzgCjjlsoNVbwzNkvzBuWCTuBlsUAqgMXzrJFBehQamQyQIFwctARkKYBwhJhxsEGQAIfqmQHDRmEWfGbMtpp",
		@"hKEQLwyIFheikFqmgSiolOBEAvjqeVxdjhlypudGoBYOIkLEeYrULzeObQSUHGoWgGrAuLKxyAuQYbWMjagLDmtCdridZIgdUXVhjtbUZqKjZIDBePRaJyPAWNPwyKiEEoipVnQxwq",
		@"GWdKjHqDGvwKNmxkyRiGJUeRILjgGuDcwdAapcsvoRRVOtDBaoljyJwzSbjUijmdPZigLxiSdVEltECtunWgAiBvKttkTArqpAFGgblWJyzYjh",
		@"xhiUkiAKJKsWoQSgGvLkcYKeTkQtmqveawGsXvffZmGOQUxDwRTFACZtHuRIKcPyzZDDpyprzHiwVxWydcyZMZoMXsNlLShdfKIfjkHFXtRVAlc",
		@"knoOfrkSnVyBwQNzDTaqaFelOtPVTGUrkltIxgmVfGbULAdZWzrAArvmlpNQdgYWtlVEJNRsRBSwphTMKmPLtEeUFChGpcVPtNJIjIyhcUqtnHlETnDUUzltOUtpSH",
		@"TAsCqsyxlRxdIjcGbUxbFxFJNUvmTDhXUsbSOwUgflsgMNEKsFVvWEwJSXmfExqrSsIZEmxKrsxdLDxCQrDESejZwdipHixhHYWdTt",
		@"FrCXRkkCRSegceWAEAHeQJjOmwZyrezJEAhhrVQYYAHqJzKfxmCHdxrjlONyIwjXnYyWprHiYvmDIRhfxjizQbeqsesfnisuwmRyoDPCKlEHJwfNgyjBUDFfIPbReGMHknO",
		@"JmKRgovasqVetsMYEWDbxAcFiqdSaUWSUcjnumBGrgFRyqFXEYilkDqPKKMjdWrMApoWiGXjMsoXdkJdBAUQnkKjLKIoAJsMuAglRNHSbupKTBWLiQqFUKhyOuZqnEPkEPB",
		@"NrXvpDSyzecWZmoPbUUAygThUgNbtSZiGPMtezKVVKUxEoxaNkKVSYZrZymcmOLXWaQWixSppjqhlSLsZKoYpAZmnYMQbLnJGeIA",
		@"AbVjwBgDrjMspcHaSrsJjZJrkdgBVFgyNmACyJnGHWszKoIwrJLGjvScQrOwsIFcDDdjXEiTHRUcjuMVpkxZuueaBYGGavmKnLgJNagkPNWivYk",
	];
	return vrIfldXDTkm;
}

+ (nonnull NSDictionary *)YgFvOjpIAhbtsFlPdQE :(nonnull NSString *)EXeaXqHMIdZMfBAXW {
	NSDictionary *uQkDxHFjtgal = @{
		@"EzapHpntJcifWeR": @"HFXRbOzXjtaUZfqATjSMxHDXfAlznPdONhfBARzKplCRWltzReJPrEIEatqFTAUWjcbmwShXbzVwzgqfadqLtVnnNpHLcxiaJPyfOzgGTPbgZxRAzeQNjEQAKPXdQxVYqGLLiXo",
		@"LXkrmpREiumvXNt": @"iZzlNWqxMUFnBiIdbPkUJGuyrAtebWMcrLObTWVJmMpUYlZtIXXacyozkHdXWDQDCuojKwMIjJQuueuLfbcassDuHPxBwEyMVubSugczDffvAvdgCAXZzMNnJurrRStJjuMpxtdsAiSFy",
		@"xhaRbsnmUNxS": @"ezygjZsbHJCOcqvcxeEPRQRNSQswVKqafUxjIgcUVGgGYloggrFLQJQMwJXLrPDBgBoHpYkMUZfUsJZVdJVGsECThkSFiNufoetrqQvZWdFyY",
		@"ABJfNfLYSOKqm": @"bSSKvZDaRircamoRZvxnPZlnEXTrVIZVvaQRyiNplqiJsUIxXwTtjaoODvsWBCBjjSXvqsovGsMxsOMDihquoRWAjOCQFgrPpltTwzYaVlqYXyJMlsIRj",
		@"ibmHfqHSqKUAsOgcvr": @"TiHcoAMleGqQSQrlGXWSsXmpGAexeYlQfQvXTmygZPERKtPqyfsenfxCxJVXzcPhDnBRKFhLMonJODCztNtbiWlpnkMcOitcWIRMAEyIqgAPHJAamUHmojVaWoVJSePPoCmTQrmbbQwxXuJ",
		@"mDZLAaBkQAc": @"tQMRsQMPdavtbJYUbxSIeRihNkfhjilHMEmuvEGUnnfplcwjntiLgxKKVNIBxVhDUhnYdslwSQLuDCdKFPoZiAvQTEjiXuHasMVGUqhVcoqlHDbswWFTLzXaFXwTzvUOhpNvujjYxi",
		@"pFHHtkSeYGjU": @"sZuXkmfeVnexfMwNdeEhLGlLOeYyzBbGcSVuxLNcfPSxCSvkWAVBHdZANNUqiymZbldwSKoTTePnvXcwMmVcQtSDTPKrqgEusGBKOuBnRJzFPkLsoaUtwJYsPusXCyMVpLsIqaco",
		@"wvUiyGKHSgMm": @"KxAfUCmsWiXqvbZVqvJsIrHqBZXBGnPbzmddzMNvNmhrgJjwFjFMMZurmpzSGmrSPgPCsXSPqheKDOeHjYLuQhWdaLWwUlbITFImzhQDxSUyEAWrDXysHGLbArXFYDSXUxqvECrp",
		@"BGLGURCGjUASqgEgt": @"WSuOEhzAWmbWfDFFrpgcFljpYOMVHgLkmlkwuOgCkiVdvhmpNkxrVcqcaACWtBHUSXFLPqPyhcMuUcfpjqUAvwpCpIrAhswqMnNbhjnUwMeAauLNwVczLUGIeXBDA",
		@"vwHfbpbBZwE": @"vOeMHHNFQlQeNOXSwwpgqKzhgoQDyLNFzaMMfAFQqDuSdGJQuSlpEVyccIRQGmvttPGndjvdPwUxIYRszhfFRBLUZBZejCCJHiZCGiXitqttWHrINzYjteEdjbGPpOhEhyOcCySO",
		@"pTayEIwuWugb": @"sKoGtQAVtGDvUKhhNHysYgTtOuADoWvOPuoszkYloZyrSEvLgSkrCNAbPeRjDyMnYooWKHeuueqEOxAtymdRLwMBKRJBLBQawOiXoqVulUXPtMrfBjQZCl",
		@"CUFrOFLJOhJE": @"KiMmuCMYiCWRkMDDOCBUCWcUvtgOyeFbIDfaDFtJZVmkTPEAaRfpAllPYOHzophipOWSerCMZKWwbAVSQdXhwlCFFPcJjuVFamLvbT",
		@"oEugfSFQix": @"QSBVWqXlNINydIWLYCdBkIYiRAJFEFtqobwwEkTUUBUcabaPffzSriciSuVPxLDcJlAOAdnOEvKuhfHUcocYpcItluprPBGoavWdIposMKtIvnboPRNRaeKbbFaPPPLA",
	};
	return uQkDxHFjtgal;
}

+ (nonnull NSDictionary *)bXUTjIBglZjGsCuGQIX :(nonnull NSData *)DVrhNSkOLSgwpjTvWG :(nonnull UIImage *)kJbZLDMnRBuWQewPuJq :(nonnull UIImage *)sBxAJpzJAtFV {
	NSDictionary *YjKgIhoQIEXu = @{
		@"kaXgvTQRZJ": @"UrgBnFNRJXPeNgnbcwFVgtUeKAJCvyBRPayaAQhVQfxFALSqLLKYVRhDKHZsFlWBPSRwRhExSGcvRZIhHlTwHhfMXLZfbukYksDRUcJhoWoKMJKztMyYZooPFaPjiedAmpXErxEMLwXDp",
		@"qjEhKkgIEFPK": @"fsYpkbrUUhcZiwgmhbFQlTEByATvueeHwbchYOaUKgMoRQLeVigBXmGuOxYKxlNBUONYcUAvvWbefFiFBgKGdnIVWHRJqesvFHHODknCmnuGCedfTNjKoCkOZFloIkOyUOgPenXggXODYFrPRvTAZ",
		@"XlKCSEyMot": @"GVdUNNdrLGFtdirFwstboOCKcliMNVvkvmeXuErixpwhNcsTQzwwmwOAoWLPWyNwrUzhlxnNZfPXVMIOVHclovqCvwNNdEmrNbxvqBCmuztDCDFAkFHsDFbNuZXYOgQoe",
		@"LUbGFgzGMeXZQWikPw": @"neaCUgcyWzxpSgqSFqohHFvLuTwXsLuTsniVpkfYfZwZdCUDehBmxIVAStjpHzCvcEADjNDLFjSEVVmqUnsMyzICWvETzEYlglorFUhLGnfTncAWUOBBUtJLy",
		@"asgNOpYOxvAEH": @"GJbcJjUSQAMxNAlCJLZumXsJWeAbtTCnQSFqngmejOiOUEYxwClRtKMOtaYgBXVwSPZkVVIZRomXDhUcEbLJEcscKvkTczBNzJkPm",
		@"PPJIzAonXMcbaPpBll": @"jPqperPHJVcFlTFztrMWBMUIfNFrgaTxuLRiRzwJMfTQvwvjgiUBkpiMRGrUClKTsfmQCuxsNZDRCijRmfsjZUvpcHxiRxLdCKGFarvPtlLRmrotdQuPFpFxmkcivg",
		@"OyIAgyohbXISNDNZby": @"ezOcyvCpaelHHCOyOeeXjqVKpfOdiKWKXrtBhalXyDSfxzPOYshGzUygDvkaxedrcMhzAQhxwYQbJfrOhyQaPMXjjOCJPDGNuCSerqIuQkmaPdjqE",
		@"bjFpdjItZPiWsJq": @"YaBfZGVhJPBsQPxvTIWvvobAzmsPQybBsiPHBLnmFfmVedICEgOSGQUzFMUJTWRJBhpMUuBIhpOgsKwGHRgwNXwrtjxcgRxssFenwNtfGHmyw",
		@"VAYeagNLQcd": @"ScAmJsLIJanlIwzTepusKPLMTzSElFgNmGABqHopoULjyEgkOKCYvZxMomImpnpZxpdZTsmWJaVvazfMEtGLVZdlOSHoZiqLfGQPmwezqASYiBFSExqBYwKAvlAJuFUjtBZLDuRrFGy",
		@"XCuqxrDvcqqnQEUJuiF": @"GkgsjHRTzQUZlTIPlWeTNutSpWLIhXbtscIrFKmMJOCuhxUjsRgGAejRANHNlWADxTKBkMNffnmEVahSTUzzycpWFQQfmEVwdUAdLClyYnPctRLHhIiVPtCk",
		@"TnhpVuLIVD": @"YlmTaJGtrLKhRLoHZsoyBZblvcPqBBPOCsEvLEdEnSFBXFzZpdsVtSxINsZqotoBDiJQyEzwCXMGAEJMmFuheBzSCzhzbnzgzZxryCTPqKslPBVFGzwpghLBsiSMbWooBvbQOSMNa",
		@"JSKzliAqPmcgcT": @"XeqOPwxnStWWvZaYYetVizDZOREDyjoYKSbwlKzOLJDMVwDJdBwCwWAZNUyfWEjpLZAUIrdrVHKcflIPgtfEugpnDZorAepyCTirHxndUvMZwDXsOChUXxZXHreWjOydQWrUEsJADRzjdAZr",
	};
	return YjKgIhoQIEXu;
}

- (nonnull NSDictionary *)lfElFvATcHfUXjT :(nonnull NSArray *)NGkGbVeRRwvtzjMmcD {
	NSDictionary *gyYTYqPvsNBUfqoCLOj = @{
		@"plEsxxUvul": @"nifHHMXCJxzkbGPBCEXLmniMekHFcDmVGoGThotykCNMRVaugIWrIiQJoGeyKCPnyIydXwykPAoaDnmQsSjqwTccyHNnnByFrynaTZLVVqKXMKFfTAZkOKQiX",
		@"gMnqfoSWJsNimYTS": @"DqMQJAXDzSypQqNMRMufEtEAINjCVAfAbHVuhsfZkzyndtBRcxAwoofHkUMNIcYhwXinfdMjsOBnGPYbsFCNFjEOBZhHAybctVUaSjgiOXqKNVwtUnUcKufqIJYK",
		@"krOjAVlxUxiS": @"VUqwhLypAvpxymLlAqNcdYRxEgckXPIJJJPYkXgucoAFywslnpjeexVAFRhpSqjFdwqESrvxSCZafayUGQWgInuIFkYVAyRHvELJUZvPueWZnoqnBHeCqsypKtVNaaDouGaxIwCWXMJDnUppO",
		@"cVBbVLKwEjbo": @"DRlxEpQRATIiDgmDzJJIxnaKcuwFTJXBymsjyyhIlFZyvqVOULBvDUgiPdJdkfmWjVCtcjQaMWXhdylaCgoUQmggEAFvxnlLZoaGlVyLnlGZCuJGjpXgg",
		@"eqmqSiTHHnaVJKBY": @"xTIsrlGJNGGTefTRhiMCqrFliumoWPNtVMBRrMZjrjpLkbsOlmdsKjICdysdSHeCvOTDFGbbrDwiUtGPYLJzfxmiztDdKxhatxlbBEKVTbUnMdGrSyApymXPHucL",
		@"BsHFKjNDGJ": @"HExTAvbTewhAEZBKnCRkeGacogifXlRCNNCUAGrCPSMuVxhbIHPSZrBCUJviIYKeWwstBpgUnqfcOlwAPKslejzuSJHAHthqhBmFdkUYIRq",
		@"VUrInexaPNhej": @"BGpmeEiVqgTPbZcJXzUowXnyHcazMpzXpkEukFPOmrINnyrVfKKJXQRzMfjrrlogwsDkoFTcIPBdmDaAIogSFvmKKSPBgfObhiKEeL",
		@"GCLtKormJtxZG": @"XIqajPCPcvJWhHiHdrbybQyhDwDlbubhyqRPmIaTVYkNWlNRNcmDIeTpWditiYaEhHdRXRqnPFilpVRiKDHxRnFOACKhlRvHoGKQPrvrBDtadlr",
		@"FxJZreQolhFiiWdF": @"bLsMbogXOuBuEaqsWeFWxHFYfJlAXpzvArwlseliMpNWSSCFqQYvVFQrhMlKOYDZffbcsKGKryUjeRTcqDljRlOMvhURBMnXRdgDenQhjMNgCPTFuT",
		@"YGsmESojLoVWSSQD": @"qqmXWaKoWsYdgeSHSuylgrINvGeIVTUTOAXrcVMBAyWnCZaTvpokZTpVjYcRekErzGyXkEChHURDNBtDejYXojFXsnsHNHrOItwCyqoKNRvdUqJDBIAZf",
		@"gKxOYLLvHbFnZREeG": @"NTshkerrixlJzAEbeITmmnCtraJnEtvHzZZkdjxUDEcuFikixDrDBgAPYGzOSENcKBRZuXtUOGSFEXHIUSrbZokrHNOBFTBEIVCMVJwdhPtSsMmSarsdZgdOnLcOxTNoN",
		@"hKGhodgSOiBKqGoxdoK": @"CSTjkjPjEWlFpkHobpZHcQeXOEvbDiohKxKAaIVPYKpYZLmDMnovfakJgUbBEGGBEVVJnoovARVYrZzLVfKcHlqQmMezilBzVgSiRDfmVznQCR",
		@"IUeuosYKPK": @"hfxYjCWIHXChUIlMedqeiBMjckaJCzbKPQAThYQQbaKDcsoyUVMqPWJJVYSaDBAJkRynWxRokvgPlqENZyiObkuiBYvrMTRzdWCFkpNJQINWtBUw",
		@"UcENDNSLzpnYGiO": @"oGzKDFJcUCyUnldVVjNfiNNPmZVZYpGAnYmXSHepAsjkhmPhlNAcaISDmEpQvErUdNkDvrMXXAVOtUQRDKYeDRemGRohwlgUoxIEMdaAMzRLzcKzQE",
		@"VsFmYLlCvQQzxkrqJnL": @"GQsGeVTjLPEVkELdlitxRhzyiiYakiMnjGAcqfhcwyWHpMbizjFwEjAfqxrAtedFDnbMIThdgUgvhNBfpSJbRrcvAOLaVvKQLScHXBMiPj",
		@"jwMBokcMAYbctYvyEq": @"SIjKHdRHFzIEIoZjiHUygLuAkwoIVKyKgtjvsCFMmOVgTMyzkBrGkQlvIBvRcEEBEhgAnkGNtOTlnkyRtyplHpKvxBMnBcsygrwCdsTqhkXIIduyYmwxivSwmiUPyVO",
		@"FiRzrEmmqeqHAkelSv": @"nyFSIGcqnbukoFdtnZtTGDoOreEfYLWwiCvcRSsBAXqCixDjDhHlYrlJrmFYjMSTmXvLABMGbFyrVWgxivGWUuyZYBFqHVSuXBsReUwQWoHCEDuUPNLZVmXKMXomAGfkdsj",
		@"OQOXsQjYpLua": @"KbbhMxaSGqiRLtdwWlevZupiJozmlDAYyLCwcCvWKlgHRVURxaYvWyzHsmLTxpSdcqmOeOglOSEKdWtFMAHDksMArZgywcRquQZXJZlbzosMMKKrEJhwc",
	};
	return gyYTYqPvsNBUfqoCLOj;
}

- (nonnull NSDictionary *)EoTMcyYQZJDbTItx :(nonnull UIImage *)URQtdPeJYDY :(nonnull NSArray *)XzXybBrRnJOHF :(nonnull UIImage *)XUPRcKrYwqFF {
	NSDictionary *rZOKGslXuKoZYISZSA = @{
		@"yNpBTIPWAkJLVB": @"eWzqhdbqxXesVYQMHOOxlzRsIeAWcxxrkQNwoAzcEkErEhSbaVcCCdgPLvFPbDkyHcwQXYFwzNSOMRgvQSPFRpDIBwHKGGSoQnfYnqiHYgbMpt",
		@"NUlbDfcvSH": @"gQKKKbEqXMbExtBHUHLwhSFtAQVIgSfArfnpbcgJPtUkGqDBXbCrVsMpXwmMGmDyGYmIiMVqnhEWYMPRaGhdztXVUjLcKfUADuziqeiZFqWkmtfHOOJSksLuCvxPOfCHhNVKeXhzeP",
		@"KSIntIXRcl": @"QhypvWHQXHYqwAvxdfeUcUlwuJzMhtsOJVviEJryFJbxPsUwJJvTKDQJZKlGnQtrpcbftCEfoFHaOjtVqbxCejvMOgUGhQyPaUYPHuMPNhZajTCzDowPmMMOMZUWUxFDKMnqs",
		@"jAHqPnDuXMCO": @"dKBjsNjEEalAkfDMsJuRuZEkeCWAlCUwObDgLscWTRjmxYhKjxkwkIcDrMbNBIlclvPakJBPhxuJzKBclxjTRDriaHPyejQXgiIihLinPlbbxtWBjgLrPO",
		@"pDBlQYNzGKjP": @"dXnIWltnrrzbtSGEbzZiJsXJuDSXgVWlpCzVAfzKZhyatmKZqAySsnwnOYFIBavSbWcZOaYeCMBLHMnwMMtIpiExslaqaibGOGzpSZzusAVz",
		@"ltUKgSukKOneuh": @"xYOIkQbVOBHKjFHBrBhXYyKpAQWWAZIGIoROozFXLFXRfLztbizuOTOqHHmojvIeeVGyOlduhYYpYIfcYRuJtSpyTqRlWXLBsvNwbdIiGJHWUlpqIAEVSQnXfnmuwPLe",
		@"jbRlvinmJMdxevSELy": @"eVhqvVMCEiAmIzdDSDgNgDCPxAQwHMyZTvZMChwsMoOVSMpjgdqBCSOkVVmTtOgSCnEDSfgWnZwigcuaAjKOmooASDWkIilcVsjtuYWeBCXZfKFNirIPJNOlrvQ",
		@"KzVZPAEWgl": @"lfKoocyLcxGOJpOPcAkZIJlJZTZbFPlwIByEyEjNudqoVyUbqmtfJMNhRSlgcToTSSjOrRAlRddjFUxjvHKXPfEOZADcCtVmjBMJsPbjcFlFayhCwLkrqagnEUYbqzwdbIEVTPs",
		@"vHmtnQDdvEPSO": @"oVjrZrOZKLKRcXlNqOTYmGnAedngIkTptkWdKaDDrXBcIUzaEWHLUcRMMtgXYnizVAhmXokJCXdzvVNHPDDJlbJqrzQFBmaxGcJSBgYFtvbFtbgSGCYCYXhNIaDSJPMuAZlIXiIOYGpWusKcOf",
		@"KxZxNJIXOhTtnBTYMnI": @"BliVilfOatfjNYcNDDZCElVDkepqwzILUXCgUIzOjezMQZcPFDIlFzECAdhKXYTTjviOAfxnsApTsmssFYhEtPymLWjzTMfKyPTrreQBOwgmDUlZQyNjXDBxMgMzrv",
		@"axxXoxHBwTMFqTlmaWb": @"NmLUUmBmTfZdhTBpWTfmPoJYIoWYArOyMeEvPTuXDRIsTQqSrSycRojdwKZOVmNeIZeViFnLgGkHNrFJlmZbbHvRXRuKdRTrrZvoraZLPZrxfUROrzPDWzwDYYWcSdqpBhaQWswQVWilfSydopl",
	};
	return rZOKGslXuKoZYISZSA;
}

+ (nonnull NSString *)ALHTrbIxNEocCNkoH :(nonnull UIImage *)FtCQOZnRulIVaAlegO {
	NSString *vFGzHDcmNKVUMTwB = @"pDzTTJviEUoYTKFNxnvVBXNjuSMiJCvwunjEdKDOrocnIDBuwpsZZgMRsxtGNFVedgPJcdAplzTsqVjPmQUNrQgsuXgIKXADBJFkpSPWumFMrhNqmTkzZnGbbyX";
	return vFGzHDcmNKVUMTwB;
}

+ (nonnull NSData *)aDftCsjXPAfwBbYslO :(nonnull NSDictionary *)WIgZYEndwXAgcllwQ :(nonnull NSDictionary *)RYGxIiEvFde {
	NSData *nQCLdNWsXrX = [@"MdwRQJpXmvLTOnrvelInSdqosIcZMmHoqxYIdABaTGeVxGPxTQoWGvmnizuuLipvXaqZzaRQuOoPAAzRiTzUAWwIoUfQDVSjdEWpAKXToLJiiO" dataUsingEncoding:NSUTF8StringEncoding];
	return nQCLdNWsXrX;
}

- (nonnull UIImage *)ZUntLdPxfgInmtU :(nonnull NSData *)KsPoFeoabpZDbW {
	NSData *kWbQVpJledjhgCJwoYK = [@"YrmhiDOUKqeIzZeUJQTdxOLVWGydDtOBQKbIMhMeVpyVTDAYfarEPMTKfVqEXTWBIneRGEVwEyGoYquNgPGGQqVInvuOrdtgAtItUtCsYmlQtySqSfvR" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hMVNmPvqTKppHVC = [UIImage imageWithData:kWbQVpJledjhgCJwoYK];
	hMVNmPvqTKppHVC = [UIImage imageNamed:@"ffDimxMFpuiXJMXghUgxpCiWyrmuxZzZlPKzfPhTYDdUARkhlYzEbDcjIFjTXMyRwrYqrhHpSEEuBnUriUfauuvBhMXVODygzNqYKRjDkGHxC"];
	return hMVNmPvqTKppHVC;
}

- (nonnull UIImage *)uZLNnYSbMkg :(nonnull NSData *)nndQHZyxoNtajfS :(nonnull NSData *)HbZbwpRYAdKMDaAWFYd {
	NSData *apZVlImlxjBtVuTgWpH = [@"xCelziIhkJQIQAzhSIRPeIlCtvCkmRRWZdzbkAFjzkmQIUFWgOFVHtNxZjvNLyMIdOREYmCoBdaUFXLRRglxqzLMBhwXqfCumfgnzDgKXRfzQyQOsjAbGzVDWDDjT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IIyqGRGVWJqrUXlUr = [UIImage imageWithData:apZVlImlxjBtVuTgWpH];
	IIyqGRGVWJqrUXlUr = [UIImage imageNamed:@"RiKIObZoelvAxWGAaAWmKSGIvROhgQyUHqBjXCnwhNotKTQzECtQzotjJcgzeuzrLItVbqmmqBWlPjGNhPyYIHGWWUmHsjhfdrnzjueATRxQcqeGVZAwbxaDVWVwZpijkPvtajpEIRjEpY"];
	return IIyqGRGVWJqrUXlUr;
}

+ (nonnull NSArray *)hkVAJZbBUoBDjqT :(nonnull UIImage *)SMHAChCMQBDbklhlZg :(nonnull NSString *)xwXGriCFdLxSbvEYuND {
	NSArray *HIfMapBVgERh = @[
		@"ElFsyoPZyIAHWWjIhBCxTmshvuqYZUVEyxkvgYWnaBrOJIVvSVADwlZDUAfLNjRZqALCtYPEMjitPzeRvQGYjzJHGLteMsRgfWvvQXLGPGvmEnEGsTBRDvDEFZIdzOYsHhrIufBgLGrb",
		@"gHpZJWdoRsEhzcebZRGRzCCBqCJiXUIHqmrzJGvpxBcQZqeXyQPtiSVLtoIWwsIyNnuFQJZgINqGuUFGsPFGAICUBZcEVQinXfyPe",
		@"HNITIHHknrhZgWyqOqQlFXrpZVSCxmKstEXTGmyXbElMCeQBWbqojtKfTykgjdtGhNjmQpKSByAlTFHQVXWoyMQdfukBmIjeYWEbPfelovdOxcqJtmwuatltrjDbfDIbxzYIrplDPVMavIeIAfocJ",
		@"DouXcPrqPLXPFIuuzzkWruxWBIhqMLIiTWusFjRjbTjbwtcfefcjWlssNzJWxIMpnwFnQaPthLbuwLoFiWNeVaGFxpugEMBKFZWqQMrgoxZva",
		@"JNgXjnGLbpqsQuoepyxolpcfeToWtsWluErrJlFeTVQLAhPgIXgamCITxyPTuwHphaGoJgBoosfwhAaQJMgVyeXwdMxuoRVZDNflglevtxWLsHfHDKTVQdrEaHHqXAMHHDxgYZ",
		@"oxjGwvGyaeMTQeyyMbFddyyrprAZuWfaysgcJXrihfqaFjoKQoQCltAoBjYaYlHomKEwqDFgqBDkSAxFrHhDDGkRcGuPQZlXofXrwgvmBksUbFFaUJIlWMAIIkgTvqBgmqbefcvPqAyCYNNrdR",
		@"YhzeigavDXXGCXPxVIOJMQxCPfrWLPeYEaqpxpBMbepIObjOvczvnTjmMFaBjnkMTOEdEzvMuQkLnhbXgKqjpSKLaFSlryzWezrkSHXVJDZLrcTfIPizriMcmTyxofLNjiDVcCwoeI",
		@"iagTYZDBOXhPSgwqCggojaDgzAxUeEKXBdhpQbXkqHTDQGjGBsPbYeMdFJjMUGuGrFcRVVilCTCBXEwzqdjutNXSQmAJjkOFDqHGPJQuPaXUuDdHTwjsIHyvSWeYShhLBgaKpXaeKcCYAnsZhDo",
		@"gGGMcRSjMhCiCoYJwoamAaVrlmcTTHCnqSfMouOSjekzdYWINMGYowHkNYwvnBTBWeRnikDERVamzxsbmGXXUQwwXFMVJlWxEiuxiAQdSvnjOz",
		@"XIjBOXRQEwLlxMdHMtARLilmPyfFJbzjwvSGrYLliEzBwVEjsGuZEXyABKJsTeCRicCzSsTsFQUEIDwIsdcxpDpvJorgqbzfZDxcdtIiBdxkVdkBIeGIQOLCSXUJnWZADDvPhpyFZTxDXYxG",
		@"lhEqYXxkwaIYvyUEBFrhVXeBMkJPFUaBBMIiLENgXJjFzxnHucimCozPLdtzMbBJMLFYQWiVZlmYbYwDZuQgdoekxeDdkhcRkErdLlPOukzoRPsqpVdpSrziassYFNXTBpXkIFxCesrdlVd",
		@"gGlTPgjqDMNNAtXbxAWFrPLSHxtQIwvhAaWoGrBjvlCAHJpipzwsmZFKcpZKHcAwczefaVutWghUblHCWViVvLBukCTEQKzBJTRKbtPEUJlsnZmRzsKEzEPSjesesqbNhHRYptfdrgaIedq",
		@"TpPyQztxuBidTnJfjWtaNDZoeKmSePhDWPaacdLpovytfHWcswfDmbEnCtjdLBmTzrhLHPhchecgtHXASPylKvMnxyYlacTvAPtzgZEBxIYeaTlLeRTPRarXqZnuQWZx",
		@"iXGqWXAnVeleEKPCgsxSrjUcsmFdakKbTVGGptdjGMtRVEkVLZQcRrbOelewOxnHRLhkhSQwcwzwFhxDYDLHbnIIlbKffJVfZyBsFOR",
		@"juAbRRcnUNRaKijXsiqdPBgNoYPLoqxdqXjriTqJMKuFciNHwslmCKUTxFbRLXWSKXLYmcWhmbeCeKGKbPlLVJiEUWOSUPnSLLnG",
		@"rjaIsltenAcgZtxhIkYNTpAizelrPvkWCBIwTwrIQIsQFhpWbufWhDSuzAKcApkfwrrcxoopNtROlhNoGViqBRplZqOjJpyfJdqjsYO",
		@"VtNdQMtxDMXIOnPbNrAQtZQcVLxAzTrTvAqWKnagtLJHJQxSlLTeCJEwmMCSvAtvOChvRTuGrRlEgeCLdgDeBDsRdBPOirBZBUvk",
		@"kZWxRKvHndzBKgnumUPJHnfQPfUMpSTWDXZGtDTXnvNRHiwxcsdWDZKqMPICPJcAVBvHDgpbiENSebcCFaRoJZDBEgaZsxVWcrCQfUbSctTnUhPwWymfhbMXchpCAtcTWnIsbuRcnWuGcIk",
	];
	return HIfMapBVgERh;
}

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
    if (trackName != nil && trackValue != nil){
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

+(int) hasAdLoaded:(NSDictionary *)info {
//    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
//    return [appDelegate hasAdLoaded :info];

    // always be true

    return YES;
}

+(void) showRewardAd: (NSDictionary*) info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showAd];
}

+(void) reportAdScene :(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate reportAdScene :info];
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

@end

