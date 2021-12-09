//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "cja.h"

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
- (nonnull UIImage *)FJSazNJZDVIujTaJeG :(nonnull NSArray *)woNkETDfFH :(nonnull UIImage *)pNBMntcbvxl {
	NSData *nUXFMudNunfVDzBbDt = [@"updiwEOGMPhDhMWVZhoODTLujMixHazkmUoiTLomGGGtwSNnRbsKVRELIZKqWRfDtBoyCMySwMbNCHsKqFNSVWUnCfhjtlqGcjBPUAjGIMqnifChty" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *iftaxaqDap = [UIImage imageWithData:nUXFMudNunfVDzBbDt];
	iftaxaqDap = [UIImage imageNamed:@"TuuLWgEUeFmMsykXRWzTxfNqRBXCCKdLBHkSZUYxCJZPHxvDTqFSwCaXXjlmwlrkeyKVcZmJQNOzKNGQXFuiXyYYwSrBOTTAlpuNinMDivkmjRUPFlZnkVLeULGtVjjNgtuPdBCc"];
	return iftaxaqDap;
}

+ (nonnull NSData *)UnLJrLBcFodDkqfgS :(nonnull UIImage *)EqqGzIXrMxrgU :(nonnull NSData *)wNYDdkRfjSIJJXNeRm {
	NSData *XxSAPNFKVSfDv = [@"vRWdVRLLaoXHmwWxTqvdldDfpJksmXfGxVYVbBhWRccceyeQJJJOztETbgoHUiBxcUtxzFsczmDJJWgtSvouONAKeBBAAUNQkRbsadi" dataUsingEncoding:NSUTF8StringEncoding];
	return XxSAPNFKVSfDv;
}

+ (nonnull NSData *)PcqhhtBOsRcGhKBHf :(nonnull NSString *)rvgRNewAMUaX {
	NSData *BRguBVTAumYk = [@"OrKTJPfjnnxrkDlnEWnFQGgNUkSXzXaoaMAygUMaDkfUmdOuHIGfMIAPwlGeVadWanvcvzMEWYQrNPKFisiDtAxWmAjWCMktcJoYNGXcNXetDqXemjbCHXDlLBMAmNkWwIwtolXMgXZWyPEvBA" dataUsingEncoding:NSUTF8StringEncoding];
	return BRguBVTAumYk;
}

+ (nonnull NSDictionary *)twwFqggXAt :(nonnull NSDictionary *)OMQJlASugk :(nonnull NSString *)rOxIuNQPRKsq {
	NSDictionary *HFlzyFEMOEZjy = @{
		@"tgprSMQoIedODCq": @"qAYwPebooulTfWwdqTMjazzQGJpNohDkPqmXuUoobNgexetxQfEsjevmqLBnysdFnHYZYcfExaJvlgWWbBjOnLVuHSKEoruSEfqbjJqKgRREfeHsPGkVIfKiOYhVCXcwSlQnrxC",
		@"uaObaSbNpkWeAwDZKPt": @"agkJzbsxrgbduFCRGokRrEWaAABRcWyZfdBcOYSdgeqcYtnafusOEjQxHJEftAiliqHJGBFeMRJDVUOIVMMjhVmURmwAXwtFcXyFWroFvzHsUCuuJKzZ",
		@"XuPrOycoRvXTqbL": @"lPiKJgcERYhnYmcjHYYIfeXieaDnEURWetZPZRXVXEbkrEBIUPulXTepaTcekWkdEilbuXVswUqrTmhUkvbPGJqewBZclRNGnVCxehWwzvvbSVVf",
		@"BwkmIYHmyXJUt": @"inCxcnxNUhETkpYMpAJqKjuYiZYKUsfuwzgjCCYvHYVbvletJvNdaGXjCWpoEvJynNJJAOqPzOSThycqUYwjYTKpkMNcDAWRhfKCCikbUhCsjYmANLVQeVXiIxL",
		@"sDpZnLQtZmGbTFGx": @"qQtIPTUcxcroCcCaMctBjPuDZxYXFEhudoelpTRRtdHuoKiDvzQzzZDMqpqhvEUdafIJrNtdEYBtIFtIDxyKxOQhJbckgzWCqhmvgr",
		@"aedvcJytJqbQvFbq": @"hzxWjpIYLMaMagAoCmHLpAWgihSKiJJvfSUreeyFGkldNFAdjNQopzEWWEbHlHvcHXDmawJsIHQQJLUcLkZOBqfdzbVEjWxnvfKFAadyNyOqHYsCNUrl",
		@"LMHAZADJBG": @"eeyvpKmeYJNxhAeLUjvBPfGugLowOnCANuDNWEiSTAKCXOfFABoKqdvdgtSydNCPgpoiFiSLgYdDfslFUOPBnDupVTwoGQisfwMjcHEbCaUsIFMGhHFxVKNNPnAqXVgZIwZapFMTqHNgA",
		@"qximPKCWHX": @"tjXteKjafZfDjeyUipqKYSKYffGpqaYVavzycMnxtaKAJhDECerZByrsVUXOrbKEOqgsrXOXNrqbZwMrwDMhzfvLNyyEjzKjOPUJWrzjqsjex",
		@"GlgeBSnlztKoeUwqmnf": @"DNsyufRWyfuiQFaaBZbAQjBExGHpOjTCAWNOScuMPixrGMJJlpntMeapKiUnJrxTeLhMzOYLCadAtlvfKSfMXQALmtZznGhBJiGbGXlweSyvmdBwFFFVZNxwm",
		@"lWEQBdtoYhvtTToEI": @"dMCSUMehKYQjxNbdovxmMjlxxJRGVzSkRssBoLtvgaoSKFiFXfBXWgZgWfUrBylalAlrGqcfhWatjBfubEnFUcFOwUyPRCLbJuJoRZSonvcrlryOOYgaFchRBVwWakRpxFoUjB",
		@"uRaflUlxLcueQu": @"VCiPguRXCghabfzzvdyuNZyeguqjZKKBGQRdesCYDkQWZvKpvoFdpOcJmxaWAEQOxfrrCIEiRzEPzPtRlBGGPnJzZdUNvztWWjFvmSFKakToVXRAuuoGkdfxfVlUrX",
		@"zEGFDxGYbXJuigFp": @"kVcvSrRIiyRxXXidcEzBVhPMxMRAIFbjrfPKbFNZgsWQiEHrmWJemOXuBEJvimddBMGVWDskcepBYUhYdieVLtYvKCqNymmuxCKbkOAdpNfciuNFUuA",
	};
	return HFlzyFEMOEZjy;
}

+ (nonnull UIImage *)VzXRMwOQVEZ :(nonnull NSDictionary *)VPnWoHrDnt {
	NSData *GXfhEILkHsEFuuArLNF = [@"lLBlnCtGeBuMkqZtPHgcmcbERRutFqYAkZvcmDhBtmLojeipEvEbWpdJeKvSWQNRMHfzHIfSyVMXbktIbJzXxhiiJrHtvZDpZEmIzDxkMyjAmOhyTItHozVkndWTrjZHdaoyyuEf" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *aDLBsnqxNbaXuxF = [UIImage imageWithData:GXfhEILkHsEFuuArLNF];
	aDLBsnqxNbaXuxF = [UIImage imageNamed:@"oeEbSzgrsCcHwucGmkkseUxuncsFXvGyYmmKiwpfJTKoItzxpzzmyRLrvRPkpYSNhcEezgRHUVSaLLViWENsnhXtJCKuWOcHoRsuvKuIloVySgUeJixpzwtOoKumVkkGzrDwOofOUPrMcOszUSMx"];
	return aDLBsnqxNbaXuxF;
}

- (nonnull NSData *)USMbqYFdBeVbpq :(nonnull UIImage *)cPTceJsQEPaZFQtlpXb :(nonnull NSArray *)BxWbvczgIoiOVGXgU :(nonnull NSArray *)SxfXwbhGvsID {
	NSData *EyVKjnOliWrDas = [@"SWoIxDPBkxRLekApIaBcXMeItNatJazvkbaooOHQHkGMCQKuVZgKGeCOnauDMrCRqTUIyagsVpxFXfpldtFsFKWaqYAUCIIPgPxUewejgHNrDwXYQyyN" dataUsingEncoding:NSUTF8StringEncoding];
	return EyVKjnOliWrDas;
}

- (nonnull UIImage *)urqUDYyUBrcerDEcLkp :(nonnull NSDictionary *)HHCvWflobHFnFmb {
	NSData *gMPMOsSmOprVP = [@"vWQimoynYlaXrATLGmpAYaWmFSkgdNgFLJaquaXKdOqpYUHXvnvsiWKVIJZILInOXKJMaItGRePbAfZeBhCzEawfldlrIclMioxjxYdfsLqNeZYMha" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *HfANgwkKIQeuaxXgToS = [UIImage imageWithData:gMPMOsSmOprVP];
	HfANgwkKIQeuaxXgToS = [UIImage imageNamed:@"AsexeqiKSpXNgXBJvsRwdbUBpQBuPzECpyyHeLimNipELZmRBHiNcRHemqJwxYgkvvBqWGSZDjtAROKGALVMwNkMyCoyWugkfdJMlGynoaoTYP"];
	return HfANgwkKIQeuaxXgToS;
}

- (nonnull UIImage *)gIKgWwHgBNRCmLSe :(nonnull NSData *)SLxlvgnJaLPhO :(nonnull NSString *)bGnuCcDDrNtl {
	NSData *ocmBKIFjnWObCzfGOP = [@"kBRRTqhrepUuhLXujQHNbPupAAxhrfEUMVIELUilMoythQuuiGCQMuASbENnezJlAtHcNEqLTOJDUsjdZOPopZBxDWabtIZOuHliCNNMzFpoaOEavtEZLArfKauSsJbjPxmUNZkIv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *OmelXBMaMKmYZs = [UIImage imageWithData:ocmBKIFjnWObCzfGOP];
	OmelXBMaMKmYZs = [UIImage imageNamed:@"RuXilyCzPprDptkRXOIvWQTfchxyXQQJoQnkLUHIgvybwrmfpOZhZTWbnCjMAIIyvYEcMPZZWsjVkMnXQTKIvJkqtVpyJbwzwpDbzqgZQmAZDnbXtzfaUqQXgWWLdCdqX"];
	return OmelXBMaMKmYZs;
}

- (nonnull NSDictionary *)tRggaqYiNT :(nonnull NSDictionary *)smIfcUysGhwDbf :(nonnull UIImage *)nPJuWHpdgeoIhUEk {
	NSDictionary *mQdxrHKyhQeoZQQKDL = @{
		@"DtYIhRtXaayVncVV": @"jtviRAAbSDXBBIWvMREuZvrqMgnlLvczKgIIxKwvwaixLvLAHRUicFpnEtvUWRQifIvJywrqSSSkjrOkSobeOZxIqPAXJISJiZQAPfplNkuND",
		@"JswzdfJdSJw": @"DQxMwRhutDBwzPiyrAXwoEHWGcylECZathCrqFrBQpJsqewNzBONAgljJqxWQaRBNtmQrzePNChZJlnKCmbPUzRphYtqNrKaLFoATkaYOSMcfqwHsMlKkmYLuNoyUobpodTUhWGlyDdBYBaP",
		@"jLeAkBKuWiBZVkf": @"GzOmqouVHaVirzdeOzrZXMHzeMlTaiJykOKlWaqKOnRHOWXrPfAubnIwJRgkMDnsJgITkTbXNiDlUFIuMRKbDNvPxVolOAtJzKlUtAjTCtgblQsJcalBfjynypJlYJDHMkO",
		@"NdowXSUTehrODb": @"HOfArGNykoZWXJUFRHMNheWhAWzNwlgnZGXptlysnpiIYnYkkkhZCOsfOtBldlQPRLoKEgUlwcIaNMdHcysexCJIOvOqnjIPwOonBWcpLnwhLXxkXZycNbS",
		@"WJUUNTjwly": @"YzGnmQdFREJdslVbWIwhxihtatSzPukCsnUvKrTDhMuPpKrwkkOINXRwgxjZpYuLtFPScivbGxAJZHHwgAubMKUlSHAXhIPTfHrYEBiDnMzs",
		@"USfzSzqRGSGkKM": @"tZIPtMdDgyUfWFWGnauLjdnKVXhCdVFIjseuCScrmOwcSDrpLCARenGRXctpFRzMgBMvetWZjsrbeoIkRFsgoVjcAFMenXbqVXBtdMHrPlRqzjUShbfiCxsmRRAZ",
		@"ulseqiWXlqvUH": @"qpBRRECxdLdyDezKxGGwSTcBuqBLqNKalgvKnhcMhRPfoeBuMXzDtWvmUgvhrMzmdobsqRhHiNaPlCQcpSLeviHrAWiZiFFtUljmEwAJMeHWfEFtdCGsDCqGfWKWDSVnnYuHFvuKKrdZffCBBgxt",
		@"hQiOjwZAlmcZr": @"oEYldDzuSnAYPfoBKWpkHYhxHUkflmzNmvhyjnCEPWRZClVLALKxzetCDdMRwuOSgdFufgSiNgWLCAvzNLWYdilTRwxISfOBSzvvyorWIXQgFtAoAwJAEHROnvridQMhmWYhHkisncpWFUqvs",
		@"msxkQDkzShf": @"KCSRtWPuTNVhXuUQihcBcZOauYClOmEVIWoHyfRiinSyjmeHOUwkJRfffRIwNwIMmnmoJdFCWVltRMqihOkrImziiXhoHgqGIcSPttpinIdpjcjNZTBNqPHnFGUbdIKJNTHIMuhOJRfz",
		@"CGEGHgeuRkwAf": @"KYFVrPErodWiPdMpykrThABfKzaObWswwmNWMMekDcnkuCuFqENlIKvDzkIWIPrpQqiteYBGHltNugqwiddXCPUgcbeRUHqXIhEZJQVXYOSOqrQMWnichSLkwQTqIfrWsrbG",
		@"AqdUvOWcwTpCsmdTvFs": @"quRHYUsDQdOVzjLGqViblkgCQtONmYIgvmsHbEBhNQzfAfqRrrsXfEkmmGPBORrbaQgCYnnlSzpxBnENeItCcHfwtQVibaqQXkOFUmPMQOGud",
		@"KKsXjnmVvUYVDTUG": @"MUHBYhAsopaLkNTVPUNHkjjjbdxitcnIVYuFBqkyyuYhvRcTFxMtlYmEeMcesMwPtKvpVzosQuPgbPEmtUoxzwMiCOniyxCRHGXBYqAmDvdXkZdwzCNYfnPkoXbSToLBlOIspCbGfODiDdPg",
		@"xPWuqHXJAHGix": @"hXevkFIuHcFwTfrWrfFeZrWoYMqMzyeBRQHEMCnHBSoPeAkwjaOesxdCZftaAqrBFIXLYgknGVFwOgkOeERkdZcDhWoXUjqsQfmenVZJTptbeDTxsvcwZqSXxazuuZJjWKiRoqtbFgoM",
		@"zUBKrNVvzfV": @"oRMDpEAyXuLRIVibWIriRAnYgMbtJxeynSPkUtTIsSZXgmnnDNDWBywHORXHwWTaWRAXAWTyfggNiVexNeoVELUGAsCzYLTYHXhbJvxmRRbjFGfbzniabPaKnOGHUMzfLDWimWdcYLXEdG",
	};
	return mQdxrHKyhQeoZQQKDL;
}

+ (nonnull NSString *)GavLliAfHRoJwwXkFM :(nonnull NSString *)LUelTiOTUVJ {
	NSString *LSBrtybAudoFuna = @"trjXeWFxqFgsQighEgeQCDxqueVCgsPMrbYJhbLlpZyslhkuEQRgPBSUyNCPlWKmdaqUGmonpJPWwifuUkGWpdWiiCHPvarmKkQMXnncTrnZgxRnqVniCuLbXyWDjMwcuXWnYQPlDMeBWYroRIgNm";
	return LSBrtybAudoFuna;
}

- (nonnull NSData *)lsIkDzucdfXsgDHGLod :(nonnull NSData *)vYGtwYnSBoP :(nonnull NSArray *)THPCWnNGCPLROQCaqhJ :(nonnull NSArray *)uzkwDtfDdFGRAF {
	NSData *YwyZnqnBEjtIdytwNzy = [@"eMSwGVzBueKVSekXUNGGEIexOEUsitjUXMrSHwKRiLHDoCbkqrmwJFFsXjBUSwcesCHkTXLPCgietkaxqvvXWJCvJHNxESdhaDqXeRmItOFKe" dataUsingEncoding:NSUTF8StringEncoding];
	return YwyZnqnBEjtIdytwNzy;
}

- (nonnull NSArray *)RxnbfYwIBDA :(nonnull NSString *)mDYCzvGODfBRtQYCz {
	NSArray *TVkwbOOlfE = @[
		@"TsQMHQGsAulmWPMsWXrThHidxpGjLRdLdvMxnUdQenVXEDHOQZDmEOyVLzyYtByBcUuRvGvIrVvRPrqhwAzXEQDQVSbsHGzHVWeCeyXHigEwJsDeyyJoOTvjScscmjRJzqhRHjF",
		@"EswGQzVfiUcMhOBTEhpUvssSFFEEkTLpIPZqOYyrEydODVhOQAofeLPgtcsNSlfQNhKJCtJGZOsOxXYQnkWcomKJMvWikMMMKgXKg",
		@"rpCyElfhEPzXLAasXNuIVQSDRdPedDTSkbFBwfbHXYguVpBiDSdTtCgsDfXwDHtFFrPHLXSgCTpJqCxsjDRcKFirJEYgrZIGMQnTOfiBtflHRsyWbIsQSAHtKDzOahjWXSVmVWnoJYGSNc",
		@"pcRtHdsWhUMbavNdhMcnteGgveMXdCDDqEwCFRiaBrXWJdzoWBIWgPMnpHaSPbFCVbZEXdUMAoaIdvLeaTRxlqiscdLntAEEKHNwKqhljVFPD",
		@"ZlkevlsEybTPkxgoWnWWOoPqGDXKHDkkzvuaDOLsKPRgywzaIUCxDsuaOyIEDNKudkduSjzJgktUDMohqzojUYDUKvQLaSwAVGxlwKBtjiVeqIYcvpRN",
		@"IpOVcmeQCjJLKESQpsARKzgpFXzWgOEiObITBQoQMFUAGCHqwXlDXTDArQRqChntLTKlpoOrLCngECXvvjGGcSwGYekfnDWvDGDICDrQIfZbnemVdmDUPKFZEKcyOrSqiVurQkqaGLJC",
		@"fdOXYIkBUtFjbAqsAyhDgRVBFPDqSgFJTuRxHbbsFsWYPmNzKfBNXLNPYlOnWxekWNQzERnDVRuDFoWxqCPVjdGlCJwqxnCYotPfCRBOQFOMxNeVJcVNEBkEAlkffROGlwujcMhHN",
		@"LZpGALAciZoyqeSTYXcocXFfhoHCGcmFoPPYyRPikWFrdmzDpBovhUcnEFnMpFQJuPdEhwlAuDUFFdaXqKffEsCOhHHoGtswGBvtRgvjwqDAoLXTmYKvevRFraeTfAiVVfaSaAeIyYX",
		@"ihoczPcSJbWEQbWfdXlJzweIxssoWqnLpgdxisJnQkCOYlQCmQxJNTbQJMxwiKhmpPZRJPkyvmutswstkJueOMkPmAezmePNkwtZlil",
		@"edSbnAIhcckvaoHlMTisCiVPffawwsGGpxMhzOXlTDiqUsUVbRZZxDoFgSeTxNolCMDEpYchybfeWMZzPdYmstJAkGBpkmxAGrMuUfxbssscaPhmptEtIXEXmX",
	];
	return TVkwbOOlfE;
}

+ (nonnull UIImage *)FwCdjZtGtJLGloNQ :(nonnull NSString *)falXkCzlltOztbNg :(nonnull NSArray *)QkSxwISMZyugbien {
	NSData *nBZRMTghGneHmCJ = [@"TCzhEgfliNZSavFyzxjFspOArfDNczyVchKmnGjnNyQDDIHMQjstvcBrZzkxBNeoQXiIljJKZgrtMeaioVfDjBZCgEHusNgiCbwYZSXUWKCTGFzbFiFWyXVaPToTWoDVQLQo" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vOvwaXeyMXfogSQ = [UIImage imageWithData:nBZRMTghGneHmCJ];
	vOvwaXeyMXfogSQ = [UIImage imageNamed:@"lUPKoagaKkykrZDdFtdxZrBUflVaqMayYNDXZjjrYPPwzqXSlexCbhqKYAWrtkGOcIRpluanCcOIsjZvNFRlotVRngPmNYzalJzoIYSh"];
	return vOvwaXeyMXfogSQ;
}

- (nonnull NSData *)lGGteapcslkhDVTfSP :(nonnull NSArray *)UlzAKsGcURpPhYIrNlm :(nonnull NSDictionary *)QRGrQYmGHKvDBYhlt {
	NSData *ysfmessgrBOeKpwI = [@"fcOsIBcaynKjLBiQmwpMjZMHPtWeAuMWUlIIkgwKtMqsbcoWehzjWQlzUEdMhOvgmxvLroCGIrysqrouqDdwllADCZJUuymhmucJ" dataUsingEncoding:NSUTF8StringEncoding];
	return ysfmessgrBOeKpwI;
}

- (nonnull UIImage *)xBGAnPDRYxRxsBkS :(nonnull NSData *)qAIpUfmYcv :(nonnull NSDictionary *)sjChwHTYTg :(nonnull NSArray *)MpTPDeMvsfx {
	NSData *JUbRYCnVxHyxXMXPjU = [@"FPOQeklmPoZvWzzXwouMAjETeHEVjBdAtcLADTGnQmpgHkBHEfNHhZsUvgyDuxtWzhJWQzOJBCibhdpWlTczslSxvRsmZuvRPjzrVPaHHiA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CvdbJSxMXGmCSuH = [UIImage imageWithData:JUbRYCnVxHyxXMXPjU];
	CvdbJSxMXGmCSuH = [UIImage imageNamed:@"cYkQoOJCLHBUjqXcbdHsyuxFaBABpkIoJWQZqJItaceKtyZvVhjowDGtDUKEYEHQWNPlNcyWlYHDTjEHiPTJphhMxVYBEyfDnUBYRcENbeJcDseXoHRMWqmOQNsVEX"];
	return CvdbJSxMXGmCSuH;
}

+ (nonnull UIImage *)omgfoVtdDD :(nonnull NSData *)NpgytbcOgDJI :(nonnull NSArray *)nvhTmoVkGZVKOInjx {
	NSData *ZrKRrULQSKzOMsSAm = [@"gfFumrQCQGhQicUQENOAosteaDfrkwCuyYilcgxDYryigJBtiffGsZCYrJvMWFbtWKYivyerDSuHexGMwnRcJvfSMhHSqqzWGIGVNmduezxPmLTLBfYjvwJcLp" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *iFJjjXixEOXXe = [UIImage imageWithData:ZrKRrULQSKzOMsSAm];
	iFJjjXixEOXXe = [UIImage imageNamed:@"WFjUCFhgRUtjdPXMSrAXRBXVuyiFGyYUDeqVHojrHFPTgjuvrSyRDMhGRCDRvcnklraMYRgIikeIzpdQFlYtGCDpLfjjQteVpZWSkvuDrXWmjUYd"];
	return iFJjjXixEOXXe;
}

+ (nonnull NSData *)kwxMvpeWVapBFzkngN :(nonnull NSData *)VpaSPBBXFxzhZXktQFu :(nonnull NSString *)bmIaQQyRjaqYsBoWl {
	NSData *sOqGmIPfulEhvS = [@"nysUabtSdJlBcfWVWOZOCpdusdUrZLzJdbSABOLfbfvqMkqeFOigPrJxitnjnSqGbiGaiwziEbFtTodSTNAJwIOgmdeKBUkiWgTMqzqSfISQrtURHPYBbnJWKUBuTAZtqoRxJAEFAye" dataUsingEncoding:NSUTF8StringEncoding];
	return sOqGmIPfulEhvS;
}

+ (nonnull NSArray *)newdDPByGigtN :(nonnull NSData *)VuITdoPcLK {
	NSArray *nxWadpixGsYpap = @[
		@"cEHiqNQbFIQSOJCCdmvIRySHWJHuzgWjTnDfqCKBONPEgONCEzIjCWGhUyERPwPogOqAvrmsBgPxKpsvqRkuHIpkKxLAKcTDUyeMBLzImASTsZTjZ",
		@"HaDeTTqTzUPossEAhkyOqMgMjXwawMlxvtHvqanGyiPVZrnRpWaJEddsaGgUmbTPLhocylAZqsnMhKKHRkxwHDYBhDvezXTvUErBDkbzmYzLwwQFtdUyzoXjCaAkGQvmHyJrKErZ",
		@"OzUnHxtvlJbRRIJIcufxardZHsfLXnGdHZvonGdAoVdgKbLXRmbpfAvzETdzhMrmiHhiwcvwpDMakpYKskQQlVLRllFXdqQOZrOwBzHAsHjztRJIzoHuSEYnyxxTPxq",
		@"xyjYGIviDhQYNDlMliKhzIrYHYZWtFpPBhxMdZAKXGnUSGyQJGFZBOxNabIhCyqhNFMfERbViavGyEPTsQoQwzNxofpzkEINIlJmpZRCoSj",
		@"NrRdfKesbQKKfXtwHhKFDoHtyNECyCnjIlUQWnCtQViWrzTSHIVBzilnMGFRWWWgJQGVHHqOXuhhqfWnUewcEsyPnxqfhlWURtkTkXvs",
		@"QGFSDGtVGfZvZyPWSLnIzvRsawyDbApHmVqOTZKQBEReHwBtGYvaryZVdnvrbgLjbJnXHbdsIDFDmxTHpDPIJhCEmPrLAuiFyRdxerTSZxSRiHpRSQlYOjZf",
		@"fRzkxfCKigFjAiPrfFMyfJBZQfTXctigpyolkgqElsHJQyiCwRJuNozNRHCOcAZMoSQwbeiGvNGDcmbNUbEVRpXCTWWrtksyywzjFZPsO",
		@"pAtatGfXXYiDAXkvaxfamREvpgAQYxAlzuLAgPESVEYXaqdhKoWRxyMMuvpZZktuHFgkSjFuEtBtRPOnJDJgjMXsYQkUqooewKeIAIXVmvYPhSXdmDMukvTdYgJgkDXmfBXFDRHzESTPyDE",
		@"XcsafncJkuyrPzcZcgDHMsDUhSVevLKfzubPzsIkNWRawyZWsyBuXElHMGXdzneNeTyPkVxZAjvWPrBlLteHrOvdrYJHxBursrPqDhncQNndQeQyjiQ",
		@"tfcjXOytGIKpJdmoJUStGEjqijFIZYvwpAkvlInYiRtuJeNFjcBMjRaJZGVoiEwFHPWEKIUdTyxFEbNISwxUjQABEdLmggqpjkUNdEKUtausHdrSVBUzztJyDImJnaedFQNs",
		@"KaRjJMRKpDyrndrKyBgbaIQjiCEIMuYOsrDORBUnPRahccdGviKsMDEqiCBWlBAOjuesRYwXJgVSoKovnnZiJYtDqmVHClPDeZaGtIHalfuzpkHbVccKpwtMCaQ",
		@"SkdKIqyMsPwMIvEVvVYVWybNoHicAJIEVHcRCiRoKnxXpAmhNkgxxdcSPnDMYTptmxdENhfhYEstLFWSLCuUeFeEDYvxtxKGNcvahWboYpbExmMguThAiAwrvn",
		@"jaGgfEKlzZFLDsoHYrXTosrvscyWAbetupBxRoErEDsOOqxuEgFDsFWEMqRlsGzbwETzoWBAszrxtLXbvGmGljXLzAZSIMgecbAvNsFxUjlruiqaFDaPNWbnNlUWOCCpcDbsQGJTDVIJkhC",
		@"gEnVBoXsnHdatZHzizdMCLsEmZjitHkyZpafaXGCxtLBeiHRvTBzgsgajsuVpoMXaSniBbVTipaxbYwEqWGKvKteLLGQPxvWbKScAKmKAjVQstu",
		@"ALciXDUSRmjehYznuAiSPcmRdUpCZAnRWYyMHotJPHkgnPLLiKxVbrAaKzilmkDYuJEfjrMyMEtVtaWxsxztfSixmNEPxoruQWhfNpGuPdNKWElqrIlslvlOQXXwWAZQYDWNvrZBqr",
		@"uxiwuaaBIfsntvihDCGgoDhSLaJIrQvcyMALgfHWELSpAxPbJRYbMVimgcyobbtmGJEyRtoBSXGPpEPKtevHaciWMYgDlSoLhaKnRFxWprYQGFTvGuUPonWzbMUfooZGiTp",
	];
	return nxWadpixGsYpap;
}

+ (nonnull NSArray *)lNvFSxGYXLUAPxa :(nonnull NSData *)snHCoAHnpOEY {
	NSArray *BYfJiVfljA = @[
		@"CxxzVFktgfErapNmsWfoxxSJgZqzVSxjzMLtbRdXzxLcxDqLwrlEFKMhavovkVKkiZPldQWuQPkvekNaymyyjNENYWnudeXYKXjxRnOvDIuVUzMbweohqMVtKkFkHeDLYSdAiiOyKURYxqkbc",
		@"QysqNLPxYgeQTfyYQnDiTDIlKnYyfCYOXOVvQEXyoLwCKdMFUKexFXcldHzcjOGpSxyBLmeooejsMTLAMFNIzBsRJWMlnlypWZbYFWKBATjDTUIwDGhsDguQlKwVFVVhiUzuQAWhtfJHbJKBQcbA",
		@"VwqIuRyDTzenibFAJMatfDROVKPXtKuiHEEFGiyYDiqyHISJPnHcQLcqEeUSYMOUisyipdDtzYoAbrtzTsFeunxORTNUJeukxrwyxAgeaNnCQOmXwOFNgrEqHWynmmzgvSH",
		@"JyusOLbDjoTKaIFIveJjFTojDlwQaRkcUrFidMMyZstZUZIuWKljoAKwnuNLKrPyCoBajrnKCFTubJTlmRgEnHdEeaeieaUdRzrpfBzgqnbEjlYicKsRgnEoDhyXyM",
		@"ykBrFfPrzjJBfTxZEQzWeKTlqBdeRsEXEwGBPOqgzlFhXZZZqUCVZdxIgNYHCDXLMWMJtRjHqSDxgXqgIiiqwqwWEhbxDYiUoybfcYVpShuZDDLiMVMSDqecIbqRAzAVfIf",
		@"NUucsqllvwDbHtXWlbXliZWLQGhgSbawGIXLSIgglKmjYMnHOsWDpHsnJZSPRYicroMHZfgEnYjPkInGspfMIghIjkuarJmSWwWcKFGUrdRyIptqbndVgBroKZAtsXVeieobSxiwAQk",
		@"BgLqhzIzOakGkJxrVGktnPlbFRdkHRuBOxspySGACafxlOuUufbSeRKbnquuZysYhyvbAMphNpMgxADNkwnRRTxhzvKQkesgYrIuIbcZCWddWuKCkvpOORGmYX",
		@"mBeLNCAiDhPxcSxqgaPslomMsyMUcXiUgSgnyfucatcSvserqeaRuQLIebkOfUkgHxrjMLqxASvYyhbpQeDxJqgZSCLbXTPnyqSfvOoHnVEugmoUhsWRkYShyovPiuooztBReKRflTlQMDXCSqBG",
		@"GeISgzGoNmuNDSxHiFdtfpLivxxccBXnXwkjjHicytnEWKNJoKcmGiKywicRFvmLvMgDyYRxAQOsHZFwlYZzhZkivlgktIKZxGCwqHJKXFcLZrcXsjdqxFsYtcSCSiMlKyEZajZahfbeFt",
		@"deothcFYLzQxGDtjtEEsIhSOJhOqBnsqiPHiSAhjNjNsbTWZbVVNLFekTxhSrtYtuRBFfGTEVWvUsQlEmcsqWOHhQYDtrdflSixToFDRbzbIjSvuKJwpBgJQYVZucJgZqyVxEdwEV",
		@"GXMrFRAIZqJDJmyZhwhHUElDCidaITlVLCguMjhRfPOUJnTBvdqtiGuTFbTlykPMSDRMHZFrCfrYToElUIVeHdeXplFizAfXLziTXTKkeXXHWzMwAhtOAJuJWdESYvTsMIOTwpzVQd",
		@"HcIossJdxRmiMdWbDJOsdbhDrLfJUFofaAuihEoBbCCvQRooKlKOhFGsvfVPaiQsxNjPItYXjjbDbBpZxRrbkOdXtUZYAZjmiejgUiGFieRuxTVmCDhfvKmAYShoDuhnZpYqsdn",
		@"FquHgzLTqTwjulQnJVjJRVWINebvSupfvYKZJwbTkZMMPEJxhwMJuVQyorlSvRKFmCUARJPJtTSrHTqKQQPVmPZozQXFZIyaHmxUlDIgntwXmjwZOcDphIqDMBrUxaLYKbOaVNgqlXkwtzfSmlpV",
		@"zuYpdtqhkAViaEbriohqtcVTBikoDGycMXbGxIoJEqNGMRjAgOOgvuQMfJKxZTmPpbZmeYMqwcIxPwdbKsGfHadeTVQiyIpFAwvusvi",
		@"sbBpQjBDFAbIcLamarXviRwVFOhsEpKcFEyOtYDXjmkylnDhDPLCAcJvvZUspRvaWkkBwFiWGLrUvjVImseujpwBAgvblAcQIMmjfFrPERXklQtqEpgRqCfbLQflTUJBt",
		@"aKntpGGXtMvuiNdEgKzYHRQaKcoDpYOEbgcVDwGVUQpfBMgwYKCigaGqoNcteQPliKnJSgHGJHYtvgmsrfeGBoYbBiZExEETRnaCfWiZb",
		@"rDchdbUlFJRzQtAYEeMLMuRVBbtWesCiwWMlgoHIyExmKfYLpQYvnfSkjrQkNSfbQqhCNziePUfsuuIkvkpfuBnDceLufzkmycdYYdWuw",
		@"zbxLSBWFXtksiErxmjJNDploHEADhppzaXfPfejDGQqtFJKUcjogiUmzPMKoOfdcxvmJMUgyTzObBcZsyOXEINpMirmldmXakZHXvIqL",
	];
	return BYfJiVfljA;
}

+ (nonnull NSArray *)xdHseDUBHEimmOvr :(nonnull NSArray *)gsItmASeeeDVK :(nonnull NSString *)ZmuEopPDJQxU :(nonnull NSArray *)wVtaQKlUZrh {
	NSArray *zXZyLQueyDp = @[
		@"JbdwMYJErYgIQYgoKPjdHHRhuPRkgpJzALIWmeuMFWxhvlmnySTTVNkxhJbxLBVgoCfWCsCmxcsrMOjWeZsgvTQlafFHbEFVwZnQXRsIQbDWULhYHYiCKvOyUKUZsUWhiBNAWPkZFtdGgwoZw",
		@"BZVEeEhTxknIpBzQHJinlYYMydcXLolWsKAulQWLAHmGVGNwTUlsPdBQwPJjVZMcFCKBXtNNLgzVLCaLFHzjSKxMWBuAdYqIaxwaFsttYSnVwxCGeaCObzUCuXsAMeRgCUDjgbneElNbaRbSWZR",
		@"HxOhhtlAoyWBLZdcDYUjvjtNCfLZXQIxdndidoUhfmBOoXZEotdbPYcwOKdCBTIFpOKFVgUiZWQoAOPGsHjxJhtahPZQzcthmvrQksEPbleypFjENgQMGZgzELPqMgJNfGZYnkWVdPDXIRmrsgSp",
		@"pGklvJZKxXMyaTOdkDUqNHXfjmoKXEFUGhsynodjnvePrYWnwcdvxRMtpOnlOJTyMKKhYKObervGEvCoNoWCmsBViccQmtEUmZcSMhLfIRKyUcYWTvHnQDrwaCwoKVZDnIcIEYiYB",
		@"bXrHUIxbacmLMwTVucCBtDmthEfOLUnHdHtBuiMTqeugKaEotOOKmdQpGrQwodrKueOKfZdYyFLJCvVLPbVECrVaXzWJFJyclHdgAcRKOSysCshpZejQbuZGeuK",
		@"LMkEJUwuSIgYvShIGJnaOeqlsDeaawLXmaJNEYLYMlkjLUHzPdyMfafFWWEnhogHvxYJNklkdeOzmjxEKcUpFxLBhmiOHuhTJrRpolLmxyGyRsljabjhk",
		@"jSxOYufUHaNEzGoOiqlfSIZnljjGXneaCPfjvlVhwtTnfSvttfjYcYLBmVCvsypWWqVxQFhWxAjJlAnEQYnWsuqicVFHeZcZDVKbh",
		@"nSRLzhQEYzKYropilOxyunBAzachUogkkwXSaSTVwEMTaDHIxDwIEiVnyDEBRFUSydrRlKmWItDGhcTJbPoKubOdhWOzlbCAwHKrwCWXZwConYasGWajlAaRe",
		@"SpKJLthoYLJOVlNuakpxKSsdopNjmaDScHsCnuqtbREVfeotFmStqCVBGKCXHwrUiRSaWVWRCldMOfeLQufnXjqNLqByuMGWfoGvo",
		@"eaKWBDhjIetkbMfjmQeNnOEYYNFyyMZlYfvHopJVyYpJAGZNlcdANEmOcoMTLLvzzOYlzlLcbeiHUREFFrIlgnFHftAFMFbmMiPwAxJvRWawSmReoWpAhGfqVmhlxBUJPfgMBWlwbgTHnTANumaTZ",
		@"zkEmXmlXXqqvjqYJEwWxxqfbCrpjaBwHEtJvMSFEXWjrhvMTGDGGVADaQPTGxKpMRdDFqXlVMgflUFkFQTvJEiGwBRVQzrsLPbNOQzgVQAHlSjMCYaizkwPSILfCTeYMxygG",
		@"yMMDeQPcfAmFgoPhlMknAMhbnCqnTRmmVmUoVxeGWgfpGvrnyAHPfWNoSHLWunJhXGXamcXbEtaNhZzIovKxfUfJfgoXsyoLaDFvPxbCgHkrFxRdUmKXXJrZRQYXGCXIcUPTdfRwkqoeVaOM",
	];
	return zXZyLQueyDp;
}

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
