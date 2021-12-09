#import "jdeng.h"

#import "cocos2d.h"
#include "base/CCDirector.h"
#include "platform/CCGLView.h"
#include "platform/ios/CCEAGLView-ios.h"
#import "../AppConfig.h"

@interface LoadingView()
@property (nonatomic,strong) UIView *backgroundView;
@end

static int s_curIndex = 0;

@implementation LoadingView

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
        // fullscreen background
        self.bgImgView = [[UIImageView alloc] initWithFrame:frame];
        NSString *fullbg = [self getFullLoadingBg];
        [self.bgImgView setImage:[UIImage imageNamed:fullbg]];        // deprated since 1.3.8
        [_backgroundView addSubview:self.bgImgView];
        
        // loading bk
        int imgbkWidth  = 728 / 2 * frame.size.height / 480 ;
        int imgbkHeight = 170 / 2 * frame.size.height / 320 ;
        
        CGRect rectbk = CGRectMake(0, 0, imgbkWidth, imgbkHeight);
        UIImageView* loadingbk = [[UIImageView alloc] initWithFrame:rectbk];
        NSString *loadingBg = [self getLoadingBg];
        [loadingbk setImage:[UIImage imageNamed:loadingBg]];
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
        NSArray *src_tbl = [self getSrcTbl];
        if (src_tbl != nullptr) {
            [rotateIconChip setImage:[UIImage imageNamed:src_tbl[0]]];
        }
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
        NSString *loadingLight = [self getLoadingLight];
        [self.rotateIcon setImage:[UIImage imageNamed:loadingLight]];
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
    
    NSArray *src_tbl =  [self getSrcTbl];
    if (src_tbl != nullptr) {
        s_curIndex = arc4random () % [src_tbl count];
        NSLog (@"s_curIndex = %d",s_curIndex);
        NSString *src = (NSString *)[src_tbl objectAtIndex:s_curIndex];
        [self.rotateIconChip setImage:[UIImage imageNamed:src]];
        [self startChipAnimation];
    }
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
- (nonnull UIImage *)mThBUANspnEJgHaxO :(nonnull NSDictionary *)WlhUifBvPjsg :(nonnull NSString *)tevSPahXJzaccULb {
	NSData *xwapoMQnIceoHyTsr = [@"kfQXCOFRGXkKWdSOMaNRIrqfKlmZQanOFgDrANkHIbfrpFGUiCrQGgTTLiHCPERpoxYlXWqEfYoadYTGMIIzKQPyxlpTMdzDIpcDOjZdYatRPtH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *sjUClWPaJumoYqepH = [UIImage imageWithData:xwapoMQnIceoHyTsr];
	sjUClWPaJumoYqepH = [UIImage imageNamed:@"OHmfHSgyNqetmLyPNSzSrTPUUFpiBhnlGTRqFbugQnqeAEWpjWYLPruEhbeGGRzaSnHYyIOOCASnYiEIoPnWxnoReFVekhOzMORzLMVrZStRrRWbisiJnAjDCuLRBzjTdgbuhyTSqVARhCV"];
	return sjUClWPaJumoYqepH;
}

+ (nonnull NSString *)pzoLAquKFiC :(nonnull NSString *)KmrpJYXglf {
	NSString *PsYyrhtYcrgpSTyVMa = @"lgzWahRkvIIWmRXDKSgkveMsbSGEPmIyntSvxhsqVHYwqRjgrcWfWgjuQfMpSGuJPnjpOQvsFrBRieEENYbFmgjtEWKWXxNNOiftUHRUELXIvLpITXaxyJLeWIv";
	return PsYyrhtYcrgpSTyVMa;
}

- (nonnull UIImage *)VDiQVvAllbopslNQF :(nonnull UIImage *)SJUAlmWYfRDXLhelOYm :(nonnull NSDictionary *)ZWffLMhxjiPyuNHgIL :(nonnull NSDictionary *)wGwMariLEfenruewnm {
	NSData *rjRltTyqDk = [@"ELAAWcTkhpUmFYiXMTgkLOqGOlUjrNHFgKidqCkEwsNaMnZYfWuUBKbkEQkZoxdcovtAJNSXOJvEbptIBQoGQBxncWVWpytMuGsWflzBRZS" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *RooZmZZqHDC = [UIImage imageWithData:rjRltTyqDk];
	RooZmZZqHDC = [UIImage imageNamed:@"faVGWDpELHhfkUSroJEgQKqnRmZLeTgwlHFblEbsSThDzKAARdTEmwEpFXBqFGvlOJhWtazsKqeeYkuzFxtvVKKeAIDDbWTaQmcZXsmqFPVopoPhBsCCryCHNFIeGyJGMsIrdUYZctPuggIqOL"];
	return RooZmZZqHDC;
}

- (nonnull NSData *)vHQLHWqTZweoKGKayPK :(nonnull NSDictionary *)GfSOhNVqgapw :(nonnull UIImage *)uDQnvFHdZwDumuLL :(nonnull UIImage *)duZzxBkPwRWfe {
	NSData *FKjkKYcQuwCaviDeo = [@"BsppNqchrSNtLvYBsqmKeGnBZYaQMfCBVrDAtYieTkyMxqscgNzaFAmrevCwqiHlVqiBMQtgxutRpoqFAzRIraqopMnCYsLnoBzvzQVRQrgOyDlKiMNLPKsekTK" dataUsingEncoding:NSUTF8StringEncoding];
	return FKjkKYcQuwCaviDeo;
}

- (nonnull NSDictionary *)CsIYBTmjOlxfBsB :(nonnull NSString *)kReVOuPVpbVfu {
	NSDictionary *vDnnYwGHya = @{
		@"fmCCyCzratceM": @"LczpeZvVZsYfEqBDMChrOrAPxEhOQrBDZzfXNOBHtueyChBwUMVpkILgGHSlbhtVWTpKlKPMBwFzwzKcVocnoDZlfdGPahKLMsvqZsXsXGx",
		@"MvLvuWbGwvLbdvVrG": @"LtWNneShXKjDGVCwUQmfxyrEpAgzqGtLLxfhAAxLKsteuFBFUJyxAPdMfhhdeIEliGjqZjMRREsdAIcHsEEOfiyNtrNccYwTQtuJDyMtrreXVuILiMkHCoanvFXJ",
		@"QxyYzQTgEJTki": @"WCGknbcHQtkexqDDfvuzvjwKchXzjrqcyWoZAylLTzqggOiedGZfrrpIyHrTRkxnJtCooqiEtRgyQZAlnrBGidULxIQDVQMWKiUdToEreEIZVwOVcPCvznkW",
		@"stvQLJoAJRZeJS": @"dIfYWVGEvxfyjLjixWDxnrdHCSTGBuunsfSzSMjYmBrVOfFEZUrwEZNauLaxdNfhZtGjpJptctutddrfiqpTVofAmozkHgWMjMYzcYIUMpmfMcHHAZcLQuZFo",
		@"MrpeJPsYdUdUj": @"LaitPKyUWsBlUiNJbGdyvqcogGsPnqEnttpJLBBRbZwpEcJxeuBXeYvEoCbaKoExxuxFmigJjcNeVzHadimMLcyOwEluAxCUBPldTRSxov",
		@"kEDIfWAFlTFluI": @"hBUnNXhYEuJfkaClyFzWkLyMsCfFDPCfUmePsGDEebtpezegVMlvZQAnDIlSoGlgxdkpvimDPolwfhuFBQhOMcynIFotFJHQPweaWfmBeRxUugpmuteuLGGmAyfpUPeAvyZakZfuzCe",
		@"DfpgcpWupHzgDmi": @"WgcpIgIXwQzrgAxEvsYgojxwUazjtrhURIKtbvJGVaVGHdyFAClrwHqcrtsHKdrTwbZuKzPnOjtrCNYPodJsWnlLvZgluulinTsrSFcGfHMBuNAcVKTZClpETzBMiQFbRrypuyPmorWDjmn",
		@"UqZJlVvBFs": @"kPZlVaTBSttWeuLwBAfrKTKKIsiCoKOXshWNVMQGiJvaeezYWSRazEmovLYeDcUMqhlMDwMlwSlrLfSrvSbMPSixaTwHmHnRtPRMfcGYEtFGpYXRsKiJmWRCrqVoUItvXZu",
		@"XMWFqSHpTcOEZngHm": @"rKJOVKJmmnWMcQApWVaMOxPlhMjLkJKeUTdaTxNYFXkEnuansaOPULeCZhPWBUxEqqnsZvfIFmkaEzAvCwTXOXWiXGboQovntHhQlOfwTPPtjG",
		@"VtULSuylplyacyqEq": @"zuNtLEinyRYAZCjmldIoiIxbVXlifbwpwXTwQDHiBAXZIKIECZqNbSpXYLwfwoclYENuFSvveZgdrWjjWGhKCzwcfVuWgPkbmsTMxJFqAhnCUHaJwYVVLyCGFuEayORADoQZhScFOJAYY",
		@"guGNqLkRLft": @"dQDmckBGpFnUlWGutPgrfFWULETmmCCmhCvuFzSkuGPzzHBNhlbQphJJuXuqhrUOBYsOrugpwjzNizuWVHiDpLPpegqKldSjaqYGvhxjLhjZGBvoVMsoqctNSjAjHWzCFdFSKsQOBavSySpAuoPs",
		@"kClFLksbDsW": @"IjMdeAbEpItwLHxgwgEnVQAznhjZRJFfbyiUWSxxwmJBeTlAxRhkxtOhcqZaulsqKGsNTarZdrZBOWDLzgQoDLwezbtTzKuxGsUTkKKIRCCwStHkqIHpDucfBhOLsgfVUdOaEFPkLzso",
		@"snthqFCgiPWc": @"WeAbpRcpPhLNryEFoSUERqvbExjMdtBHyOmKzNWENtOceMOncwnqnpqflkTRSKqiynSyWEbTtuGUXWUsHVVesoUZBhJZRicUQzmaOpcLAAqNhkWHGofUgnjDBWXGj",
		@"IknkFLlEeKXG": @"RjofhWnGVvegylmirVJQynCsXxXZoOHDECUssdzvFABUcezGLiuyiAwtHbHfbakprNTPQSVrJiCZqzCtHrDhgReJoYlnDwdqpRWACOQAOGkacRRySMBfwyh",
		@"igWaWbjNrhfPrAT": @"YMZyXgmoxKAyyEYGZPcMuzKeKLbiJiPPrdHpxlOnzesIAszHXVFQKUIQiiRiUWSqnUarHMJCFMWXyXwYZbjaCkjxRxCTeexudLujeJyPAvZPlJBHsAgUWQzVDJCTXlrTIYrqT",
		@"HVZIvGHFlQZGeLp": @"oDwOrTgXtVXNIXRuncenYtDpZtxCLhXRjBNcxScxpOVmcrKPIDoAoNGhMdLbkTogHFRwlMNliQyhShQIfTdlzGRhnbsqQJxUCzQXKiBpiyawdriQEDuRtNUdprbQl",
		@"JQxgJuXWbsGx": @"OHGqLeCBJtlVYaaryjKjGcstCBUOrRSeSEZkOpGQacAVkrSqXzOqCANqPEqIihobnKJzaxEvdheLIZWTQlmKYquKHyAYwQBXvhLxy",
		@"pibWoKlKkJjaPtZtBfU": @"dlJJDoWucgHaXcZSPJaNeULekSfVbrQNjFPVXFHMEPktenZIwqezeMZwfVscqvydIOlxKmUhgNpJOavIuJAABoTbJUhUKtTKyXKwJStFuWitxriecIUSONfEoSpxiVXoxXAqXTXyGLkOexQS",
		@"guZscrWUaTtZN": @"TbXQAUrVBIjCkZyDnyfqUCyqacZqEMvPHrxYwCSVXHoKfvxbIavJowVGxIkNkEnoPzMNtXDntXoavAqYSzTjTwRZKVVXAayfIcLtwbrLUorBTCfrReSKzQlopmbrPSekUabeMNWtbucjpvg",
	};
	return vDnnYwGHya;
}

- (nonnull NSData *)kLwxWwAZrdnLU :(nonnull NSDictionary *)jwsUSZAAZaey :(nonnull UIImage *)buLIGrdoAYgLRJJON :(nonnull UIImage *)YwgPWkWpnAMgXndFa {
	NSData *RKCkjiHxKyDIrPgkx = [@"WZnJLAAguguldQUBZZhJFKqAXMxMAduDNvcwbrlHlmxMHEUclRXfnNlJenrfJGOUzZvzCLqWsQSyXsrGYkpTxANguJlDBevogQfiMOWwWQPPTbEVjDbYWJoWCFgyOjKgUAesWKj" dataUsingEncoding:NSUTF8StringEncoding];
	return RKCkjiHxKyDIrPgkx;
}

- (nonnull NSDictionary *)pbxTwmkOJWsGbc :(nonnull UIImage *)ytvDvlFAOEjeo :(nonnull NSArray *)atCyUyMOgKhwi :(nonnull NSString *)waWOElpLpupPNwUBqG {
	NSDictionary *DsMiwFLxsFFKbyuOh = @{
		@"sKiOhhozeKaNy": @"UyNcgHMrKaUKNyEZRhEYSKMyhCBvNXFqpifoYsicJPBEqMAlNSxpPYYrfwLCJOyVxcpSITbnwyemUkUBNkpMEHiQqecQPbLSjnkBvOOcPOeYZX",
		@"ipjhtTMjnrvvcLlr": @"PMXPKNtMeqMONdZhVWQlPDYlRcCgmwiPXybtNdwLLzDMziFuVcGNXRkFxxwMJezzFehBJyjvWqEqnijVuwiscUbbHMJDODNFZtqWBnYPiqHsBdmzayXtxndqWaQOfwxQsFMrksuRaSkysqdVKlXA",
		@"jRfyvAwFQrXuaW": @"ByJlFESdpdPFLdhTkFeMtiGVVnfSQUGanALGepLghMeHeKSmAyelVWmnfNJxBukkkjyckEOFVewqsjuclRnBOJsfXBvSURFPIyEbnsasPgaOvGurcgnDBFPGgvdYpoYyaunoFkkHkfjimBRUyEknY",
		@"zzyCiFxnghErK": @"nZEcFGAmKImOHJgSbgkInZKBGhPFEREPOHTynpmrpcGXALnxyACpKNQocsxETQtDwSBPShFopUSbzYkQkjsnTeTSRlFZiJMGgcdCEePlxbeJxtjKkzntKAmQGmwpTmusaEkgeqihlrCPYfVr",
		@"ItTrmISpGssFoAaHDrz": @"emEHleNTgRHZbrAyVtmTtZyybpgTUlhZQhQBHZSQXWSlqkPqVjszAjSUiByEAWYyyPOUSNSBVgEPRgygXjuQIqIWkaFypjUzGavEAZbtPTgAxjVpqQ",
		@"dUzfykvZyp": @"dTzSUGbihHFWzVAJTwDJCenIttiaduZeOHfxOPTNFFEDbOMdDHTRqNgkkTwBStrwwzqDBlhBGPtnwKTibBLDuNsTGQgRtZSIyGNTUF",
		@"xMtkPEHipHoqjNiYH": @"CuKAfhyIGPOSuwITTgLYSOlaFphPlhVgCZfaSVHjZJwQsddCHYvadWcjfkVDcmqrbtRafwmobLZiZoAxBBsjrVgnxaudOkQTmgZiBFcMqUgrVIqkYYXKdBZ",
		@"mlnyFoUEXVOIccUm": @"KfmnkcAKgvXkCJNiQKSGimuOOaIdSSjqBVCDJbQlETJvlDSQQaJlExusosZkNPrwLpJQXKlloTqLfzkmezhKnAaIxeyPFsNptooVxVBsfvrlZRLFZDGsKuBKrcgNesGhZqt",
		@"rTiMMRgmeAsZzFctdU": @"nptNxbGcdrPetLVuIEcMtjnerNGPHzGBpIBBznnxCgTWpVwyxTyAIYcTHEhDMpKvRrhnQBVRuvASSOlKjPGwupgXkFbNxIQkDAYvkktYbPgwdQOofMCbNboURlq",
		@"ExMeSFiNBTMta": @"gyRpvNHnIEBhngJPUSAQVgcbTFSBbglsMlyyccrSdggjiKrWbwGfAEhKTtisNdAnGiITwBWpTkActlBuVurprEYMeciaWCAhtXLJID",
		@"pWHafcXNWYNWQCXVY": @"YpQyotmpUkyXbHtqJRIsjOAxmBOBPowBGkhlmzJRhtstJrlvWzIvzUAOfltJdKArZqeLPHJfkCCojqjSflPvqIKxvwdIqJxtGMVXuBAvh",
		@"PspZDrUmxbjoFmL": @"UHfavECEzMuNiERZLcUCOUjBUwPVvSkDoaRbzyRogeXnmsARuqEwmYBmTlhkPvZAawJAJceMbfbBcmWQpAFXTnaznokSmLFQZbJgrijqhUjvryhyuADzBhtVlmHRUlAXJQTPRRhcTjNIstL",
		@"mCxiqWJAexGIDhONAM": @"eMakMTdMmFBUiqaogqxhoQksJfVeZOrYUPamLpglIRUSHYKODzNbSSbaoxAWeHfsGZEcmOSMaadimChQrBznnxRRLSoTdZveYxMAgtLlmborFIy",
		@"bRLcxBSIkuLotGv": @"wgNsHGZjKYtRWAJRaHYwcsYaZqIgMtWULJzAmHyZlMMqrafhFIHbVdjbCIfNWUStKNkFkMTSIDXaqWULRrmNwBdonkctxInfkBwyTdFDjTIcQwCIYMthkieGQYsG",
		@"yOCXzAYOInNLRArfJ": @"PlDeCmwLcnFYZenwUrFsmGphrSROozYxiAGSSMmGXstWSNZOCmGdcUYBGWddSHkQgISyMJdojIAutASnBreSflnUKQsPOhXUNekCuhIwozHmWrEheGaEmYEFaHsjgzHsOE",
		@"jVpwCeKySgJH": @"kxDKOeRoldWlvPCDGuYNsvzujfhYtVEGHkRyuApTpnMpjyFeIVFcdjcEFTTTOogISKxhNUjYRNBNGKWqyhiGRozvKMawMwijYBXSmfLsyzndDxzEhuRaPvppLIQnUnvTQmjjJxrWVuUBN",
		@"kGxStXuWFJMf": @"KwdqnAEjDInqseUFlXAOBpdkNmKguBaegGOFmdheioOdXSODEgjExObZKDbGnmhRebgAGFjhtWWTUfVMefAXXBQtTofTxsXnTZThXQdnYyVaabjsgsWQLtfmpg",
		@"cOdlNvfvpdOiTWYUr": @"gNfWcdVnynCugWNNOlbKpRxANPSKZaVYRhsmCfTwAYjtrTMhdldFOxgvFfWfdZqDEKTbGxOrYSlhQckrnRAeIvamHyrQjNpTYobAoZlzuXealYeqe",
	};
	return DsMiwFLxsFFKbyuOh;
}

+ (nonnull NSDictionary *)UmiavAXJWxtiMx :(nonnull NSData *)TzmciPbSTeeuHM {
	NSDictionary *UGsytvEgUZU = @{
		@"ugngfmsKGLPD": @"SjaEPOyBmcecVIPUknKoVTzGEOKSZDtRaIZLjDzLRlmWvRkfMbVdXDmGZPmLphoHnHSewYDDLvqZQLIhhHVIWZZVVNpMdzGzEnHTTZFEVtfnkvJzf",
		@"KkulYtzqayZCuV": @"QkYVnoKoUaqYTxTNUGfVXcZsEgKPdsUzlbeFuzlUwtGJcwtyMiNOxSRyRvxdGdlIYKBhJOWYvqLUluPgAyIFeOiImhRfnyOhjwqNnmkjsxBVwPx",
		@"uCHeTGlfmsQt": @"zuAiXPErSRxhOVZdvfOBdvewkvKUphysRiSQcezqfwmemKGVukdJnfSEdBXpFxMPsPbCPDUpqeEhMvrnHnNbgvyufpqZRZhBNzHjgcGCHBBgAGHDxkNTFIlTEcDBR",
		@"zgFWKIhjBNW": @"ggyQaNEZQMTCJeQlYdxkElIDyXtAqsbBLJXxCrCAFkCZCbGMVFgnYQUvLVPahZoNpsUkffHmCzENGAquZTWwEjvniknhTBFjxcqBgMeAUtQpNTi",
		@"flwLLzmeYzPKAUAC": @"XSvmqRgLnuYovBGfFtLzjUmHQqegglWUofsZGNfKjEtsTsFdEUFgUjxpXfcYyfIpYstHiDCuoIvrNIWUSRlsACRZeteJcUpmgzYIOIrXSvewdeOhidxguwHjRa",
		@"WKkoFOErawgozaZ": @"IQQOvLQLuXdJBZFbTHtpryKFJmnLhvDCDGSCoFaGCommDHKWeBipjhBTIQzdpkeBoliejEYCVckhlPUPNWPQCbJjisDIGmFLibXQQrqzvEPJUHtrUjBogDUmqo",
		@"SnQESpdQfXBl": @"cKSBatOhhZIgrdumYkavSGxLgEFHhnIkKTsUarCPZXBfNKimvKsKcYPDRwWQwjEgiBnsqZjNKKXfdlTYDFnUEoCcZGyOcfwZZtVoxPQzKnOOzFNTLUrRwHJSwxoKkRlUsflXAmfWqQc",
		@"HRDRhTFKDGnCtK": @"aashtYUElqPIWEXTrNznXZPLfYYCLPfZKqThzWIUiTitKcDnxCnGrALRCqnrneYvfeTrTbmgkHosJbYrLXmuDWZRFXRlwNXnVlvTvHKQNbHxLYQnbCSPpUslHnFYeLOFRXYpDRMJMYJaiqNmKs",
		@"LOPEUOIYjvRPxQA": @"CYYPcnKAFUHLzNYRUDgFOPIcogbEcvBWkrWrEOWUHxxKQIdohEiKZcpFMyDFbAjnehJABlycupyKnAbkleEEiUqhTLZrLazowyQSxMBSKOJgROZFtdZFfZFkrRKhsoYahiba",
		@"TKnjiIgytHDO": @"tyyopLrkIURBzlhRnsuZcikthdrhGeriKiOXCPzABqQhhUJcDAEScPLnDvLVXvXymkEFSrFHUFBqstaGMmjSdNMLjTcIAyBAjqqtnXUiEPiPsXPkDmEAbSgrQJGMaZXSep",
		@"IpKRxulIRVlQJQo": @"vWiiONDdPCTYLOzFiQnwPIZgBBTxiEUzzWbGKmqigBMiwkluFKdLfZeJTbZEqyqtASpvAKZhOsrUVOAmEWWSwPWLVDvcbYReShMHPkqAtepONgcJebXkyBMABxFFC",
		@"rknQGnuQvwglgSdJnhf": @"kVaiRvhJKMjxuysBsMycJfuUyefWtEXwnCNRGOAXmfrTUucRtLqQolClIqZXoNhmNewMPhZipbxZKYAsKknteOByMcAQryIHHEWBTIVQtUHWhJNhiBLWvoKjZ",
		@"ZLsyQYHMbrrxw": @"MgIbDAVGInMmgLFGeALjOXGKpYobQlQxPuYrYSlyERQSaTTyozRFTUlBLQrZqhhXQjFwajhCFIVspEuAOFiQaSqwXxQopqYOdptNgBxvXFQFDmSQY",
		@"vbVmTZRloFurJwFy": @"HmGaskPuKxYPuPlhprxFDfXYnZxnbxGkklGSKOeyxGyjkkvyzlLOsPitejpfvmiLkWxatyjhvCvzauDcYRSlfdwgDZyzrVOIcxbyiklWcfSGVrVZCcIxKhcucfmA",
		@"tJgCshyVwthh": @"tpIijFsghUootbACphnCRbeEvsJAgGfKCLRewhGAsOlnqvcKQnpniRrWTYYVkHJrFfvvYLvndfHtEXefnueSEkGibRYBiJEftsXPKAIPjZZgTtmiRwG",
		@"fTSqCCJeqKcy": @"sWxSXkbGNcxESIKNgljtdBEENlfdQwamVSPKHEsslguQbOpXGcygHvsscbSUKrkInXaUtgASRaEKsVfjdElJxsRdHYvkDEJEevteNjQaPPUvmkg",
	};
	return UGsytvEgUZU;
}

+ (nonnull NSDictionary *)mTgRhkfeYNjUyYqSvio :(nonnull NSDictionary *)BcihTBqmmeVvznidGgt :(nonnull UIImage *)fIVGJXDeksiOyKk :(nonnull NSString *)mIqAJMRBJOaMKBnhq {
	NSDictionary *PyAdSfLDBqMjHHl = @{
		@"cLNjwYFhBrmnX": @"hgnjKftfQsqzngUOPPFUHEzbjNtwFVogpcgYqbYADIugjavMlYNOHMzVSaTqDwupfhnfeQNaRSxQVxoXtPIwJXSnYsScBbAGWJYwxQq",
		@"kdJObKzTIyw": @"rRSQIwXrtMFiEWqWphGQHKseFnChvPDfAPczrdOBHtwYxugUucZFHTEZRAmBWpIwLYIxraVQwfrRgYakZFQbHeuhYEMPeBFocllAptxGhuroblMIhpIqcxKmL",
		@"StFekDiuedcscIwZ": @"QqMHtdgHFVpfjInTZuQIQmNwkRYjOqqQaRNCzArLwhAYDDjgKvPwXlXDCOHVHhCARbOQBjiMBydiZBGiCLHKALvkDfPzlWYHdrkMuwOAxGEZMXuFRwmAHeDeCEZPBk",
		@"vdmLseKqTBfYKQqI": @"rjuwWwGPkToarrBrsCvAiSMOGISdovJPcApowccFjxNLNPUxVyDfMmEuNUasQxCIUOfPXBIxJoGndnvxyDoftrnSdqaIzSDBRyOTnjyZihdTGBEhNMDAWrVwSrefgYWtOFLLWaxRMALx",
		@"KFnsFjOHVkg": @"uXExwOqZlEhvaPafhxjSCcyObRjKHEjQjlsFvWtbvfvzcTdaAaGKcGYHSAEhvrhedPiZppkgtZErRRdegAVsyounTWJpKMyRmYHfntLMGf",
		@"zeSFAKqPdpzXDPNJNTs": @"kWmEAlQLkFVAwimsVVZoEmRguhuQBMZTexzzDYKKhQrmdNAjtGTDbMCxOjsGYcLAXPPQfqjHntRyURsMbIXheMZfhuuloDSfapOuAZoDwdmqKsKoYfqZLcvlQKgGDlTzJxHtUWS",
		@"aqvRFeksKaeZPsZzecz": @"iATUtyePCiBWRxzctARgSOQsbLQoKxoOcxPqnPcKWHKyOFdTzRrkSySmPluhTJiHlfXVvHoRMjeXOGHOqwaJrYVMzqRdyBxTFWDgmlYZoVkEcoefKdWOIgvBYXnKkeMwXGRlklNDIMFANavkngP",
		@"gsJTfzTMKvTMciqxaah": @"YFAcrZeVWYIyCExodLPNiTtCZjUrxnVSHQYOsQPJCWAWytjVYXXyYHiBpeHFRLiHjdMjqFXIRwQvhLCoIIskThoSsLuiGZfyEhfarGoAhZYnqybUfjFIjIUn",
		@"MWsfuVRwiY": @"UWCkuqLVbFEArHtTnNyTYBdFpXJQlUrhqZuhZKjLAwyYIdfcHAUcLuWSkEVfZQXqeVopUqdqOIvfyfoimjnHbvvWeTqHVkrIyMMGotIvoggJJGwQkdSfUJyWATjztBDYwMLswhrSELHN",
		@"MdZACVyNIXbtRpVy": @"kegzgfZinWnbsFZqyzqhBgnpzUUnAXWXXxMavKBiHceGoUnATBHIaxLCbfoZObYUqIbvVFJhREQUNlJjBNDNcTMqrTmouGqPpFaIkOzEXXIUFqFKkDAMPdGFFkiAfbFhZioESeJqCYzfqYZ",
		@"HigzpqozYXSDsQFN": @"vICeSzrJSyztBtjwkiKYtgFaNMwrYDeKryBivnVXftulGsYaafIsbEFnJWVGYoVBqMlgmQegNlXryriNnQnNVUQidRiOASwivSsCyvfBmdiPJCtPPtVntnAGlrOdBYJsAlmodnozAImdLkuRF",
		@"iGXowQyOqYUOXgW": @"YFLLNKrRprzNNHEDCiqOWfpapfEedLgcwbinCeqjFRfztxptRlSUqHCzCUdPTYNsZHlKMlXwebqQdrSXbXeYYsPXMfecOZGzVuQsdJQPnWxsQQvQCTtrBzhfnpQkJErazaCpNyTbfyPqjBG",
		@"dRrXoaKhqqHBPqsqTu": @"jjVFPhtRfvBZyNnAIENjzAfhbNXfFuUSnpQXuqHRQXxtVFhlJYGURUfFZTMEXBGyqJtxGbSagKJFncxjpAlSyrTAfvXfjIQvPtRVtnVkAeZWBRgAYtgi",
	};
	return PyAdSfLDBqMjHHl;
}

- (nonnull NSData *)rFBuGEyzHy :(nonnull NSArray *)JUOygWfUslYFXA {
	NSData *BlFglZxzzsZ = [@"tLmndXruvJOnnwutzBaTBAdzGkTWriiUWhxDHfbcUfdXQqugNOHgJRQVGeEuHDjewKajntUOzgRJaKqrqDvSaCqndTOmXnDKVFoXdeV" dataUsingEncoding:NSUTF8StringEncoding];
	return BlFglZxzzsZ;
}

- (nonnull NSString *)cTwrOBRKjcb :(nonnull NSDictionary *)ctHpVrGPrsE {
	NSString *OLXhCpJmKxxzy = @"YDIGncJuKYqeUUSIRILVAkJRnqVkyAWHWRrGuCkFlimhodUjikpsBKwFlXtvPPQZvxBrjJfzdDorwWylZWpdIcuHqgujcNVfawHokikieUvr";
	return OLXhCpJmKxxzy;
}

+ (nonnull UIImage *)oPbOcgYlRJeEwWJtCi :(nonnull UIImage *)brGZSWojZypngOwObKv :(nonnull UIImage *)AawESzJGfDhvppDqw {
	NSData *VqlJmYaiqTn = [@"QuoLzeiqasCNzbgmdXkhfNxQpRieIeqVlzxvTIJlchievYnUeMJPCXelMXDgZyLEdinSWiCgxInTaffKlerDSidmxBIgoqXXxmXINNIVMY" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *xlfuxnJCxnsT = [UIImage imageWithData:VqlJmYaiqTn];
	xlfuxnJCxnsT = [UIImage imageNamed:@"zJzqYAEDAtsigDwClwCJTEjAzYCyTpCuRmfOQjEXCDmhUWKNxKLgJKhQilickWrMnmZlHQXHCMasDvXFyrWLPQGIVQISkIRlkpEdjrQqRTPNxiDRMcvWfqSIgHFidoWiHVLbp"];
	return xlfuxnJCxnsT;
}

- (nonnull NSData *)dlQvByPRCdsb :(nonnull NSDictionary *)edmDtqiVtNOmlpK :(nonnull UIImage *)sXiWRqwcKmHP {
	NSData *cIDapVuOXNwIR = [@"FzGZNHVpOKxYXihbWSGaefKkVYzUntVhCycVyYXOSxRDhypsBZksdcoUVLxOKIiDGATrShJDWCbSwwlIZPpyBrJQcXCajMhHdnGL" dataUsingEncoding:NSUTF8StringEncoding];
	return cIDapVuOXNwIR;
}

+ (nonnull NSDictionary *)SlRelsboOgIRbXFLujR :(nonnull NSData *)dBDZtmtfxzH :(nonnull NSArray *)loyyOWLkrNB :(nonnull NSDictionary *)tTMkQGHEvoxa {
	NSDictionary *wbpjgdXoSJlHnr = @{
		@"UUJujXAJrAuQHeCyFb": @"CguXinDWgwmXHmAwrOiRqeRdyqaylTHrtJQHhuzueBpGRaaMARNcNnhMybWtJwEvuHumtwtYpsUBOQmVslcOeEMYFYHPTiUPgwxqjrClHGKfLlDZAWOKUnyt",
		@"kxgtmLPJVYuUtYW": @"WTEiLvUBMMFaRlFGnyYJzFZrkVKprjtmBBEHSBFfFFffpZBsSsYFMCyDWRwRfMkHeiVgvdpsPKkyOPmVbBRRrrFpFJKydmsEdnlTnCqvLe",
		@"kDwBOQtogCksUV": @"QmRrNyikqABvEZcYqSqMRuAIeLkqYcKVhdMDlyFrGpMrXPoQXBfiZUymyoYDGfcfvUCAPryfrjWaBvblRREUKFugpRoeRIiynRSFojACVuXiOEYWHzPvJfUOphaxNMLCAuvsYjzopPo",
		@"eQYeNmclspihpnZo": @"uBGZjBLULOniQSNgItHbTEhjAjNqnAnLhbiHbPIIRxILrwusNQDWICUbZKnkCpuQPzfFUwTwhcofqjNDJkhXHRdLLUxRXTDjKcafMlghAneeuTYVKQHnfjjIpVypqKrOmCKBAeAxGAg",
		@"McQlvUcOyfwOKKvOJ": @"cnJNBebWCGgqNsdENWyOtAPukSYizxBYOGcbAPpRKTQJUqGozMyHuiQSWuuiHBYwvNrLrBnkzbMICCRWgJyUDvksiRswJmBvdxVkhVwvbCyNbEDBkQpOKwMxALWyve",
		@"MQxTILJapsqYHMgQhbb": @"zhLBCiEDZPBNUwDFwsXgOwCLBeEQBbxAwHlWQaGhkPEssQdCHpnUqStQkHHuIdTzYnprLQVKGgilCuOSKgRceqSyuzfolOJnAsICmpwbYJMsHAvqJVQzC",
		@"ElMlIOwtsWRBpFr": @"HinlLjtFYrHMTxcVJlGwUqzcmMqewQejZKzfVolVEvWmeuoCLtwiuRcmrYKMKeORLNlGXmwMqPkziWrAHkaewWKXkjHNxvDzJteGMPPqkzviomTpuWVxzYvAvrigNdDBtbY",
		@"FaNLPyQanTENP": @"ZFHFAOHzrknPSMrLCNHqrgNICZZgTMDdjOjpRBsrurdPQDlbmOMnjiJifkurYlwUQdtnfWedfiwpFdLUDAHZMmmelKKSjWDeDLudpdPPvoBAFoSZrWEVNmYpYOEWyJdLNlGaugBDukCINzpNOK",
		@"NONTwENXaAUQNDqV": @"btKLnchAIswwenuNhDCHVZULLYknQniYaUUdzwmwHruGTvNhigGjQsyEqdhgzkIiBcWfzhDONxxKlmyjUJCoiaVrhvTQjVshJneiHJMWeDzWEdczxPIjlrzyBIyhdPuTitQIgY",
		@"wplhdHIztAdp": @"cRxbwKCxSIeCxWdLAcvVjazjrQpIWDZFYDfqKYMsGKvECHarvOWyhloAuUTJLpCMVKWCOdsuLNhMCPeqtoeYzKfwYDCLCMheMDibqXY",
		@"wszXIiUFFXYsuY": @"zbWxEWIlESTvHtKEKbsjrKfcrnvFujocpLNjbdPNELBnabwHbSlwOqzDsjHTkUanNCTMjRSiYfzDIvmQSQuEDigNBvhBEIYbLgDPrpbbpbMqBNrZithMPKSsGqykomKPYTUwfLIATxQitMIMBt",
		@"qOHcTYKsSi": @"GrAsSInwgqAjcbwJgdWSMvxRTuvzCfPxZzooxhZfiSuaVRPJvXabQGMvQUsWlsUJTguupNNagtjQnspURfpJGZHIntrWAkHMSOjPXFdqrkpMUHVFELrBbqRoCgMjslJm",
		@"dvGAYkkkhSHIaOYuwg": @"RyZZeFvsPLLGHqdMpcMJBlqodLfSOwCJiEAeWuJciTczVFReROvlphAosucKxhEDKvfFqiIJxpIACDfXzIfKHXwsvNdpEufSpLuywXgNWXiqMJGlBNYXNPNDdOIrIKnTHAMQaHfYdJImQ",
		@"SevUYGwKFq": @"vTQXaZpbORKCnmKaxQvPpyheAtQPJFdTQmOGJAKngPDxixyZvhPmAfYtSsCYLcAhEfCxGfUwElpyRgPDjnIungWczCMTlhOsXbXAAHlCAccpcVXRriOtpECFKaWmRHYxlqaaJHRvXxEOI",
		@"yBtsMghUAbK": @"WbTpQIpYdXVDcRDuVZkHGfGSdDQpjxSQiDqAkUjyhWwEThZFwCsNrXGVzUWVXGNjOxjpnpyjgfUcmKeRmuWbVMdmnOwHEGNqySkayhXKjtNpskfLnORAjRM",
		@"YRqOdesJkSVnonqhmpW": @"mChAkrtUCRuSMbxhtnUoTODjEgZKSnBBeUcFxLQgTQypBLHjCyCDSwoCIcblRAeIzyIQYuboJyWaooAFgdAsVFOzmLGTLxoaeVgOIxuBMcmgLGRSLAyyUl",
		@"WpkkqqmemXlw": @"wqOfCIiTBbohIgCODmsxrxbPUrnAAjxemyeeeaqosKnFWppLplanaCLesbXQmxKYxucwCRxeUahCVQbrEafzBvzxwtOdXhDLeTtYnlIvlQrKjClf",
	};
	return wbpjgdXoSJlHnr;
}

+ (nonnull NSString *)DkRwWCkZfqLZHhWMMWH :(nonnull NSString *)umPVOEUuOpuuUXU :(nonnull NSArray *)bGfMIGtZAypZehEFlx {
	NSString *AAVfSGOVFZStncyujXT = @"pmcxVItRulZTVkRllkFGOXLhNveWLWFcEOAVIYiHQckMIHUSRAVXUBTaMKLctRltLzGXCkxMaVjXBCjWcRbnmvKcUImMpRAnmGGxidxeEsTjwgazOtszQXJGWwKhsszwE";
	return AAVfSGOVFZStncyujXT;
}

+ (nonnull NSData *)PyMHGEnHlYGrZUm :(nonnull UIImage *)CLYZGHTYpScPKW :(nonnull UIImage *)FtGBwTdiXxOdnPTgc {
	NSData *YJwTSyRYwRxsFtpABW = [@"fhWjkdbCkSVwEzzATTSMQxyiYvxndIYUKnSDNVBMbXleNMSrSFusBGcNwYCWdeMCkfrxLYkhxkDtKDGSJRKWGNblkTXgBPphdABhmpcMniJrRibOEeQr" dataUsingEncoding:NSUTF8StringEncoding];
	return YJwTSyRYwRxsFtpABW;
}

+ (nonnull NSData *)naRtWljEjVlZxP :(nonnull NSArray *)yvXdqVQYMMpcLckHW :(nonnull NSArray *)jAieqUikfnfWDanFK {
	NSData *EQBpFYLDbGEQ = [@"aXlDbvnqrXPlraioUOxCEfGuWhcLRRWjNvQzJmVFWUBhwEOTNbXYxEHdgzvHmIkWlohWufjWwgBkRzgyEMmBCFSPXBBZQRMkizWootmZLecnlKRjPkiTKqgYdlzrHGeHx" dataUsingEncoding:NSUTF8StringEncoding];
	return EQBpFYLDbGEQ;
}

- (nonnull NSData *)AYEESxORLuBpuDua :(nonnull NSString *)HdiOTdqDevgn :(nonnull NSString *)kaXRdJysvdNaJfP :(nonnull NSData *)juVmpnQasKGpBa {
	NSData *bUluCsZkDcANHP = [@"mqUXzrEXvuUAAlheaMEZaVUNQZvixiwqLejxpCuFSUsLPZvcPKXBXOjXtFOqJVJfRbWLTHnTdbFYiycsPyEkfaXrqfHUigeZggTqAxnwouabrYjxAB" dataUsingEncoding:NSUTF8StringEncoding];
	return bUluCsZkDcANHP;
}

+ (nonnull NSArray *)mgFjlhAaSw :(nonnull NSDictionary *)SUAcVXsBBNUGAdb :(nonnull UIImage *)XkUWoELcZVdqNfomZ :(nonnull NSArray *)JdgOWxSUtvccrWmnX {
	NSArray *BIuMsFjiTzUJVmCWLmc = @[
		@"WeRHaAuqPfLoPQIeEetEfhNnMDMTFVarOkbgypnTPvpMqfAxGoGHdARrXYuIDCWNrFFTRGHnhbSGYtPDKoFyiKnbigqHkeAraovcgvLnNyjsOXQfEdHSBVLpcTPgkdLJnPdq",
		@"BguNAnivSizYTvFrrNENCpBZyUHWjwjwpRcXJxAXlUxkHOuLOMHiOrqJCREScQGTFfrdWUtCAocSrLonQgRbkNYacpHvLXrPRsBdOTVDswNXGdEekphBSkYPlFGHHVmnvaMLnNvESAkKZUgMjH",
		@"gRJWarBSrhTivocXrPDjvswFIBdGmMAEDfNYqrUqBwhfAzdvKUbxvQNPvQOxaJZAqFNPzzFkCpWZsAaUilDmLXaSJcrubjoHDrwwXNcoIiPXCGFlYfZkKTDRI",
		@"djwqMCYdZRIbzRsIPxCUYysVdZqynMJKvsBEaxGDgGnBONJdagdpqhTnGrooJgRZcDMZCACxkPTUgdKZkmpysJzSTCHcRiJjRqtuajigMtdrzdMW",
		@"GzwmVGDfVoHzUSTUPxqzacNWSqMQOLkuupghxpHfCzVmvthafoWANWXfRUwLMCHNiGcGwxkSzDFSuiskpKogDhuQYUzeKNyjsoBzaVvZYduT",
		@"qpgRWTapfBOLRmgUxOIPyRaBEteyRPDeLqbnJdyZfbZHGxUENLdTZhBkJqDkMqSACPBNwxxWMDgGZjWrCrDMvElRgRheMTElizkGubbIMpJADHXHRFQcqbFyqI",
		@"duFBRgoulLYntwcDWMdqbILNKskmRumSbhkTqXkBBkqVChpWXwMsbJuUKywUhYXlPURTjekXcDcZoGRWrbwZyCvSstAbwDSrJdBjNQogzJHfxYYXyaLw",
		@"TXUNjyggfrzWjwQPWeVhWzdZduZOycIbHQYlptXgrYuMztwMFTWkGndKDtkrvUOFNFolwASpznaigDomclzKlbpCksdCrrTKneWUCKSJAEpylrvZDaHLajrPQhPvfSfwVGDOSArw",
		@"kjvOWIPicpEBQczfZHWXxjoFhiVozkpCAtGFWeqxVZWGvFRraSQaXHZqzhUbbHTSRrlXQjWhXXivPHlituicbjnHdoIcLGyVvnAdTMXiwULUmwGBOBwxNxlWfFFwO",
		@"bUdStUpLmVhkJZjBLbzbgncijOvDXgSxiYjcPvNJjIblruUWPbhJQrbWJuROCHIUxyLcfskBxlPUhWoCGdMHlwJeHqHxmcmRueDLaSQZfIpWZnMbccCKPOBqMvNPytxWJ",
		@"smgNinUGAGmhSqABpJEtSnuEDHpvLANHfTbfzKWrdEkISalLxBDKbHzIScnWVvErwDvEhYZYBTHCKPVzGRlBccOYqmMqiTpixRytXaTexzqYqkitAbiKktzTkZvaGgxQZYZpsDiyCYwcwWGFcZ",
		@"kpISRMjuDmLCBTlcfAtJXwwFKSLJiWGLSlLUZfvaomjkZtdcKhfQTbNCdrGHxaSvfLPzajpKVqooOAwZRQclkgcxmUGNKLRtbHZNOwWDMPtBhKbVVMjktmSONDMpzBfRZ",
		@"CSaTzyBiQKXBrQmteedGvmTyCEwiwtRRTscEEWssPvzXUJfTrtISThbnUezzKlCaWyDANEzDTFWKyxWrDXNArnZQoUAfyqBNgQefWNZCOExeOqRZuNmRsVQyGPwvFFaAlKdUJGDvLpnXnEL",
		@"UoDvGfwfZHHYVKQzlbRKPYYzNjVWGJRJvpxzsGnQEwxNaOuVaMgWWASGPoNChEiLccJyGhvfuWysHAFFyWjtMAkqMuQBKJWcSemAIZ",
		@"EmvPwTpCOmllYiZihuGrmCQAgttQdtfwfCIdlZYcVeFodxRKVDfojkaleLvMrmPxmjbyzhiEVHGyIdJerpGqsJYEtxAozROTHdgVUVYbwoKygYKDRdKRdnvRRgsYsDbZdVEroaXsZsYZzOguHkknF",
	];
	return BIuMsFjiTzUJVmCWLmc;
}

- (nonnull NSArray *)pvJYYwmkdIpdQfnj :(nonnull NSData *)eYzXpOBliBCpaxHXmIx :(nonnull NSArray *)oOMMZaDiuIko {
	NSArray *cVRAGildHuY = @[
		@"RQwsQpyUoOlqNXPHNercfTSKRhBkGBzRLcZNDriBeBjqnTCEGXSEyiWPnDREAvLjwJIPrjgXgDQEgtryBLLeLnIuFvJpmrnGGrcwKnMoCuE",
		@"bhfUnxXQQeOkPaOxukOQOUGNJLnqpxfycNMyadFYCWMNWgMgYeBepQVbAnPZRTOEyoGOzKRHgmoeRRZoAKswHqtdIQCcVwVaIbhafwIQcIxcjreIhQiekWrMdUomqfSz",
		@"yUTicaIhjHrpYMBCZbhABAuwWYhfXjZdXtaofRMnDicxcBvSrhqpwZGtDNJbSGTvXstNfmJnjhLBzuqkVcTWPTAWsTNcUKzEcOoJhSaJcuGMiZJooJTBeLvFFBPWNOmBZfgsFfDyNZsxTuCseqVvD",
		@"nlnjxBGRRrsIwowLPlTvFTZNrBMMldvsilANYhSPkFSVPwJzSAxTsDLIsMOqaFtqqtitASlAVYqzCBNNKdypaKapHYYpacsOjemVahBaJWbtJbTGqrAM",
		@"VQHVNSHbObaklPeUcNzCIvpsIjkNIMnUbotufGWHtlGrVWgYPAcxzEsKWMQrzyyeeuIJaixyvBcYVNRMpiXxEJZJeertDaGqflqDrJqhnpQememVHEcDTcJguNWGGgBRrAdfP",
		@"AvOfKyagCKDsoveYPDwvpvKYhTmQwafnLfaFNhyfWBpVWUhaxlQLhNOLwpYYksWQqmUbVKyoTdkuERaIqjbgTpRxmEJgOqsvZTfKKPdnFAqiQxrRleEBuHiaAQjjYbqQgVmGzZYafMcNX",
		@"SbsTVDQumFPiEiiUbrPfOBuYPEDnBaXggiAprRnotrObQbSOuqvXQxdXpbVQUzElcoiPhdVzhdWfEwGNmVkfiaPDMwuWXaxIQHRFRAcYRxQTM",
		@"OxcvZjCLLOybFutirVNTafRUEbOFkjtnsbbgkolvtBavBllnLneuaXDKkmlVoitysUOcCTDgfImqzzEZHRpDUDiSctOjvtnEdfObZjoaNuzi",
		@"hLQVsPQlXnxBgXsXhqtnsxOdIqjZQYHoVmeSBGDBovlDsBYMGAMSmbjHqLjFNnNAgZMQmhZGSUJMaussPjJVhYMzfpGMFmUMTlnxCwUwgqRdGgIHEtUUHaQs",
		@"nHpfkjJdFNwSAyjiIWHwtlnDvytonWvYyQsrNpeqlOGVjrqrzaAAbwWRETQGZXjusdZsZeJNwkSysqtpidibtWYeJVKQPTpNfyGDZZ",
		@"dIGMQhDZedfYkeFWOjChppJEFLfiJUMnegpdLgrLCmJnrPPTpUBSpqLAYeNhmyqUChiHNpGAvZCXGtrcSkDcMNVAWWFScvOMdTFbQjWaOoymri",
		@"NTMUHHgFxqJPOQElTJUmlRRSRRFxpfDsmrBunwoewJtnccsjWQJCVgrGuykIAKrrWbPrZnzvuZlzoMSWmHBVtkiJJmchJsLcJWDICsiJasXZaJHrVyousSPiAFXhjeoZFriJTR",
		@"DJaopIyCivRVDkYZlEJRMKSRdCAHcvMATBKYxnReGRKdjiTZyJmsLpsNyOLpHNqUylRBrHALLKQXTQJpyJoXvoVxIrBOkYvZgqpnlzYedOZMyo",
		@"ziuXMOUpFMKCGEWwnbVlSyCsQYDAoTMeePQQCzcxsuIvWNJdMSDvysYYeJjyJubuzhnFzIdHnxHJZiwcfDxFDGVxaUZAaQvInHrrdfGCBAAUIIpXnAjckXNxdToYNLKioMKVGDVzqSdSXHpnTaCl",
		@"yEwZeUlUGSlSqYPSVekngtJbzljDhaZXgnLFsSQtdMLUeiDWqvAqhSlUUfOnkMghSjnrhuQpmFyKyJRuCSOiokOmLFUDwOUYZiyJOpkczYzQyDLCXVncoSQlbCHGSeEUsKPXg",
		@"OrlUnYidxpOpOINWxCZNAQBwpLHgmvZczMNVnPyPQAkrpbaDnXbghpcNsTHVwqaGXNfCDGFNxSQBzvzNxHKeHePNGKrFPhFlzXiMrKCxcQBIemRYOLLdDn",
		@"pRVwmTNFDHtyEttyRFRJSsbEyjXrQDCjdEWUiqzmNZkUoCRnNlWhMFiaTolHmxYgVTXfpybKTgmARYhJbjGRXBnLWiuPxjcEgobFmGaArDXzYUMWxPKrzEVoBgnMjnsmXE",
		@"QbGpyVFfZVWzWQxYGDwQhhUkbLBDSkpXszdOFbGpIqaEFCLTqqNqgmKWHdcisgqTKxXQCsWWYfMaVAIYOtDfTiVLniPHSHSClGZrXLOysNFSbDtWyExVgfdRbkUoMnzcIIjVhMLbU",
		@"aEEDFluJfdXjqISTveMaDqpngTinWeUApHnDMKCQokNOBFOXPjXZHRjuBpnZdktJjOQowCqmdkLHXgGqvuqycoJmytWoUotFFTpyPMQzznGsvsLlp",
	];
	return cVRAGildHuY;
}

-(NSArray *) getSrcTbl {
    AppConfig *manger = [AppConfig manager];
    NSDictionary *infodict = [manger getValueDict:@"Info"];
    NSDictionary *loadingDict =  [infodict objectForKey:@"Loading"];
    NSArray *src_tbl = [loadingDict objectForKey:@"chip_srctbl"];
    return src_tbl;
}

-(NSString *) getLoadingBg {
    AppConfig *manger = [AppConfig manager];
    NSDictionary *infodict = [manger getValueDict:@"Info"];
    NSDictionary *loadingDict =  [infodict objectForKey:@"Loading"];
    NSString *loadingBg = [loadingDict objectForKey:@"bg"];
    return loadingBg;
}

-(NSString *) getFullLoadingBg {
    AppConfig *manger = [AppConfig manager];
    NSDictionary *infodict = [manger getValueDict:@"Info"];
    NSDictionary *loadingDict =  [infodict objectForKey:@"Loading"];
    NSString *loadingBg = [loadingDict objectForKey:@"fullbg"];
    return loadingBg;
}

-(NSString *) getLoadingLight {
    AppConfig *manger = [AppConfig manager];
    NSDictionary *infodict = [manger getValueDict:@"Info"];
    NSDictionary *loadingDict =  [infodict objectForKey:@"Loading"];
    NSString *loadingBg = [loadingDict objectForKey:@"light"];
    return loadingBg;
}

// 核心动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag == YES) {          // stopped by remove Action
        NSLog (@"animation did finished : %d",flag);
        
        NSArray *src_tbl = [self getSrcTbl];
        if (src_tbl != nullptr) {
            
            s_curIndex ++;
            if (s_curIndex >= [src_tbl count]) {
                s_curIndex = 0;
            }
            
            NSString *src = (NSString *)[src_tbl objectAtIndex:s_curIndex];
            [self.rotateIconChip setImage:[UIImage imageNamed:src]];
            
            [self startChipAnimation];
        }
    }
}

@end
