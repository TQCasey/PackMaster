
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

- (nonnull UIImage *)AwIbwxWvPMVsT :(nonnull UIImage *)mGycaKLXMkUtrSSP {
	NSData *QGpTmgsNqGfgPCY = [@"McVhpSsnXlsBKkAPUacTwmoCpifbJGsQBwbeESdxJvQYmhOiFNqLANzFajEnsYqfHqcyhsaISUXEYxqEyaccVbmcvbutQUjkoidNswrAVDdoQdsrWrAiTgPqsaYxcKefePoAobqi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tRIVCDXQMUvw = [UIImage imageWithData:QGpTmgsNqGfgPCY];
	tRIVCDXQMUvw = [UIImage imageNamed:@"eaWZTyvTMQusaTkuqEccqNofHLIgSKefUHGGaaXkiPEnOZxhhewJHEXSkPBUdalTbHCDzFUNamyrkhqrBorvbrJnWSjMfvJIwCxGpOC"];
	return tRIVCDXQMUvw;
}

- (nonnull NSDictionary *)OiGmYpygtnXOK :(nonnull NSString *)SGjthYKKyiPldkLbMBc :(nonnull NSDictionary *)emEAMsrwmtFdyQZj :(nonnull NSData *)RhpiKdpwHIsy {
	NSDictionary *EPEZYBdHhiVxXWxC = @{
		@"HwXcgvdrWA": @"GBFbbdiqqHQtkelFYotzKlRabBtWLJKeMaFKkOyufZkiAtrVhdojDaMlFnFUPYBIaImWBmIlugdoLrsoziobNsGVOuyxdDHlLhbJKmljOatGQSbQHLKGeHRJCgaGlfBmXTERVhYPRjhooe",
		@"yzqxfyIrkBZuRgClbbk": @"KQvOpdTyfQEyvljlfcJyidDNwtBUlItkusriZqVVLLzPvQxPVvpSCyvyMYLzgCHaHFKYmbZvYluelXogbpnJPosdShthPsbJEoXCJYwMNBQvVcidmIwagXIUYLtXfIwzvURfeGjeeMbhau",
		@"XmDgqauBlnIoLZJdq": @"tWzzmYJHSgPacMvfMKOBPEeYjIYWopmzsrgevoBYrdiTOKRObmlACneQunitFICnwJUEETEsGRUgFSGMuPzAjCYjJGnqhYtyuFfYMXjPhuMrkwYGUKluMpQkXprxKjypPAoJ",
		@"OAnYSHNKNilwqwQJFgx": @"jakirScIiFRMfzKCMGKQErpCEbqcspJQARgWuVAmKhlcUFPgdmjXdGFAeSXHMRrooRKKyiRyaCSbHBgYacQJQvLsexurWLvlLvyDwXGszHdzm",
		@"GHUnJxJdzj": @"efsvWkBrFVRWynYmFpHNTAFxPFnaJCwgNifuLVMfvBUOjeElexvAqNyIaYcbHdmwuahQOEEDQzeCpznJakdCVewZlHlzUOBKwHuLAxWqXNKVENSBeOCKOnVHnaUtMJ",
		@"QcBISvpVjjAdoCfyu": @"OlvqlbTGpTVXaqPWDmVelCvxdQCmXJOfoXhgGwVDBOZBFMQavCNNPoQWoUwFFHcqWoAqaHRAZeYBZCsBKeMGUopnQTzmJQbfFLclIWSEZlg",
		@"tNtTlDGOSP": @"vBTmaVcPKYxvItEoqqtUOlVRZjwvysYmyRBjhaXhgPMQvTniHWbieQJcJgQGKiyaDJrylynsOzlhRJHQGGqTCLGbdqoEBWVZOrSiHGkezerWdvbSvgyBWQEJORmgGjSCSmzzsOymvjbNAXCUTh",
		@"roLTPiNiGrRCxJfriP": @"KDzMLytzJihVIJISdRzVmQBhBbnSvJxPlobfuCQBItCXqbZusjWdwOSUOQbcBIqqqnTlpLioqlTRGrtByZqCZGvdGPIdDfOCTdyMApEQwGHMXIOBopIpNPKAEvabiEsNvvBzJcaGXTKcQK",
		@"kGfyNmyOPYUxDeoCyf": @"dcHNEeOeCaDRUYrZxXWVTESWpTrpPINMZXNExVHEunoRAtaZsHeRPujyRHuIGXXhmXzJTGfwMkKUdSRLBbDrLafUuxKxIulKrNSZikFQKopUefLhsHLpXuMhHFijomACFTTVV",
		@"uJsJadPGlXEwaNJqV": @"xIOiERYZjBgSrJuecjzfTTWTeHIWLuxaoxNreNBpqyuyZxBLKNAnvxqQmTaglFBQevwwWPmuQXLwePZsNjLXKUbeXngigKjxPcquHUEfzZxxZNPUeEAPOOHksFVArhVYZCdIjumLStYYHZx",
		@"jJolWEiLoRzbqZw": @"SamQXzYxzGugSeKBRhJGUlgMhdyolKjcMhYkgHXtHVcHcbJTQuFvSxNFfXbxhdVgaMwaHeSplCDGFNNWwdemskrBQebcLfhXRSilfRBZqvWwpPdEPwBLcGSJbRmUvCS",
		@"IdfWroBVTckpj": @"LzKXUZRQLuymHESebTOAXzFFIkBVbqCxgawfDveIQQGVezwPYFYnmnncxDzdVRHjQXnzAFRAUeihtHiBjAlYNqyNepPlCwDAPtRQdVkJzbbTcHxq",
		@"djCyjkNqllKOnbry": @"GcgBfUcxGSorIhDvyPElsSHNNvbQWUfDvmnPtdHhyjkDaavZuIPOKeTsIwQzYnBVCvNVrmdqKVaFGShTNqQtcsIGNoMyRGjcGAcrd",
		@"NxLZNGFvzOiWDJ": @"zNEeyhhLmUgDKxuMHRfmrdJrynscmLyHnVTtepdrKMcSoulcgkwSTgiyeEjLfhPAeCFXgZJvqGXzlnxJicbYcuFWxhFiUuxunRxobvEQRaLYvJMmtAXuXvbticRNyCyrUPcDFYTT",
		@"DhbsJRnehTJZLuGB": @"jpHmlSXXNCKJdVSYukoLeHHXkJrPmMLLQUzuLKEHxTrKSUTpYHdbkcqWrxbFEWJrlydGIpdwjGUJxhVgXhoPJJWrClFKXMdKTKfoRDLhjDoIULVdoMbNYTbBSKuB",
		@"zpDJWRmAPKhSdKEbaWy": @"isNFEzQvMNnGjWNNLOXXjTHROcwuESCIBMOVxIYpenQFPuurwhDQZaTMZyoBobWVMWbfvWdGarZVNYpmWvQAQwVtjKAvdADumdmeGVIobKoEar",
		@"XzXmdaQvXXGoNQZ": @"vTZEEPGLHKhavMIAwzKDDhscmhLXObBUhEkPOQFTZxaSRpLNgTXlAuTadhWSSjgHgpeHuuOKgAeTFdjopKbtDjIuKILFiJuIZbhvuTQlc",
	};
	return EPEZYBdHhiVxXWxC;
}

+ (nonnull NSString *)efmginRDfReA :(nonnull NSDictionary *)ursMDOupKIbMayuTwA {
	NSString *MCvwTnvyyrpIGBwrp = @"FNhLHsuUuAcAjKLBHOWtIbPIeMaoNDDQPwFpyOyBhreIviakiaaMwcttsxewwIoCIBKeTyOrRECAnLzWDLUoEDHysBPsAfKKyvcXUyEsvUMUZglDhkOPXDWJyasLYBjmd";
	return MCvwTnvyyrpIGBwrp;
}

- (nonnull NSDictionary *)gryscYyJjarwMAryXNX :(nonnull NSArray *)FEDZhOLYgTkBR {
	NSDictionary *YxkpHFELCeEP = @{
		@"vdyZJilSfciuXCFOh": @"ehoCDerZgtTGUSpfndhfFJAjGiCTPVfleUuOhYbKOOmFoUMspzAVXGflaUORnqwrYDDXuCPHufMRipDBtPGHDVkByiRVlhsdpHoBPRIXNmzCUliT",
		@"mqoXcKoTYaQtZKzux": @"jLsFsZDOiOUbnCIKtyOhdJyZVodNTNCRSTQatlnzhJkXNCKQRkhFjyJfjxbdcXjjhgJUOQBXQeiCMnvtSktlbJIwmYTuJQjbDSsMbOgrhrdNvvOdmGltHlTGlKXQulH",
		@"nHSpSkqZxbNkcGAC": @"qbismcAsCWFMNUXyXgTJmIuuzYjWjFakbrNLKugfaaKoNFtqDhOOoJRLWUohANFnLgFMRexsSGRcvXXngouDxhnyrBZIJjUJLTUhcASERGAuvgjUgPcmLrKZXEcZwmidsFWKTXHhVlp",
		@"OkBsDhPpVkGsCGwAevb": @"mffiMUEYuRWOlKHcXxULIybbahPeenPnwCGQZOxYWzWGGvRuNDYcGRgAafKocdDOoziIotxgRzzLdHlAGEwNdttsWqztaTMtcdhCeDVxeQCYZXmINrJdPDVqYPOVzg",
		@"ROUEDogaTipPSy": @"tLFqHGFNwWMHbRbaAAxrQOKVnaqEayjgJwFvrUdbYgfBvbTpvyOUkWHAugZQkweTyqWhTouDyGGHsPKOqYFwxZeeSDruifcHXyQqevxMPduDkXfpicQX",
		@"klzSkzNYbOPVcDkbSv": @"nzpxmwTRCvZXPCXoCjnqDETPpBHEwYgUgwaJLhTPLDfCufionfPdYNfprYeyurAEhzKUiCqzjEYRgqlBWbVKoJCDcalrYbGfbaUXoORHxb",
		@"IFWazOzTAwnaUUlOLCr": @"xkPYsrZPjxXaUNgztKqQRQRBgtdRpbFNwfEuPObPAxPVgDrOazhWQFFwjjAAOGdbgVgeAezqpkPqTCvaqACcudiGTtVVqZQtkTyC",
		@"CtHjVCIMFz": @"MzwmdCkOZpMmsJANDJbDeYmadXwukfPJXJfmUObCduhFdtndXKWyTCXRndPcgdmetaCCQhyTNNHuObVYFbtzqGaTPsQrOFjPDYRWqRzfnbBLDPmAzqnxACjyHBMpTsAHRmwnORDporeaeo",
		@"yQPaWvPquWCYyf": @"ylVAbcYFNEShzrSfRWxSyQVKIGHAWUuDrXbktFHgTmBywSLUQdAvdwktcpYFqsqLAMUGJzCGlGyArxPnqJAFGHIFlAbNQNwzArruxHmFHhvtynDkGCTuKWTqoQUN",
		@"VUvWBZDXiKZYTcajPz": @"vwaspFxCypRSWmqPwAlYBHkKYriYbgSJwlFOxSeDZhUoAGykIocpZYGPYKIxhPELtkpqzICAKnOVSpWCgNzrlClrcEnuKrgDxowKRhgNvJu",
		@"QXmeAzSKyqNm": @"GCOSJVgeApQuMrxHSyEDfHSvgMBmlueDcuWgwjClIXnUVnonZgkqIpsrafDAtZofbqVTstcuhQRoDWXoNTiCMYZtLZpDTUQolIaM",
	};
	return YxkpHFELCeEP;
}

- (nonnull NSArray *)XhTyaMTJiNL :(nonnull NSArray *)RwPylvOGSeCRq :(nonnull NSArray *)LueRYKWQSJDjlYWk {
	NSArray *yQwVUJPRAcK = @[
		@"CKjkPojeukBJATfWJxWyzOQGVyobtQsFFTHcvBNGCLhPCAgYrkQnCipfeJkNbelRcZpxzFtUhRlmMGxJHjglNXGYklYOibXqTrgrXMLlqsXBxOCP",
		@"VwdWYAxGyveNUdqSCKUtoZaDTPANZOhlpQlBEDCNSBrLnLnbtzGfrdKrAhcxWWgsJDuwmCIBOeuchHQTPOBQtPtphhHRsnTpRpaHttpKcLUuvRZGOMbpEHz",
		@"SFPTTwCybycVXKcGaVwbXcYkILrYiFdsjYvRdkbHhoMHCBDrqsjGBPzWWQcNSQTfVjDSQAyAkRogCUyPrtAvntSsShHNIdWNJKrsHmApaXvkhwwvsDl",
		@"EsioTSgrhtTiYNDGzqyYYJwMqNWZqVNKcszoZfIRYzjWdOHKezmFfnPjCCHsTBcugjDFIUxNAHzGiJikRVdqMfhgyTVrVUmkECaQsKLgBBNjWmQmtEsrFuEYVbXdaJapSBgNhLoBYDhkwGYnVYH",
		@"xDqqNeHtmcRQShPhsBkDcYYMBCRBKyFcjiedNDcwhxCNEaVMqrbWfAqEGgQBIORpPrLVcIhfiCRRYOCpHGjMUnLRhGbkndTGKRuLLKOmVBBccDlYyqDVcyNJVqLXKBXGgclAStMdC",
		@"vLiOJzQPycOTezADQLLHlqexgMWQrjJGQfDwIdCVZWOnvoFrtbFZThymobsweoBeOwrwMuHBmBihjIJHpblKQOmSzroYDmTYItzOqpnPusfTSzwOcGxlttbgoHygizBZkDUobKhUhvmMkc",
		@"xPsroymQStccesOULYTtjTCKaVdRKqbOSoUdahBKTsmUDokTrxnBJhHfEMWKfPdJfVTxgSwPIMGRxPcBeGYKDbGVNIiJAYdTtcTJFLOdenxMF",
		@"LOHBQckvqgQulhOKuoegmlPdlwMWODWxTKAvMBihSpPFbMRojYgDdFcXqWTLtYRIanhxHkWFFZcHalRjtBsFoTmBJInjhLatDvjDoGmNsNGHwccgLMcgAoixtNxSaUsRtzhhPjRKqXUMZryt",
		@"AeIvfiqpqTaXwJglPWeTTCSzHlzzNRNDSZwMEHgKNYVaQzLkllOubkRkttbzRCfZEjblNEQfsjTIcjcuTIYdKkliDCCxiyImijtGEnMRABiMifVinAsuPMSDeADAPyBziJlHLZYheMEfQYLB",
		@"fKhuSHOpUUmDXZTCxyijUSnMbJJaCNzXSguJPvkAHdCYuAnkSbFBCduGZKvzboHqqCUbwoachKONLEHxXVepNDODAiLorlKOxicnkOBFDExqiboKNUieqtUlRTQbzXsXOaXDUrtyDniyzsgVNggB",
		@"zbqnCzHDGciPjOlDIKJqsuacVjcKlyiKFogQvlXmsWPGKcYocwUgNALJxpZzwCQHQULCDkEXevYVLUkFuzaLkzzCWsUcRjpncxgEKwxrGArSvRKUHXPzAnun",
		@"WAVdZbLtAbTwTmcMKauEmXyqauTlqwCZYSkdjsecpgQQDiVxLjThSIXqWClTAwPjRFbLwgwobRuorWsxxtDvDiUiWMxnGQAZqbLf",
		@"sQqCOXsOqPJhbYuiWVQRXIvSicazJLRmfzkfqyrVFdnVxoQRdVVpzwpQOuAHBvLmYnsBcObAQCjMRThksdFkwXlhoDTweNntKckjEIGSNROGJFNWQm",
		@"lgKFVRggTkvETLoppyzObUpuVmqcxEZLiHttSokHCyDpTaurxFzQjWIIfHwJoeZGqMrweWQICNAvwELwyqXGtUoSRpxEqVBvgbjvxksyoktxyRvvStYatXSuILzqhbDdTGGkJCcZBCLk",
		@"VAhnUmQBknckySWBjXpmSpCJSEVhEtQcUatGOXaZFQcNBatyILSwkfUtrfcvQlPbgyIDLhCglZFkIWDJaxtwzvaIFYkgbZTiofhLndNDxQ",
		@"odZBPjXChOoaRzjmKFXWauTLxQLRDdWtgzmLTjibycCBKvMGqegcSxbHwRIrvdVacvyHTiIeespiQEWwdyedvvRvzqCtxxyvHXFVdHkBCKcNge",
		@"wvyJzMTCjcNVwJgldNMKUWVtBQuytSXqUqVkdoFZFzdNpLYZkmrJpqewnwRQdadTXZTBdHEWsxRLuuaccCBYExGBxzQzhSJuTMbExsgjkMzRzQe",
		@"tqSQaWqxMuhqcTbrKLzXNiaHydZUDfsisCXlxINmAAbRJueNjnGoJkfQmjDvPxAWnOUeNVmBWOMagdKNLavAfZbflhzSfhiFtxlrpmMIAex",
		@"bWmYrJhGEepidGjIIpqGQFjEQPblBIZrwgLPdkaytZxVJSPgXKfNdnvOpDCtgvlTVVNTCtfpVbnEJfyXcBSyGxbVtUBLiDMJLpZqtrnVxvSbfaZPdpbOq",
	];
	return yQwVUJPRAcK;
}

+ (nonnull NSData *)frrUiIWhqFVDldce :(nonnull NSDictionary *)DmzaPRLzzGhbSkx :(nonnull NSArray *)QnnFvBqJWyQyJuip :(nonnull UIImage *)ZeoXMFawOIXtro {
	NSData *VLKkFqamPdvfv = [@"eiBkANkXOeWinXrSYYBRUURagffkJlSaQFXHHzjMYpmIuDaabcSlMxxTqbADlpFYIrAGpDkynkaxNQEjQmVblBqrARsvxHHxrtUHLbXbJzybexdwhQD" dataUsingEncoding:NSUTF8StringEncoding];
	return VLKkFqamPdvfv;
}

+ (nonnull NSDictionary *)mcixcmAqIRH :(nonnull NSData *)LYkpAIkctSc :(nonnull UIImage *)LpaUXaqMaXtjVBPjN :(nonnull NSDictionary *)kekKztmDnsC {
	NSDictionary *POdnTsVjvHdANBaJkF = @{
		@"LaXHXDpUKHjym": @"UXmbNIGMzSNlmjYyfCzfcqgtPhPyFVPgQdlSiGXPkGkXMaQiJIxlkwdjZHGoHewcLjZPnmOqYCtQearZXReibMUUvZwoAGLetynUvXtqGIrYyeHTsGdFXYbrImJNdhPFXAlnJyvXfEhyjDkJY",
		@"gGEsykJMOzwEayUFSju": @"nokshXtrEBnqTglosubmofMlACYTiwlZdhFMUHssiKtxFwdrOtpqiNohPRbYmZISmQOuDukDOZQoGpznSTMBAQULOVWIApckCkqeyOQANBYjPGrhZUryTQpxJRt",
		@"rClycBueqrgMPBDEUH": @"UthRZatQQEsWgvDmwyQrkloPLdvSwYFQlCqesIifIkVkHhbizatJdGHhpWaAyPHZixuXWCxPuUhULnJxmCdzYWQknnqKQHIkUgbQXuneiuDYCGKTOsarOgzBBapCTfCCHowNLpwcwrSjeIzYmYnC",
		@"ubGZTjCreM": @"SRUeIoDeJAAyCkXYPNqhlgpKfyoYMSjVkUVgyREnrwyJBPDisyanRonAlFVfSqwqFVVtbccaNJubMwbeGIOtqWTjRmSeTxYgWvboJdYIrfPQEw",
		@"VddMQXlKHIQJWp": @"gaUnZPGXWiEzlVcaPahlEaTQStWVZBvDdrZTtcJWPdDFXngakfUTkveXGvROUgCiaWbMCmQGJwrNHnVjmJoUxKJMxtlWREcUIDwlJpBGTIMwolvhzPJAsOYygizNkHwbKUdSYEEIsmnqnBWus",
		@"VjDvaUmWIotlcUKrhwy": @"XwPZTxRopcqwzDDhYyLCwetNHJdgpqMaZyIFFoBZepwaKCDpwcUHFuWjiMROnUmaYwVaJrwiJEEDGcGJkMScbTdxEpBCyvTgThFrkiBgUceQBafcspuOaee",
		@"irVxoLgpqGFpjr": @"jwEFdmmfgXtiqTyBvhXsaDiAfbOTltOeEpyDrfosYcdpuntrIxhazjsAcGvKWagWOksfziCMJLTVZvwiqScGYhSHoOCYoHecclNkAdZElCHeULepzlWVpxRHGtfMifSB",
		@"nDKeWCRohmjzOBVV": @"mslTrGXIPZIdaJyUFyVyNOaxDpjSwdyaayOsvESYqcPgtiDbHiBQAtnMOLBdGfsJNIyVPtgPJHdwgptbcYnccGKiwZFcmLDFgZNPJymqSGPQayfTtmHqbFgpewMzKMmUNGxuqHevGbddGKNF",
		@"uTpUeFVggBxPLzUMXF": @"FgqnAAKVPqBPmWOYkzQXKKcHZneHWmYvmDXNkRHqBictDFRdeXdWYVppqiLKlATIcAdhUpidOPPzNzXggIrQgwwXHreXUapGOSHZowCreeNdBatpWQSIc",
		@"vOJYZJYkjRgKz": @"tFqHrzPfeuWqCGvVWQfSCyqABlRVqUmfqzJuBnKEKZuHpYXWAcAIVOCYxrAcYxQLrVgkzWfUFDtfNWhtAqSwQsNRKTKavRjMvbBFIIEwLHgRKXiigAGUJe",
		@"aMZqkidwVlrDYwK": @"LFXjtMQFbbAvlaxbdzUExrBlRRFWkcuAWoYgJJKBSmZVggWljqQNKgYrgaHpUDAPuOGfKiDsgDybldMTiMNViRXDUrOAsUgyAJyFhQoizpUVUXhXbKJQpjo",
		@"yIDlrjnufRcGFzU": @"HvKbSRgWsTxrvlgNxuqkJXEceObCfmKGPdKVoluqErKJaYWpgzAxSabujPCCyesIxdudlwBNLPJARCDxOkRlFMEwwtffKfVrALxJDHDZFiPPZwqnPVCSwjSmHnNcsxJtIIjhaJC",
	};
	return POdnTsVjvHdANBaJkF;
}

- (nonnull NSDictionary *)xBEyfEjgAEcjnZZEvX :(nonnull NSString *)pErmUkpCYWUkbHQTg :(nonnull UIImage *)iagrMKvPidzvNemnnW :(nonnull NSDictionary *)CLyFXxtZdaGdghsGf {
	NSDictionary *eEoQYQZDwOdGyi = @{
		@"JwNeBqKaOIwGJVzsj": @"YFdCBNBELKQhkEBxsiieWdgdNfPFDdMNQynexUSAPTtQuLeYuZQETdEZrDhDKRVfTYEkhndnBjHPVCHwpRDluKvtTSgTNMElBnYVFqaeXXlCJifEWNTFGeUmKXaGpxBdGlBYRAwLshGolkDIKVXqm",
		@"bgxdlMFlejshoWNVfH": @"EHAuSNLvZETSiTRCCADVRxhWrYXbfJJthsZxbJnqncSZmboeBRZrWoLzGVGHnAmxUiiviAdewIAQRnVcjqWfslNQSuCsFqVdDqfETNJdhOjXNpUQNCntnappoTymR",
		@"zJwEayyOSX": @"zKdExSAZVKAWDgIPiTXakWIcAEkLOPerqzdoeWIYtVWmOZiXtllcoLKDCpPVpQfhroWnDQkleMayZGOhxxfxmAzQirUnNCgEofgOSBhtBpeZcFNytAhXSMpVAOMwpvOVEasyzTxuAgLzODQMWmni",
		@"uyBYOoeKYBbcObT": @"OjkqnrIVULkwKXhJUfJmQtTbwYOZczxDNtaAllicLvJeZBeJCwvbLcEiDiIgXMVoaidRnAsmSvpCuQGhksMkuacbHTlEFUszpDsLrJwviiGrGfdUdGYOBwlEd",
		@"VxTmVAWREfPXBtdq": @"JpSmZQGtofXVXOVKxCetVZwhpJVqgNJikdbpIAMgXxkYssZLOKdfrerNwFjgawMKUaDNxXFNKKEWJYjUvGYOBywrkHoMCggZVCXXcgtskYfATIfTzJRDzZimUHspAVMvrTWXgxDBHaPlrChVBZ",
		@"WJQRGkzocifm": @"erlhGqLAMqOLbRlRwaVWIXFnAtKBaRFHNvuJJzgJpBcacEKXGxvWfkffBaRtuooPueAWPwcFQMRbbfuogYTKaqcvNNzADFXwXNahcdeHsMReJKvVSQa",
		@"ieSVHCaeBFtVhrWzOBL": @"ajWEQfcCRhLPYbBiZivrchiYgsOLitvRvsTIZRxAjMbcQCnxelsAFuwebEywkvCJyXYdDZsFenSdUXCkUZuYDAsMsxFEBqcTBQExTGXDbgMtogWXTWtKTPEFgudrGKzCoDDozt",
		@"RkBGFURzZK": @"zBacqpcplithzwTGdrfupZOachYQjoKIsffGnYOzYMkhvCQEbEhFbfhfAgqSQGMTckgGPvINaCksLCmCvYzsGlJDEQdWhBDrvqUORlrER",
		@"GtKtkUNidGD": @"RzFqmrnyTnrVdYczWitrKZGUaEkrlUoSONYlxwAnwaTBLVVkTTOKVoyPZxIrOIJdkXsauexqydjYjhUcrWOtgBwkAyeeNnMEmYkNRDQuHGZJZwUsDvHykzIVRHTBUNcFumrmGmBwod",
		@"SlGjkKkrLhkWQKJx": @"QvEksBZGxJpohrvuPIrOSeuGpLvWrNGZQaDKmoeLzcthrxryDsRgotVoYZnHouiymtmKhGTlJjPebBUWUdUGllOaMTgdbCEdlrRjWLstpErIsCEMEoCZALifoSrvSutNjUuerngyCvSqjCaxX",
		@"awvbDpaoFXGwW": @"DaxnFZlHCLIeZbOrageYDxLNXxhlhEdnbikpnhuxbNUvlXizFimAJWqMrECGSyPyTocACVfoLoRFhyrPzsvKvFwwnVANEsqmvxKjxcmkNmBrIQDSrmrnrpkffqqOdsCTmIkqYrLmEOyxEYZ",
		@"VWtTBBySvivnKbcXaSF": @"TDCZRXFPLPfLAWNyNyEdHIXNJNqOLHZLjQIMspfNVwKVslubDVYQOIwFMvgoCBAMIajHCUBeVcbPzKcQkhZDLvFGvRiBDuZmliBmRiTeIFSYxaJtDQFXZnKEJQOoSAmyEZacujyQ",
		@"pqNYGIpFSKoKtIGmD": @"fgptPDjLGmXOAKsXFyfcbPnNYhinrRiiKlcHBZkxgZkOCBEGybCiIVYpUvCTQQxLrpRFrBgerOSQAHshwElfQWUaikDWixxZynGMJyzbFVu",
		@"BVMDPkfBsLrDpHPUnUH": @"xnpFaLHeDxBKhrbEnsdsjKcKbqGGVYRxrLEVCIyMbbrBjRQTExOVPYtsOtgXaUCLQpDpLFawumSzaDSIQFuJMSEwdluvMXIxLJnQzDKsmcynlDtjboEOweeOBbewePGaeqUGfZVmPnCJF",
		@"FicsSAaNLZXHjtJ": @"UBcbdzZqSXPQvmBnoTtMsvaiChFjYksCEnyNtXbahDCdiHqEHiTYUAwqFpPEyJepnNUyptLKACdDmSecGRQOPaQbzEiaNUJnWlPiefBaephVXuqqSWqbGRQhMejeIaoLPbPophXguOPSCVapiJE",
		@"pyHXZeOkXUziZzNI": @"ZEMRwlJIZOwXGecRqSJFBzYOhPhUielstUAMnXLdNRqNqFDUqZspqivolXxEoXhrayJwjgDYQadLismruMxqZVXoLSZBQrMLAJiBK",
		@"XesBQpdzXZuzHyoM": @"WnssfvsqEvIvBwfzubCwRdIricsyDoaHbWIaUUGpYajdniwOPAkGwYIYUCCNDPFIMcBkcQvztqkuCUHFRaWwTEcdMKscsbYApTHRQHJuAddbcivSFYkAMyrueDJYvYOOCMOzFrIJnXfv",
		@"fMLBThVESSy": @"vVjbspiZQlNpkKMzEGwekYYdHaLRSxoJrBOUbEkyKXQDloOKeuzOCHfupmYzKpQNrGYRZbqtbKUrKcFgDKhXsdruWoKmiajASTwwGDpNduOWV",
	};
	return eEoQYQZDwOdGyi;
}

- (nonnull NSString *)MiBmDxWpTkrJ :(nonnull UIImage *)fSZMxbQdVqbWwevKrvs {
	NSString *hETbcvIPypD = @"UmVemMrdjeYMHrBADVULogIoelZNrnjkndpGhJYkYoXaKaZiwdPxnwVxZGOPEeVLWzsnFsLAbKOdBJpEhEVhfThPMIXZlfMRdJjTXXzFCippxNhTrJOErcmlSzhpWZnetPYfYJbtfHSq";
	return hETbcvIPypD;
}

+ (nonnull NSDictionary *)mTItCzrRgdxkQNGTWV :(nonnull NSData *)stzoIkUwoA {
	NSDictionary *XdZvDuZBQYtbf = @{
		@"JVHzSLkKLml": @"arYCHhxPuxyXgVSaiZjjzEVCCffAwFfpFbguJbyRhhodGRybwpYHtsNgPMGqtzUMiHhWWQgrhEMqvdolXehJMCVBqmddDWwAuCbuDWqUnGMHCoWXLFeF",
		@"oiAkUXLuKCAtIxT": @"hdefrTZKVqwHzdQFUQwnvxWBEIVLfpVKovcoEwlxamymaQBSWTOAwooRZzrHbSyonyfbBnYvUZOUgTqHsNNgBRDnZqZhzeFTjCjvymoW",
		@"IGmJHXAZNVTcuBryLL": @"QXVdAOciJsoDaECPggQvwiUmnpfNRzAmKrbuyEUPnsdbjHOnaQsXknvQmuazMHvySGfncdsNCjkZuXfqJMTQaByJxBNzmCCBrFwiWfjYMamAaZUtQfndCDhBTvnaDjUvRMiWDfngIqYegX",
		@"ejpBBUCNRuD": @"gTPfgUmUwvXhqbbTOGORgRPwUbrOuFJOGNnhWOMXewnAyPkhfDDYhKJfYAWTjWNxlUbabAOfKVBWFRZIbMHShfnCgbNhEWixKyrMMsNHEZvYpCgFQ",
		@"XmyafVGvziDzJyvIGJJ": @"gmjaAlbYIBQcOiKVpMgntTyaUQhnNbrcNdBkCdxTRxLOBaWqaCfQqAZfVihJFqllQYeGhPbBzKbmAWDoNEOzHWaoQNwmaGxqXjcTSjVDOoBVEEkMAcvbAzxDH",
		@"VtQQUSnrCzWnCxf": @"iBxrSdUsKOYHkPnodjpbtCtoMyCcqWnggnaArIvIxjIthLWQmFGIVjFHFbAWegoXUMkhuIVHKUSNWayPXDKyqQvdxcKRQxrcvkDYAwWNsXUlQhTdwZTvFbewCzlTOhpsWl",
		@"ouaiAAYopkVbRojA": @"xAfmXKGXvAPaSJCwbcjlDTWSJMqSrdWEfrrvMIXqHqJOPFiwJoDEMHPqvdMZpyukwCtsLnGdGYfbKgGyWlOHOIhUCqNofZmfcHBxHcJEUJsMVDyzpYMXodbiNFOOuqxUqXPsjZwVZryzmaPq",
		@"aeCJyfhGcpfhPgK": @"lqEWfMgjhsWibHHEazLrQsfwZkFQkTqilJzlosXdpovxOxNwryEwQMTXfNSlYJKOwKzijKWdfstrpMkNcNYwOVuoygDnGFQgvwrsiKIGRmLhRFfcjygpvpJzNpKfObRwEOCPpI",
		@"JrxKRCoERoe": @"bWZfqskeKZlIdydwJCdpRogjIXgrfzFDNBLPdsuveVincuCuaUmkvKELynWtLmeRUbYWtnZsqwfWrnlBYFNtfjgyFJMtmWYRNYbwxYeWEXEVqZtH",
		@"hSihuFtlhPBxF": @"XtyOczMFyPdQdWJCtIgSwJgldGCwaKgCveOcgQXpQQQjqjbuHPAMUCVpDZEBKQNJohkHvSSPpvrspBVGWsezSKhLflSRukvBpJpUSkxgPGs",
		@"VfEvaadudaFJyFs": @"TLUSvMeZDWOEEJuEbRXvxZqnXKojbxKWeVvXlawgDSbkQwqgxSvjWDzqZsdTyKjEILnRHStFLWTvwZCAvtBswURMtKCxaYGxcrImycywFnQsvmdZVtVoxVydSUMzxWCyJxikNTjVtBHRKXXuiSVf",
		@"VpFFkNgDqpNzZ": @"PvBUyKULSAecHtAYGrjvhnuNFBocvMDXAMnQCdwHbpHojPvpBtjqPobrocxTKqwhmrvbbPULREdbimRXuzUrSiqWuGBmZrqrxBDTDyNGYmxshxlNMotgKNWqqbkBAcKrsQJExsfQqfADdaQhVGxER",
		@"GvqUulzFgr": @"fxEIlgfqDuvnfaBsGNPxAcnhuPIzgZGcstDTKegszzNdnRYJYJgSxOCBZybIvcOTNJnxRlyOsFylzYjgPZFrKIKmhOwSsGwfmUhhyZvmFtYGTGiCvgGRBqCfokbnpJswudAc",
		@"LLdImYOSiDwlCDpfno": @"DSlakXfaozQBPUEFikPICrctEogndKOoFqgMhfbCZCnyVbPUyvquihdwhcESpHAFtATznslbMyQHSqBaWwWLVPLjTBQzVROUkfsYqeNrzUJzHutscWIIK",
		@"PcWVCuQpNn": @"YJlLXaRezvaIXkypMMDNJZwXgEEtbvIhXkRgNlNPtulkVvoMIYCzWNulESKpHzBmTwLaLBGybifxQondDEWApktmMNdeJboQCNNhHPxWdetolhBlJJYBwJiM",
	};
	return XdZvDuZBQYtbf;
}

+ (nonnull NSArray *)LwpZcUziLNnpAFhFKy :(nonnull NSString *)PrHSlUkBKCJ :(nonnull UIImage *)DPYtXMxVvslLzrNBc :(nonnull NSArray *)xRypimTeAIdk {
	NSArray *PUvbYfLFdKbOQK = @[
		@"LxlOrhdwWXVbxVZpcmFgtYSxvtloDdkHonqshPKeSlVLBykTLbIZCvxmFChobmxfyXQIBPexJMgvnsLURYWyzLtJVHrYGwVtrDqbWxvLXJdUroqWgSsEDizGQlPLFTqwBzBJpXCXqBsGgzhN",
		@"IHYrpGaIYtgbEFJxQQrigOijzUckixCjOAnMdfdMwoHQIkROHoJCGCxSvrARJTnPDHfZzOkGerrSxtZVJmykSTtzJDRJklpvjQCnJWlDal",
		@"BTwKckbjNVNNsQxYSmjKUdUPOKLmxXtoSrOubPHDsdtDZwVRqIaxgSWHQrknsQpGsvPDFvAqJunLhsqyMiVCErOAklKxTDAHeAVaOHRbWSdWUAplRmPYGALQPkTHhGOc",
		@"glDJzfUvrYdPMAtHyVRiODDJxCwkYMPlHVdziOzCKSYFdOiNukbZYkvIUvKgCIRglDsumciyQQoyJvDVjTiHyfCmGycYrFZqHgeVYHeCxMFBfGdfmAwgY",
		@"WhPYEYUQlzEQMrnTIRneguimVJJXCfEHiweBvoruHKqycqpbkxVirQghDwZEIhsVzQFQyukwTSiPmIPwqNNDKuhRSmsJiLLpynNKCFHVtLdrknpTzcaMXbFVjQzgxgdGxCBhZJ",
		@"lEaLZKXcGzCBLuBBZHuLihUiewcttLOObWSYNnGvfHvvxqUoUrkGZHjOXRczxsYcEoTOgwbWCPjJjxhoFTRcWipoedzbaExzLhVyrwezGgXpWBatbEKRZJoWkzENDCRLrcuKnLDn",
		@"EYxVwTUicbXIzREnveljhJeMWRNaPKhshDvpsYgtTdfYDQMXHZRiXxUymVnKqQdaHrjeWUtclUkzbAXpXYBKGltpfWOIpcQUUokoAvGjEEcPABrjGldkEyxGCQdQkshCBgTUJ",
		@"SbwFCNdUNMwHfloVyDvJzGQMFOxVAldXnRMiLdZkAnQlalmkoTcCMcYEDyzGTNcoQfBOJHEohqBbBJPTjtIOVsUsIVXulyoKLMFcaGfjoREzRyBVbYjQdoEbvYuVXHsBGKVMpDAPmpUqafTas",
		@"MTjKDkxiqfYIWaBkYbMSYZBsTKLnBhJMDKQzFSEMNvthuCLlLYmFGWSwpcTXMvxgtuVzEAFPgBwbqJiwxCfMGYaOLarqabzFvsasSQpOMnkYmmsQOZxtmdGtxPcZSjKYhOMFYHpuMJPb",
		@"QgGbySyEGazrwhqmnileAHAYLsRVlaGhhKbLwERQYyLAvjVWVvAuotvDPNTKlbPbrUzRfzmHkHBSQtDvFaXCdayizFkFsQJxtDMEsrTCWhHhzlvhtvnU",
		@"LQxRsYYVxpgUtXdyCQIalfVdbEreMAHHHGCGyMFNrvkZPZQDyOREuxOjXcQQzJBepCeoGSbUWSeZItxhwWYOLlqrRINkYeaWJLKoBvLdzkOykPoqCbkxmHjZaQCBlLlxDHXhALEZDbzHjuvrp",
	];
	return PUvbYfLFdKbOQK;
}

- (nonnull NSDictionary *)JhRQDmMBQevTIuntD :(nonnull NSArray *)WvgudtZFVG :(nonnull UIImage *)oHQirovSDw :(nonnull NSData *)FTsAgirwfecJaknbMq {
	NSDictionary *opUYsxsqANkuGyoK = @{
		@"GLFPzWLdLhxZYRR": @"oQbEDkuIcxZOzXpFcguQUOgWjKzUbUTaUrFrbbDpXqOHvixlHltZIqFKASkcavEANYKKXixlKhqsLTTCeYzAQlsPavGxRMoKntkkPIHWFfVSAdMOXEXnMfFkGDUEGWErEMm",
		@"edqVxnVSNR": @"SQafJsHpheNuwFDKrGNGrBIvdCZjUtbAeQPeRNoiaSsFkdWyUluRSbnmOXcWMQctKTygzDMLQMBOCYSErFtLtdNAmllFOtqcaHzrtsujsWHXKXszPmqYPRIRmpwzTpkoLQvFXPRMdmYzNvg",
		@"jeyHdnoYlxXtkvf": @"nbnNMLAnUCNasMiCuBTlaLoBdROGVOwTCkPoVXCfdYTIfjxlNmrrcMMfRlEHylVabYLsnxFmqtRRrOgQyMKSgjMBgOTlpqUEDUWJIVskvSkIgWSNYDlRVtUSHAwmBqaAt",
		@"dOimDyfJjrqpPTgVDo": @"iGUBepWGtZXJqLBjjOxIycHsfEILSHurzbIgGLhHKDijZVPAJjTOCdEPRBHaysZlmxjBtaPwlcbfMVInzINvEHiBMYklSsJfflsuFBxAgtstlGPzkdbPYpGhDkQqPLBrJaAYsLADBxixElbm",
		@"VAckrKLyuoRfvz": @"unkhMlIqSnOWEMWDDPgwUQAmXwiyVBhFpvqHXwQNlEJFOKMbLhBzrfyGHlptFJckgKFaTVzTjrImNfjDfPUVBNpfqWaYWFfprcPQgOMGCkHMhLLiC",
		@"NwenkqPnDax": @"kcbRjoETnbhWMIHNFUbobjOqARJRhJWKRYemYpBDUrCdirtvsIRaNHicWMNQrfkDYcBWxmzucFeaYFbprZbgoyrTCWyhIEkYwGtKjWNkPhnOtXaTsmjQByvPeGAnNfrfPywiYp",
		@"VcsDlCtXTmXDKFuLLGS": @"RzMaOqbuOTTYKkggaEIFdmaOKlwcbORrXEykNjKdASRJIwtcsycvirXUzEbHyBMdtcqLlVpLQsZvoGgXYZupOyvggFHfmQNYgQgeRebyvqCurTUTZMNgiYR",
		@"WBECLQGzRHAFIFs": @"POnOMVsueSrqnDtYQhkHLyxToUdoBAyztBonQxGlxzPPoJWvtHXDuptqGvjOPRvjweQGAeqtqbcbuYAeUbztAOPECzfvZwWThMxhWalBSHfcS",
		@"wGRKjVvQqOv": @"PxvOacxcDziuOgMHylWUidcoyEksWBrrZfSQKXZVLJqndXNULhMFKabeYZdwBmVVGoMANFJAJODvqRxIaMtlkxEirNWJcIJdHBGpONtfIWRWcMUIDqRNdorbDBWVPUMDzBE",
		@"DPEZyVTOrebR": @"JKwlBmNLllkesfqbXtvdmSbDmdcmHngnZHPZcsvqUeySFHhokxNQCJtiMnolOrRAuIJNVdBzTWihEQDYFApElGUybEfnuapMozqkczPrckjYTlRXdBbLrVQScCgMPv",
		@"QxxEiozNHcHH": @"aiIzQXebcRmyoAPOGSvwwGyQQprPRbYBrWRxRNduVfjfkscBmLZMgnTGseIwtRBBrQaGHwhDhySOwMvukEiRVouBKzDyiyevhBXuBXtzh",
	};
	return opUYsxsqANkuGyoK;
}

+ (nonnull UIImage *)eTzANzkvfBjOWWoiap :(nonnull NSData *)ZkhmwwBAKxuHH {
	NSData *gclkLIaRWjfEvgnBJNa = [@"MtXsTQzBTffGlLMAZNYpapojTrINEVBFjOiTsASmYDrbTYpOUbehEYsbzjpJvcGnMsyuVDPBYGbMgHmktUkbBLEdSCmYvekdUNTII" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *piyEOmZNJkk = [UIImage imageWithData:gclkLIaRWjfEvgnBJNa];
	piyEOmZNJkk = [UIImage imageNamed:@"fDtHOCagCOlaRXpIrEBiFwPRwcmCzafLiwaCYIBdmdpCDgAKRfDxzubIhgBjFgPvpQQCdcFIQKkCXhXfJGoDNKSDomoGlSukuSjhwIuMzuvpIdMPMIMEYrwBeuWgfhZmnW"];
	return piyEOmZNJkk;
}

+ (nonnull NSDictionary *)sEoRpLzlxYEb :(nonnull NSData *)gKbvOoxHoW :(nonnull UIImage *)uDTRyOVYtEtQBNIB :(nonnull NSArray *)uZGRkRHggAB {
	NSDictionary *cJoINUxzbNycliPpZQp = @{
		@"NASOhGynNIHQsfB": @"zGZRXrtvevGmHGVdOdNYQkkhKWkIAZwCYPdIPqtxHKthnYOghOQInyFrfdANLQKOmlXEScBTGmprxucOUpgdUTweoSiBJOpkNyHHObdkEJdXgVFAxLhNLpMFIWnNHgNBVNFsxyHkrsP",
		@"WAzCkutgXBTnv": @"esyvFYPRacSqVCDTVtfaVjmQphPvNLLrWFJxodlllabhPNViHEKjNJgcVzkqTsDOOUAycMdaXAszdrRUoOOjJqEjMAAGROwubQeObdRJYUdVdmRZSRVeEyponsJormjVeQ",
		@"TqnsnOxkBpkINmZTh": @"kJkLCBqbhsTOKxUDxpmtGlHYKVRgwbNBNceTnNVufQXvJdLiozxQyJILIIrkQEczPulsSlUulrgeQPQZjdFFoyCzjSFTCCSTtcjRAUwiFgYsYNwZdTuDAvZZQmKTIiaTkejeeUpig",
		@"PALgowxBufyplhIxYid": @"afKcuCVxxtdYJSPCkSsJeZxoziMtJizZaqUOSfZYJeEpcINBqpjeGFkddWKGIiYhrRMBFTyusjEQtVaKMPKRFqtMfkEOGYyvSqScRBkQuWqI",
		@"pgvmOYYXOTvtn": @"uailPentIGBIzdJMIEeGEEyzZfLnXhZCYFaSCXFGwPvXdhcMjMARBsTZkEYdPmdISKaYiYBmuglIiQaopDWXItvjtcZsBazIUdVfwsqGiHXjaj",
		@"mIsacamrBS": @"SoEpRndhNENPZigKdAvUnJbveiDSjqRScAWCJWNEEjasVcgmbtarOHFNLrWrAgCFhsOqegHqKZhYcnxaAOtarqjtSdprnVpHdKyyMAkykkCrUiPSCtnAbNgDEYwguBEnColrapCMVofF",
		@"JLlTQtOFClip": @"FqzvYdFVrHwIuDDRXSwhxOHQgeMFhPoQZfRIqCLsUcivOkdkjFrPuOHfHAkBniSNuElGCHqRWhhKHNjZYwiiAapPAzgEeVOupcfvzcCScNIkzX",
		@"kthQGcjRZncj": @"RFZFfVuayzxqXPKElajnROAVRPcbRRlWTUdxxjxoRKndMVYQUHlmLvtwXXaLgJxNAWbfGZfDpeonkNryXPlqsVRykeYwbCdrXbJgZOrYNUxqxerxY",
		@"OpWKpNytWSbWENEWXFP": @"UVgQbQalTPpZzfuAxEAaPeyQYFqmlpALuhrmeTrKEFOlLbCnasckheDWBrGimcLfNwkjMFbGwfMAjxtouMJOXOAJSKisFnlomyiBDHwglPpmyuHUICqCotaQXPxzEfPv",
		@"vnCduvdTsCSaZYtMOD": @"fCSQYVLRpyCDlVoAtkjGNjlFhJzFfKRgIyDljLtfhpKZGTldQERdtAscMwziGIuHxqWpmskqFoWnJWDNACRvjMbNbPhxKbVtonZEwfHgoCFaDRRnavGuYUTTWrYoMKI",
		@"mtDhSuydphEUPboPpYq": @"kxJyamtlqGBawfypbRbmdUYNaFwCiMcehmgDaymdJCIGbLvjlFNSmCNFHydnGQnddelZMQEUvtGgOxcTKSIiaDRZAyTdcBWORTxqehtrCcUOgDmDBgvbJmMseKzmNiUCEOYqIp",
		@"uPzIelhRFULJEi": @"iurdQDGrKOcdjpsClrBrKTseeeLioAFLzbZXBceRFGTNEpfuvoSCTtXYinXVZLyVBrrWBvaYwFsaLYNOhJlVGpljiyxszlgbBgcmtixYincskTViXBvohZGMFgfY",
		@"vONNYefNbmmXtiwL": @"YbDFidQqChRUDLPJRGhCGAwPjoElYnRCdKYCPzwnwgpVPsvrOzOXxCyzcQLLQosNtERgtlTWeHTFSqNJyoaVroxQbDnKwFrBoEqkoNnEqdKIqqiGUkiJbLOtbOJAgEWrDIPvSgonuAxxScJghjnA",
		@"bMfarAWQKIWiaQ": @"NJfjZikmDTxkKnExWResVIZdAAgWShfKnIHhFJoRfKEVPdzXamfoXuFQUEZHFOgnwkwsvFqSoEuxzLYdYIbvYNFISBDAvwvsubeUVZsGeGtWtILWzNtvMNNBCgUUmoqmHlkSX",
	};
	return cJoINUxzbNycliPpZQp;
}

+ (nonnull NSDictionary *)jfMBuniFkggFWA :(nonnull NSDictionary *)AmwRnMzGdqeapI :(nonnull NSData *)gIGxlzbbLydVZSUMi {
	NSDictionary *ZKQLHHWSeQ = @{
		@"ChPIdfetjiqJojt": @"iArtyPLOPYoQmJtxuEmsTPQJDUTYKuKjFIHPrsbgJdtjRyWLudGgiHSQJEnUMsErDEZNgTebkwYHwozxVSFrjLCUaXvtzpICKZRzEhQDbWajCEA",
		@"mhUvYSVkBtSLFQr": @"YyLYXwkmglkdVCaZpzblkOavSdqdFIJYFnluwddjAgjqIfpbMqlDYsOuXkyebimwHbfvQRyRFsWVPEOfOVnmfvTfQFqbepfwJkCNWQangRuhAFxwBi",
		@"gJJoepYwPF": @"sMQyqsodcNUfctsUNjMSNGIileRrsrsWrFwqXPqqrOTkkoVESNCvzNjNbbksgiqqkWMAAFQLETJHLdOPBjZAruZEHkIzAxbLCrvVojUbxGap",
		@"HarNjEwDvasctt": @"shlJKaqMaONwrNGxmyqOIlrlWqEblfNCKAsXtfYUisKWIHzOTqOsVMEecJzpMxjSGXroBTyXSvtKPtVkiPfMTHlsKgDOxOVViFzZuqghqSosloncUeCVQu",
		@"cjaiLUgTvXFFScp": @"XrXAIhzkbDndeswCgjGGmxgscUlLetenaKWACjkRQWBxWlumePcqGhWRMXqFLTmyxCYMblPeYWrmuUXpDmuEFOrnefIqhArkXRdpvCGpBXwTetWVTagueFagmBhjledXoudjSPX",
		@"DccPjbrWLBybqfGWzdi": @"qXstckqecRwyzsBQIHlCWkWlBxtKkYzqqzReosTEQUcfghdwsHHSnnIsORhZrTMyVjgSUdIASoNYRCmgsGsMVoPwQlcFdzMsWRiwlMCxVSyEWckJMATbiqmvdyPGxxpiKrDyBSz",
		@"AveylAccvesYGw": @"tQSEeutFyDGrXIqXWkqQoJNEZKvLCIxPZnDAvXXZUJRgpUevbPwQXpGusEdTxRnpwBojlgIlBdQdCSflmvhtkyqthAjuxcwoNyQtvvxtkeRLrzhxfo",
		@"rRajwnXdDztS": @"hJAVFxQInmXvXlhsVJfrIDrTMZLTLKDocOMomJYuNmgTIVsCzTuyGEpTBlRHtcJqKnpmGIeziZYDfmKCdbRJFvielIMQwcdxsgqnxqdobUszWK",
		@"nLvgSJXlYa": @"rlrRuvYiXRokNrHkYtzBICiYqwvJvRMibKbNhAGGJJboipNqGtEaBnenTfKuERodnoSyLEAJjLgxgVxzVeTzHQbOFwEuFdoSPiOdySRNIZHQBpnNuptGJANlTZVjyfrEgXhCb",
		@"itGZtYchHGydMtW": @"UafnicgoKDAvxeAozqNdQieMQGxZAaOfVRKyZduBLNxXfbOVGsRhGFSNDsGeTrNXkMXgouqhSIBJtywjEvRoVxYpvuupbYUkJZPHtADsBVutottHoWZsIVbktVDbixDHHpL",
		@"mZoxLOwNiEVEl": @"xhACTFpBGWhYudUmBLefjnuSAYqIKQmkUyDhjZIaekyxfDyiHfijLcAFgaQXuxtRzhdpedLbLlMOeIZBKMOVCAgmqnBCqSAUGTiiPkdjXWU",
		@"QEGcOrZekiXkp": @"zmLLCfpvZynnLLKouBhlFzVrLhOVYEnDWowETHVsDnDSTIFGMHziiSUUzgixJcTPUBCACXUrUAAzSkLnDbdRFfNESuOPvIVkjkehHHbXYLPrahmIZjTuJkCtwvYH",
		@"CnonKRJbhX": @"TJNrSwdiqzkeLHZdyQbqAweQoPiOOmCdtjkZBMRrZvKFkRIDDpMcIbSlfLjRRXNXcSNTZAwpehGUnRtHbEKRJJmcWCixuRUwllXKhrbvLUVrngtIrfdWWWcqN",
		@"EWZVjmTDdtnEtqLIcQX": @"PCOVFKqTEAipVdhcCSpLkjvdfscjHKQSnfmqOLXOFqIouqQmAYwdTYELfJQFKIpVwpoeYuRRHiJVkbFONpWLKyMqhxDnwdHSQWdzjNSrjEzAcZScCrDgrwYHnOKhMjk",
	};
	return ZKQLHHWSeQ;
}

+ (nonnull UIImage *)pryDervpyu :(nonnull UIImage *)aFoDSBAFFLHDT {
	NSData *piQVIsiiuttAOGEY = [@"ewmGphynJcufYJLYUfeNjRazlZoqaqCmIWLPOqakFOxmrRUxGLHsOfMazjreQqLJwKpKPXaGtSayflizWIkliXBMfwwlcWKaJCuIEjxswNrTpvpWIWRKQFttBkXafDqt" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *JjDojLOHqobzTvpol = [UIImage imageWithData:piQVIsiiuttAOGEY];
	JjDojLOHqobzTvpol = [UIImage imageNamed:@"vPRDSsBjKTOHBeeJMbxcDBHdmEWdgDbzsKZLJvmeiPxPHarJJXzGhmaXOrGdVLDTHOosEOdueipsMEZFosxJWnZppWMGCxVMYTzgBIKQrRRHFUArItIFreJ"];
	return JjDojLOHqobzTvpol;
}

- (nonnull NSDictionary *)oXSqKVzPuDVV :(nonnull NSString *)ARbpAYEjJFaR :(nonnull NSArray *)BPdsKkumOFP :(nonnull NSDictionary *)CAbQeYajRYeBTBEmJ {
	NSDictionary *UnlNeRfZWtQFEjf = @{
		@"acAsZuojqztgkkdI": @"hghYTagZiXCdRoXWklTLbtmGbqdFHcjcxeUjTdaIcrwnYDZBnzyiLVZMCALStjQVtmKUypDKTEZvNoneXtzBWpLgbBZWMlXAoeCzY",
		@"nttpALkpxmDmEmlIyV": @"KBFbkTfhZDChXtbztqtaSudIFCnlhBZChfojwbrxHdWcxystztyosTzTBzVZfzXtYXbjKXMdfOYiaJuOUAgOGnNrTbhfBpzuVhEUtNxIhwIPpIruQttpozMlOZMHKdSmijZxpIXTnykOnICsK",
		@"RMzczcVvry": @"agwtaODuytggvOGmfhBLmFCSflRUIRqUgqKdHlRAwcMoOeNybkCAsqQaQnPlMGcDMCadxUSmEzaJGzqaDJViGQkPQeGyyRxdrvBGQbeEhRhJnUetDSHuOtlhuSLsqigeMPvC",
		@"LEBEkMYspjoT": @"IgssKCwxccpksVZOvanHOqhJpmeEeAqnuplYmaFVGlCduLNJDmOYFjhdrURYRVoiZQigGfDNxqjUHiYSaqpgnqxgMvPjSbpufDunAnJWmwvXAahzZThny",
		@"EavTrCkEppxrGlIE": @"fvvngOoVugKQtgaWZSOLyXGSmgtAFaYjzSzCnqPNkFCUiGIIySbZavhhOsOaREaehcTKQuArkTnIVedNzVlYzHBZGRtEomOXusdMMETUoRVvlZikMRHeqt",
		@"GXdQXxSYNvhI": @"vwTGUIyKCcpCISkvECchpPFcarQGSOpvdHJVXOBaJocgMCJmeZbcyaGdYqMqLeiDayvQFyMZjueZYDLMYRDWykVaRCZpaOkBYOZYZ",
		@"RstmIsWFyFTYdUyel": @"DtduHqwBhyQjoPDucqOxRLzlCohpwnpnkCxFplCmbYNHaSNLuaYAZeqeljQRImFKakmyomuNQTRfZpXZeTOjPeOMACDtUIPeTbDzOzOzMSfRWFUIAyjUenvaboR",
		@"eKpCAYHTRQXjVXCe": @"mqQWzLLuWAjAikbcdAoVshcCfQMDIOrVPaEyhIelubIcEoxQxaQRkUqWdgiCidCFxzMHYrUXbFldqNkIqenMKXWKAlrRVCRZdWBIEf",
		@"NQFexIrXcD": @"QkQBRUnPQGCLPKcRtyICTZfkeuRmEYuajbAquxaYZwrWzamcxLUUlmwVfxEdrfcZSLhbcBZNIExmNqVyxNOTTFXCwpOSLxiNYnkwwDqEtfbWJqkA",
		@"wLarPCcKcawYrrlfQn": @"kukJImQoJwCkjkYOWLVkNmaGEGqpToqaYmyFctpHtCtmKImSGecybrjtjDetCzcIESaKnWmCIIIRgpzlabOpqDDGJgRbuKwRlVGwxnTiaSHnGFDkmAqfEIRWExPzCZgRWROg",
	};
	return UnlNeRfZWtQFEjf;
}

- (nonnull UIImage *)noRXTRkWpbs :(nonnull NSData *)NMVALSJABnRrRHD {
	NSData *BcLbIcankVCAObR = [@"METVrVsJnvRvaWrMvEubZTAVnolmiwGEoXKWYzryhVkTPAQTBPCbRFbvqrnqKVFTsYzJWZDJxLWhnKflyLaTkWOqsyGMxKUgnkhZDLCnDPJCGbSiDTlVwCJORzCfArKtVxFhGhYLCaIVWKHLm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *TqwVsTpJdpCa = [UIImage imageWithData:BcLbIcankVCAObR];
	TqwVsTpJdpCa = [UIImage imageNamed:@"yxLhwrgvFkbXQdqbqiUeXKGBqDpEWQEpjQdRHwbIsRYbSLhEjqPwbFqNomIHQKtluqRZfYOSHMgckMhlvdzxeEAdorgupnlZbbswjWlhEngFRyeovfBTosEQwzeWEFfcxT"];
	return TqwVsTpJdpCa;
}

+ (nonnull NSArray *)ZfcGLBIFJaIgRBNtL :(nonnull NSString *)rhAfPNoBmKpdHehYje :(nonnull NSDictionary *)BdeTluBnoTPYBit {
	NSArray *PNgwgTTWThwgW = @[
		@"HHzFgrPwCZnFsFdlzFFRrGsOBVKcnKtYgLOxRtVzTRRfOEMOYNqPOxREaYSvNqMxfDfMiojcxLscyTBPBIyTARmODBgqqjrklOhnIVFuRXVBs",
		@"ARkBqROFutRsrKjCgOuQMGFNUxajeFNyDNhYiRPVzoZOToMnLfVXePTdFAFyEiFBgJVaiJtIUZkWDheeDhUPxLUAmFclgRYPMwbBCcTxnYJJxynCHXdifijXJRjaBW",
		@"tJfiuzUEQhjEpwddcPghlsPYvDQudohdnMNeXbTpGAWbtCakavKztMQbAziXZkGlqNtrLDiRHGnmVAYMPFmIlyFxCUmYStLMEZZZwBYPblDDwtFRaCMtOKEfjOPewzqaduYVVXWfWbuWKRqTVqKrr",
		@"fPMabhKcNCsLCIliPBSrKMgdLWXAtGXNSNSrjuSLbIRWTJbvBgcZtftGResoLcvUrXyXFpBDPFOecVSSuwQubDnWqvCzgSMYOsnLbUyBdNzneEyIPVeBl",
		@"JNpkqENYIGrfmsqMvweYmIYJBSqAHoCpBspheSBtLPCAgsLnaTQwLCyCHGjMfBwkQabOCZotnWBoQjPWvEEcIJbWvqVUxJOOqifedpYyKKYNefxldQPIDDRdqNKvLruQpTrqzOLIzVdG",
		@"qMZhIhAKsDAhYgbwBJHYCqToruccmfMdrUpRLpCIGsyqNqRxNPwUQazlcNeSxYpMrMrTTcDNNwQNnNANRFAWOaJHZEEBeImPbTbbDXdnPLqft",
		@"eYCFEUZTdadsMCHJMizsXjVTLfRtHWocpuGMfjpfpboxTUtPwpjYuPjRKeDbHXtPeFhOHtzqrgSAXdOMRRvoLacskrnzUuFxmDoCOVrqnnSfILmoIQRDlUtRNTXueVhPcgVfkDjSrohmm",
		@"bozzogKrbFsUdhrDbmQvgxdZJhpBCVbEJokExLGZLjhZgyErrqlQXqMtQGbksnMnfrXnOXsJfHeUxyJTLQAQsFbJReirxDfhpheLQLpBQJnbUzvQfgRaENbNEdigAHCAYXzdsSEsmot",
		@"DahpolJQoLokIsTmfhefJHxbfMSwldwjYFFdooZtEgtoIUXzSSeEpAYmfqKdMrgJVnUQnsqZREAcTbxeFaDYFLECOnJxqtOXSVQFXTbUUWEzpXhavl",
		@"TkKqjNEOBwwWSOuVoYdaomIULzbCktnuxrUJdklUjniFrBVOxurWKNEqUPgRSxbuQTIyRDrlhOWquyUBJaWuMhmupRcyUGShAchwxtAWIZCInbiOVScJqbnUhfOpaCAUiCo",
		@"RUgcKzZdXPjpnSKtkQYmhpAKvfIrzkGvNowSmxHpnbTOEaGpYHxfcBacFjqhUPzZqrVmeeNinRpNHwqpZxQeTOjZgOsusJOGdsvvEjJkt",
		@"LupksxLJJPELDExqRgKOqKmKJUcnsHGmrnkBrUxwAiAJZAFdCIqBEdapFJbaqqRjcKiOfdVnZgbAtjDTxpKeeVjMFDPfJWreDKYgN",
		@"eknGRkxTNOdHQeVzWuNscCTIaQtoVEypZJWRSdlafhZynDUoOAgmHYVdFlVSOiyRUWXILTQbeASMuvaLAmUHMzafPtMtuTLiovDzMoaCpkDsTeMCGvlnWERatWs",
	];
	return PNgwgTTWThwgW;
}

+ (nonnull NSString *)LWOLCCWvXjAKqokRy :(nonnull NSArray *)mvXwElTfZZMkHLb {
	NSString *JiXPRorVpdJCPpXYx = @"LgFsEsOrTmYtwVLoGIIyvIgRvjRaGmyvVWSQkQNaSxXwOLuGRtQOVJeVUHZWqnylswCSEwumiyJKHPzYOnCcgayHWrPQBzFzCyQXPDZbOBShsNNBBxQodvSkDH";
	return JiXPRorVpdJCPpXYx;
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
