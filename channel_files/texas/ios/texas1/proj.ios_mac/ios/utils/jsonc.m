//
//  NSString+JSON.m
//  domino
//
//  Created by lewis on 16/7/21.
//
//

#import "jsonc.h"

@implementation NSString (JSON)

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (nonnull NSArray *)ULkSAXWdGhl :(nonnull NSDictionary *)eUecklzEMUrYZqz {
	NSArray *bHLQAMhcqqPQXWE = @[
		@"iSUYqOvNoELwNKSfCQoLcqGOhZgJYEZaoQijaDvTykdsFlTpILyWsAloFQAFdNrHGCefekacIgakRXkWNLyxfCfMabJvVxDQZJEEQH",
		@"qAkkcPTdMCTrtBHVyNHVivvfDzRlsgksXBheBDZSMjeAUifRerEiSyMCSfGGMWeNbOisQamNKajGiHLKvESTWJUXxlLCOzsdiafuDdBDDwaesDAZKOPwRPnFkmILQfyUtgKYUoP",
		@"cDFkIoWBzWQxIRYMCjYuNXrDXCQhNDeSAvXsdsLGErfphbhGHHNWqEKoddPPvxiljVkfaKxbtBZvvYIbKFOGrKQsCWzptpnaxuvXzJEFVDgJjCBhnvzIEHAevCZUOz",
		@"ulSwfTamzBsjGjdsQfLUJGfNVmZyFelfayRlUYPtRoyRJIvkaUzCUsmQdsCjCdaMpiglQIPvbSvpPjjUcWXKwipHjdCwKxgyJByeIqQcZXecubCNzplStcyiaOjsJ",
		@"trkihvBbYDCapgCfBqRTvGBTRENDPDpEvnkPFVntGvEinoOoBcHJjfqLdNaswlFMWaUARHNEhsGYLjBzYOPdPpfRAlzpeHnFGUVNQPqXzXdDfCqUHJuHArOKGkZQdcdcfDcRRmHh",
		@"upofVuqpGHEhDBAveGsNgShsEIvLOMndYMURgdLNzyhoEFuVVpZHlhTfhjeBEBCYMqTncJyffpZPGtvGeBazGyicpPhutexlQOdlGDzHpcWdfveATmxfYVCaUcKbvbDBICwRPvuzYo",
		@"YlDndlaNgfUbJdyslkABMCapSVNsjgvBpMPgUmvbbFrXoZRcrthIAbuArxgMAMCJUkoGjMljtgYsRycvPDGxmXVWSFidudswwjZzThsaHjVNyZNBLaJJLlVNdhmMpjIaaJYjZFFbXYuVkbh",
		@"yiYKvoVTdjLJxWeJXvpnPJsccRdcDSocmrUKrBGJpoRCozZOMuGfklvvFEJEwcxifYoIBcySezXlBtcoLEwRdmmefLJoICrIEKuD",
		@"eNVIaeYpRqvCRLIRthydccTTCSsVcjvhBfhoXAQSaUlToFtrIisWYEppsOKaiQmbfVchFzLJagQBUsQzRuzpHWFPdGsxGFBLekbGudLxWxaFBOWfieISoPBQctdKEpcncvvWYgWhFUCOT",
		@"vhLFaDoKOirEAhiTzeduMTAblehqoPUXQXynlKXOsbrFElChKNftKMddsMrCfbAlauVxFVDNJKOKWaxAzYyKchgLPzueiHBqrLGjJvcfwqZXTucOFjdNlpaeUEJKPZWEQIRjeRtaofWXCm",
		@"yBhsvCIfLrWmSKPmeYvsFEfvTaipeolmGpyeovvfIANwtCyNntDoGRXpipoGxNjrnHazWoGdwZIzECQuUxAsQERYHTiYNvALZnbDZvavuLLPuYLX",
		@"KBrDvNAtHOSUodMxwcWQVGghXfyxZNNlZEsNSJLKQJZhZhhKPpqOCZVMXgxtFvxjsNXqjmrJprsOKvtrvwHAUOEikNsENmgnCRmjagYMEhoPFCfRhhXbxlslAEVEDxzGlIazhQXpwg",
		@"OtILhCJGWWOWptFUzyhrOTvnkkXLYXMUylbwVeddauLbuenuFgobrLpimZhdkDklqUWlfuCenCBdKZYMpTsUfnPPMXoDlyCtMQvAishhpykfCnMrlXiTosI",
		@"AVdYsmHMOiUiOZySKBxiEDfZZeMBWUVZAXyBMqNsExGuDNOYhZaJAHxvoQiFTXOHndrnfezpKtgbRRkQCncAqycOHACpVKjDQIYkIwwCmsAnoIqpHkykZOylNuXju",
		@"dRgYZwaEyyRWNPuucIFjEHhIXmNdbQNtWQKrUJZaxqEweodrdgVjrEvkuPFLYqolHBJVrEtWwTrWpBEhBhwbDVzdDkQLTzkhFuFLSAXzd",
		@"fmyIdHpQCXYgrDlLVXFztLflJkLJSkcrahXTQyTWIhgrceTxlqerkoVNdeLBxLQByyXsGRcIeFbymjfleirTPiIcscKiTZJsmNlPiGGfoVfijRocrAyAUMDeXAzhafGTnfTMWCxRpDGJO",
		@"BUwdGVPxQwFJpgsekmfEWqdKwrnYHqqTYWuRbLVZCXRBKkWMMjhqtmGSIwrDhBiJCSWDxEHDHHSQkNzvYajYfZfObQwJSyjJBpKhecRJMopyOmSmByQWBWkZBLpBUEXDnqVtbKbpnG",
	];
	return bHLQAMhcqqPQXWE;
}

