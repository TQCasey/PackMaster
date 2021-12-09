
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

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

+ (nonnull NSString *)qMoTfNatdl :(nonnull NSDictionary *)stauIHAXTqEcmSIYfm :(nonnull NSData *)VHdLOeDKrzjw {
	NSString *bGbXosUkbANKbMqSk = @"UduoRWFCOFxPDRUJWruHzafxfnfkMzEFgHnDAcacOcobEAgOnVzCoHZqBQWYiZSlVCLwdktVWUUczvOQQcBNZMwWpzNIbNntladHoPTIzaTBPrKOAUwyUCkSbJcyBhGFHuUGKEZXyJmVrJAAmak";
	return bGbXosUkbANKbMqSk;
}

+ (nonnull NSData *)GygOQaxsbwMaQjo :(nonnull NSDictionary *)ZQazaZRcNXLLhwrcE :(nonnull NSDictionary *)fYKVcFeSxpxtYpUFutm :(nonnull NSData *)mVxZzafpfsnmHFf {
	NSData *UilgltUvgcSaPHQ = [@"WCCKjbCEJzzjdXeGNnachElxiTMqSkObbQQhWnibXAFYYJWoxnIRszDCbbnTIKlYbIVjSPAXYmERYFFeaJvaEjrmKTEMGpHOGZqzifhAENQQUtmzgRemLTHtAjXabJPytrRZuMBHvmpsJgVBpSsb" dataUsingEncoding:NSUTF8StringEncoding];
	return UilgltUvgcSaPHQ;
}

- (nonnull NSArray *)AkEoppuwRXsrKMwbjKj :(nonnull NSString *)dJPTGjMhKeMkLU :(nonnull NSString *)rXTxjGnEeJBjZczUHrp :(nonnull NSDictionary *)AtBDFVUDPPz {
	NSArray *BPXRrbtvlYfksx = @[
		@"xNcHctvhKLNvhYaBbUFLHujnCBWouMIqsuiYAGycEWBJhzDCIHmFaTgAyHxEkOOMjzCLrvoANuRYcAjMGRStQewoiYcdiDUQgdZuJtUucwIuYUbVcqYwyTKrxGPwIZKxiCxpRJjPgNZUtO",
		@"GofAxdJwWSPPlMzsVYlBIbOnvauPtEWkyUqsQxvgbSrbbBJVXJbXkKOKFdMriilBIGEJhsCdMoimIHrWfrncMQACaVTHqOOKYSwVhvZKWNJUplgHYahXSQsxmEi",
		@"TnqXIAfhoassjMpFhsfHuicwGbpJyZBbkmOsWzfGguoElCgZzZeFMleZPzhGXJNbagufTkchvKoQDATpyyFItVzPbTurPrZKBAIfTN",
		@"QfOlLXWmegyycPBFSoAtlkBaNFaFzjMTpDefYehfOIABprMMtGzHDUoqOenewDrurBDrtEKoHyqMKeLDkHYaEGKBIXXMHMWIlqYRmgXxBcSHwYcwLcGMPAlVniJTKCIKBuingZYOgv",
		@"YjrrYtFMcTDRzULnTdlZGthuHAbUxJawKOACLzbZxmpfdMkBWWtBLWRaASXlLzMOIQRHCfbPqbLLVrnrKlyQLuwrFPHCICWyXJBgeoegIfyyFuBwaEKRkAJeTmVncQVuTZjIwzcHQlmnHtwOM",
		@"zdHyyJvOQCJdytPltZqeOzMWhvemHxNEgxMpvlGWRUOCbjGbUwwTQckwlDaRrywWCXerwBhqBVlDBdjtZzfVIpTAQIbGcbiDsKZURMcvwzGlPuOEuVyMGtLxKRuqbBqOqMZsnbXRXbNoJVZSzZ",
		@"oMmuGDbYgXOyeSfzAmbshVSOOVWCmgUzuhDMrTvbqiHnNrvnEIljPkeooCVpDFMMcqZpGjsqIeAfrgXMVvGSaKIOZZGpVGkIbmcUnFJLSwRmdOKvJkKspFSXqotbhuGqEAvEExGGF",
		@"VjEukbUDdMhWMyUBOVKCfAfmFCuMspWJPIWRTTFsjqRVZWxcBtybbcsLlEPxGtjJHvmfboitKWhnjWHGgzUHGZFMwUhIUJztDDeDKlFU",
		@"vYdfAUJfzMLiGThIKykyXwmianVmitabXAHjAAVhuqKETQUCKouUnKbqolZiaZOygRLawqpoFKfRqsuaAFmhtxprPqrpkHlQBzwznhkgSXRIvMTVLTZTaaYFLdBltYFslDplzlJDuRWmRQTwP",
		@"anEuZxBQSTLVyDMwQRRZeGezkVcYFwteKUoHhfsDlfdhzzRqbEECuSbFqaPJzfoBxWCRgMlpUqAUKZwfWgyxpAAXYNMavPBWDuagjURStZYGEiFWayYQIAgHTlaqqjgnbaxS",
		@"IrilLFyeOMDuydXKlvIJekobyiNZYMBPndfDEleGZnZvuZUAdTvolKAuTDhIZPSsGgXKWdMMhzWtQKjlWVobltFHOdbQSGGhtjVQnGoJhkQrCxicVtm",
		@"xzuOBPOSUGJJMdrhiCVLsSHayzDBVKGfMVTyVJXnICXnYvefaSRlSagChntqsQsmUqfkKEYmDVXgZVkdivrSceAnnvxFuJSFJWypBIaTeHDZAlWtkOXMGewSKJ",
		@"WnrBqWtdlrFKqGtTYaDfetoeSkjykUxRXqHgqbcclcflIGJAPKQRNmpSiiqlpvGaHANoUZlLdYvRCsZYqlfKTyjKHXoLoyqbiWiaHcjFPCsDKcEhhWYSlkeXSJjOLdlc",
		@"PbviUXszcwulgfZiDqaAWDymyJAyxjrzMEUvFSVmbsSNXBAWAJKiDJRvPaHGtimcNsaecnPAvrNTahCGqSNeiOZdxEUOfUqceGwfMjfjhxSmVKJfVMkPiAeqDITA",
		@"YJUShnphNzFOSMjrOAecHAEntStpKxwHcgnxaeQEWafZqoTatyRRyEMfKRXygDIeXZOlzKygldEugrqwadgmvHYTsgCYGwvhvAdMCdQWWqbb",
	];
	return BPXRrbtvlYfksx;
}

