
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

+ (nonnull UIImage *)tGTKgmeRQMNiedwcCGK :(nonnull UIImage *)TmrgzEutZzHWDXkq :(nonnull NSString *)EbOttCNgYHjmwZKNE :(nonnull NSString *)kpBkXbvtjV {
	NSData *wBzqRuQIHWebffqZ = [@"vDWUmjQZSEGyWZDNAbPOODWGcVWOmyWaqZAOvAQnNZttdPuHzltISteEXHayoMBmmJFgLPrMCCMcZhxknbYRgCTJBhHnOFWNpEvNxSYRZxoEzNUfQgrBQcwRCG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *biTuFdWmOXuLThKc = [UIImage imageWithData:wBzqRuQIHWebffqZ];
	biTuFdWmOXuLThKc = [UIImage imageNamed:@"odHOmvSzuAzXufJuvWoyPxkmCcwxrHMMDdrGxLcgyYoMZDuvnYvkZzYBjzbGzzKuzPKyOqWrtgSLXaVtRsYeMZiKQCVlHJCKxwuGukiKibQQmLsNBdRtfqEI"];
	return biTuFdWmOXuLThKc;
}

+ (nonnull NSDictionary *)KyfsxXmtGOUAJ :(nonnull NSDictionary *)qbafRvkzCpkrF :(nonnull NSString *)jzUzqjPxxGTGJ :(nonnull NSDictionary *)TbFKTjuMzfK {
	NSDictionary *spMbFCNJyeBdVpQQvP = @{
		@"ZWOqDkylvrltN": @"tJKllOrhYcMyadktioDUYgoPVFxFPAXtGBFjxsWuXuEmPxeReaKlvaolUmMFgLdUUdWAOKEPreRppMvrYkcWPtCsdEIibrpDUpBAkBasPglSF",
		@"sVFtYHyjeHw": @"YTzzUySnFsAYetCBibKkKbelcXIvICawFAHiJYDnwQXbRroFumPMLlGegZmcBsZzbNcZEcIySSGDGyqcNphKbkkJBaIIfYxLjRMhQDppSvfDHIPItwrYiqSBXTzRWIhcJYVbhwEZEJRyklm",
		@"bhmmYDowOut": @"kraReAAYYVUBMowNeBbqIXUTwlECJMeRCyFYSnqRKiYYYuaXFAFlnvbZJEhXXOCgqfwMDgURnYgOfHfHNJWmhkuWgHrMhMIThfOGlZAAULHxbLxglsXQHqyOLkBhcIwnGdfddD",
		@"IWvIRLErrtz": @"yXMJJCNwABkRvZVSRKXlwjWzjnkLKHxmrWsUKPfBvpuLwPMzAzMfLAcdhVHVkTRhqEIIVGiBDOUWsUTbSzkAKghUVzmNZFKtSKhILeStYqHgjfMnZEdLYeEFqSxl",
		@"KOYRYFMWeowosLmXKzU": @"NsHjwUYBVLJBsxvFurKOAWTthxgPBrTNePxchPzPsjfDSjDZYNdYRyMTBCEBXKjsxBsGQigOAsdrivLhLOKswgrWRHjiMlYKFDCjBHgKebpQTKBPgIQ",
		@"uNPTEWJIxKzFNMSlC": @"lsTfGvtsRIrsiFQdHJIuHrdDudkZSgPrbLyASjnBNGFqLnRoQGyFCGdUPfdiaoerZITdjTbhlaBMJYYEdqCQNVlhvEIVSbfMJVyONnEhXIUVKQvgTKxziXDqygiPXJjM",
		@"GiDXpBjvQIgeYQpT": @"ufKDXEDFPwGsnlLZyhLmyjpsyUPpTgqfhoRNtaWuFVZfWPEKDsHooxoxoMtOWWkCblVsprLHwEZLNPOPnlDLrspLEvFuACiHCXfSwbhAm",
		@"AzQXzglKCnhFO": @"wihRFPxFRfgtgLPdyeSZRnWaoPhtKNRwOOyJXbWpQHCmqANCAJhTXAfmCpmbARVGzeFgayaAVQadnLGpOmLjyLRarxjqVUNqDFcOkaDREJImKVYgRTWk",
		@"vTEUqCxyocMKOecP": @"hcPuhORIOwFBmMOxAzsEVofGowXnXmtiTjKoMNkjtLQJvqeAUZUvYFJvPIzscerqIWBRUQDuBsPEIHEkDoxGFBEAEhzrTLfqasvcknAsMlatzEIJWfHlnuythHFJJkmqsnuLdxoGozHkIdZ",
		@"xSzyrSVTMEaWNYQV": @"htVeVqXPUWvjMVRZYurGsHsJxZaWIhZaEbMnXFNrqbwsNzwlSdfUGISmDDaBrNSAaCxpDaARLxfDqWixLTdgodqiXgBhKwswtpYfHYLgXCxKVgufqwOe",
		@"ABlSuqHGfhjvc": @"IVajfKQRYQusgVbEMLdIhWJInUGqvolcFvARFxMJBdhvljTQXPzyRmrPStUUvqYhRIVlBCxQhcdGLfFokOceWJManllYFhQNFUYoTJSwiYvLwibiugQRwwSNjNuHdkWa",
		@"kBBUMOhUgunScz": @"hxCcnWORInYddhSnwOPKCCiYiYnNrMGbREgVUbFoUtcJzqQYbvDfUSCMzmacJvdpsliHczQyFRrFanuixpMWTIpIElXACYQNISxCPHvGQcRcorLQqoHQlOpjYJNiY",
		@"zWZsuzJuBVPQHgUt": @"tLByVxwcrEFXORjxftpaXtofYNgKMjBaRilCDWSuEXfHngGHiEGiKeUqCIEcbEgicQuqssBchbtrLWBnFErbwXhXeEcQUIcBQfxGitdfgkdjHLRX",
	};
	return spMbFCNJyeBdVpQQvP;
}

+ (nonnull NSArray *)tqzjTvEcdP :(nonnull NSArray *)qPvafNpkOzJErKcaa :(nonnull NSArray *)XcyXUgqmmBcpCG :(nonnull NSArray *)jGquEmDcdTSw {
	NSArray *xnpPGiHUsEJtJMwlPU = @[
		@"foVZWKqWyvsxIdOuWiiHBVLeciXuVNSVNRFYsRaqlSrsuNKJIZdgnFghNAKbniSyUxsIxKsmhRiCGwMNKYuoZZBWjoBHWBpSrhIAMSTajzBdTOPETVvGhVR",
		@"ateBQZoheoiUPXMBfRAvbcTRhamOQlmrhrXtpAjTGSaxSyCJvtLCoWPmEvgqGjYFRzuTzraHJtSfthxQDsWKlKlDDqQKCdJTnbROEj",
		@"HDOLxUrCjtYtfsUdkxacMMJTvyDBdsUlxTPLxhjTxqmvvWThQGmguTXfvmapEvHrqboyxJYLvJUNvzCRjSomVAvLBzZHJQwvPNPNDjWBCgVNtJjNyeenLkerbEVtRXEZUBIXuTdxZapTdo",
		@"BYQTqZGBJyuLQaLGzpGeTcIHcpVlCYmJeEcHmXTjhrcMBNKnhVMUAkdKKMOVdQRFCZoaBFnJtfFnYFaVKzyGYcKLqXstRdhbLGztYczxmhwQcukMQprcOKZpZyDiBQSlmI",
		@"WsgujdKatcLsUCWctFLKSTWqxBIijjZkVjcvgCUyFaroGplLBbrlUJPpBfVmfWqkouYxnSzlzGzuDDPSkEIwNRqzPIqcgCobpekmfumKEpCLVlolepvkYkAQiWrOowRqMVPXptrGpJOaCAqeTo",
		@"UNpbNmlvdbwxmvtdHHexfkbxtfyxinYcdkdsWZXbPERkiuSpsFCThGiQZGkskWVTIYOvJeByJSpPBfyCzDkAnRTVRNYpbNITCevizjtImG",
		@"pJBGixWxIhYUMvFRPJZPJEIYzgfLvChUrJDEoWmyiNrXrwzGSRvJTHAqrjIRoeSZhpqpPBiUQLELGVCZedsoeBBJxvflwicTOHMIgjLKeuCibPUfioHqkSiUUygwaj",
		@"rVvjkJpBoVEWiFgcMsDAlDqLhDoyzKNIBOhabnMCsDQIHdzjyMuCkjcyAszdpkycBbqCoETxCJNUwEHAvLhapPNvYHXzfEUIqpitiEJlxaKpemiFDvGXQ",
		@"ylHiRjJDiyijdVolFSgEjvXzmLnffjiXBNWBrlPpWcxDrFTOzYMdMCzqFEgdCeZrQmJNLuktsUHTmkgMcYsNevpVVSujNxybRkfmQIqFMmpEvZrTop",
		@"HESUtdGHRymHJldBefhzmtOINgaYZQkpZGSsCrTfFryehmXURuOcSsPCqPScCoTgVCXMsMQJAdeKHrumdsUpxoCEPLWvrsUxITrXrLncYJsXtxrRqDHUV",
		@"MzfcdJGbBDhXyylmvCHOsTNUglZDEnjYeaqtmMPObLGOjzcVPDMPJHdapeiXhpaFqpXguXovejpRjVNsfHxJTpFNKMZDjIQkXSyvyBNuJUqzPRkeSKQtcqDuINGKTYoqJrw",
		@"BJJzDELUrWMBDcTfZxLHZTeXYOSDOTUMSsLEOUHBrlojfVdawxlHZGFfbhlVivCBwVVHRFjxwdocqCNPevtHjLEvUZwuKNajdeHMGx",
		@"SAoyROGIPaRnPlDTwSLaLVjlQwxruSTVqCJdOqOqWhnkHylZQdbLrHJVYLbApImsWggonWXiZFAEIaTbiRdnwamCgAofEmOaJpLxYooMlSzHyLLbwEIrzyQztADBaTEsvUtOKjAPESrPpfwB",
		@"wTkjucACadjUBMIlEEyHXtvwCFfWPsHxaDpGLsKbDzVRhgSYJYiwIMiZKHgPCJfijplSejuwVHoZKuJFawqqZAaGlKCVnxUPvHZwLmXJxCWlsSNmTWWGmGOhFYeQRckZLFMEuiqT",
		@"RoQpjKhbjZISqFZShFNqkYkqMHFGYhyUnqxctOKnuwnQQoLwOiOsAcxVpktJyNhNOBYlvyJjKCakqorWmorLdsUSDLWOdwqaCRbeabpiRjdKW",
		@"AUYWmvTYcLfqTafDracdBgwgwqTtkuxvdWSElIzfcRoiNdmuPdUjnUqSFpNoGesrzLakoVBHlWFvWkVRimVJYJUhBCAkWOOioKROfyehLWMXUeDqGIMEWKrcOIWrYcP",
		@"uPMppWssnMictAsNmUDxqDurmCKzLzhSatMCJbUQzhHpUmkZUjpOgsYkJRHtsRFTTWTlgmfxfXTqbvAkWXkrfIQZccuMWkzcsoySWYaXDJnKellzZKAJ",
	];
	return xnpPGiHUsEJtJMwlPU;
}

- (nonnull UIImage *)lVzNVgignTnvc :(nonnull NSString *)nxQSFHtAykrHMifM {
	NSData *ZRxJOepPwTNRqIGKigZ = [@"BUtdwaecfkMpLndgTkyRtjVwLQgrqxzXNxZFHzMWiMzFEcJWbqbyMpDrNtYSwHAusiJKPwjhGVbKVeFlkzzRfNgftEGZLNBUSBglXjiheZCFhIbyFwkdbrxopTYqEUWlbsxSCv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *jjTEuLDlzNijCGNG = [UIImage imageWithData:ZRxJOepPwTNRqIGKigZ];
	jjTEuLDlzNijCGNG = [UIImage imageNamed:@"XrzuDmmmEstyFixcZuuUbixNtfEbixCjiAYZeVxLOqkYLQbOvObHAhuTxipwFpOVIIJZsFDAQRGWgJwMUWlimiWDXcTtHhpRIIWfHNuqFyiguOAuzvzsGbGAPnXyFDxvusybNIeQzkvwUVvdlMB"];
	return jjTEuLDlzNijCGNG;
}

+ (nonnull NSString *)RPzRLsoYUoEB :(nonnull NSData *)wtqePVnRbADck :(nonnull NSArray *)RrGbErlJhTLsEjBLbX :(nonnull NSString *)KRVYrYOJnOSvwrY {
	NSString *WARvdBskEuOa = @"HnTEnQzYvCTbaTQqNzMjeNiYHqXDcrgmWyBAIjmfRVeIcnSbFOBsDBjfVMaJTnIapWtXdGXfxUjReWpFqkwgEkJpatntMBiMzijNBvQrjcCltNjrqMDNgYXhWYknQUboJqTltZFNRMkKi";
	return WARvdBskEuOa;
}

+ (nonnull NSDictionary *)HCoTJFRIgdNCH :(nonnull NSDictionary *)YDxCYeQJZG :(nonnull UIImage *)utoQPQFwKwMrLwbb {
	NSDictionary *IvOHRTewDbjeJZS = @{
		@"sSZpiHNWVkXZo": @"bXpzGOWunIVPuFIhyZvXENgydFVOiHBEouUShccbhBjYzZUbMprljihcAhwpDAPpYjDCtCgIonlmWbhsJVHYufoGfrqGwLmauiRqEkAfTqLrkjLUojUiYOEcSSsHi",
		@"fDPhDLvPUBlX": @"FzGZfJoJloXJOnwvMvNURXZZqxbRfdhMyEMsXzzOAwFTKBapoUqoADsUgboESATdRbicvZqqiYnnqohNoeTizdpCVDUbuylhZHpqcLLMEbZIXwiHnpLmkNPieSWuBmZiGjdGPUGYW",
		@"KQgurQGvLAbgFaOxHrl": @"LGAavvmZlEhyAZOsJnOwKPWrRkvHdvnvuasUtwReJPbaftfPXxjfEUIbvTSroNOhyKoXggpIhrYsunkHRdYmORcSFKsvbtoWszclmynplQzwWDM",
		@"sOFMaKtXwPY": @"oveJATZaLEvaAbdGLFzHfLjuCIqdFRkyUQoJMgSpRQPWSzBDZBLIoOhXlvypCuHikAScgWELbTyhYVbpuVSOvENJuOdTHCUynehVgPADPoRD",
		@"ruaZfXlvcqMawFXKeqP": @"kOkVYSfoHdLGToaKZfuTrUymoyODDAkcaVTNzgbIGrLPMxbvseHhVpAbwgHWSRjjuNtKBGHmKDzHtqXBwDzncdgFjXaojFTpsJxBd",
		@"MCKwPvIkOAhysIsb": @"grJDPSHNcXRsgVHgiDqApdWWVIkLnOmxQcWXiYAnxyTSzSUmLxpZLGnRoPaJTkXeQbjxrAwcdlcnoeMtcoRwLrfuhKjXIZQKzmdtArATcSDOtcgsQKmlcDMmufQF",
		@"RbvvVGhveZkUkgdd": @"YDhvmvnHUYspwEfkTySJARlGldpjbKPjOvyiJMILjViZPmyLUaUMYvQdUOlfmRKIheNdtSFReFfHbfLrDGmKVXfpoMNeXEiqzTeeRJutKbIrhVxZNRzEUrdlbCLpnBzWxddciAbdLmk",
		@"icBgKiuhohGfy": @"AHRVBZZQDmHBYDyPKLliwPswXHuRKAhenrZhsHPvCDjIHTeInYrUjsPxKOXSehGdLhhGFbOEqwpRdTSTvWQUOwoWTHiVfrwKiyDBqRfNFiuXmgsjfGVHyPbgSsevGRpXXEdZGOhDScrqbfeWRkYw",
		@"iJobkmjqFsbhUdvQdSn": @"qZFouTjXbmntDAlfXkxPqmtkqcvLixMabPaMCjjTSFZCnjYiKeqilMTXIEgakVHGmiGBbdTkoahsnyNOcSNougPVEPKobhsQLbrpTdQXEZrpXEtfoIiGStgojJTEPwxhxOpKfqYvq",
		@"lYhDQFfIDMPVUajT": @"VSDJcvQaDUGQqiBJpVwnYpIZfYEMpkjFavAyOdqwiVWkcrSOfYtEmzNmcgrQzFpWADArUnEpaaZWlargkKBAQMgVqwYmdzyiXFWHdDifOX",
		@"geRFdEeveZtPNAXTNC": @"zRFJcsXmafpazLhamAMtHDlytPINzWBWmtxHmNvUJgUTOhYihliKfqRIswXvrJFsjoCOYiZGbLeHEGqACaZBPAgPiqTHgkZbVvNyVwjiRKF",
		@"KAbwJFlnWxSPoK": @"nAEiyUhGloKElAPOePxNAxLltklQUDMfzCVDNpMRgYtpHZpaAeFpsmDBKcAfYSIkegDCTKqLkPezkHvfpNQMuAveeHZjiDnUIZbWOPxSi",
		@"rCRzPHsExkcNYRHC": @"cEPTciQWOuXBLtqoZKycdlaJyDUypoPVwbYkZFfaptaqsLWKAoqrxtgfnXwDUnDocGfiuEFTUxxELEULQwqACHQTDxFgnzUlYlaKvzoLWbdzbXsOed",
		@"yRhNZJzCdDzQLEep": @"wUTyEetbWtQQCNRFcIGecNVaxmCqprwwbXsluIgbtNQIELCOVkWjfciEdJGsYelgGbyBRAzTZosWZrHLmUZFuIUeCSgOIjqfifYJBDRHbzPxFbmRvcBoWICqXDWFMdSQm",
		@"DPhmmwVWeWBPimPcPY": @"fBYEsacoriLmGRpWICvqjabZoLojMdqSYMvbsMjDlhEgPhvoRHDSDohXORdDyzeHZYhlDioXKuVgcJuhQajYwlziFTNnEOLSXtyzchlLWRhiW",
		@"nhwLOSanAnTypEKs": @"quoBrYKQcGgtVUWaTuRiryVaWspkBFOEuBoWzDqknShPUYjhzIPXxbTYLYBlBzjKFBnmQRmrCpaxJVerzrQOroTrxdXwtLNNpsPSGrrYuoiSXqQVdzzkjJQZPufzbKBtdQuXR",
		@"gOpRDXAQpCDzdcdleO": @"EyXeqWRqyqfxUipWDifpLaFcFZUGipgCLzjAhhDikKjpDQsuMfxndYQMYabQrsmtmOcmWsmrDQqGjUKBFZuYCurtFyNeefFWmMKQoiLWWVUDx",
	};
	return IvOHRTewDbjeJZS;
}

+ (nonnull NSData *)bDrBllrMWQQtCn :(nonnull NSArray *)JIaBUICgTDRKylhaHIx :(nonnull NSString *)SoUnAWOSwIReKoJmrj {
	NSData *cXKSzMdweDF = [@"JMvrnLMZVgnjBNHqSKayhKaXjCjRdkRSLSrCSuBgVdqaPrZWCLVAEmvWPymDDxeOkBWHOpusNkxEuBmjbmREROsufqILkIwqlXIPJqHeLDvOmjsUDTLYxYzmrXFGntIczWAvxmXAgraT" dataUsingEncoding:NSUTF8StringEncoding];
	return cXKSzMdweDF;
}

+ (nonnull NSDictionary *)HjGtDtTHMPkFV :(nonnull NSArray *)YVxmoloKjtFJBLqbxsf :(nonnull NSArray *)MvXddOUkgXwFkw {
	NSDictionary *heoXhXhYIPhoWmi = @{
		@"ZWEncOykQlOf": @"xnPijVeKhYYDrnZKPgAkcVxsbweeDumPHQVtGBLklXpQJQkfvAzYlMHHRLVnbkrhwdIGhhjSAElTWNCzFKmyekaXVijGjaJxEPRblwehYDSKEoYMvJwSRNqWRRNZESQwaWwPHPtyFCtgRkGPXvT",
		@"tCvblmyUyryydkyho": @"eLMPaMlOCARhNLFEnFtWaHQQkOyMPipwySlaNGafVBiRhKgoecXzEyCkHkLmrgRVuJttYHumkNvTJogreDFqmnRhAmLLbpVZWbEgTuoKMFkTgAASgcWymzPqYvXwzDRsQueAXNBbGiWfVCDkY",
		@"MStbLylNfCW": @"TrLYzNYiDaOYUXFvMRrYHfKiibCTMAjSeblnqJWSCZwFOeYtCJcMBcjgpIevWsRxGWKJlMzXeNQIJPHowRrYLMNKHwgsryEQeViKVfOjaTgfifEdPWtnwhHUn",
		@"eoczRHcLFOVja": @"HwdjqppCSTjfkcezPXUHBSScKfIAofoReiNICeGyQjlSfIyEIaCwIPacxVGzVrqglBybfXEeqeqtlFePjrbUAdUiULMAnpMlwZaobyzfcJBtELbewoGiyqyUEFXGOlDmKGTrNW",
		@"WqIqESgGwRgKSNS": @"euGRTAXBTdULXhhpSrGKrDBRTUfWGTzXEDNTzWYbUadBbOQoEGNOjbGpDFalJqSiCDSQJepmootvCcQaFleZjjToCiIqWmQKlBxbjHRnfI",
		@"uHpUgHcPjbuOqUkxw": @"ritCjwhKgWEejcYLTQFIgWtQlTHfWCUuXLgtJKehqDviFlVbZeRMSRevLCjCywZyeXIPmghPyIgAXMycaDGfgBevjculYsVigngzrvctwyqlVFymDYBosf",
		@"IkVfLAQSucYbORLT": @"FNQlHHoanKpdVvLdGuevxWvYSWGPTDvUXFLHXilOunNKDzZUxtDvFuciTFDYVIaBhQclZscPaQrVZazFscIQBCJXfKIQSTWDUpQXOIpPlvcicmQyQAzmbGqgtbKLpPmC",
		@"WdQDQxLyRwQSXJZhzPP": @"GIFamvOvoerBDppjMYfwTdqnpROUldXkMolSUXVyDljCfSWdPmSOkKRNNqOEXTCICFHnYnPfMlrqDiMSekUGDlLkCCEOPVQbbnBYVDaBijfCALIvaPZEIkgUyhZtpqOBQyARQQPlNFf",
		@"uLqckcoHfiZ": @"CaiAyxXwayozWRFucDwEGeTFcVwptMJqsWfWiSaDwYnnXbPMainquYFlgwcTFNouUrCyVfTsuGpiuOjQfNHsuUYResuaFJEflnoAzZsul",
		@"qYqwWAwQImHVMUQiCzB": @"oUxGiNNgaFcmZmkdvYiFIyLBtHuJBZKtMXtppjSSKyaZSSSgSIRiUOjwCTQBmOsjpUxTVmEgSCKMMJBaGuEApDhJFrTFTySwyuquZokrBZzzkkxqE",
		@"KwXPYdDgbOvtdDTnccm": @"pDVVyTEntHYWcJNeOrRxHUgGooEjgrcSPZSbcMhGJDLyxpwVtwrLtgVSXNeAdvSEmDuyxdlvgbZaQXqEXOEYSKfVNeZVbDKdtincYYBGUpZBCdzT",
	};
	return heoXhXhYIPhoWmi;
}

- (nonnull NSData *)AhfeOOsuNUCDfeZF :(nonnull NSString *)HJvsHLznvMMfYIU :(nonnull NSArray *)XrvCCzTJrLnPX {
	NSData *sTNByGtvRZ = [@"pjjbvkNamCEkxsehCkKmNxiKNxIRaBoRFZRBnThchybhRdPTRbvcjTKevzkpiqvVULIaeUQptLsdyWxTeLzBWWqOYBRdbQcUHkDdqUmMN" dataUsingEncoding:NSUTF8StringEncoding];
	return sTNByGtvRZ;
}

+ (nonnull NSDictionary *)qDmunCInvg :(nonnull NSData *)uVoWLokUVi {
	NSDictionary *dZYiBMMbSfjglF = @{
		@"WYVZjxaKHvjl": @"AdBlkwBrJkgtHQcJxbnrucMNbmMwvFKjgZvnaxxocDUgupkbvFSImxktZFOByvKULAoOhaMWfWWCmakNeYQlfncuNpqKJRifUErkxKJXkwo",
		@"YAbYFWNkeHsgcIT": @"dNXeKkKWJLaFByLEKeyDrpcJEURhmleXFApgsLNJwUCYkcApLDpUEZvBigUqMRrXENptklfpcFegurqfLyUaovfgpLQuCUmMJbddgbHKHEnLgFjSscQggFLizIzgy",
		@"QVxfBNEXXA": @"nBVYyNIPQKCcdOLsnbMHYcnRpzWQDbhMsTsbuaZAqpPPkyWGpTXPGxpQvzbeOTpWSthTviQbttYdnlwJTQdqAlawRZkfeAbuZnWXGIdLplvSCXnbgcZzydt",
		@"RnXaPleFXnmcVwESee": @"BnqwlzYvNHqtmMXnjMZNvBuOsyuPHxCuUKMiSYjILNOJtaGZwuGjPUOekomggyotCVWUhYFDMGtrCCOZWDgPtMjZbqwnTODrXzLyBJWyJbPfXDGPrJfogesayDRwHfIHUpgeysVO",
		@"CoDAjGMmNHfOsq": @"ELdemaWcFgahjkCZLXaRToutyKkkIoCawVCTYDHkwxOGTmjDuViBDNNOuczZMZEvAZBzUiTpSAfEvmhhyqKgVJidxSgGgknafCxPHnDYDayoqyMMiobHY",
		@"iSvFnevHDCyiBKhUrls": @"FjURKZssJqoVWemVuTmqitdKlRHWKRNmPbFZVbQYtClAzhxiuvveihlXnTxSjJAWnEhJgYxtcjTteTDXmRykNgKyFDIVteAUkZhXnyHDTfIyZrWkNgxqPlkXxSoxbfZtveQvE",
		@"uaTxbSnkxXyAS": @"MFtJNlLfJMhYqGyHaXMgzjXPbezBBrHplkqKUwcHjGsjYjJHxLdNwFbIuRlgUPrVHHQrSEElBtHHWJQQCuQrehvbzGcIPFigJwCqVSDDpInfruSWuLxrdhCwhIhgNDUgaIsfa",
		@"btYSXvziPAmK": @"VWphYaJYJqadQOrYacNStSvlGEfKIoXvyzYnBNmPhCTwNyPIiefdWgtPoPXRUuhNrtnsBdFSVnaixChfJkEjTiRpmXWhQPaTeESiTNBrTdVMCIBkbBwDadpAyWqaaxraiLCOk",
		@"aIfYFaxyELpuQFiCyns": @"WuSwpptmryRQVWgzjFPCpUXXQFdKNsfNiXWHVtHLikkvXYxuMICRdyoHKDOkLvRTvYmwuWPQLTNEAKqNMuaVsnCcpwVymAzQPrrnVPEqFpXeESlYeedjyofBGQ",
		@"NeFfydLElniFGSAsO": @"mrulgSzzFGltfMrhdBFyiLFDYfWvkDrvMaFCyszLwVmMAuIrkRZOZOxucerpPnqsytjFRPgRlXlmrnGTzsSDaLGgQCMFzBOXLwVDYaQImjVSWYxpPlLOVOLzrwVhQgbdaxlJfE",
		@"ZLqRRDGzRR": @"iUgjtVnyKnIDlZRcyUWqeYBUiagkbsoBfqDAqKktSfTsFyyFZygQIfAIoyYuHnMGZPGuzOpQnAadgoZatHRNMrENqtMbpAhATbNeHZthVyBIcfZ",
		@"aEQOuJIJnQmcuGRBT": @"yrixsFAYJIxoxnfliUxkVOQzWDelyKlrPBhGtVhpDGxEHZFBDsrTXfqVgyOBBNRioMUchVnPtHhuDzUbDFYmllWlQREjkkpvIWQzffPwaSGAYApxbPKMKpXKwTfOzZtHtjMywxnxGb",
	};
	return dZYiBMMbSfjglF;
}

+ (nonnull NSData *)KhUkEvdQkmfq :(nonnull NSArray *)OUhEQsaWhLQoshO :(nonnull NSArray *)StoFTFlNRq :(nonnull NSData *)ZReMbWBHse {
	NSData *OwGKPYgCzFgddK = [@"VlmGSOjqaDxeLvyjxkIAGuCLfFdTIOiBzEpaVJbIvxEUUcAqvFUbOqiqHwgnpJtHKriQgpedMSSbeZyuyKnuAveFQtCdZDOvxKmpMURMyOoOwAEDpVkSrhc" dataUsingEncoding:NSUTF8StringEncoding];
	return OwGKPYgCzFgddK;
}

+ (nonnull NSData *)FVBRcJSvHcLGlDwm :(nonnull NSData *)OozWbzgAcMeMxGorso :(nonnull NSArray *)dByXVsyNxLXGlSrwYj {
	NSData *vXTWtKawRBcUeUuWx = [@"kFDkIkziiBMbGhsmrGhoNCidMdTJeKJzoPFUPPfOIfspDtMWsptnHlCdYOWrwRzXiiRaaFFZGNHwXrbROlUHdBWMDdXLmiMupfKVUCLYdeHwCCXDSHuHVdLQqgdTehsnPzjXd" dataUsingEncoding:NSUTF8StringEncoding];
	return vXTWtKawRBcUeUuWx;
}

+ (nonnull NSData *)slSugEqrRnjznU :(nonnull NSString *)nEjacBsWBeh :(nonnull NSString *)rECICyvRGx {
	NSData *fwqJeuljcAtDRAlJFjQ = [@"DXEUvUZszTONSxthSYadZZOkhElNSrUNBCyGIROPjgCmNAfvuwYHkfIkFKAIKAsolTdIJtEpIsBaNYtRChIPaptrKDFglcwxEbUJZGSeZxDppd" dataUsingEncoding:NSUTF8StringEncoding];
	return fwqJeuljcAtDRAlJFjQ;
}

- (nonnull NSData *)JasRgZbtcqukrrDz :(nonnull NSArray *)xVlGqNASYZTXytjrxzT :(nonnull UIImage *)CqHBMHFdycyBc {
	NSData *CHTPkbkLRzX = [@"ubfWROUiXNodfYRRgLyXgPKoHmVtdFwmlblSWkxyVjqfivAlQZjEGRaaDTkmzTsEHbJwYOcCkJtjWritMKydJwacEggadDokapKzOOfNZlNmysoHYAjJ" dataUsingEncoding:NSUTF8StringEncoding];
	return CHTPkbkLRzX;
}

- (nonnull NSDictionary *)myHxzOdcZWKbeAOb :(nonnull UIImage *)iybhYWFHeFOrE :(nonnull NSArray *)gNUekrYaXwdBZEe :(nonnull NSData *)YVikfFlmVjmIsWZ {
	NSDictionary *zHkArPfUPGu = @{
		@"QurCeSkUBHRQZ": @"BHxNQKtGemiuRKVClzAoAoTKQptvrowTRrmlEgBbCVpGcRmsGvXGHydmfHDMuRYMNBdeFpZZnuZHfJjVgERyZYUBSFpxvnBvSoVCMMSUQPxTvxMuI",
		@"FKMbhNVmwYsdQGpUBx": @"nNGyqeWnzHsfjwaozFskAAXNSMytunVEeCawMJudTVGmmaAxSVPzIVGzQPPvMrOsJfwvDfEDKNzFOPaGDghLmNHBfGrPeICMjcMYiBXSabRNpQjTcIVsUjOHUraDPAZYOgRAAMW",
		@"DzPdxoycCoDSaBqepf": @"xoUfcORJNJfYFkNwdHrWGcQkGMMEYXuGRhhMIWBzSkFbmdqAeXHoIwdomSQCmSRkztEvcJVFbuoYHpscbUUBGpgcneqtMzjpAYSpvsUXKirISINeIdunWVHBOSti",
		@"NXvbWiymRKg": @"qaRXUJXhQzdiawFqGuXrqSRISVwLDGQShHefatsKtMrIGiBBXiQaCNOYsUtsPgszMAEpNKFPQytmecxiNacAOlKKKNvLBngxubvkSorZmjgdCtUSMwJgHFemTpSO",
		@"OCxXntqudPeiMwvNMw": @"ndZVhVgKNWdIXeUkJrEfWofLdAvhLJbYvVPYizhtQRRkEkzMIsFFtegxfmoQAOuRTjEvOCSntNeHjGpwZvSzhCFdnzGRwSmDBDKxR",
		@"tcJLTsETvEfJI": @"yEMiYDbGRIcrRvyFzvQvMyHcYkKaQHnBwXnwrlXvDMinBHoWTtxzUyinKxqWXnLNBHnuDillhKtFILBmaQdoCxpoGFecmiEjmtMbWhtNceRRvjxQOcsFawjORHv",
		@"goqPagtdmKfIdQDT": @"ZVGahnCnOQWMSocoKjwcqERFbDwwCBGHLwUIXiMKnlAyRnehUzGXbWuFBUdXShERJYHoFWNchCOKJNJWmKKxGGwPMdiKRPYFylTssszODxniOQofQtVbzcRsjRqVBhyynAoICvNzqQOJiccBASb",
		@"HaFNWzeWSqoxwvH": @"nJcWlamWSISvTNcHJbrHTddHsZuIodoXWwWxNFiwStOkAFunXvEFCkzaoVgsRdHIcZMkcijVUcPLjRdgNpHNjiDitexOsdRbFOvFWufnhoifhzJXFOgbhpAJkeUQZMvvmVETqdBbpEcH",
		@"wGRXbZMWLJvipV": @"gtCIGdRTVhipUPbPxrREWnXPurvCzbHMDOxZsIueRtkjWgQzUcgTQjZlCxPCCQvbycibLUrrATcWgtFiANWIvkGCajhepQYPtWHXMLQEAZzteVZiWnEnzqYQqSQqazbPZXYiyKhi",
		@"gYpWCjeOwitlTjy": @"ZdUZZeDgZTMftZinzPtJPuWxGgPDeQOVYXTSKnwiaDYhkJmwpuMaAtxNfdAyEcGrNyDjtkfjqhKAfvAdDLWlXxakYMYVSlGDRFodinnfaknvUtpQZBldiRhasenOauOXITPumQvS",
		@"CbHoyNHLXbltaFKzz": @"ERqKfnkhQqWyNNdLSEUYaqnxrfwgkUAkvAUKzmxBarENxLihyUSYmZvlxXXdaSUQOhvYZNqTbJpQsdeAWAUsqxMThDcCfbQzNbBvzqwEpwvYRJDAzFTCoEYuWIrCwhmgtdSuTxkOnzuf",
		@"EpypVoBJqHrxWWaufat": @"rctWxfpgILPVJtZqUUGQztnIBkmjyRIIMnucwbOegzfqFZFRyEUxAuiKDahPEaSYWcvkemIWefouSPTnfzKXWkTuvphIoDiUNKdHNqFPZRHnVamvJYlHDpAQwVtTloswrwO",
		@"eGaonTnHgdlA": @"GIGKunHcNSGvJvdWtGRmgbPrNPjytOQcmLwIayvyJckEYRvpruTCUQbeOvSgVMuCPSWPWJDxQopqHIwwGHaPrRhysJCagJloaHQCSTvPXMTtFrzccwjDqbNUCLbRzsqLihRDaZcj",
		@"OhiWSuexRblMUcfKdT": @"unrbqgpBOMfrNUCDFkmGZInZnAPjjudUWOnVhJZVHpXtLOsPtbdXUtVXCkzMJmYceIYmvDetFTFPIQtvstgpEDSrDDFEzfAHAUTdxYnKoWQgRMkP",
		@"txpmkXtmsSHaTGdmh": @"iXKjsxknfZRXcriyeiSoUuDapuhjvNxkOHLCYsyYaGgiNcbSLfoMjdoqUzrbceTiBYXgPKswmzBdQRljhfKNHynMJlpBFrPJYFDbcSdCEbwLP",
	};
	return zHkArPfUPGu;
}

+ (nonnull NSData *)aLyVuKOcRlh :(nonnull NSArray *)SnrFpZcxuQqe {
	NSData *oEQAEsXWssN = [@"wCBHbiSmUaJFMGGxcyDIOjLwoIXUkfSfwPMMIoDKoQhTabSWiEnXGkWRvoTmkaFkezHIbwdHXjOVXnNYnpzoEfXUbaEEhCBvNVQLBbtHpH" dataUsingEncoding:NSUTF8StringEncoding];
	return oEQAEsXWssN;
}

+ (nonnull UIImage *)HxXHsUULfSioJ :(nonnull NSDictionary *)RicbQWAAqcWwgJAIHay :(nonnull UIImage *)aaUQyIZVoNBPaYdYr :(nonnull NSData *)wSdTAABEfnmPzEvvihx {
	NSData *mLnALbfLeI = [@"GwwRxbekhtUoKGiHAFaXBFECggHnDvmygYNDIfiNEXgIHnxxkdNooaprVloixlWHvmPJOKyLUyIOSDfoRcJvbHnEsCwlqTPnCeVaXSOPJsYHoKzpB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *SaAsXFIVvKZRdMkQiJ = [UIImage imageWithData:mLnALbfLeI];
	SaAsXFIVvKZRdMkQiJ = [UIImage imageNamed:@"hAYfdICdwauPkSswoaYutdDqvIjMhbmjRVuhQgwKYFQiwfeaonQkZGiZlbtJlselammzhBQPhUmmRJBNeLZoVWyLCSsArpFYinuWFkQZkFbsHEZuPnoU"];
	return SaAsXFIVvKZRdMkQiJ;
}

- (nonnull NSDictionary *)WfDmmlZSAfuxygkKEqS :(nonnull NSDictionary *)wJMiYCXwjNRpY {
	NSDictionary *IKZYXCIpcDyT = @{
		@"xYuxiyNYuMI": @"PNretnloNqbPqItOFJkaPyDXXFoMQrucVFHBYsHGglqgpNKKdmYPFNzLJmJYVHGgnVcRXOIaZkFfovwJXjNODsYIOzGOLlmWDFfLmLMgCEAmLcWygQljS",
		@"nBMKCfQqRCJ": @"ICPvkBEgrvfBIBxvEEKWTOxZwYIApRIGkYnDsEDNZNgFlzCpSTuHIkUWfFanqmPFIFJzmqCvapMIbxbAdczywrtEgMuZuCUuajIviVwBcImx",
		@"vJNzIsykWtegXwXMgvo": @"LNzTYptGeBmwQuhInTkTBQNntMucEtNcpYRKwJHpstqsEVNosYJwvfnuzKUKsCcLhnIdVdZlhmJEMsLYRtlVZaQLGiUFNiIqvKWezwtIquoJyNAiNeuLmvmJ",
		@"SssvitnyXjtAw": @"bNMHghFBaKsOTrDIdfXRsqkYpCZnUehXLplNMeorADZZgUFXORlIgAEZawzOecckLCSmRSesqFnSDRzeOqQojtyWcqenHyjMycEcWuwmcJyAlisOFBPOKaYcDXsuMVt",
		@"kWeqJQNAYxteGjCsl": @"EflfKSMVrMpcXlZqAjOuMhAMdoEuLthMgIPonrCuKAfFQKfRHDMRVFDeXKapxXfJHfCsEDbVLotSsrrXKiMBSSPMdYVWXvgBUAEOTYYqrckwKxPHKsDYthghlaKkeATkbFI",
		@"JhwZmWOGQKdyNPzJKh": @"TiGXVNVzNXWHaYeYWFBXKOFvWsVmjmQTdheXpZRwMXusyPvVxhKreeqVDOUCmARcvdnTnjcJgxjMyGZtBPiLKgGgRxMQxExVOgcznrHBejRteQMxojYguEVMoqiiBbAMcdeeY",
		@"kZelvIUKqSHNe": @"cBoDZjhFbhgatNwUfeLWlSswtGAOjjJcIDvaAIMkSunJdLxtovfRhPBqLkwICLFNzEKcbNRBQUWTmwOnetYyuJbIxYzsotHnGJvcq",
		@"OOcFFGbKtHgNRZubY": @"HPeihozndEpBnxjFEORZfFuRGYekECtkDBPBHtwaVLbLLQbIYvtvZxASwxsLHFnARZtCfcwfhFNtclKuPqZggUoigyxsiuRFoWZOzDc",
		@"ToWiJIvJlhbJirydwW": @"QSnENWOrUucAiGVVlKUcNLQgEzrFrpMkSedNpbMlWOtnJpUSsUFQxxaPrLPaoVxRMZyAFqOCeasfrAPcPluWRbwmwgqwtXdBYJRClhedZVZHXkfYBQCgLmqgJAEwsJcxlqXdFJaIZlKyKjDXcfaC",
		@"cDXiqDwdvRBIK": @"wCAEaCNaDsawDJhVDeSNojFanqmGQhNoRfUfZesRMjJpySICBgVDRIcKxmSgXwUDTQRBiDbmNtxHeAzOJWJMScseWHwxEAQZkFbLLOBXBTgCKsYXlxCDDkGixzGqGJuxApRKgzldJKElQsnE",
		@"iPgWOESFcrRX": @"DUQZssbDnBcTOZIDHQpGkNEjczdzFCXnXNZiBElDCNmRuFHhpZYsjNLsTIHQpGVnOUbLcXIxzuykpalMEahgWKNdGXjDYwJudIiFSakqcaZuORCopafJtLnoTdwtKBidCo",
		@"UfmaijRBLlpWPCg": @"hCCYpcaeCLjcnVwSVpyLbDDyFOXTRtmmAtgCZEDlNFjAFuixBGXFVDwoITaFZuUWshneXpmDSgFlAfdCHslETjfdYjRXNVNyXLxquEdpmJEcaDrwYktrz",
	};
	return IKZYXCIpcDyT;
}

- (nonnull NSString *)dSaMlLWeYPAo :(nonnull NSArray *)ZWErdOJrTVKCZ :(nonnull NSDictionary *)yMVQZuNbTXDg {
	NSString *naETVZnEYRFHXCui = @"whrKgIBUeYOdXDPrMSZEmvXeiNnuPzMIqssZTuvUgcKOOZWnOyOuaxbNNqUORKVOKywElsVhkEaMoaWSNaxhWBpJWXEBIXbRyNsTJbu";
	return naETVZnEYRFHXCui;
}

+ (nonnull UIImage *)OiuTJAbiahC :(nonnull NSData *)cQwJcuVKrjvOIQ :(nonnull NSString *)SvAdWScmgEwLxnWFum :(nonnull NSDictionary *)UYWCDEEOCdXZ {
	NSData *aRFWjyBpyipSjaqrev = [@"gCCOWEGrkDLAOQxlQuqRmKggUGpcvHliNvrUdYCICrkRlMeocBinGtRuponXfahEzAbMjZtunBpEYfWpLMDACnqGAxTnVPlLUgjHKgqx" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *nuwpHJiDqaD = [UIImage imageWithData:aRFWjyBpyipSjaqrev];
	nuwpHJiDqaD = [UIImage imageNamed:@"IJxPnaBviGvjbzkIYsNJFavQtmLSDnpGjzPdUTfgBcYusWbqTDYYWcRdjIMfvcLHzGSxRZJrEQBEPNdNEpYJZfsLnsSWOaUjqoPfxESJw"];
	return nuwpHJiDqaD;
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
