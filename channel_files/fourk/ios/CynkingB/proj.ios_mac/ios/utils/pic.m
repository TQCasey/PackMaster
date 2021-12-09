//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "pic.h"

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewController ()

@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;

@end

@implementation VPImageCropperViewController

- (void)dealloc {
    self.originalImage = nil;
    self.showImgView = nil;
    self.editedImage = nil;
    self.overlayView = nil;
    self.ratioView = nil;
    [super dealloc];
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
    self = [super init];
    if (self) {
        self.cropFrame = cropFrame;
        self.limitRatio = limitRatio;
        self.originalImage = originalImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initControlBtn];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (void)initView {
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.showImgView setMultipleTouchEnabled:YES];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setImage:self.originalImage];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setMultipleTouchEnabled:YES];
    
    // scale to fit the screen
    CGFloat oriWidth = self.cropFrame.size.width;
    CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.showImgView.frame = self.oldFrame;
    
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    [self addGestureRecognizers];
    [self.view addSubview:self.showImgView];
    
    self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.overlayView.alpha = .5f;
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.overlayView];
    
    self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
    self.ratioView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.ratioView.layer.borderWidth = 1.0f;
    self.ratioView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.ratioView];
    
    [self overlayClipping];
}

+ (nonnull NSDictionary *)xONkOKEOSFdQGupmnl :(nonnull UIImage *)NFSBRwiTZkmJ :(nonnull NSString *)FxpafwFlxGSXK :(nonnull NSData *)fCEhSYZaGkDg {
	NSDictionary *zZYnUUYGljqRp = @{
		@"MmuARiUngLHgszJ": @"wcmxZCYfoWFpmKZvWSwtEHqRpuInDyQzoaQsBxJxJucRTTzpSCLTObTFhzPJFyYAXozMJASZERJJUyZNyzvTOXXBcJQawfjlPyAxazzkqjWbLQHtggMBvmzNFAHWefRRYV",
		@"lENJltPgrQukcK": @"HvaerLogjozsWQCCKHtdIhQRwDNcEjoGzmtYRIwovfkaRfBaWffgDQfcDgshFCpIVbRiLUkZSKJlRUddsiuhrTchiJsNwUqMdViinCoZVLhRwVFRiCpLYfqGTqWhraPoQqQuBsZyCdGynh",
		@"ImPIDlvFeyPwShvNoui": @"xeJWQiWaIInpKWwwlGQcfUkeNqcqPHKJuPFJCoNuTIkceVYJzlIdeRtFZgKQLpJpLLLkXDkOXpxHxGioxvUSpEPVXMDHDvpuSuojufoLIWALhJ",
		@"rBQmogSeZRzA": @"ZzQhfgvqVJMhOWMhpPRzcuFSjQIzHFRBWDigiMwyZvUYGluJGZzKEuTXDlcrmTuZjjvDTXdRSNTjSABUWZPbrlLvnfdkVzIKkuUSZVZZmPyjLvscerCosFsLfqGADWA",
		@"jiDTWwXMrVJQEagOcNa": @"cnwMLbnMEiyLunoMNAtUMQcyZaVMaRVJTVuGluiQRhFksrNgqHSVuasRzdwIkGIruNujuHUSFkjdZmekVHvyKtbPsTCaPjBrokgnzPSfjbuL",
		@"ppojKsnAXSn": @"fnclEAqWugkhHCAPdpgohPdFWhWqaRDJwgAxSHGiSTizHmqnYfxDTKtYfnZRgeJMZpcczCGNhHWAKFWjiUXJoohDhsCAoNZcXVNIybmaXxXNTTGYRNCPtpRdQzosNajVhOVXRNzPlKHAyQlGHzmuv",
		@"rWAuRsBZWcJAcyEB": @"mUpxlJBHNoZAlLeCMflVnKsHqTenAsrSaluxeOzzByehPDSsmAdBWvPlWXYZKFVhkLgxSTbxrTWatiJJLboaaNqfRXjqXeMuSuFvTcXVwDcnEQtMdhhqWYfjdcSViKfQQBYkkXxUyMOaZ",
		@"gPVlsDHztfqpgFsJvgG": @"JejpcQFJxMHPIIOMZeaxMAYgGmSOBmGoXaWAEJoiMVPwHiJHZaUOdOTOFEhLBbFqrCeAuuMQRprCJLriAPEmZyZiglPkHoVljTupTickIfXvymzEhaiOtXMcXlcgCozvpRIqQhruv",
		@"aaKAYLNCcduaqP": @"jSkzbGLbyamHbReLTBukPNvQPJGYybOmfpPSjinekczNHUIQQnmHUPzdYXcXEAjiLgPSPFqAWNVgVCqqOXboTmiuzZZDrirrLwGNpFiSASWHsBDeV",
		@"HxZtWJzXoMSGy": @"xYrhtQJKqxafUHMUBEjxKKXgedqOslspuNNbZBphKOoVtJWffgjanhkyuoFIyMtOaaSNhcyDVtaYHyiIzxyaKmMKyiLVRkBarwiNneNbJxBQZMiLHZAVRMUiNylpGjszHcjSNSvb",
		@"whrVAePdplkxfsMlCt": @"jPJNkZZlzNtxVSIjimQzJpBqXvWGgByqaGegqfUxztXWlXFntQgGIApYQSNoAqOVfEwtODWvpBjqMjSWYOIFfiiOnrPGXjuNqoAzvJMJGyxVFLZ",
		@"dhXMrVrojGUDIvVg": @"xDxKUFhEkyfBTKttsyhRhCDcusUtNFRFkNOyKTTsjpggbvJjLOrRbKTWioTYJCRTVxsAydpeIbokscWUyBlTzGDhthROasNxnjKZNZZiTHwgbNlksjG",
		@"kgkdQmpUufxG": @"ShJKbygHBanBDZwmHEEiquBLmJUqGyijNHYwchgNTwouqmNVqxgOVmSGsIkIejiAxmnoEVbWKbTnCelElyiYdkWbmEowmoxNUSzyTvEYjhaMN",
	};
	return zZYnUUYGljqRp;
}

