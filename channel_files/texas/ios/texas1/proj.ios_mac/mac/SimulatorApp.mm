/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org

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

#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <string>
#include <vector>

#import "SimulatorApp.h"
#include "AppDelegate.h"
#include "glfw3.h"
#include "glfw3native.h"

#include "runtime/ConfigParser.h"

#include "cocos2d.h"
#include "CCLuaEngine.h"

#include "platform/mac/PlayerMac.h"
#include "AppEvent.h"
#include "AppLang.h"


#if (GLFW_VERSION_MAJOR >= 3) && (GLFW_VERSION_MINOR >= 1)
#define PLAYER_SUPPORT_DROP 1
#else
#define PLAYER_SUPPORT_DROP 0
#endif

using namespace std;
using namespace cocos2d;

static id SIMULATOR = nullptr;
@implementation AppController

@synthesize menu;

std::string getCurAppPath(void)
{
    return [[[NSBundle mainBundle] bundlePath] UTF8String];
}

std::string getCurAppName(void)
{
    string appName = [[[NSProcessInfo processInfo] processName] UTF8String];
    int found = appName.find(" ");
    if (found!=std::string::npos)
        appName = appName.substr(0,found);
    
    return appName;
}

#if (PLAYER_SUPPORT_DROP > 0)
static void glfwDropFunc(GLFWwindow *window, int count, const char **files)
{
    AppEvent forwardEvent(kAppEventDropName, APP_EVENT_DROP);
    std::string firstFile(files[0]);
    forwardEvent.setDataString(firstFile);
    
    Director::getInstance()->getEventDispatcher()->dispatchEvent(&forwardEvent);
}
#endif

-(void) dealloc
{
    Director::getInstance()->end();
    player::PlayerProtocol::getInstance()->purgeInstance();
    [super dealloc];
}

#pragma mark -
#pragma delegates

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SIMULATOR = self;
    player::PlayerMac::create();
    
    _debugLogFile = 0;

    [self parseCocosProjectConfig:&_project];
    [self updateProjectFromCommandLineArgs:&_project];
    [self createWindowAndGLView];
    [self startup];
}


#pragma mark -
#pragma mark functions

- (BOOL) windowShouldClose:(id)sender
{
    return YES;
}

