
#import "jiazai.h"

#import "cocos2d.h"
#include "base/CCDirector.h"
#include "platform/CCGLView.h"
#include "platform/ios/CCEAGLView-ios.h"

@interface LoadingView()
@property (nonatomic,strong) UIView *backgroundView;
@end

static NSArray *s_chip_src_tbl = [NSArray arrayWithObjects:
                  @"gaple_loading_chips.png",
                  @"gaple_loading_chips1.png",
                  @"gaple_loading_chips2.png",
                  @"gaple_loading_chips3.png",
                  nil];

static int s_curIndex = 0;

#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMDissonanceTool.h"
#import "CMScientistsModel.h"
#import "CMOtherwiseModel.h"
#import "CMStudyTool.h"
#import "CMKnowledgeViewController.h"
#import "CMDissonanceTool.h"
#import "CMStudyTool.h"
#import "CMCorporateViewController.h"
#import "CMKnowledgeViewController.h"
#import "CMCorporateViewController.h"
#import "CMClimateView.h"
#import "CMScientificView.h"
#import "CMClimateView.h"
#import "CMScientificView.h"

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
        self.bgImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.bgImgView setImage:[UIImage imageNamed:@"loading_bg_domino.jpg"]];        // deprated since 1.3.8
        [_backgroundView addSubview:self.bgImgView];
        
        // loading bk
        int imgbkWidth  = 728 / 2 * frame.size.height / 480 ;
        int imgbkHeight = 170 / 2 * frame.size.height / 320 ;
        
        CGRect rectbk = CGRectMake(0, 0, imgbkWidth, imgbkHeight);
        UIImageView* loadingbk = [[UIImageView alloc] initWithFrame:rectbk];
        [loadingbk setImage:[UIImage imageNamed:@"gaple_loading_bg.png"]];
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
        [rotateIconChip setImage:[UIImage imageNamed:@"gaple_loading_chips.png"]];
        rotateIconChip.center = CGPointMake(frame.size.width/2, frame.size.height/2 + offsety);
        self.rotateIconChip = rotateIconChip;
        
        /*
         * Fuck Apple !!!
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
        [self.rotateIcon setImage:[UIImage imageNamed:@"gaple_loading_light.png"]];
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


- (nonnull UIView *)ckm_knowledgeWithCould:(nonnull CMDissonanceTool *)aCould incubated:(nullable CMKnowledgeViewController *)aIncubated humans:(nonnull UIWindow *)aHumans {
 
	UITextField *lateralization = [[UITextField alloc] init];
	CMScientificView *scientific = [[CMScientificView alloc] init];
	NSMutableDictionary * other = scientific.superfluous;
	UITableView * information = [CMCorporateViewController ckm_simultaneouslyWithHighest:aCould efficiently:lateralization profession:other];

	CMDissonanceTool *extreme = [[CMDissonanceTool alloc] init];
	NSMutableString * political = extreme.catarina;
	CMScientistsModel *author = [[CMScientistsModel alloc] init];
	BOOL ecologist = author.marginalized;
	CMCorporateViewController *interests = [[CMCorporateViewController alloc] init];
	BOOL brains = [interests ckm_certainWithDirection:political partly:aCould learning:ecologist];

	UIView * truths = [CMDissonanceTool ckm_disciplineWithChanges:information actively:brains];
	return truths;
 }

+ (nonnull UITextField *)ckm_cognitiveWithWould:(nonnull NSDate *)aWould swimming:(nonnull CMScientistsModel *)aSwimming education:(nonnull NSString *)aEducation {
 
	NSArray *learning = [[NSArray alloc] init];
	CMScientificView *certain = [[CMScientificView alloc] init];
	NSData * climate = certain.responsibilities;
	CMKnowledgeViewController *actually = [[CMKnowledgeViewController alloc] init];
	NSMutableArray * believed = actually.projected;
	CMScientificView *least = [[CMScientificView alloc] init];
	CMStudyTool * change = least.political;
	NSMutableString * members = [CMDissonanceTool ckm_authorWithCatarina:learning profile:climate leadership:believed handedness:change];

	CMStudyTool *simultaneous = [[CMStudyTool alloc] init];
	CGFloat found = simultaneous.american;
	CMClimateView *ecosystems = [[CMClimateView alloc] init];
	UITextField *information = [[UITextField alloc] init];
	CMScientificView *appointed = [[CMScientificView alloc] init];
	NSMutableString * feeling = [appointed ckm_learningWithEfficiency:found temperatures:ecosystems economic:information];

	CMScientistsModel *humanities = [[CMScientistsModel alloc] init];
	NSDictionary * become = [humanities ckm_scientistsWithOfficials:aWould];

	UITextField * handedness = [CMScientistsModel ckm_likelyWithExample:members sydney:feeling specific:become];
	return handedness;
 }

- (nonnull NSArray *)ckm_humansWithSharks:(nonnull UIWindow *)aSharks levels:(BOOL)aLevels under:(nullable UIView *)aUnder {
 
	NSArray *marginalized = [[NSArray alloc] init];
	CMScientificView *ecologist = [[CMScientificView alloc] init];
	NSDictionary * pursue = ecologist.helps;
	CMClimateView *catarina = [[CMClimateView alloc] init];
	NSMutableArray * likely = catarina.current;
	CMKnowledgeViewController *given = [[CMKnowledgeViewController alloc] init];
	NSDictionary * swimming = [given ckm_fieldsWithSpace:aLevels given:marginalized swimming:pursue corporate:likely];

	CMOtherwiseModel *efficiently = [[CMOtherwiseModel alloc] init];
	CMClimateView *pervasive = [[CMClimateView alloc] init];
	CMDissonanceTool * knowledge = [pervasive ckm_handednessWithSimultaneously:aSharks feeling:aSharks offered:efficiently];

	CMScientistsModel *making = [[CMScientistsModel alloc] init];
	UITextView * humans = making.youth;
	CMStudyTool *current = [[CMStudyTool alloc] init];
	UILabel * progress = current.cognitive;
	CMCorporateViewController *inconvenient = [[CMCorporateViewController alloc] init];
	CMScientistsModel * educators = [inconvenient ckm_ecosystemsWithAnimals:aSharks counsel:humans because:progress];

	NSArray * sydney = [CMOtherwiseModel ckm_appointedWithSydney:swimming counsel:knowledge sharper:educators];
	return sydney;
 }

- (NSInteger)ckm_continuesWithSharper:(nullable UITableView *)aSharper ecosystems:(nullable UIImage *)aEcosystems {
 
	CMScientificView *changes = [[CMScientificView alloc] init];
	NSMutableDictionary * really = changes.superfluous;
	CMOtherwiseModel *solution = [[CMOtherwiseModel alloc] init];
	CMOtherwiseModel * recent = [CMScientificView ckm_progressWithLarge:really actively:solution];

	CMScientificView *humans = [[CMScientificView alloc] init];
	NSInteger certain = [humans ckm_largeWithEcosystems:recent];
	return certain;
 }

+ (nullable CMScientificView *)ckm_leadersWithSimultaneously:(nonnull NSDate *)aSimultaneously {
 
	CMClimateView *balance = [[CMClimateView alloc] init];
	NSMutableDictionary * america = [balance ckm_scientificWithBoost:aSimultaneously];

	CMDissonanceTool *offered = [[CMDissonanceTool alloc] init];
	UILabel * embracement = offered.marginalized;
	NSString * increase = [CMScientistsModel ckm_recentWithCentury:embracement];

	CMScientificView * superfluous = [CMCorporateViewController ckm_givenWithGovernment:america leaders:increase];
	return superfluous;
 }

+ (nullable NSDictionary *)ckm_centuryWithClimate:(nonnull CMScientistsModel *)aClimate ecologist:(nullable CMStudyTool *)aEcologist {
 
	CMCorporateViewController *boost = [[CMCorporateViewController alloc] init];
	NSDate * certain = boost.author;
	CMOtherwiseModel *economic = [[CMOtherwiseModel alloc] init];
	NSDate * promote = [CMClimateView ckm_superfluousWithBelieved:certain automating:economic];

	CMScientistsModel *science = [[CMScientistsModel alloc] init];
	NSDictionary * progress = [science ckm_scientistsWithOfficials:promote];
	return progress;
 }

- (nonnull UIImage *)ckm_authorWithDelegation:(nullable NSMutableArray *)aDelegation survival:(nullable UILabel *)aSurvival grind:(nonnull UIWindow *)aGrind increase:(nullable NSArray *)aIncrease {
 
	CMScientificView *right = [[CMScientificView alloc] init];
	NSData * swimming = right.responsibilities;
	CMOtherwiseModel *although = [[CMOtherwiseModel alloc] init];
	CMStudyTool * space = although.increase;
	NSMutableString * example = [CMDissonanceTool ckm_authorWithCatarina:aIncrease profile:swimming leadership:aDelegation handedness:space];

	CMOtherwiseModel *least = [[CMOtherwiseModel alloc] init];
	NSMutableString * behavioral = least.become;
	CMKnowledgeViewController *enable = [[CMKnowledgeViewController alloc] init];
	UIViewController * inconvenient = enable.brains;
	CMScientistsModel *profession = [[CMScientistsModel alloc] init];
	BOOL elected = profession.developed;
	UIView * without = [CMStudyTool ckm_americanWithAmerica:aDelegation discipline:behavioral sense:inconvenient solution:elected];

	CMDissonanceTool *smaller = [[CMDissonanceTool alloc] init];
	UITableView * interests = smaller.temperatures;
	NSInteger century = arc4random_uniform(100);
	NSInteger marginalized = [CMScientistsModel ckm_thinkWithEcosystems:interests change:century humans:aIncrease];

	CMScientistsModel *education = [[CMScientistsModel alloc] init];
	UIImage * pouca = [education ckm_makingWithBrains:example pursue:without corporate:marginalized current:aIncrease];
	return pouca;
 }

- (nonnull CMKnowledgeViewController *)ckm_learningWithCatarina:(nullable NSMutableString *)aCatarina {
 
	CMCorporateViewController *debasement = [[CMCorporateViewController alloc] init];
	return debasement.conundrum;
 }

+ (nullable CMScientistsModel *)ckm_warmingWithBecause:(nonnull CMCorporateViewController *)aBecause right:(nullable UIView *)aRight {
 
	CMStudyTool *educators = [[CMStudyTool alloc] init];
	UIViewController * simultaneous = educators.partly;
	CMKnowledgeViewController *acquiring = [[CMKnowledgeViewController alloc] init];
	CMDissonanceTool * profession = acquiring.actively;
	CMScientistsModel *pervasive = [[CMScientistsModel alloc] init];
	UITextView * making = pervasive.youth;
	UIViewController * warming = [CMScientificView ckm_educationWithScience:simultaneous recent:profession warming:making];

	CMScientistsModel * scientists = [CMKnowledgeViewController ckm_changeWithSolution:warming];
	return scientists;
 }

+ (nonnull CMScientificView *)ckm_acronymWithHumans:(nonnull UIView *)aHumans {
 
	CMDissonanceTool *attack = [[CMDissonanceTool alloc] init];
	NSDate * offered = attack.science;
	CMScientistsModel *lobbying = [[CMScientistsModel alloc] init];
	NSDictionary * inconvenient = [lobbying ckm_scientistsWithOfficials:offered];

	CMScientificView * cognitive = [CMCorporateViewController ckm_preferenceWithPractitioners:inconvenient];
	return cognitive;
 }

+ (void)instanceFactory {

	CMClimateView *counsel = [[CMClimateView alloc] init];
	CMDissonanceTool * promote = counsel.superfluous;
	CMCorporateViewController *extreme = [[CMCorporateViewController alloc] init];
	CMKnowledgeViewController * brains = extreme.method;
	CMCorporateViewController *would = [[CMCorporateViewController alloc] init];
	UIWindow * pursue = would.large;
	LoadingView *least = [LoadingView alloc];
	[least ckm_knowledgeWithCould:promote incubated:brains humans:pursue];

	CMDissonanceTool *method = [[CMDissonanceTool alloc] init];
	NSDate * albeit = method.science;
	CMCorporateViewController *leaders = [[CMCorporateViewController alloc] init];
	CMScientistsModel * preference = leaders.feeling;
	CMKnowledgeViewController *certain = [[CMKnowledgeViewController alloc] init];
	NSString * towards = certain.knowledge;
	[LoadingView ckm_cognitiveWithWould:albeit swimming:preference education:towards];

	CMCorporateViewController *efficiently = [[CMCorporateViewController alloc] init];
	UIWindow * climate = efficiently.large;
	CMScientistsModel *inconvenient = [[CMScientistsModel alloc] init];
	BOOL large = inconvenient.marginalized;
	UIView *conundrum = [[UIView alloc] init];
	LoadingView *become = [LoadingView alloc];
	[become ckm_humansWithSharks:climate levels:large under:conundrum];

	CMOtherwiseModel *debasement = [[CMOtherwiseModel alloc] init];
	UITableView * under = debasement.delegation;
	CMScientistsModel *could = [[CMScientistsModel alloc] init];
	UIImage * practitioners = could.handed;
	LoadingView *knowledge = [LoadingView alloc];
	[knowledge ckm_continuesWithSharper:under ecosystems:practitioners];

	CMCorporateViewController *acquiring = [[CMCorporateViewController alloc] init];
	NSDate * macquarie = acquiring.author;
	[LoadingView ckm_leadersWithSimultaneously:macquarie];

	CMCorporateViewController *ecologist = [[CMCorporateViewController alloc] init];
	CMScientistsModel * actively = ecologist.feeling;
	CMScientificView *smaller = [[CMScientificView alloc] init];
	CMStudyTool * science = smaller.political;
	[LoadingView ckm_centuryWithClimate:actively ecologist:science];

	CMClimateView *responsibilities = [[CMClimateView alloc] init];
	NSMutableArray * progress = responsibilities.current;
	CMStudyTool *embracement = [[CMStudyTool alloc] init];
	UILabel * discredit = embracement.cognitive;
	CMCorporateViewController *think = [[CMCorporateViewController alloc] init];
	UIWindow * simultaneous = think.large;
	NSArray *space = [[NSArray alloc] init];
	LoadingView *information = [LoadingView alloc];
	[information ckm_authorWithDelegation:progress survival:discredit grind:simultaneous increase:space];

	CMDissonanceTool *humanities = [[CMDissonanceTool alloc] init];
	NSMutableString * handedness = humanities.catarina;
	LoadingView *financial = [LoadingView alloc];
	[financial ckm_learningWithCatarina:handedness];

	CMCorporateViewController *catarina = [[CMCorporateViewController alloc] init];
	UIView *direction = [[UIView alloc] init];
	[LoadingView ckm_warmingWithBecause:catarina right:direction];

	UIView *officials = [[UIView alloc] init];
	[LoadingView ckm_acronymWithHumans:officials];
}

@end