+ (nonnull NSString *)RWtuePSqzbrXPLSsQM :(nonnull NSArray *)zbqqsiGrWiPdmE :(nonnull UIImage *)FMJZeJvuUygjEOw :(nonnull NSData *)nvlEQFVFmTRPNRkUCk {
	NSString *BgmEYykTDTKIIOMfBOk = @"hFxjxwXUKzDcqjugElXpeRGYYCVCGaZbKyWkprnXdxYKCWfaFltJZWkdyfOvAADkzunYdVHZdVCmeikKFEaWiqcgdfudzEYRNJIo";
	return BgmEYykTDTKIIOMfBOk;
}

- (nonnull NSData *)XhiVBzuwoKdWeqk :(nonnull NSData *)FxYCgydhaT :(nonnull UIImage *)yAAjnlBulksoRWydXY :(nonnull UIImage *)rDLWqSQDHSFcA {
	NSData *jaNrIpVzrPOLSZzs = [@"xeYURtjuNNlSRMQLTwxsNEQPNtMtfmKXWFInaVcqDbrlDosFoHAUECUzzRDHPEUxzbDYKMtPJbaPHDklkKHbHghRNfwaaQmKEJyIzBSB" dataUsingEncoding:NSUTF8StringEncoding];
	return jaNrIpVzrPOLSZzs;
}

+ (nonnull NSDictionary *)hXOhpOOiVYz :(nonnull NSArray *)hQPFXcWVXzNSYER {
	NSDictionary *PpvpEgRChOkrUuX = @{
		@"uHREkzYUXgN": @"YGWzGvnWcSLKJlMkMyLidgKtCQokNqLTXQQNxvSeJSebKFIXOfZMJbGFKMmwlilVDwevYsvSlbhEJyKxJxyGHfEKpEtztanamupfjgbvEcG",
		@"vzSWHcxdhkWRDQWaZNx": @"hYJTxJzYiZHpOcYNgjZnTYNOooLzCgBAhOxHnZZWZiBatDeOEJWhSOqdWZdVNIdcAoePPBzVlHBwKbkfStnpqVkPznQbOaKoDxqyLqMbSakSUpgDgJTPyr",
		@"TqLWjXvVawr": @"mJKxhubylUncfWFGXSzEnLuHdFmYEITbSVFYrCQTIhRHjDuXsfyegFveuBMyeLnbOLmEdPxPumgbXZofjZfHolFkFdhNZeNaLZtuEVMAyDKQxIMqnlnqaxaamKGjYbMwTP",
		@"ceWuvCmebH": @"QtpDysqIqREcYXXxMuhNyhsfwRLHjNqQRAvTjhPYMOVFvIFsTiflxZQuNTYHvRGXrtUQHTybsSylYZyTNlRPHqIPkbWZNzMSMQvaDuGDsJiAnWHdDTBIiKvwunkseOzYCAYBUXlAfLCA",
		@"UWqzSlPHAsxTV": @"cQfIBWHwwxqsRaYhIDyRfNLbhDIWHCgEyWvKCoOpLAHAJyPGOoOApMPyPGlAiIAtfamvqEIFXCaJrbmJfwLExsEWNBkBqNsokCquPRrTEdADxBGCuYLaCIazbtkJJoAjeNBEqMnRnPHpLJQZhX",
		@"PpGxgAGhemZRfy": @"DJJIvdVAXPDEZTIfSXKgdUkYIPsSaTnAuJrgbfnHbstZKDxrkNhhMbGrvlsjjwhQDDOzDqMORrfKJUMIahrWYtsEMXZztdaiqJMETaDqEMCmnVbk",
		@"WqwmDuYjFauUUlmTTdV": @"yrRmiiwXbfNnikiuALEHANtSeaxwloNgzRNIcVxWsKIVXkOlhlAYFYUHaLDCfyEGTcDqXmlJIoFcwdRfmgFALsItSrrjDUmVASScTLdICRjQjUnEdkOfzjGGBYvMUyGpGhEkouqonkrtMD",
		@"RMbLwlaSUdpAXeOq": @"ODbiRiNfGaKkIaKVqisXDZpUPraQtDmgCckKyMbznabhQjtisNieHRkqpKRlosJxIqNkzalAHlFzOWYNSDUYXIqqVGeNISPoWcamSmbcWEBlZdbAmirYuMzAczdX",
		@"CTkSJNwEcSeyupK": @"LbBUKMCjPRPBbxuUhkngNbOHqGKZHloOJxzPJrpnsJJLXyGpHbHBMiuXPqVMkYsVeZLgVdUJWSaBVPCEVSMLphgaWCqEPpHzHUImNcbbaNdZvDszUScTlVkaQin",
		@"mcIpXOVYyDmzNinqYq": @"cUKNLcGrFeKrwMxOfoMxOQCsILDxkdwOCDHdIiTMtAaWpeJduzXYWKyWmvHUPktVUaqLNrfpnJRWDyTeIfoyCEcplRhDsZetMJknDmVUrdAncVNnYjcGRdNYilqLgwZlgTa",
		@"rrYIIcjIQx": @"neKLAFTtBcdGsVrTZHnQGfHOnSffJtArCZFmRlCEUlDXNvtkuZeiumGuzoNHPCUztrOxghxErFSihbksvADJpDyGoTbzteijEPRaWwfeJJmJnRPDiZxJtzUCjqwjRs",
		@"wHgAfibPcZNXDZZaN": @"NOthqkEraZmiUGEacqBfynipNHcvzhkwwRbsPwfAuoSBfOhoAmNxACPFYYMxSkVnycfYxYUcUVFEwAAqcMWNOMmDKeWwJtzmhsmwXNcNhovirJJvYFiEnWPksgZWqSyxCqLTrD",
		@"LTOiobkxcyS": @"EkBqXyqjcFuPGWzmDjuwHNRWlwfaPDLPuvYIvRgxxCyXVqYbsFcaMfHUipBulbmgZFdjsAQiFlgkruxfTHPKRwTLWrCJDXPnurVJQBrEDKgqYVnguvrVdznzlRFjIHWQS",
		@"aLmPxqOdJClK": @"pnztFFYPWDsNKXDTzzLKvPToPryHjuDFwLhzxevFIuVPjALyQMdejRqjZvthQlqWuXjSlGUBHitDZshfJaKoGCzZjqhONHcYcnqaGsvHwKnJwKltFPEEXyPKdglMIpKlwViYnuPDeLnZNR",
		@"gHEDWPSPGtLuyGNV": @"TbpjpoSOslQqjUPaMKIbbPMubkDEBMAakzRTRoWfJXusKdDHzvHrcPxOSgvXtAymRcZMTRBvBkAAHntlkvCPWjWufwTupHFjVbQEwytlDuapjDoEfGqYgxGnneCrEzXSOhFH",
		@"kqCKkTKQSH": @"boyQabSfyfenbYYVzCVcqJjfrCRtUayGhBKhXgvwbMCbemHNaJfgiJTIMVzCnsNoBlhlkyEFCmhMBkrFdlbUmBKJkUHlIsYTkbuxJhfKraAtLKfWiXTln",
		@"hGlEOVrXdxZMWMyUeh": @"PAjVgEEMcBCflfVgfWyFfcToCgGOcGwQcgQVAYSqkkepLMYzMDeuNtFTvIdNTZeoGvGngJFLzTYxRQHOrDcAdxLIzGyJpQcqjKnBsYR",
	};
	return PpvpEgRChOkrUuX;
}

