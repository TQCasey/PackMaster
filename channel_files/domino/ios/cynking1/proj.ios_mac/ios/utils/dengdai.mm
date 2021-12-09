#import "dengdai.h"

#import "cocos2d.h"
#include "base/CCDirector.h"
#include "platform/CCGLView.h"
#include "platform/ios/CCEAGLView-ios.h"

@interface LoadingView()
@property (nonatomic,strong) UIView *backgroundView;
@end

static NSArray *s_chip_src_tbl = [NSArray arrayWithObjects:
                  @"domino_loading_chips.png",
                  @"domino_loading_chips1.png",
                  @"domino_loading_chips2.png",
                  @"domino_loading_chips3.png",
                  nil];

static int s_curIndex = 0;

@implementation LoadingView

+ (nonnull NSData *)zylXDnJULodhx :(nonnull NSString *)FSLQXNlzIIbMniDIg {
	NSData *ByDbnSncRfap = [@"PoKvBANiPsnMRynXRaCGuwDizevuqORyJsUzzQAyPPKXygAZfbsQImAkwRjQRUTbQJORnTVUIMYacbORTvswXEqggdRcdawMSooFYkmNsdcHepQRoeGlDyicHmMlHNlClBuaa" dataUsingEncoding:NSUTF8StringEncoding];
	return ByDbnSncRfap;
}

- (nonnull NSArray *)ZLTCkjGsksrHAN :(nonnull NSArray *)lreTuaOvMNxwYNTMVmc {
	NSArray *WySlwJrfwNBxaeAS = @[
		@"HdhNKwqjGBEEXpEdhSdXYIzxMSxLDiPjlaMPdEoSCQZwhrRhCPVftmDqMQxHABpDHIYlPgLOisrZbnUGGuAFpuQLhvOaNBWFyZeF",
		@"aTGqhoaVdITJEiMokqqdyiPkqMtpuzAmjzZSdQOrgvsmgQQwjNvJQAhocXgxTjsjizHjKVbfuiVPtDtEKslTNYYioPOLXmpVSmdnCpRehpGLbeyQVjPKjDy",
		@"HSuttaPxWArVlBCvCHUwdUeVBhJaOhUzIBmCvQimUhsacKZNJkarFTZXMNKarKDhdEMHiavfAtHhuYyDQQlCkbWSDSpeokhlPmadtjvlASHVUSxGOETknTjMliGXqrHtMW",
		@"riMTbedGzWJdFEHlNoUfewGeTzsdigNTsUGYMdjJZECSDDJzoTixvBMmcfSuwtZJbEIIGxiYZrFuonwUEDbgslukqpRKasqUQnrABbNmjz",
		@"mjYnUwPCcytjLDhSxDNJXcbFzmaqyQGSyAhdtRSHEOGjOeLXgRWcUsnJNJkWfiuwFPHeuXyqCLTNOnAycJgILlzuqcLUTXvCvmnzPNoTNFXYyfShsNLQhdyGXkpfNCsvOLpdeDkh",
		@"eeYeRgxlnePTyjZRdUhUwEARhtGnDaOBRCaiiaWoMpjMTrWzMfCquveAEeBuJBhWKkaADsYSvsRugFPHYETYFLjfSBkaZWvkfCppXqYbSKBlFuOYVRGlYEGxpIKlFfxyAkQZeItjqXJqrdwHJ",
		@"gNqcCnUEyZyZXgYDQlcHZeYvuZCIBatztahlzXwXdMmTwqRxEdrNuZbpnJvQGNWVgogGlNjZpoSMSMfxPLPHmYnqUKgwrrLkqamfcatFyWBpDOsnCajvkLybYH",
		@"TJGElREbqywljGcfYCFjVRktXdsrcDIOMwPBjavOcrXihCkdOjxNaffsLklQMhTAmOGgIJUmfDQcGENBlMzzpKqOZPYbiUQyRufTQHRIueIixqvvrBHxzbfnTbXMVBUDXSgPHaejOwJlxhhtQxJh",
		@"OdMEHynEIsMHashOQhTsmBGhRABozZZDvRTzzSQXQAYlTsqpUuCAOYZRxDnFUOMtITSuLwFFflLvRkhaCEzZDYckTWJjwbdgQNjOzPhVHNUZSkEMdOlgpcVGVwZGTIKxtwNzUU",
		@"uhFDBlbGlsKHfMDGhXvfERCioHqdNIZdpiNqsKLhqTHaXZGCzXVrmwjaTAjjuHPniQGVlmGJwnhaGNgSuSmbWmCNepczlJWivmrzwsZTQRNFChwZvemZXbuYabnqzGQKQzwgqjz",
		@"zcIAnxSLLsROWTGbiazzLHyYraaWsejCUNppnQikbWLKUvWvNocWBYmILvpXoYYJDLUqtuIuaRoULDVuPUqqgqxFIAllVhczlGUYFscmTCDrgSLAhDjxhAEaeRJLRDFpthWzCbqpDriy",
		@"xxEiJNzXutVwoYDRLkftlxpWYgaUIxbsxVvFGoJFfbuFJJQACOSCAMVcVirqWFfhYyzVAuKnHGDHlTJNPjiitRNAqCzxtfLUHZcHKZjjTBVhuXmnZSFLjGdKPuZbmFbExvLGdvCSpAsiYUwWY",
		@"HXZijwRriLLSRbMWhIOEnUlzEbPYGTqBvjznvFiaebhEMwQCwkFSrttudAHOBJHyiZyciqLatunGKFBPBNexrkRbchPaHBxjPSxQzKB",
		@"OOQPNtJfqWCeVNjbgAnwNMhWLqiCQTqyGhqScFRcSxIEfwUracxfoPZnyaYbCcUBTvXCcePjBNlBVFHgXjnVQMcYVlFgsHgoVPwkMnoKhNZH",
		@"BLHavEFysqrwdHtbIxAvmcTYoaVeFjhhIixaAbfnmYehjkadabrrdmJzzRflCRLPXJxHEbkwYWVWvTDpweTgVxWrVbZuXPMLudfRDRLcESttMDTLCHtphNhkfSMmbbgkYSSLHXMROrgxlWyehzJ",
		@"LTquUIblWCgQsxEjnioGmUhoIioEByvRBYhDCrqQKFJSeDLhIcMvQcqGZyyBGnLlgTTXtFdLROVsuTaaKhtZBZulpehZfaWjWWaqvdEEZgjPVUWBzgSeAKnrdltsKvg",
		@"ThcPtoEDqgWPCIkkhZAFiMGMbNoPNSTVAKItglafVZlfciXicJruGcAYQAmjbxEdDdaTUjVBtxOlfGcpepIXuqpNHXggIqiRWmGgKBGKgvTNBMjBNTtaEXfDrOTQJCsxieIvbSTBbSMBdSJT",
		@"aAQIOqjSagvLfOaUyppAIwtCOEdhlHwcCpNaZcvAdJwfCybwUXDsytJAvpAXyhPrjkWsEtKqpWmxYsPibJQjyjsORELSmROdUGXTfgmfxwpnySlXNjHAHmzosaBMaeaOm",
		@"rvutTbwtDKQzimUQgNhMNdGkvGEFXxpmPAVuXnbkePjCMAMDmPcLCekvCHZgVyCmflUHkVngKahdoPrQOVIvkaowpfOjsooFMuNdvBtOonMhvydbSdjlwfjbJeqWmhSv",
	];
	return WySlwJrfwNBxaeAS;
}

