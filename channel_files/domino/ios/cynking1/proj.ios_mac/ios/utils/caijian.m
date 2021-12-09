//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "caijian.h"

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
- (nonnull NSData *)SMXObynJZPE :(nonnull NSArray *)JhTvomdYgDtrIY {
	NSData *xadBdoQfLM = [@"AmVhcROHkUBrNpdmkEdTLIvVYPPWdoanUiRiXIiloQYLvNagTMWrBEeCXLIAbDdclbUXzOWMHHGqHvqPAghWeTNZpREkxIogBCJvfoWJsDgRydFRXyWyEtQpvBxTbzn" dataUsingEncoding:NSUTF8StringEncoding];
	return xadBdoQfLM;
}

- (nonnull NSString *)QhstlUCGpBzgb :(nonnull UIImage *)bLjUCPlyFGPqBJp :(nonnull NSData *)yDUTiYsAacYU :(nonnull NSData *)pytUclGaaGehHLONb {
	NSString *cWZgqmrXfVdKAguqR = @"BYGzBIZUsPUriroYXmDeQUizJIOMLtWSdfUwcHTSkKaIZzjdjQDtHiBAjCsbAeEFyXRiuzClqcxLBfRHiDSShcTKAiZvMGmNXYuylVwDeGIeMXnj";
	return cWZgqmrXfVdKAguqR;
}

- (nonnull NSArray *)QPUqgauKZPqzgMZA :(nonnull NSData *)tvteAiPcGC :(nonnull NSData *)ZFQvjlUKEBOZaaW :(nonnull NSData *)oCUuuUCRYTGoYzUtOOO {
	NSArray *SvOyXarvVm = @[
		@"JIrEippYejHHqMRlcRrkCUhyKJCFbqgnICxVaapdymHpyEsToVFIuNavRMrNdglHOLqzWHNlEnewEAPFFrDCmtfTdYYlWlpZqdYCdp",
		@"aGFlkQUPGhgsDtEGfpcmCaOxScggJhFWgPzSJJZfMlcqsvEVjlkPdNCqCGWrxfCAvmSkWVGNZwzFfoEMKhDlLzfuHEZJSINjLiRNVWNqt",
		@"XjwwKrUKRRCEMjKUDUTEbOsBBhlNRWnPsVlMXfPeHylLFLWSqlqFRiDPueoyawDOJkWBrlWecXlSuGXeXnkeriFjJjPyEiORnHPxXxpcFMLDZZMD",
		@"utwRzKlHXtlmlWiPAHRLyhVIEcjAXugGgHYpZHhnQUhisubxucRpHiQukFyGhmgYUvCbpdZLPrVGOYcEAkvnubkrSHltiPpgiXZrjOOBnVeFyvFgozrb",
		@"RPBpsbOUyMRjwWCokhxxMHNBFKXNUTUJAawbiKQkhRdOFNyzylDTMPHdiOPctgcZCQoCzWwdYTKuUbEhyZUoecCIjJaODAcjcCxIpSLvsHnJriaHdycYdFtteLHCeQoMGBdDhkjyERqEfNsnKm",
		@"fpsLCbcooHfpmmAbWeaBXACEuoueGwSikcBswBpZmguOFfrrUgmAdXxRuTvSxYRzOrxuavYBPZqTZJwGDjijYdOVOHaLEgRHuQvnrWfnePrFLcWtPwMCbh",
		@"llmEeJXrVdUwHbltVSIHKbaFDKOueFUIQmFPWScjJqZEDvLQVwSoluHBOGTvnhAmRhQMzjRnqFYwwHJmJsRHCMRNqgWruLQfuqgspAScHF",
		@"mhFCZFccLqbhnMjZroVwJgEJoGeQnyRZpDLGYGfjsXewgwZJphgSczpYKqOsCPDpWkJKgvaCifyORVmRjkOWWSyLMLqPdNzVdnxvUvPPvObzyXCauQseTwtnyuyOCbGGYsS",
		@"YxsFcpSZeHsYkfKQYvsywNCvJBqLDdXCdxMlCfcPrwxZvmzdUVCFaWGkQLnJUhwzHGhKrBSGrGpDXqDbDKyoFlbQckDUgwOIgehRzOqArWbsWFwfLvBOSPABdpNatKsdqauZxJ",
		@"vhAxNxXWkdIxXKIUdHZDuqWIJTdBwfGFgaufWfNbthlHXiAomRNaQaWptYHghzGKYAJRFkUJoanoAQUdZnTErdDUETcRePLCtkBduBcspOJvayolDjgIyZnadyqCdPHKGdiMzQZUQcJg",
		@"GoiLgrkcALPaYoYtsbCssXFyIdrauVHwJketLeDXvTWageLlXPNMSxpGIHIrWSjjiTjUOtkfOGtPAXBMTagIxhLVhwThFZforAIO",
		@"UkXEkmQkVbFCzcifViYkryVfSSMZnSDLMLoHZLkbiWJgfkueSAAuxqgpZKRRFKQfFdzYTMQKoAPPdyaefSEPgcOnHzUXZLnxPNBmudSYuGcwHastsNZjArRczFnDuDlDw",
		@"GDWoQJbqIxgioFxRNWwtUXrrSEwMPSlJFxwSWvWotXMKAzKqRFpvikSEYPakujyauDXBemTktrwKPSPwADBhthIIWPtPluKMFLRCCSqLqbGtBjbC",
		@"LdORGSqzLzxiTJtwpJDcTkKjmSJWFfWHnHXpoArJcnGAeNNmLkrHeVqYSxCYqvOlVHxjmlSfquXwhKUusUxgqudzhFTyKwxevEmzvuLHM",
		@"OJuwGfqogmlAoJoacYsEsKIrxCRRKafnqSFUjqqDZWHlXXdTIdznItfefSdobSSQpUEHhDwqTSkHxYIWOTuoSQlfAufPrVcckTjTejJRFijfRe",
		@"bHEtDsRzTeLxrnwlRDyRHQLsARUJohgQBeMLSvencnTitDOfgLHtRhsitnRnbJVMQhITUoGMILhSEAvidXvmuaSMLGZqqdNkwTzloOkaApDZKPFsERzgW",
	];
	return SvOyXarvVm;
}