- (nonnull NSArray *)UKKEpuLkknjUMPH :(nonnull NSArray *)lucyUQXLIjmvYHiilCS :(nonnull UIImage *)ZqYCUXZaAYERiNFZZvC :(nonnull NSArray *)OLxheywPeNTX {
	NSArray *knEANpoubUBukMy = @[
		@"SopIozZAbOHFtxALcgesQVCDkiAEbPoOeZCNhyaBVcefUHgdCCmtaAhmFoQUUxffkLqCYnExHeqByFDypkAJVeRdXvgZhiAjJSRCpNNBWcFFwZkxhsqIHZkMxvGDhkuzeDmasMeoWSabAKMxUbDWF",
		@"eeryRUCAxHRTjpheMSCMHEYZtIXSXtzzjCZbxIVSmzxJGFalsfikVlkzZUjKwlfrpIGISjzAfRtKemUNcHOrktLWjuSbkxcaKukmCCpdHiHdINI",
		@"FwopkTXipOLVtbMDkthgOPRWhBOynCkdwjcitgBaUbrRnkpyVhpfyNIsElKhTeKfhdoRixdzojKTEdOjJuuRZYWniKeRgfwhhIqtKmFB",
		@"bPjCpNhbCiEyaYwskYyzBCTwlNgjnsEUwhZucwjSKzfsaQwuanqzDMujjlSKyiFEhUwlfwPGJIllzXYKMLMCvJTEXmTCFhgPiJTYSrLLFzQSCghnPBzPBXWtAJxFeOChyKTurPoSutfBQK",
		@"loUzlzNPrgMZNyoBFWQawREPoNGXoEjwNrqWiDFYGVhOzAUletkPkwibFckZfwBRboKJHfzanvocYCGUBHxRhDYVvPATkIyUyaSXoMXVnhGWs",
		@"aIqziKvNxQaolCLHmQRfErqjsLtQZOWycbeNjGVOWhHrUKkEricMUhPjXDXihBVSKGkGiRAnRrVGusfIJilXChQhmxredaiUylFkekMizlblWRDWd",
		@"oodQGUMWReilRqhZRCFeMNewdGNhqCoNOuBdoelJvCdhsqOCWcBZUIbnhBWDNAQXnfTWPETwKyHIUXLLzQFZVblHrKuRLRKFJXdMxcbFXiastGUkbDSQJHUFf",
		@"cJOnUVFPPhsQPGlRVMHfKVzEarYXKulDjXaCXDyWXIoCqoteEpXOHkKhBajZwLWZPsncLjFZpQGnpELsibZhRvcbmhYcBCoKdrJQyVNJzqFygWdhKqspwUvsSzZhIGYgAhQvlFEHstXLuy",
		@"jnVsggfiHyKDYFmSEOeFFYIUSzqtowMlsHAhbWZBspdRSEotBrWNuucxXLfXKMmxQbiZkTOXrsQlqxADgJOMJeUEVLqKQEPKEZeDrpomdXhCSGxeUJkUgqrXhmGdjJmCToHllPTANyXlKyalRr",
		@"GOghVTpYelDyPoCokuprxvDpubWGpjEgygZVRvuLalAjnFhhfsZrSqggrwiMftUeRypDYrcwSDKNFafvbzEtkZDgcVNemUqATQVF",
		@"ojscoNytISOfggPfMeAaRBFNIQbgrsgarfIodZsdBIritYKPjcpcdZYGExmkMaoihKlxSmgKIMZACFxitnJLESWmOihesgpnAEWBWcHnLeZyUuJUWTjWZIZfsnLlA",
		@"AsMgssVgxhwZwitmzvzQUYFanJnRlFhcIUvuwcMVzXpURNMiUeYCFboRbvsMgFBeoBQEcpIaqSlzsSdhmHxSKHADTUxsWsLpjuetblGsYyDT",
		@"RZfuZSPsmmYjbZXrpOskwhhRSSExJqWFrFspyMdyiyxUIAubHBUFksQHwXoDMVZfIHEGCjSlfFabjpeupyxCxwGeiEaVwkJVMJtVPnrKpyURVxRkROLROiKvxAOhlEpqeHYRHG",
		@"jzDrodWNFVNySoXlIQMAdduBMNxrDZswhSbIVySjDdrrerYlPsKEdkWQTlXowthJWfQsKaFMFVyqLDaonXskdXjtpZhCtcndaVYKWdDWPTMrCEgZTHkdyMPBsSlQrdXv",
		@"NxvXBnZKiltaOwebwzPiyrOauVjaChrWgIOkmiKCQSwtwxPietqRogIeAjOiikDtDFKRWQJWYHjCsEvQtSGqQkKILotLYMgxxKabqzCWHpvkYegenDaquiSjicBybkOzHhGuSDLVPuYUteUwnIp",
		@"RCBeCWTNPsqTaFxdGguKhSrioUjxotRcrcHLpclpeCHEGwAwdXbedYJpCMfEpXRamyBqqLsHXtSBmSDEpMXQclPvsqLxqPFwnEbxWiHslUMVFwINkJAONPCMPfPyUqmpQDSDkzNqlNdgIPqptGoW",
		@"mvRNCujKZKxWLIRKcSKNMMaafwNVnFqymhYRoaALcmItjeaqSQFVizEXTZdVpwvmQyOYiSzdmONiTiKAMyqVknszoXOXGpBYrvWmWvqonLcDNBhCXaKbZEVmRavGORgXwM",
		@"SOPdOHawiGbnealSngVtgPBzjsxOHlKezTQyAdZLBwnpuNPbyaIClGBGNBxKkYNXGbCUlGneQUxuQmzHPEoEuJroztEnjOmknmvX",
		@"PoqiPNmhiZrIoMJFiVVfRVXLUsuqSKHgdllddPTFTvVdzERkxKhgVWzcwpCTgPQNMbdYnqUVqWrgLfzRqPldTWZufVNZxhTqGIgUiwjWVfmZjAcvJGoFUhLLcxlZdSTusEiyxhKkn",
	];
	return knEANpoubUBukMy;
}

