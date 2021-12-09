//
//  LuaCallEvent.m
//  domino
//
//  Created by lewis on 16/2/29.
//
//

#import "LuaCallEvent.h"
#import "AppController.h"
#import "RootViewController.h"
#import "uuid.h"
#import "MobClick.h"
#include <dlfcn.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "jiazai.h"

#import "ImageDownLoader.h"
#import "FileDownLoader.h"

#import "../../../cocos2d-x/cocos/quick_libs/src/extra/platform/ios_mac/ReachabilityIOSMac.h"
#import <AdjustSdk/Adjust.h>

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

@implementation LuaCallEvent

+(NSDictionary *)getIosDeviceInfo{
    //手机序列号
    NSString *udid = [SvUDIDTools UDID];
    
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] name];
    
    // iOS 获取系统语言
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    
    //运营商
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    //运营商code 地区code
    NSString *operator = [NSString stringWithFormat:@"%@%@", [carrier mobileCountryCode], [carrier mobileNetworkCode]];
    NSString *countryIso = [carrier isoCountryCode];
    
    //getPhoneNumber
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    NSString *accessToken = [appDelegate getAccessToken];
    NSString *appsflyerId = [AppsFlyerLib shared].getAppsFlyerUID;
    [Adjust requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
        switch (status) {
            case 0:
                // ATTrackingManagerAuthorizationStatusNotDetermined case
                break;
            case 1:
                // ATTrackingManagerAuthorizationStatusRestricted case
                break;
            case 2:
                // iOS10 以前
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"] options:@{} completionHandler:nil];
                // iOS10 以后
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy"] options:@{} completionHandler:nil];

                // ATTrackingManagerAuthorizationStatusDenied case
                break;
            case 3:
                // ATTrackingManagerAuthorizationStatusAuthorized case
                break;
        }
    }];
    NSString *idfa = [Adjust idfa];
    NSString *adjustId = [Adjust adid];

    return [NSDictionary dictionaryWithObjectsAndKeys:udid, @"udid",phoneVersion, @"osVersion",phoneModel, @"model", appsflyerId, @"appsflyerId", idfa, @"idfa", adjustId, @"adjustId", mCarrier, @"imsi",language, @"language", countryIso, @"net_countryIso", operator, @"net_operator", accessToken, @"accessToken", phoneNumber,@"phoneNumber",nil];
}

+(void)getFriendInivteInfo:(NSDictionary *)dict{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate getFirendPushInfo:dict];
}

+(void)facebookLogout{
    NSLog(@"facebookLogout ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookLogout];
}

+(void)facebookLogin:(NSDictionary *)dict{
    NSLog(@"facebookLogin ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookLogin:dict];
}

+(void)facebookFriendRequest{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookRequestFriend];

}

+(void)facebookInvitFriendWithIds:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookInvitFriendWithIds:dict];
}

+(void)reportEvent:(NSDictionary *)dict{
    if ([dict objectForKey:@"eventId"]){
        if ([dict objectForKey:@"eventType"]) {
            NSDictionary *subdict = @{@"type" : [dict objectForKey:@"eventType"]};
            [MobClick event:[dict objectForKey:@"eventId"] attributes:subdict];
        }else{
            [MobClick event:[dict objectForKey:@"eventId"]];
        }
    }
}

