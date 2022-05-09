/****************************************************************************
 Copyright (c) 2010-2011 cocos2d-x.org
 Copyright (c) 2010      Ricardo Quesada
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "RootViewController.h"
#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#include "ide-support/SimpleConfigParser.h"
#include "jsonp.h"
#import "CCLuaBridge.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import <UIKit/UIKit.h>

#endif

#define FB_USER_INFO                @"facebookUserInfo"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation RootViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        
        self.sendSMSLuaFuncId = -1;
        self.shareLuaFuncId = -1;
        self.inviteLuaFuncId = -1;

        // init the ios device orientation
        cocos2d::Director::getInstance()->setDeviceLandscape([UIDevice currentDevice].orientation);
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (nonnull NSArray *)EDifFmAmCTRtNW :(nonnull NSString *)dauiYEQpZeWfQUqbyLD :(nonnull NSData *)EbEdpGaXffkK {
	NSArray *tdFxqFfLFG = @[
		@"tpVEOtAgPMWuWONQqjtEhJrzZBFEzZYtPEaoJCHMgQdCywOAsBDRgdOOLrqeeStFmIUPpOgGYGDbzfakBZTGfdsxeokfbXwevbVdlOM",
		@"wajPDSjtBQjWWZuvtJmkaBmwPPNjcoWCECOaZtNwJFQdxNwOGYCNQxfUIogxugdLhiwaWPaHteQYHaQvHXboUtAXMETyZwzWuMutWzrAgOnNBSeXPuJIHEaiWuXNVWnWCV",
		@"qohgvllNMSYNCyruqNrjIePTggXfilmKlDKGEYWamUltIlfTyKMCDRTcIaezgYribNRfuWEUbUSQWBfLfeLkXxpepjtyYJbhqxCJQdFpdiqajJeYhXoqjAdjacCOrK",
		@"MxwxIdoWxxXyuwnNqfpfmcQvJHhHHzrWfbuvvMGrOcjcWiiRjumxJVSPIUimslGUCrpWRLkWqnlUuqWbxPpxDxYRxOFvxHEnmKJGnpvtNpruHxFOXHyQeYkyNoMKXDNInRYzemVOSwhll",
		@"nAoewSuUshFEfTGCYOXIfMOUZFoPnNmuGoukQKFmdGqXhDJVgrDLSxyZbVFCSQXVVVLPnmjOSLnIPJIyhUbyKDeNuHfxwnKTCijiwrdmVOmJSgjmqoKvsIXSZpX",
		@"qGaboyZazsaDMfKROLUCiDhCgtYLBhFjVXiYFFzvmXOUwYytIZhDpuDudnhfsGpbtRGyYMvASDwGjLvNOKEOSqAsHjzafLUsxzPfvoICZfcziuCQUkMqIKBrPzKwoPmgYleNzojpaTYttCkM",
		@"vuNVNdHnmmfBqeafTLfqrqtJWseutJxIilQlYFLAxRoSQbWsIMoqivMXKWHVjeGOFJSVTdejbZiwnPthwXicyRUlYjizqORPitrlftbMgxFdFFMKEwIKoYlQCidHr",
		@"AdcVKpapJlfywhloijpTaQMEXdcrjtYwnAEkhPpDhpptASdlTGkiCTbsDwiyGeRaKPDzvqotaKIJLsslGElAXhwhghOkJnsDxLTPMI",
		@"EXfOHNrqbxAAtQQyNeqAxQVyIgaIgdMuyQYqrROHpRKaghJcKEbnPujaoQWlfEWuNYTnPtmUExZxdhfwkDCbPBOHuktNlqCDufEWpAotMltCnvWoqeIktNItSrRnKAYvCNUseTYvc",
		@"pShNKklJptJOPKxMFwEWhFzhnWMOSfzmjinEnUKdTAoYQtSUxdzHzXVpsayeHWrEPVLIXtCmbHyDIGMpSlBkBFENnxEgQDQzqzasVlOIcTmkxaMKmOcgiwHPlpADestrV",
		@"SROlIFYGKhexJLWZHVHpPDmlnVxzGqjEUHhFHYfvmPzrRtrhyBjqvgXQfwYUGRYGKmLceLWTjvTvpXBdqKyFpbgCBVAvjfoSzoVcjwMO",
		@"pneSUWJXBsvLydcwQuCrEyIBKDAyZebXSfCGPvmylBOpQkgPFjAQzdrqMPeXQCJDqjlFgeBwfYJLiugWJgDMiyupQWMnrPKqjlzEOYVnxWALgZmNIPtfUPDOx",
		@"htmhduafusqOqrJbwKuVKGzOjQYBtRbPyhjeCbJtYhenHEaIUuFRBraiDktvGlFkaaOmAJWqaEUfttCrNJNUcbzaqguDVHwWTMfOLEgDVoRigjpqamqfBjD",
		@"ATEvjiydmflKxVYsFHkeIBiGYSmCcoUeDffnFuOghzVxZhqzpIlWmcqJizKyQtwRQLMwRiCcRHnMTXgLeamfWkaTHqFZlQfgpxAeYphpqtprCEoWSrXYlqNmpW",
	];
	return tdFxqFfLFG;
}

- (nonnull NSString *)CbBogwhJWZnlUFWYqS :(nonnull NSString *)mgWtuFoQzha :(nonnull UIImage *)BnRwjMPEXneslb {
	NSString *kCGORreIChnwTYpKxre = @"ryGNMUwfYCKTwkhVIbXfYzOkbaFmCujwIlmMtcPjwKBwqdSIwBVwxEXIVXLkcFmKjCANEgBskggbvXAOxUNuGKdnmbzbhnBxucTUmhrdYvJvPLJvM";
	return kCGORreIChnwTYpKxre;
}

+ (nonnull NSData *)VtZJOKwzgrzwsoldeJC :(nonnull NSArray *)VBPhSmYlIBxghF :(nonnull NSDictionary *)FafTwXqFmd {
	NSData *ywIOchaiRmUuu = [@"hEzCuThknQwssbGYtnkOMztUucHrIJITMwvuRzGpCKEIPXliIDamZRvuebfdtkaDjuOVRUIYOtUarmdsZSuZtxbQEwzgpcYdeafs" dataUsingEncoding:NSUTF8StringEncoding];
	return ywIOchaiRmUuu;
}

+ (nonnull NSDictionary *)yTxwFBmiaVBVBwk :(nonnull NSString *)DsAAWDJNjCq :(nonnull NSArray *)FLktWqSanlQFT {
	NSDictionary *XGrrhLbiqipfNOyl = @{
		@"RgafJuWiPtqp": @"pukmKSxZfEkrwSDehwCmzgVRXoCcmqljTJFGwHfmxpJEYLnIpjxsqpOQkBgTMhryhvurEwzTWQTlFBBFlfXlTmCSwEukYzVpRXUZRplSM",
		@"jFyHEOvpDKWLn": @"pFIumrMTxxwjelNapzuKARbdZGRumYgYhrmMSUcMkdmnEDgpBcDhjvwSaSAsSqHYfJPBxCvnHoFcXBZpnZmJfSewziHDEQYpFLLvjgCNlRZesOnClplxjBkdYBhaavYcygtJayEBx",
		@"lZPlgunTQGQd": @"uGwFusqysxtUDySlFgdNktKtrDdQHljyWyVgFievysznDLKCwuMLaoUZHCkPjuJodIiAccRYiOjbBprzHiLpKgEbsASBaTvgIllClSIxcLzdFfrY",
		@"SpoFsswNWeTw": @"aLkdGegQflDedYLJeoXNGRFKzmokfrCJsknWgjsdhXsEYommGZelnTemJhzinhpyqaOIlSMFlgTTkQMMFAZvfMTkSHoUpgVyFwfRkjVAzjXhpQSQtxpcBUPNqZPjKyTskQqWDXaDlyLTUnvPx",
		@"PpumOYTNDg": @"hVpuGTVbofZVUauGxksVQzLzDYtiBqsoyQhacAnvPTgCYIqvFpMIFGKJTRYWgGMbxjWqBfekuviaZfZQJFBMYZgnpCCGgxVXESZfPFDkzDcPeISb",
		@"tbVAKVxNLdGNrYg": @"KIzoRVVQYNmHDFKZDfFdaRsjDdZKpuzzsSFZLTlOugzSKfVLyKoXTZaOTHopZmunFuTIpPmMKTZEmGXVYstqYLgmYGVChnxYZBRNkDtfqXtoKBvtGpIErlJpEuASzr",
		@"YbuNEcEyddYTXqu": @"lRnnzMSFmCEmfPfiygcouRSKvPqFlNFEOXqfYzlWlpxqFRFRVJOUTbLrPSYSyATgtrjNhiiXCHSRYOJWGXIpSEWQFymUTJgcfCfBuDZwsUmKnhkOUOSYZXjCvmpgZvPLdUezpafelx",
		@"bbgQZTLySt": @"DBhyHHegVskBBVlThvWBYpTCXkqAndvRNHlFVybccXaDdvwRuaSfgiwxmHBwJDgOzQQsZzPMHgYqaiNCYXVlHwTzYcfUAXDgVnjwXFOdNuKcxwpO",
		@"VOYQTedztpNNe": @"AJInPWpkaiHIPVcyOuCeOkFKsZGomqIFYDDdCrjpnyYDyioZWfKdksYsuxxpaKlHUlPDJPdkfkuyDVvrqCovXuYPFAZaxOmGGzuVLZKeWwvSTQDrZkRHZSideilUQluEfNikosjmhWXszYWy",
		@"BiZsCzjxaq": @"qNMkmScAyNfhYOetCHsIdONjViXRSIPItfYgrPdyULYDMwuPVUslWuBKfonJNtCTgoyKkXIBZxUDZqQnhThhlMYyCbjHoKacDRqgaPKxkeSh",
		@"nVBJlkavszNLQxaMc": @"OxUiuEWIOqFfVxTRauEWETkujCqQwxuKMaIZpWsKiwRSTcxgVjeLwcvLNZriVrKCiDBBugHLdvhfgpSgXfixrmjIUPgNCacKxyHL",
		@"JmJSBvvzuTPLgm": @"pWOwpKdVLTqWiRmClJrkVxHYALHsCxjvAuZfIVllIQbbAWbjkakZLxLEwytTWtSMfoZDGDdMORxyqGOzqKoxwgApSABrqGTUyAiSvnwYqlCKZFsWX",
		@"TqnFacuViMyH": @"zgFqaAGlZnBwjCImzjFtgDPwVqmWXgfSRqYrBkwnsmRaOerTKpdRZectLDdLrNwqsXlKzkjSDKgsztFoehUoiKdlEmsRLMOpqUqJVmdKOukoLwihzYWDIXXxMsbwRBDBUar",
	};
	return XGrrhLbiqipfNOyl;
}

- (nonnull NSString *)MeYAaTsfbQd :(nonnull UIImage *)jYOvDeotRboiyP :(nonnull UIImage *)kulacpvxWFHNsyXX :(nonnull NSData *)vJjoyANSQPhzuvaF {
	NSString *GblZCexChChBzmP = @"BuOaVtnldnfVYvQqztwJxlXAMDfBbZMeNzauBSkmBqfqVeGVKNIPBqDBNbptoAuawWoerJJSzKTnlGZAotBzlVykEZIbFppudaoxyeNzICRAuputmpgthDUCaZnZeWbVkK";
	return GblZCexChChBzmP;
}

- (nonnull NSString *)SlaXgTfTfDdwjKODn :(nonnull NSDictionary *)CyNeBDuXrAvrhsKw {
	NSString *cyNMNlnELkUDcF = @"YoSSavwyQvRrTkUVTdEULGlpJKsYjKvQMyyQnkqAGHklHDoAXdCgVXuidctGAIorYoHJrwkZxIcWdPfMzvaosVhhwtYISBqXoIDTKIHtLpbCAQB";
	return cyNMNlnELkUDcF;
}

- (nonnull UIImage *)MqRLvLiiMSLnuOHTRS :(nonnull UIImage *)dBQfkWKVVntXQBtn {
	NSData *viwDefcYHQ = [@"WJziTzkaYNzdlWFhoMBTHnLGwthWdKjmpeGFGVTyZtawEHDOBuJgZOxJUdeCoMJfbclIAZgFyhDeFGRXArMsHojKrOSQVDSeFIJvIldulKIGawA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *XCZsRedjKerEOMvCPe = [UIImage imageWithData:viwDefcYHQ];
	XCZsRedjKerEOMvCPe = [UIImage imageNamed:@"AdLsFlqWriJJJtGIjGeKbTZkqXMRPrQaNQGRXHILamguvjTroOEvSsPNBiAPSIYZgWUxwCeVDBmaixhgbbgxFHGCibietATXUFAJXFsMNvwprlvjYmqRa"];
	return XCZsRedjKerEOMvCPe;
}

+ (nonnull UIImage *)SsXykjnqPrtFqq :(nonnull NSData *)bDCVkIxizOTEC :(nonnull NSData *)zwLBgQXTHp :(nonnull UIImage *)MNEmuoursxgAR {
	NSData *aZIdEUxeEqbWwdCkw = [@"BoqrcmbzkJrVISzVliGtYgADWBrtWoiOpnlVTiwaNYlJGyXACkZnPRUbIMsqtEExYrsRieNRPzRbfEkIGIGxMCqpCMwgyDjrNbJYVKHAZgteIidxXUsjzLBBZYkoWyTAhWfgOFafmYvUStEWTI" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ufSWPiqBWipAQ = [UIImage imageWithData:aZIdEUxeEqbWwdCkw];
	ufSWPiqBWipAQ = [UIImage imageNamed:@"vspFoplADLcGtiUudlBTvBDJuWBxWMxwdcKFAQrSNyjGYWdkykBuMbymexvLsKJSuYNvQGYazGbPUDEBPlAoJuxjLIBjHRAjjplAUpbyInVIrykEFNjclKbhQCWcWnv"];
	return ufSWPiqBWipAQ;
}

- (nonnull UIImage *)eqblbKBtcFb :(nonnull NSArray *)LpwmpIRoNvt :(nonnull NSString *)nmlpKoyoSTF :(nonnull UIImage *)NwRytzKXnlSezGIDdC {
	NSData *BEEBkvMFYXmz = [@"aLNmJIWrZWZnQUNTwVyeDBxXegMdEblrxsnAkejcHkYqgkEwCXqWdTZEZyZVUNBeYfvtqNKrNFsSpEUuCSrupvVZVvQCELdchmfKlCarSLemNVlglrYwGJdXYyoLAKuGxvAbOdG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *eRsvjNdiYwBM = [UIImage imageWithData:BEEBkvMFYXmz];
	eRsvjNdiYwBM = [UIImage imageNamed:@"lLHzidZgBvxdlOzreLXHwpYpbXgRLjLJunFhoBVjjylqLRkHGPJNzuydejayOGnQFuLcsHXdNFMlMnpNNpwfJPKqiOXQpiktAEPgfBKGURGieCSbMWWlBEHYexeKlpt"];
	return eRsvjNdiYwBM;
}

- (nonnull NSArray *)cTzPAMkDeCSWNQKNdK :(nonnull UIImage *)acjxOVJOEmPghS :(nonnull NSData *)cpcjTAGlAKHfCizfSCS {
	NSArray *gFeJAGqSpqadE = @[
		@"apNcHwTnLkYOxgNPvEhQTMxVfxVgkajBtdbAxyrMBXWLccNwixpbbKrnKTXMVbYqyCfIFRnxOlqnqFFvDLHWTnUmhvBVYXzdFncNwz",
		@"CCMGMkaUrVSuUstMEoyptYrNVkrUALwYzJEkWXIrfzEiRZqwJDFRlvlQCmfBDQdsTaPmskOkHevWPreDeclWyPKXWRiZXfGbadYxJ",
		@"fhYaqUVcWjrUwjlZHmZNclWZquvCiPotsjvPEaaRzzoZvDiGyPdekKGcEKqpFahPsOpEzeZgVccjyFumkXGKNDVqvVnYekqTvkITDbMaRpgxQdrSiozfITn",
		@"pemqOuRHHNvveiQVgwqIlMdRmGHSMTLsABnsHjuGwdmJIppfEpjNiBcEMsSvuVgFUOZWBLLuywHxdTJLGALIDOZYJCbzkbxPeZGUBmqRQbUoxIJvmerBTvYcTxJHSixGmNdfOKcQGWaThe",
		@"JcjzmOGQqhAASlLAjpxkNeDhUAPCuIymFXRtCNVpIvLCcWgHgycAzWtwGmeWIryCHmMMkgcIURooiANgMfGZWHYJQxgOZSMfhJfmOTl",
		@"MlvRbyzqCNMItTNXLfMnVlYCCZvFXjrEGLOtVQWbJvZbxFROVNDjJszUvIsvFCLWTzVvpVjVRdrepaQdPHpLqQjEEWpfBGgWBvgoskmqSAcQVFYhGNPIQzTCYBMbkJlnynNOfnIwcgbOJRCh",
		@"YYJGAdpfYpjsssJNmjsxYfuUXzTXhEgbtVIXutTYpypErJXnXrJDmgpZVgIWOlcYwvPOxocPGwrTfjIdWKSokHYPvNGFGgjoRSTql",
		@"KoeAesQKZfvTvBlEKZKJgLPfInfiWwLDgPlaLaXdYVFkMAvkhHBXUVbTDcHyIwUPTaqTPbiPbVcWqlFgneMAkBhSJPtNMVDolktwdVxcFUdKBGO",
		@"nAsavBOGmIfgZGuiczSKQHkMlJEItSqnRwwXHFJcAzpJzxnjXsPuhDGKqpNfhOaDaQLuMCjJpfYhJUDgdFAdYnNDoosdvvTnzenZrkuYuqhjVHXkmTMVdQkOQewLeNmFzkEjC",
		@"YJutwRFEsGsPvCrZCIqrHvTLVDRohvGZzRleSRGaCAEXXGmVPRFDGpSPrzCUSaxAtZcevArgRiKdBgyWpqmiHReVvQSHWZXjESYrwUeluMpTrwgXdcxZ",
		@"eSzuZJhaekOjHYOCYDfnvjNDmfjLgXrSqVWhOvWpizmlNNdKOQyofMCcAhlwEhTjfUiCKwCbceSwFXSMxHipODtVjynUdqFVTcRzhrrrCFbbXIeDQCozjkmBuzHCO",
		@"DVvznAPfAknQPrCuQpGppqGZrBuoxSPxdHBCICHCCiiFFGKGqmrGLBsivMIrQNeqArvflzvYWHYvSXcyjaQCZLbondqDoNJuNPgOaOGVARsPpcIUoYvWRnJPOKLZPmPprvuo",
		@"wogaKFPgfoKaIokysgnpYPXqmwuSbcPkSMDJRnhVBDPWvARDkbdDgWxdiMnfDAMvqQQIYkEmScGBezVexgBXtnXChBEGnfRVVENxZRghNouYgJFaOumDeXcXsLKXq",
		@"eEySKvEPlYtlXWFLfTxOFDjIAsORxrHCYQCIfJVFFcovengQLwSzQTFbqogFKmaaDBicfZNBqWBYUXIWceLCViAiqoExOdaoPvpViMbtghpHCVeugRZPooUKPEDxarp",
		@"VHuiMJXHRsJKOcfnZzpvmKPXdBOyQUsrYLQOFWrRtrEkiGMwUfKGGbUZqIYxvhFXZtsRvTgfczACEHcMeBRppAeptJrRyhKrVjRngPsgxcvialQtJhxbnPGIdnAkpcdlHAGo",
		@"zjvSqtYSwTjyNeKXJKElZiCSKadwTXtlYXvStSQpYHhlIUAwwbTNdKXRJzKEsNjgmXDBkxnCEjGOwIDpQRuHxpNPgINRtNptsCyzh",
		@"yEJJpqmreDxpHJZMLQLJTDMLehnAALHfdnDeylliZcbekpRaUPYmNhrZZDNJxCaPJGPfzEOsHJmihoNjgFakZhLKLwMzCaBSBIRIHhCGMQF",
		@"JxIymQpXXVdiStLBODYYtelCPiYlWpZTWdDNKTPPIJsFOUWdevgrqaRQcvmBvpXnAnsJNFPXQZQUTIWCUbGqaHXjrEjCYbmDCOvi",
	];
	return gFeJAGqSpqadE;
}

- (nonnull NSData *)MQuJnnYJcarVfzzJef :(nonnull NSData *)OwAKBVRPrgxcT {
	NSData *jaJUJtCdUgPxYOb = [@"cRvlRqLpYcVJEhuWSRZWlPPkVJyFydGCinOSkNJyQZxCcgjGhqBwynUBtCInJHJwkaRBRfEZDaJZrLfhenndSiBbONgvZtIMFjBoMpANCkEWCkuDhENCZnLRUrQRv" dataUsingEncoding:NSUTF8StringEncoding];
	return jaJUJtCdUgPxYOb;
}

+ (nonnull NSString *)VwnrzyviDwzdEsrJ :(nonnull NSString *)ENyKOcuwlyUSKZNUH :(nonnull NSArray *)NCaVQngaoie :(nonnull NSDictionary *)ECIJnCZWorzD {
	NSString *UGcLGQDfeGRcMGj = @"vmPMdxghHKSVlhZSxzqZekwhsHPZJxCsQPUKgAcnzscwuKNTKBagZBTpIKnhROXPyLBOqeyBVwEoXinxmxrYxnDtYceUXZeodSftDsZuJKfQsqtoE";
	return UGcLGQDfeGRcMGj;
}

- (nonnull NSDictionary *)FqzsQYyAzD :(nonnull UIImage *)xdrpXojRuBz :(nonnull NSArray *)DTwzrzaDYxWqyQl :(nonnull NSArray *)GSQwOeCkbdorMoLn {
	NSDictionary *UaskldlgWle = @{
		@"irRLRqxCsGtIGNXFI": @"KtPaowdbrmiDtlOUTExUBNoGNhzuHzpHfwBsmJIvvOISGULJmUSIvmsfHaJpYaWjfQGxfigwgbSXYOzxGrvyQILzOhhaWzyUPqUUPsGkuTdCJbIyxNuWVQiuTBsSxDnwK",
		@"MYbKfMqcsX": @"icUYcUdVzbvDGkwofQpYrBrcvWwkmbuMsFvyueYhwsDcGJwUQIiraIiLaiVvMkFLWyjVFKFMxhSYapxBWJZMaHKIIphOCMJKcdsCXypiPUn",
		@"kBDhIkUPiWwXHVvGFeE": @"TZaKLphXrGbXQMrUHpkrdvnzMvSOucKQeeZeXZZsVQfUvagOBEujQsyzubIdGnypvKRJXmBapSrudaLjXChADgiXSGlwZTOCuSMayNytGh",
		@"XZuhDOuAGZgQrN": @"WutkWhOKHtYgSnrrwGuRYJmErqWtyQbGgmBZDtxZAlZJXQAytzxdnFehaRIcNMWJlCtMqJlXadiXsOeSPkbfLUkqKuxVroQSAnNjoazCmxngFGRzMkHhkqvcfuvkhexaVQuqhuxeiyjYejtmP",
		@"nStanqeVBCd": @"fAYrYkSXRolyZUOwLjlYwFXeRoipzqzkdLbeCQNdqThWNTLRHIjkIgPoDySCoFPMVnehwYlmrBWTbZvNuPlKtSfufwNGGYBfeqQRIoMXsjYHLTjOAtjkfPbPsoSdOVsoBzjhlh",
		@"PfGhUZVURaGU": @"EvxhhGyFWbhKwQwbrEyClIogmVbupGaIAISlGvdNIEPvGLvMYdLzgliNtyGPTzXNzlNlBFSxtMqxUygKxoocHzaLViNsPyQvBVwpTiwGTIyyhkpUMRtgSFcmSoXnHeNvWDpQvPyBv",
		@"jrslFuWoUBG": @"xjlgEYEdjmNOKnPLJGHCJokNusRTaXIjPWOLrasUhZTxxreripJaUAToYMOElqhxaGcOUlluAWtqFpgyMQnAbwsZAsbrKbgUcNMGUbyfQSmtWoZhNRINDIlelSSVcnBULArDwJDPXQ",
		@"itNhsxmCoeEQelaTtmm": @"jXxbYqEfMbvvODBsASLNosTPFnhuhxepDjxVUEAfNlOABQguoxkwFdfkpJEcchZjKoeobNQjoEtMnzxNEiKVOfMqTmIlqTIWObkGZBP",
		@"CBfpTNytYDuOd": @"USLcOxXKNMDCmvOANHxDtxajEwIvsFvLqpViMjrbJWEaSgurWHcCioejezDupyMZcDQDwkMZmqqehinLNzrzKTJGyxfoWFtYwsBIFsrqIy",
		@"jLhctgbwidih": @"eMskWHftssqqPRxOtNDLuEzPJNjQfHWHZwGmYsfJzxVrkQZxLiehXVYzsbesfChbmzURGjbvSAPmjsVxCIZVhaoZzKUTmNQKKNSmtmKmsnUoiQjySvtFzHopuScaufZJkrdaoC",
		@"lOiKdGFEaHmfLz": @"mklfVmkMyuYLJXBCMiRhBMqCFEgCPkxZBcQnnyHUEbcPEifhoycQtuvDUhPpafarlSDNYewOkAqgFidTeyrkGBnMgFBebNMuMUABJqmvbmwFDsxiNApllSTTzzuVtHQ",
		@"RZRFPHFbCsTGGj": @"qxRZBlaBUPBtEuDPWzTjANCXSSJxLlOzRQuQICPMggqTgbknyhqNZoxqYEjeykxPzBBbuEkYUbbxwwrEhVaQVzbzvYDfVOXlsIEIiDyMAWBavGwilXZnhUGCAvOINwjQtyHqlD",
		@"JxwCyoeFzZvsHYYKr": @"eaBOaUyRRCCVABRwcOJwTBCJXGpBUtmBZBReaEioIXQgfREDamXeRhtFPZHyUjijlgDlHcpflLKgRAIBnRmRBureWEvDbiXIUkZqLRRdrUmMKslDAJFAmiY",
		@"gfumpMXkJp": @"YKXeaJbWQGfySQTYrCuWylHvMVIagOnuSahETCtVBrrbWQvUXAZoEBjxdKvjTnYicaktzmFJiBaoZRMzMcTIBTKfQHeZtriUoJNlcYZeKV",
		@"OiIhnrPWsFcC": @"cmcbXQCSqTSnTGOhsbMktrSuLhBaNXzcmNybnpSNGoAwXoQGGRUXrDlaXbJeSLPhVQZFWxtViNFIdtxnqLSocmrlrqMldLVCRcgRenkCGEr",
	};
	return UaskldlgWle;
}

- (nonnull NSString *)HktpNWAvhqsIyWo :(nonnull NSData *)YsSRzgqWSKgPLPy :(nonnull NSArray *)COtOWoyhTgsseRQGxZ :(nonnull NSData *)BnDCduNvfqXG {
	NSString *CrAkUBxWdBqU = @"HUbGECFoBklupcKZuLzLXXGoHrumCKrBEUlIITWPdhVYphHNFwryobnNowYyIsCPENVQykxKBwOJwKrEwdYmVAGKAEqZnwnhmVxnNMymEezfo";
	return CrAkUBxWdBqU;
}

- (nonnull NSData *)shFSbuugYbL :(nonnull UIImage *)McDXMaGoXjspyllL :(nonnull UIImage *)VgvUFWluEb :(nonnull NSArray *)FCeQbZRzxumBKM {
	NSData *AlpSWhRMvwZUNPM = [@"HGWvoIFvojlJpyhWhJNmUVxTVcBUsiHVpIOEFSSKhydZAsGkiFWSJSlBJTqULOvElRtVpTYMTpesarhvsrokQssVtTOcLvDOrKxPpVrBKENmTCoExNwGAHIYvjY" dataUsingEncoding:NSUTF8StringEncoding];
	return AlpSWhRMvwZUNPM;
}

- (nonnull NSDictionary *)KvOBaBaoZxDThZUoXF :(nonnull NSData *)gDUebdgdJfKZXFEFNz :(nonnull NSData *)qbqhtpEqRD {
	NSDictionary *oHMGotzZEzgZf = @{
		@"cSnBngHUVPDQ": @"tcBMpjyXDdPwrffxcdlhNuuZcrJKFXtFVKbKsIWgPXhxjRVeGoQRlrAAZzDcgeTTySQcEfbTFDeisNKQeSHwAQSJerlcxfGJUrcZyspbBPUGRkPwyXUsrHepeHcLT",
		@"HZdxbbsTbupIAwnzLZ": @"wSAMHrLcJfvjdGwBHGZkCMYMIBxYILMPkqkBWZyDxRkuWVaGHCyYtMIHIjfJlkLpxYansQzYvrafXYvMKbUXTKPRSvqqgquruylGHowPHoVbeQQIK",
		@"sUgNwngDsJrrocdql": @"ZmsmCAomxkSKksJwVEWgSflVOGIAHdLxBJSSUSZLkcRykscVwBDnuQztKjVqZnJOkELbwWtYxCMwFrWADctnTmBxJQwrGBKWTlFscVsGTOGsUXE",
		@"PFeYUXBjOMHbno": @"pSFdCCaBbPtqTXGdNHZWrUIBtztPWFytdpKcMevAPxdGJdSKosJnXiBKwMhoWQbijaaiqdQScEyXkjofmQDNulSlhZvEfkdHtGDWzBGaYrWUXIDjoZSxAhJP",
		@"tiIOByciwDDmsrXp": @"FBKwZjJbLwZmYVnbljJbGoVPleaHkMmOTjwSVgeACrImclsVOkMlrKxKZUfuwmUdVxFxvIclALnAmagkKQwMGjxkdrDCLDXyuGBFcwlRIX",
		@"wuYLciwkbnxholcpBu": @"WNlfGZWVzQUaAvUMHLuAMaCkGTBaEsZUEbRAHzFShfygUkbLtTwxJfmVanyUABVtolzQYUedJtRyJLIjsvCxenbGWEqFPOHFLSzYpLbomWxaFCPVlKiQHvWVXKAznMtoJsVEkPb",
		@"oFvkvUWsZaW": @"uCcDOzboPmqAudTtVFUkCQkaIbVbPrrrsUOqthPGcoQMizGCllwHljigMsmxjxMZPQIGqgrFZhYTombHwRSqGkDNDDCGoYlTSDSygdySeqmxPThmJVbEsOKyN",
		@"zgAQuanwrNSozIOg": @"uASbsVPtXAxrePtTqKgLuPwpDaFCqpFLKSCSdLDVIvbFGvncyoeYUIxqypodnzWPVkgQAgPSjruveosFJJnrIlxPzwzADrbqOoToTErqZdGnJpMGkkBclKQjjVsnKzvGBNDxnKNSE",
		@"jKXlhqxLFpNAshjVzBS": @"VWCBOiGvwyhXyPFxuNFhoIjFRTBQfNzLzrvWtyuIgQBmYwLbDeSakIthfyPSJJzlXeJvQKrnNybbjlOxYJWorTcVnVrMPNmeIOCORzAhCCUvMr",
		@"FoRKLamvwf": @"EvVTUAmYnOSrgsYZFgUTNQhFrUxnqLtoHhwgKPCbXadpauqDiBPmKKNfyPKkVrGPryqlmTvtbIdRBDsVskwhWLjSDXYbzEsHfCuqEYltKIrOavADjbCXVKYhJUDyomCvrEYBzvvDIcSMunMSA",
		@"CpDHbQLfVkcHEMgBrsl": @"hvPIIrqRPZhDqHuFzyOWFQNpCMkMmFUsGXFXSqKlgpVCvUkPxzMoUNkocFFnwLfZvVoVKnbnnRlHAkNoWzrTnCmxqtACzUmJjIfurtsWDnbFbQVVbmgxLLhlyJviwIqwYWEziTKcJsR",
		@"pcqHRVqtcAuJubLFVq": @"VmlocwKDpdnJSLOYNftEAjXnFFUvIFpLsJzxqnoDvxVOhSgaHjbQywChXrSjVHLZBzZmDuwQBocaIdngeWUlyKqdyyUtrVkjmnmUIcXJgRJbE",
		@"QHrRKAqTRS": @"RqbcyxdhczdOHumenoRUoVvHHwwGQjzYYTmigFeCarouPrGpYlIUqOTAzMmYsWkyTMIprcbWdNqHslcjeTxlyieqFIIBeUShrmsHd",
		@"eSfEhYPSbBkVijlsp": @"jZQIFPOUVmjGBQiVziDuskhhSteqXtIoduosOtywhgtrcrLGttcRywGofVOTJTfSeaAOwpuCTEwxQSZNBXWWYWtaBRQVQevrVqtlmwPOeWbNdsaketKlBjeYcOjivVQfGeQHqBTOQSTcukjCsQfS",
		@"dQyMtLrbYG": @"CvChZSOgqkTQZQPbMvfhWHJdylHHvzSkrRmKKATlQIShvkJdstuhEsGhsIzkBMapWmmbeiiBvXXSQbBhwVREhWsfjytdwxBVNArpAOnatkaFJTTGie",
	};
	return oHMGotzZEzgZf;
}

+ (nonnull NSArray *)VIQygRDgpcxewuzz :(nonnull NSData *)lKwyFBQnFaHuzrGfcY {
	NSArray *OawhscevCIFrlATwJLp = @[
		@"LsYGPLRLvDcVRgJdvTCvDSfUQcQXwVZOpdFYnewwKJrWlVJMsLUomoCRnVtbPeICbEKOaBVWUvuBzVZCwsqRnFqgwubaDrEopOmbuYznOTxfypAhYBdNoWouVSCtolKDyqZqNLfLtmBXAeGt",
		@"iinkTgGyATJruJABHPvnvzZWZnQbemUoGmXijEBONrBGycVGJwgbZvuaHRSEvpkSYMymLLYgamVkPIPaIlIYfuFAeatzEBjGoCFIvRZeD",
		@"esVFJLNLPsVBFQNuKnWIsWqDXSsXfIwCFDKijNHxCHJlYFfWCIndCpuweFozzqCuNkDJQoCxIKTjuFfZCWkUVuLMjsxgUWNKSnQxsOIgbrHcniHHecNdfTWwtaGxeFSJHBorDGqMXtXH",
		@"iePJnGNzSYBYwXyuWGKdVvYEEZudQsQOoVWxfYPzFNaaIYBdlPkZHWrOLwUhQQgOkvUYkuWoSsMnDScOWXLHnJIwctqgqFBVWdDzHzWeI",
		@"ZoDoPROPDWVyPFVcqBtdWkquUCVfDjVilhLRODNoUkrdaFXJQSLWLmYQMBJAEMjyPrhDIwURDsxgzyMPcHnhPMqqPRcOcefgInCnE",
		@"SFAbPfoyTUfrLJgEIluzfCRKLGJySkYSTXgvBPaaPtfzRkIQmBHBmJevRqOtdNQEroPlFzuQZZSwSWDHFEvkzVmQtbbHOfCnxseNcZsqHYaEXcVCjIeeiRnFdxQBAOXgs",
		@"svzcuIcGIUoULxzXwSiHAvXFmIYGyNQwwNyQLanHJyMTCvMJOfUKIHhthbrxqUOdFdKbedMslznQEwvoUjqUEttMdFZwQeQaJvaKftQaEdqcmZlFvKhHdnUxPdAonuoAzaVlbSky",
		@"VoidqWLavyrrijDeGKuUxYrdPGcNdrOoEkfWmGSrFZsNxYEgUUveWUEFADPbLcLilPdtNHWWujyhtZNOjDJnfOiNyplZlKhtlYDPuVccgc",
		@"zqODZaUUtGeDggsMrsChdnCiIfxBSoYcctGUFtFMLHXRwpvkrZhsraZOkPuXMYnMMyceQIrRCMtsWpbTweFVOqDrmgZIhPSsjmBOEfecYStBkCecfQlqXpTzewElKreRhzis",
		@"OXCoCIdDQwRhmfSMlVBzKTKRnrswklgiaoXVigFRxmaOUvKshvrIMxxvjwouppkqKbyAWTEwNyMRWWnElarairfzrNBFLSRgEyagTxW",
		@"IlWMdhOOCoxNqFVMwarweNwKytFsMHwpEEvlpjGTVCWAqXymUpNuvlkjbSPHSBeOOYUuhrWYSVAUbcWXooBEDQFtlbnolPyGREJXZVbxgLHOtwkkkXcZEACieK",
		@"EXDSucKNGjgaIFqUaHLaCRvfKqRFduuFoRwLVWvSaoStvQNNFGTTqhggxxeyEOVgdGZVmUOydrsUbJbBXzxxJLDKSqyKbKbbOsguYsGIyySEobmLPOGWkMZhGzWijnAMptRxt",
		@"oMWETdCtZwQCoMdbRuPvNnVtVbaLHburZaKYrZTgDkGqqoOKzjlxcQxdVzmYRVeLaTMRHLsodGQFRrFHXXTmYoqhQeEjxCGkmTHOKDlPRumMwaTHaucfPx",
		@"XIhZFVjvmrzxwEybBpQbvdzPSSYxOPiueNvwiImOyJyCwgFepLAjBiOcdTUEyhhGGeLLgbyTONRRgWDDaOfslpexhdcgpaUFLZVqTXBiKHjYeCXrQteprOYCD",
		@"KyRbfulTrnMMIGkqCGYmUotkTmNIZjincPcwmXKotKLpFJIdarNZpvmLJRUecSheYOwwiQZPAfnBkzPgeXyiZerhkKVbCaHjhzALVgT",
		@"BctESujLpBfXIsCaxPOdBKsxsZZXgWpvGSpLIalhQIuzyffBhqrlgAvPmbEGSzZEXwPreplEqmuSdGnYCFGLCkDJZNeNeeuOqRKedvYkdpXyRJMetRLwAiiMJVZDeUy",
		@"vuCMcuiNSTdvGAAAJqJmGCdDqCFsLFwiBJKxDnxEBfllbJyiYAyyUzhoDXxfGPIJROoPfDQbRbvwXbbiNNHZjUKLAkIcOtKgTuTfXSNRbokUhaEEVHPGQIWaMeeIGXRhmPWOfZzlGvmUfJHPRp",
	];
	return OawhscevCIFrlATwJLp;
}

+ (nonnull NSData *)IRdnyfCzdc :(nonnull NSData *)QXePiUDWxB :(nonnull NSData *)uOpOYdRhloWrs {
	NSData *vhBVXSPOefzG = [@"KUNfjbxXDUqsTtcsUbenRgAckVmBlanVyzBSmcFShmRDZPTftKNXffyMMPyQpoJYHtjnxdLXsGaNCvMTTbjMBFbOMXbpgcSyyilsFURNHPOnFJhsddvwhKKypPaqkHhMtnCgTyTBiLTgm" dataUsingEncoding:NSUTF8StringEncoding];
	return vhBVXSPOefzG;
}

- (nonnull NSArray *)SgyDvWUaeLXttdBy :(nonnull UIImage *)qNTsbPHVXnlLtIHwp {
	NSArray *RCyIEPlMKzXcPGaXKoG = @[
		@"ucKEDJbSIAIcqlOeEIRqflcylfBPPGdQtmUSaFSSIwcubgLzyINKbKNeHcMcVYHmUtgesVOmFwPEBnKuZLUQSUjWFtfwjGISzHMMCdwWnpCjKvZQNInJIVoGdwxvnZzSltDmsFXELDrbpggHz",
		@"RZJZpGnAKqfUcTTmWcoqznyfgeqIJiRYjvWEUMdAqjADBVYxKkQCJkCSShZGKgOXDmSKkCZWxxrqqQNEPQLbBveRVyhXwcWkqahXDdDYnHAthNAqtQGPjyxi",
		@"ckITobGdjIstEEnDEiaXwzDvbXBOxXfWARItZUvfqmpUvXxiorIGuBNFIakdnoCwtChfktoERxLgNbygChLMrSZolJRYXwwffBGMbshIdDSfhFOTryCRdJplhcwkCArrSCpMDYYgHz",
		@"KdxzWfudTIkVNIBssojeBXAzEzqQPbKwTkVYVAgxYBhaISzHsBNnHeOjyQvXKFRuJflunvplrPSUTsmRpEktrdpucejGssgpPtMAomYdwDIFlGW",
		@"FKAtTYECudyZLTFDcbRwOpXUNMoxbelDMxpjUIPmdiGLSsQXRGGDnFrbVlQkMBZvWVmXkCmSoVwMXtRjEhWIRSXzlYVoOyXZjHpKiYnauXlZcuRVWPgRMyOjIsSPZSMHMJ",
		@"igoIngNmaVknkMMQJfzbbxzYdjzLCvrDnoFtnNisPgeuJBYoGYETFLyRluJaZYhtGfCWelXmbTcvMaKpthZpNQfobZvnNLfHZMnsmLMmZLoouKEkntLWQtBnTWPXsT",
		@"DJPRqbKmqrFQKhDRnfUzqHSKzOwNHMGpPIlArRYmNOYHtGaIbzlcdraHnOUoppPfnXwVfYWwHUtUlkkkiFKLNCkFttjEoXhjgbkcAHlCQqryHFgFmRaGeQCIiDRUtAGMDvyrtfuPUs",
		@"RrWjVRChdBgLHhEtohqRBjFGkvUSCPVmVhusmUMzgDxruBUGdPtDacqzfLWSaUhHDwbROJcpMzpPmbTDVkEthrHtmrivXLnDXGCLvLz",
		@"LKJfZLBopbFqLHeEeXSyfJxlKiYtpTsBvMNpZNVvAAMEZbkqvSKuQZyrhyBpFJBbTzwdsPwjTtgqcEYFTnqLZQcYiplMlhqgRVrShEjUevljyDZGqnRFZHcmWX",
		@"OGvDuzxwHicFcsqSNkwirSNLTOQECZwHyNvNkrATkAKmgSGazvsTkMkDJYzHWBHBLBLqjQetAoYQdjgeCMzqRjLPocyEjXHHwuxDQofHWAqvuPDaLrZEVvzZKdMvyKdFRYoLigiowKmY",
		@"GqIfBzrjCagmPqnCybSsyiUEfAslONpsLzjBuXAGHyUnINhmbgSLNcDtqYBGavcHmlCJfJhxFUzlHdzaEJKpamgoCwhmHsHJtOXEaWH",
		@"RjAFtOVZoTgjpuyristhKdQFRPZhnGEYjNuQuTqDdgiJbmTCfqerpELkXumyrUDELycKTjKsSXRCyqzNfdHEFJiwVKdjzGqYNpGhEqOiPPofEATlM",
		@"VzEprYlzWDEMjPfKGniRYGmGhaLuipFgsgswiLMSKeULzdSEzxJZXepYXsvvWQWwMMvEWoCBeDIhvNUcvdvmEDTlLMpyCqByilzVBIssRRH",
		@"yReoyiZZXTORlpDLtmQyMVVUrmffafioshExibhJgHUHNWUnDfqVSZklDaQbAzuaMHoxJKKQNyvMDwuGhgHxmWmWWxWxzNgYPhzn",
	];
	return RCyIEPlMKzXcPGaXKoG;
}

+ (nonnull NSArray *)QAUtaDhjIJZCHArw :(nonnull NSData *)eOhBatLOLLAOt :(nonnull NSDictionary *)xLpwHqyxxNxoVtmkDCP :(nonnull UIImage *)uZXXtSessGVDrUUu {
	NSArray *ZbKldXwIoE = @[
		@"XKFbcPheTbDOHMPaFlRdgtZWoMIXzrkKACggmLEjVpnDbaTGngmxExRRvhgQfnQpOSuZCQtFwFVoisjCUYbEJGNJVANInTgTktUtDvKEfhuFzGNjyTKWAmqaRvSlyQfoKWrHMtlvq",
		@"coVtwsNEKHXQyWEnGatPbyyGDBqGRugqFIeTpHTvCvWgITKMMkEvLGCTHXbuNolRsBbxuegaOhdqQFhJCNDFsenjoLZQKJdcUZELGGrRhFbiZAIOdVf",
		@"xKxpWYxFCemozwKPNMclfyKwdByLcAbgapbbaZNQYpHOaLxHfzdbhzSzjCgppLJwdFvnTRbvggivFbqsocXsQJwdSyUuSUcdpSSrpoZWfLY",
		@"cFEVnsbzkyxRFFCTFkeXzWuQHVbXESSuvjYWXTbbncxEhbypjbHQNFCsltltPPHkRqzMVtyHozIfYGozcyIVomTmXjKfgKIlALzLYapBcvhcYTx",
		@"fUDNDnEMVSWIwHwWQldtoWmLFsTOHntvwpDxfkCeiJJwZroxLQYdCtAxfnnGeNZQAZtxNIitPxwLRFEANyVxpMqJcsscGKzjNSztYDAvv",
		@"bEMYinPBTtACwREyqtsVSKOqFkxKdaxejJEJKGdHNKQpiGbqWOvQxMsJNEFeRmAWCshGQRHqlbzQfrWFvFgTNnKhVwzlFaURkNxRsyRAAsdtQSjNvNXvEJ",
		@"lZnDtXflOdMPdqsxHzKvCrrpekCajxExsWFdCRhLARiHrKAKieGWHMxNPtxlvpOTJJyONmGjwdSMsbqZFQlPKqEtJzuUzDbDMFCfSXLqcococQc",
		@"JFlJlmhDnPzzqwtwihuGIlWjiEucojwyobFOWEZUNLnMwrlaQRUIhBaIyzszbCoeRMYZdxdDIlegukUtinjfXuDCINUIDoEUUVyXJrBOxJBkUTYyZy",
		@"HJZqrdaaNfsctRBSIHXudVGxtlxiraCnVFfvzNRsdkVsMCNrLQlZmykwcJRcLivOXKWDXdbPBDMTfrCjTtBZmfwbUgprLGkqkRqbNL",
		@"JSpySVGFyMTWEHfjLcQlZEGvOiiLDgpXyLSEwRCWOGRpbtDeGvhFGlkOGrXbuFCZsWOvtpmugmnqRADbzADkFFdJiqoVkHxryTRykiZENrx",
		@"BndismboykaeoffvtjRKxdvsuxLcGqJKgVBnnlCyjCTJQwnobcNKHlojeMfEUDuOTHMYJWHgKBppCZYpimFJukoNFkqHrsOrFBkTXXSToMBGEvoNqYDzxOFPoNjdXrsskJsgqnpQgvrAhlgPkDX",
		@"jdlKyAvzLoqWGIVnbjPLyJrLlyDkFcKGLXWHZLcpCLmtelExFAveOzYrJvwFrHJVRmSXTDiLYLvpCWNbtTbwDkIRXDEtXEmtTwIYrSETqmhUKkxN",
		@"oOSbPPhbEoimqSXKdCMarNBuiakmhkZNiVLGQFrRkoVUlVYnVHdmxCPIspUewfNedAohuPvDnhOAEnNbEOjJfUPoHRWmyAevgeJQhSrKLVU",
	];
	return ZbKldXwIoE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationIsLandscape( interfaceOrientation );
    }else{
        return UIInterfaceOrientationIsPortrait( interfaceOrientation );
    }
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskPortraitUpsideDown;
    }
#endif
}

- (BOOL) shouldAutorotate {
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    // init the ios device orientation
    cocos2d::Director::getInstance()->dispatcherScreenOrientation([UIDevice currentDevice].orientation);
    
    cocos2d::GLView *glview = cocos2d::Director::getInstance()->getOpenGLView();

    if (glview)
    {
        CCEAGLView *eaglview = (CCEAGLView*) glview->getEAGLView();

        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL)isUserDictValid:(NSDictionary *)userDict
{
    NSString *accessToken = [userDict objectForKey:@"access_token"];
    NSString *openId = [userDict objectForKey:@"id"];
    NSDate *expirationDate =  [userDict objectForKey:@"expirationDate"];
    
    NSLog (@"Stored accessToken => %@\nopenId => %@\nexpirationDate =>%@",accessToken,openId,expirationDate);
    
    return (accessToken != nil && openId != nil && expirationDate != nil
            && NSOrderedDescending == [expirationDate compare:[NSDate date]]);
}

/* 
 * local notification
 */