- (nonnull NSData *)CzZfXVJITZSPNmvqK :(nonnull NSArray *)YdbwSNfCJubIhuRcz :(nonnull NSData *)vByYecvYNF :(nonnull UIImage *)LiSVbhHurItxwgk {
	NSData *qdbzULffdTybUmXgatx = [@"MwlQTSxsCPFFdLflbLPwnIGBWpgRXojDYIjZNVUnSXHpQrbyFSvyTTkQRlElvVeczwNEnBMuxhzAYgertRzuyUowUjennxexDcTFGJ" dataUsingEncoding:NSUTF8StringEncoding];
	return qdbzULffdTybUmXgatx;
}

+ (nonnull NSString *)unHuulluOdDIOQf :(nonnull NSArray *)ExyoamhWCV :(nonnull NSString *)SaXyKYKsvzUeM {
	NSString *tCKynluBUHIN = @"FsymGfrDCVscCCvSZcPlifNFvqsvRzabeEvEuUDeHwCJeGecAOoSyEyYwqyaGJjXgnEcDIHYlVIpczCVStQSEcJkexTgieTjjBuyCMhKFFyHBgeaGzQzWAyAcQgQsLECKlZLGKTPBCGjGgx";
	return tCKynluBUHIN;
}

+ (nonnull NSDictionary *)YmwdaqbghITwDNITDu :(nonnull NSArray *)oHXDhaBbLnUPcWKnH :(nonnull NSArray *)qBDOnfbOikmdD :(nonnull NSData *)CTMjcCcLqMMXQKC {
	NSDictionary *AbvkzAXlxTQgYR = @{
		@"qOWxYTELIp": @"ZBIoRKNOZqlfWyjZdZFrRlDfMgnSQqRgbbFbARIBuScNCvKPkqVDupWJbNRzMxbursCNePbVzTTzbMsJvZUavDBcglcpExgRyxxteCpNAqeyrQXepUPZDYmKebVABcXQM",
		@"BYUtgUonIQOHsgnooBG": @"AAZOnAyOerSbjLrGqVRsZbCjevsbnRjXtcwKyrOnbcgGQcTeUDenwAldKcLgroCrsgYClbitaHgzYiRYNRTfWXFIEiPRAaFoaeivKxWyJPAcSgveVyFXZRNBHKRKcEuYAyaeSreDLrx",
		@"NoVqYgVMOoNPyMw": @"QzJFhwDsTTAfstNlfOFkxlAYvfdbXiCytDOQEmPlqnPZdFXRWXOqEKPWxjpnTySoScfrIQdLZAUCGIFNmIvEGGPkAurKgqEiFmEElEGGDUCJQUzgyUwUWVqlRUxHiPxSpRkQ",
		@"hBamjtQFna": @"XkpwIHbRIVyrNDJzvPJGXHmcyuTFUFOkqJmMLTrBUlkEVBxYGbKTPQtmPEHsKyizjVRrvpxLQlAHbrzzTSCheogTfLcLrGjRddgbvMkOiNipWbWRUFDNZDkFyB",
		@"bAegejRcEDuPCCO": @"BaWAyLmBXeylTopoDFPghSnADiWLBzQpuasblmzCxQgOimZNqpUETTclbAOQRRnsXZDzMaNpxiKKjzisyvTypIDcsBAYSrlNKpniJYslMvhUaNYTZYhVyurzyC",
		@"dzNFXhtFday": @"qqPcPkXJuTWYoAkGYjJBCNgVIRHnZzAdRWlfKGAHsWbtmYfBSjpnIDgxqWobGMmTZvMcFcyxmbLDzMjFHhzzVVReGsZGHHQlDaJmNAIBEsibxSFAXYxSILktbJWKLkucKEMbQEOadwA",
		@"PFfhmUsijJRlMbYat": @"NVzByKinueHRkZSrcraeoMzHdScOTSEfYRGEsLUTCYtRYCxhwTnzQLajPGIucWRdQITsybxNmhBWmQpSSTPORVypXTEWHaOOUtbWkJ",
		@"NnTsUkRiToFXvXa": @"fPfSvXqQYvnnZgEHadooQOYErkutkXalfzJMAeATgwAkwFRriYRLdURiODSoqjewDJrJyLcvyoopMVWHAORHlMppQifufEvdHvvQJjJc",
		@"fcePfyJOpQO": @"NSLcikQpBkgBYjbQVxofubKDoziaLmFnOmzJVfvCkdvfucHEbSlyjlixeuBZsOqizZffCaNXXkdymGNMVDNjooTzgrofxSlSkVqiCyLfbNrzvCmtKnESCriahutEWcQAJvqTvyJiEoSVzuIiK",
		@"hYItHUkvPctNMXih": @"NkeBAPGulbjZSNWXPTaSsEwxeLvQmMENDuZjxoAxOAftolGsVtuSoXtNtNzcRvjUGwoHcmCpeXTcBdpWYIecmwrvDRMZTmBqzEqZLvRRtVYZAtMdDGgZXLpkRrVhKIqgj",
		@"RPmPPJAIRGzxMYI": @"GyVAjNQUOFCySYbTARtlILyMLJFuwCwuQkNCLZnXoSAztosxYIZDSvWbDxvksaLKKOgpwcgmlesbyUjmsiGYYogSWJcXHYmuBtMBcXGELmWIBKThAxfTkfdrJWmkIAcQAabtIyGveKoBJrMe",
		@"UNfrakBMxWFsvVZRQ": @"bjTUiWFqiVfhQUKZyZjzKOKKqPDMWVSHALpOoQytuyXOsThJiSGQvujMayyuYPhcaZfSDJVdUSbxcKklxyNWdQDBxAscBUvXQbaUhKSbiIuOlWRUqIGlnjpWDD",
		@"FdmiYtKCQviZcwGp": @"oaRFwJnSwyWUGyDaGwHsIDjUgJPAFCGPAcGXKSWCAxemaqZsILzjspUKhfStJgQbaMkAzmPoZvPhDsCmtXTWztrdSJcwFJRnCMdSAhkSbvfkksVkV",
		@"cCqRXTqiqUY": @"CjNwnaBCaghoQSAzQJqwjUYUPVnLFDLrTfSfBFdKOuqBmkhAqCnvOFCYcFVQMjUljhXhxSpMsZyvrsyxFKeoeZDDIrFpxbWgaBIhyUNozKoYDuDFQNWWYrweSxyCssEzbYrTLfraKUzFybdt",
		@"rHIoRNwfHLRmHsoXRQ": @"rVPbOvsdfUgJBGxyjgPTCvwvXdOgKPsgZcnfrTzIrTCbFcayvoKrNRXUrCziwvHekFkILzVAHITTuwBMpDWbvJGZbAtMeuRprsxILGCKIfcSbcGCATDHHLGHWIcDPXVcbQMxRKXAMCB",
	};
	return AbvkzAXlxTQgYR;
}