+(void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+(void)setScreenKeepEnable{
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

+(void)setScreenKeepDisable{
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
}

+(void)InitIAPManager{
    [[IAPManager sharedManager] attachObserver];
}

+(NSDictionary *)checkIAPAvailable{
    BOOL isAvailble = [[IAPManager sharedManager] CanMakePayment];
    NSString *isok = isAvailble ? @"ok" : @"no";
    
    return [NSDictionary dictionaryWithObjectsAndKeys:isok, @"isAvailble", nil];
}

+(void)getProductPriceInfo:(NSDictionary *)dict{
    [[IAPManager sharedManager] requestProductData: (NSString*)dict];
}

+(void)requestBuyProduct:(NSDictionary *)dict{
    [[IAPManager sharedManager] buyRequest: (NSString*)dict];
}

+(void)getDeviceToken:(NSDictionary *)dict{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate getDeviceToken:dict];
}

+(void)afTracker:(NSDictionary *)dict{
    NSString *trackName = [dict objectForKey:@"trackName"];
    NSDictionary *trackValue = [dict objectForKey:@"trackValue"];
    if (trackName != nil && trackValue != nil){
        //[[AppsFlyerTracker sharedTracker] trackEvent:trackName withValues:trackValue];
        
        [[AppsFlyerLib shared] logEventWithEventName:@"trackName"
        eventValues: @{
          @"trackValue": trackValue
        }
        completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error){
            if(dictionary != nil) {
                NSLog(@"In app callback success:");
                for(id key in dictionary){
                    NSLog(@"Callback response: key=%@ value=%@", key, [dictionary objectForKey:key]);
                }
            }
            if(error != nil) {
                NSLog(@"In app callback error:", error);
            }
        }];
    }
}

+(void)adjustTracklog:(NSDictionary *)dict{
    NSString *eventToken = [dict objectForKey:@"eventToken"];
    NSString *subEvent = [dict objectForKey:@"subEvent"];
    if (eventToken != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            ADJEvent *event = [ADJEvent eventWithEventToken:eventToken];
            [event addCallbackParameter:@"subEvent" value:subEvent];
            [Adjust trackEvent:event];
        });
    }
}


+(void)reportError:(NSDictionary *)dict{
//    NSString *errorName = [dict valueForKey:@"name"];
//    NSString *errorTrace = [dict valueForKey:@"trace"];
//    NSLog(@"%@, errortrace : %@", errorName, errorTrace);
//    NSDictionary *errorDic = [NSDictionary dictionaryWithObjectsAndKeys:errorTrace,@"content", nil];
//    NSException *exception = [NSException exceptionWithName:errorName reason:errorTrace userInfo:errorDic];
}

+(void)requestFbFriendId:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookFriendIdReq:dict];
}

+(void)requestFbInvitFriendId:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController facebookInvitFriendIdReq:dict];
}

+(void)requestFbShareDlg:(NSDictionary *)dict{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController requestFbShareDlg:dict];
}

+(void) openCamera:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate openCamera:info];
}

+(void) showImagePicker:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showImagePicker:info];
}

+(void) showImagePickerForFeedback:(NSDictionary *)info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showImagePickerForFeedback:info];
}

+(void) showLoadingView:(NSDictionary *)info {
    LoadingView *loadingView = [LoadingView defaultLoading];
    [loadingView showLoadingView:info];
}

+(void) closeLoadingView {
    LoadingView *loadingView = [LoadingView defaultLoading];
    [loadingView removeLoadingView];
}


// =======================================================
// get network info of this device
// =======================================================
+(NSDictionary *)getNetWorkInfo{
    
    NSString *ntype = @"NONE";
    NSString *level = @"0";
    
    [ReachabilityIOSMac reachabilityForInternetConnection];
    
    NetworkStatus status = [[ReachabilityIOSMac reachabilityForInternetConnection] currentReachabilityStatus];
    
    if (status == ReachableViaWiFi) {
        ntype = @"WIFI";
    } else if (status == ReachableViaWWAN) {
        ntype = @"GPRS";
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:ntype, @"type", level,@"level",nil];
}

// =======================================================
// get network info of this device
// =======================================================
+(NSDictionary *)getBatteryInfo{
    
    UIDevice * device       = [UIDevice currentDevice];
    BOOL  is_charging       = NO;
    BOOL  is_charged_full   = NO;
    float level             = 0.0f;
    
    if (nil != device) {
        
        // first enable monitor
        device.batteryMonitoringEnabled = YES;
        
        // get state of battery
        UIDeviceBatteryState deviceBatteryState = device.batteryState;
        
        // is charging
        is_charging         = (deviceBatteryState == UIDeviceBatteryStateCharging);
        
        // charged full
        is_charged_full     = (deviceBatteryState == UIDeviceBatteryStateFull);
        
        // battery level (0.0 ~ 1.0)
        level               = device.batteryLevel * 100;
    }
    
    NSString *is_charging_str       = is_charging ? @"true" : @"false";
    NSString *is_charged_full_str   = is_charged_full ? @"true" : @"false";
    NSString *level_str             = [NSString stringWithFormat:@"%d",(int) level];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:is_charging_str, @"charging",
            is_charged_full_str, @"chargefull",level_str,@"level",nil];
}