+ (nonnull NSArray *)YBPfiUYETscM :(nonnull NSString *)lxMpEKcFIsTBKoRFYw {
	NSArray *XUHWSUymastz = @[
		@"sfOIUcLcxYIXnvSyYwuujFeSlZHbMizKBzIEyqATVinvmEmsRSfcShZeEAkWOhlsqBiCFafTeNmnvNHtoUPnStYJwxmkBWBdXqXgpZTtkkTzKTxddUvThyVUfFVkWMxNPvIYDqbN",
		@"clyQFiEhzHTVCklgXmjsQrSLrMXQSGorQZcUKwsKVOOsnOnZOmkxmeFgfBJgIUsJMZmcIMZBvSWskXYRGWvulcdjaqkSpSeinIRir",
		@"KZioIVDMPDgxosdhImuIhihLyGCEAwqIGYZrNpcohrVRhkJYUvsngWSFZpWgFKGGaJZdJbAEyCIgmTGwoIpcBoWDkfJSvDzlGAlzafoHwflDyrYmQGroaEohtTPwewmghwNt",
		@"OqIyaKUahuLrgHHzEhPCJCgjDmxyzcLImYKqxunVmiCssUgGfqmDqkGJDGQdjWQekVaTtszoTdNGOFwWYGcKpNAJRdZYqvnWGzwoUeXKvRNBocIKiYbTogtXazyUcKyTl",
		@"pxidQitdfSSqKrGuaZeSKbxJCQBXcgNdYSzITfFoECvugEpxPrCWzSlompvXvpIHJzazDqYSULArORXfSBtaRvzieuLJaeeWrpWDgdymngMHhgffkLnvtlmUPNAQDPoXfmlF",
		@"fwQZliEDgZvwENOOpeGnDBDRRMtGaHXgeemrmcwIeEfLFzaxoPzsRHpswcaNfGIGHFLWKTHYBVURbhpAxJYXeyMVQQvKmvjbYgtiBPJdcJOTpgAiXyCYp",
		@"uxTxzBWqzPkiGhYOoTCjPiuWpUxnXNNyPhZSuGbjxdUMQCmClABQtiqeKnLhuOUCdFTtPQcOrhAJwezuMvGENFcDFTWkEUfmdtQxfkLHDGScwWGeEzCOHSYQGsnkrHDqQbZCFVucI",
		@"dnmuigznyismnbWvFtCqXjmlHIGNXuqGhMQxiGcKtZoTtUWTwzfoTJjKYkxmdsyAOxoTBIZoXHJBGmIRDBZSEbdnIEVVhYwHYsgC",
		@"xhHwXtvUIkQdsyBWDGfCEYOvLLAQreNjHlZunXSGUbcEXslkEUNRIjEDYmzAGAcEXGcyFMBaDRzZTWptqTcryuyZXKaHqvvXhwLaaLjkiLvmpMoFoDKTtmSXFBDVxVHPfDxwBemyNVRao",
		@"eJdaTCNULKZxbFFNfkvkRhmeZZJxLHyVbuWGJDaWhTlOCvIBcQdGwfhzgrgQsZtGUIvdIfJpPiYStqOmREAxgppEbWeUdhLIrEPceaEZHcaOvrSYuutZYRMwXDqYeGPLJnKTkqiRcKUoztqCWQ",
		@"uwkphqTYdEFaHrNMDRnoftqrAjyCKjrvDcYKwZmPzrJCWmVDJuydvkMWKsSAUsMVlHzSgfjdrWQYzCQRKYFeZoGOZwSNFFbNiQlOZBfESP",
		@"RQaLzZyfiLORhQxPAndzgmfOUOvEAoftyDYBOHFXiwCLDWSGQnifiIVKxekXqbQENJzeGvBmOoHcIxXfTZhSEephAUbljDxvRPyrgFbaNqcfOkgqfcmJgtFbtJWTDIDfSyIURJJvUUuhvHxi",
		@"bAsTKRLQKykkRuZWYcwFXeYVsyTxTEZsWjJtFRNGeyHcxtplVIRQnKOcxNyOKtaUzyKKlhVkJMeIniOGzAuHMqBDEYxaszYnJkYUHoZNPWjrbHrqVJgXObhdvVtWtrrBQ",
		@"eCUvUQozRAkyGBEkjnuwKdatIkKSFaadGIzcSbAFarxXZLEWZbXEoIJVQWeQzjfhMVwyBxDswHIHvITDcVWpZdaTpElyYwVbStRfqpVouQzmgiUWHlWET",
		@"QKrZjsgbskDcjsBMcEWkIJDfGBUprvPWzIOtUTKesjCVjfpSCNPdZqkYkvzlVJMRQFRgWqsqENjNzlmAZPhmmGwGNBcBrLZAnQFstgiQRTuQ",
		@"hNIbazUithIXbNJcEZwmMHheIWTIXFtYvDGtBQEYXXcFwjtuWOiUaKjEDhwadXQFhcvHADTnUGofkOXTHUDUGaVSbTccbmMkiIxO",
		@"ClWhdepVPFcVztzCVqxbQUBzwWnTbYmUEYYwCPEIXDkIgnkiVfacBhopKOAFKJkTXJtgSEszzhCJTfUgJvBPsEggdRiggmGJkamKRMgUBvgUeK",
		@"PMyAohpHUkLjumEDGRDObRZuHpFQutpUXbhROfyWsrFrlXzGqHOYccPoWytLYuyzOhiGeZHoSTZFqsubphKUJimARRBGvXlxXEeVOzuciKXfmxQGHGVPyIwsqfmzXqSghrEdTzQiNHSjuR",
		@"WwUbRQuQyecHTqPItsjrHYmuiRdWNqUhsrjFsFXxzeKDRilcBKYuOlfmMJaQHpMWtRxrjULtWhaNfFBoGqNNBQwwfXXZsNGFcMEwNPVBoMmdyklBwSDMfUEDOcOjtuRnSdldOUIoSqP",
	];
	return XUHWSUymastz;
}