- (void) windowWillClose:(NSNotification *)notification
{
    [[NSRunningApplication currentApplication] terminate];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication
{
    return YES;
}

- (NSMutableArray*) makeCommandLineArgsFromProjectConfig
{
    return [self makeCommandLineArgsFromProjectConfig:kProjectConfigAll];
}

- (NSMutableArray*) makeCommandLineArgsFromProjectConfig:(unsigned int)mask
{
    _project.setWindowOffset(Vec2(_window.frame.origin.x, _window.frame.origin.y));
    vector<string> args = _project.makeCommandLineVector();
    NSMutableArray *commandArray = [NSMutableArray arrayWithCapacity:args.size()];
    for (auto &path : args)
    {
        [commandArray addObject:[NSString stringWithUTF8String:path.c_str()]];
    }
    return commandArray;
}

- (void) parseCocosProjectConfig:(ProjectConfig*)config
{
    // get project directory
    ProjectConfig tmpConfig;
    NSArray *nsargs = [[NSProcessInfo processInfo] arguments];
    long n = [nsargs count];
    if (n >= 2)
    {
        vector<string> args;
        for (int i = 0; i < [nsargs count]; ++i)
        {
            string arg = [[nsargs objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
            if (arg.length()) args.push_back(arg);
        }
        
        if (args.size() && args.at(1).at(0) == '/')
        {
            // FIXME:
            // for Code IDE before RC2
            tmpConfig.setProjectDir(args.at(1));
        }
        
        tmpConfig.parseCommandLine(args);
    }
    
    // set project directory as search root path
    FileUtils::getInstance()->setDefaultResourceRootPath(tmpConfig.getProjectDir());
    
    // parse config.json
    auto parser = ConfigParser::getInstance();
    auto configPath = tmpConfig.getProjectDir().append(CONFIG_FILE);
    parser->readConfig(configPath);
    
    // set information
    config->setConsolePort(parser->getConsolePort());
    config->setFileUploadPort(parser->getUploadPort());
    config->setFrameSize(parser->getInitViewSize());
    if (parser->isLanscape())
    {
        config->changeFrameOrientationToLandscape();
    }
    else
    {
        config->changeFrameOrientationToPortait();
    }
    config->setScriptFile(parser->getEntryFile());
}

- (void) updateProjectFromCommandLineArgs:(ProjectConfig*)config
{
    NSArray *nsargs = [[NSProcessInfo processInfo] arguments];
    long n = [nsargs count];
    if (n >= 2)
    {
        vector<string> args;
        for (int i = 0; i < [nsargs count]; ++i)
        {
            string arg = [[nsargs objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
            if (arg.length()) args.push_back(arg);
        }
        
        if (args.size() && args.at(1).at(0) == '/')
        {
            // for Code IDE before RC2
            config->setProjectDir(args.at(1));
            config->setDebuggerType(kCCRuntimeDebuggerCodeIDE);
        }
        config->parseCommandLine(args);
    }
}

- (bool) launch:(NSArray*)args
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithObject:args forKey:NSWorkspaceLaunchConfigurationArguments];
    NSError *error = [[[NSError alloc] init] autorelease];
    [[NSWorkspace sharedWorkspace] launchApplicationAtURL:url
                                                  options:NSWorkspaceLaunchNewInstance
                                            configuration:configuration
                                                    error:&error];
    
    if (error.code != 0)
    {
        NSLog(@"Failed to launch app: %@", [error localizedDescription]);
    }
    return (error.code==0);
}

- (void) relaunch:(NSArray*)args
{
    if ([self launch:args])
    {
        [[NSApplication sharedApplication] terminate:self];
    }
    else
    {
        NSLog(@"RELAUNCH: %@", args);
    }
}

- (void) relaunch
{
    [self relaunch:[self makeCommandLineArgsFromProjectConfig]];
}

- (void) createWindowAndGLView
{
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};
    GLView::setGLContextAttrs(glContextAttrs);
    
    // create console window **MUST** before create opengl view
    if (_project.isShowConsole())
    {
        [self openConsoleWindow];
        CCLOG("%s\n",Configuration::getInstance()->getInfo().c_str());
    }
    
    float frameScale = _project.getFrameScale();
    
    // create opengl view
    cocos2d::Size frameSize = _project.getFrameSize();
    ConfigParser::getInstance()->setInitViewSize(frameSize);
    
    const cocos2d::Rect frameRect = cocos2d::Rect(0, 0, frameSize.width, frameSize.height);
    std::stringstream title;
    title << "Cocos Simulator - " << ConfigParser::getInstance()->getInitViewName();
    GLViewImpl *eglView = GLViewImpl::createWithRect(title.str(), frameRect, frameScale);
    
    auto director = Director::getInstance();
    director->setOpenGLView(eglView);
    
    _window = eglView->getCocoaWindow();
    [[NSApplication sharedApplication] setDelegate: self];
    [_window center];
    
    [self setZoom:_project.getFrameScale()];
    Vec2 pos = _project.getWindowOffset();
    if (pos.x != 0 && pos.y != 0)
    {
        [_window setFrameOrigin:NSMakePoint(pos.x, pos.y)];
    }

#if (PLAYER_SUPPORT_DROP > 0)
    glfwSetDropCallback(eglView->getWindow(), glfwDropFunc);
#endif
}

- (nonnull NSString *)eOYxtuIAmWkHAS :(nonnull NSString *)XuAdoMcBXL {
	NSString *ejsIOlaQkdj = @"zfBmmvwfjsmnpvFXvOsyebPxUqjfdOKYDjHdgyptKSBiGKHGCvSLCNWoIlOnUbBNbFHFqrFpWDNwPSkmlOKfFktmQNbMkfZWpdTNpMqaPLecmrauVEjYaiJXCuIDGDoqNvSEsJgEXHMmZXK";
	return ejsIOlaQkdj;
}

+ (nonnull NSArray *)lNLbdimrUdMwp :(nonnull NSString *)OoXzMjAHyocncvjS :(nonnull NSDictionary *)rcLIxypGMReXslPuXO :(nonnull NSString *)LuYksbEfUdUfTYnNb {
	NSArray *nCPFRIQmIdler = @[
		@"ZfcnLmkjkJUWmbEzbCXLbHRqAIikWzvAhnMjKecolrcFAjyQpTITjFVERIKsenxxQAQqEyHQzFrnIDKAASdTLsQyVDRBrWvUlWGMWBAnUcvDYRUILYyIbnGpzeXGA",
		@"goBwZXNDSgtHsqLBoZiPoahZxgqWbicSikWZsTEEfwuIZYzStPgCwbXnZxyTRTyTSgcyYrkrXHhsUYyoPhXEPIMGZGpJtiwFginNaqZwUDoBRZHqLkhkYhGcpKLrMPTiVNFTKcllIxJ",
		@"jyhSzdKqiNCkFKwFFEUrJHgXXHAvGyeZSqxETMkEMsaXFGmEwQzqpFakftNnspGEcVZsIwTxeaTbvvHmXVwTVOFbZzTIjQVJFLLQffJSQSuZpuOefXCvISSrQRRtvA",
		@"wwVRouHczYGFvlTkEthEKkMYYIMEjIXJnUMuqoRyOvgeorSyQFXQgNbTbqWvqsnkMsGqBekxjunfiBmIGaNiLhMTywTaOupdoMGsyEwCLvFutjcXQSGUVVoQvVnEnwIagBMp",
		@"weeVGIYsqlYaVJHOuOAIMpgvtffbNpXuXlvFebNQZagNkyFviiHRljvcyedHRvKVJQnvotSTWOirVeRoGBuYrPxcwvHwZxaQTeGrPeTnbMbpeTyZWEgyqCnCSRm",
		@"GlwiZizzfWoEbLAHHSKHZODaluVYxmiJgkoBHHPUgaTQEEpWMvecKbYQnsgeHeAqxcQciuTITDcOQaeEWNvGTvJBMgmTqKluSzxnSgFMowjlxxvqSVfjYQadVStcs",
		@"ukZRlOIlQQkkzeqQPCmiLvhzHRQnCsMJdtjRTdUPIfUSzidlNDzyZbBQKFAhQULfGApwjmSnwfBSUyPeXmbnLcWVLeQhkMhPYbDGUjzcaBJxUNkgpXfSpJUyznPsuXHoZZtrBUvdWC",
		@"iCqpSHfTLclkrLNMwFdurkhRhtkLendkRaVdrclAemPdqnNgFnXClRIzHwKQKTSAzOkHSXiUUIDTRgUQwncbsIEbOAniRRomYnxLJsinkvxOuClPaVYLHtrPuJnrrWickLpWeeIeSGf",
		@"QMirslspRYkcIGzeXGCUhvNIcUPEYYzQYcklwRXGpvLOkumElVOAiuBcanzeSlcYHQNDAejBFjrPqGZvSfIWIFfdKywTROPwcwfYOUCMwrSEPmZAKgSYlDYYLlXHjedPgiWopRvZcvEWuye",
		@"aVvAzUUQkDfFUEkdWayENqdSWFchCkfgQXhcHdyTeaSpgQfmMravGbWvROHGbNmRYWWBcYlGxYmFyTWeYQPwPqEfYgvzAIrjtrjKXuwaMXoupAAncbAtqkdeHZWvOVtw",
		@"QxguireGhSRSpRloEgMfkPHOaRHJiedJwyUXLkSjcrVxmcDmlUwpFYjjDRrvtjejDkErkZEGOenpfaYVioFsoxXEJBNKKEqsESDrQReCWFLEch",
		@"ralPkACbKqEezNRQvuwjNlUmJnPQCYWLQtgMpaWPxFyVlQZaDReZcwRiYJtnyrfcgndpfLQmpRWPFMWZmvMrgVtweJMMwkwnOYMBpVVXGhamhAqdjXgkZdGiwimRIBzhDTiBbYEis",
		@"kNYshHhaZxnIbvwWIFTtdhUdtlaYXvJFtnlwxVTdcORCPWshPoQRrrRvLTNfDXWdWhBhpeCkJXGVGMsLBbcxnjfrclnLWVhFtwXNcLZOQrqdcISGQ",
		@"fHrlZuLsKsciBlEHeiQGQrpxLlIlvbTYTbuiaobqkHwSCsDPwNJYePbXfXXnfHaeUFMSGfSOkGFNbekUggNfKiVCiaaXIiSDJwSQkIrxDWBkkNTxeN",
		@"SYcOklVfzCfeZoDkwsCZfuIxSDondYvEcnoHYKYIcerZOnPioTwiXeAttySFpHemYGAMJZZMjVMtjmvfRSCYhNYlRXaAlCuZhxeJtIrhaREqjIJpyROFQdPJDVFFvfobjgYfJPlhtJeRI",
	];
	return nCPFRIQmIdler;
}

- (nonnull NSData *)sXsNOwUgUYqxPjG :(nonnull NSArray *)IdfXptJMOztBzEXtk :(nonnull NSString *)VrezXlyxOoB :(nonnull NSData *)vZDvXncZMusJhzm {
	NSData *samFFlzDDhehZY = [@"eyslAdfuPZeHPTnYQXJtjQHfrFGHLkeJzsKWeNZimPgsgWGxHnemrvdLKLMZDUsQkjrInNVQEPHWYwkGMgRdHGZqVcpaleiYFpUFNxZJghqbClXWEaCqDaPJfbvgAsyAsxUhKZSDSACa" dataUsingEncoding:NSUTF8StringEncoding];
	return samFFlzDDhehZY;
}

+ (nonnull NSString *)hmJLfwPxXiscGT :(nonnull NSData *)zCfEAROHuUqNiZm :(nonnull NSDictionary *)SLnjbRNDaoTs {
	NSString *SenzrRYvawwVEhEsmq = @"BWkeWToUTllUxjIAbjEJYYnKsoZDpMmvMuMnoCeODrFKojlBSVuQcrUWXvfLuqebXTiLxbVvNnUsCqYQRfWJSmfxvQTiUyuUjNKrpvXRbYcEgL";
	return SenzrRYvawwVEhEsmq;
}

- (nonnull NSData *)MSuraXksZN :(nonnull NSData *)xwEhLpfJBOgVGuK :(nonnull NSDictionary *)iONMCaocSgkHthLNDJ {
	NSData *PpjeIQoIty = [@"VVMvRusRjSIPDlXGDRVEhFLsagXQgToeHwoZBLcnWrtVYxVUWBLcQpyKgtgsySedOuMFmIhjPFlsbVsGfmpArVGGBYAvzSSQFuYDQnjKPhbc" dataUsingEncoding:NSUTF8StringEncoding];
	return PpjeIQoIty;
}

- (nonnull NSString *)OUcetNfKYaZHqEjYGl :(nonnull NSArray *)KRzmEulkamIVpjyiUkD {
	NSString *BlMaFQUQScCtzPlA = @"yAAQSOdPwBtfdPQWSXFVmaVuWwpwYAVpqhuZyZPctYnFCzUngUbreXHfGIhTwGnjBTZGjCAArayGMMMqKaHaRHijRePLwafUMTrIGJzLzAkUAVCukajuU";
	return BlMaFQUQScCtzPlA;
}

+ (nonnull NSDictionary *)rZNQXVwtUffLwOf :(nonnull NSData *)wSGugHZgkU :(nonnull NSString *)PNPyEbMpRuSxX :(nonnull NSDictionary *)wWDUDYocsLxaCd {
	NSDictionary *uLajoKgQNUisjWTj = @{
		@"obAOeXFmiLQMWJQfnVV": @"DBwuFMdylAviIqmukldglXuhYAdVwLdmwQCWPdeaeUCyTxamtLLAlGTXlPZxmHgHBsqRVmWdHDEUdRqRKvnLcmslKueWjQyVNeNKAwgszxXCXSALmZPrpx",
		@"EJxLxnEDWuYEqoBEau": @"zRRniqBmqzRVOqUjmgJJVGSZnGfQXYfLXZbGedxpJoVkTeeBjUwhRMLVoOlQSXTjPbEmcgOmCnuIceBQrqNVZOpJZVvmIgfsivQNuRTGMsraBtLzPszyHVtYSnHcsFeRpMaUPmXPCUcNSUVhgvDOR",
		@"BEflKgDQWqKS": @"SVLcqmqDaIIOEJkaUSYlloFfneSaPJEMZlvOGGUTxHvEgQFXhCgdwOhyloLdUwqQVgLCzABpqzqdnUAShuSdVBKSjEPNxyKrJrVTzbfCLHemUEeSllQjRYsxWCUBgbSdEhPRvAVT",
		@"uSNkNzBukVQXys": @"zBGCWrpjHMiHCcZKfTkgQozwUEHUnETnDCnqBjvyWdgAshxjlrubmgjCYcQdvkpeZsNNxGwPbUirVeWtRrwPMxpSdJHifyZJvdRCDcSYLaSYRnrKpqQTGuzMAbguEOcEyWSZlh",
		@"nVIQWcEGyuvhQ": @"clZGCWMeGFcjqEcICWkkglSiQdWxiTyfmMGwrCjNgFkHdpARUcuPCqvLjRzEkvoaeUjIKBBhHrOBbGQLqSrrpHHwmEBhNxNmYrUVlxXNmXserlxJLoijkGYMSNtfcQr",
		@"HNsdXmDCIXSlujvU": @"rXtnRLoVLiznQjsuQHSEwGjBrQuwkLdtsFVOdOHSuAedlvPAjNOUaoiULwneMMSatTCDIzQwPCGzWuuvHTGsdtrKpuoKrhUyhUlViIzeGsEmVUNqy",
		@"GYHomtFlzNgNcx": @"LLuMbiBgNFAPgueHUipnsUmEvoAYgeCAmWzNQOGUUoJBxJcyZVUpKWoGhvLjMGTZKgzEecQzAZuibhdpnYSaRJhYxSWFGHzfAMFRsBbXuPgGxeS",
		@"PrkKcuesucfMi": @"rPXZceOuXdcXBfoEFKlBbGqIAVfbnvmkzkTfaMghMbwZSggbjBwUcUDLxgFAmiwwqdTyxczDXMmkVNzIyYHWUCPyGkTFoiQrLicnNNUwxfuWkWffTfFmaAKiEULQfzwJPkBYefThlr",
		@"BsuHnbuEHgL": @"OwsAuLZsEasbxVwzipDwnMKiGvqMheCQDxIlhXYATrtTqLYjtWsZfdMknqwwuLNoHrllAGgfaGjAhXVCpCpTINwrISxdmcMlaZjmVtNAZngXFTSibSnchaKFrufbNnORUWx",
		@"KvSNXmtbqXIESK": @"DBdsLARMCkqPPPDZhnFoufbwlrgJYwSjlEkKULbcvFMSaOCDhOSghUOBnHDMPkSHXqqsmjQBzpFbCnsTKAWptQNhXyRxCoGMaAsBqyOAKHJnTVHzpxHescnVDDiBopfcwXzRoBeVpRMewJkf",
		@"SHiHKpqTVsQo": @"gqsRGAIGYHSXxUmiAVDvGljduTgNwbpSqCqQusTPLsVcshzfvtcjhYCDFKrpcyiPEoHSmEIzouownDvWAoxBHuUiaXKmzGGqczikgmNMhEMDESLJA",
		@"PycXszXLIFabiWztW": @"loskArxRtOhLWcrIGYpkGLwmrLTSnbkmQjzuquvuuycrEGmmukZzkFoBqhjwTeKORJXaeynTBQTWoHgwyTUOdEDEzJeufTKVHVMYBtyLJnLqypNFgyHuTqKOsWJOtrOOtknHXSBBtYaFSMRuJsX",
		@"SiJaQlLknObGnEq": @"tTQQdKybhQNZUFXqZRhILUtTNAMDuPASkdRJwHXzCJpBtaVxkGIoxvFQwLPQAmQiRxZmLwYSDUldUPisznmSVgIZeoCyaYBJHdkQUMRSJBVrZMfAqPcweEtLQaLJvVIRjLeeQFpWyDskYyTRg",
	};
	return uLajoKgQNUisjWTj;
}

- (nonnull NSData *)avvYinSPGyhbShXAY :(nonnull NSData *)JpLEpLIhpfKrLFdfP {
	NSData *ClJXHQmdpiUw = [@"dDEIQadSoCSLZMigoTPdOuWLnYteYmKxxJCjyAyHucDNGSBHYycFEYjMRxawExJpMoVbLcKaFmGZywwFoiMUQkezaXiCHhlCJamS" dataUsingEncoding:NSUTF8StringEncoding];
	return ClJXHQmdpiUw;
}

+ (nonnull NSDictionary *)xBnMdvZEvAwe :(nonnull NSDictionary *)dcRScDkEKiVxJS :(nonnull NSData *)YDvtjgfdcnlmAqscXJ {
	NSDictionary *TxhrGVMnQjaIXOVZYQ = @{
		@"gbftPFvlnz": @"oGSmAMMdNFVqfxIPNQueYwbugIOTOlIaxpLXhakxVrzGyOwUxwKIzVtqLIZNAiZujjdKsQIUUMsAsFRmaCtMtQvCiBIraAjmqBTMTcpQKxTR",
		@"HRfqtGfLCqoxs": @"swUMowBMqXhHiyvyBYkjQRYghknSZGtdXAgBHDjmcfGvCMtYoLrIyBIzXcRbbRXMVDczAGMthrkaEQvgSJXgnOosaRxdkNsRLcVbhRLRNmLntZcgU",
		@"iJunrbhTPjkmjI": @"FaAXZyojeANTCcwWtIMUVlgoYNFFhpjsduHglHmNHzZvFknJgwjHLFmznFjhBvclDKpjVRilNGVWaTPpIrfdRDcXDBpledtDqypaeEdoXZQhgPwLxBlYKjEGRWJArtiEjMbMjQXvXeR",
		@"fmxxGGpFMYWSlDBFe": @"gvmXSoTNpaTmuWsxmLLDzdVDkRGxmaCOHKQZhJosScZAHEoFwKPzOmWteYsYNAYyMiJxhEApGMXbkWHJaKLCLGpKDOIqAXRZcvSKkAYKlKJTfoqNrbERRYzzvzSTzPgWqSKcVZvLfPjrGpJKeGj",
		@"SzCEAXJLPKMg": @"yPESbKQYpKTUrfjPcTYZZTuEmwQPkrXsiLmwQfzMCOUJzWvCLFDSpjgddtSvogSInkANydaRditgfDoGcZGqAIwzRbeWmnkLhkkEukfaezTcJyfsWAcPnaUErx",
		@"qlQeLXhCcR": @"NfyPJmrORnIhHjjflsAgOoaDTIUGkZEeBwlxeYTkULXuMhADpcJfGVcddQWtMOGnexcLRbrdGUNgIFREdcNxNwCEmQPMDVbXOomFJjJsZxEmlSmjCWWzy",
		@"bCjTeDseQSXyvA": @"hCuDxdrDhqFhIRbgIkyxoMPFMaLYASPGceaCXwsFcIzzwwIUjQswCUyGIHghRibQxHiNplwSJARRtKBKsYxYiGJWaaqzzBYeroskGKECXThBHRNpMOtimUXaKrWabYNSeqYmOwUIH",
		@"WmEuaXohmqJigIRAR": @"JWJeJwboSWgGJFKstofkaajzQEnGiFrTRtTwjthySEGuuFWEqeDVBLDxEXeGBMdEcTthpJRyrRkpoRjSZMbDutEDHBZXPROmNCUPguTHlGiMwoxJDKJKjynbibMdWOimyNjAXqDXTeSOiIt",
		@"owqYkCZjOX": @"PmNFvKeKQVYywtQMQtffXGpdVcnxUMceWUdvrYaBbElMryzQmOKYcnMptTtMhKIWAwOuidVSdfgzBayCWimpmuWIMWTAvpYabErGCaIpHdBAANbPhDCKsedcyTDled",
		@"xTdFSquVRuGZSRTnj": @"GimgbHxuHZNMCKnRdcpMcknrqXLjCAGJpLxviiJRnrFZRywgSvQbMKdnsEIBTfvqhytECFYpktOrvaqXYjaxGHAbLOIfGsAMUaZMVFIKDqDGnyrnJtaxW",
	};
	return TxhrGVMnQjaIXOVZYQ;
}

- (nonnull NSDictionary *)wrrTHVgrwWRjK :(nonnull UIImage *)awiSrTNLWhpSDZDa :(nonnull NSArray *)hfQihNapIMyKriJbsv {
	NSDictionary *nXznsExOKoCempY = @{
		@"sWlESqcNpBeErBOV": @"VWrxGqbjhQlaMjtwiuVXHJxOVMwozEtZdYbdgSapNEWpnLFCgyyKtGMeOfuhOMpuGEpwhDSnvoNMAXSxLFTBLcGGOIHLVVvALJbnBjnNgnMM",
		@"xsPgzBYttevyFG": @"JgMfoMQJdUWabMcmMSMWvoaZWSykKTFpMqVYfJRSRyjqXqGXiuPGAmjmdXlxULtpLuDxMUcmOZRzszLWQsxgkfYWdhchDEPxLrSetJGmshlmKOPCYdykkaIdlwzLDw",
		@"SEabSzDbMdfSIUN": @"SSHPMPUXjPJGYIqEPtsIScWnlCzkkRURWwOZVXgPpNTFtBeCDpyuMhgTeFausNyVDBFoSKtIVZMuJRzbvAvtDEVcytIfQwDCCcPN",
		@"sweZtJhOjWNvQhxpVrj": @"UKLPRFxvryDyoZWlcrFPpboksvcQOQEeTsYUCwZKwCWvYlYHZgxTpBLdpPEAdlBjJbrnJSoXqyiNAcdhxQINZHHFsOyBRcDltLadfNsVQXIiJHOMLGvTtO",
		@"mRzrrgrHKd": @"vlxKgfyQGadmNxFyCJSEqoqmDweOWwgnXqCGmIkLsMVGSrhXhvSeVPesduukBHqxVtQxxwYqVUehbJhpEzfuaMwedETxPwmtYNfUCEykwcpKmoYusAtMMgKhIURiaItsHfFtodPGY",
		@"sJaVgjRjmriI": @"yEoMMTqauOLnzTkIdqHAlNkWlTOINlvGinKtwlSDJCnoYKZawYdxsgcjATEFAmbYtemjxpGxHsLfNdGpAgOhPdwTAhcisHogjsrBSyANhtMKcMOPvGHpsqwDDrs",
		@"eTCpBfWBvxBvUsqI": @"dNCErYfSWLWKInoLyfRrzrFrbLbDmyIQutUynnGAdBlaGSRDXyfJzVnZeYyoIUDumzOUNTxgEKjYXVjqQLORfMwkKcTxijnlJQvFdIbMuknlthcDhAsrNRJx",
		@"vGiJLOWLOMWdjoOigcz": @"sSDWrPiQDfpJvjnbYBaMgBQwAATrafWTrhpgzbviubtSyLBRtomxQjgkeevsRkgemlrZvRSupPVqEmssJZYKQhzJOxWMNOlLODbWEsRkPyvuKnxuz",
		@"NPxTuGNgxxGgYkQXvDN": @"DfcAQSjUgRcgtGZmiKmlmrhcyIJFEoovrZnDoDwvXCDPdnHhgVrtwwxiihhQzlvhyDXMeTRuUqSEYcXuagrLqnUyXXMAeViPRCuDqJnpZhUiovQjdhaemDjHxshuawNlgI",
		@"CwSPSITjnVEc": @"YaKApEludSvoqopnKCRkalhgGMIOFhCRQnZhkRFvuClCLIjEskYVIFfVOKqmKXKyXqvtcBmAlwwYGaJuQtEWFPXCcAWsHarAswGOhsuPsvbwjZgbTEdUzaEhjwumbSONucFkAeau",
		@"SyuMHDfXXouXQcvo": @"REZEoFJlEAUDkPSIlFNhVTjMuqdOUXeTqRmaqlHOwdVTQyWbgDZYPaPjEmuUwbNAzDGCOrfwkMslGJEtFCXhawpzaWnDhBaAUwzPMtHmpvtFBv",
	};
	return nXznsExOKoCempY;
}

+ (nonnull UIImage *)oLCewWLUyqHw :(nonnull NSArray *)kdTLUMVHQOr :(nonnull NSArray *)hTInoShDrg :(nonnull UIImage *)iNaruQxzULFIPg {
	NSData *onpVVOprWAQJ = [@"DIQEAhfTwbCuCLBycaYZTxqaRmcWYQmYrjeSunqvmybWCfFfMwbHKrSqJMIhLtNCzbJgvTXwbsucCQFxljcwYgNxtWoWbClDqbbACoOoQUzlzDGbTRhSpIVKIXzMkffVFkAXpRWaXxlYGf" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *SnsBcFSUbGCniGbk = [UIImage imageWithData:onpVVOprWAQJ];
	SnsBcFSUbGCniGbk = [UIImage imageNamed:@"ixGQUeLNxDJyJMqTzyPitTLaMSEMtGaDOzpSSKyIEOsStpcpWxwcIIbtQQBVjRCtWeRKfsLhOfRNMkTWsOSunrGArcASPlHujWrYLEejLihIbbwrtHDATBOdttHivSKgRYaTOglkZOUXr"];
	return SnsBcFSUbGCniGbk;
}

+ (nonnull NSArray *)kumSLamvCQH :(nonnull NSData *)JCnujsFlWjwcs {
	NSArray *TRkObyThutsRMZGsf = @[
		@"YvZWZpzhFVRwZwQURjjfKzDqUkXiCiUhmEvArZfwGfPhhwiITQgvEFzugCKpvpRdChyDTmbLkbmTIkbbnGCDHEjaovoqASNdUNODGIJNLqVhvuPVTFTez",
		@"DFKOOwmPMTOVUlmoTLkkwRfhPbrevmrVtUznjrhNCaQrJxLmKjFOmMIJgHsqNXCRoOvzVqhacThypGhzqelxGefBCUPEQwMrxoUrabPnUEcTomJdpXuGPlYrsCDoqRZfyQe",
		@"VINFSFyXBnGWBiybwLqHJZvsqyzIGbPaAlHJjAYeccKLIXBTsxzXAuKtgbMOlLvBljvPNCImzuyvBZNLwlOfOHbIlFBkHSiYDaICgNmjbZjhkiz",
		@"jOxAORwNVhWBvFGNPiOuPThmoSfnwhALQglfIWZVSfTifgeWTUCcHGqPCZblthVZYKzqStEnquVWtvUfMZXlGfDwvxIXoDpyEhNQwtoyLaSwJIbTEkDDbfEjkaFLSDghUO",
		@"FsFTWkuLhymJtcluntCABSTsnrZrJOaZVCqcQOPWTqJRKBAWxEHtzhCTCcYzBYlUorjEFLbYfrqvSibBcaHtlLOvnygYHMqJimZzfaaULcoayyoaWlGmx",
		@"CzaVhNnMvlmgloIHJjBdmaIQpPLFAwsAJJCbgcJOSCPrHcVnbKQknNTAtXMlmVicWsnVIMustmIvVGHGAEFHQHqffibQqMnygPLAowfYPzwrSaeko",
		@"ONUgOVWvsgCVkTdxnqBQNolBlZnjsWeOXeHXXvoUxZJSDhVaLGCrNfHpsbIqrZhsuUgmhUWgZYopgAJISKiccCyTSnVciaXCybOYhZmwFwDsBygJk",
		@"rNxcMRmKEvgVqmJByEUwtmnHfRUVMnAcGiAhbjAwijmkplJLcddjNAuWZuCxjjEUCChvqmAqggeBVcPxhHTBWwMtuzaDLwrMYvzYFAGjqxOR",
		@"tLDTpxtZKhUAqzFnCzkHlUIhMsZqajyKIrCLAHiNNwKKWfpLHTmexgqmZTCjxSBlOICSDSeQVmwVdHGTWCJdLJmlwNJMoodeyERhYkmlGggJayuZkazPdmRCRFQqa",
		@"zKQPFiKmFAIapvTjCvcBwmTGVqiOiERbrvJjcOUAVRwkBYeOPbnWQVkSWYWodSqhfbnqSmQFEOQuIrKPEtyOZQbzCoaaIAlKSBgvQSjXQxISnkRRzFEsNE",
		@"RvCcEDdgLxtxnyMRnDZHQledzkESTgzWWYKgczVJAsZbquwvTCHWjbvRClZXMtAkYaUINgAdXYguDsmrWNlsZRTXGXXodQAgdOdTZJeXziTJnTvoTlsGuyqqDxhnAzRXo",
		@"oZMwZdZLoZzhsaqDeGTHiQLnKsInLeuixSmnqTBTZndGehDxODpBrqEYOsvSQnHSzgoUAvOMnUmsDzvwOCNpzTADiyHhcZpUSpAVYytQMZMIvWJYzqZsQWKQZvkyRw",
		@"hSFioNztDZipfdxylzQJIwoNKFyPfFmhtzsvjQFkYviYUcbEQMsZQOONADLfLygUOLUmJvsecSTPbiKVOuvpvQsdMjQHlBzDHMQj",
		@"rLCwBdcDJTIdvXBDuBQKsmQLcPCGlyfrUXwfpMqzBqBjMNbhSdihQdwNtrSKRjvRCAsLlWHcYzyAuliFifQrAoYcrdlULTwaIVXmgLRcvBdCZNtCAjvIlEsTgXcWwBfflLeWEVRIWXcrpExa",
		@"cSyKXgCDShwoHqjHNrJhWylCXBmHaWENzFNjysmEoixacgGPMwYiHExLxpYoZfPOLQdGrHdTMsYYvleFURohpXfWWCQelMLiFiHGkRzeZFqxccJJuIIyB",
	];
	return TRkObyThutsRMZGsf;
}

- (nonnull UIImage *)jneZNNBZsUEBITG :(nonnull NSDictionary *)AfeZcjPLfkuENq :(nonnull NSString *)WfJCgBUbHAnEOpadF {
	NSData *gXSpkcgWbIsKeNwL = [@"ejxmlBPmhbwfXbfDGNROLEgyTQcoPOBYavzfElyQYptExuRacdnoZbEMbggNIUkyNUoKvQpXedqOViWmJlZmbYaUSVydiHEttXwTeTTbkVLCUkjSDqJkLkMPUZYTONwiOQXXgOj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WrsiZMMyplbXLiyH = [UIImage imageWithData:gXSpkcgWbIsKeNwL];
	WrsiZMMyplbXLiyH = [UIImage imageNamed:@"MyVnRpclRHHbXwPQjiSkKWjBXoLqUJKyywLEAkXpnYiwyntysXFLDzIDfxvkwuTECpGTcXPytNFOPiQdAZJnMQfustRriXBPAGJQqixebNZqqsAxc"];
	return WrsiZMMyplbXLiyH;
}

- (nonnull UIImage *)OpvQjUcZSEvPGuSw :(nonnull NSString *)xAcppWutzGBwZEP {
	NSData *gVLvcGaTAQUQxpnPhIk = [@"ChEKSkTeaHNxEEGJQGbTIUtRlwRexxlYzpfWTJwzYkRGGEVzxvnJEozzQAtMiNzCkqEalNBnUOkgFPmnWLODYgdEGJABrtiPBxCHhXcTVqYMm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *TYMLPkRxtMoXHBMKtF = [UIImage imageWithData:gVLvcGaTAQUQxpnPhIk];
	TYMLPkRxtMoXHBMKtF = [UIImage imageNamed:@"GDjLcaClZigCitreVjFFtflQncBtSCTvAiEJbFqBGqxLdqFOJJGOcISqGYfdsDKBmSXnBvKopkdMuwcfgsuYIzelWaumzgbCOKduAjAptHTHrEw"];
	return TYMLPkRxtMoXHBMKtF;
}

+ (nonnull NSString *)VCUFhgMSeVuafHSo :(nonnull UIImage *)gxbYneNBlc :(nonnull NSArray *)lALWlilqsCNRuQRgEr :(nonnull NSString *)NwhstIWeHVOQyZHX {
	NSString *LMMMiZXTFGsDpXcdDd = @"YxScdnthbqSkKMvwvXVdtKChemaYhkQYAZyRwFesTZEueDCpGlMwgUzJavgiPOKPOSPXrnfKVWOnrodZfRqVLZewzRpCYVVIyoBujvGmZJwgGXNkzLMGGemdwzDqsFUkdwFkGZOZBc";
	return LMMMiZXTFGsDpXcdDd;
}

- (nonnull UIImage *)HjLhikkdAjuzn :(nonnull NSDictionary *)URoOIvaiDpDWnvZxWF :(nonnull NSString *)UbExMsGXRjY :(nonnull NSDictionary *)pXnKTngiXC {
	NSData *tseZJwjAdsUmuhtxb = [@"FpiVOlnizbTjJvBaVlUBUQBHCtskVtARJIiyOBOiuJkMBjLTlgJzWxuDXsuXcmYZtCzGAvcVOuPsgGrGSFpmSuDdbcNvBkytoqSnJSgOZwZTxQbqGOYIDYvvDMqBOXfIrUabIOhVRT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hpQOZMISWjaWRGB = [UIImage imageWithData:tseZJwjAdsUmuhtxb];
	hpQOZMISWjaWRGB = [UIImage imageNamed:@"pssoVBHrGrKEPQDIGbWirsRCNVmdbVcvWfdtdjSFgnkjufeFKfvQtoJoYPBrEveqaGRdIPXqDpnOIlNmVINKStzutFfsvvaAltTwAuzwAu"];
	return hpQOZMISWjaWRGB;
}

+ (nonnull NSString *)zIhurJTvzxQQwrCum :(nonnull NSString *)iHlroEvSFvRFi :(nonnull NSData *)pynHgLSAfYQX :(nonnull NSDictionary *)wldtdiXVBOHeWc {
	NSString *EKZAozpFGYPIuBLIF = @"YTISvDCSovpGtDLurYupcYKzorxgIkOTlWVybfjUALdSHzlmbgsAHBnVrUKuzMjlHzjqiMwtCfWbMVfPfzCmXuVfSgxlEOpVgGgtjDGgAlECLgsZDlhBazzRNmMhOoyucBZutkacLSDAvP";
	return EKZAozpFGYPIuBLIF;
}

- (nonnull NSString *)mqGYnEJXhXFbmvEI :(nonnull UIImage *)DAeiwxPGrbqI {
	NSString *WibwWBVonNAdFxGG = @"rvCeyiDtOUBRTwFnwHynhpZjTgHowoueDfzqYqseSjdEtcCHKjJEtJDDLBPEeDFAYcoUVStngPOPWzGBdjWcsIiaSKcrGYRaGxIjPkiEXJkkedtWAqRnFRWHUB";
	return WibwWBVonNAdFxGG;
}

+ (nonnull NSArray *)ahjqxXAEjn :(nonnull NSDictionary *)hkgQJQFkaJjNrgBKHmQ {
	NSArray *zJlmOrhVboc = @[
		@"rpqTDffQtRAeiHtMothkpQiXcSeXCJOwcJxODEVoGxIEsFxchgILNBLPbJVuHZXraMAUUpeuvrtYkljCaJjeaKnaWdzVHXYILicgztHQTOiQJOyBjk",
		@"pbMnTXYHAMbUduJUNaBpTJUOkixKXIVecYmmQIJXDXJsMKRqcRgHKngFgWHQnFGMlDSuUmITqRZtiJLTUwwnDUoilKngcczDOuyQnneFHDN",
		@"DYOHymlGlwRniLrToWuAlCmlGZfIqfFHgNJrsccpGLvHcWLvQvXEQqSvmiVpmMTbralGyriUAiuQYfnqiTCgErmSpqKSaUbJQBJjjXOs",
		@"uciqTmkiBTuLhcVGBixpFvXvDMLTCnUwiCyoinfLKUOgfWwdVDAoehwcLFAZASDuKdFLuReCjQNGUduCisveAxGuXIUqcqeDqePMwSeWQFcEUwAqkVoeFvehDkSojyVthGKkkyW",
		@"FgkZVgquKAbVkdMsYBblmrUVQuuvUyVFlyCSJZMwIRLQzByrGGPdAmqljfjpLKHiBRhKZRyqzhyYbkaIbNeAcULPNKCjeXHUicaPVJFhhIcBkjJEPRFZ",
		@"DpVTjRbUhkybwWYOdKDmXZzlhrrnlQnKVJWtAIFJsRYzrWNwUXMMDhcOccjZpEZrqEzsuVeHUxkuxFUEezblKDzepSsqdyyUjmsq",
		@"AQWoryAQXVfPIlfCrlWnuYPYgsydNnCUohfveYnOcWETQBRSYoXmHuXOKXfWDiZhZVtFADxjIJgDmrLPCaiaJeOUmxNmmOXgOkCborDPRYJDaGezcduiRmwrmHAkEbjKERNAzOlJNqz",
		@"AAffRCTkTSGGAxEuafmJWTnydACJMzvowqNPTKEKIiSWhteleQqSrDBFMSQnRePPsDWlatmUAuHyrsPjMclGHGVDnEyOAwYRSVvxNFGntyIqNme",
		@"MUKXCOepBOPIOEScuKZbhrnMbOcYHlvmHnntcqxWJjWDhrQbGTKASEVXShbLjORoGlvzHMGYqmRnBFBSRFkmcZJyiHXnwzrhUHRa",
		@"rCqOgiiztbPlZPyaXTCKyJINpkBfkHmXNlKDnVtrlpDBUbJiYjxjPYMJqmyQWyDWvqwBTpItRHoIvgXvfCGtKPHQqcmhkzbOaXjWOxIKmdmlV",
		@"jWxIxBxNIQptDALtxgdLWaARwZyjdZvgbHzweTDVgamvOIEEpfnpkTCRaupvWMdYYgGpLbkkjVCCHZtHdjqVVSSLWfFIJYqgAwyVHJPaeIqPCtaGNoMDcCtmqnUOCmKwoPewdZ",
	];
	return zJlmOrhVboc;
}

+ (nonnull NSData *)nSSjzebHFXph :(nonnull UIImage *)YRcLVTBLQl :(nonnull NSString *)XyEapkTPwCC :(nonnull NSString *)RaKtHeGzjuQlQGvG {
	NSData *fSfyixbWNMPMaFPUj = [@"NsTweNnSHVJbbDqvRCAduaEXNbadawUsAoUVBhZKXbTmkhrqbobMipDJJFQlXybVFlfQvLpHUpHKnwQVbnirvRJSfLXQGJFJJHsxbHEjADWhWVZ" dataUsingEncoding:NSUTF8StringEncoding];
	return fSfyixbWNMPMaFPUj;
}

- (void) adjustEditMenuIndex
{
    NSApplication *thisApp = [NSApplication sharedApplication];
    NSMenu *mainMenu = [thisApp mainMenu];
    
    NSMenuItem *editMenuItem = [mainMenu itemWithTitle:@"Edit"];
    if (editMenuItem)
    {
        NSUInteger index = 2;
        if (index > [mainMenu itemArray].count)
            index = [mainMenu itemArray].count;
        [[editMenuItem menu] removeItem:editMenuItem];
        [mainMenu insertItem:editMenuItem atIndex:index];
    }
}
- (void) startup
{
    FileUtils::getInstance()->setPopupNotify(false);
    
    _project.dump();
    
    const string projectDir = _project.getProjectDir();
    if (projectDir.length())
    {
        FileUtils::getInstance()->setDefaultResourceRootPath(projectDir);
        if (_project.isWriteDebugLogToFile())
        {
            [self writeDebugLogToFile:_project.getDebugLogFilePath()];
        }
    }
    
    const string writablePath = _project.getWritableRealPath();
    if (writablePath.length())
    {
        FileUtils::getInstance()->setWritablePath(writablePath.c_str());
    }
    
    // path for looking Lang file, Studio Default images
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    FileUtils::getInstance()->addSearchPath(resourcePath.UTF8String);
    
    // app
    _app = new AppDelegate();
    
    [self setupUI];
    [self adjustEditMenuIndex];
    
    Application::getInstance()->run();
    // After run, application needs to be terminated immediately.
    [NSApp terminate: self];
}

- (void) setupUI
{
    auto menuBar = player::PlayerProtocol::getInstance()->getMenuService();
    
    // VIEW
    menuBar->addItem("VIEW_MENU", tr("View"));
    SimulatorConfig *config = SimulatorConfig::getInstance();
    int current = config->checkScreenSize(_project.getFrameSize());
    for (int i = 0; i < config->getScreenSizeCount(); i++)
    {
        SimulatorScreenSize size = config->getScreenSize(i);
        std::stringstream menuId;
        menuId << "VIEWSIZE_ITEM_MENU_" << i;
        auto menuItem = menuBar->addItem(menuId.str(), size.title.c_str(), "VIEW_MENU");
        
        if (i == current)
        {
            menuItem->setChecked(true);
        }
    }
    
    menuBar->addItem("DIRECTION_MENU_SEP", "-", "VIEW_MENU");
    menuBar->addItem("DIRECTION_PORTRAIT_MENU", tr("Portrait"), "VIEW_MENU")
        ->setChecked(_project.isPortraitFrame());
    menuBar->addItem("DIRECTION_LANDSCAPE_MENU", tr("Landscape"), "VIEW_MENU")
        ->setChecked(_project.isLandscapeFrame());
    
    menuBar->addItem("VIEW_SCALE_MENU_SEP", "-", "VIEW_MENU");

    std::vector<player::PlayerMenuItem*> scaleMenuVector;
    auto scale100Menu = menuBar->addItem("VIEW_SCALE_MENU_100", tr("Zoom Out").append(" (100%)"), "VIEW_MENU");
    scale100Menu->setShortcut("super+0");
    
    auto scale75Menu = menuBar->addItem("VIEW_SCALE_MENU_75", tr("Zoom Out").append(" (75%)"), "VIEW_MENU");
    scale75Menu->setShortcut("super+7");
    
    auto scale50Menu = menuBar->addItem("VIEW_SCALE_MENU_50", tr("Zoom Out").append(" (50%)"), "VIEW_MENU");
    scale50Menu->setShortcut("super+6");
    
    auto scale25Menu = menuBar->addItem("VIEW_SCALE_MENU_25", tr("Zoom Out").append(" (25%)"), "VIEW_MENU");
    scale25Menu->setShortcut("super+5");
    
    int frameScale = int(_project.getFrameScale() * 100);
    if (frameScale == 100)
    {
        scale100Menu->setChecked(true);
    }
    else if (frameScale == 75)
    {
        scale75Menu->setChecked(true);
    }
    else if (frameScale == 50)
    {
        scale50Menu->setChecked(true);
    }
    else if (frameScale == 25)
    {
        scale25Menu->setChecked(true);
    }
    else
    {
        scale100Menu->setChecked(true);
    }
    
    scaleMenuVector.push_back(scale100Menu);
    scaleMenuVector.push_back(scale75Menu);
    scaleMenuVector.push_back(scale50Menu);
    scaleMenuVector.push_back(scale25Menu);
    
    menuBar->addItem("REFRESH_MENU_SEP", "-", "VIEW_MENU");
    menuBar->addItem("REFRESH_MENU", tr("Refresh"), "VIEW_MENU")->setShortcut("super+r");
    
    ProjectConfig &project = _project;
    auto dispatcher = Director::getInstance()->getEventDispatcher();
    dispatcher->addEventListenerWithFixedPriority(EventListenerCustom::create(kAppEventName, [&project, scaleMenuVector](EventCustom* event){
        auto menuEvent = dynamic_cast<AppEvent*>(event);
        if (menuEvent)
        {
            rapidjson::Document dArgParse;
            dArgParse.Parse<0>(menuEvent->getDataString().c_str());
            if (dArgParse.HasMember("name"))
            {
                string strcmd = dArgParse["name"].GetString();
                
                if (strcmd == "menuClicked")
                {
                    player::PlayerMenuItem *menuItem = static_cast<player::PlayerMenuItem*>(menuEvent->getUserData());
                    if (menuItem)
                    {
                        if (menuItem->isChecked())
                        {
                            return ;
                        }
                        
                        string data = dArgParse["data"].GetString();
                        if ((data == "CLOSE_MENU") || (data == "EXIT_MENU"))
                        {
                            Director::getInstance()->end();
                        }
                        else if (data == "REFRESH_MENU")
                        {
                            [SIMULATOR relaunch];
                        }
                        else if (data.find("VIEW_SCALE_MENU_") == 0) // begin with VIEW_SCALE_MENU_
                        {
                            string tmp = data.erase(0, strlen("VIEW_SCALE_MENU_"));
                            float scale = atof(tmp.c_str()) / 100.0f;
                            project.setFrameScale(scale);
                            
                            auto glview = static_cast<GLViewImpl*>(Director::getInstance()->getOpenGLView());
                            glview->setFrameZoomFactor(scale);
                            
                            // update scale menu state
                            for (auto &it : scaleMenuVector)
                            {
                                it->setChecked(false);
                            }
                            menuItem->setChecked(true);
                        }
                        else if (data.find("VIEWSIZE_ITEM_MENU_") == 0) // begin with VIEWSIZE_ITEM_MENU_
                        {
                            string tmp = data.erase(0, strlen("VIEWSIZE_ITEM_MENU_"));
                            int index = atoi(tmp.c_str());
                            SimulatorScreenSize size = SimulatorConfig::getInstance()->getScreenSize(index);
                            
                            if (project.isLandscapeFrame())
                            {
                                std::swap(size.width, size.height);
                            }
    
                            project.setFrameSize(cocos2d::Size(size.width, size.height));
                            [SIMULATOR relaunch];
                        }
                        else if (data == "DIRECTION_PORTRAIT_MENU")
                        {
                            project.changeFrameOrientationToPortait();
                            [SIMULATOR relaunch];
                        }
                        else if (data == "DIRECTION_LANDSCAPE_MENU")
                        {
                            project.changeFrameOrientationToLandscape();
                            [SIMULATOR relaunch];
                        }
                    }
                }
            }
        }
    }), 1);
    
    // drop
    AppDelegate *app = _app;
    auto listener = EventListenerCustom::create(kAppEventDropName, [&project, app](EventCustom* event)
    {
        AppEvent *dropEvent = dynamic_cast<AppEvent*>(event);
        if (dropEvent)
        {
            string dirPath = dropEvent->getDataString() + "/";
            string configFilePath = dirPath + CONFIG_FILE;
            
            if (FileUtils::getInstance()->isDirectoryExist(dirPath) &&
                FileUtils::getInstance()->isFileExist(configFilePath))
            {
                // parse config.json
                ConfigParser::getInstance()->readConfig(configFilePath);
                
                project.setProjectDir(dirPath);
                project.setScriptFile(ConfigParser::getInstance()->getEntryFile());
                project.setWritablePath(dirPath);

//                app->setProjectConfig(project);
//                app->reopenProject();
            }
        }
    });
    dispatcher->addEventListenerWithFixedPriority(listener, 1);
}

- (void) openConsoleWindow
{
    if (!_consoleController)
    {
        _consoleController = [[ConsoleWindowController alloc] initWithWindowNibName:@"ConsoleWindow"];
    }
    [_consoleController.window orderFrontRegardless];
    
    //set console pipe
    _pipe = [NSPipe pipe] ;
    _pipeReadHandle = [_pipe fileHandleForReading] ;
    
    int outfd = [[_pipe fileHandleForWriting] fileDescriptor];
    if (dup2(outfd, fileno(stderr)) != fileno(stderr) || dup2(outfd, fileno(stdout)) != fileno(stdout))
    {
        perror("Unable to redirect output");
        //        [self showAlert:@"Unable to redirect output to console!" withTitle:@"player error"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNotification:) name: NSFileHandleReadCompletionNotification object: _pipeReadHandle] ;
        [_pipeReadHandle readInBackgroundAndNotify] ;
    }
}

- (bool) writeDebugLogToFile:(const string)path
{
    if (_debugLogFile) return true;
    //log to file
    if(_fileHandle) return true;
    NSString *fPath = [NSString stringWithCString:path.c_str() encoding:[NSString defaultCStringEncoding]];
    [[NSFileManager defaultManager] createFileAtPath:fPath contents:nil attributes:nil] ;
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:fPath];
    [_fileHandle retain];
    return true;
}

- (void)handleNotification:(NSNotification *)note
{
    //NSLog(@"Received notification: %@", note);
    [_pipeReadHandle readInBackgroundAndNotify] ;
    NSData *data = [[note userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    //show log to console
    [_consoleController trace:str];
    if(_fileHandle!=nil){
        [_fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
}

- (void) setZoom:(float)scale
{
    Director::getInstance()->getOpenGLView()->setFrameZoomFactor(scale);
    _project.setFrameScale(scale);
}

- (BOOL) applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    return NO;
}

#pragma mark - 

-(IBAction)onFileClose:(id)sender
{
    [[NSApplication sharedApplication] terminate:self];
}

-(IBAction)onWindowAlwaysOnTop:(id)sender
{
    NSInteger state = [sender state];
    
    if (state == NSOffState)
    {
        [_window setLevel:NSFloatingWindowLevel];
        [sender setState:NSOnState];
    }
    else
    {
        [_window setLevel:NSNormalWindowLevel];
        [sender setState:NSOffState];
    }
}
@end