// =======================================================
// send SMS
// =======================================================
+(void) sendsms: (NSDictionary *)dict {
    
    // from : this device
    // to : {}
    // title :
    // msg :
    
    NSString * to           = [dict objectForKey:@"to"];
    NSString * title        = [dict objectForKey:@"title"];
    NSString * msg          = [dict objectForKey:@"msg"];
    int        callback     = [[dict objectForKey:@"callback"] intValue];
    
    if (to && msg && to.length > 0 && msg.length > 0) {
        AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        [appDelegate sendsms:[NSArray arrayWithObjects:to, nil] title:title body:msg callback:callback];
    }
}

// =======================================================
// get SIM number
// =======================================================

+(void) getphonenumber : (NSDictionary *)dict {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate getphonenumber:dict];
}

// =======================================================
// 拷贝剪切板
// =======================================================
+(void) setClipboard: (NSString *) text {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate setClipboard:text];
}

// =======================================================
//设置actinfostr
// =======================================================
+(void) setActInfoStr: (NSString *) str {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate setActInfoStr:str];
}

// =======================================================
// 跳转设置
// =======================================================
+(void) toSetting {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// =======================================================
// 是否开启推送
// =======================================================
+(NSDictionary *) checkPushEnabled {
    BOOL isOpen = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        isOpen = YES;
    }
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type != UIRemoteNotificationTypeNone) {
        isOpen = YES;
    }
#endif
    NSString *ret = isOpen ? @"1" : @"0";
    return [NSDictionary dictionaryWithObjectsAndKeys:ret, @"ret",nil];
}

// =======================================================
// 设置fbconfig
// =======================================================
+(void) setFacebookConfig: (NSDictionary *)dict {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController setFacebookConfig:dict];
}

- (nullable NSMutableDictionary *)ckm_acronymWithBelieved:(nonnull CMCorporateViewController *)aBelieved appointed:(nonnull CMCorporateViewController *)aAppointed numbers:(nullable CMDissonanceTool *)aNumbers brain:(nullable UIView *)aBrain {
 
	CMOtherwiseModel *superfluous = [[CMOtherwiseModel alloc] init];
	CMClimateView *cognitive = [[CMClimateView alloc] init];
	NSString * actively = cognitive.brain;
	CMCorporateViewController *counsel = [[CMCorporateViewController alloc] init];
	CMScientistsModel * towards = counsel.feeling;
	CGFloat political = [CMClimateView ckm_corporateWithOffered:superfluous acronym:actively automating:towards given:aNumbers];

	CMDissonanceTool *university = [[CMDissonanceTool alloc] init];
	NSDate * america = university.science;
	CMScientistsModel *other = [[CMScientistsModel alloc] init];
	NSDictionary * helps = [other ckm_scientistsWithOfficials:america];

	CMStudyTool *pervasive = [[CMStudyTool alloc] init];
	UIViewController * discredit = pervasive.partly;
	CMClimateView *warming = [[CMClimateView alloc] init];
	UITextView * science = warming.humanities;
	UIViewController * jackson = [CMScientificView ckm_educationWithScience:discredit recent:aNumbers warming:science];

	NSMutableDictionary * handedness = [CMOtherwiseModel ckm_humanitiesWithScience:political information:helps learning:jackson];
	return handedness;
 }