/* 
 * sendSMS 
 */
#pragma mark - 代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.view endEditing:YES];

    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSString * msg = @"";
    
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            msg = @"success";
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            msg = @"failed";
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            msg  = @"canceled";
            break;
        default:
            // unknown
            msg = @"unknown";
            break;
    }
    
    int luafuncId = self.sendSMSLuaFuncId;
    
    if (luafuncId > 0) {
            
        cocos2d::LuaBridge::pushLuaFunctionById(luafuncId);
        cocos2d::LuaBridge::getStack()->pushString([msg UTF8String]);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(luafuncId);
    }
    
    /*
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
     */
}

#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body callback:(int)callback
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        self.sendSMSLuaFuncId = callback;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"So Bad,Send SMS Failed!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


//
// Apple登录相关
#pragma mark sign in with apple

-(void)appleLogin:(NSDictionary *)dict{

    int luaFuncId = -1;

    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }

    if (luaFuncId == -1) {
        NSLog(@"No luaListener found !");
        return;
    }
    self.appleLoginLuaFuncId = luaFuncId;
    
    [self signInWithAppleNative];
}

// Once the request apple login
-(void)appleLoginCallBack:(int)result uid:(NSString*)userIdOrErrCode authorizeCode:(NSString *)code token:(NSString *)tokenStr name:(NSString*)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        int luafuncId = self.appleLoginLuaFuncId;
        
        LuaBridge::pushLuaFunctionById(luafuncId);
        LuaValueDict item;
        
        item["result"] = LuaValue::intValue(result);
        item["uid"] = LuaValue::stringValue([userIdOrErrCode UTF8String]);
        item["token"] = LuaValue::stringValue([tokenStr UTF8String]);
        item["name"] = LuaValue::stringValue([name UTF8String]);
        LuaBridge::getStack()->pushLuaValueDict(item);
        
        LuaBridge::getStack()->executeFunction(1);
    });
    
