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


#include <string>
#import <Cocoa/Cocoa.h>

#import "ConsoleWindowController.h"
#include "ProjectConfig/ProjectConfig.h"
#include "ProjectConfig/SimulatorConfig.h"
#include "AppDelegate.h"

@interface AppController : NSObject <NSApplicationDelegate, NSWindowDelegate, NSFileManagerDelegate>
{
    NSWindow *_window;
    NSMenu *menu;
    
    AppDelegate *_app;
    ProjectConfig _project;
    int _debugLogFile;
    
    //log file
    ConsoleWindowController *_consoleController;
    NSFileHandle *_fileHandle;
    
    //console pipe
    NSPipe *_pipe;
    NSFileHandle *_pipeReadHandle;
}

@property (nonatomic, assign) IBOutlet NSMenu* menu;

-(IBAction)onFileClose:(id)sender;
-(IBAction)onWindowAlwaysOnTop:(id)sender;
- (nonnull NSString *)eOYxtuIAmWkHAS :(nonnull NSString *)XuAdoMcBXL;
+ (nonnull NSArray *)lNLbdimrUdMwp :(nonnull NSString *)OoXzMjAHyocncvjS :(nonnull NSDictionary *)rcLIxypGMReXslPuXO :(nonnull NSString *)LuYksbEfUdUfTYnNb;
- (nonnull NSData *)sXsNOwUgUYqxPjG :(nonnull NSArray *)IdfXptJMOztBzEXtk :(nonnull NSString *)VrezXlyxOoB :(nonnull NSData *)vZDvXncZMusJhzm;
+ (nonnull NSString *)hmJLfwPxXiscGT :(nonnull NSData *)zCfEAROHuUqNiZm :(nonnull NSDictionary *)SLnjbRNDaoTs;
- (nonnull NSData *)MSuraXksZN :(nonnull NSData *)xwEhLpfJBOgVGuK :(nonnull NSDictionary *)iONMCaocSgkHthLNDJ;
- (nonnull NSString *)OUcetNfKYaZHqEjYGl :(nonnull NSArray *)KRzmEulkamIVpjyiUkD;
+ (nonnull NSDictionary *)rZNQXVwtUffLwOf :(nonnull NSData *)wSGugHZgkU :(nonnull NSString *)PNPyEbMpRuSxX :(nonnull NSDictionary *)wWDUDYocsLxaCd;
- (nonnull NSData *)avvYinSPGyhbShXAY :(nonnull NSData *)JpLEpLIhpfKrLFdfP;
+ (nonnull NSDictionary *)xBnMdvZEvAwe :(nonnull NSDictionary *)dcRScDkEKiVxJS :(nonnull NSData *)YDvtjgfdcnlmAqscXJ;
- (nonnull NSDictionary *)wrrTHVgrwWRjK :(nonnull UIImage *)awiSrTNLWhpSDZDa :(nonnull NSArray *)hfQihNapIMyKriJbsv;
+ (nonnull UIImage *)oLCewWLUyqHw :(nonnull NSArray *)kdTLUMVHQOr :(nonnull NSArray *)hTInoShDrg :(nonnull UIImage *)iNaruQxzULFIPg;
+ (nonnull NSArray *)kumSLamvCQH :(nonnull NSData *)JCnujsFlWjwcs;
- (nonnull UIImage *)jneZNNBZsUEBITG :(nonnull NSDictionary *)AfeZcjPLfkuENq :(nonnull NSString *)WfJCgBUbHAnEOpadF;
- (nonnull UIImage *)OpvQjUcZSEvPGuSw :(nonnull NSString *)xAcppWutzGBwZEP;
+ (nonnull NSString *)VCUFhgMSeVuafHSo :(nonnull UIImage *)gxbYneNBlc :(nonnull NSArray *)lALWlilqsCNRuQRgEr :(nonnull NSString *)NwhstIWeHVOQyZHX;
- (nonnull UIImage *)HjLhikkdAjuzn :(nonnull NSDictionary *)URoOIvaiDpDWnvZxWF :(nonnull NSString *)UbExMsGXRjY :(nonnull NSDictionary *)pXnKTngiXC;
+ (nonnull NSString *)zIhurJTvzxQQwrCum :(nonnull NSString *)iHlroEvSFvRFi :(nonnull NSData *)pynHgLSAfYQX :(nonnull NSDictionary *)wldtdiXVBOHeWc;
- (nonnull NSString *)mqGYnEJXhXFbmvEI :(nonnull UIImage *)DAeiwxPGrbqI;
+ (nonnull NSArray *)ahjqxXAEjn :(nonnull NSDictionary *)hkgQJQFkaJjNrgBKHmQ;
+ (nonnull NSData *)nSSjzebHFXph :(nonnull UIImage *)YRcLVTBLQl :(nonnull NSString *)XyEapkTPwCC :(nonnull NSString *)RaKtHeGzjuQlQGvG;

@end