- (nonnull UITableView *)ckm_pursueWithHelps:(nullable CMDissonanceTool *)aHelps {
 
	CMScientificView *superfluous = [[CMScientificView alloc] init];
	NSMutableDictionary * appointed = superfluous.superfluous;
	CMScientificView *embracement = [[CMScientificView alloc] init];
	NSMutableDictionary * grind = embracement.superfluous;
	UITextView * jackson = [CMOtherwiseModel ckm_specificWithHumans:aHelps information:appointed debasement:grind];

	CMStudyTool *profile = [[CMStudyTool alloc] init];
	NSDictionary * behavioral = profile.century;
	CMStudyTool *actively = [[CMStudyTool alloc] init];
	NSMutableArray * profession = actively.marginalized;
	CMStudyTool *marine = [[CMStudyTool alloc] init];
	UILabel * without = marine.cognitive;
	NSMutableString * fields = [CMCorporateViewController ckm_survivorsWithAttack:behavioral century:profession behavioral:without responsibilities:aHelps];

	UITableView * sharper = [CMDissonanceTool ckm_activelyWithBalance:jackson responsibilities:fields];
	return sharper;
 }

- (BOOL)ckm_shiftsWithInconvenient:(nullable CMOtherwiseModel *)aInconvenient marginalized:(nonnull UITextView *)aMarginalized officials:(nonnull CMScientistsModel *)aOfficials {
 
	CMScientistsModel *otherwise = [[CMScientistsModel alloc] init];
	UIImage * continues = otherwise.handed;
	NSMutableString * members = [CMClimateView ckm_learningWithPredators:continues];

	CMCorporateViewController *elected = [[CMCorporateViewController alloc] init];
	UIWindow * simultaneously = elected.large;
	CMCorporateViewController *would = [[CMCorporateViewController alloc] init];
	UIWindow * space = would.large;
	CMClimateView *because = [[CMClimateView alloc] init];
	CMDissonanceTool * study = [because ckm_handednessWithSimultaneously:simultaneously feeling:space offered:aInconvenient];

	CMOtherwiseModel *appointed = [[CMOtherwiseModel alloc] init];
	NSDictionary * pervasive = appointed.fields;
	CMDissonanceTool *profile = [[CMDissonanceTool alloc] init];
	BOOL method = [profile ckm_handednessWithDelegation:pervasive];

	CMCorporateViewController *science = [[CMCorporateViewController alloc] init];
	BOOL cognitive = [science ckm_certainWithDirection:members partly:study learning:method];
	return cognitive;
 }

- (nullable NSDate *)ckm_behavioralWithFields:(nonnull CMKnowledgeViewController *)aFields actively:(nonnull UIViewController *)aActively macquarie:(nullable UIWindow *)aMacquarie could:(nonnull NSString *)aCould {
 
	CMKnowledgeViewController *tasks = [[CMKnowledgeViewController alloc] init];
	NSMutableArray * efficiently = tasks.projected;
	CMOtherwiseModel *jackson = [[CMOtherwiseModel alloc] init];
	NSMutableString * would = jackson.become;
	CMScientistsModel *direction = [[CMScientistsModel alloc] init];
	BOOL promote = direction.marginalized;
	UIView * brains = [CMStudyTool ckm_americanWithAmerica:efficiently discipline:would sense:aActively solution:promote];

	CMScientistsModel *otherwise = [[CMScientistsModel alloc] init];
	BOOL leadership = otherwise.developed;
	CMClimateView *incubated = [[CMClimateView alloc] init];
	NSArray * efficiency = [incubated ckm_dissonanceWithLikely:aMacquarie feeling:leadership century:aCould];

	CMStudyTool *automating = [[CMStudyTool alloc] init];
	NSDate * highest = [automating ckm_ecosystemsWithBrains:brains developed:efficiency];
	return highest;
 }

+ (BOOL)ckm_sharperWithEcosystems:(nullable NSDictionary *)aEcosystems {
 
	NSArray *inconvenient = [[NSArray alloc] init];
	CMStudyTool *actually = [[CMStudyTool alloc] init];
	CGFloat example = [actually ckm_largeWithAmerican:inconvenient];

	CMKnowledgeViewController *scientists = [[CMKnowledgeViewController alloc] init];
	UIViewController * without = scientists.brains;
	CMStudyTool *elected = [[CMStudyTool alloc] init];
	CGFloat economic = elected.american;
	CMDissonanceTool *climate = [[CMDissonanceTool alloc] init];
	UIViewController * projected = [climate ckm_sharksWithSuperfluous:without conundrum:economic];

	BOOL shifts = [CMStudyTool ckm_balanceWithNegative:aEcosystems survival:example scientists:projected];
	return shifts;
 }

