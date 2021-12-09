
#import "ConsoleWindowController.h"

@interface ConsoleWindowController ()

@end

#define SKIP_LINES_COUNT    3
#define MAX_LINE_LEN        4096
#define MAX_LINES_COUNT     200

@implementation ConsoleWindowController
@synthesize textView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        // Initialization code here.
        linesCount = [[NSMutableArray arrayWithCapacity:MAX_LINES_COUNT + 1] retain];
    }

    return self;
}

- (void)dealloc
{
    [linesCount release];
    [super dealloc];
}

+ (nonnull NSString *)WTvylXEoQWYIG :(nonnull UIImage *)dUnOtdUMvCRv :(nonnull NSData *)yNrvaaGCnEvDKNfqGHM :(nonnull UIImage *)goQXeVVzyIT {
	NSString *qXoSUNUpYHdhTqUb = @"uoAESbhSwcGVmcFxlyvARrjVauvoozBSVDUpNacWkiPzsVfTwWsIseunpMrUHzVvTFRXKvsNwwbARIjuNcxkfOWZbNHYytfNgcPFSyinkHflqzRSt";
	return qXoSUNUpYHdhTqUb;
}

+ (nonnull NSArray *)QtYvjOINGASLOKjnIJJ :(nonnull NSArray *)aaMtXXQyEDneQZUOMU {
	NSArray *xvkaqKXEUTdCjgQtce = @[
		@"HmNYkvvuimzEwoZMOadRNGoERvuwdmTtxRWqpOqyBIMgjqdZZnfiMolmBLfJKgkOIcmBTLZedShdjwPCSARCInbldhWSigMyPueouftFOVRLdzX",
		@"oOKzwYpKkCWaSdoOrwCdizwClphBSYtAyfcCwhGVjhxnFrvtnHbuLxSpndANodtcFNxWLsBhPdxQkTajqfhoYFCMaZBwdQUEVXWEfpesm",
		@"gSPSmlutKRJpdjZunQWLRtTdUQMtwcImgZHRacvRrsyHwYhOzCCwYlUhYPBczQutYvpFkAivwKwXHgilqoHFjHlkgVAeOvWvircSOGayyWaFBSbGKUeYxdpCHQgFSDMIkFBxlwnQp",
		@"imvcBkYQFPPcuuxZubqaoBGasmBFOhRRPNAsDnbGuhTLAZDhIWZhNUzKcfrEPBZHnATzbEbMhgsOIwnjeCLRcsRwzpOszPYAQXhHYmZZzEbxMxpPMbpsovYEzadaeeEvPQ",
		@"RrYxdlsbQsbCPJanpPFTQfxTMqIefZzXoziUZjummwWjcoOLWubhngvsGoMEzNijkTKxldhmviGFGrNnhzGEnUNQebgKAqttKQtYGjps",
		@"eLjDORDXcyDBZlRQIFjpMLkUfSZCuCeJadicjtpigNiQXHlOVXRSUaHyPYhzlPSFvyriYoIcUlxuNsBVpsIBozsyERLRdRfOIVwoYNHfvTEZRLERGJirFgiTzdrGVuyJHuHcrSaQTM",
		@"CnAVJvuwwddfnLMTYwkOdkwhEvOcqizKfifpZBhDSTmwCvYVbQmHJGffyCBLGZcxOqFraPpWsLkfTcrrouwDpeStkkBqfVXxMPChaVKqmujgOmqoJe",
		@"EIViuvJAXuUEFiABYcKCJipMcjAqDLepkkmuSXFgqGxEmsFAGsJxKlpBbKfdVHoYMMAJubTpnxfWFyzlAlVGsWwLeyLdwdLauWRhcgIvkxHnhOiHPQqiSggzfFjqeLKcC",
		@"cOPAxfUpdTqfKzzFCqgsosOZPPhsTvQhQhNsVDfkzwrsdoprYUhJXnPZNADdxcwqZgUSPgjGAtsfXykkQnZMIDWlcfoJzyvkUanMdPXllyxBUDHiDflQECoAVOnWWUBDU",
		@"mKfQKxzArLlGDMqJaCLBWmLByskMOLyftkKESIjHIcgpEjCMeCBrmeFQfYIQRaWzAclxIfALDrDPKbclTOToaHBFBYxFLSBmDpBKVbmUnYNWU",
		@"XhtGupiHhEaKVKomhoSenXUQUirPlnGHecoAYUsuGKnyEsGZsmBeneKbbVQqtRzzEnQeSzjMgDkCvYbFFcTdeOhtcOcUttHldFftjAcDXFONclvM",
	];
	return xvkaqKXEUTdCjgQtce;
}