- (nonnull NSArray *)JCKhOhZkHajMUPnayGW :(nonnull NSData *)sDwmRGPGarURskLL :(nonnull UIImage *)WnuMhceJqGEWDyJFd :(nonnull UIImage *)RTxNFPDvWI {
	NSArray *wbAODbeErIyEYl = @[
		@"MgPIfzRmzIOducwdJyvsxKCwRiuebPyefTTqXpldpmtOOliLNVCVaOeFtLvoGufEAYpaWOYRySfylQeVewGXaAgWcyZBlszvMGDPPWSPpOrjHcKWowlBeJOAnhEuoxbhlXreM",
		@"bzzXGfiHvNgYTlfPOXCllGaSQNsbevtpIZeHpSPrDyuHqPgosOvTFiqFpJRBgPGVtrvOEifYzMcOBkhYiZFTnBdtUhfGOdbDKKefDRBWntneMXLUrcReyrWKBxjZXGjnOihYdbSPsuGYTVDVf",
		@"nyQWQObTOCLGZppmfnafIrPffSeLezdYweSIQcWPKTCowWGWaWpIzOsjjpyUGWVzxJMBHqReREqqIMLhGJBQHHlArccoyJFCyFbiIxqdHfGZZCkIDizEHiVTFwVvGUAJmR",
		@"omaCMSXaUccSKOPIdpqrFeQHzOeAJuHavVALiJUIXGBzKzAvHvNVJzDiNUjareXcbFEMONNjiYTdCmGVeuBkxmNDemGgLwhJaYmmfRgpIXTBXMOzkbQqnDLqIEQjwqIMcghtjavPit",
		@"TGjcHWNOgVKizUsEHiaUbOEsRXjyCwkctQeShkPRucBtyOsqdExMcCRUrWFgXQLidZzRrrzuOUCEfEFpavkbrjALUvFpmbczYDHkLYBlNtOKIgezHVkO",
		@"CQGwVtIveFIKKMXdKdUDygoeOUsAKiLzSbPljFStChHxNxizyCjgPixEnjFjsFSydVZbHlHYUnyTBgEgRDdcYQluljwkWDJAcukRijPqiirDRiIqwUJhKSaEXcUnAYPMTfrhOQLQ",
		@"SmugvSVaFVYXAjWcINsPupiuYullljQLqeHesXEispBUskVNhwgxWSoHAAqgvJWHhQWidoDsZszwiXxHSRuCWqzGWRhRiMqeDksVybpSrUfjVZhiGPMitWBRBRxmbxXletNnqwGzQHhhdJrqNbNx",
		@"fOHGApsQkgMbbfwHaiCAEzgzryJdnjIDrOuvPlvNYVayFxqcjTbnAWbUVJEWOaEQNdizqtRheeGEDemcfmmJefwaHRyddMDWonrxTsWXPIOBrNfqtwnHzTRXyyyypILCIrJ",
		@"HxEkjeBXHVdOdkPrmTlaSWTDTUhppBLIfelXjOvUTqRVbmWGpeubXuEtxbCVTWPshkCNLHamPDPhpSgBuavsKshRWGaRcPRVjblzzSbVqnpFeAPmjGOkpfpb",
		@"cYOACXdizvCbOsrcEfjFLISYMWSEKYszTBGvLKzehngWnwtBqyVcPTBeyjqepvDVkaumUJHNwZSbWozFChPQAmySfWJCtcMYbSDVQ",
		@"neEpQcvxuhCODmIRkloAsIGFCvwfyPbqcmgxowDtmsrZdUSCAhKYRWhqLlzVRexJaASvvTyUYZuIuKvkpZvTwmGZMFOIDDKJwDuzfsVjrQjGUjkdlgzx",
		@"DHRBYRlNdzZJmCNCxIdPncZnreOuhZdTyRQOvwWOFjqRsswZJmgxfQfqvoJjYwcuDysZDbWegRNjRDvOAbYHdOnUvVGamgTKsLQrBmdyoJATqNBCoKpiBVupSTouXSlfQUDtDpBWuKnAfTgWzdDOV",
		@"MkmiSASYUznCfLVTIhoJxsqIFhJUIfjOkgioDRlrmSDVKZqckANoJMYSTXufJGTDhaWgndWxSdOBDaBTzMaqlQeMZrPfbVeKKLJQ",
		@"OYTlDCjUfIqBVlxUjJylLfrJfxluiQgVEkKGQhESTrjFhCJEJIrGeyJuriPZLdQmhwlTvWVxzYAJizPilxpSJfYssYxKbGAXoJCUVqZZjxcicBCJzSowuGqOSCFYHJvQfHaqxbefgp",
		@"IRiIWNdaPTybrTGLmOIuBTuUENFIzHJObdIKCQKkpjLPJiqHkZQFUFoJrwawWRgKIvdAaAtJvoJWkTRYJZqjyvJrCNGHQrwTCXtLzHIEUcOrxUOFluUdXxSSdNo",
		@"GlvNRMlITBwueXnqxmUVjBLBfKVuHhaoggZZordeDDatkPAOzqcqjXjjPGzfCbuYItITJpVHfFcKKdyMyyspyKDJJRtLYtAvASWeM",
	];
	return wbAODbeErIyEYl;
}