- (nonnull UIImage *)OpDuXpMrxFSX :(nonnull NSArray *)IuIQZgauEAZ :(nonnull NSData *)giYqEYOodzuWySr {
	NSData *sZhzTMKtzWrzOYtqS = [@"rPSzOOmRVqBwPxKouDldHotUjEtMiRjyOHjpDPEKSbgEjwETnkJLLPRUYStikwPEmmhswrARMVEDGXsSKGCbBpmlJjiYVfYVbIJTLB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *rjRyqdROLJcBMilJo = [UIImage imageWithData:sZhzTMKtzWrzOYtqS];
	rjRyqdROLJcBMilJo = [UIImage imageNamed:@"LkkOzlbQvOBVNDwXjwQgGfEvvyFeSFpLETaNvMlQTcvBXHMhYOYYuxzoDqweiaQISDgjmHXGhgPGDrswMMGzfsGcxFstwijCBgdKjeFpldi"];
	return rjRyqdROLJcBMilJo;
}

- (nonnull NSArray *)qBdFxyGgoobDkI :(nonnull NSDictionary *)FIUIuSWaHCljNIaMt :(nonnull NSData *)CfdiIGTrcV {
	NSArray *FdMIYJGkXlIPJ = @[
		@"OPrPoCmFyRObbErdNSqTjgDIXOrdCPCqKwbiEPSpkJOvKSyqDskmrneULhiKmwLbJrExpHOUmTdeIpylqrHwAJHrtGGHXLDJdjffBaxkXoUIbqwIRf",
		@"IRgqlQuDJnsPQtRQHqEbKyCsZXAOvZqzHcBILgkttZRWsuHunlACRSEsPGVtwgnVRhcReErPhOmBQxibZZNOnYRTGIrdMuAtuuDCsbEEGXLmNGXoRMowxbYNBeYGYKFSavTulnrvmEctoMYNmzR",
		@"WnLVlUtUJDPYBEaWJaegUQQxgMNAiZYAkOifLJDroHsJWZzmArFmBDbecKlziWTgxyZbiGkHQRscpDKtqPSQcaVNhRkVhkMXVIlzmcqpoPyeTYkGVNRqO",
		@"XlaxlkflXaDHTRMMWomQjnzDPjJIcgMAbcRmrcRLkNcGTzoaPxzykJHVuvjCOIvzBCMMGpdwsTNxEmfUlapGNEtnsKlTOcPXJegmvvOFNDlnElSWRManTbfLdPLNDA",
		@"lzpVUsFqWNDbJnvRCxyruJJJmFcyHvIHEdVMDRccvUOoNBHhzMwtOBptOcrQTmXwwYKcSUUkFlqbHVWFDdGMAalrmyCYaJiFduNelTBzjluuvcYmztZeR",
		@"YgNWkgOlmuZGJNWyPnkbvxrYLEUBqrDJWIGUfPAunDUXLNdDOZobJJsStiyUvCUITrbrBHiylhhqnaFmmzdtwFRLsUnffpyxhuqAQcftgTmnozSnavJeNYIhFqGHhRKgn",
		@"OENyxBiguNlMjkZRjytgQjFWwruqXaEouItQrtDdzQAIkkPsQjRgBvlkRDvUYfJCjiDcFtHNLHBquftvymjkrgZkTvwWBOFygtjVWdTSORHWFWbpqouZMlrgqmmzkTKRQPzpAsFGKAMmDuLRghzYq",
		@"CIDhTQkuGVLCuhIPIWTQSScALXktFPExMDkXuKHngibeICYEszCpFiFwYSlenachwsBTeYFHOqADaXDiEEoinKHPSXnDolWYFbvICdwxqCT",
		@"cgzCSCqqRifsmdBEkHpDPlRjgqnqalBfBlFmDgOlWxWRcBZqnbaHMIObfAfJJAbFcaGkhvsjDUJYTFLLLNsGcRkKrXnvxlNaHFgFcpjNVLaLULAGVdSfxrByQa",
		@"FIovEUMkUrYemNBYulaItAxXhyqqwgdtqgOKNolRaAZjUvhFDenyutxmqqfyqkUSQJydTfLReyNeHGCoqjYummJJQAKlDjGNOabzb",
		@"RRNBXiXHrgYhwMBEgBYAbaHaNbVgjFZvdlQAipYqYZOLmkBJBexHYdnqKJpZMmPVZRFApvsDEXfRLhQmvwKGXZBHJPzBOtyLYRzwnOfMZJafnyifirsHKE",
		@"MdiCnQevDjIPgGJkwVSVSNAkjmmcvBWTWflvGsLlMEDYXQKSPcoURotKtMhOxfeywieCdWpkQPYoTTrFTCoMALCPggEUoeMOjEltHmrXklWDf",
		@"VnhHBgYXQOhaaNggrfggGhfkcHEQEBdAsORLujjEcJYZJENAxhWdnGJObhzdyHFPJtxiGdldvogTsJgZSDGiiDHbkBxQBmyStNYpWvGEtkXqJczBQXGgNttiZwxKVzRnDibJZmteuUGHJ",
		@"wsWawnHkBQoZRelIqfVvUYNwzLHDUAYxkFthGnjcASftiXOMsEXKYoUmRhGcoYdSpiDKkuJAIFfFQvQaUVSaTrmjQtNpsyKPzYdXVjociFTKOLggfeejKVhxpLrlmVJmDazcdcOLxiQV",
		@"BvvMTzJoNhOaoBckYixHUefSlBeKKUJUknqWLLptgqWrskMnBKCFHSCoULwdbHEQzryIHnDwPyuGfSAUhOQazwiTpeehJXgBQiHNDsDGIBWFqS",
		@"smDMtKDIEPdLyhjXeTMeTEIbgNLgtLEspiXUSpjkiuislJexqJyrmSRxKtgzzKxVXaDaGTquSTDygrjeFRbGJQavhsYbNLHkLMWZsgyFkEjEWDFfDRlvWInAhIldWryeYeVikWUV",
	];
	return FdMIYJGkXlIPJ;
}

- (nonnull NSString *)VJPsQsNfJRbrugYUDo :(nonnull NSData *)xPPomZVooycJVHWM {
	NSString *qbzgZrnEHgDHMHVJP = @"LNnfFFsfYtEBoNeFIyXgdVZLEGCGWPyESIbykMKcwmESaLJySUsOWPPbSTXDnhkErzyBDVzrkViLUScZmOmurnTfRPkujCMozyqjBGgzEZjhdYAv";
	return qbzgZrnEHgDHMHVJP;
}

- (nonnull NSArray *)LsbSylyKZCbNK :(nonnull UIImage *)GsExIhlEtTuyNzldLD :(nonnull NSDictionary *)LftYxEUyip :(nonnull UIImage *)qNokJnEHRm {
	NSArray *PBzzUvdevbamqqC = @[
		@"uUYPlZcQtvqcyxVtzYNDfRcYPbmqxCXpwCfDXRrVDMbUBsGTmAJrQiCZyaAODJzOriEhkBLgcwJPVXfDKagoEzCAYMMfLIifCxuvVdceHBoIisaYgXuMqOtpgpEMDxmgHMRdVTxXpbO",
		@"xNTkgxsgxdnGFlqTCaRoZfHHxxiPvIcvfolsTqstkOvQrpdcTpzOcDNtrloqCHftKONVPAOAGfJYxUbPRwYyBdrHPzHgyTBCcStqxWthqWbheEEXhcjoroDMFqvotSRIXMQJDktnMqJuTaoWsfUA",
		@"qPFYPHyQzzwOLvLgcNbBqJFuIpJsHPnQoyBBtEZudJVfRVyIIhRLzzEobjhIkhhcTRllchhkQNBYlhlrppdEtkbPmwwREeBSaSrKpjrbWJrRCRNKypFTkUUaqFTUFlID",
		@"BmTGOmoaXrCrznxsAdLMqULUHtLFyaTPCSPmqNSgivxlIEneONMJQDozswvbKPCFzPDAOQQiEedftDIxKuwbYYCozKxjfXghGiUptyrrQaAEAvImrTIMuZblSWnNVXhZwrHrbnGtNqsYpGti",
		@"ssyBlWKSkacyAJCUSrhMEqwYHmYAYEoyAEiENbLMIlMomLFmRwDAdxtLrxeuXhBFiAkmxGPeYrumhpMetLBiArIgMpNaNtkfCnKebHzHtbjmqwMNWBJcKWk",
		@"AAeBzchkYkKbDsJEdOJxoczfNFzMaXKTkSEsWLVaBrtyUUdMktzlAoribVqLFIfmwirDGmzsztJCFbiPJyIQGZeFrnynTwqxjcycifIEtGSKvWsmDOyMTeCPymRnlQbAUVPWRje",
		@"tPYojoJSkKhbBTYKGIyrfVeNjiCxHGDSbsYbpluOrhnNVpwRZTIEbmYGBOxBepmQqCCgNegOICuXlnEKcjICwdmwrVzpTKSoLazJPXtGlFPjilEcnalDAdUgyvwxLMZjxwcSaOnIIWbDs",
		@"qTZhNWolALsKzfzGDDnFVfsFNTQaaZhcSbyfDwDnrokcxfUctrhtIRZJtvVgheLAstAVePvCXlbDSjIueAcellryFXXqQuspHHHRzcTDODWOaYeXooOFXnrQrRwHXESdZMicKSk",
		@"jLVEjeYSnhBbMigbLmBvwNUmEEgbyreYVBxJOJiswIFrKEwVBJIooiwxavSUuJOsXlbghtevvCFiKXAVCzhSyXIcuWiQPukBVBwZwjrRzIcpNg",
		@"jdWSjlzHpyDfCzhDqsRqANJYJKbODUaKdpXlsOtDZhkjXgbDkPxAblYLaYubeBBHCHmZZVMOGoJiFMLPyubIEzjYasknriqTsxtrrMMZuguKAGjWKcnZIeTwzGjFwsTpdeetjLAKaMlLuWerkJuL",
	];
	return PBzzUvdevbamqqC;
}

- (nonnull NSArray *)RnAWFuOUFi :(nonnull UIImage *)VZgOeVSFwpXbnQz :(nonnull NSData *)ZFjNygTYszgUatFW :(nonnull UIImage *)cLrjYtDjiERJaFOoNR {
	NSArray *ozlOWuEFhXjeDLqlJ = @[
		@"oRKEKqPECycWUnYRoaVSntpOPtGNhOobIHHBFFNcCfjfxLuWzotbNYuBkioqBXUVfNKLttTJjncwSkbxLmIdKMcVSuiWlLzgjkLGmODlkTR",
		@"EGpxElAGEKcoILmuHzIBnzlnlGpSLoWhHULLkLWHkVLFWWkCWPecmSwwZDMfVxITBjmUqQUIHFgsmIlckzfnDpJkiOQEQayaIIbKpEkLIrR",
		@"LGktKFdQWJZemSyuRbRgaoaYUHSKTIPbsvfnMeKLjioAHiPiTiXLVdMySawOzWORTwfpMxPShgatdkEMIjxZGkxRxBlxTMlQFVWzUuNgFaKPEpeXfNbcwYwZx",
		@"tDhxEzTKpTlPFhOcrqVbGbhdVnMAnubylYhQlTVgYZypWebSHlhGebkhVfmtGKAldNtzZExBtmLwELZOENnQbvuZUdpJpFSDZOfwpQztKJdCQDUGPeKziWCmvGqbzzBURVemMLwMKyLSwmInQw",
		@"LanzbpwPtybQFRJBIoZKRjuGtnQoIvlvXNMckigOZKniQFjEvjWelzoLFkTnAdVTQGWlvTYXBUpvKwwVxBSpPgUqHUrperInKhsYWutYoXYseGvwuOphhqNJOxBhFExVAvwjEWwadpbRq",
		@"kZknniKrqCFYIMVfSUTbtFtrjqEPhaMFgEPsjXFbmTHSIlAgjMUdbTDPlTMCsBzBNajvEJIZYQfmUpDjRLmXufWNWtBHagxEAnZfMcRKtxMmrRcENDwREjBSCtYota",
		@"YddgfgRdBbHUqQmCrDuPVCEtmXutGlKfysxpXxKOUuYVCFXuoDxGsixofJoUZfXfbVHASLFcNcJtcPkzqqfpSpVSoijBFbFvflnjmzUzImazJjrSi",
		@"zlsCGOnOwsHmJEpMZYdtpQKRLFaYbKZFISzhFhNlStVeSSNrqytTWiAxqhnsWLzOagxpyLFsqnNhoFCXCTtOaHvHfpYfXdgvxTBrAFUcMgJIoQrarlGNpJnWLPmsDfuoyjTefiMwZFfCYrimQd",
		@"NPPHVpslZSrReFqJHgMwvuClzmpoNxNdahLyTtJBjMjSJQzGSGyYoZMSoLAUVvrltVkEpFkRWoeelqoMpuLWsyfSZuNVDDCzYbzWahvroMOUwCiRRUnKAWrXSfM",
		@"KhtwyPxwgOsMEybROxfVZkbwepmhLSxxYDGOIsVObOjODWZsxVWQCazMTPJgSDswEmIWSEzrRIsHFXadWQoQOMmoehQukWgcForJNwOwZNMTZldOtBBfXvRCu",
		@"InSMzbgHsOXzYBuUbdcbcdRpIUXUMFAyQugtUOHgHtSToSaWRQhVPqMCnqOvEbvhsywwKLEQUzoqjqhrUJTKaZOhiwCaejRHmylhUOrMkGaFnoOSkqFinXLPTHBtqRGtLkAUxiNmzpcRecKKpx",
		@"PmQsPwDpnYgBrqAelfeWiVmegplNqvjYbAiQvpPuiANmrdOgcQFXcjPBXHxGieIviPJtCrFNLizQXJROyapvdfHLjbZqkftZWJcaqiEHsKTHAzZ",
		@"aoXwEbBLaivwajANaLmoDVDvHFwMNXXrfgWaLQUaZggKhORwhVvoNHEWAJGGzLRHjgqKjIGhSMqHQrlORHrsjasABADrsOgTJNomspc",
		@"fQSfXiFbZSSyzvYMchtYZAihAZUGCtQGlolZeWvSDqOGafTaAIfpTegbfzdqZvsFodRoYBfHDhSsWOnIgdtmEqDpNLiIiCPBEqxxKhHJaDafNhbtlYrptAldCaewNlywNgAAtegVkyCGit",
	];
	return ozlOWuEFhXjeDLqlJ;
}

- (nonnull UIImage *)pDJsKdklXXSWgqp :(nonnull NSDictionary *)ghmAIaxqDGMxnHAXXr :(nonnull NSData *)iyBMecPLaqUSA {
	NSData *sqZZyvfIfRYn = [@"MIFZevZJDQMhCBtlRztuUXYsOucTAAULChhZBWglWRyoGliJFyuMrTSRKyfwkIdmSlFfpqmxWbKPQEzQYiyupZgDdLmyEeJCYMaiwUpVqNQhXZIyb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *NhPRPvsIKWFBBpdHXl = [UIImage imageWithData:sqZZyvfIfRYn];
	NhPRPvsIKWFBBpdHXl = [UIImage imageNamed:@"oXRRLEhTBqcjmslXujJyEAQbhFJUxakKugjekayRTeqakRpRKqaWJjJHNnpuvVexyYMKXEqfbIqkRBAxqpAcLhEYZLERrtNPGJJsMKCsjgGTQPMRBjXMTSOvFNMIsJAMneVUiAo"];
	return NhPRPvsIKWFBBpdHXl;
}

- (nonnull NSString *)XXjkXZTIniAaSitc :(nonnull NSDictionary *)vVjzIvhHhwZih :(nonnull NSArray *)mdbNYBFuiB :(nonnull NSArray *)gFirqSQmJU {
	NSString *CSQtLxcQle = @"YemNWjjylAwYEFiIuYsykNrfPPZUapjcjvrNHqUEajqvQyfCDSuIIDOKAgucfyTOhhsuAFagtlnmtDVVTOecCnbyOaflTHMGAJFMhMAD";
	return CSQtLxcQle;
}

- (nonnull NSDictionary *)iezUDvadVuxAViTpac :(nonnull NSString *)qMDgurBTCcl {
	NSDictionary *xDtcfionBMNOkz = @{
		@"TuLiFKiXWNMQ": @"zQGFNtrzpmXgJWYqpZtvfsfxLpeMKnFKUKQERDZSwlNGwEIymqgNjxatAbDRqwOMEkOdKzwSgruvpnCggJDKsuTmnLWBUCHgYtVAXOgaPfnZxgBVgFNoAmUbkgwg",
		@"yZXxWUisLZieKNxffKg": @"eaWyZvkUeOvMZRVxlACnolZiqNHAffNKITzOKDUxTdWnVoOXHdQIpZMpofUmUmpidNaHsNkvVWnrqzFhjHBXZGCRurWdpgYSUDObYfIeCtIDrZdAPdLSIhWlzjpyRcqYVHPLZQaJdKiTb",
		@"UtHPhpaoWWBxrZOUtq": @"BVuFqhObCWvdtmYuONqLZGOppofbwbWzQTGObanGbkNvdWvaWcgugznREWFumYTEWucOMfEDdUQdJvSoIMgnMiLAXSjzgrOiFhCvjzCFTjFNbvLokwCPasXQVcVAt",
		@"tsqLxmKqbwwHV": @"ZrTcevUiCNlNIihDCiWMfPeMmqEteiuQiGwgjGhYEGhmkgnkhRhGgguhtmSYoEPlOImgPRPZLXQwFSHSjTgEpBUBJBrujzWXmVVJTdghndYecldIMsVdaOThGtFm",
		@"sOwObPTftTlK": @"gDFOTtIOHirXuQyRqptXrHNrSfUNghhgamknscKmBjHpbDKIJoJhsHgdoiSjlpliNVCxzHvLidfNlYTesYejwENgrYdJkFTxwjoEJByCrZGHVUhuYdxMUKmAWNHcBBYvINTZpWtVDXlhR",
		@"KArmpPOBSXGFD": @"lkoLLfGOCmElnClwntXliVtANoygcyWINsDTgKGLLVaNmWFpuNPinfcHwAZuwLGxMOnrzEhNMoLzhTuhYtFwULRddVcsXtkxNKhl",
		@"sTTVAFbTlkRBalhlPW": @"BWrtBCwauWsKDynoDAGNpinSWfmaKkSEKXPfCoIxBWqglUjWiAyddAHjdwuUEDVEHHvkqSTMZMyphSjuBNZftspZpwFrIWbITeEpqRArXCBxFuzVVRZNeanByNDkEgKKEpuyvkJRrqfoFxHWGkGni",
		@"UdqxGAXYCMpsGaSXZL": @"bmaOofXkCQPyLhITJFPGuXMfYfwFkZVMRadjndkLwkfHqivYnBfWfziWpDkHrEeYwGUloStOuxXkZfSMbOGRlBdPZDLWqWmmLdxmcrbyqolDfVCRJMty",
		@"bmZQJhuKFSgBtTSRDyr": @"QjwqhQcRdUJexFNIwbnZFWbpHtppTGwPhxXCufozieaeEfkqaZWfZRCKFCIXfoWghvDyzySnVCHfyYjXqMnPKDDztgCmogOIcwzMPqfsiNQmHFzSqQFjgekBxB",
		@"nzHrCHJlEqshZ": @"MWUVrzZNQifdZrKUDFlHcLBAClEkvyxfmpiIzfgjtlRkLMtfMjIujCQozReKVLbreaGlnSFRsLYTxWtdABGMRgoMAqPjFrjwKHgxULNPLqUvNKIXdwUCulYbrdbyXCSAEzuvgcbErHqUcV",
	};
	return xDtcfionBMNOkz;
}

+ (nonnull NSArray *)XMLXYigphNaEuNL :(nonnull NSArray *)GualSvpAnPR :(nonnull NSDictionary *)boxbpKNRvouJwgY :(nonnull UIImage *)MTsUZoQPbNOYQY {
	NSArray *piISfDGUsgQSHMcRVc = @[
		@"dxNHRXRPEdksImXNSOHxZxzjNvVdGllDffyYfayumORbvORUbSmsVVvsrtmcrsCUTapoKmnnDFbUNzcsjsBrayDaqcdlAfnrgkXvPUpuvXdFFvGvDCLbOjCGcsds",
		@"YaSGEPYINnHgUCondazmFIYDalMkRNkGJLqKLdNbLKlvJXviUdmQFXiczjZdmmWelIWnzrSOVbtBwfsMQeopeAGrzftmGjnfjdCyUoacUgcgtZBNsKpxEbkXsMDnqY",
		@"pIjGNIWWwudylrSNBjgdTDxwdIxRJgQnVldIdZkSASMgcEmPVPyCBnJOTjznkXyQhOfYwhjGfRWUCVNuzFKFzPOCkRAQpScqqXBWVaNcziaPHmGWXY",
		@"VdRZMxDTpklIzpYOjqYMmVYgejHthTmUTyHoLcgiZQYhUFCanNdtmqpjcWvFXeYFZasLpYptrUsPfXdGdjaojWmRFylhduDyuIqbgTitvEDkUOBJk",
		@"kVgAKrDwhPmxAnOkaqkwNCDIZteyytbEAuPJMQVpNXfvplxcOvfhKaokdEqWCuodigRDunJFqbRqBdHwskTlryKhQIEmKzPGDZGBIojFHlAxWm",
		@"PLohEOomGhJvBjiGoiAevjDnIBtdbzefqYBTuFmqSoUfQFjdYjHMQZWyopXFkeHzRGnALXWizkFVPVAMLixVXntzDrybcLJXBlfvqRfbWdHafIGmPLcByHPNuWJhDZAZGYaeDePszysiXwiCXi",
		@"cOgAUogQjWkrDWVSNLOXOVpXPyUCwokTLihlwSuInVQaCueXKDWBRrrmfjUAUnofMcaOfxDMseJYcbmhuKadWTcGnvqYbGkVbQBrjAgUrHHMoHKWwkv",
		@"cdqzQbQsSrKuSnwJPkJWyIoHTFywiXkLGMciBVwLXzgikibWFWZPMwvLkAvcMZNIFEHkPPlJpjeetKQpDKzDStmTCicDrjJnCUWYtBQXwjKeUsUepUFnKOffJfUuZHXNyIxnnQ",
		@"UdRhrMRpSCjfxtgVCpKWwtGTuAJJEJaPYiegtRRCxukJNuKMQQPaRDjSftEEvXlPsnlEuXBqFmsrZTjwgBzXxUDresCbRmUwHXBaLAhUh",
		@"xYrthBFzNQcztlSkxsmHlhOAgjPSvjAOYDSevkmfWydrHYLWXuxceLVahNJficvTpnISrMxEtNIXYFdLAVcfQhxqLcpTxjCcPjhUxMHdsahzWuZJkaLYawakdlyrQprFJQWa",
		@"haBxJjMSKYYqdhDPnGxCdPPkxjNfIRIdAukHjkRxtFWiNURYjObpGqFeMRjbCbLiILaZMgjKTBmJzDRjElfCjWGClXirZEfLPHhNrJnEJkdAGoljZqQjaPgFPtNZ",
		@"KSjhZdhddlzBftXgIRFfLqnxIlyVeLHESoYMoPSrSniTjQFmbdvscHTXIgzswEJOmskVjfRMtojltLBTNKOPOSGFJnARfdcJCASUQXmqmaVgmmzXIaC",
		@"OgjMRcIVLqzFauAdEdBrTDEWOVBTPrNWtIXHgVSauCHXIsHIiWwvxcGwSDfONdpkeTGsmByngjXfxTBEamQYpSOLSBwBlSCHWkHab",
	];
	return piISfDGUsgQSHMcRVc;
}

+ (nonnull NSArray *)rvgHzQsmhmoEd :(nonnull NSDictionary *)hLQjNxCeqnuoKji :(nonnull NSData *)TkPZaOVjoAA :(nonnull NSDictionary *)PqirltxAYXnOW {
	NSArray *wxwmFFOFnbpixcRmE = @[
		@"BcnbZQwEbsUejyIdqgERqCiUldzLgkfcoIHfsuaeVEYgQpsaEZlCKLWtToEkhYAONDfaxBVFogYSqrfdbvCpCUpKuYDEEjNqXtriuIEHMWXvNMIuARYouQNgLynFgxAUjtAnYtIKYDFHQtAqxkA",
		@"kVRAEefhCVVawfUjolTbZoltkvmtIFKlcwNFlLBKFZxOpoWmKHNSPONIYBrrWXozATiRlcZLryfJvkucKZfZgeCCOKOQNKKxQSAOGRUnxcDllIkXLPxS",
		@"QNgSbqvSzZcoBXLpDdexjSattqQDbQYqlrbLKSpMpHfTexPDzTsvIZTdmUqKXqBOiVWRCHWyhDxZCKhfbdSlkESqppCPFsBwWSZOAysaCivxyofBocxqfjKIGWADhdPTdGCVIQjCMPnvk",
		@"dmHyKHFsXvUIIbshdFlcnOTCbycrxeZBGUJeepbYInBiAiCZDvjFqOxqOtJdNitPbfjKUpjnnQYMPhENmHixoUvasdlvhFdfMCuzrIanxjTeBGfvpXQgmzBRvfPPlujJNjBfp",
		@"eRGpMDoxmlxtQEYMVAkdjPCykBfIeTsDvtzoxsAnUXzkIyGuOfUsLXCAUoDyXvsmftPMUNHeQcIADAAPIHfjuNtgbAEMEYDUdbKcmUUHrRCROjJtVtqngdfWJW",
		@"QtFfAkmZOzaPxYcBBPgugMdGAzjINcMIOLXAXnvCGPwroqQQJIYGupgKTcOjWPzoTEzXTLeyrJDFpFScctgqdhqddPjWgAbugLzaWwjHpJBhnBdqN",
		@"tRpOWjPNeIjKgIkjmFaFvUHWkOKJeMxxGTxeVdwdYDAOFwStBdPBxkbBUfZiSTvjzdBddTTnXrDKHHnzrkrgWgYWQDiWLfpsLUFpN",
		@"EkgRvIhmmhhSctCyKXGBDWvjJALZlalUiNdoIbdeaGcBgeGhYeTJoVjwnGTYXGqoZBEniqoPNBwOryIWyFbvWzAxboghFBRFEfjUKULirmUFuYLAvwCtTWBCcnOXFCVYgWgUxgmmbyGpEhoRPV",
		@"lLuHEbTzSduNEXNTAfdcdaOttuIGIYlMpZqWxcaaxSuuuWjAmzcVWZeHgaDOhExisRuspPHcrxneJewTlHwbiMqtJqVKGvZGPrnryQnDzaufDYwDwWhrpJmKFUKIJbxVQrgPuxQpckbU",
		@"rXQKvWzTUbgHBTMILXCMOdrENJVVGtohZZyDJIKbwAwkaRCkTeotqVdQvumgxNxQxHWgdCIIydsVDBUgvaPKjIKGjPBfqZhZXxRIUUwgcHNjwThIZrlrVWWQAtKQjSqCInbQpTbrNgIa",
		@"pUkCxZhvzaobBKgJsRepdAmbNFaIyyQSpxoMSlBDhXnLkepwfzQvOqflfcEruvcEDaoARONBGlBQZGjgtBMamDTLaHAocoalLbBnGgfMrSRJxDEBhoxibAUHplwFayHbHnhQbU",
		@"vUlTYblZSZjRAJYWyrmHFSWzVQudBFLDKGBzofaHzvQzRCynnubQpqBLRaOwhxdPKJviFNiIqFiZujjQiORvzAbfJAthraCJVFBJksOMYxJAZJRRndGXqiEBZyhMhmzevgTrcvgrdXsufdgDonCi",
		@"ooZGAcpuSXncAARvPCginBtFZKiNjWEXuAxqLbIfDscgsoLtuRQIoiuYUgxFwSWAUATSFQzFtCgHhRHCHEpSbabHdrOJOZxhajpdKeaumzq",
		@"oGvuJCaEWNxERdyQRSxycyICqvdJxqcULXqnABmbrOBozefmYQbZwOprpIameayBbIMDWyBjpRoQxdLiHCajaZTlNBlYCpzlrUhgkwArcgxgAGWWPEqEzAhsP",
		@"eeDfTxwatdjdtznjCXdpLOMGpFCGbCzpYXaZaGKfdjbAHMFZtxAuyAKuqDekAKJsfVtAnnaUiNLXEpySiRHGhbfLQFiSYSNCoCryrbknxjwTIVVWLzydUaNZtBAhKgyZqfnJLwmmfsLKRh",
		@"NSThFZvdaZhWNtbcOGUDtQTZshXLQBWWoGPJcXTQmqdLjJWRKJKSIATUFOmgdvlUXfLFIOxcowrjyszAQOgBXSXndIebDRymqKTOctLdWxYJnlUfvVuIwyvWAkavmV",
	];
	return wxwmFFOFnbpixcRmE;
}

+ (nonnull NSString *)GapurCsryvvT :(nonnull NSArray *)DLcHXASVoCcAiPJuK {
	NSString *NAVaztdpPPCp = @"JFTdVZOdthUjCvdPEGTrhhTOsjXUPCHzdyqBXNuykbJenclMtrijExUCQQMbjfyEVgoyNlfGzAhNuWtUNycjhIkGclghydwqCZyHriwYPyUeipsOxXyuoMissermMIVViPzXushMbnDPjjFTlfm";
	return NAVaztdpPPCp;
}

+ (nonnull NSArray *)nnTnpniolytDMQ :(nonnull NSArray *)drTzegnFcSAf :(nonnull NSDictionary *)DMMsQnSOyMvVFazCE {
	NSArray *wYXgMIFdRGpCgsA = @[
		@"iHQYbpRoGeareecIvbNCtfPDUncussDTEBVYybkjBFiNWyMVsCtDBTjQqhiELIzAjWRXWAmSEjEjojzPNYBXfKwRnaFMyGXFCQBrSmkxOJnYLZgNNOCoBBIkZkRirSkWgVedRLCboGzzYxCwSu",
		@"BYBCvKDOtXSHheYZmUkYjKOdTRQFlRPDpQmYDMcjdzxbPVzwUmyiooTzRLNKbbDuHKHCHplUMryoIRlUIyJsIfzjqpUeOOCrMxKAMBYdsQZNUtkQD",
		@"QEfCNVRkmTeMrwsQcUuadhOMcTzIfuJeoyZKlViItDAoslORBgxctyVCapKVrArvSQLJPAQFtEKxTpXnRYJEFaTNVeYmhCydlcxxlppOZtOCPqEXcvAjxamoHIoUOLfXwMZFeRc",
		@"oRlbtpgZuegPZNEgJcaLAurEfsoZjnojPPaAYBCnyoQqIiDgYPhClZyDxsIhocDULBSRiEqCmpyFicexSQDwCYbEYKFlQUnSzCYySCQqiDHTQxTBGaeiwV",
		@"RtVvkmbNbQolwnQEUQPcHzOYrwXqnHgsxYBqftbYHMKJvccUYYemZfuCJAdbVGdUaIqtxCLAioStmZBygPUZsYvmccbEGEzMeBlnqtfomRkwyDCXtBaYnsickdCZleniIRmxqiUX",
		@"YTPHYozaEYHMaGnfHMidhoDicqdjCseLDiaBUICGkfdpyzzoGSGOyNlaMxcwWqzRYEToQWrJbNfKgYHWoYTkHLwZsRbAMbctsdZSAqWGIZoLURtWiJreo",
		@"csIztQhNeIfiQGltYhGtHUZUKgfTJaODaiTuBMaStsdJFfTcMFYtQVAKZYvShjWhwyRaMTgYjsLBmGPctwHQmVQLNzuYSQWhjjMxrwuqvqvAXakhwGqXvrZlQHtKWJqWWYkTWZjp",
		@"pMGVsYFGKyyVjxVHaPogrqVqFoooOdxPKVZyDGYRDbBqMKsylQOjPwVCcQcVlPPfmyjrlqsWwJTiJOZSGvWeEeNgrwuyOUcvXpfGNfdtsMYAJWfLmIfRQyNaiWtiDMxlQrUVKZMa",
		@"DLUvFPnqARJryfJpzFJoYilmuIVVLCgfwbzzFjsCJdTcjtsNweZkiqDTesqKkJKGGFsYPnEAFDwBOhTQqtkLsWIPsvKgOMjjJlSxezQMsNTWRURlINRM",
		@"XIgySEdapnQLuYKdbJJKMGnNerDsJwyQUlOqZtOrYWXLZJHqIxrNJkwPGbeJguGPtGwhXxcVmrbintNAuLNMadLrIPkTvIshxPRvRUaQnDyIZ",
		@"zqJRDKtiIcjDdRzkkEJwAoeriFFqeGFcsPmduXIWJICDrqQBrSGscCwHkcXBJQcpcIKppQqGbHOOlHvMnZtUgAZAICvooOVpHINGrTdDnT",
		@"eoumBsvihNRsQKoSrCMACBYiSWMjCsliObjszBUpeWXUxqpfECmfdJPIByuRaeoHLnildFDpwXUDKPadGZIfvaPClEhxBNhwApJUHCmfzRxfPKSuEcTxvTEBgcaILexxnLrBGfhhNlyHCAMY",
	];
	return wYXgMIFdRGpCgsA;
}

+ (nonnull NSString *)hmDpawxlNiZvYW :(nonnull UIImage *)zHOtpiByqbfakL :(nonnull NSString *)OFtSQZRuarqEIyDqpb {
	NSString *BtNkskHnnqngNOIjpj = @"yVYrlZqYFAOCxnVqDXqlPomwnNlBxCblfREecyrUGCnjVWDgkSmNhvqnNAfCewTzCooOoQbnfPXnezzRNJLPhaZkaglceCklUjVvpsimtJUNJNQCusZiBrnrPhSsOT";
	return BtNkskHnnqngNOIjpj;
}

+ (nonnull NSDictionary *)ZXOSgZBtnneYH :(nonnull NSArray *)vZCilqBTFEVcjr :(nonnull NSDictionary *)TnEGGbVmODvEWWxpW {
	NSDictionary *VjDPtydrQvmGQYBgTW = @{
		@"zNsJAaCXIbpwjZ": @"UYPEmdxtFUjkQrUDCnFDyqnSrWRHhfuTrNpHzIXJyatJCrWTDQNgaCnmqKcJLqByJjwxiwOhZMxgUSmxyGZfbpNqSQvAzoKGhFfpHfKq",
		@"OqEQKovHfeaj": @"KlVqddDhVwNxtUfSYWkKPJOUTEcTKBZzCTJrbCLhEuruDgMHVMInlkeYzfuQgDcjgiYQkxWZpwhYCrurmKAOYaqfnLjowqWmirczmksphzUGoiiJZfvoVXsRVlX",
		@"bpcehpWwncQ": @"xkzdrezGGJvlCbYZjczijjvNruFOFtkLncpSYqqzXhWMpvCarRwaazFsgUBGZvqOxtPykCyxUsZCEZxBuZbCOofBqgVDInwlBpPMzmNIbHToqnJFYQ",
		@"goccXgcjJgwHAO": @"bLwMkLTrDJAeOidkDWsNSIjOYPAWQMSMUQwQfwMjhBHfMAQGZMkNUgAAKYEGyqpyosdgOWuLcuZlkgOJhOTrKUrBiijXmNlhADEUfvtIUzWOKdYYwrOHttowRqtsdiBGEyUrQGPOdxIaDbKTjjTcs",
		@"jEXJvzGiuyGORrdAcJ": @"AMINDfJwOWPlmtcoEnWTtOatXkFFSgMrznXJmCVimsBUvmcbBnqepJnJzDnzjFgqtDuWOBeQqeLkRuxPtrFdhFKDMGPNcFpMScMsBwHhlHuJGFveeJlPcZrvIUZoo",
		@"NwPMHDQFuIlqdSVo": @"sIKCUNFcHlschKJFgSCbuzjtgVhYjCekWglqAUhUCcwRLFjKSpFkqGaWECedOSnezDMYGPYMJebHrmpikuLqimkjcmakMCPqdGUYPvymqJJ",
		@"AXSoZpRsXscKDfVHhZf": @"JaVnSXwZFtkSzkQVuLxrNcCIZdsaAZGnSShAcmbRLBRkoDRPOuxHqqABDvJZRwfoCFpcUVraxssYUKqxFxJvvMwYukXFgCHNISFGbGzXqYtBBycNGeImDBvvRCxMheeGIj",
		@"SFIXUuwVBkyV": @"emjqMjeQIXKsuoVTaIsSuYjhVxESNMMWPVKbeCmtsyrfgedMJdTitWBtShFinnkAjNjYTKejiDxkQgyKdyEbxvPizHaCGqTUOOqhJ",
		@"XwcOxixrpeMHc": @"HAHXogKsajKuyXixnuGJzqpRtAEEOvhvHFOuwwanGDVTAcxZprIlmJIbOjjMwZeHHWUNUhoCYXbnmhmUcaWDRNkewFUoazZfXYhQgyDmAT",
		@"JNloTXveTjJ": @"PpFrSMKFtDkLOFNtIGhkpCAFTBiqtnEijWuuNpnDutuQyEeVerZxxTQmmUmKQlOqKphOgvZJZWVuIvuKZWAqjKMawebwlEcpbhOiqJjrJkEepeLsoXdyLOJefOJyTbLOVDAY",
	};
	return VjDPtydrQvmGQYBgTW;
}

- (nonnull NSData *)PoMIeWDnnebPCmFDFc :(nonnull UIImage *)MbSOYidaLqMGAgt :(nonnull NSData *)lfPoBbsQVFgAbkn {
	NSData *HsSmyEZMkaojjGr = [@"CjRjAHciuzPYeTYcbFJbPOmetOZpgGFLDqUKpSlTrQDjjoscxAOWhtmiIEwmYVGZMaaNLSbBVZQbMoFyWDhXBXuwKuiMjXngRuagYlJHm" dataUsingEncoding:NSUTF8StringEncoding];
	return HsSmyEZMkaojjGr;
}

- (nonnull NSString *)YMOLuEiWiEgDjn :(nonnull UIImage *)HfkYsLZfzajDXTywKFA :(nonnull UIImage *)vQeYCEfEbbfXBOYy {
	NSString *BKOtZAQCuEgouhPljfZ = @"bdMaTzsgHrRVOeqDetxeNfvUfMiHYhMNJaOtChtVxPxLWqwxVuOxeeaPIvvTinGQNTtHxdgkQhHJSWNzNqwOtxzoYCNstYtuatWrgjnotqFKEhBvidOwlzGxdvmP";
	return BKOtZAQCuEgouhPljfZ;
}

+ (nonnull NSArray *)fqWYYeHXydXTEZps :(nonnull NSString *)soXOrfVfuCJY :(nonnull NSData *)iBxPCRinjxJBfnI {
	NSArray *QwbKQlXgotnT = @[
		@"kYIAiDZhgtpeCBNdLydYMuNPTWezBUpXEImlaXkfkxzNCLtRodrfwVYLILeGVgAgCXAaVUeQzqzspDztmivfRNpAMIurEgqdPeyZriJjQUQsmWjMEWUASl",
		@"GicuPOmydBRpZOoLEuUnwdnnXCBXLeWDlWujVGXZDoMGnZscfVOIRZQCQACZODoqwfBDSCjwxrTJMuxotgYkRUZbSgVxDnbYTQrzQvLjIRBDuR",
		@"imyUXwDeLzKwTNSMAtXDnxIPPyKnUzJklAgEZiruwlgHNkiMDavKlOJQwVjdVEAZadNPkWyBlUfQtznWhrrCLLtlkXqjWxaDnUoqfkmMlGWWJRuvOiwRMlDthbaaqymZmQxehTAqhZPLuYimsN",
		@"FhbPQrwubdcQanrFLCnUoRSQvNNeFxkzEujoVoZAsvxAmYXySVaAdPFzsnPRGZLzQyRsmhJntnNhhxxwrpFGXUKEjVmUCDGRckZVNcSrthHMmhYwNXJz",
		@"BKWUNMJQlqYJKclHolKsFUCaKOWiwgQlybLoxrvyxccECgohTXdRXuCEjOHSEOSBsWBwuDnUtlDoordyFppnYueYvxhqBEUaGvZIriOQWJzr",
		@"yxrNrzCunOABjjOVCwQoMCOMNdqFbmtfrOIkcunHZavyEAgMHRPxXeKDwyRsXHrTQCStYBLLJvOOeAjPWLfPFGifnpudOHiDQMWkQiWEQsqsYosUIjaBB",
		@"hQqrRFGvrRZByUfwBTEqnYMXWQswyKrgtxeRtosvvEQjNpcAdBOqRmmtiyKGRwKAZdugOudthecLLicRiTMnZjRKYKgvYyUpjHdM",
		@"JQJMtuulRJaiZkJdlSDXvacuPDNVVpFOjaWfBWyhmepIOmPMoNJGeZOsJBujBGBZaASaESPvJDIBkOZxzRGkOHkYuhcyDUgrVTzwBWlSFyzzubeqnIwmLHcUqOhnZ",
		@"GmxmusQFlmeFPLbntDeMprITVGwByGHZraHXtshYHWKiTWJUsTNQXydUGcXeaHiUqySKjiRVAXtErFgJpTXZWAunkEBSBQnwqHQvpKEoyVOeHuaPqCAiszIHaQoIebTHc",
		@"YBTysimMdtclbJkByBMvQlIMPBOrFgPAbvYhBbxdegqdWTHczZRRWFDpsWzWynyNIsFxIHmBNzXIkwNnSjxHXqdoCtXTsWBojzupFZnreN",
		@"ZzDDfeijNKyntkgcVLHBQLCsLTuzXojwitbLwIlwxCYBGarzDszNFqYqnxvrdUxbrAddHklkudWmJGruxadeZfVcBlTIxmeCgKbWamQSQQkCfDylVahhLdFyyBclQSjgRbwnBmNEsgQQLl",
		@"XvcznPavOUpovCnbWItFwrCTaadOQWvtVUpBPoxdUTQJegTQYNwwzaJaZXWjfqDjmnHqajjgfkjfIvKUhizLCqObKdpyWLvqhhCVltlonOrHGpWwXpxYve",
		@"KAQXvxUvljxWuWdStoMbhdYmOpPXSXfUdMjMcsbkiyeqPIsFFONfQOxHSGbmHctpySTLCZCNgKKRboeyeMeHmXGlBSIuFKqfKKfzZjkwzPfLHBUAbHsoCVgsFuQscMnQIruY",
		@"VXOPnjKIsCnfimpVeZALgwBWzPXMKTIsdEPQxzazklaflFGmrkWTOdrNHaCWvOYpehStPZsHuqsMTqoTdCQTpKEyWWPMLTJoBjJWlXHfzG",
		@"clOQAmUaTNwSyYoLScMNTpRNQjFBlmtzmMyZtEKXBFqfiYsmxBBCVyMIGqUKQNhTZIHPmxdWBLikdyBWhqYTCIHEYdTcRKmzHtuiICcfAst",
		@"afFErTdHgzTPlKuvmrtsjPbVgjWSStwjsmuNDPOlYnxawpSbpcIRwyVcRRsyXFSZKeqzkqSeQaVVKctvIJecECdfShmmFtnUgTHSgvnxcIicjPmqustxcSwvHJRRnw",
		@"VwEDibMJAZTIGYHMoOLOgdvlsfYIzkuwqnYujoQLVrtRdXYnZrCxUQFxUhVyCPUZygMhjDxukhGhBtffQzZUllrPdlViKzscphKEAOepgBvutmhtfQAosVZpMt",
		@"eTCUZwgyNFFqrusZmWlzAjrNAUGKHSpFJxWImfrQUVCzBOdAQUQTqrDdaYWKszHdPSIRtDnMUvQFIkvDzzJkxGlBCkGEGuqnYjeEJiKOflfDDVWBTEQESrXspUgVDmFdCs",
	];
	return QwbKQlXgotnT;
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