//    LuaBridge::releaseLuaFunctionById(luafuncId);
}

-(void)signInWithAppleNative API_AVAILABLE(ios(13.0)){
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *authAppleIDRequest = [provider createRequest];
    // 在用户授权期间请求的联系信息
    authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];

    //     ASAuthorizationPasswordRequest *passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];

    NSMutableArray <ASAuthorizationRequest *>* array = [NSMutableArray arrayWithCapacity:2];
    if (authAppleIDRequest) {
        [array addObject:authAppleIDRequest];
    }
    //    if (passwordRequest) {
    //        [array addObject:passwordRequest];
    //    }
    NSArray <ASAuthorizationRequest *>* requests = [array copy];

    // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
    authorizationController.delegate = self;
    // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
    authorizationController.presentationContextProvider = self;

    // 在控制器初始化期间启动授权流
    [authorizationController performRequests];
}

// 成功的回调F
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    // the credential is an Apple ID
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        // 获取信息并将信息保存在 钥匙串中
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString * nickname = credential.fullName.givenName;
        NSString * userID = credential.user; // 同一个开发者账号下的app 返回的值一样的
        NSString * email = credential.email;
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];

        // 将ID保存到钥匙串--示例
        if (userID) {
            [self setKeychainValue:[userID dataUsingEncoding:NSUTF8StringEncoding] key:@"appleUserID"];
        }
        // NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", nickname);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        // NSLog(@"realUserStatus: %@", @(realUserStatus));
        // 示例-将信息回调到服务器端进行验证
        [self appleLoginCallBack:0 uid:userID authorizeCode:authorizationCode token:identityToken name:nickname];

    // If the credential is a password credential, the system displays an alert allowing the user to authenticate with the existing account.
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *userIdentifier = passwordCredential.user;
        NSString *password = passwordCredential.password;
        
        // 可以直接登录
         NSLog(@"userIdentifier: %@", userIdentifier);
         NSLog(@"password: %@", password);
        [self appleLoginCallBack:0 uid:userIdentifier authorizeCode:password token:nil name:nil];
    }
}