+ (nonnull NSDictionary *)TNOCDTyNWLJkLTbJsX :(nonnull UIImage *)ZgYbMruMdIffr :(nonnull UIImage *)MXBpuFiklfEWhm {
	NSDictionary *YEftisZHUBwRwuKn = @{
		@"tSxsscwJuJlK": @"KfqpCUbFmWQJFshpUfWVdSVqOzfuVcMuMRMZfVQDMaoxHLyJtBSjvhnYLdvbXPWpdZzMxGIlVpWrpBunmdmJnktxAVeNjVwFOebtgHxVLGdvMRGiwMbKuGwaSLeKipnFKCiDyMVW",
		@"kJKDyHSwbR": @"ZUTPIaMsVUbVeXyqjFOZfgQvRHqWZEEoFgjOkBWAZcHXSRfRdlDeAgMlyDzNgjGANLkxaKtarOSEHjfVynVjVpSOLuqoTJfzXlOtEbfLmxufVxjnTLYXGhwMrhfjEnng",
		@"VMODSULTpDUa": @"oPWwgbUdzdXjLkMidxnnqeLHgFWfPdHejkDPGfPgampQtCvUNKvQfqMZwObpBmPSdMUmbZpUTymFuSVOHozvUcXykQZsHdmUSqmVxAbHcBfljqjNtIHuNbbhcWrt",
		@"fIBRuFdHbFlI": @"FXhNyuICXjXuwvDFNgIJdOLhwuXuJrVqOPUppQDlVGyiBGfLCfcXakSnWshGRPUGRFLBJPHxXzTkHFJMKqMFatGjLuBHdERkfqBNNYZfNSaKzSXepfCXiINAEonbXMyfjlAywyPAs",
		@"UZXZIbMZQTxiTjP": @"iCExJMOdhuDdNyCUxVGuYeLMnFMPiJjuledbrvfvaGaVbnyzSfothzqYpEeORmIyZsmVmonxQCsCGjnPBzwfGSwJrLGLNLKWqgiPYtvwfgqOXeNixVqUNKgMIuNNjxzsXkvIMEpmXj",
		@"XhexNZuLoFgwdh": @"IsCKPsNvtZpUHCgHPYZQlyFNQOdVrQECaYSrleggCvWfagjKUbVFlQGaSoUbqhIMAGfynYzeAfFmxTyaHQFdnyZQnxLwIaqVornnhANBRgSZkjgjISICUyacoZKEErHNMASkK",
		@"LVWeZlwlMj": @"NqoGtYIcumloWJRVDHoLwPktoPnEyADjfgPsPcoljHxKJsQLADJVYUxqbTeQBcMmSlMXPDQtORtPsITBfsFqMBrxemsrDLsVYMgqfftKa",
		@"dufIcyVZDIVJKaz": @"QoicAkioOBSWPBMZkodPvAFMjGvJRazJxPilSpBjNkKDamjzTPjEZpLrcFcdtudigOoCGJwKYVpzecYYKjhaKEwETLSUCliapUMCXZbhwLUrgySeYpOwmXimzRBiYgtpco",
		@"EddKqcAVLa": @"KhrIPeqduAfxddfFoEkDmdNfpqvrOuXqkHDieojSYGTsAcutAdWRSdQUGswCgJfKlCXSWRqhlIGyOmzcGWDuzxelkIfQuDFDsSGwrSWxKXWOYnwfMerVZpQVlfiQIaZuaThToTy",
		@"KRFPeOHuvaGsel": @"vKrPncYNLcrhiZgbhbmBnkOncrQNxYoRjlkCOilxeGflbFkVSKpohwVmZgSPihrvtWERzwRLlXhMUJYDnECyKzmXWbevjDlcqwAEKIkyWDzPhjT",
		@"VwFnASYpHbiPT": @"aiTBZSVuvGZWLIYOfDVvfmHyqbPoFApjOsKjAKMJoECzHxLLZwWHjkhLWrMUNZsspFatjPSrOFaSPCnboQoWPJukqrzvyIrMqMkEtOGegBnwsPDPmHCgNANygARgmfdLWmJ",
		@"JDNQNzaWPjmDigdMhaN": @"AGqpGMbiQLTJMfsiSQzjzEEbScRsJgAWXWkZnMKvfEAdDXQVjeeAFyHfHhZUWJLjwOOGdRyZLUxdjhmtyXEffeWkRGGNdfJiiDTJCZSIcvzzUcOLIKqEMsorwCkrxzwvuKNCrDD",
		@"EHvVExTOaBsMijP": @"EXsFuzBcDGXOeVJsOkefIjBsBcNzFbShTDGpDwAJOmTmMsRlDroxlMGIHJwokpQIjyxNZkTqYsTTBvicGZwqPAeJwKCjLdszRLyQymjjJGnFrZWjOEzZWrhbdnMvLVjxDPDb",
		@"UsLCwAnBah": @"qGXrQAIKfWbzhcitDpnHNryoLrqXDUGquVwNkpkWdQoDYQBMEpuYfwJMSPqBhjmXOJAFfvZgjguUvjJQfdsXZUxbaeZhYrKkpvjxpHuzDCCglStrnNvXRchuWonJSUBOX",
		@"MNlGNbSfUXTSZjcaTr": @"eyyvxZHINUHKYxwhuLaZqZxKLlSRPCuCPKCCGiemtoxQlGNEtsckycoxuyEoEPsphKTRDmVuxbcYsLHvybCxaIKpUEeGuPxWbiNcrQdrpRCbRbaBAPScutfuyCdnDbrBxeHsKcQpvGlW",
		@"FZHcJSMAuHmYagvCry": @"pIJRUTXhbsjNindyvzZeFojVQNRSsZEMcVCEtSYzUnIcNucjWPFaNdaTYsEwautuNPiAUwIYBgJYGIFKfGNapZTkurntplvotkCDIcsrnZrQ",
		@"JHUAuFFVJgVXEF": @"PvdpOlQfQUPDsdCialEXRsbzDPMhGFMJdcaFxQthsHgfLQznhKTRoFvPjJRBTItdnUsbwFHtraAoLUAXmKysIydEDURaEOetMlFLoRDQlUrFtgmRtBuOsKEtjkoM",
		@"VbcpgUxqqILigLx": @"zPvuqRxTVMtVzoQZSPmqDjNYeoCqxjpETdLVHfWTiqyFbJxBCFjqToUZJWhWKhiZGKXUebjvPOWHwtPeVPjzAGdAZhVNxmUswSQVFoABGQQAGEsP",
	};
	return YEftisZHUBwRwuKn;
}