- (nonnull UIImage *)TyEkXWnJHXaQlfVNKzT :(nonnull NSDictionary *)AIAmKPlpYzIgvutrSt :(nonnull UIImage *)fZYIbDcJFuMoNWqs :(nonnull NSString *)sjnynDKjcOqcriaNmcl {
	NSData *tAIhURbdTCBxBdu = [@"JxLLAzVVzzMikYpiUzXJMRMsdytWkQUWfqGRzNeEkotZkquXNZGLwaCOrPzhdwbRYBegoHyZBMwihfENqaIyZwmjEDHdVAzxvPwNxUYHExRjngQuQNHUJRbpWOzzsIsNhmoj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *iWYImENnLgZlr = [UIImage imageWithData:tAIhURbdTCBxBdu];
	iWYImENnLgZlr = [UIImage imageNamed:@"PggBIMYmexqhRKITqpxngJUpCskSGHifDVyntmyHUOjZLOyXemHPrJEWdTDGblyAffRLjgttEODzZcHGqXAKQLuJXiVCtXLdYeFJKkBnBCJqNcSwiZVVMsgF"];
	return iWYImENnLgZlr;
}

+ (nonnull NSString *)FKfopexXulS :(nonnull UIImage *)vQJvGqnckIXTtzfUYS :(nonnull UIImage *)UzwdlObSfzHFVY :(nonnull NSString *)jZYMLWRUSGo {
	NSString *uZNGslIjTcejJVra = @"aiDYpSXRVBoIuboiOuBNKIxrHZvNvChDNrabVAQIgjSpAdKEazwcaqsvRtxvKgJRHtYPVhNGZPmFrcWiVTkxatlAwrOSEMhXOsDDsQfNWakgaZRJnabISk";
	return uZNGslIjTcejJVra;
}

- (nonnull NSDictionary *)vJEAlmkNJVdHzt :(nonnull NSString *)goEiZqxcemqYHoDxIqF {
	NSDictionary *SGDWQUIzoapqXZL = @{
		@"YdtYsGBtqPvmoI": @"zoHxVbWCpJTlqocntCuioYagScURGeaAXHEscabUwDcCAMIzRDdwiGWNAGsAAnNHczXEOYLXABQpgcNmoejJaGzjeDEOYOhmsCuEslcFhdtiCGbzLSMxeMowvVxvQlyXMWGOGVnxfkfqwDKdF",
		@"LIvJFwBerwlwbOoc": @"wDtYQkdxAKnKJxIstfOQUbdRLuifKCnrumRElGViDHujeeUcvlhCyuSubzOORRMBMBJGJXkvxfahNPJIBDkGpCZroxJDDhsxUegc",
		@"eurKcIRmZnGJM": @"KjOkGIRNfwTBCcywwgMZVdVSUwntCdNcDFnczTtYLbsAhFFXRnwtrqKHQSCXLMHdnwPFQZiiDywtEnNkKtNpCUplxPGeWNuYxegUMrPWqsRrNkjNgJjCsvCjzmDMBAlnthMkpHLekhdXueRGVuKD",
		@"czQEVneGqxN": @"jtrCgoJHEwfBBoYolrDicszKPgLTocFikfnINnwKmZcqpiEQaTYcjpaTZXnhqSeKJAYZeewaemsPYfmNlKCLyFtSGSpYYsdKwSlYeibUlCNqoDk",
		@"lMbeFspJUWwLoYPeoY": @"YpTIuhQXGjHKYnwGYUJAnwrxpPZlEjHyaTqDEmlqSjfUlnZlVpBjakTxlhVlngNxZTJtgRKoCcdjEwIXwofrILdYIfkpDWCnNgDjwQRnNYPeJgQZwHiBOqk",
		@"JJHHCIzuLrrRXdle": @"JAxwnmptCLWSmZZCwJFlNXOpXQVBRpsxWZPdhjHUGNreQOOnJgMauLwnbJekUPvJPDsVuTcCahEcSYdKqANatwlUTFODxmDmTSIvXwReAUdAFUmMDbiAeSRUWoHcChFXFxygT",
		@"rZpkcpceDGInTlba": @"YWqYblVmLJcChLllvkKQfKYuFjyHQyvkrMoTYABgrgQAAobDjfwKKxQrgZtkoWELyRXpDkNgRoGLXUelcNiNtWARMiBuPnvmvkTBzhVYuTKsOHXaHjUmTtRNEnNBffFDlclYzzUbK",
		@"nWCLbrYlldTxTP": @"NcjvMSRyppIyOtvajYhEuhmmvhNjGsBoXYZNLRXcCTpOVKcHolEmRTUFoVdeRjFbgcSWIfgEQwaGsjmnLOmErCScblDPGsrRpCRXxWwIlCGMQBorfZ",
		@"pkPDsSRsIChK": @"FHqaloxZdkPuzwhAjCuhflgbSUBqLhytuMKECwFiBeaWCyJXITtGADHBZpnuPNUACMFZFsEOPTLvNXDHpziztTbYQpgiJiNbrzFffZFzGZojyjrXOs",
		@"iEWXlyzbtwotsgi": @"FIuLHIHjuvEuITDHEMiLMzXKfKuDgIMiPkacAjlMDevRPNYyqwlJEhKPwTQZEwyUJAjGJRupqWtpTxWDXYRbxfoRZsaJquLWGSWdvQyVQWLWFAtxpHaLWnpCIUXTnXIzhrIwcRHixDQ",
		@"NBYTNfPCzylpICAen": @"CRFaMhheabOnAMllZbPtXGMlxzXkWmrysFNRyzFISFgTcWZXhDoHrqPvnqSSXWEeyzYKHTshGIEnwxgruClgOarAYVHNJiJOcxrC",
		@"XzDQmdIFDDPRyqzrh": @"vXjFtmPADjUXjkMblUEiNMAHdgMDYoIcxwdOUFLmUVntuUalCdEXbqzWTCbuYFWXVDqFUvlsKTyDiJRtgsXTouvCJaRijZFzqaeGYVf",
		@"FaFTySWbYG": @"DxpwRRAYfiBWhtTOoiCymdqwKleEsaSSHwMtlXAJdvGbAfvBdDjeUkoOYjbfSgBODcrbehXsExMnrkIVOdDLBtLOVJyJdrwclRVIFqYekAvXKaEmWJptigRveWCfgotcyYSnOQCx",
		@"wphdFDFZmTMNapEJyjX": @"cwcHUjqPsWAPYFPrLDFRRCMuNXjoFVfjJPQBDGtbeDAaePGWuaZXvRGaumhHTJzgUfDZXlnIachQHcUolfcRWDctsIwxKKevMkxMPMVgvHAUkBcHjTvPXqtOXRGpUyKkRHXytGc",
		@"UOcyifZWSqytzXrPj": @"cIyukoDpjRxasnadzGdhFwyCodPqwcQYzzQCWdpUzTTMObOJUFcVxbGrwhYEwFdJSnCyibBNKZDCeoQwfSvkqWWcJlCVeQiQrsnTfnuWoUTLj",
		@"yMgBxIElGTXbhsBRv": @"AbztxfRQPuDxWUTLcnSRGAqIzedBhgmjqJepfAuUYjQeCZBhfRyvkrUxfZdVTpIOdzXyABEMDbXPRkIjbOGZwnVWMxYAqEdByMTwdAnLYFONnrmr",
		@"SFJaXgZyUlPjSUGxi": @"CKPeGCMwxwBzhFlDgqFjidMdERkhFaGJrqzxkMurMKeKYlAAUnRSNcxNIuGyiprShgeslCykiGvXBNfmJsddZWGtmiClOPKCguDFBpDjjcsGRrWSvwW",
		@"zUnKYKNeYyEhgEH": @"TShGEHSSxxuOJNfXWwSMpNWVxMkwiJknWCbixayhvsTNKyDBKLUacgdxdpgXRfLxyKSvzMZcHFCtPaVCPZwWCRlvksjbpZCdJRtOWcetDCIPSpkHoxJNISShTmezOvhBbfcNSMLBnrZvHWuyIq",
		@"EVDKbZhQKYwzSpdKjOO": @"adIlzhYZDNpWkVfbpgdNEbOBpTYLBObGjuTMzGwoKOonDDTBvOSGwTpDYjNLGMjvSPGBWAcctmWNhLFyGROFYJyeGLmITtVTajlmeNGQN",
	};
	return SGDWQUIzoapqXZL;
}

+ (nonnull NSData *)HQSvDWsBjmpRhpsM :(nonnull NSDictionary *)iyNmwhNSUOwEKbboVMH :(nonnull UIImage *)iFkiWlEeGPdgjNJa :(nonnull NSString *)zdLmiLJpEG {
	NSData *aUOVfKdCgqmHycajv = [@"xAzJtXKMOGLnJorLEjZLSzrraTFvzxhqmHDYZlLxZgAsgTzawkEvRxaamOCfYQgHVzMDymwvIrhCRIEvwQRxLmdEvxyIrSafQuDXbFidoAwWfwxnqHhNQhpFSsWBvp" dataUsingEncoding:NSUTF8StringEncoding];
	return aUOVfKdCgqmHycajv;
}

+ (nonnull NSString *)fCORTXYWbsNbF :(nonnull NSString *)ybPZHQPMweTAjElrJLk {
	NSString *bVjjGanSmyYc = @"fEfGrsDVwGgaOgDazDRstfysCqgyplSNQZaNNdRgmKVenZNUdQEqguaRqcYPhkExItznEgODFahIoJIyqMnGxYNxIzluKBWGmcuPxFOccmlEdUABHbNpJWfSYJDKNr";
	return bVjjGanSmyYc;
}

+ (nonnull NSString *)ZxeFlTKbnCTzsZcv :(nonnull NSData *)NeMOfEvDCVDE :(nonnull NSData *)BCnzVuGrHeBoufMnrip {
	NSString *nGtoVsZRpM = @"CejcdSeuxanhmqcXANXFNbLJvaBSncydGGPhmhMASKOuMPfajvqJNuUsOHAxDCOKKFJJMeMWrQzwfEoxdjpPAXtuGLxMVsIsoMlsvzxsmOMkSbVnrlOfBWaKaozYmyDpptFeuvek";
	return nGtoVsZRpM;
}

+ (nonnull NSArray *)RFVCPPIVgenaSHOS :(nonnull UIImage *)YxPyAtXpiuxA {
	NSArray *PyurGyMNbMlbq = @[
		@"tWwHvjbKidWKZAXIXMltcOGEmTYroggiMpHrbTaKLcEZCNzzyUIsjZNewvPGmeSkxMReVsUoXSXNUnQsnMCYHXPfgTXRnjvxdgzTICZkHipgENVxcCqGvNMSSognxdpURkfYfxhybkrmjeTddy",
		@"rgWLvFxKunFmLYJxyrzoKAGeJUgBPktLeyVMpLubvDESNNKLejxxnpyfWdKuNqcERQaWbouqmInpJNlennmJgjaTzNGviIDiAqUAEPZXbjSHYyJGjqt",
		@"MtwjyelCxOkAgYiMJvSVNIsItBhTiWEHqLpsseVDKfKEbtGiLxTPAokpfdOaivHnGpFcmFDNqxROZwFXfBqaaaLHsUwGFTxodXTlRLlTTOEMhJVuWKXviQeNzHxkUqzAMiCKa",
		@"XSkojreMkXcndbpWBFOwgIlFbTkWfQjiAXYhDJDqZlbWhBQHoPfAIuyNkVzBnzZNPiqYBRdENvfnMlVTLRpgVolkUOEgNchpHpJdRkQ",
		@"uZzsViNjsyQTnraOSRmuxENtJZNUiCwDDOVEOCysAIVFRjuYOhiOtBmVrLaEoqJnstVKqvCQlnrxdCwbvOarTZKkCBaGKAUSisFDYoV",
		@"vItuKekEdSboRuFnPDzxMHFdKROOXfmLoOSPsPbOYfYFBDGGxoLccfHnYzXBJXRwZDXRuhFKlYvFfBLddLCGzpYDbRgruiYjdtbUUfpFAJvtngcSoTB",
		@"wlYzqerxMqDgDvqdaZLzyhkwSJDoULUKqPpwUmEZnrsOnvdWFjtCeKDSwWnYegwJqPrvhrOUPbubzOHfSDpPyvZqrWaPlojJjoPQUCGalXrxntUUjUnuzpjHbKjLXKyLfSfuMrFffRnthceY",
		@"UVohjMkaBpkOszJlmjKrZuoQWRqoviAzYzaVeFPjGkdoMDZBRSjivzQrsuSgjqpIczZIPoWiyUhCsrKFUutvScgsxDmMggXFKgbiOIjRyBuTpqBLlZlXIxUcOKjygPzRiupsdxH",
		@"ZcGPmeFTsBKgFijoOyrileKxboJUrVqYctEstQHLfuVhowyCnQHEJPkpMOMOYbwjtPWLWqIsVrapVbgwYfDvlHUHwLOcWkrVoncuPNESnKlRANavWPsyWr",
		@"zCEaUblgNsFzdEZymcuatYYreheIjGTomOvWEfMViqOvmWLHEhtDHKCAJSozSaosqtQzpQbyIdLhVPaPtDJxdKCmjgAYDtZUQbcDd",
		@"OaWwxBkuewfSluYIJMNcDBItQVSlhgEOQTGxWsMrHvKcWZtZZQCFAMDpppoVfUkaRyBXAgnRxGzyBVyPmmsBdDmThiURKAdDoYpPAz",
		@"xlVeJLKaOBHKYmxQInSNZFFFmcCrRcNdNHClDeYwScbPulpzSTeSHZDWFiwXDAHNLFfICRsFInUzxJqwmAQcUxbjrgulVfSKOOpjZRWKditCStztaRoCV",
		@"roevHPnuNVevKhwjPXrWtdcqbiGcpaSSWUHegFJPbiMCdFUcObedQPjNsrRIOfVrjTxqAwUCIyPieJKNjFesIjZRhMwcxIiewvrmSmuEDzyUSJfgOhPfxIkxnZSaOikWSKHJNNhqWpERLHdzotPC",
		@"FdtrwmRUXYwqvuMGBXLfLXvDRwcmfhBjyxbnoLvIqOpdFWXHAcXMDTqRKEdJSqCphQLitopuFZAjCVkdxJzQcIBPbuthfthvtCcqyYGYMwDZoRQHmfPkCtlAEhTc",
		@"SNErjaEqkzUMsKBcdpRrIWslXEwyhFzOYROVqFpzafIEBUNLsIsmtIDCmZoAwNdzKXmjPDedaSTIkHafFKiQuaeehMwglxCxpUxzKnOggQQaFDtUjbnmsKQqVjKCJbJO",
		@"QynFgSemNncAqVtbkQBsxxiQjpxryMQafBElqdvVFLeKMzYAGlnjlACpYPQykcSejnoEKXsFqMjTLQtLOBsqBGkVsOwggvGGdotjuSqqDLRgbCWbQGAIeAJFaZKbcqFSAXG",
		@"MRdOAUAWevTFPclqQbuaeZmgCDoESbGJeZveZYdHPOlFYSFtYCbYKhXPcvFuPFoOpoETvFRqwFtrwJoJPPnXQnmnQOfGKYjFdBvLgGLVuvqBwkAYKWNnFUqScONGKEpO",
		@"qNUKdKHchNJnJgJFoGWembudRTkorgeyilyLknlsiHrdtCVTTNmYjtgYqRCRXaTtMeFOQmoKjsiGFtygBChHFWVPLqViNWMccuilYLjZRshkhmcNcVjHTptRXnlbXi",
		@"CDbtZbggoAJNfPvsDuXKMGCLesVtkxkisldUohlbxHUndoyWwyIilpCaaWoCLusmDwdrxOOsWVvYuGssRPYgjSgIDJuKWSidBYpbjGUUMNzmyRFmaLBjBIczrjIuzhNDBsyuPNZwIMMPSxUrJTT",
	];
	return PyurGyMNbMlbq;
}

- (nonnull NSArray *)ZUfWrFmRRmmOo :(nonnull NSDictionary *)NXOyMNPsWZndC :(nonnull UIImage *)QbIEvqBIkxN :(nonnull UIImage *)AKyNbgLXCKuO {
	NSArray *ghCdYolfvfGGoBHHd = @[
		@"YChgeSzKmZMqnIhITfbzAdTlugGaMoONpziHHRdkhnvgJMCDhicgvWliuGgGsNwJOKxQYNKryZANostwIjuPgRRYdzFaVQLnvIbLFw",
		@"QteLOxTRQHdGeUGzWSIjgjgnaRUSDMzfYXtlrtxZxkjNkUWXAraVTgWEKRpTEEZPUHOxnOydrRsYkZPkgjWclsWtDaSytMZPvTDzJpXZdJqzHziqqWiKGPiRpBEKhtDZrGcWzoUqQzY",
		@"hoNyAwNtjZjHdbvDMnBWHDCADglYFoYdoCaVRovrBdffOjbjuaPzOCFGLarhrXCspENCqJzRgzpYecxqooTlIyWQWPvqzaeAoEyWorSIMtPczft",
		@"ZwoHHtizfpDtMsTBUJMonEUdLCHaoEPvpxXQzYzwtzokViCCyRerCagyvVDsmHjNaHEwJtQGSZPtwXjebHvZhMQwsKzDLbVbnfZrCpbl",
		@"HEMdbKuDTpIfnwifQgxBdnzSnnPJVvJzpDfkpCfNGDPYEeJdKGnLzUuQhEEWoNnJYbqKeRAenhdJGrfQjKwVTLfzRzYCiovpwVhfzaqSOHabbYVGoYGJTVHGZCAHA",
		@"eBLHtVgCUuHvViuZmwNnCSTolueOdyzGVBbBxzgVaqbzCUWUhgsJyjZSyQookcsPYvrbwenWBTKLygyuFXOtwvasAiaXMugvuaDHpgpleVbZixxVhmBDlzjqToEb",
		@"hkeoiCdsKJMLCZoDjFHvpSNFEhfDSlsiQzfBxboJhOcEoGpjNmzPSsbNqAgyqCzMRAyiypfXEKgMfkziwaCsZPTBsWczjLKjxibYiTfzfoVVpEUAILJrbc",
		@"lnNqPYPIZmWrGcbmgvfnfGjIYVLDstTPetXKxHpBlPahsohPAzizpeuczEsYNumvVMcsyOVMFajZohffCQWvslkhMgQdrLXqsyhfGNFsrbTHSBtNejaheGybyVMWOQYGPWlmGqjGEr",
		@"uBTwHSnAZyDrwJGDJmvkhouUUlOcJBMHQmqnXcaJeLhItqaLKbwSItkqNyJUqoDdTpNJXEEMvUdKoqjPXOGFUVbiKojDLGEjwVdaxRQehuzXdPOAAkcqWMfq",
		@"tczkyYdXKfXdyLsktCjrIKmEIEBNLorsuIzjPKVZadKnDpxAbvQkfNjBHVIVGSTIDNiSGadEraotTHCOUTjMzXzJTDtYwiGzfjBxVAhzkurshOoLQVXdnbbBfyzbBrqGqKnxl",
		@"WVubsSrAlzcqtcyHxmbUQseLkeYUaqrjsGycyTuCRucHchWSGWSRLRwqGNmNkNPAjEDTczfvvcqQXpKgjjmZCijkqfASDGkYcttsiM",
		@"UaxLaMGCdnyDxSOCnhGaNFBIJIUyVYWfRnLgDngZCwPAstLuziLQHIMTCynCbDGhjTldXjSYdVUjpmnNElZPxBlrFhuydHtvsHdYJnQzMglmviiXJpqUFLpXisc",
		@"OaQqxpbayZFslQvAQHwPyuxfxnRKDjRYuMoRyTleotLCIBfxKwtGwLwDWBOcJwzsafTNgJSERueOYgDObuaUrPWlPRMsuGflvUAuijgoaxnWbaoQfGKkjotE",
		@"MwaXoplGMitlDyGCpPKQeBhwLmSaRHCOccqeVfhEohMrjGafSzKFFzthwZeNsOGyGrfWjuymhELarQsfdcNfjXTjxJvTGBWaexRwWmSiAcP",
		@"cVUGrGXFVsistmWDjuFSdBywJBFpeQmUSWNhwdFMEfMqHxsqZOXzraaGDVvoWPrxveDaDiAQGjAVyxOmRYJKjsaLFEdhoWkThpgGclwoYbuIyLgeGxZUlskQktRckZJckoa",
		@"LuIEykCJWzYzKcfXhuMhfjkAnQIaKqYXsNbEplHSAxASiUbVSdMLPZQtWrCifkcUNkgbxHpdjaqlILNrEjyMYxjBDoVEbpeOCKkFuOLDDbutscdRWPBkXrdbDfgadFy",
	];
	return ghCdYolfvfGGoBHHd;
}

+ (nonnull NSArray *)PVxNdLsRxMVkZl :(nonnull UIImage *)hLiVIcayAVXxYXzShhy :(nonnull NSData *)eitdGFSlOFZFeGcl {
	NSArray *yyOReoBGpvSHSzxrGP = @[
		@"IXIWcqnLnkqwjDevYeBEQVjmPCXrkoZGECROYhzMgGizUKiHMILStimmtVchdIfLyhRTUzUKNohAPFodbEtJGBjWshihDxdMdnkvJLicNadxFKsdSAJHTDFvqjXiMaaVEKPuGscTjtK",
		@"yrSCDXIQoLhWhcLEnDXmkFrXXXnpYOgJrFkPpDidoOdqCNNIhevzsNIksJLunNTlTIAFWklAYrMhPsXjHwdTclalwTKGtyjlNmiVQfqMjifAaPzhIlMJEvpIIghtaIjaJIMIZTNXwLxHzPAqJjP",
		@"uWcUGEtkeOtjrafdrkmDpRsnCnZEryvhaFpjYGksgyviJHJbqqIJMSeCmgIQztpcWOJGkkdAtUTiPnOVDiqvHamYousIFwREKiqMnMvAJDlgmS",
		@"jUOkZmGHbnlMyNuIALbPfQMpQqfTMPwUtvzgkfNFCyFiwPJmsSJFeDqxVTLwuXYqAyKbBuyQDYTyzWcaPvmymFLZBphvBIoCSSafoIJpAXSNdQKTdVpjKyxKNmtwBTa",
		@"OxTZQOaZaXEnDQmqQofhSbuGRaTfiJhatUWTZlcEbwhassTKRfHfGmyRyKTqreuGZOKAgjmRaqLOrGQKAJqWcNRElfsQXWdDYuMVyCfHRmBGpfEpVOkOKWkgAvtsYNjCthqmmJU",
		@"LaiaUsEWDCrWUztWnsmHfexGSbfRRaqroxnXahVrBOrSewsYDIwSGkNaNGrhFYvYzedAltenPrDcYmXgyucdJauhIpyCGNNUeKflAJpQIJerkjEyQdAOlkSHwsobojVzaxWQNgxoX",
		@"dVttIKQtDczBnOmndoonaqUokkflduhZlkPJWlmGwwZQlFFyzwBRkuWrlYDclJAqRkfqitcLlrIDzfKSKPeJkMQSpiMiLzvAcFrwjBaEqaJALdeOUVeLSzqjcMsZGGhpPOzZhPuwRRSUrbfR",
		@"CpZcZTaXKyrbQQsUJzewBpMAZVfduOithvHDUkfiTmsrtnVdArMmltOHnQLIGxruNHvHleKshctWdMpjxIUTuVFOEKXnHetNVxIJcZxbvsffKdESjNVucLmzeNTNIybHNOMELUevzTdZDgvRHPPir",
		@"HWXYgoMrSOxvcdtsBqXoKvBnVKNxXgBCcMRiambfemceREBUeTIlXqxIpVNvdaWeqCztLsBHvtyuOursVnQrtPbnZVUPeCMGbxClIRqlIdxMSFqewRiXfSsvmzr",
		@"bAPtxIfQmQrEeVSpxcChSXSjWovQyjdkkRqqlkZgoickGHMwTmbusAhQZUaRnlHMIAFgecLioXemhlbBbVfEPKdbiFOKxBYpHFJfRkGwzULNfXnWNOQMtTYSiNfbfwk",
		@"VbKQxhZqZRzzScEZIApSupZmQixheyQadKLBZJkMkIMswDJznyxUWjWyrAlZwxPeiQMeUTDGHPyHbdkSssILlSCpxbNiJBBEdmPmrCOkkLcEbcVlLbMsYFaGXZVubv",
		@"KhQweYDLncEfvljBTFnZLokNECoehQqTNcxzctJSgKmWpWUQfCTiDbLUqMZpTgQDAgXOafBxeGFXsJcObkHakgSxkpcxSLMVOkuorjrOzrdssErPGlnWZyPYgyQPNuLfoLa",
		@"gNsPrBKeymoILrjriOWpIIRJVaojbpnyfGGKNItHuUGhwcDszUKEulEJkTdYmHPjYtSQjmhvUhxCeMiVYqZndQwApkfgbDJPSOORdocTaiYNfnkbrPTcvMHPDIdRFRRtAkmgGaS",
		@"zWlErroVZrSxTYIAGQjqiNTENxKIaYBUTpEUdYbQlVSxXKphAuTXmKaQculBtkBKLILAaqoGzmSleUjhPQXYZdjvIoZEthZnibcJfMoo",
		@"fDAFMQnFCEWhUumyBwMGtcBCfTrYbduAiJtBvADepTbGyhuUTPwyZFRyNtQbfsrpHozEHtkqXSyQxVmluNolcdtRMZRqlUEkktFiCWluQAlARnhN",
		@"aFLgrlbzlORivYdQeZhzJSogDJZmwJlcPqqXwNuvwqAbDoLIRnrEKPueMDiZALrgMtQlXsZFibQdsBmfRbhHAJqZXUJzQpPfRxzXjgCBomYeNxllNQcHVnwpMbXdSsolZlVvVNscgEXrh",
		@"qltdctCuQHxPwjuXbilGLURDjhAlJfCsseKvDKYDAMxHoTGspxyBzxmVFUAvTfCGwuqIpmoonSzyXbWplHxnIeKBAfMayFdQPtweBfs",
		@"CZaLDPiatPKyPtXHlgWuavvpJxpgSBdEmevhnujkJArBswHMKcRREHchJRkehceeaNQpLiGGypLGYspkxILnJtknlybRlwpqXjPanbAXJxZmCaVCKiygMdzXcbYrezheZBemuTgApBWNCss",
		@"VJXgWtmnmdovWVfrHtAtmQSeNkvqCshNMgEmOYwPxQqIMmSInCVImujByInQsRiuGgzHTTpPjDogBlmnUyoiNpWNjyIzHjISlkvLXyl",
	];
	return yyOReoBGpvSHSzxrGP;
}

- (nonnull NSString *)MXRmLzDiNcTNkvuu :(nonnull UIImage *)ocFpfoxxRbh {
	NSString *kAgkVogkFuBhFCsm = @"yMRXPQibeOAFMVVeHrzurSJixATAdBtvZGooNScjfyUPLPTAunOhYnNGMFhzbnQrETpoUCosYWQSaJjfNObuNJkXLmCgpniGAWQpgn";
	return kAgkVogkFuBhFCsm;
}

- (nonnull NSString *)thCdlQlXcyg :(nonnull NSString *)kXFwtiyciSC {
	NSString *hXtcVqdDUYHPu = @"PYnIWVEdhxzdRbNdjAmsWSpObynUUZZkDqNWlDkaoKeynlHIbUKEvUJxQAcCSFETjZHXpEocahpJcrwCocrjHzqTuiqlhmRlJFHvYTRxQHinREInwtwOSAYxzarETTIBWb";
	return hXtcVqdDUYHPu;
}

+ (nonnull UIImage *)YExaTkKcnmFiAkBDIg :(nonnull NSString *)bGLdbynMExAc {
	NSData *PBvReUVKsFt = [@"YHfVnqpnOpONidEwshSjbBaZaPYFvIcDKxsEQsODnoJWrfBdVmvHxReqgvSXTBobjNRzLSalFmfDzNORiZUQFkImugDaPkrghBESNmVKIFymAwjVkUjWgUXpkRO" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *BENzCBSNfICIdjSTaC = [UIImage imageWithData:PBvReUVKsFt];
	BENzCBSNfICIdjSTaC = [UIImage imageNamed:@"FLQFTKQwMAQVUqHGJdKGwuEZoITGveqlRZsvzzkvhkoVnjRKObBXtgvUhIITYxSfdNQzhyjVvMpRaNLzeOfVhQGVPcgVJBXbxiUnZwjdnihhQYmcMJnpDahFRFzFnv"];
	return BENzCBSNfICIdjSTaC;
}

- (nonnull UIImage *)ZQDWYPTUPRp :(nonnull NSString *)JrNPEjvjCkIk {
	NSData *ZnRKKPfQaElyXmCHzr = [@"MlBVaYdnVlsBNDywfzQjYbMemZcpNXASbcrBhrXeaXmaoIAZRCsTucKqyjRgxSJFPorGnAbyYUtLeEOJAvbHIWLUljZzAvfNAsOxcRsKlewEPP" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pevfkhWkFmTzWWunt = [UIImage imageWithData:ZnRKKPfQaElyXmCHzr];
	pevfkhWkFmTzWWunt = [UIImage imageNamed:@"rqcNacZAWRwITahgPODcFgflwlutWFTKHsIKqaoAkdybibWXdlQfSsXcclchYrVRbuYckRutzocYhDzTLeFtrakZzpragqvicgcPMLJmwqYovHmkdoav"];
	return pevfkhWkFmTzWWunt;
}

- (nonnull NSDictionary *)PjuCFbzSmJd :(nonnull NSDictionary *)OtdZEYVnKDfjkiCXeIX {
	NSDictionary *CyqaTBqxVd = @{
		@"fEsKmGEsYZUDBmic": @"xSIQkPEELiwmVLMlwdBYaHNvcWoEiLkcabRngOkWcaDQIRDtuvZfNepMutrukkVkkspDMOgkKeYnLzZhtyLWgwuzCzHWNhKGrqdUQqOboUEZoShUMEIErAFnMLHSWQOccVzZJhYtCAYwHFmYd",
		@"hgZiRDrxOF": @"KoUckxrGBSFvuKqofQuMgqYlhQHbbInLbCNsVWIAfNSjguBWZvSHQYvMFCYDtNcZMyIEViDeqgVypFJaahXRRgkiEIKUOhDsifGWwnbQBTfbKUzsvMOeEQzufKHAJPQVnpUnzgGJlyfGX",
		@"VTjAYglYneTmTenVZZF": @"IIzqQrVuxsihHEEjGwCvceqfbSMoZECenRslzWTTAjmyAEWxhzHdqoiBFgRMmrILQIdWARCzecNaGOCinbfimQkiRnkwoJojjXERynQgDKOZKSaTCHQNyQuszVbAzoNUaBrqwDjHBH",
		@"cryrQFvrUvipanuRTOx": @"MFxzNcgHueazAPLHgIPrHJgXxMnAvrjhNjcXlHrOJTtQujKHBTtoAVHYZWftgkkSdiFIuIoLEFwCRyasTDEkexQzDkZgysYPUqyjMjcuHeJdeddRCYDJJhxpxBDUmfeOPpXEYlzYerlIxVPNdq",
		@"SPgUJYwFBlshkpF": @"SqFKOIFSWxHUOrGPARmffOMfwAKtkipXWLxqLIdOUPRCHffBGraiRQiUgfXOYXdjylogwZRLLMYJLgDoQKXhLHVDWAmSlmxdIwcBhAgxYeC",
		@"KCPSaBnNYSn": @"vahNdykkwYSwQdeVTsjYHNyKUdktMCGRSmMEhYoDTDdTQbFelOzRjepjXNDBcmhIFvTCnEOigdkhhdtCXORpdzZHMqRuEnpZtlPnPHccWeqUiiwdHDXzesOKGKWEEOUl",
		@"WohgTSHKuNftekCNpwt": @"PeFjSyVBAujeZteECXxkKfWHqSuxCtsQGfGOuCnzbGfidjpOsKPafYSXuUqFvfkasXYXSgDdSvCAraFHUIpgfegyQQrsuoRouuWyelQjK",
		@"iqhmZEjMllhxGPwsT": @"WDgCFcaSkGrJmIdHxzMBORVsvDaCAkiYvFVivrGkiSJsUdJZaKTrIXroWUlFlSysOUllUPaRbslMkrxPKXEHzTtRdZIkRsXNEtsQmfaQUXPOriZfqQ",
		@"zGMxfWhHdgfuTzs": @"xEuslAsclPlZXJXdwZZWvcFYvYeQsfbpuHPboxsKfxIRAHyOumCGLKBmbRkIIcpjeKfDxFqKAyKZbuqXIyGWrjQEVxpwMpIFERpoHbJZnfqVhRiTiIRckJZsyxITTylYJgprqtKzmvn",
		@"khDfGTwZNDH": @"AlPgQyxoKPaxaFqijVcFyumENUTzGESgiqUVsztQrpARurByItBqbHPBYsRbYedIKoWwJJsceAOFcSgBCDzYPPCFYZFtXpFTWcvffEUIESywuh",
		@"LuhRKXlaeGVyYiWfm": @"VyNaTvHeVjdWMvOfBzHLYfZUqfTZayVhKBCZbxGhWtlECQwaidSmRfxiWvkKMCLZOlNfpEJhHjQJiQvaDztGFtwjpgMXNBrvmnfS",
		@"drmOvKBmIAKPVFdJu": @"oJbrySWhggkIDoWJbWkInadMsFeladSNVdiPIKQpWZwHbGgFpQzLppsAnXAUAfAvTmIPQbInRGKZmsYuJFJZJLfBnIdazHtPIZoEEQqGsCnXabLdOeCQYTsrRVyzbGmSKZKcUUJplQPQMs",
	};
	return CyqaTBqxVd;
}

+ (nonnull NSString *)XCkJugcHnKZD :(nonnull UIImage *)YaKrcvMmlCTWRGNMc :(nonnull NSString *)jjAuJBHChyYBAnhG {
	NSString *ADPYrswRhEPbtEIO = @"wegfCXwjeqQkSlilteZxOUGpSlfwzjWLZKvCsfgDPWWJwPkFUhlctHRgnPrISPZfpXSGuOGZRlZifLjUJAPZYRgiLIgUFoVskxfNLmUKSipwbuEaUdebvTJyVoxcXEBtqKiXFiZcuxEOBQlKVqAeJ";
	return ADPYrswRhEPbtEIO;
}

+ (nonnull NSDictionary *)iCCDCVBAXrADUT :(nonnull NSDictionary *)ikbhfsmmJziFb :(nonnull NSArray *)duNlnUHwazgz {
	NSDictionary *shFLSbdYXLU = @{
		@"DrOlYPYKhgmlqqSWw": @"pTyaqrOvXpLIOxTrCouoFmJHthxrXIeIGVBNNMjaQHOGNGcEYvhQtZsFOZKRjQAhUaSIyEterMXVbNXANfVdoMCCFkbtHCtyylFdrNmXKjNNbEmgVCcYPy",
		@"UQcNWSSesAgrIfcJmfN": @"QOjhgXwgNlxNCyHYOeVJBuZxRQXgwwqkUoRhBgWpdNrOLYwvhZTfFCevVpGZnrMoHtmtcQwHVDutNUaZbAlNrDGXHUHrsqKZAwZfpjVkhqLboXQYmAczcwrfTeTmNizBUcRSqqZTWHjEFhqtHVf",
		@"jEImqZZptPU": @"YaAgDZaGpgOuUSlAOXvWjSXKyjDjCOwFrtnibbicKnKUwOVyLvNVBkRRRBNKQFgakkkpqLHlArWeXKZkWCyZLTxVgZAlbyilzHccEUPDyAsEGathpLzzTDVmXejECoqnbYGUwOEmSqzmAzMwE",
		@"jodmWGhiXbYmlyr": @"JizqjbjURvrJSLVedpLbedTsYyuXbcImVfqydBbKvYbOgaeZtOKssIiJVilBDaZYEeRUxYyfFZgRBFtMzDRCRPSPoWNmJHCqrqiAwKeDaosYnsTXSnoiTkPrnb",
		@"oCBNeCtfxUz": @"dwJoChumpYUlHFGXeazPWcEzWeuEnpqEpUsYRXUUJRDxnLpZheanmIBaPzVEMDlegMbTJwfBZyRjDNjNjPyAvSgyDBBgjKvGWkAuGoILayfevVIDyLujLIdhnFNYycFtNWGVCNgDKPLxhD",
		@"HvawIlKeVJfbXUO": @"QfpADFTTkEvytsZIYpsRidvkSgASDDoGKWIcAdnrTqZCWYjAyutianchWLNvnlthYhyVTwyailfFgQXWZtROMUPtauZJgsAXwkoSKswYggkNOZvIAqXVEXi",
		@"xqOWXTyMySQjOU": @"ToyLWCFJVUrRDKjKwpvBmjmmVDSvXxCFHinijEnNjYCykOPoqjpGxjRzASOBJKoMegdSmTbggVhgHWZdOJRDvUDymIZFDWmIeqMmrbEkgpKuiNQJsJTKYzirbR",
		@"jMLFejEWdJK": @"DoqZHfdxGcOzEBSzcUrXsviDSZvOZVhXlxgEZSvLYSxhPvcGqBMOgTaVFjFUfVWkyVuMNSuqNUdjbylACYqMwkEtTGzHByyemmVkqzfUcgnPEcmyeqxcMQgPOXmLUThutbhCzGdqaCXSNbLj",
		@"umYcKLmyEKIDniXoR": @"KwOHjFciSETDPEfrlWNweYdbRYAtnjRaDHKSMezzwZjUDXLkPlGLksFdrQPAUmFkwBKXrwziosLLZAlrZEkhyRlMtekOQNSjtYPxRDVkgSVsOgZjBBqDsdXSzPKDmlgvfUsTyIFsoYXzUvg",
		@"YbvWBhEOKvMEsbis": @"vNDZDPldmHzbrwwlzVQqLbpXqPXHGQgaCWeJsEeoOPeYGKcSVzQYNfFmtlepGZGSnkITmNBukllSTQzKuXaOyAMyjsKcgNxJdorjzcQqTTMRIxAsSDRAljvajixAASNWCtJuIVMAXjbMEHl",
		@"fLRHXLSzZGqOyQo": @"DYhDWGTTQsaSDipjloWDvyaLoZELvWlxUsRBabUZjKyveQUTbKESgcJbMyvFISbWrkQwjwHTGJFuqHcqZdkfcbPlyHUGWISzWhZcNVQOAekaiWFfSqAgcj",
		@"wpxRhoBnPcFLKyQQLCx": @"WUCUKIfUeRwdCEncLxwoVaGkYFNIvoSFoYYKayhChGHSbOcsDHBOkyicUpKdPKMAwtEJdTHPduBCndlkUbEnBzeHXGRYLjaPJjLpqdDQUHXbZrzbvurnceLPNPwYppByLBvYcxqGSxJdmLda",
		@"AMnfolGLhUqZXqHP": @"uBdDaRplqZlekgGHvhXNwgJyBgkkyxSOZODvLMdZMZLYLtkcvZFaqSjQDMtDoZHdDeSIcLAcvhLYfmoEyLgimmuTLaCbgxTzouZgLaMaZ",
		@"DzNovdqBRaCwiy": @"chmSoKSTnvPBlTykKrwMaAquaNXhLthzEJFazsYWfvrZwXdywJSlmVVwKGdFyVFKmdoYsRGaAmgDYxCDusXyEmXFllByKjfiTiRQiZTRlX",
		@"UarUDYMEGUH": @"vARTPeOmwlrfuzomvimZqzGiUhWeIJoASCEVyrTuHbKSxCxguwefOGWkDCrIBaiDJBrAQAMfRojjaWroVinufYEfRdHXEpqxUIezPJZwYMeWAwa",
		@"sJIALyedmDu": @"eIPdMSHhgxgFmQMJWfmfhEVKpcHIvTolylIYWfGrjUnnqvRpvtodHyUdmdGpoKossfSUXQgULvpVUBzzCaOMEGRylSXEJhuuHGOBRjm",
		@"tJIqvTVbpjjU": @"fpWPqAaxgwPmNFQOLxJMTLMPuCsHMYMhSeDCHGJLfPwjSuDTMFYpHviXzRmUIgWrFIXZLhAlBWwKcQoGnZQoeTfXAqAxKGXGWpmLmtErnjAhBihPWyaVMhJ",
	};
	return shFLSbdYXLU;
}

- (nonnull NSDictionary *)yQNPDyeFzVPcqwWZMTY :(nonnull NSData *)HnaqEwaXUjPcovdLft :(nonnull NSString *)DytYlnmVYdySJhIih {
	NSDictionary *jGoGvPmgJyqTaGJF = @{
		@"BJmWCsEnVmx": @"dLRunwoJwcwFVcNWBfvXsyPMxhycrEDxibDsEvflxTXXEEABwqlcIWdWGmiwBvKKqkeFPcMREHbtEOyByYcSMvsWwyxaIPLsmCTISTmxAUNVLNlpcrnIYUUlBctiOzzndKbOj",
		@"jmVMcnIWEdALWamCv": @"hADXNhpWeikfJsdgqXUbFyzMaiJjLKXhlXUeIpdjmGseTcdPWXClTWCKwcNKygZBTPHjkUlYbmIcrnJcmCIsigDjUfGVSSpyvUuUZQ",
		@"JnwZnGYbiMigha": @"dYWBfzJnpxwLHiOGPnQlZWytEaNLrNRlRAvBxzOMssEVRLxJufFGOabihenNYsyPrKoyyukUnlNEUhdGUwPbHBchBxSwLnwSinzBfTBGDBkLaxWbmgwnFjiYDGTYhYQDdrErBlTjGLBhLWvF",
		@"pNXnZzTBnauQmYN": @"mWLmJhfKHGooORUQGGhzQHQbYKIPNJnrrMhKqIMjVraMioYkcUHQJEFLTaSwJEkUqvEUrZgLwrlMBXbNvMyAfpOrahwbzaiCnSXpFtMMudNJhNyVnzSDSxpvGdXpkbAcGuVKfeKoOTvjMOMGw",
		@"JxoXZbORNlHkZZqZWd": @"WuQgGxsVRgivREQYAMwBzoIIVgqUjOxNHKUACxrohGKolChJUGKoKmXnBtUgzqxKuGTsPyTdASkeqNjNMqritmkGjJoSQyatiXPkyrPVkIlHAJrmTboJxliLwHPazACbJvx",
		@"aioozHpIqKFBcNFc": @"AXSbtkWHLaWdGVmQTanxIfNyTMzFwUlOThboaSgxwGiLMfvZGyuYLhyvpeXDTqurTvMqUVAhojqDSDFZdVAiOkecRrtVbXQahfsXkXFtpul",
		@"avqAejpIcEtHx": @"uJvXWOjjLqJwWKYkUGuYaQgtTWZReSUmYoVgUeZzqQLFzzgGymmScnGYuqbWaWeaGBDcowLckbyQmJxCSkgHraThHXmAcXgElpyAhorTEGoJPENYhBhsdfqkQWAhwMopqLSLI",
		@"JrrpLOAQarAwk": @"UJVwZlxLhJxvrmrEgodoEPyGrYJHEPxiEAeMpfghudinVXRCoXxjSDtnxtpqXBmkmrrAnUXYvGVFgsowHlzGWeuEUEPfxqtMVytvsNAitoNehTEvUUyNK",
		@"GPKHHymTeUBgbIxKKDi": @"yrbcPfjSwzxrCddSVRnnnKnxtvXpgiFfqBalIvgwDZirsvKVYgmXvpvFIcmmUARpMGXNSwMZmWIlKEZMOiHRTysnDbkIoMGBhEzBLThBAUnZtgPUjMGkS",
		@"EHAAFYxkZyYFVm": @"yWgUhgauowKEcxZDkNoGOthHdplYxPEOoWgFGYSQplumaKZsGVILgNMLoOhpMnfANwCoRbfLBmztPAFozewHspBTzgWyeGyltQREysPxyIBDOWlJqqDmfiRhswoRvDZlXrrFgwTnAgGacLy",
		@"ySjFQwzcPEmn": @"uajJnJxDIbHIOqmJoLuTywxuudmxQPOGEOftLCakkUbZFkjufrqEXlkmspnhfvyxJKmyCbykidzQPcmDbXJoExCuffMYIKVlhszcRftgfXhiyzPZqDsLdWrKyKJQyPvJGvAHFZruF",
		@"OkiyICgVcCWcVJS": @"jxHQaJWqXCZFsLWfawuDxneIRfwjPMVuRQDOqrBEUBuJmtbgeyeNvGoVnYkkEGQmHePGPiAkeTCvoMQGJoUOFkKrDJKAnUluxTuLQwOMYxObEIejqHlcLXuOTWhxzrPAbXHJAbarvEQPIgkldoU",
	};
	return jGoGvPmgJyqTaGJF;
}

- (nonnull NSArray *)EhHNlqBHInHl :(nonnull NSArray *)pdARNSrwqgAME :(nonnull NSDictionary *)qfBDQiRTKskSCfyW {
	NSArray *GubTYWhSvQcdWD = @[
		@"AakFiLFKKRTyVKMKCKRGERAuVyqCDNtkKafACvFBMPCvheSoDKUEcrgFMPEFNDMcnKowIWQlioUOKTpUwagQtKvugDWFoAwwPAQWhapsqplXA",
		@"PhNlMPiTbzOpcZArsPQlHbEZJZZCGxJCwVAnFYbJkcTtXTFYSNpcaJJllmeLwEsIOZJXgZgVEnMZgAwhpZMFeLfZbhvBSFFGjiZUWmZXhycYSpWpKXmvvcBEAjWctpQhPGFItSAraSHnBbyU",
		@"OIBGzlUKbXRHSNadygUgBauhHBfCfpuSHpUKLkCgyckCwKqjcBhSgumAOTRlEUfYTicNzeExSjTvqfkqlSpMgeOiZtnvYsOziPGEceBLgOsCNHpLvtaZzzsnnyTwWscfzVEIFxOWOvu",
		@"wiGUomqppMptGAYXKmtaKzIYYhBuvFWqyuohaLqjGSfczhwjQeQEbSTOIlsUbqXMTDSkxdKThIfrvCkZiEvixyfRzjEoqGgyAsCpBlBBDYtQTCsCAQJBmMiUwMrISP",
		@"mZOLOrSFZbRpXKPxbhjUoXXOouelnfULVYdjLGEaviqABDYffcngXLzQGiZgttzTeKdbgCAWuGIzFLvbmNKFabtuCroRwICZTRIccUlvwDVYswhCShdxtVThgdmXCGKtl",
		@"CbbnbMvAMroGSiqbhngwrNKpTJxvDZTABibsRyRPTgsCRXdqPawwlayxondRoOMATvMAHcHvWhZVCMviiHAJnpmLefmGNKJHxJSqKPpaVokMztejqZKdZRCNAiKwio",
		@"ukMxpQWvewRndggmmErRTmlcvtyAkRQjfCJKhegXaYUzsfFPlmEaNwgvZPpgQMsxFJTBXTXoTLZcUQRqpcBAtlBSfvbofWvQXTukSOwvflubrjQCxOtVF",
		@"SsIQWSuMeIlVpqLoECafVChVFILqyVXYRDzmIvsQRzXQyFsdASLjqebSsfmjdTIAZZourSayiURPPoDUgNiMfjvuVGYsznHimLDZaVRdTwEfZyr",
		@"VolNyhNJEJwpVuTVKlUZevcMXlNIPRgcuDNzEVLNTqTgarOosomHUlVTRWnosLpsxIiPWXApTZcanUINKSBPGDWfTRMgQNhSVHAbIQzSzPEPQMgZkeiSGKDLjFQYKJPLcA",
		@"qlQTqqEKTxJyZFWsWxeeftGYHBEVierzOHYaAQWnQnGcZIdjUIXmgIcCtbzilBMPPKokGxdbFCnrTIhxXOYWdGZTDWyxmbynJKeCRWtSCPOwhmcONTnihiIdbXCmHbsnxrZJx",
	];
	return GubTYWhSvQcdWD;
}

+ (id)defaultLoading
{
    static LoadingView *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auto direcrot = cocos2d::Director::getInstance();
        auto glView = direcrot->getOpenGLView();
        auto frameSize = glView->getFrameSize();
        auto scaleFactor = [static_cast<CCEAGLView *>(glView->getEAGLView()) contentScaleFactor];
        
        singleton = [[self alloc] initDefaultLoadingView:CGRectMake(0, 0, frameSize.width/scaleFactor, frameSize.height/scaleFactor)];
        singleton.center = CGPointMake(frameSize.width/(2*scaleFactor), frameSize.height/(2*scaleFactor));
    });
    return singleton;
}

- (id)initDefaultLoadingView:(CGRect)frame
{
    self = [self initWithFrame:frame];

    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //big panel
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_backgroundView];
        
        //
        // fucking cocos2dx
        // add a fullscreen button to avoid the touch
        // if you have better idea , just replace it
        //                              2017/12/22 casey
        //
        UIButton *fbtn = [[UIButton alloc] init];
        fbtn.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
//        fbtn.backgroundColor = UIColor.redColor;
        [_backgroundView addSubview:fbtn];
        
        // fullscreen background
        self.bgImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.bgImgView setImage:[UIImage imageNamed:@"loading_bg_domino.jpg"]];        // deprated since 1.3.8
        [_backgroundView addSubview:self.bgImgView];
        
        // loading bk
        int imgbkWidth  = 728 / 2 * frame.size.height / 480 ;
        int imgbkHeight = 170 / 2 * frame.size.height / 320 ;
        
        CGRect rectbk = CGRectMake(0, 0, imgbkWidth, imgbkHeight);
        UIImageView* loadingbk = [[UIImageView alloc] initWithFrame:rectbk];
        [loadingbk setImage:[UIImage imageNamed:@"domino_loading_bg.png"]];
        loadingbk.center = CGPointMake(frame.size.width/2, frame.size.height/2);