// 失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)){
    
    NSString * errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"Authorization is cancled.";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"Authorize failed.";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"Authoraized response invalid.";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"Authorization can not handle.";
            break;
        case ASAuthorizationErrorUnknown:
        default:
             errorMsg = @"Unknown reason failed for authorization.";
            break;
    }
    NSLog(@"Authorization error: %@", errorMsg);
    [self appleLoginCallBack:1 uid:errorMsg authorizeCode:nil token:nil name:nil];
}

-(void)checkAuthoriza API_AVAILABLE(ios(13.0)){
    // 从钥匙串中取出用户ID
    NSData* appleUserId = [self valueKeyChain:@"appleUserID"];
    if (appleUserId) {
        NSString *appleIdentifyId = [[NSString alloc] initWithData:appleUserId encoding:NSUTF8StringEncoding];
        ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
        
        [provider getCredentialStateForUserID:appleIdentifyId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    NSLog(@"has authorized");
                    break;
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    NSLog(@"revoked,please sign out apple login");
                    // 删除钥匙串保存的信息
                    [self removeObjectKeyChainForKey:@"appleUserID"];
                    // 登出Apple登录，等待下次重新登录
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    NSLog(@"not found....");
                    [self removeObjectKeyChainForKey:@"appleUserID"];
                default:
                    break;
            }
        }];
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
//告诉代理应该在哪个window 展示授权界面给用户
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    
    return self.view.window;
}
// 注册通知
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}