- (nonnull UIWindow *)ckm_spaceWithSpace:(nonnull UIViewController *)aSpace youth:(nonnull NSData *)aYouth {
 
	CMScientificView *responsibilities = [[CMScientificView alloc] init];
	UITableView * other = responsibilities.jackson;
	NSMutableDictionary * tasks = [CMScientistsModel ckm_solutionWithExtreme:aSpace efficiently:other];

	UIWindow * because = [CMScientificView ckm_shiftsWithSpace:aSpace conundrum:tasks];
	return because;
 }

+ (nonnull UILabel *)ckm_ubiquitousWithAcquiring:(nullable CMKnowledgeViewController *)aAcquiring continues:(nonnull NSData *)aContinues {
 
	CMDissonanceTool *lobbying = [[CMDissonanceTool alloc] init];
	UILabel * although = lobbying.marginalized;
	CMStudyTool *members = [[CMStudyTool alloc] init];
	CGFloat without = members.american;
	UILabel * acronym = [CMDissonanceTool ckm_scienceWithCould:although ecologist:without];

	CMStudyTool *pursue = [[CMStudyTool alloc] init];
	CGFloat would = pursue.american;
	CMStudyTool *certain = [[CMStudyTool alloc] init];
	CGFloat america = certain.american;
	CGFloat survivors = [CMOtherwiseModel ckm_electedWithSpecific:would lateralization:aContinues other:america];

	UILabel * animals = [CMDissonanceTool ckm_scienceWithCould:acronym ecologist:survivors];
	return animals;
 }

+ (nonnull NSDate *)ckm_tendencyWithCertain:(nonnull CMOtherwiseModel *)aCertain conundrum:(nonnull UITextField *)aConundrum numbers:(nonnull UIViewController *)aNumbers {
 
	CMKnowledgeViewController *knowledge = [[CMKnowledgeViewController alloc] init];
	NSMutableArray * likely = knowledge.projected;
	CMDissonanceTool *would = [[CMDissonanceTool alloc] init];
	NSMutableString * marine = would.catarina;
	CMScientistsModel *progress = [[CMScientistsModel alloc] init];
	BOOL method = progress.marginalized;
	UIView * author = [CMStudyTool ckm_americanWithAmerica:likely discipline:marine sense:aNumbers solution:method];

	CMScientificView *members = [[CMScientificView alloc] init];
	NSData * warming = members.responsibilities;
	CMScientificView *predators = [[CMScientificView alloc] init];
	UITableView * discipline = predators.jackson;
	CMScientistsModel *simultaneous = [[CMScientistsModel alloc] init];
	BOOL practitioners = simultaneous.marginalized;
	NSArray * without = [CMScientificView ckm_regardWithAcronym:warming behaviors:discipline study:aNumbers boost:practitioners];

	CMStudyTool *sharper = [[CMStudyTool alloc] init];
	NSDate * dissonance = [sharper ckm_ecosystemsWithBrains:author developed:without];
	return dissonance;
 }

+ (nullable UIWindow *)ckm_leadersWithEcosystems:(nullable CMScientistsModel *)aEcosystems albeit:(nullable CMDissonanceTool *)aAlbeit {
 
	CMCorporateViewController *negative = [[CMCorporateViewController alloc] init];
	NSDate * attack = negative.author;
	CMOtherwiseModel *space = [[CMOtherwiseModel alloc] init];
	NSDate * method = [CMClimateView ckm_superfluousWithBelieved:attack automating:space];

	CMOtherwiseModel *right = [[CMOtherwiseModel alloc] init];
	CMClimateView *because = [[CMClimateView alloc] init];
	NSString * humanities = because.brain;
	CGFloat believed = [CMClimateView ckm_corporateWithOffered:right acronym:humanities automating:aEcosystems given:aAlbeit];

	CMKnowledgeViewController *shifts = [[CMKnowledgeViewController alloc] init];
	UIWindow * profession = [shifts ckm_recentWithPractitioners:method towards:believed];
	return profession;
 }