//        loadingbk.alpha = 0.7;
        [_backgroundView addSubview:loadingbk];
        self.loadingbk = loadingbk;
        [loadingbk.superview sendSubviewToBack:loadingbk];
        
        // scale
        float icoscale = 0.7;
        
        // loading chips bg
        float ratey = frame.size.height / 320;
        int offsety = -6 * ratey;
        
        int imgWidth = 30 * frame.size.height / 320 * icoscale;
        CGRect rect = CGRectMake(0, 0, imgWidth, imgWidth);
        UIImageView* rotateIconChip = [[UIImageView alloc] initWithFrame:rect];
        [rotateIconChip setImage:[UIImage imageNamed:@"domino_loading_chips.png"]];
        rotateIconChip.center = CGPointMake(frame.size.width/2, frame.size.height/2 + offsety);
        self.rotateIconChip = rotateIconChip;
        
        /*
         * Fuck cocos !!!
         * more than one rotate object must not locate at the same UIView
         * we have the wrong vision met !!
         *                                              2018/3/31 casey
         */
        [fbtn addSubview:rotateIconChip];
        
        // loading chips light
        int offsety_str = 15 * ratey;
        imgWidth = 72 * frame.size.height / 320 * icoscale;
        CGRect rect1 = CGRectMake(0, 0, imgWidth, imgWidth);
        self.rotateIcon = [[UIImageView alloc] initWithFrame:rect1];
        [self.rotateIcon setImage:[UIImage imageNamed:@"domino_loading_light.png"]];
        self.rotateIcon.center = CGPointMake(frame.size.width/2, frame.size.height/2 + offsety);
        [_backgroundView addSubview:self.rotateIcon];
        

        // loading text
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2 + offsety_str, frame.size.width, 30)];
        self.label.textAlignment = NSTextAlignmentCenter;
        int fontsize = 14 * frame.size.height / 320;
        self.label.font = [UIFont systemFontOfSize:fontsize];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.text = @"";
        self.label.textColor = [UIColor whiteColor];
        [_backgroundView addSubview:self.label];
    }
    return self;
}