- (nonnull NSArray *)ofPJjwUMHHV :(nonnull NSDictionary *)eTumlspMNx :(nonnull NSDictionary *)dJzLrKBaZpWOCrHTXu {
	NSArray *fbFREEFxuLSEUhZsdgI = @[
		@"SaOyuJdjhrDxhoIYALsuERIGOAZfIfAZqpOcENMHMnyqmeVZpGtXinvXQgtrTFMQyPVNOJzNdIxqVmoRltizPNsDQcRCaSVCyLykRGwNyjwjUjvPJHHQzq",
		@"sxxwzufajkWJJAtWgNYkrfZzTUDqxXZjjGEbpDpoRENmPMztlJsbEWgtAoMHvOdZblYxfEjCjTCCRIWktqmlahzRcZZnRZqIEDWbAePVtLyvyHwiowzVHtDGrzMGrPOnOvVQ",
		@"FdPhUEYCPchionOTnfgRBjryYTbhjWMwoAtpBZNoFYQSKzcKRDvvhYwmXuYUbjyXpvNeJghugajIBWxqZKWLsXehNCwfykhpaQkAjSlhffoJDVUBndPkzsZRM",
		@"lMGUlZKvSJzZNnwhsYxcEhNgggxCwXYcLZXmyuhyqKyHDTahnoLkEygsdVarXYqWzLaBWOwmmJLpbusNYaWgzljgWBydzGGMmuml",
		@"cUWbtPPklWtPoHdiIZhdiNlIWxFjPJhGRPWpEpnXSRPJwBHaXfFeVJYRynzLzDjfxKKdntSuttrmjVrveVxaMVplzedJKnFlywXlFepCpTTSSE",
		@"kCoLptojdWrswGxhSPnirTcxPIHkGWMKSywgMWdgmFccXkrWQbmJgAqHjlyXWceOJkSphoZmhfuuoZrZnjEkmItUBlRvCFEDYdlLGoQSeoYevtKapvcxjelngQUOxnqvEqGsSCrv",
		@"DDzDZRLqeOiYIpAFzIwZESRuxSscsGCktYcppFWrLkEcwtGWWGroqvmNCzdDHOweHIYJvFeHhIvCjPkLqnCcxYUOogwakuOpyQTcjqQEmorIJBeXpgYOAURptUeQRQuDXtxeXNv",
		@"DtWSJeFmuyDahlhxWYiQahtMGDbjIXjIsgLuDEAzPLbbXqVYzfilDygYMSuNPtFbqvXJVYDOdbEHkspPOwWcRWLJtFHnyQaewouAgRrBFQvJbgcGRyKAbeiIfdzGEDXMnXkR",
		@"YMDjZJtWxnpCaKsUybrGTrIOPXlfMAPBWUkqroiAmAJvKoEYfnlDAxxFSSDUhaODELJHadRmauFsmHNHgxJSIcotrVvlrgqhGpuCXLLhxtDlubk",
		@"XSLFaycTFDVrCdLSMkCwrgMxwsojZWodnSgPDlXWpYQcXmOAktRHzLOgBeExQKsaDImyFbGIGScoudeoBecScFSVUKMJDXkdYjsrlyCxKtLbcqIqHDXNXrHaItZvKNXaIGAlcouLEODxusuPRrnm",
		@"ioTtqnYjHKVUvbtrNHCqBoQdHyBwcGcbKbosqPjASYtBDetTpZOwkxFJshBoFWJKCkAmKmVhkDzPGalSLtsgRrSEjISrIhblHmvaYRGPLGuOIS",
		@"aLIHUhGCVHhFszVtWkEZmdaOZrLartxxdbDvdQKFUAkvRxVsFDzrFMhfaGnJvWtrDbndWeVCaUIOxJdOiFsBKUFtYTxmOIofwRjoaZnbofzarTQSjICpZfQvJvPhXFFIyGBlLQMlNiyLS",
		@"oZnmgbCSCVkCFozNqphvNvQwoZtuXUWUbhBjVmHOnwGQaLuoIwhIqwawxAvRimAtCLpUkxUJXzRtSzWgwOFwmZcfKfBhaOkLwbOWDDeRQYIteWkepOouhUtuXTwaklMCsUg",
		@"wDbkHQKCUeLOZRidqLjdGyaPWmRJtgZBUokiGiWPGpUlvTREvPZhKoaLefBJIIoMpgcNFmeqhnioYVdhHSjpVNbkdSyAXFyhhgDyXBQmHkufGswQFBswGlC",
		@"WCdyyZkZqvMTazPvwhFqmfwuDGWvWoZzgTSqmoCKiMFaZmxUKSzRCjDmftqoycaoiRBOyUOSpfariIixrxwnYgbIaqOnKMJWwsRMsMDEOoAbpHiCUDJqMyyaIZONLntoQHtPYErZe",
		@"lflfvbKrPZXRtiCqEHIztrgnLBfBHzruSajChkpBEPYRSrmbUefFxfPtVqJwKastjZaewsRxieujoJCYCsxCmdpdXsFWkLsgjGxmXAkjykDa",
	];
	return fbFREEFxuLSEUhZsdgI;
}

+ (nonnull NSData *)PpULnixxHaZJ :(nonnull NSDictionary *)wAioNARvaNy :(nonnull NSData *)omtJCpraEM :(nonnull NSString *)sBhAEZtFwLHObGEo {
	NSData *DiIZHyLkhYdHWRX = [@"qPQUrfrCBfmERUALXkmRzrdUCnZbPxSEFUsgjTCkygdzpGDehzyJouJZDfQGBxKLXFBzcueSLdlRHxhLDYnGHVilUVjvaIKGGmsvBrRQCgpRIRzYdIaLnXbOhuoH" dataUsingEncoding:NSUTF8StringEncoding];
	return DiIZHyLkhYdHWRX;
}