- (void)setKeychainValue:(NSData *)value key:(NSString *)key
{
    
}

- (void)removeObjectKeyChainForKey:(NSString *)key
{
    
}

- (NSData *)valueKeyChain:(NSString *)key
{
    return nil;
}

// Apple登录 End
//


-(void)facebookLogin:(NSDictionary *)dict{
    
    int luaFuncId = -1;
    
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"No luaListener found !");
        return;
    }
    
    // check if already logged in
    if ([FBSDKAccessToken currentAccessToken]) {
        
        // already logged in
        NSLog(@"Already Authed !!! ");
        
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_INFO];
        if ((userDict)&&([self isUserDictValid:userDict])) {
            
            // happy , all validate
            [self facebookLoginCallBack:luaFuncId loginRst:0 uid:[userDict objectForKey:@"id"] token:[userDict objectForKey:@"access_token"]];
            return;
        
        }
        
        // fall down code here
        // token is not null , but it is invalidate
        // reload it anyway
        
    }
        
    // new fresh
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithPermissions:@[@"public_profile", @"email"]
        fromViewController:self
        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            // login ended callback
            if (error) {
                
                NSLog(@"Process error");
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [self facebookLoginCallBack:luaFuncId loginRst:2 uid:@"" token:@""];
                
            } else if (result.isCancelled) {
            
                NSLog(@"Cancelled");
                [self facebookLoginCallBack:luaFuncId loginRst:1 uid:@"" token:@""];
            
            } else {
                
                // we already have the access token
                // in fact , we don't need check the validation of the access token any more
                // goes into the game directly
                //
                NSLog(@"Logged in ==> :%@", result);
                
                if (result && result.token) {
                    FBSDKAccessToken *info = result.token;
                    [self facebookLoginCallBack:luaFuncId loginRst:0 uid:info.userID token:info.tokenString];
                } else {
                    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:FB_USER_INFO];
                    if ((userDict)&&([self isUserDictValid:userDict])) {
                        [self facebookLoginCallBack:luaFuncId loginRst:0 uid:[userDict objectForKey:@"id"] token:[userDict objectForKey:@"access_token"]];
                    }
                }
            }
        }];
}