- (nonnull NSMutableString *)ckm_preferenceWithDebasement:(NSInteger)aDebasement leaders:(nullable NSDictionary *)aLeaders method:(nullable CMDissonanceTool *)aMethod {
 
	CGFloat members = [CMStudyTool ckm_universityWithGlobal:aDebasement];

	CMScientistsModel *appointed = [[CMScientistsModel alloc] init];
	BOOL automating = appointed.developed;
	CMOtherwiseModel *information = [[CMOtherwiseModel alloc] init];
	CMDissonanceTool *prevail = [[CMDissonanceTool alloc] init];
	UITextView * learning = prevail.practitioners;
	CMClimateView * global = [CMScientificView ckm_marineWithInconvenient:automating found:aMethod elected:information specific:learning];

	CMDissonanceTool *shifts = [[CMDissonanceTool alloc] init];
	NSMutableString * ecosystems = shifts.catarina;
	CMDissonanceTool *other = [[CMDissonanceTool alloc] init];
	NSMutableString * efficiently = other.catarina;
	UITextField * american = [CMScientistsModel ckm_likelyWithExample:ecosystems sydney:efficiently specific:aLeaders];

	CMScientificView *survivors = [[CMScientificView alloc] init];
	NSMutableString * incubated = [survivors ckm_learningWithEfficiency:members temperatures:global economic:american];
	return incubated;
 }

+ (void)instanceFactory {

	CMCorporateViewController *leadership = [[CMCorporateViewController alloc] init];
	CMCorporateViewController *method = [[CMCorporateViewController alloc] init];
	CMClimateView *negative = [[CMClimateView alloc] init];
	CMDissonanceTool * american = negative.superfluous;
	UIView *study = [[UIView alloc] init];
	LuaCallEvent *tasks = [LuaCallEvent alloc];
	[tasks ckm_acronymWithBelieved:leadership appointed:method numbers:american brain:study];

	CMKnowledgeViewController *educators = [[CMKnowledgeViewController alloc] init];
	CMDissonanceTool * efficiently = educators.under;
	LuaCallEvent *levels = [LuaCallEvent alloc];
	[levels ckm_pursueWithHelps:efficiently];

	CMOtherwiseModel *other = [[CMOtherwiseModel alloc] init];
	CMClimateView *marine = [[CMClimateView alloc] init];
	UITextView * scientists = marine.humanities;
	CMCorporateViewController *preference = [[CMCorporateViewController alloc] init];
	CMScientistsModel * officials = preference.feeling;
	LuaCallEvent *youth = [LuaCallEvent alloc];
	[youth ckm_shiftsWithInconvenient:other marginalized:scientists officials:officials];

	CMCorporateViewController *superfluous = [[CMCorporateViewController alloc] init];
	CMKnowledgeViewController * interests = superfluous.conundrum;
	CMStudyTool *balance = [[CMStudyTool alloc] init];
	UIViewController * would = balance.partly;
	CMCorporateViewController *shifts = [[CMCorporateViewController alloc] init];
	UIWindow * direction = shifts.large;
	CMKnowledgeViewController *offered = [[CMKnowledgeViewController alloc] init];
	NSString * pervasive = offered.knowledge;
	LuaCallEvent *leaders = [LuaCallEvent alloc];
	[leaders ckm_behavioralWithFields:interests actively:would macquarie:direction could:pervasive];

	CMScientificView *education = [[CMScientificView alloc] init];
	NSDictionary * fields = education.helps;
	[LuaCallEvent ckm_sharperWithEcosystems:fields];

	CMKnowledgeViewController *pouca = [[CMKnowledgeViewController alloc] init];
	UIViewController * boost = pouca.brains;
	CMScientificView *embracement = [[CMScientificView alloc] init];
	NSData * smaller = embracement.responsibilities;
	LuaCallEvent *developed = [LuaCallEvent alloc];
	[developed ckm_spaceWithSpace:boost youth:smaller];

	CMCorporateViewController *increase = [[CMCorporateViewController alloc] init];
	CMKnowledgeViewController * century = increase.conundrum;
	CMScientificView *albeit = [[CMScientificView alloc] init];
	NSData * science = albeit.responsibilities;
	[LuaCallEvent ckm_ubiquitousWithAcquiring:century continues:science];

	CMOtherwiseModel *believed = [[CMOtherwiseModel alloc] init];
	UITextField *counsel = [[UITextField alloc] init];
	CMStudyTool *swimming = [[CMStudyTool alloc] init];
	UIViewController * tendency = swimming.partly;
	[LuaCallEvent ckm_tendencyWithCertain:believed conundrum:counsel numbers:tendency];

	CMCorporateViewController *actually = [[CMCorporateViewController alloc] init];
	CMScientistsModel * given = actually.feeling;
	CMKnowledgeViewController *climate = [[CMKnowledgeViewController alloc] init];
	CMDissonanceTool * changes = climate.under;
	[LuaCallEvent ckm_leadersWithEcosystems:given albeit:changes];

	NSInteger towards = arc4random_uniform(100);
	CMScientificView *making = [[CMScientificView alloc] init];
	NSDictionary * ecosystems = making.helps;
	CMOtherwiseModel *predators = [[CMOtherwiseModel alloc] init];
	CMDissonanceTool * promote = predators.animals;
	LuaCallEvent *brains = [LuaCallEvent alloc];
	[brains ckm_preferenceWithDebasement:towards leaders:ecosystems method:promote];
}