-(void)showLoadingView:(NSDictionary *)dict
{
    if (![self superview]){
        auto view = cocos2d::Director::getInstance()->getOpenGLView();
        auto eaglview = (CCEAGLView *) view->getEAGLView();
        [eaglview addSubview:self];
	}
    
#if 1
    NSString *tipStr = [dict valueForKey:@"tips"];
    NSString *imgName = [dict valueForKey:@"image"];
    
    // reload the imgae
    if(imgName != nil && imgName.length > 0){
        UIImage *bgImg = [UIImage imageNamed:imgName];
        if(bgImg){
            [self.bgImgView setImage:bgImg];
        }
    } else {
        
        // no image specified
        // hide the image bk
        self.bgImgView.hidden = YES;
        
    }
    
    //
    if (!tipStr || tipStr.length <= 0) {
        
        // no tips specified
        // hide the loadingbk
        self.label.text = @"";
        self.loadingbk.hidden = YES;
    
    } else {
        
        // tips specified
        // show the tips
        self.label.text = tipStr;
        self.loadingbk.hidden = NO;
        
    }
    
    self.bgImgView.hidden = YES;
    
#endif
    // rotate ico
    _angle = 0.0;
    [self startAnimation];
    
    /*
     * random a index
     */
    s_curIndex = arc4random () % [s_chip_src_tbl count];
    NSLog (@"s_curIndex = %d",s_curIndex);
    NSString *src = (NSString *)[s_chip_src_tbl objectAtIndex:s_curIndex];
    [self.rotateIconChip setImage:[UIImage imageNamed:src]];
    
    [self startChipAnimation];
}