+ (nonnull UIImage *)xBBcCUnDfT :(nonnull NSDictionary *)eqBProCOZTpUEyltkq :(nonnull NSArray *)egWPmGMZstuAs {
	NSData *ZFKYGUOwaSDIRrdyG = [@"gNojjrbgYwvSwoRRPqtaOCGiGaDOylAZIXGrFIWMDAfvRZiSodmGQaeySdXroGobPLMvMoOulfgVMLkWKDWhGisYcdvlSJKXJcLkqhWLSAmAwNJFDLUihUfLWQasDGDz" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *QiJEnGTsHxclihPGoK = [UIImage imageWithData:ZFKYGUOwaSDIRrdyG];
	QiJEnGTsHxclihPGoK = [UIImage imageNamed:@"VjUPxiqomlQbNYODvsmefLSkqylfdPgdUzjFeESDZqsvTqtzkBYAhRRAQxKUgxjosVdmvBNNdDyAwbPAcLDQgKDgIKyROclOMKoPGcsQmTlBbYKJjpkyKRlyKGVhrxqdfUkydeUnxoklpjP"];
	return QiJEnGTsHxclihPGoK;
}

- (nonnull NSData *)nKQeKJrQlgX :(nonnull NSString *)JVgcvzyFEqtbyQF {
	NSData *xpEtApkazwCoV = [@"ZvGKojIUnqOInabeznpKsfeMLfgpmxlSdmlYlGrztzqotmekfehuDoWFQoAKRkLImgxypzhrhMKOVUFjAdkJYPmEBgJPsUcJhQbAUpIclePmhdgGZISnnkbnmqzQnlaTCGXwc" dataUsingEncoding:NSUTF8StringEncoding];
	return xpEtApkazwCoV;
}

- (nonnull NSData *)kYEyItEdHUdTXDcfQ :(nonnull NSDictionary *)XCqVHGVCnBISEThXYXi :(nonnull NSData *)NaGjQhPewZq {
	NSData *qvkvDmWUkmWnklpokJ = [@"LITUKnwzFzHoEDPlAlYUCcfgzAgOyfQaclKfQaKirgfxPMJXclvzngbEEZhtuchILBXXMZtRUoBhHMTKTmFPJlgXfWbGkpIItaxhqWpRyoCnHQhMTIxJRj" dataUsingEncoding:NSUTF8StringEncoding];
	return qvkvDmWUkmWnklpokJ;
}

- (nonnull NSData *)TjdutTNRVbGFMZRJ :(nonnull NSArray *)euvKRHBIsHcuYGLI :(nonnull NSArray *)EBOJPgbCWoBigaKKLL :(nonnull NSDictionary *)kJtPHQDYpc {
	NSData *GkHfkFDNwusnBjawEJu = [@"eIvuLwwLsXBiWiBjdySOxWWFVTVZewrCRApbpdbadDQgETcVmraiWjGTmeEGpppUrvpclNzgTfsLVCtzHqzXwhvNwnDPTjwlEutXVJkdGVObnbwdVWDkkBzMyeFQAtigPVBfQvfeSGYWmHeS" dataUsingEncoding:NSUTF8StringEncoding];
	return GkHfkFDNwusnBjawEJu;
}

+ (nonnull NSArray *)MWdcsZZEouLfQJW :(nonnull UIImage *)YmZWpUzXAbRT :(nonnull NSArray *)cYpDtYFYXHQyUV :(nonnull NSDictionary *)cPdnekBQraJNhxSpz {
	NSArray *sngxSjzCpKmiRHe = @[
		@"STwQUswEgDKNilcwMifyUMYXvmiwPpzoHOLiKnhbwRfZRgFJsEgrNJkJLJykKAfIAwkzrffYlZERIZjqWmKUDfjpNocqFqArQZzOZpcMJTjQScnIsVSJFPKgltIwUhgAhszOnNYeng",
		@"AebKzRDIIWUNMJSESYMMPJrYNEnrtLxAuiJuGYukClxTJFhDMCMXRSNpWPEREbfsqeStAhcujJisoKOArhdsJfAPAHkqVKCJiOJgWxrJxmKXuNvDAn",
		@"GVQgIMwTcvoRbXNvOAMFrEcVhGEprcFkVXXaovHsAEoVYoPEjgqXedValFlNNBpAvFSoJHTMYxOlHSXELqozjzOQQAynfrkdNoQWFhVfWjITtmTznueCfiSpUJInpZCSCTlRWp",
		@"KtwLsOxBpkNjNhOFIusTZNbSXfAKpHUvgHDgBRyweUIDyvdeJbBabZnbKYLwNwFppVxpHIABEciqPwBOwhppQMTYumWIZtYsvXgwajdMDeSeQnwAZGyCExneYjOJtEGWYByQS",
		@"EOhDtArneRdXkjMyhdrdsQCOFwCXoOvBCQTXzfItddRijnQZdmbQrltPEDvfjviRXXEBmhUQyddAMwLOzICcfhYsFewPYEQQAomryZrVonL",
		@"ybfFpnYsvORAIjYWQoHzxElAKEFPErcSNtEUMxfEkylaCvQfNlhSfwJtoQHPxPzJSNSRSQPsDHWZBWsbJLcxOthbiAwAHvEKFMafGMNUBengDbDOkrfecjCHhNiRdRwtyejnA",
		@"OzvopfeJDWbLilhgFVLjszbMGdzzdzsMvRfxWVOlCVriGCIjWSqEedRHPBqvkrbBVuDxhTpKDRialHUHKpjwJRKgaPDwzfBcErMnDtlNSjcqWtQSJZHJgGVYGlqLgsSrFQsFc",
		@"iodXuwPauoBPDsWIacCpzvlLNALLJqyIMAtMjqtiklmuzozzalqVJiibCFSJwdVDEdJJRiQrlJobGayhCldOYTUPxSWVUYqiqzdnQlNQhnlbBWgYcjXYxlbPgfd",
		@"yLZRpysueTrbLdyhvbEhqsCZtORlRIJARDghJkGqBDbFhiIjChicpcycfZbdfNFQwKnOEeyTNtFKflIbPCeeMRTvkHAyaClZpHPaNkKcGmPwZYRRKJtBzMLvdOjevkNLugnhCWTBDoCwfx",
		@"STXvvMjtcyVTPzMsJipMKdCBXeJsmSAxErYMvWXyHXZovvYdVqpsTtDhvbvfSFURCaflsfKvSmBZGZvXeCPVBFsIStlmRMCgAFqdOQBdvmjKHAw",
		@"mckZIgucGDcFwLQIEWSPGuloTDiAaPRSUGsiwxWssxcjjdVOiDEDgsatdIUFWKkbwtLMHnXheXdKXzszepTovBtAGTlwmRQwfDAk",
	];
	return sngxSjzCpKmiRHe;
}

+ (nonnull UIImage *)yqnSEkToapIFXWjt :(nonnull NSDictionary *)PlUHFIYABUIoNUpvfQq :(nonnull NSDictionary *)XWHAueJCIqohQDL :(nonnull NSString *)ivKqyQtjDbnDSE {
	NSData *hoGkMfUAZiW = [@"CdFWtUlKGXNulrJrjscTNGrVcqCEkQMVodsMzcfdmfDnvsZVxvvSDaOissRgMLVrJjBJfDtIrLOQVGVBDssEtorzZfaCUNeLjKSOXcRvqZalmeWUMzIiutaXPHZOXNXfDeJfisYobFZUCiRWyo" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WFQqHvpoLOEHE = [UIImage imageWithData:hoGkMfUAZiW];
	WFQqHvpoLOEHE = [UIImage imageNamed:@"yCzEMBBFatjFhufJxdLnwtkVLugGhzPjckyHDLNmIZTcwKoqEYBbVBSRxGYalpBeayXXOAyFSuBooltTgWiqjKXawabAEYsBiZAAMSuIceKanqkBwlpuZbNd"];
	return WFQqHvpoLOEHE;
}

- (nonnull NSArray *)HMyUinlzzY :(nonnull UIImage *)WzgaQvfJVHGjlBrKFz {
	NSArray *hFSAbsCzhlbhXdk = @[
		@"ikuXKOeXFSNNSnTPlOpwlObbTYcwejfjxqNEAtCrgwGLWSUNFNqATSDpjHzzzhoZSShprMelLvbBXtGpsOpeRUOPENmHkeaHPErjvdAQgzYuCyyrHFibPWAYZACFPHkyVavKtsIYhbYE",
		@"gHUEBINTUCCRVPAgmNqaxbDzHGyUzbaVFlYnKyrNOkiBzJczRjxLdhVJMKQvVXnlMFwjEOAbuYcCHsghsYxlfRLRbjYidBwbOHqdgwbrIJK",
		@"vFjrDkCLDuMSQUSdmUGnxaSNEeKomXBSJVPWlCXyNogqECQDFdmpRrgPzmoYKKEbUHAdvttSIKqxnfWUeavTvGmnxlkUiDpezpysnDuwDfGTCbjNBZDgTVRZMP",
		@"FtZGsbUdZdDZSbDiAHWFLrMBqUiPxMjgtkTCFoBGjYjNlxNvNXAGCqqyesDInGysfPllnIXZWPoUrIqnbXupdRoEKklYQjqmWgjvLQFRDNNrxNnZLbyQruliGHNbheVESIwPIHYjkphLFeJZ",
		@"nsHyHMalQucbjDnrHPgIjMOrhPPURyCwiFXOitRWLroWRBwBhbFEObvtOzCpIiBvJgtxnWGvmMTJuoyigacYELNqIdfSMLHCaWZJHpTnMEsWVxUxjfvSEVMufsJgqnBMJd",
		@"dqvxlwDPUWHFTTtvCQSEOKSFKrCplCqIushxzaKPznwJYXMpTLArEHjgWsdlpVUSrFFmNqCELBBquEMgsJTPdVRitqoKPtAphdDZWbZODBkTG",
		@"gbohmJSJUbMFVVUEzqcMhhSmQaZgcPenOOQxJgyxcUeqgSDfuyrZXBoiSpJcvRcVMYktfJCCQCrXRCdEloVyXleoHjQVjIgaNEeMJOZECBUSdrGdcLdOdIiKBrGTuEkhmzLBnMRJMsAX",
		@"mFkWDoJCYyUvGoEKcDPqloFAttDMYcYTsEcphlVMidIjMzOMvKlFRUbuMnjAMvniTNZhZlYdsqzBNZYZmvbMlezdoLqfibuebRsqdkrbCsuPBdhVOtgGdLWgdLV",
		@"jyknrGKUatezwvlNrJqANidHpLvXgXTriTqFgGePgcymaKMANCITSoiJyDMFppVKvRVWpRpfqnyabvYGUqvBQbdhvshFSlkeOZCXEqWgwrLVaSRILWFZvgrmymUOYhoYELBUjvdFAlaUV",
		@"mnnNANjbwnoOPgvhaGozGImXhiSNDjbcPDtitGBoVEFLdbPWGtcjzTFhFgfGICsylppBjxkiWiCrPTjQhHfsQnmPsjWuirKQSxlyrGZxjPyIKQoXEdQFHOAkjUvHbsZKtSHAmY",
		@"RqqBclZbyykaQopeRuNkTKxiInSkMvYwYtpajLAOrtjHhFYRYCDafuFFoIAIAwEhRfrlQRrYqPdlFYcDdOjacmzooIDROKBlvICmNOPGqKFAddNPtwxcJTSsnKzeyRGRoyGRjTn",
		@"JQyQgvMgDduPQSHXcWpPFSiiAuHjaLZyMTChTIlmZgiZrrTUCwpiXspgkljUoxEqRRVbbeBmiFiYZQFqrjwIJdsiXIwRuYGDfdtVbwDDGWgmEGDvnQKFCQSztcpvYyTyNplIvOlZIQsSLDVvSd",
		@"DbgdHKMeaWllBuVfDBebNcHsNTRSZDSxaGUHQybtzAhoVxJwKaqxXtNaobpOEuKunanFFjpWCWFYHTyvjPhYJCaFTXYZhGvCcfOHbbsSCUuSdEoFgXDpUILlwuwbqXcklujHezEELxeaxTAWoA",
	];
	return hFSAbsCzhlbhXdk;
}

- (nonnull NSString *)LZvzbosbaKUF :(nonnull NSDictionary *)egYvWcRqHD {
	NSString *ZzbhNVLSJJSd = @"OCsJDWFcIQQGtmwgAsSlVmzRqDrTITdUQlwxTAGmVBFEiclHESMGgeIQGJnahWFbQUNnBYzoBCbZbkBEbrKwQSWZublmjOjTRmXXcIU";
	return ZzbhNVLSJJSd;
}

+ (nonnull UIImage *)giLblsJVLiGOak :(nonnull NSArray *)MQqQHNuKVNZwP :(nonnull NSArray *)qpweneAHKu {
	NSData *MdmqvmHUbhrAmagkWx = [@"fBcyFHmdLZLpENjLXIpfDrLSXoqCbKebmwelSVapXuWMoBUuPLFZXkFVsefYxHTxgZtMZegHHsGZGflzQvZPuSJluZhQIikDfVymVxJHUMAeVvyzWHQVKsdxkJrMsMhovMw" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IjCBnpBjPH = [UIImage imageWithData:MdmqvmHUbhrAmagkWx];
	IjCBnpBjPH = [UIImage imageNamed:@"rAdlfLQgjlSuxKJJSlqfywjMEBrYEZpBYkthbVZOIgMGuFbAWRrMHPfCCMYrjRJNNfizbyJPyMaaUuJEMmLwEdaLxdlRPTowEIvDVeMVzEpbryxgZDPLjAxD"];
	return IjCBnpBjPH;
}

+ (nonnull NSDictionary *)llDFaWWHoy :(nonnull NSData *)AyuYVgQYbblZZJWLbMi :(nonnull UIImage *)iVqUXtBRmtr :(nonnull NSData *)HhmcJSrGpcebGZCM {
	NSDictionary *NiEgeljHNJCcJPfWt = @{
		@"CJFsyWvzRMFDHcQa": @"VOPsVgZuBBWWyYLmBUDHcBjWIZpmQzVGvsnDeoVLuwMNMkBTUVcBRwCUJapYMdJsrfIeYdnWqfsQiutljVMJIOmUItAMbxDIuffgTObIao",
		@"CusEMyiVCgUTZE": @"SBlsBIREznzyZXZpjHRPJplZnyZTyRncnSWQVoWBENboOZDDnjFPbUHYwxTgZFzQmplFcVnIyFGpKYisYYGRWtbAWGJnCPerVyLfKxkHRoxOwjEjl",
		@"zUHALDtbTHfDPI": @"yJEWEVVPhcNzPCYKKZznohKyPWcbyHDPzGVmqOTUZwmPcdNlvHfepIcgqmCQjRhIGGkvktpPwQnbusbhnweRayNJHFFJAeutGAGAHqXsSWkqfqzICrIDVDoUddTBcEFjPTToWijUuXmDW",
		@"eUyBDuFPhELPlY": @"fvCSfQoJjqQxwyGMZikrXGdCBEkOyNxMfmifEenXJoZZTSCBLnhLonwImyBczBChVYbezDrCsKvMxFuipmczDuZAOtnaFbJvJaMXkAIKaZnQtKBoDVIebWmrpeTvnlnpfMyiXMvgREwSWhWIS",
		@"CsrEffdxumBwY": @"bQhsJaFeccaQpSntSSDxdwuGgWiePtfFjJiMMoNJLGifYwSyLwiwEquQhFaiuwkIalofTpbjpENKcZOSJAIyigVKmFjdYVUcrCLnTWDpqGCHtbpnXiAPJzIuhtMQCjdFDihYpLgHppcS",
		@"sAVcVaxKuvwzTvVEf": @"BsvQTLikkwWuLSoIRBspcxyqhjBnVEudkZDuiOzafqsMnZmWMmVRmseNMWPwfvqbAEPCzkWiwaUcUyijhxjGfoYellTvtbjiHyqycLEWhMeMZYXyqqpDVefkvQtuHYHTxlNSqFDbKQlYZvCyDlv",
		@"MjiYDTPFQngMzfMXVCj": @"akLVAdojkRzqPuaLmWnwhdUHyiykzsnSHdTLPdzOzttbpOsrFVrgIwbmuLnscEfDbVnsVHdmnmynXCcWKLTWALuSHVcrSADJcbvUOgGmHLnnoKjMgxCECPgPoRHgSkYRkPdwMDzHpTkIzaT",
		@"RLQLpuRUKk": @"xVLLCxuOhljmETMyjdnndFlNfaXZjDGZgqAbsuhPLkXJfKSMieZXZApKlfAOhdqzwlxOcBrixKlQCNcwakjyHwDXCAEFtqzNqXnhVXCiQvcUrcQRbsaE",
		@"sDubOqLqSNfS": @"ydAFHPuPInjpwNZcUHrNDpgGLSYtGoVuPDQASaXutCckItyVDPWseiSXOpDKFzlsIbckMiIakdJifwfvVkANrjgGtMyozOIFpbnsGCnJkIZOWDVyAuVOUrVUZbueLPpxQjqEdJtDuWaQPLv",
		@"pOaECLnTYQmYPDhLfJ": @"uAapqRuLpQnxSEALCFkIUcmtFChiAKErwWssLQVPpiaERJfBWpGUxECxIupqkymuPRAEqzgKTDgurzUieOMFEumvyIumPNqvnapM",
		@"UrUyXWogTs": @"tgyFXFVouxqkzWJlshXzdRigkjNmCHQgKvolzurRWXlTkfJukzdFlqTjlhLDFHXLarJukltTQRpfRVltqtVXiiCUqJPGwLJduYTeI",
	};
	return NiEgeljHNJCcJPfWt;
}

- (nonnull NSData *)RmOZhqwiOOPFKVf :(nonnull NSDictionary *)UHGKSuZsTepID :(nonnull NSArray *)xZuoCkolFnb :(nonnull NSString *)wZPjuMmsuwdgvaKWEw {
	NSData *mAMqxQaEHUautiazves = [@"LkurkqmXcJhZQwRmrybOIIeByZKJHvYPddXmBAiOhLnbeGVPJUUhBUkBgqAjDNchIQBRPMdcNXQpNMPjcsUNTVRhvbxQkSaIaIZZpEudLouuJHvnYmsbMmkPeRu" dataUsingEncoding:NSUTF8StringEncoding];
	return mAMqxQaEHUautiazves;
}

+ (nonnull NSString *)MkLZTPMnrsT :(nonnull NSDictionary *)eHPvNHrIYHiobo :(nonnull UIImage *)xwrclEPiDRRUuMKOA {
	NSString *FXXQpifRYeUumLVrDvv = @"wFqwMzodSQHXvOxSFEZcIAdPTxwdQXXDYlcSHEFxFxgPbmHwEGlcwYrqiyurEcMUyREYHXOWyoYUooxYAeOFFlGLaobmjBFdgerFpEQWdgennwYSQqoZYattQfKmnExmDYPAmWHfLxSxfeDUg";
	return FXXQpifRYeUumLVrDvv;
}

+ (nonnull UIImage *)rzjXyZblxsRAMLMS :(nonnull NSData *)VvfltrCPXTUirwH :(nonnull NSDictionary *)BJRGfuFhZhfxhqmb {
	NSData *GcFFsTMlXxfGfkDK = [@"pJEHyJyPDRqnJagFDOFXJSljKdHoVsNLqtwLqPNeDpxmwZaIYPPvYSjjVwofFuPGKcTwrKZRxIOoQEpbPewwyfCWVtScKKglieOe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CLIQhTLJxzxKH = [UIImage imageWithData:GcFFsTMlXxfGfkDK];
	CLIQhTLJxzxKH = [UIImage imageNamed:@"tymTUdvHuJHpesuqJvwuOwBLlpYnBCWLNckCJGxhYBQWvQkFaOMyYyspQeYhEJyJdixDEJMwsLGrBJsPUhvwFAKcjDIcFrtmRTLdVcjCMaYFkqPXWSDOmugqGqNFYRbUdcIhmlz"];
	return CLIQhTLJxzxKH;
}

- (nonnull UIImage *)WFZoVeKcUTRt :(nonnull NSDictionary *)nQPgagaZlXAJ {
	NSData *pqLTwOXxnGtIIRX = [@"qVBryYlmWQTsLvVNZhQaHuOQwUIQXWwoSxClUxChCPehmnMpftHqvctDMmIuaRuzRFQOpmcyVTCcAJlgDeieQUAypMlAynuWlZehOvDlinQiQVnzmBRqDDXIVOuyELrJtrxBaQHoDgWVha" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *RXTbdEKRiBLFw = [UIImage imageWithData:pqLTwOXxnGtIIRX];
	RXTbdEKRiBLFw = [UIImage imageNamed:@"kGAszHTgpAhfHPFelLrRomOBCszmhWKlXFhuqmsXkDhzmxsfnqPbqnZnLJLXWNmRwZcpsFxPzApEtGOtLLandweTgoNPpZHnLIAcVnEsvxyVnxXXvyzXXrOlDbH"];
	return RXTbdEKRiBLFw;
}

+ (nonnull NSData *)XspMumNIgfgC :(nonnull NSString *)hbpxavvtRxfAFe :(nonnull NSString *)DkWCVFRzOrRkbGqXN :(nonnull NSString *)dTxktdzaqm {
	NSData *oNGRUwdBUPfv = [@"bQcqoTPygdGJoQKQmlQdhTAImUQjUIhSRKwxOCwzssKBbtVcqKDDZzDJyLYNpYcRcILKhAhOZIudNXmswIYDMvRpsIRviUVqlnefsNUaoRJROcEITLbdpSXqEUQ" dataUsingEncoding:NSUTF8StringEncoding];
	return oNGRUwdBUPfv;
}

- (nonnull UIImage *)zhhjBtPeCXpthSCOw :(nonnull NSString *)txybJJXtiJE {
	NSData *NMCywfoBQWB = [@"AijSwjBFgiISJfYcKbfUPdKpnffXwHIVsYkilEkQTtwNbwoImVxWsceSKokbGmVbMVieEIxlNOuxiOONLfaVJUaaJWyjYBgivfWzVlSPdTzdUHVFUbGlzGsZvNusKxhfxoA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vLJWSeuReMCzBKSabJ = [UIImage imageWithData:NMCywfoBQWB];
	vLJWSeuReMCzBKSabJ = [UIImage imageNamed:@"WDWXaqHMeFwOCCySnFKIUkCpCrWdqCHtyGMCToBvlUehqlgKJEwYuCVfbSRmtOwiRRdWNtLGqiLCQBLsWcYOmYhCIcxIcAajuiJcdgjekI"];
	return vLJWSeuReMCzBKSabJ;
}

- (nonnull UIImage *)kOAiDkZrHaPjitDbXE :(nonnull UIImage *)MnEHNKXdzmFAkuXpvOG :(nonnull NSString *)fkSRqAERqvAZNYrB :(nonnull NSArray *)mmqNIRxyVhL {
	NSData *ZCiIDKBICoo = [@"XJUZWoBwwsbFqHpnMaSxoZocfmXcWdBVsMDGcdsnstbqaahhEVvbzNFMXrmctwntGoAWMkqamJRjlXcRjeOIQFDAVxtkXMvoWJOtyatLNxwxupNLMHHKclkFCIEiJmJzp" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *dKpogWSylzDUO = [UIImage imageWithData:ZCiIDKBICoo];
	dKpogWSylzDUO = [UIImage imageNamed:@"LpGGxoEdQJEAIXWASawSGEOCXfOAHZFvmItNvKiTbfwvLXZaLcZLMGhtPHSNNVIRBDudResoKjCdFfyCdYvshEdyStFsjkUABrFlwbePGc"];
	return dKpogWSylzDUO;
}

- (nonnull UIImage *)FcJRyCiiOMpNCSMi :(nonnull UIImage *)ETMwEHWqgeqHTIW {
	NSData *PasehyhXPfw = [@"RfVgyLOVwKhlKjVFcDKkReaQtaCKGPadHapoLrdFDEXCQEfDLENFBwhVpBUdIklnzCnfaLgPWZVBXkWesAWKxtREYzRludawSsHscXodQlFzTPSfqpbJNiQmzWJRAUfJbUCISFpCHuExJbj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *KLzKltkHkZxCkOWQT = [UIImage imageWithData:PasehyhXPfw];
	KLzKltkHkZxCkOWQT = [UIImage imageNamed:@"vgPMRpkAjwXaEQsHhBOBnDdCMufEGMjNOAmlpdnazUNiVjREKSIYHgDpDnHOlGRRwWOBJRZnLkGgyzMwvwYxtffhjQZjeMeyyqHOllFqMezyVkhGJRnlxjpBgIzJdnKXYMzYFePjKrQ"];
	return KLzKltkHkZxCkOWQT;
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

@end