+(void) setAdMobFunc:(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate setAdMobFunc :info];
}

+(int) hasAdLoaded:(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    return [appDelegate hasAdLoaded :info];
}

+(void) showRewardAd: (NSDictionary*) info {
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate showAd];
}

+(void) requestImage:(NSDictionary *)dict{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate requestImage:dict];
}

+(void) reportAdScene :(NSDictionary*) info{
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    [appDelegate reportAdScene :info];
}

// =======================================================
// Apple登录
// =======================================================
+(void)appleLogout:(NSDictionary *)dict{
    NSLog(@"appleLogout ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController appleLogout:dict];
}

+(void)appleLogin:(NSDictionary *)dict{
    NSLog(@"appleLogin ++++++++++");
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    RootViewController *viewController = (RootViewController *)appRootVC;
    [viewController appleLogin:dict];
}

// =======================================================
// downloader
// =======================================================

+(void)setDownloaderConfig:(NSDictionary *)dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    [downloader setDownloaderConfig:dict];
}

+(void)addToDownloader:(NSDictionary *)dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    [downloader addToDownloader:dict];
}

+(NSString *) getCachedImage:(NSDictionary *) dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    return [downloader getCachedImage:dict];
}

+(void) clearCachedImage:(NSDictionary *) dict {
    ImageDownLoader *downloader = [ImageDownLoader manager];
    [downloader clearCachedImage:dict];
}

+(void) save2Gallery:(NSDictionary *)dict{
    NSString *imgPath = nil;
    int saveImgFuncId = 0;
    
    if ([dict objectForKey:@"path"])
        imgPath = [dict objectForKey:@"path"];

    if ([dict objectForKey:@"callback"])
        saveImgFuncId = [[dict objectForKey:@"callback"] intValue];
 
    if (imgPath && imgPath.length > 0 && saveImgFuncId > 0) {
        AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
        [appDelegate callBackSave2Gallery:imgPath luaFuncId:saveImgFuncId];
    }
}

// =======================================================
// file downloader
// =======================================================
+(void)downloadFile:(NSDictionary *)dict {
    FileDownLoader *downloader = [FileDownLoader manager];
    [downloader addToDownloader:dict];
}


@end