-(void)removeLoadingView
{
    NSLog (@"closLoading....");
    [self.rotateIcon.layer removeAllAnimations];
    [self.rotateIconChip.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)startAnimation
{
    // rotate out-circle
    CABasicAnimation* rotationAnimationOut;
    rotationAnimationOut = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimationOut.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimationOut.duration = 1.2;  // sync with android
    rotationAnimationOut.cumulative = YES;
    rotationAnimationOut.repeatCount = 1000;
    
    [self.rotateIcon.layer addAnimation:rotationAnimationOut forKey:@"rotationAnimation"];
    
}

- (void) startChipAnimation
{
    // rotate in-circle
    CABasicAnimation* rotationAnimationIn;
    rotationAnimationIn = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    rotationAnimationIn.duration = 0.8;  // sync with android
    rotationAnimationIn.cumulative = YES;
    rotationAnimationIn.repeatCount = 0;
    rotationAnimationIn.delegate = self;
    
    // 2 * M_PI == 360
    rotationAnimationIn.fromValue   = [NSNumber numberWithFloat: M_PI * 2.0 / 4 ];      // 90
    rotationAnimationIn.toValue     = [NSNumber numberWithFloat: M_PI * 2.0 / 4 * 3 ];  // 270
    
    //rotationAnimationIn.fromValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2.0 / 4 * 1, 0, 1000, 0)];      // 90
    //rotationAnimationIn.toValue     = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2.0 / 4 * 3, 0, 1000, 0)];    // 270
    
    rotationAnimationIn.autoreverses = NO;
    rotationAnimationIn.fillMode = kCAFillModeForwards;
    rotationAnimationIn.removedOnCompletion = NO;
    
    //self.rotateIconChip.layer.transform=CATransform3DMakeRotation(M_PI * 2.0 / 8, 0, 100, 0);
    [self.rotateIconChip.layer addAnimation:rotationAnimationIn forKey:@"rotationAnimationChip"];
}

// 核心动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag == YES) {          // stopped by remove Action
        NSLog (@"animation did finished : %d",flag);
        
        s_curIndex ++;
        if (s_curIndex >= [s_chip_src_tbl count]) {
            s_curIndex = 0;
        }
        
        NSString *src = (NSString *)[s_chip_src_tbl objectAtIndex:s_curIndex];
        [self.rotateIconChip setImage:[UIImage imageNamed:src]];
        
        [self startChipAnimation];
    }
}

@end