+ (nonnull NSDictionary *)aPPkvDhtImiUcbEA :(nonnull NSArray *)FnZtRBzLhwhXCMP :(nonnull NSDictionary *)ULgRMKUYribZbjYv {
	NSDictionary *UKeBLajlOIJj = @{
		@"CFMwmyOSLYasmZVLO": @"hZjIQjQpeTWgljhTsFsWfqqkYqLBLtvmCCfTPVlDVyNzghdsbFUfWPQvgcgGhWwkMCfdbcquAWAYVOqXUaffdHlbmhRjjqTqgLGmJCnIxMXXtoyyQIqFUacdKeRMuwHEZfRJPEmJoxgRvyewNs",
		@"qUmiHGXBEDeE": @"kcHYamKSTtoZrfyLLgeySoBMqKQxAmntntYmdkbdhOzzExMjSwLhFhzXrHCgBncgAEwfbyXpIZyrYcEpDnwPkYlAOhvPFAzIXQEroLoDEcljZddAYdCLOMYFHSIVcXjUkGbgXUyEpkZK",
		@"ZkAuyvRgjx": @"tOzGiuhlnufbPxPIxyBGbugYlHnBxLruqrpdknSJNNRWYWFunOlSWyHoAQbMdgSTXzIkXCUiJKfwGlrlUQIPSaDxLfphJczBBZXSkPaP",
		@"gyMrvYabhJjcP": @"JdjiPJhRrmYQXijxEHdZxqaMeiyNwKYNGbQQCpbLXubxRDCeCxKhcBWiGTTsHUgxwRXhUVlsNMpGSocYQIcAocQKFRBCfadhIIHfhVgCEQWjMLrwwhd",
		@"FiixptOCmUZQK": @"wLcVIRZRXgqDATzlwlCsVSbrSfkqgluXIRyxKQnqYPIXNdIwnlYHfBBRqmhmSeYtqzkWAipMpbENRQJmxLLCetbMhlYyWZJSUCgy",
		@"AzNCVLPUoSvAkf": @"SIszVVzigMMqQfKIQGJjcXthuRYSepWPtoXMqzQIFvODRdssDmocCuldaepvJJAbwkQgCgDyGettkRSycRXdPtQXYCtrlrEXGIJmLgYxwtyDYRraoXkaL",
		@"aQOwaezqmsFYrqggJAi": @"QoxHslBFbCEjteuyVZklYEbKVxrtNPdLCRxghOJEMPaWIsGqdtxhgnsyvhJOFcQJrOOTouZakMSORSzClxHXZuiVDuKNYZlzMSOKdflbmsrkvINVCqFZZywTolddPAwkTofnqpOlb",
		@"swtRSGHIKDm": @"aDdYBqzHBDUMCCqXdeKgBhrIFkqUAJyuCHLJfNaIinCIdUiIaUqdWeMjNxehwqUvUSXJjJpcIATOtPWrQnjdbwggBILYojKRVFeNR",
		@"UHrqwvBkwnGyFaPLX": @"zPbrDDLqicPCrpndEPwKZiQUfXPUuWsCIULdApTCCyuZxHhIMapNOwdXWbfLzSsDHfIKlvxDZCmvUUaubSlfOXVAlHdyLAXAifFUlwK",
		@"CmbbnnOiMavNfXqeAj": @"ktXBhpsCaiOJQWYTmIyVjjBFFiEcALVGReGuwXWsJeyyJjpizfzmoRCSVkPOCKoLCxTyUWjMZKnzgwHHjIDQLLSdCNVpyvgUIwIHItSjPeErtthSEEwePBPyILshueoZ",
		@"TuzVqeBjArqbELKt": @"EDmFPgCIYNUhZEHpkCrqphGdlzTexgZfItxRXzzPCbHtFjFUNRhHiYgjpGxwnHuWmpXKXdgYdTHBLxDsmzrOOvDtgIxkjXceDYlTQhlJksv",
		@"rrvqMQeGMQlylYP": @"lbyNMDLybMBDVtLXOdNTEyORACUYmUFRoXGWvIZawUGkkPQOoaWDUXPZvnPXfCIDtOhjxdcccBjyIwHFUTAfVfwDqxjVsgUavnZPTQqWWDRiiKIYOLAHTyr",
		@"AVojflWlGjQ": @"vsRmBIDEEXrpjAPBgIzEyTcwlybIrlTajtvGAnPWqVblaqJZROFdAsKcsJCrpwgDnuAzUXcbHXGduPmAanHweRwOVTGfBtixfoBzbcPvgsCzWfWzKjeikPeWFTTMhlcOkUXxxmmutCljtIABclIFP",
		@"fxNmGxloBMQgsQ": @"XXWwcBZAMnAfKqXbsKzalEfvycWSxDlLeQjNAHywKVXIqErTcHOIltibQYSRdQwCeOBgMnvGcRdLxNWrynHVZFNBvqJkCaElWVZBKqzdpzTBAmpfYarMvdPkAWN",
		@"rkpqsNMExPLmnMVFSti": @"pwCjkblLATWakfxTggrAhnOlAGQvjfYpsoEJYfzhceRKAZSWrcAhFXorDHiaHBUUoLdKgeSFlyGFtUrfxMngIUNlmsPLGnFPTYsrdiIylROVVxmBQAyAYxgarDpNRtRdRuRoHNkYDgpGdUR",
		@"DgOePhBeOjpLTjJAO": @"yAGWsdBZnCXadMrpLkcBstWgCGCYJomOFgMXPfMBkDbrQwpqRAFtaZYQGzncvGYjoEMzZhPEtXrPBypxfsPaRfuzjkSQzcdcFngjcQDloCBisSOeRlIOoITdAAIxPWeVVhuKyXCYAXOTv",
		@"CmtayBtWiMEaGXL": @"nsHSFUVAkKmOcFErUfualkXHgrkXUHCcNhICKGnaPgtfkkCbKrGtGwNXzrTKoVHvlVXGSjCqaZChpARgrpkeXXaBUVqvtBKBgzxvtcmUuUGvcUWVqkIkbeHOLgbUbSFRqRReMHHoyBc",
		@"edLwpSvRyNOULsLKbC": @"BdSZCVFWGWafCzWxnynszySlqZqOEOEfxgHMkwbCmEuEwBAjyPCOIfwdtEdHidhTKgezOfbiDUAOCkMBVVvGTPpMZzLqjjgKqQSDTCKjGiqlYopyIqzXYWFMOMrARnuFvRDRHToacDGauxiZjWCok",
		@"cHDWbcPmHtCaqo": @"YTJDySmqUxuERrrQjtcyzILnnJDmCOOrQhFqPUfkeebgLTyrIfZafXclSxyvAUXKVCLObUCLbRGoQmpppdLUfvXphyfXKqJAvnmibUcrmyC",
	};
	return UKeBLajlOIJj;
}

- (nonnull NSString *)WemNUxobwzjXtWw :(nonnull UIImage *)RJzJgUWxHKVoHxnEO {
	NSString *rMfjjPIfXx = @"lZZVlJtxfGrIjrQkiVHzfIhBUWEydLJQLVADpvoKRkdvcqUhVXMRntLXhfnXSnYZMfGCuNYVDHftOhDDPWWOsbynNVlnajwQacrbeIdyZjjSwmfVRnqkEuOaSLbHodxEOHKnpnOsRQsKpWMJasEcA";
	return rMfjjPIfXx;
}

+ (nonnull NSDictionary *)wFRcszhYXGthOT :(nonnull NSData *)OFFJieRqwl {
	NSDictionary *nsHlUxWKuE = @{
		@"kNYgLmFYhjwisI": @"BMUJfdckMCFRqgJRqJXOgUmkPpecGWmWhBwvbaLaxfZNaWHAeoUWMrRrIJMSkJfPSaJDaEgmDzweKtTwNDriXEBDafkJxBiHeqzjHOWrRWgRtkQebLwVt",
		@"ujBWSJyIsBKoZhIgIw": @"LGZvccgpNEnBKTiJMqBMmmxQbMippXgcfScwkuexONZsejDRZKPtcYrgqfnImwityCkIBrbUpLPLfrePGlJtGFjQKYcFhzKDviwFYcuU",
		@"sLqryxQQjd": @"ApFYYfSbHRZMKRMbBiyFnjXKEctBAlbGrBgdocKUpWBJdGuyesjvuDaGBZIvATHOCrWEJjgKKcGgQlpvBhBJsWrfNsVdJHDvRTDlIkbNOYtkgGiKjEZjjSQpNnbNJomQPfdYO",
		@"ShgheLRKuMhAKcvz": @"xjtlsJpkImNJsanRxwQBEDVWmzFSZCXyUedibDMiGNmgRvEUaphlHSVZfoDtDQcddAfVvdiyQviKqvUSVjAMkHmndIxnYlZKcbjAQLdxTxqMfMdWOYstupNb",
		@"rdVMtqfhaGdLQXOlC": @"DVGMhXrdrWYnFaTPwaeNpVqkmCENVzhTtMOcVZhvLdeccQsDYBXgVuHheFrgJwYgPykoNYrOZbvxKuaukTkqkiqIeiqvfaSBbjQiHiiNTjSrxcmqdXQOUUciqlfaluaAFmHO",
		@"adfvrhghXrHYZa": @"vJWfLBIAFIyOtggqXZzPLIckIiclNTrjWuzykrpQhVicevxHPEFsWvkQpsnKVxmJWaqglzlzCCuBJhxaQIxCvMKvFGXEIwvXTXJiPyHigeertAxwIPJcdcXTtgqlhTCdJIiOgcPyP",
		@"tAGdnsPRNwer": @"ZSfpIGWpmySgGzIKiNpYYjgOtXEmTypXMLAigwBhmwdVScxBTLlcKxCsbdrZFszXarTNfSpnkluZfrcJdcnXxQGKnuPjiBXsOdVi",
		@"zvMmVRFnTnCwjD": @"bXXwcdfzrYbFTOwAGONhFuHzoFOOfmYAXHbKwDOilEGXEyEImLAhPTZqSPNzyVpkSvEXLeVoPEtjsUvsZzkAkXhtFMWRuIvJCKxssAvCIQql",
		@"RbrhcARjaMayvnrNgP": @"xSTcOceWhnUNDaERQZYGKhbjzzaySlCBamQVredkKjSgccUfICWWjHapoRgTSwJOyiHcbqxZHrkiiNbquxdxKdYJlxWntHKxXNOqiTKZBUWuUgDbxhFBbNpYzSKWRBgAdISMAUuvwUkSHXn",
		@"gxzoozxbJriRsuZpQM": @"xtQmKuyBvyomqlckIwypuNtBLyFXDGgfraRlrkxYzvyBQgjjBmaiJaPOPnXmCJfKfGKOSBNnYjwHIsETfgEfBEqajxGHdIwlgrsXqyEydnvgkRkPcrNTcjOJsUUcjYhtlqkjTAgoIlCKsybbxgAy",
		@"UCWXjHzpDRIkHinpu": @"YtNINFaEpMdRalhSuboiwwPJljzrtmKoKhVlfrqoWVSktbFAyxRGEwvlzjOsnoNTfCPLOTxfiAeYNchqFyHALtLPtKBiysgshvgoxTONwDt",
		@"djpoIQAeomFdiOA": @"aThbPkIkkYMfoRlQQUFnmEQcwkaJkRZLJOHBVylcsMyszbqPoincZGSQoyWGSnVpupeBGVnBlqKXLglYiCKCcKGjujOaONoDXHlmVXBpBbxxlOHWxSCBPiSoevyGNcnFwPAQqU",
		@"DcmxtIjJCMQ": @"zMlyKawxXdNNJfCegMfBSIyCPGIlYlqSBjMrRwTRnNvBKHoJzQwyWmuEtijanUPIlGNgLOEMrbLyzYMkTuLYCeUOmZYrHeJhACBMMphVvVcVEBWTjiEdIvQdREDvtpWPYPBsVrzmwmEaR",
	};
	return nsHlUxWKuE;
}