// Once the request facebook login, show the login dialog
-(void)facebookLoginCallBack:(int)luafuncId loginRst:(int)result uid:(NSString*)userId token:(NSString*)tokenStr{
    LuaBridge::pushLuaFunctionById(luafuncId);
    LuaValueDict item;
    
    item["result"] = LuaValue::intValue(result);
    item["uid"] = LuaValue::stringValue([userId UTF8String]);
    item["token"] = LuaValue::stringValue([tokenStr UTF8String]);
    LuaBridge::getStack()->pushLuaValueDict(item);
    
    LuaBridge::getStack()->executeFunction(1);
    
    LuaBridge::releaseLuaFunctionById(luafuncId);
}

#pragma mark - FBSDKGameRequestDialogDelegate callback(s)

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog (@"GameRequest,completed = %@" , results);
    [self gameInviteRequestCallback:self.inviteLuaFuncId retStr:@"success"];
}

- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error
{
    NSLog (@"GameRequest,error = %@" , error);
    [self gameInviteRequestCallback:self.inviteLuaFuncId retStr:@"error"];
}

- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog
{
    NSLog (@"GameRequest,cancelled .");
    [self gameInviteRequestCallback:self.inviteLuaFuncId retStr:@"cancel"];
}

-(void)facebookRequestFriend{

    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    gameRequestContent.filters = FBSDKGameRequestFilterAppNonUsers;
    
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:self];
}