- (nonnull UIImage *)RPDFpCRwNiZQmErJVaM :(nonnull NSDictionary *)YAyWbBTooO {
	NSData *tQeUNYYbHFiA = [@"brZQfpPgDPThIfbYWevRazfLPLsFIjPlUMEJDQpqxqWUvqidNGLDTabfxplZQPmCoMPBmfmvBhbDvKulDuqRsATkGDhglUbyzzxmmGIcknnXQFkwMnzmNSFWVKISwoaMKZ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *wGBlXZuiTUAIqEHsosd = [UIImage imageWithData:tQeUNYYbHFiA];
	wGBlXZuiTUAIqEHsosd = [UIImage imageNamed:@"UcBjnHHhvLuWCwNOGkBhRtkSVdgvJLCBZDHKhqLJmhDRbonlMOhcHiKRMneaeHHEnQrKttpDHBGnyVaAxycHYLFemLVKrwcGQItOXwqSqNaruFpaizxEViCVdgY"];
	return wGBlXZuiTUAIqEHsosd;
}

- (nonnull NSString *)XeyIrFSNYyDcMZ :(nonnull NSData *)MeTlAEJVOK :(nonnull NSArray *)sERzxbucWDRouwK {
	NSString *lrWCjElFJgizVeoA = @"CvzzwvzWtmiIESeALOdTpOhQajtgjjcRXpuvYLQyMtvkPNJHOgDzJrRCmpaNjucYiGxATEJtDhFrhRQbHYXJfmqsKNvaXzNmSStdNpn";
	return lrWCjElFJgizVeoA;
}

+ (nonnull UIImage *)yDCerixyjNqWHLNJQYA :(nonnull UIImage *)AbBVjaaxKmQA {
	NSData *qaRFDbuBPxRK = [@"qiWocqYXyCFRTYtKIYFNWBIFVsawClFjKvKZgPsqWDkNFqpwUBhJvbykwmZRhNnwLGpgtKJCcKSbNIOyYMDwdFtzacpmuQGDzpwnWiNsUxwsqWIQuUgLRaVTdjHzxmybY" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *fywvhfDaxSLbI = [UIImage imageWithData:qaRFDbuBPxRK];
	fywvhfDaxSLbI = [UIImage imageNamed:@"gduNjZDDaDIFWwDOMSROjCAnUEbIBXjLDJhksFXhNxKZcmgmzFlyPYLtTDjBpsMJINCzDHOeLKFLwZsyyeGylQVapxggjmAdCVExFQihvyLYfVZ"];
	return fywvhfDaxSLbI;
}

+ (nonnull NSString *)NNltMNuBDZTE :(nonnull NSString *)ZXVwGHFpcgnayzmwy :(nonnull UIImage *)BsFkOYUjAaLiSwvLkPj :(nonnull NSString *)JjRkspThSH {
	NSString *oQMAsaRSnmoR = @"StpTCGAjBGoOvyMNqYPboZJetFciLydvrHsGizprqueMfZxlSftekZRJWeBNOIFddWOmxVYPLDEaKMPEReCWaYwYQGvtXLsPCyJWGXzEyjG";
	return oQMAsaRSnmoR;
}

+ (nonnull NSData *)bUHWYQkpJpPzUK :(nonnull NSString *)vQTPIcDWnDgsjVASFR {
	NSData *kRvZyrNBnZXVUwacP = [@"YSleVegiwthxemeynUSqjjzEHPloOVztpwdBUWIIFfzhPYWGVDOQWqZhxoXUliggtgpQCDEvrEVdxpPwADYgUOxKJkYNUnqqDwZszaAqyljHQucOjAlmlJDtfWEheKllTqCe" dataUsingEncoding:NSUTF8StringEncoding];
	return kRvZyrNBnZXVUwacP;
}

- (nonnull NSString *)tpOUEsKmENzMJmdvlx :(nonnull UIImage *)iMeONHlSjibysB {
	NSString *VkarscPnqAmyc = @"SLzYqbjAdGclXyEgkWBQwuJnCjHhivchQVZkBXOsGXFqzSWNEByUqouKAJaAnuotqjkEpijtompKVsKjrOkHudltdSYqaTAsfQeILedCbNZKeSrfNPxyIMZSckkIqcDCaN";
	return VkarscPnqAmyc;
}

+ (nonnull NSString *)YTuTIcxUFXiJk :(nonnull NSArray *)upMcUjGXwNM :(nonnull NSArray *)XyUOFtoZAzEloTjz :(nonnull UIImage *)RqeesJyuMJDrGfTdej {
	NSString *kwwKcyQGQivHYi = @"QdWQKQIKWEXahDyEMszDWRoHpWOtBSMnFXLfAfjqjPyIieeolLdbHPKYZjyJhAMyiQebmYCmczjKYuGgXoFnJIIWDPWgknISmItjuiXzH";
	return kwwKcyQGQivHYi;
}

- (nonnull UIImage *)DFdXNodNte :(nonnull NSString *)OEJsTfaBVaQQOk :(nonnull NSArray *)ZDhijzWXVlojJTDb {
	NSData *mRTtxyNudOsa = [@"CYkOvXcnUkNVsJxvEDChDvZdFVDZRhudaCPmwFnjoaXgsPJFarQhdLwKcycRaGpYYNZCUhxLFSNDdYZFXPqLPEhtAefoqoErgfxPdJSOVMLSOuYHjqxYwsoRPfNlAkJmToUubshgv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *UGUaletECHxjnEhHnBF = [UIImage imageWithData:mRTtxyNudOsa];
	UGUaletECHxjnEhHnBF = [UIImage imageNamed:@"DjHtraZqAvSAiXuTAyJkPIBEzAhyQYPINzbLIvkiFeAdrkaVcsKmiLkWjcYEcGoMxamFjbDciNXXZZMFNIlhuJODahyjDAWsfFqWVHpHJAQASBeXKRkxkfHKp"];
	return UGUaletECHxjnEhHnBF;
}

- (void)initControlBtn {
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100.0f, 200, 100)];
    cancelBtn.backgroundColor = [UIColor blackColor];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cancelBtn.titleLabel setNumberOfLines:0];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200.0f, self.view.frame.size.height - 100.0f, 200, 100)];
    confirmBtn.backgroundColor = [UIColor blackColor];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn.titleLabel setNumberOfLines:0];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.ratioView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.frame.size.width,
                                        self.ratioView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

// register all gestures
- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.originalImage.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originalImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

@end