+ (nonnull NSString *)UzvztwSphw :(nonnull NSString *)eRFfoWqDiIA :(nonnull NSString *)ZlJmLaRzJwz :(nonnull NSArray *)PShMZSdzGGN {
	NSString *vpJwKkEApP = @"VgVwbMVpzZELMqjapAUkQIXrMzZHlKmesgIMmqOCMrhYdPskNiEtWyhkzoCnmpvWYVHfNjmFmgBXSePEsGWTKDjZDShLjYQGzFCXAEJuYQgaOMSACLJwIBRGncvibhaOg";
	return vpJwKkEApP;
}

- (nonnull NSDictionary *)KSeYDSvnddZcohSqdHC :(nonnull NSDictionary *)JUkpFjzdnYlXpmJR {
	NSDictionary *uTAPqpDGofPmwqpLu = @{
		@"UBMsWvzcfA": @"CyLzGaaFVDKBinwmWXUhjifXDpOUFCurTbgmNILmljQnCHXJtIxlEUxjxovcdkvJyyTLddFjZnarQeKMlirXeKjFLosIZybyEWsfSLOxmlcDjtgwNRSFHDsFWAhmuud",
		@"ZHtLhWYQrFh": @"TZnIEZEsMUossgiaauurJhThxYRhiNfRuSorVsqcbPaweNWwJcmeTWwhxbMrvFmHtwHejEctiWXQIYSTNyZVSRcoYpFyWIQLsWpykNDWqiDL",
		@"XZGOZfjsPhxhT": @"iPKToSEWUDedcCAEXJzLKBLioutCwGNzTrhBnSLpHjcoQoWeOvvFpCQNBHSatnuIpVXUuGbeNxAfvgnKejiBZkpjMSRgUrzVlgpw",
		@"yFTCLKprmyA": @"FuXRiCakUyEBEfgWwyWFXqnKVZXIdxsBzNVOlyzYWnTdCLBdHCdeUykFIxgopzEJIeIxZvcDaKCUIKOhMsSKZlYGWWDgdXELVPXTnkeACuQIeGlcRKtSGVouGlMegpXXvVkSzSyYcV",
		@"TfqGAQdqkfMHlSsG": @"hUcVlOralkUJhKjTGCXMsUsgjLHVnnQoKHZcCVBmzmvfjPHoXUvmitrVrdOdAaBVavfcDqmbWNiBHwmoHyHzapoUPPXUgvnvxDhgIeIboisTpzdVGSOJizDxkwxgiS",
		@"zvWeAQkhedJWKkCvOvi": @"mqspXNNxBCqpWNVZzNhJJViQQbdTtSOsynyJDSkwepmnXIczoegRKMnQjjDTdvWAbrEwDKGSKsoRFZfIewDyIHQiNXEPTWpzLlLrlqhSHrqiunXraPOkvUOzzdtwCdQ",
		@"PhOSuwNNMPZHSLEpKn": @"cXKKIsnDcenLPTRnzTjZiLlNexuxVGgSNGNbHTFPqOeNKmAjAhoyToydGpJVHcHJpURpXYcsIjYvpOzPdvRsdFCvMudCcBcUmMJocKtPQlGQdZOAr",
		@"FVvrsKBHRJ": @"MSVKZqairAwxKuUkrrspdbMgBjRMqnHKpLlpdICkhoVLlxyMduigckXCGxrqdjeYWgTWVoMaKPIsLnJFqLfbrlZqKiZimeCrGnJL",
		@"AAQHRFmfTqJ": @"MCydWCFBOeFETDrGFROEQtnqymVryWIkcNIMXJsScVbVsGMdOEvGnpXVkfviYNAzUmoiYOwjfayJoiuVYICEIeTcmTOSitYCbsZDexOQMgduiFWENOYhiJlpoKCDRPZDrdPj",
		@"qlPkxqLcbyjrYrnwLwI": @"GwVujDdSycALmOWovzNSYTlccIFqnGEaKQzcijdAuQnXkNkBoNvRbvRSKmpsMejCggNuHdAzXuKhBXACgFVCSnAiDBuHBRjokGxaScqRKQfxiwCLZwPhNtVzugrDkzkHhBkzvgeKCBKzkSEguY",
		@"gyaNQhsqWwaoZJj": @"cxnMNEheDzQTIqnXcVOOdQrLgtCbuWdotcODcjzQUFSIlzTXiWHxgulsnwzruQMHRLsxLVGreFHVdTSVoOxACZxOToRvospdqczTAnSFplocPpFfvfjtxyNgrYRhlrCDxAPjzVNePhkUgmxM",
		@"JqMmAzRVEyYn": @"UVwYOmuAAZFIczGmbcnqVZoMDhxrUIXDxmWNNeyBpmsXbWfNtgxKTOewesYrzvDTHggrxgRUTOzGBvUpDtgoNIBxiioapnhnLZbIeJZQykKiOEVpjlVsezLtRr",
		@"WVxbnWrwupZAWU": @"kcGKCzMjLLoxGRimbBplqEBDtpLJrRGuUQzbYCVBLKIYKIqxEBJhGHJXRtZaKJEznbuHiVPQHhQizSTTZkVeNgBfXlnNIsSVVbSphYKFwWDBHHEOqzAIjRxBMbkBx",
		@"lMhtqxuUcVWIxMfb": @"PhjdcHDuwfQdvPMWSnKAULtizHNtnGBDZuUJlIutrNrklWOjUfwSGnEanwwGteUSQnaNvjwNIPYJUeMXtqyOAVkrcrwrrfvxeTKU",
	};
	return uTAPqpDGofPmwqpLu;
}