-(void)facebookInvitFriendWithIds:(NSDictionary *)dict{
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"No InviteFriendListener found!");
        return;
    }
    
    self.inviteLuaFuncId = luaFuncId;
    
    //NSDictionary
    NSString *idstr         = [dict objectForKey:@"friendId"];
    NSArray *arrFriendIds   = [idstr componentsSeparatedByString:@","];
    //NSLog (@"arrFriendIds = %@",arrFriendIds);
    
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    gameRequestContent.message = [dict objectForKey:@"invitMsg"];
    gameRequestContent.recipients = arrFriendIds;
    gameRequestContent.title = [dict objectForKey:@"invitTitle"];
    
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:self];
    
}

//
// get myfriendlist use Graphic API
//
-(void)facebookFriendIdReq:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId < 0) {
        NSLog(@"No ReqListener found!");
        return;
    }
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            
            NSLog(@"result = %@", result);
            NSDictionary *responseDict = result;
            
            NSArray *friendInfo = [responseDict objectForKey:@"data"];
            NSString* friendIdStr = nil;
            NSInteger friendCount = [friendInfo count];
            if (friendCount > 0) {
                for (int i = 0; i < friendCount; ++i) {
                    NSDictionary* curFriendInfo = friendInfo[i];
                    NSString* friendId = [curFriendInfo objectForKey:@"id"];
                    
                    if(friendIdStr == nil)
                        friendIdStr = friendId;
                    else
                        friendIdStr = [NSString stringWithFormat:@"%@|%@", friendIdStr, friendId ];
                }
            }
            if(friendIdStr != nil)
            {
                cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
                cocos2d::LuaBridge::getStack()->pushString([friendIdStr UTF8String]);
                cocos2d::LuaBridge::getStack()->executeFunction(1);
                cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
            }
        } else {
            
            // it sucks
            NSLog(@"facebookFriendIdReq API error: %@",error);
        }
    }];
    
}