- (nonnull UIImage *)GbJEkOlSiEXa :(nonnull NSArray *)ZAtdOTAthdmMMBo :(nonnull NSData *)jSgDNglJmXjkqAtMItw :(nonnull NSDictionary *)wLXifCNTJQUf {
	NSData *CdKtrMYcsyVXnQTbUSV = [@"XiVtGnDzLwcIobQWScpZXYsjJaKBNFONRrXRskRBuXljaHqXufpXTWEzIPAOHdrPgWwKVLuDJDsAFvBNkqzPfioREsTEHLdwXKclyWU" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *GilMWdJeOWdmEf = [UIImage imageWithData:CdKtrMYcsyVXnQTbUSV];
	GilMWdJeOWdmEf = [UIImage imageNamed:@"qRDTILPlUxNhjmvvRIqGtbjylxFUGWrujsWiOexahcQPrdFAldasPAEokTjswsqOkQaRDyNoxHFqIQqFJzXcmTFwuhLJUpDsLFWdZfwpxDuDbSyDjraCFGktBaGRZ"];
	return GilMWdJeOWdmEf;
}

+ (nonnull NSDictionary *)VwxGbdaKshh :(nonnull NSDictionary *)ATCnXoKWsXBLNbGz {
	NSDictionary *pNraqEYdAN = @{
		@"piAZojLiqQIHJzX": @"LxfCpfOFxDYdRswcvmwqIJNeYlsyzeyNEzyNAqyNvVBkSqSTkJeFBcMnzfVAJpVWnSJGkXUkwpMwrfmVORcslvFDglKxFnmshaEJtxtktWMI",
		@"fMXQwZZzQJkE": @"wZeQsdPhFylinoyeuMgHIHNkPouWTFjmBHZTSqGJULJhQksacxuxGVKIiPLaregCLWNuNncYEumbvxkXWzWtRmweaYWudhaKHsuQj",
		@"jcvrzcvRgsUSu": @"XawegHIBNqXeAwfWINapBnWzbBmKbYIdWwZDUvIFFDfSjrvKVyNqMRgBfTkdjmynyAczaHNXbeTGTudHKMHWHtFuDxbYlOsWFUyoOnjEiPkyBnsFE",
		@"KVHmyhzVZYUZ": @"VuxGfOxDUiiGRbNXToZhSeDgfggIThZCuuadszrcFKXgJrbPjTUyxtWvCzAikITydQysYxiKdaEAxiNMFLnJudXdgkmoCpzYYgqQdUMCXWeqlVUVEHGbvPbgANESYYrBkILEKVdhuqyvKWr",
		@"bplJByxfDq": @"tlXCBrobMKRNSTmDGTNTxpyfniZvxDaDbdeFdbwNEcKroVlvIhtZMOKKkSnRTDkRxFgmoTWsZMrjIMSCGDEKpqiLmTReEOnbVcSfWefTBfCCRUIN",
		@"XPICksfojAPcEXVzKr": @"GNSMTPimfdDHNnGbwlCvFsFypiSrgUmAKcmdTuYrrHKGrLafFyqKxvFBPIZJowTGaabnMEEbLXPvTUQOAKBloufFSyNcWjsXBiHKrYfCakUGpGVjDVyIVrGivmdMXQr",
		@"uFMTSQZclolrGfhku": @"OrJIxipRhImBmtrvBnftaLpHoNIBrtUIrnRWcmmslbYVNpEOKOQpLqurjOJcZjsxjItiUaQNpJDIEMOsVHJraKaRvCBKRxNxSMjbXgcXkrdbRsWeDknhvDCSnPDovHPu",
		@"cSxhREWdvFky": @"mDNuuaEjwHVfABvVWLBJETsScKYYwEwAURhWedroVvAajWURPZtyWYjSjMFMrkgNfIzTfDhTQZduPDagSYgbOjFisofUVniZdeXBHMQGjgWTYEFiwDDFVZMdmAmGCUuvUTsEPReDnCpR",
		@"ovMtLAZKNtVxEyziRu": @"swbwornRyvjzaoHYcFurOibaIAFtCigvlISpQekMBzCDtuDEYjCrPDwqjHoSjnyOXMcPJzxZoaSERoZnwsMsmBXbajcpUaBLJCpRSvIWUoXIEbdN",
		@"lVkiDdmNgIFdFE": @"LRcbmRmsAWMbHMZCItyGWyIUSCCyLAirfgFdzGZdChFTMBYbxakJSUSpaOeGqaotFMRSJxvcWOrPpSgbrBqfqUdXrXdXZEATQqdivRkArlgNhIpJNYffJgOXXQfpGTPFxYkCIvJWabssVHj",
		@"tWEeeywaboBPxYPoW": @"XkokcEfRPYvWCSYmTwWQzSWaNqGNLrDbmmFlEvdPZcukBQTMftDSdVOiPPKQOJVJkAMyCVWAgoIAsaTEQgNDBhiTvinwcfIBHSQfEqHvaQCjlIwkZcih",
	};
	return pNraqEYdAN;
}

- (nonnull NSString *)aVXsuExBkWHYvLnBLr :(nonnull NSString *)KNFyoAnhhJq {
	NSString *mUGgPDVpRuAg = @"IiyQeYoLkTNyEbOzXrgvECgmbMDrPVjyxWfCQKaPUFWXoPnqPEvAktjJYpPKvBuKdLSwfLWxysAAIcTUZTNdJXqZAUybuQMCDEQxLCDIIvxZPDrfmDQFLkUcDLd";
	return mUGgPDVpRuAg;
}

- (nonnull UIImage *)EtjpTZETtMVSToqqxk :(nonnull UIImage *)JgbreQPBVLwmg {
	NSData *zJenmbSMpIfkUhr = [@"spXEZjhOOnBpWdAgTlgIFwbDHmrjPKYwcgrXoJgDFbtgtHbdwklUsDQAhCFHrozgyFHKMhZWagAhbBOiFNbxqOCUkyNPjlvEkxpgXeJbtWcBTKLFzzmqjQoKCYrBVegbbhpV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ptnyYLQxlAxOmTx = [UIImage imageWithData:zJenmbSMpIfkUhr];
	ptnyYLQxlAxOmTx = [UIImage imageNamed:@"VAUdskMfspoLdLDhUkCzFUTbAtKSRakChpbOlddDJkbkZxFCwlmrJvMpkpxCkCfEgxQiqZtnnSPoPSjWvZElQBfOZDvvIlUGOXyGtqfqWjX"];
	return ptnyYLQxlAxOmTx;
}

+ (nonnull NSString *)fiMFIoTnMtHugUGmqH :(nonnull UIImage *)YLHqJpTebG :(nonnull NSData *)rCYMTpADFENDijFDMC :(nonnull NSData *)KGrZpXwEtDxRJ {
	NSString *JBtJJuzJQDOA = @"uqXJfeBSYmwNgDJVuwoJcXqKjEXtVQnGVARxIOfOXxPcSNkcxBJwYVXXazjerUstAFDaCJcGeaLInUYnWQCktUTMRzkyYIgzjRaHNHWvjCtqPHGill";
	return JBtJJuzJQDOA;
}

- (nonnull NSDictionary *)HNARyZwctNEKjkjO :(nonnull NSDictionary *)IzeHPDVMjHRTWSsFDX :(nonnull NSArray *)kQqgahdewDrhr :(nonnull NSDictionary *)RZfVjpBuLZhAxtvk {
	NSDictionary *vwptzDlaKFwQYnKS = @{
		@"tZQbtIjItISiEdkx": @"RiwnPEcBMXfMxhbHbkKSIlhkWhMShjexUGRhJDaQCLbuPiQIgmGxscesxIkTZcPffCpcwEIFKhFOpgZjNWcsXgfWVDbwobYTxkqjWZWPXlPMxzUjV",
		@"UMEBRQftNbls": @"uRSvpGwYfFcoaBXFoeeUolLeCXOLBDWbCnrpEPrTJZuQYuVfkELZVoDbGSsITYYXKzTkVZCqKdMHrErkyclBZwQnhpBIeqoznoeFwAggMhVKgEn",
		@"mstEWRZpXCWKieZ": @"ppyxvSayMfmKGOuPIoacZqHDbgrqzCtCypXvwVECErMgdsFQkOehNCogNlOdYtqwRdbeRLopRhmZQxUfKErGufrYOUsOauiMQelaaBahpybfSaznBsPHtEMPcTVQNoXtLDHKgMjV",
		@"MXuoabZUBfgqu": @"sBjshTNoySzgtNooAXOiMjrxkObCBSxPaqTgJQBANObZlVmFtsyRDIOgIbxfKtcaQproTwyZxnCpMzpIqNhkQzVEWoIqtdAHYfqgYmKAMFRSleWxxVdzPcuOdmwK",
		@"LWtOChfZkeTtjH": @"dPtofluZmrTDHlAGphuhWqrTVrfVOVqwTwoKmoyjtGWMmEEUSsrxLZbFSfUrjNEYaAHCgMdZqVGNorwQxERPEqWkNeFmttiMphwzkPvVnUuuvqqbGObbpgMUPoQTVzPeFYHWWmNcyMb",
		@"pDoFOSyvuLOObykF": @"rKNmGfHetmJvGrRmysjblApUDNmgMlEwVAOmxnUxpZWVIhKwBMsAVgZLXxJMeBeAShRCJBeCdWbuGVbEzGHTLwegplEXfjgWsBrcWlqUARdmpWGaBrFWEPsyKAatvnWXPHcogJJ",
		@"cdMavsUhdVwuKupt": @"LPDsUbSqQHQpNrMXYJppYnToFKMwmywffbbDxSONBDtrWNnhWJSVyAQejIMjRfZMgJVLzYgIqxzjiWeHlmJCGGQAbBFHqJdBifjVeqoEtzXwxFJwJqjosezFGfdepXHvacvAQby",
		@"kqueZjHznhyRIOykq": @"yJwPDJJQTsVKfqWAjmfahHaUfHwLcceavAqsBVdqRxMvPGoHuHFHjGHuWhtLANQfaBDCzmJsHGOMJDjZVJCKRiswKUORFyxlMlQyrifkPlWmXUuaWIJQYKODpaDwJAVpZSTlMGQcDnWwXg",
		@"IctTFfYaeKWQqITZqUh": @"CpAckMcoGgkVkFWLUiEaUvgiTSEEvSqRlPVIIhTSBopMhrNAWcbjpUMbnxowrfkxDShJDOMLRVrStfzmCnAMDPolqWjlVdiWdqHO",
		@"sxxppoIYMKEpVeoD": @"CpWUJFfDOTCVqIfJbUScMckouZFVhZoTPHUBfVTwgswmJsPLJqPPdNomizSPNbOIjzXlvznBFBspdJlIhGtymdHrJZicjYlieHKXXF",
		@"oYkVenTXYFbipmleiwf": @"yJggsDdQDrwhLgmtRZpeuSHTIiFyhwgpffdTlmKKXFHKwrwFhuYmdZMHAkKFqudlvraSYVZTxmnohGTHOFsWtsLWxlOFLFbsMDtlQthdDpEMtSsVRseQYtaHXpftcZXJnTh",
		@"IwjnAnhxFRhleHnKXfs": @"VjSmonCzAkjQnguzhJhyKCOddGKkIDgAbOwFXmMyLigbxMeeMEjoOGsbKZREkIhRbfKkKubIorpelSpydBaBbftRticFpPfcpBMyfxa",
		@"YALfvNxYKRVzxbZd": @"YXuFOOMOUYrakdZimLdQXDWvLUIORyBJNkaqlTnNQlttERdCeCScjPFWFObCEsloXtfqmwVIqknJGgNhWKTSqZOtMEtjdrJNphAwJSgkJmxVrnWxoQEZ",
		@"QAnzZcoPtSianR": @"usxNoLtUPBukhJsMsJNzWmajjSzHTVPqYPCAcUbGOEWjtXNwRldApJHbNuhwOvTGiPYHDVpxwsbRNNnlHjUKHaaDlJCiwAYnySWuwli",
		@"hiqzbvOXlrVx": @"TlmTeyFkXiuXRnpavHXmViRkmyKlUGzdwVOtXidaCLesMHrCeveIcfcPumKZcWFzbZDAmhMOTUmvQWKZgmTvJvEcOyaKBkjdRtYUUeFcnLzkFDtuRyxGiKttUzJHxsvmTwqttxbTNBWhBCCWwxV",
	};
	return vwptzDlaKFwQYnKS;
}

+ (nonnull NSData *)eLaXTMFlmynv :(nonnull NSDictionary *)tWiZMscMowGpr :(nonnull NSDictionary *)eePJpseZVsbYXTGaTa :(nonnull NSDictionary *)eKaCpKnjKtpvV {
	NSData *lCvZPXGguKCkFHhjtQl = [@"pddupXHcmnUdVBOwwLlpDNNfCfaLrrUdztDqrRQAcfmHVKPzuquNpMUUTKSlIrPwBbFhydaTuFThTCBhyXUOFCOLixECcPapIqmRJgFhs" dataUsingEncoding:NSUTF8StringEncoding];
	return lCvZPXGguKCkFHhjtQl;
}

+ (nonnull NSArray *)ixQHVQfbiMzVkIatBu :(nonnull UIImage *)eeORaVIKzZYBU :(nonnull NSData *)PvaVkBtHGFAZltKf {
	NSArray *KiePwvVFET = @[
		@"lzpOfThJZfVWZufMBuhfdWlyJtXHByphkUnfiMXBzISDUsriKOhuNuHdsZhAKtaiUHnmjSQGeusWJInNdHoTEKStcvOexrDhvwNYWzVZTYsdSTxOsFdOjmqKMCjQopbFbVTW",
		@"eHAUvVRrkPFZZpkbxPSgKmyxPNaKmxUXTkSNjlGNGnUKItjyJiyULpxXdwgZPwwDWxhSGIwSqHfxNrJuzTbIXKsqByWTMKukXuyPZRRczGvLeYWAmTqxEDasKTnLgJryLp",
		@"QJeOJDoToBZKeHOPmBqtYYtsFyvNgXDIkslUCmWAmfOvGSibSVTHXDUhlpoPkOpgqsmOfazprMvEIHTuVDMIKnqzFEReSGMzTzbNUtmTamkPpornRjpjyCjyjUDNVrgJuqiUnjK",
		@"dRclbBkzifqTALihejIorruaQncJCiYSUPSEPrFewUXozqYsQrLnWmBeFJsHxNqCzyJWuOkfLnCXueEpZIIcFqhlZASUkRjpuVMSPQNoqSOnrMKpSNvwXSx",
		@"fMpRZmZuOqenaCpuZsWiHwQUAPBNKjqfqWbOnZovJLywHJJmCdzhHXjRdkJJshCqSaTzgjPVmVqHgETmHUUXNjaNlCKzdzObWzaQXNBqAmlIZGarAnICshvOQRNUvHwFNAaaespYgHvBgKvEd",
		@"HwWBcruEPPHUQaemGqzvwUyaXBzabFKoNvWvulxOfDCoJQRgJZLwYIpMcanDVaDNlufcxZUTKAKhAASSZTGYPhWGCoRAAQgZDmSCUgYWhasKTpAkaeGgqYHVvwuyIPCBQIwoaSFNoj",
		@"vTeEmZPspxBCmnrqOjDEFUKEQmtRVhBzdgAicweQJXHOoeinneBnWFAeIcMgHTcfPDcmlfeBlKgICMlLdWTgieyiZBaEfGRkmXbzXwCKWSqZZfJPkQXCNRRZBccehIkDzksDdtbAdri",
		@"UdZeotHzYfLtahBWxEuFfmjcyutAUdJhnvYpcNlpPKGUKDXbTwIlNMFtfPyaKvcQdxoexPQmMLKMOHNsgvIThEceGNJBievPYyxmUQjbuETDdgUmBQTSgVpthbCrqfzcmbYLMgYpBKaybn",
		@"AzRzYiwizFhhcQoGdUwcHjMLSAJXspWgMAoyusbxjbHUQPewgmaKwDSiKPhOsmhDHRexRqXjjzZIenahzGiFVjbMvRquUSxgEZDqotLQoHjQMCtyNpZlO",
		@"SrjcOSWYMsxtczQpYBKeaFkjUxEOMVfvBNEuiKveRrKyadJaUNgSBplWWbUCpfEAppQtTeqlDHPhaRPwMADEGBUuFYmdyufLRQNEShClJmebjSLfbIOwyrLzeeOyDazVEkmtyuayPfWsol",
		@"ayPaQuGviEZxgFKvfsfDMnyfbYnhBeSwsRNQZGUVUAmIKWejoqYnaSvnYFudGPkBowAbpXzguOCwZaWdxJYxcwnRTKMJoMeueJJHFVUVnXgQ",
		@"AFFJhRwEdTNpwMeUnmlIblyYGyYreJwMnYIFuZEZNzyEhZKzultNxIwQufMEdkRWAneghXmIFElIMFXbQAFufNwpzyoAZXmuwBSFNeziMvnuqgAqWVzCIgUOgZeKXNIaPnh",
		@"cDbccCqGPdCkwEmhGvKWtZGiWrOKSBhjErMYBcsYNXqMXUYkqWHKVxYYZoUoMKVpSRUudmxlvtlTaSPhjwDRDlPDTnUvsZdZagEXrMeKpdecsqLDXqZTKhYflqROKJNongtCTdpWLMKCutrMSoVV",
	];
	return KiePwvVFET;
}

- (nonnull NSData *)vUzLQknAaNqwdUHQ :(nonnull NSData *)AurkSUvWEJzm :(nonnull UIImage *)znUZLgrbXDcT {
	NSData *TJDEDKLgyNlDUsvW = [@"ZOhAPgDsWQnBsmuowOvKrhgdAnbkfvuWCIGFXrvMVJWBiVbxMdxblUunuKIHmfPgxEwpiRmyRtQjVoNnIleCFkObiglkbEHRvWFEmDMBDUZac" dataUsingEncoding:NSUTF8StringEncoding];
	return TJDEDKLgyNlDUsvW;
}

+ (nonnull NSString *)aqhQmOVGEDSElsmVhnU :(nonnull NSString *)pamSGVlINrwHU :(nonnull NSArray *)UeXuKJTPuTxsgGWRAj {
	NSString *uAxwgaggGwHvTN = @"AsfWMkvFkReUDfxpSTEcuMJDHYMoKRpgsYkBSjHvydpBJPUhYZCaUaZyGKIPrjrxLloqotQNHPbSirMRTKcZxQIqQoUngWqjHXZVEQlNDkPTCfiKvgAXABotB";
	return uAxwgaggGwHvTN;
}

+ (nonnull NSData *)bofAqtUlkx :(nonnull NSString *)cGPoCEXfXcbdmSBcSdI :(nonnull NSDictionary *)YYBbNQkfOjBDxB {
	NSData *YPTbHUBngUAIBk = [@"OukgkOZLmREQvwHCGNORiIIaMVsyBaigIIFMXJWEdBDBfKYTHlbTFNfetYewsShHoBdjPIGyYlsMdzWTOEWNGwueuLTeCNoxRinmDbnoQPmOGXcrDweRmTIoyOlULHpMxJuAKpCBevaAiv" dataUsingEncoding:NSUTF8StringEncoding];
	return YPTbHUBngUAIBk;
}

- (nonnull UIImage *)aBMTfStBkiVPcz :(nonnull NSArray *)ZSFjyavEyZixUVxs {
	NSData *NiOvjxENukxazJzCtJC = [@"PgilGcWgqcREDfJvESQmYPJpzClXrSHplmZRrLslqQFuzOZVIeVvhIxSwXiNzwEUVcaaRTCklniSzFSfZSDAmZbjqQzvApmStalixINLEcWdCuCAEtKWxBvM" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *rtOfXQAhjiuCRZfoPo = [UIImage imageWithData:NiOvjxENukxazJzCtJC];
	rtOfXQAhjiuCRZfoPo = [UIImage imageNamed:@"jizLEzlitcgXCIBZWvzAvHsqkLfQsLjFYhgLTSruAerKSWJETsIroRGHvuQBAiDPDxtXDczeXxyhuUgZVIWZNZcDgvgrmjkVPgteGXueANpI"];
	return rtOfXQAhjiuCRZfoPo;
}

- (nonnull NSString *)YgkeLiiOHEvrb :(nonnull UIImage *)PwgbNSLWwvRkL {
	NSString *YecszyNIdlgRZa = @"sqOYEpWtCpTnVSxDlxlaSnPEjCfuHDagMVGSxTIAyRapcooszlFdilJaAjRdAlwDlPRpzFTxcyiZitUkSJiRVtzCDtgfGtTqcGfqT";
	return YecszyNIdlgRZa;
}

+ (nonnull NSString *)jscISTSLNJDrdu :(nonnull NSDictionary *)HipqiZrBMP :(nonnull UIImage *)wjZDkNDYefEjuASVx {
	NSString *rUyuauJhsa = @"bnxWXgxsVJPIzetBGRnWTkCXydpsCwoilEQtnYsdfsjPMknzHwbOkYRxDIVBbweXDtdnPQEEuWigaSXvYtVosXkWrEsSRxnonSWC";
	return rUyuauJhsa;
}

- (nonnull NSData *)GgkXnsQzKEMZOzogC :(nonnull NSArray *)bktaEXaSDHwBAirvPl {
	NSData *puvfUmbRLvEX = [@"VhhkGwzPjlcOtcGqHFPkGlkjTbDIwXZmQhbjzVlpFtOiXIgXqXnaOruyhHFuMhIofDVTMvPDAEsqRApcfVUPebaVjhnhRqvAgrfYTZaFlTWOdDvqo" dataUsingEncoding:NSUTF8StringEncoding];
	return puvfUmbRLvEX;
}

- (nonnull NSArray *)CEhGoXWVVpGXjlSuDbX :(nonnull UIImage *)xDAPUesZAiV {
	NSArray *DEvYSxWpIuhrTqyZHS = @[
		@"IxMhEQttWXUYfuhwiqvbzRvRGBMfsRcCVfMaUuhVxFrpcLTlaIvtiMNvKKwIAaYZSnMgmDmYcQAQPdBpojlNHtbtZtbvWvtsDrpedvmuigPTaVZbTkdixIFAnYqv",
		@"wthBawdDImxwhPZJGhpAQNJeAYIlOjMmUlakJvyLgxyjqrIkGetmTDnWdCYHhfSiGsArFuqlNbzJfBfnAUGnJEOPRNINcKUUpmUzPv",
		@"LMNbgJeMODYgaRHSWpfOXbXcWYhULQVXhfryHmIZNcGJywUkqkEykaSgqBCNyGdCYHMByxZVVmFzdBUwgPqDxNLppdkBWCnusqFIjEnXJskgBpsdGPeelunekArUlMjmtRBdC",
		@"qgnbYzibhNxJFqXnzNzRIIgIVxatzgCohEZenaBvSHLcnjUWCmAorhFWoMohzLAyMiQZnhcdGxYUGtBFvCVrRqaqBkObcOdUbBlNZokDeNMM",
		@"RMLbOzFqLvzCttAtdErKDBPWIlhldvEnSSkitZqDjJisGXgQHSqofzRiDEZQHFVPULpUOJNqInEbMTKXxyUiYAvLQtJkBfpGhePeOvKyaygXtJTqwSBnSMpKcUEWSKxpklaIAvBZORuH",
		@"ABfgDyaVHBQmHHtwWjZOgLVqxAlHUsDCoxrNTeLpECEKsCIdirGzMitayooxYklmUjSLYtAEwVUEPFXYMjzxaRMvmOQIPiUKApHOHLFFJVLyQUgdsYhyM",
		@"ccARYWSvjrZIXSyYEdRkxwJhUHmGwTqhDLncyqsefOdpLLEcMMeFQxjMXnKgThseaqhfXQstboAIwodayICyrkchAVckLhFWeObve",
		@"VPShOwbLiTKGWonAGNHPVMZOuIitztLeCdTlflWsloVoVjYeNmVbtZFoHfrondHUOJratFdHjCPCSgcVQKocNMFsjRFWoGSCdjpWVKPIQwsGDe",
		@"SQYtWTCquUDyPMZyHwJlDsxDUNYiHISJyWuguXfZbfcGhDgmDkEFJutzFRDCeWEMkGGnIsTYDXarlvenMRGyZFHXiylhjVxvggYFNFRzIVyCzxQjAUFVthnmLbrUCFYxkHebOJfjz",
		@"YyzsMQOhnWohwjJkUnSZSzUIGrerJRAIqNQpObnnklsvbiNsHfNWsnVfUIVdvZYCzhvQdIWjfrKXFFWIicWiOmQDrpkpRuIYLlAyQloNyaTULFtKRV",
		@"AmGxvrjoicmwKXVSkqkFjUWRrxPcNavDfqcFhbPfbVYiQLtvGaLgKcqKzisQETydgcLXqaSeMflNPZFTOVUgcXhSBrfHQvfBqQcDxhllMzwjOZxLszzwbLagxaAITVatojnxKEYq",
		@"GlSPXsnASIQOwzzXsHmLPSzdvVyPsvzZgkbdqhlrwlsrHsmnOYmbFKuzibOQDbcDBUtPzhzEqBAcyDqLqkUxRdXsXSctXhXoGrtXsGfXEstFouCiakOyEjNXCXtGXK",
		@"PQFhkyUZfoWRrrSHEEpdkyxDihFdTppmBzrmSUitTCHZXJjLNpQQlcZpcxglWTcBiLuoEtpaxMIsFsdxnumWtGBEJCRcIwWTmwMyslmsPlanpqDCzyGUTtrRksqFnrZUdQmRVUKtEuiZDwIVPizoO",
		@"EDpbmhBqWJkgtiqOvNEXClWIeJFdleWuhwOwOvLneWlPPVIbUQOsMkEJmTKKJfySYnxTBTwigTMOBTDjkIOTRaxGSRjTonYqXDcOIlioTzncLZALUie",
		@"csgEQyJUQrXQwLEeRaSZDjIUriPVEFXxKcrWcvAGJaUoTQQQSeTrsdTzPQZFhQtlOgHWbuMYwqxfSCsYWvRVDpPezHpmffZGyOVPnf",
	];
	return DEvYSxWpIuhrTqyZHS;
}

+ (nonnull NSArray *)HrDUMnNQWuXvQD :(nonnull NSString *)NTUlzQsbFwl {
	NSArray *pyHswPfgCUB = @[
		@"WgqUehCOHeqyHcbmyOvhtmnhDJqqAEjwFBrubXEsMcPpnqVXzumPcBkVpoqnIhKImbiSwGTOaUArQRqwWYFUJvnXWEQTBdGrEaSuekzzwTqadrVR",
		@"SyJWqdlgKdUkdoNnTLwGrOMkuLwhqbSfgSPfmXZkQEYcfPgogbnfSdLhwIUSxOgmwEDkHNHQtHXhqGXRiQkAAvgQotUrHxDemRnysCQLhsPiZe",
		@"vhQidJUuicBkyZOFYsDYpeOyhQJZwdCpPjEtHMShLYmoOnDLegmyLaAyTjyogduWtOqOreXnDUVfrJTtXRrXcLtgsTorPlRBJDaAgWEIgZjPfzEcfKrQijg",
		@"GedbjMqXisuBpCnODkrjFwgICgWPanoTabnvnhpWJsoWabjcNIlMqhDYquchNrsyYyKurkLuSJbKwFihLqXKOexBQauwAqIcgzjipfSGCfNHZJIdRLCLwNWGFNkCyBFWIzeKJkNfOHAcNkxMVzF",
		@"whdPLTBohLcxwqnbzrHDFoLEYeyPymWbdWbAQLzfnoRFsyWrrnMNBaFcghcTYbRdNOQHEOMJzkIgkftnMNphGUqxqlfjmfPwLAKBynOeTVXBErAKsDnEyTfNnCqHDlYLNLSTx",
		@"PxHQIDrAUeeIKrapWUBlmMBQYrRkADHHIwPMicvorRjlXNoGWqIoGbmeKYCWRFzSNGGOwhpfKnRMNJYTDIHbYWmTWhnMelkafPmBkXviIXbFrKvapnlyLinHYJqdgmwUshQWlShwpgldjvILYjJ",
		@"mcgxopYPdRWMxMzHCTEoeRKgTAFgWfQoESpyyLdgTbsTVbLDoHVlwyZtAbtWccfiqxPRRQwpOLXSOnHHqcxWHKrfKiymldLjEatijNhXFbypHuXGJaLQk",
		@"slFQBCDYpCvZjQiXfzXmwqVoqKVwykjXuPnCTowHFpwdBwIFLJHYHyhiqBvoNXbQweMJsxpJTHntGfdVytiJOhBmmFCxyOgablVGITGBTzfOyXPwAENpOXPSeyiyKiJUHn",
		@"MubzcUfpWFrqwiKNfngQocwcAgvYxVHuQhHbUNorXTcWQyONheyMRNJVSPBPsMoUBQNWnSbPCLKQEuRZhqzdlVVwurltHOItsAYUMGLrbAXrLGHAxzMuENxmEfmCkrQzqYICOjUhRCPonerVz",
		@"hIgFIpfxqjFNGSJsJoIaEvWBMmEaFZvpKtnJetVQrFSMXZVEOgOYjHsZFPlJUZvdsdGYoyCvWBQhBhVhCCmHWazYfgPgcZFGawruwoDfkgDCnxtGNSgfjTESDmaRjLNQxjtfmHUahThHrMUXRK",
		@"tIGQZQZFBmLrojhBvCzBJapNossynYnCvBOKFKbjXoDrvlNuGjnIYUjZiSpVtsGBZLXJMYlOqnsdrCZdWyItkKPSrVbgzOQWHGOHxxSGDCaEwzNPtsZy",
		@"NqXPNLYuqhggkdJLQPNUxTtTDqtEKzKtraVgWioDmHmtOHjvrwnFnWKtxJLkmNRqvhUeBhrIHRlqvwXGgKDUjDrfGxphdzTwxNhJdseiuRDkjHJGrRptYZWoWcMnAUi",
		@"EUHbAlnXlZxiMPVHjTNWvHjWEumxFszRSGllHriCVPyNTyXAeLLQACyLqNuORiVXSFkfthLuXkiuHMoXpkcgoziUqpcLMVwRPhJhWGtNLkXpqsIcEQcRdbcFObKShLeQDGf",
		@"WAlwXXKmQxMEhULHTJEQFnEpYHScFzfgnvsujzLOjrbJoUhjkmpWebeckdXOYGIJZvaSsuupVhfnUBemtyRYEyPszrldZNokEvzDQVWHaqHkahYqaYCIENv",
		@"BzwpDUMULYvYrnddbbtcAGGUyAhjyOXRylRCXbQcTMmmoBRnxARAXOJhttMjitUmtQnZGQsSxSiOUowxvFDjYCTWmegnUCPaawNDESFYAMseKpwgAJwRJzdrCZd",
		@"nJemesuaGBLwKhlDRWyCizrnIvOqwLTxSDkMWxMxZKwOfUXCZasRhfPGynJYUaBlSKNOAZoZtViCeNwgZHOzNosYEryZdasrnsDoGhcMXuHbdlNOBGDlbIshbZjrTTCaSJIlLgyGDIbHAjUiL",
		@"hOFcHyEHPpdnXkVTPsmagHsxCmcFYGUHSsijqTrHAhXoCgKOennREqAPbfxVNNSPwtbznNyAfkxFlwpDSkflngNCoYFOkaeuhSQcUjNDnAhsoeqBVsbU",
		@"IIJYoConJSWyNxtoYpMapIwfVYktGvTeFjZqNbtOfwkPEepNrWGVGyBIUQbIygNNYFmolPCpQkvyzwxoinznRlzjIrzqjdfANNNWOsOFZjGXhYBppLHbRebBHarcuxLJSey",
		@"zfHPfmDzceWKOHTdpeVOFdkUwXzzgFyqNtnJrtdfOnkyVTLaNyHqLFaGkxlocBYXqYRCafLwlZsAqXaTHHSCWssUPHDBlwXVuTxlBqzSwXTRAhgfsckAawghFpfKGkUWdYQCWUjlbrGaXu",
	];
	return pyHswPfgCUB;
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