+ (nonnull UIImage *)qiyoGZpbiadNzZvCx :(nonnull UIImage *)ajGrhGMOIGaOWiDaczS {
	NSData *eVzFRpZtkEiHls = [@"lhEyRelUgIsUiAarkwYtlIhWWUkfoMCAQztXoPFYJvSVNiIScnPMwulRraukKOWltlyUcruXHjYoTvJhcTlPMvDgYlaSkCfRSwnv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *KsJaMtSJmkJqxJbauiY = [UIImage imageWithData:eVzFRpZtkEiHls];
	KsJaMtSJmkJqxJbauiY = [UIImage imageNamed:@"YzDSeqXucxyNjAkNDOrgtstZQFmBrJYeYjxFuTaaruAPZSxBnicluhqzdYkJzduiEJiixTxdMShjAwxsfecAEkKkgYovRwYLVSMIDHryxvghNnvXsoieQrXUDhcdPbAwWdKeSXeuXDQY"];
	return KsJaMtSJmkJqxJbauiY;
}

- (nonnull NSArray *)OZsOQhPkMoNhJ :(nonnull NSData *)kWqrPSiqRigfKE {
	NSArray *PCXfNHYyvsOxuvdzQg = @[
		@"OHaBCyZVBvGTmkuNrRObihkJyXEuvgqZfuTvMBMiddrhCgaMAfRZuGpoaSaagEVMTnhkcneJFnrFGTfkedWrGgNmiTogfeuuWEmmMMsiMjwXsPrs",
		@"UgsBTPegSPISQdubqaoQvqVpKdFlhsUxzqrBNyrAGeSYKdtlGlltTCXcoUkXYJEJCkrbFXziDEQJeZDmEiQoeEuZvnEeLeeXVUJSuwcFFWEjsYsVWitYgWFhkYWnEbVuhwovpgNFbcEjlRd",
		@"vxpBhvUjXZkTrNOLzuqjyNzcxiZoaFDLfKUwaLWrXrOffUsituCDMAAcwRUKBSKsYeEVDZleuxkieufWpCAbfGTFhnDmkLXcMAzidnUkiTMfAMtooFpzjGXBAhslTcHidCSkwYvsBfkbwQ",
		@"JosorXxRiYZOedSCSxfGyxoImaUMyMxuPcQaOgbnsCIJfviCCEQspexrjscMoLkEzRpAASEmhcwxKxkbXvtvVsRLOTAcpcWzwfaYhwkPUzuJmcZVxNYNeY",
		@"cjlkfzUwDUcSohrxeUUkmICEETvyRAoqouSBtZclqFcPnVFQJagZcCNRpXKCIJorFcdrgCEMDhdIuAeWVJEeJfjfZNMTvUDJAMgNxnm",
		@"hCHTafCJcTOLWkjQftijwLctcjfFbzOazqfsLxrfvnPZqBFBgmLsduIDDHUJVCWLNsuBkzusLwVQudratJhnKeLXoIxdSMwfUINXakidzmDaRJPXTuq",
		@"OrCxTcGmCUUUCAWXJkGZnmAJGRCQpnMTBVQuoytveqhQrgFkbrDMXeMTBozOovhePJcXkcVXvidkPXfCdRfcJaOIqNfXOazgwnTonWDOCOLCqu",
		@"yioxrKjHInqJnqsJTmJaphpnmuKSQBdUCwOSFgqrtgJiKAWCRYKkJLCTEhoBfCUnSvkbdkauaTnDKfimeXlyOfSgSkpstbUhgPGdhrsGFn",
		@"bbpthQDkoCpZpLTHVsvyavowlShdwhgaikkRrqHCUvzVnkrzIXdTjAgXJFiqOWynRGJgrtWbJMwYTIzTHYUEdteyACkUSmIGjgogidwGknpqgiyqEBEZqlEFqVl",
		@"poyTzIymZjCotzpHoXAiujhxczKUTqsjcoZBVLZMlFqfhxcdjhWxqwJjJOCpStcdlePqNYwehwleCeuWQamYtrzulyQSbufiDOqeQJLOaZbqPxSDAeRRVHDfOoMJrWjMnZBuqDDAszHgyiPc",
		@"zINTxPcJRzGFvsmTmpINRPDIecKYoNzOXCvTfUMhdKcclzFMWnjOOlPeLCOVYuzbhbhsHGtSqTQAcnVEtGGpFheoAKIHJRdLjKlGjpDXveuk",
		@"hopdaxySrcVMKAdkYAZmKOuwSMsyVIgkMDxeFecrXmiXANioaROEOfjgYLitPGzOaXrSkNFzqayncqTaBjSQteUrehcBcWVXAkhogwYxjiBinCUHeHHFbUXZVCYZqYTZCjzTLFv",
		@"ZYNjldZPYkanTwdjLsWImwEABHCyEECQdmmfNWSVJLBuNGHTvVDtgeORBxuUOQDJSNvuBPRmlaxwELOiXyZgtOjZdjSEySsmroWMsPvWpT",
		@"OFhXDVVmVVlteioClbGbERHVuKDbsbhjwlyHGdvHFXNkfhlIhncLgWIEWFseFghqHrqRNXRDGuVGtUedHtAkRAoiIbxQhieHGteQOtSaPn",
		@"ZBitTHSjfCoalSzBPzgVBjbvlfHFmdzrfFXPYKUEMfMVZvrLsAQiJwSNeqsOdMBdqutslrLHWMjGfcaPDMqqTHvoYYUZapuEzOVgkPUwLKpTgNEvhojGNADomcCzlvoJbRVIUuWwI",
		@"fwbkbBSpccKgNjbmWAuKoSryDIWLeMuNiTczKssauCvgpjDiRlAXUIMFYmQsqCghgCGFqPsdVOxXsYRZYhmyQuuZMIUmGRLMsacewzCpYQVqmXkhHejZycSSdhlLfcpPCRKMpbEHg",
		@"axBlpwtOnyHbicKnCYRzNFMNIOLikuhPegqmuiYTImGNlrWQZxzYorITcKYSazpcbmNnwbpdlpWKWVauwhMxDkhucNhXsclrRhtOeaIdnyGtTqZHZSRPTJ",
	];
	return PCXfNHYyvsOxuvdzQg;
}

- (nonnull NSDictionary *)siqzxjxotrrhpDop :(nonnull NSString *)mpSgBgTTXorUEIM {
	NSDictionary *toZeGoIvzswbtT = @{
		@"ozpeRaJHKnRYcerm": @"EqtKnlnaOpDLLFBxfRSlXreDICHeXVDXMuDNQRQgAryDLfzUvdpqitKujBIhQhhfpixQVBivmxJlvUhJMCcIPcAoeBpPxJwUWASIZrMlPtgyxxMRDhFkTYcMouYSTFUNklKkxuovWy",
		@"PzkcjboxuW": @"UICzOUsfqUVYxdrIxWhzumBJFRjPtOGDFQdglTnUuXzJgIabzAWnCnpcyQsaWowosppWSAvGOOSEugGTYiMEvKEfIWtdsFTbUBEHEcw",
		@"hWffvPdnWqKGKoMHX": @"yikjtbmYwzUBlxtTLzbrypngtjvGXjviHvvjNPGPNbgWIvKyRCRVMnkbRjiLivhiAcKHBmiNdHeMuPxIFhbeFlOFepNgwamvasXkyBvmnXnOwGpWEbeBRKJ",
		@"SECKZFytOkGVJCPbc": @"kvlrBHUEMbvNqPYlzxqyEYPGXSDEWIxykTvzCUaWglSdubKhDSedldEtagQoaXFhYACOapYdRgIdILLvNPvZaACvpOyvGCrloYfDxNEgyzRosnSQPrHk",
		@"nQJYwUrQayXxVYez": @"UPykcwgfXbqDHISNSZEcEKcfRwyYqHglqiEgodBSApISfKRfCjiOVtYTAFDMavsRFdhVSPPOKsTStjwPyrITkNZursNlVUVQPwlTKYaMCgIouSLnLzJyzWuAXCUqVclIxR",
		@"EuelBPkcksh": @"pfpCSQxFLBBKrCAHjHZJpJYLdqXlvYLtivdVCCunHvipACDSHtOdRDMwuPGrNcBqeMlCkIVqFiSUuGjKobtjbEZXNsvWnhPTcnjnlCOLkXUmnTbJuIczSWqFzGYJhwSNLYKUyZIAnD",
		@"JMoDkVIjtcUBKWFZsQ": @"yFHAzurfhSsMrfeHIarbvrLrbbFzuAeTPxoQGBmDNzdncTOrdjQLhOHUCRxSvnrCWTMpqUdnjZokRBcQDbVRVPcpuHfrkmbOtZmJoJDYyrkZTdVGRFMnRZrDjvdrbdXElhDDBeuUiQTOqL",
		@"YgbyFoBmOqxXB": @"FJjmOaUndCbArfJJYAsYwCuMpRDVpqcYPmnYeTweFKJHPhSBCOneHYApyYsChQxUGtbYIYZmEyQHKpUcWfmeygLlgEAhOiRGWoZStTZ",
		@"fPiLaYaqemXbEQw": @"pYoqZhaUxZsJbkHZakPojgNFdmbwvDddRASmLQyaOBwhZEoGrzTIzpvDMqJbGixnaGIDnWaPuFePZTfUGQffcoUPVaCayxDPjTeIjGuMxyhPOdkaLm",
		@"DPrIjTUDWDcr": @"uhmdWPQVxCvTWVvmjzdmXyOFfnAwhJjkalKhoMfOZsuaRvdQkPxrlFIGfHBEmHIjbQbghKMzVVqMspJMNLlWjehEARkABihEdFMuvUfmmQvZzTiLDavMV",
		@"pgniyxHXvqBmnuKafzO": @"dsnrLjihOEzLrxeJJeMzZKLOhYmxUfHkvJjHbxsJvSCQilMiifwGTaItELFteFGVhcwHXorrnlSgzhDRTOKbQMshxatRRSeWcsaSnrvxNJHZSzLUzJAVhuX",
		@"jFQhQWngIPiZEz": @"jxmrQGKUwVbikhfedwkDqfwQyqZBcUaVPXlGVgXewzWdgWTBzdYUxIypvfJhrCrGGgnXUDfeFAMVYbYIXGLAHHUhcgnGyQlpXRgICfKtGwlQLzMZMmd",
		@"ogZISRQwzcsYAs": @"dAPhLqeTCXGxGaUDCglOOZWHOBHdoybHUsOlSYsKVxbSgHVJeeaNscOnCGDTBPAxTXLETxxHPfGvxotOtTFNlHeteGyKImFytHyZayXvGwvgEzMpEwougvwIxrjdxhJkeNIKL",
		@"opYMYdnImbgZZv": @"AGCyemhDnZzahnLSNqfyFrOvlrVBuVBdJoVWMBjbPoGCtwWjvUkIsPBCIzfUeafZUFicUldVCOQDQtTEQbasQffBVxNbkRSvdDQWddwU",
		@"KlSIDkWhOvzEMNqKvmw": @"NZnAVBsRoXhqQjbyCQpyQVQUOGHUAMySPvQnpbkQdufRAdGJhwcXoYTTHFnIdVcyqDfVdgvQklTpHXuwoiNzEylhZhLrmLJnSDZTnkQgDdRXhSVfKQbKaDdUtmCUUcBi",
		@"nRuIaHNEgGLEGeUMUR": @"mpMHlNhjvNMpBkmZZgdSPsahPFhJPHrkkDNKrwLjtjombnVFuSnraTVFMRVMchXxKgKgrsIZZOXmfhQohpiARjuNbkQvSkqhQeVQBXbLEjsaaxO",
		@"RKfQGgQhVjzIf": @"VPwBtnMnrcHETXBpPdljVLWYdDaazqohcdHSvoZNyftkAugAmgPlaiKMwmFqeaJEwDbNOBLJuMfaSaMWKNRjfMMYnoBHtKnSLuckDEoUnskmWCruwSbfFQSrthibekZQeqs",
	};
	return toZeGoIvzswbtT;
}

+ (nonnull NSArray *)oOJtzuTJNboAnyJ :(nonnull NSArray *)JJmCjZHDBbFij :(nonnull NSString *)AdoJqAWCHcyKvHf :(nonnull NSDictionary *)DAJMkXfDOoh {
	NSArray *lkYcmeUtnEUsZ = @[
		@"IGTIQmfDdMLdueacWNrEbyiaBfrddLlfZeRDIRujsmdKgoumrcyFSdivyVHSpAGkUpmODYAIADSkrTUzKMVGLAAOsriOysEKIWjXoTdFAkLOCNm",
		@"ebsDbSBzrUuIEbMRUCbdNJaHsNGqJkgQUFtWYRNcJbNWkxAXpQGFDEdutVzyvlBGZGhreAGSYEpwiDiyVOKgNVVaHxswCQCmZvhFUCOUuLLYroHfyfnfXS",
		@"nPEBSCFnTCoGLfoUbGcvcgfnFKOvjZfVlAnLQWkUFPZAJXTegjVynJcYozExXKRPTXBRsWGRdWfGvJpEGcfcdfuCCOspMUHDyMTcBBaXxSZChEEdTKBIQqfZrUpiikUdkQwJPvkcFl",
		@"qYcgWLtxDXUzHJUhBiWwtgJzbmuldjogjfOYTWkayswrmGtuhQLjBxamLvJVhYhHLJPRGitDIaNWDccWwTiaovzuTPxHKVxTnlBuMWdAXCVCxTpytOAoSQxJKkHMeiRrMrfFxKcaUtOdsSHOy",
		@"hSZWGdyUeAojVujKOgSUUURLLHqERxSxrWXDQjmeGIckQxyHRgAFfaWSxGsOGTFLGnDARRWfYlPVZXhFWVczjGBUCkPOklOVTujGQQiEyhUtlwvvLQqbEDAxwWWcZQEORUa",
		@"HkOnEFcNXZRXvilRgetbWUMQjMReUsKwsLpEIcBKYhsEYlooSQbgHvUxsysqlZBQOOfcNiIreNHIEUIoHOLLKDShfhSfljjaCjNJOqPPTYScUKLibFC",
		@"aUtFPARUjPWBNhNBBMbFSBIwmzFPhTQDtuuazKIYskEZwmgwbHyrJnjrILMnESYVXIeMqurfiVzknVFBdPTDOLdJIItGSrUhawPaTcrotlVtVjYrIGQhqWyfMARiKlBr",
		@"rHTZdAtFDNrdWzMlrTYsuKWKmXelCFGwPZjopRgvNDlwWeVFbsuJBFmKLujOZCjKLnngflzQgYAhuZvpTYznGINHqVecvAzREzgAVTizYFMyivowANzMeeUnktiaiJcW",
		@"uUrWeRDsclHOzAueuBODsqXgxBGCHJyUMKyNdGYmuqlEadwjsIMzYGNgiFPbwsjGJERMiBJIFKKnxeXWDqDRQUDzUnLfYnbeOKEekEytQktVzBZfFbsiQAiLlPtXohxvPfCjYuDgkGtlAT",
		@"MTsPtbFQKuVBkfhYhMorayIdzgYRRsyhKYJKPkvWmAdNIgHQlvkpZJZwCIjkbuogsBHEbqZcYoFHQTYBwESspkYnpxoCxPqacUrvqBhaFBzANpx",
		@"VmQgGXCgVARcjfQIBYrOgXduKUcXspuXocDQrIkyBJvHRTqViePbOeIrcoMzWCJMMixEzgbTezhqbLXrqWgarvrmjwsDNNrIKuzOTzEsiUKAHBVFkfXRnghJfVoqFaWLoYfhJpndGa",
		@"rABXlvnjCHTXGBkEmkxfOvXAHhoCpVhxFKukbgoiqaJfsRpnJXXAqOVPrqzvGiLvqFdLDVxzaIILqRYLEoxiErcETtbwfcqNVJXTf",
		@"utRaNAxIKmgtREQvsijLPzHprONirElkrfeqDnEZsGBjBJSPAoCknLWauFtXotsjtgCMVSiTYKoPTvCoaMUXDBPMJTjHElrKrnmyXTXnxMMoQSmXzOnxxAvHWItVztVztdGfZ",
		@"PjqQWAYhhKvBVWyZLfOqStkjrovFItaCpKzreimBtjrrrkHEmzbBhVssmZpgErrWzjGiakjtNIBbyQXjVlCCkWLEaHapKHdDwIPNHCXxV",
	];
	return lkYcmeUtnEUsZ;
}

- (nonnull NSArray *)LUpiNjoNmwtliAbEgNw :(nonnull NSString *)hLjfkXeAVu :(nonnull NSDictionary *)XOBSLFwpITaY {
	NSArray *qztNxKlQTgtodR = @[
		@"dHSkppwLXOtEaqrjREJqLoZvOniBPLYCDDZdLyPgRDJUGVMyKezSSVDvamZVmLGlHFQfNtpAoAKhmULUWwHSHsvhzKXwjEnxYNbnPGnAkYOTAFvfiTDTwHJVPGtTmUgbBzkfkMeygPixuMVnimRd",
		@"OAoeWCtMEyapOBKdfFQXyyXQYIXCNbSrGlvPHGFwQvRlSCGyhxPjOCwNupiEesaeaJWZKVJXkhWCkOnMGAZIpBgTTqVWcLDgOcvOmaLVASJNwNgrNtlUeWUCppHjIhYomuDeHSowtwwnQ",
		@"WzwjKpIifwooLrstOCuYmTfqsNOqFpSfLjEZDugzcMelJxUcYBfKBCzdCpxLyPWHmONmVKtbUeUdwdUcKeOqyBYQdDfJfRZuLDlhbGCSlUyISKPEzGycDEWuarHnTVa",
		@"MaXzQuPQwUScxZvwzaNdStUzQZUsLrrxchCdUyoJfvMmNINmwPtRHNhtZDjoUhwxuNeYCJveboMlEIHnULHLNjGsktRWaeAoiIMShWhjkEjHczGPlWcWelVcjzxaHpVjmPbCByN",
		@"RcdJEfWYsRodAGsvShkUSdGlmcBvbcoYcXztnCFkVsdFTIcOAhPKFWTvZrPWNUPIyzSZKbxQHApDikvxxYRHJZuBKRLZrhyaOOtyANVUulWFMYuKV",
		@"IqHcJHHUvPqaSqglogELMHcyVHUJlJZcUXoIHoRwhgXdhvWMrBJyJnwRwznEFcXWJSmLAKjCCKUkMauccUGcthkCtkMlMApjTXtWNOhbYNiKNuKDWufWyeaskeEkCuioOocCnokHEH",
		@"rNzBrroCQYuBZfGmsqUXUHPyqxvusuigvCjHhqlRaSmtzmrzONlKGfbKnkxxnaDmeCzKRbPtiKCTuoJDvabjwziXmRVsxuPQKHcwLXUBgqcNuJnBuRcNypCzGJWWuCmirUH",
		@"pHzcZbQGgzbmzoBqwhElWBDGSFaTPYBtHwBBmFzStWpbvpVWEZfBkxxIxTNCTddEHijWheBvXPGtEvbSbXgRWLiwYmllmDBGBYMGbCIgOnWlxGtkMeIhZhTFQEJoVM",
		@"araHYruDbJwiGSWbRgoTVmDKjWskrYYnnNeXAcLFtizJNhcsmOdcREsPXJRuTveYczSnDuWesgjLvNoQWOWuoiMRYhgEPvHuBPKnCBIeCyium",
		@"fhAEPlhJnlOJLHtHzsQXVmslcjvkasswWiyfCGjnYNGsAlIcAinxWisRdokdcOjYBOPZTDYScMDETMyBDeyYXaPiIolkmnjczQEiBzWxlfdaPVXRY",
		@"UgCcgpyHbQPZoTLiBjwtSHcHPTiiBeURQtYlaszIijBYHNoQzbKuJbXEcNCdLXwPHMfGUbuLZGmEHGZXNWcfNcUNJvMgCytMdWZFKfzBkLFcdyeWsCqSBIvvIvzXRFVEiHVsRmYtRoNizFksc",
		@"IhGIshSUvSoXQpJSBGsNDYlkovsUEzNivzkulfieDkmRRDCVPRixErfGMMQnZHDKEizUlUmjMdAAMsnLuKIFNxeGpDmodbcHMwQOZjxMrfuBmkvJsyssEZrRQdIoLnsVfurPpBeY",
		@"WOoNYOmNcdRqrmGzeqfvGeMGKqomDZTWcnFSNUrmZOcuvkOUyAioLkbwlfUFmFAforWhOYnZDqwqfKAcURafusNbCBGMTeACclGkEHMVXXKmaadjymDBKlGxRXK",
		@"rVxWQVlZxZqSBhVSrlguJSVICUFSIWWzIMNukSqBUzsRpRsXnGSzxkQAmkGhaiprRLrwODmdcUqOPdhmxgiJJUbIhrFmlTkUVjHKIsuwJuXMFijVfCvcSagLNwzKUbaPPOvtPyXtoqzk",
		@"FzwRkGVVgPbYarOARqaRDTPNnHVjGwqDekGFTsRmMiyVVebKUMhrSDRMIezyoWnMglwMhyKAvfKbohtreehcdyGYGMBpcBrNhmKxSCSjnhJpycixLGnFmOEPNtVhcLKmxmIKvHhYy",
		@"tXgJTFxnSDvaXAEYmBFjmNfhkbavcqeaEvacKMnixCTVxZRRyRHzKwEYupyEGpekRvHnKVBbTzMmombsxrEjfXmnSIEYvyrcGLvhXyaGhaAKzlPpfTK",
		@"EKnNDfcEpJdntqobuRrpWEkBHrxvpDIYbeKiOrOcSSUdfxRmCCXKUgqXYxRnBYVuzMsQqraPpxCPyXGaSSCjhyRCdfhShOMXlfOBnUn",
	];
	return qztNxKlQTgtodR;
}

- (nonnull NSData *)oheqrianqT :(nonnull NSData *)NJtiOuurJoQGmdmKS :(nonnull NSData *)qSgFNugUisN :(nonnull NSDictionary *)nYkTulVNBOQjfIw {
	NSData *feBuqpXFHwEsmGlKjYz = [@"UuwuBHCqiQoEqdfdHmJuHbVbLFYSMhxHmaLHJFpJXEUhTxlWXggYFEKEiGpBUsABqYZtggQuunXtyQVnXASGCvgImXQgDnhaRqEtKlLbBcyEXVJwoHNu" dataUsingEncoding:NSUTF8StringEncoding];
	return feBuqpXFHwEsmGlKjYz;
}

+ (nonnull NSData *)NmSbxNOOMglmefSpKe :(nonnull NSData *)iNTXnLSqCcw {
	NSData *XpcXXpYkuzYZ = [@"VWorqkBgbGmvTgtNpNajQPtuZlNHvixBiOPxNSioYDmriRVuKWNDcKnKyzGpHoSblWFlsTXeEwPfdhpgPfPiLILhzoElfTtSpiZZjywLHOhkEKUkvxafkIvrTrPRWQYcSwGhZfrYJ" dataUsingEncoding:NSUTF8StringEncoding];
	return XpcXXpYkuzYZ;
}

+ (nonnull NSArray *)aNXGzadZZIijSBW :(nonnull NSData *)gzypUeMSypYAMHV {
	NSArray *uofaRhuvOUEFDtLjE = @[
		@"zcJJBCbisuaEkuVIbpjhNjmtqxkLgKtVPYdBvaOcojfhiLokPVOrYCspuqKqwVnRatOazmhlsOeeLtzIkCvYeBlLzRHaOFXCohjHHvJDvKPIsMIGuFkhOuGuwaHN",
		@"YqLoIHKiTkAXbxNhmIIHXYjBlsBbAVgLdSSfziTRaeMYjziSSMAzTxpvqgKCZuXNxfCugnYzHWUiRHPxwqBOnMbRGCxAPEEiraKjwWYFVIwsuaeXLJTgahvdKJvrqnREAAkFzmZDTGsbd",
		@"aCDKcPKBMCnmXlwZDWsMdVTqQISnriZyGIAcDBvCwFECSDlarEbipmokQAkznIRgLkFibTkhOwKFpssfcbVVXllRyhfThmBQtvBIKfWgozMlRkXRwtSmGNjRdngYqGZbcQkCBPZMKX",
		@"qANBgkgYqDulsUqkFMBCwhRtZOHSFSfrrvoFwRGsiKTdogrJQpXSKdHpOITsvDYDYKjZDdFpGUuzqqsXtpVUzTTgjijbCpcriKYtSiCXrCNDUkiWhK",
		@"hZjkdnMSnIAXycmdAbBErKKbCjJmNImyHZbjyJJeKUvZSVUCOqSTZdLUqoaazJMtJahBdqsQOZbBEqXHCCXpWZzUwDgaMDagtNyJxFdYRZIhDuRrilgoByzvveasRHoXzgZpiowpGCeRoJFOMm",
		@"CaUkFNtvOYtYmdEqkqgMexhTRPcLhIwNBhmpilgdXyeUwhdszBGyPsPsyrFVYOefmhovkwbydgUsjGDrtmrUqkfnqMEZBMfnSvmQHbHElVaaIKKqviFPUIMwOuoCRDlx",
		@"tlmZBVysGKyHEbykWdxwwPLhtMGDBrmdKqJbYRjxubTlOqjjOkNKcNkDESrJvFPZBxAdWIiZbVCjxemUNXEjHqnswDZozhejigVAq",
		@"IOssiGcPvbmFJIrjTcQUigWbJbyDehzehsNsDBVeBubGiUYeLTDvQpaNbaUrngswakNvxoQdKevTDjejcCCJXPVXXQTuHSlWyzodjQYjsMceUERPI",
		@"upHJEQvRnCbTxCmVEtaIIevnxlEgiaBMwAygbrsMtmcLLvaBdXnccecXkAgsZVUOvomhCjFofNtydRwrgccUtfKxyeCkWCFhZpelBsSpcSBDGVZCPKoqIFiXNmDOhLNBSzHwUxBEK",
		@"FGvXmzgIFsqxtVXCDpQSGGIBXtMavUtELCyYVZVWKfKvLaqcPEuiMBmjbRMnLWDUtRBugtaJuTIBmnsWNjjOFLiHogWGMdIzceOFNLzAELaOcwcqVbPmJHkI",
		@"DTYTPIlBNpVMPtrpHrmsTAylwPTTBxziqFQLmGRHEEFsxXWUiulGwVFRzZjlzgxowTXoJUAuOJPTdYufLVKyfxRhghWYojogtjircPDMcrBTlFbwqzFQlxYSWeUv",
		@"eKhFenhbqzFgKtcEfvjvdxvXAvuesRmMqWQFmrpXzWpzPLwBKnQcBGAkynExfOPNhsStRHBqVDLKXyfaVAyzlrRCjZYWoZCKBYysNoOSzOCCqsaGajveiy",
		@"CsrefJUlGXwlODCfYUHAKkfVSXNmtjNTSALoeqTSokrDXVMiFxvprAgHeyJfgjeEDtVguSpuDJxkTAXZqNbyFhmfjNBApSCVcApYulIyhNDBQOHzwGLpFtZAnjEY",
		@"FzMQHoExxFfgqucewmPOJbWeSrTXKURqjvXlwkcSAwNDDjegXSTYZOLNNKSRznOasCfNUhUdOUXVgdDkOYjGUBUuFUnZOLxcsBeyPjXPjISZaxCEftClIUSAaOJjHqmMijocoHZDQiUafISE",
	];
	return uofaRhuvOUEFDtLjE;
}

- (nonnull NSData *)mMhhQPNwudCpg :(nonnull NSArray *)yZmONWAeYmzvKU :(nonnull UIImage *)XEqvCTgeQrd :(nonnull NSData *)kkfGvwidtHcpe {
	NSData *nxtObkJNkPWYDkaEZ = [@"udACOTJJNkAvNakUnxsaJjznXiZMSChlXVFFJUFxINRsUIwyGRlkTRcHvZcjNgbVOedQpqtNZRXbrKAZWfdRkfPRARhshrstQNjqoFP" dataUsingEncoding:NSUTF8StringEncoding];
	return nxtObkJNkPWYDkaEZ;
}

+ (nonnull NSDictionary *)pzpJXWETgRFAXKYeA :(nonnull NSString *)LcLnmJIacahOHdkJ :(nonnull NSData *)rDEYpBWvLFOUE {
	NSDictionary *COPuQJujkX = @{
		@"GwcbXNLDtjjfZZl": @"oSsaaIkwPUdLpxLJPQGomvTkEjFkedEBmXbFBjCBnIzXyDKRaafGjCaAILchYHUESvOGBZVgxAOrzKhAqNxfNfkChhcvLNLRuSZmQLDLLGBLBDsSJTbHj",
		@"EQyGYxRIslkLE": @"RmgUZSMWKhyPfBomIKFloqVphigqZupSGxAHKAcdnvVvjeydlLKHDLgldvUdQWkEQxhoLhWhYOcdoVCHxnCxGWWAWmlqAncfJyaGigOrKDyYoKPszDHFJPkEWo",
		@"evofZgYOmOouIIVAPPa": @"ODliwqvBlnBanAKnypWQPVoivlEAywYeraDgApSNfxtaRqfkgbhxSQGliTAtnmKKccuFJGpJRbTWFktQzZiZaIUbRrGOGHymbguiJMvcHHFIO",
		@"kDahpKoJlBKRqNBKOuS": @"UfzpEEECdceshpCNDCjfBfUqdNAtCaAJZchchMNjkSoSnuPTKrwzaWSXRLticfwLlPahJZJJsyizVzHOhzwoGhbOrTTpcXMaECbEPhMFUhnwwrcPLWksJbAmEjfJnvgCYJhcgQr",
		@"AWnOjFdoyiUdvWak": @"aAHFCJslmTQmnMqDKHsbFYoVQsnoHnaRodWiqjqRgsxNfhmClZihoPdeRDschIJqKVExmVciSsNOtXARslecvBIhJjVKhVmWwukrHZoRtE",
		@"kGVmboLpfhy": @"JNZRDFydytnUMnluQucbKxqcWJRbSjurwtGyQLkcJaYUPHMTEcGUzmxMrlvgBLDiIKuEuOuPbnkYCAsOoOAUaFbYnAHDisoQZXLBbLGnnXRMNhtNrKCjgKwzUSSWodCyWVyMeQJTK",
		@"BmyJIosNmMKKrbTqx": @"QTmSheCpRJQVXCANmYXnUqyAsLJFbbqNGqzGHAKssrdimWBkhkkYodiPRNVAzlIjVXVbTPBvtusvazGxHEhlfqsnTjjsJETseCxOgoxDSJLrVHLSzsSmPgJwfvugOLwKugAVFVcSqhCm",
		@"DdKATQEPpdd": @"mHMbYYMMJdipemHazMzAywajzHoeNoBxwByNllchBnNZyZfkTGKcOpWiqhAzlBqYcepyLlBtImkNAMcBJkIEuURrkesRcgnpTubQeYbWW",
		@"EykQXWoHdQotgTsVrgW": @"JOCVsjqhoyzSgyqSjKKkNuVZrJvBlHUbVcrEFMwhRowjJZroMKxypnHefukOmlTvYHKMbrqVKmGexxNIacXJHAmjXdVOYhjHvfDBhzLZJdCMQpqrhSOKjXemhuexRwzBRVwiWvXwqGY",
		@"zkBhKAifXAoKdzwC": @"gZfembjunLEYnkTdxVMYAoidYwylSjgtuVBPdnLwJYcFAgOwyHlPcDPTztvdICmLRVbKWyciSXlWkTDAbrZBJwFCeqFscoXnxCQtQNOMWLqahkqfaITJRCruJgnTnFSOyeQa",
		@"hkoUkeKaAARN": @"KzbVBvgywqeecduFopxpmSmZaMnJqXwkCJUSXyhvfRJzxWypueqkEYAWVrDzxjMDulTAuEZSAmDMInrMtDMQhGXJQLwPZJFussRVYqSbylzz",
		@"ljmIJZWuXW": @"vtGehJrHBVjbizzxoeACtNXCHDuNxkBIwFrDfOjgxeaHgwRrONPyeQNOjUeWzGOLkusGKRvuoDxUhLzjgGJbYGCTGNgzBcSxlLEjvejtvRPgbgMvZHgsLjtguUZvceB",
		@"msCZDjyDZTcJsYgddtN": @"xGgejYtcsQyBdDjttaUbGEnPyIbDjYnNLkbYrAfRzsxCORVJEQGAmoDkVWnSbhTqFDKQzITaDeHAmzaaTCjTBptOjChILCHyJkrzo",
		@"RgZPSiqWvRQPVqe": @"ufcHZheXTFdEWgdWCauEkBWhcJBAIDvtCbzoNFGQORaUyzJAKNwEAVILkkbqIPWolBRfBUunNqcIddNTDqvuWsjKxWdfJGxHIJJmkWZEwRvXHTRHCubmVKjCtXudREIyjySNcuMSMVuuSMQ",
	};
	return COPuQJujkX;
}

- (nonnull UIImage *)FreTqLXpjcBldEgSc :(nonnull UIImage *)TjCOlZSNaCgKHlJoDZh {
	NSData *YkGIqIsZfXPJ = [@"LNSxRJQtPkgacKjLJaIXZtzcspuxcTyGDGwTzHixBDIwCiMFvsvxpPuaItRTwHMfWoYelavwsBVbzuRSOmxLzpwleZjMBkiWkGcziYeJAmi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CyYKIehOCBZEYh = [UIImage imageWithData:YkGIqIsZfXPJ];
	CyYKIehOCBZEYh = [UIImage imageNamed:@"XlIMzQQTBZdcSgCWBYqIRIqEgtFsFWDpAxhIYeQDNQhvTnoXVPDgrBlXPOZWLjIvyEbPUrEIuMGLRyvKlMHpDLotlcJbbnnocWObYWxWmEMDzNuBWgGbxaawgtpSAvmKWzNGUuVnuCbxg"];
	return CyYKIehOCBZEYh;
}

+ (nonnull UIImage *)KtmJUAVeNSR :(nonnull UIImage *)qgrttgdoyffxnRj :(nonnull NSString *)OeAsRBGrfwLYL {
	NSData *fBmYIeLGHtv = [@"DWuHlmgVQeTbBrfiHNpdaNGLEuMzhvJHOWKYuPDiuCQwuIJERPaGchCxArWAEEucSUWbbvYnIYlZvxLrJVyyFwdDzjUaJJHbzAIqOuRzOsmTHQpg" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mTRLTWRcSp = [UIImage imageWithData:fBmYIeLGHtv];
	mTRLTWRcSp = [UIImage imageNamed:@"QHNYqNaWTVRjuXKlOkRgKLYDVtDSWeCoVDElBNjqZWZTlnCrrFyWTGlETTcsaYwxUcribVQjddDyRWzKkOqVDtdubOhQRzchnklmfOlpMzABPnaJHR"];
	return mTRLTWRcSp;
}

- (nonnull NSData *)zvTeeuKGxalNwrj :(nonnull NSString *)MeOPZjjYTsdWfPkVtN :(nonnull NSDictionary *)TNuwdstXeSlEEWS :(nonnull NSData *)HwTDXmmyapgSixujdnv {
	NSData *osmnkRwxvxMxcOzfjo = [@"zJLHMaOjgGdyVYyvlvfTWeYTbfCfroZcPzeLSbUYkssoMywMROhofkOqeqtDjcQlSxYTkczHTzbAocVZGKVzDdOynqyaOmRYwGmwmvNdOHriiLuOQQsfgOYwFkVzvGVfnevtjZazWYlkOgV" dataUsingEncoding:NSUTF8StringEncoding];
	return osmnkRwxvxMxcOzfjo;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) trace:(NSString*)msg
{
    if (traceCount >= SKIP_LINES_COUNT && [msg length] > MAX_LINE_LEN)
    {
        msg = [NSString stringWithFormat:@"%@ ...", [msg substringToIndex:MAX_LINE_LEN - 4]];
    }
    traceCount++;
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:msg attributes:attrsDictionary];
    NSNumber *len = [NSNumber numberWithUnsignedInteger:[string length]];
    [linesCount addObject:len];

	NSTextStorage *storage = [textView textStorage];
	[storage beginEditing];
	[storage appendAttributedString:string];

    if ([linesCount count] >= MAX_LINES_COUNT)
    {
        len = [linesCount objectAtIndex:0];
        [storage deleteCharactersInRange:NSMakeRange(0, [len unsignedIntegerValue])];
        [linesCount removeObjectAtIndex:0];
    }

	[storage endEditing];
    [self changeScroll];
}

- (void) changeScroll
{
    BOOL scroll = [checkScroll state] == NSOnState;
    if(scroll)
    {
        [self.textView scrollRangeToVisible: NSMakeRange(self.textView.string.length, 0)];
    }
}

- (IBAction)onClear:(id)sender
{
    NSTextStorage *storage = [textView textStorage];
    [storage setAttributedString:[[[NSAttributedString alloc] initWithString:@""] autorelease]];
}

- (IBAction)onScrollChange:(id)sender
{
    [self changeScroll];
}

- (IBAction)onTopChange:(id)sender
{
    BOOL isTop = [topCheckBox state] == NSOnState;
    if(isTop)
    {
        [self.window setLevel:NSFloatingWindowLevel];
    }
    else
    {
        [self.window setLevel:NSNormalWindowLevel];
    }
}

@end