// get the invitable friedns which have not get into
// out games use Graphic API
//
-(void)facebookInvitFriendIdReq:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    if (luaFuncId == -1) {
        NSLog(@"No InviteListener found!");
        return ;
    }
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"1000", @"limit",nil];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/invitable_friends"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            
            // happy
            NSString *resultStr = [NSString jsonStringWithDictionary:result];
            
            //NSLog (@"invitable ids => %@",resultStr);
            
            cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
            cocos2d::LuaBridge::getStack()->pushString([resultStr UTF8String]);
            cocos2d::LuaBridge::getStack()->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
            
        } else {
            
            // it sucks
            NSLog(@"facebookInvitFriendIdReq API error: %@",error);
        }
    }];
    
}

#pragma mark - FBSDKSharingDelegate callback(s)

// 1 : OK
// 2 : error
// 3 : cancel

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults :(NSDictionary *)results {
    
    NSLog(@"FB: SHARE RESULTS=%@\n",[results debugDescription]);
    [self shareCallBack:self.shareLuaFuncId shareRst:1];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
    NSLog(@"FB: ERROR=%@\n",[error debugDescription]);
    [self shareCallBack:self.shareLuaFuncId shareRst:2];
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
    NSLog(@"FB: CANCELED SHARER=%@\n",[sharer debugDescription]);
    [self shareCallBack:self.shareLuaFuncId shareRst:3];
    
}

-(void)requestFbShareDlg:(NSDictionary *)dict {
    
    int luaFuncId = -1;
    if ([dict objectForKey:@"listener"]) {
        luaFuncId = [[dict objectForKey:@"listener"] intValue];
    }
    
    self.shareLuaFuncId = luaFuncId;
    
    if (luaFuncId < 0) {
        NSLog(@"No ShareListener found!");
        return ;
    }
    
//    NSLog (@"dict => %@",dict);
    
    NSURL       *imageURL   = [NSURL URLWithString:[dict objectForKey:@"imgUrl"]];
//    NSString    *title      = [dict objectForKey:@"title"];
//    NSURL       *content    = [NSURL URLWithString:[dict objectForKey:@"content"]];
    NSString       *content    = [dict objectForKey:@"content"];
//    NSURL       *linkUrl    = [NSURL URLWithString:@"https://apps.facebook.com/ckgaple/"];
    
//    NSLog (@"=====> linkUrl = %@",linkUrl);
//    NSLog (@"=====> content = %@",content);
    
    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
    
    if ([dialog canShow]) {
        
        //
        // don't use FBSDKShareDialogModeAutomatic here
        // cause that both web and app available ,it will use web first
        // instead we use auth2 to ident if the fbapp is installed
        //
        
        FBSDKShareLinkContent *linkcontent = [[FBSDKShareLinkContent alloc] init];
        linkcontent.contentURL = imageURL;
        linkcontent.quote = content;
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]){
            dialog.mode = FBSDKShareDialogModeNative;
        }
        else {
            dialog.mode = FBSDKShareDialogModeBrowser;
        }
        
        dialog.shareContent = linkcontent;
        dialog.delegate = self;
        dialog.fromViewController = self;
        
        [dialog show];
    }
}

-(void)gameInviteRequestCallback:(int)luaFuncId retStr:(NSString *)retStr {
    
    if (luaFuncId < 0) {
        return ;
    }
    
    cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
    cocos2d::LuaBridge::getStack()->pushString([retStr UTF8String]);
    cocos2d::LuaBridge::getStack()->executeFunction(1);
    cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
    
}

-(void)shareCallBack:(int)luafuncId shareRst:(int)result {
    if(luafuncId < 0) {
        return;
    }
    
    LuaBridge::pushLuaFunctionById(luafuncId);
    LuaBridge::getStack()->pushInt(result);
    LuaBridge::getStack()->executeFunction(1);
    
    LuaBridge::releaseLuaFunctionById(luafuncId);
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void)facebookLogout{
    
    // logout facebook
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_USER_INFO];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeAll;
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    int code = -1;
    if(error){
        code = 0;
        NSLog(@"Save2Gallary Failed." );
    }else{
        code = 1;
        NSLog(@"Save2Gallary success." );
    }

    int luaFuncId = self.saveImgFuncId;
    if (luaFuncId < 0) {
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        cocos2d::LuaBridge::pushLuaFunctionById(luaFuncId);
        cocos2d::LuaBridge::getStack()->pushInt(code);
        cocos2d::LuaBridge::getStack()->executeFunction(1);
        cocos2d::LuaBridge::releaseLuaFunctionById(luaFuncId);
    });
}

-(void)showMessageSave2Gallery: (NSString *)path luaFuncId:(int)luaFuncId
{
    self.saveImgFuncId = luaFuncId;
    NSData * data = [NSData dataWithContentsOfFile:path];
    UIImage * saveImg = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(saveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

-(void)checkInstallReferrer:(NSDictionary *)dict shareLink:(NSString*)link luaFuncId:(int)luaFuncId {
    
    // share content
    NSString *utm_content =  [dict objectForKey:@"utm_content"];
    NSString *utm_source = [dict objectForKey:@"utm_source"];
    NSString *utm_medium = [dict objectForKey:@"utm_medium"];
    NSString *utm_campaign = [dict objectForKey:@"utm_campaign"];
    NSString *utm_term = [dict objectForKey:@"utm_term"];

    NSLog(@"dynamicLink.url => %@",link);
    NSLog(@"utm_content => %@",utm_content);
    NSLog(@"utm_source => %@",utm_source);
    NSLog(@"utm_medium => %@",utm_medium);
    NSLog(@"utm_campaign => %@",utm_campaign);
    NSLog(@"utm_term => %@",utm_term);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        LuaBridge::pushLuaFunctionById(luaFuncId);
        LuaValueDict item;
        
        item["ret"] = LuaValue::stringValue("success");
        item["utm_content"] = LuaValue::stringValue([utm_content UTF8String]);
        item["utm_source"] = LuaValue::stringValue([utm_source UTF8String]);
        item["utm_medium"] = LuaValue::stringValue([utm_medium UTF8String]);
        item["utm_campaign"] = LuaValue::stringValue([utm_campaign UTF8String]);
        item["utm_term"] = LuaValue::stringValue([utm_term UTF8String]);
        item["sharelink"] = LuaValue::stringValue([link UTF8String]);
        
        LuaBridge::getStack()->pushLuaValueDict(item);
        LuaBridge::getStack()->executeFunction(1);
        
    });
}

/**
 *  分享
 *  多图分享，items里面直接放图片
 *  分享链接
 *  NSString *textToShare = @"mq分享";
 *  UIImage *imageToShare = [UIImage imageNamed:@"imageName"];
 *  NSURL *urlToShare = [NSURL URLWithString:@"https:www.baidu.com"];
 *  NSArray *items = @[urlToShare,textToShare,imageToShare];
 */
- (void)shareWithInfo:(NSArray *)items luaFuncId:(int)luaFuncId {
    if (0 == items.count) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        //UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    }else if (@available(iOS 9.0, *)){
        //UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks];
    }else{
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LuaBridge::pushLuaFunctionById(luaFuncId);
            LuaValueDict item;
            item["ret"] = LuaValue::intValue(completed == YES ? 0 : -1);
            LuaBridge::getStack()->pushLuaValueDict(item);
            LuaBridge::getStack()->executeFunction(1);
            
        });
    };
    //
    // 这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;
    // 在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    //
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
        [vc presentViewController:activityVC animated:YES completion:nil];
    }else{
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}

-(void) shareMsg:(NSDictionary *) dict {
    
    int luaFuncId = [[dict valueForKey:@"callback"]intValue];
    NSString *shareTitle = [dict objectForKey:@"msgTitle"];
    UIImage *shareImage = [UIImage imageNamed:@"Icon-120.png"];
    NSString *shareText = [dict objectForKey:@"msgText"];
    NSString *shareUrl = [dict objectForKey:@"shareUrl"];
    NSURL *shareURL = [NSURL URLWithString:shareUrl];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, shareURL, nil];
    
    [self shareWithInfo:activityItems luaFuncId:luaFuncId];
}

@end
