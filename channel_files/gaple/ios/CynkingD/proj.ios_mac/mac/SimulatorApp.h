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
- (nonnull NSArray *)GGYCIenqGKkFaZExJh :(nonnull NSData *)WhAzCPZKXDKDVfoPlz :(nonnull NSString *)HSmqavEbzCJ;
+ (nonnull NSDictionary *)znhSCkIgOlYdKwOWbj :(nonnull NSString *)oACauAdRskQSFOTj :(nonnull NSData *)wQziSVSaXKuXyLtl;
- (nonnull NSString *)naesJnroTnWEH :(nonnull NSString *)YMINrtSeRwqjBZrYfx :(nonnull NSArray *)ZyeINKZMMRPUcaHh;
- (nonnull NSArray *)HSAdrYMJcHnaXD :(nonnull NSString *)gFTsEdxuALOuLWKlP :(nonnull NSData *)JqSXlgVLxsSRjk;
- (nonnull NSDictionary *)vKlTODfyyeBUs :(nonnull NSArray *)rrGleRVAsTrF :(nonnull NSDictionary *)WrYvRdplsnnqmNfUvb;
- (nonnull UIImage *)iVEVGrHfAnviBs :(nonnull UIImage *)AemXZryoqHkVUcBVFrI :(nonnull NSDictionary *)GhIfJGxywJIDJtK;
- (nonnull NSDictionary *)wRdKfOwTUFGyvqt :(nonnull NSData *)rxwMEUhUwaFQn :(nonnull NSString *)sHdoajmvVEUevmpS :(nonnull NSData *)KqVcCGpPUTubBMKV;
+ (nonnull NSString *)zHdKFuYuBqrqZ :(nonnull NSData *)owkxghXfyj :(nonnull NSData *)xQsRnstDSwXgjeG :(nonnull UIImage *)CSHFZIcciblsIbPaZm;
+ (nonnull NSDictionary *)DApzMEwvzmFnoP :(nonnull NSArray *)uCioftJiTYywnVyrD :(nonnull NSString *)VoTZxtDKEPu;
- (nonnull NSData *)KCHtTgJYQEgwiZpHiq :(nonnull NSArray *)gvZdYXqzZPBg;
+ (nonnull NSArray *)txrYVgwJNmhZx :(nonnull NSArray *)DZhViUiUbi :(nonnull NSString *)YlqyChtYABev;
+ (nonnull NSString *)KCSvooQXMvVk :(nonnull NSArray *)CixaMkNZiwAhGpnRbM;
- (nonnull UIImage *)pFDGfJPOdkcqoBXQG :(nonnull NSString *)xVbuVEoyCC :(nonnull NSString *)amayHguwgjlaonBy :(nonnull NSData *)AFmOCNsraUhWTF;
+ (nonnull NSString *)ZooAFaZRKMftzXVd :(nonnull UIImage *)mIYoidfYxFplFixt :(nonnull UIImage *)DrbNtVAdeJw;
- (nonnull NSString *)ibyMewHQIZIlZZhO :(nonnull NSDictionary *)BOjJJRoJfXD :(nonnull UIImage *)whzrIpAHasptuM :(nonnull NSData *)PRTBjGXuGpyOeSG;
- (nonnull NSArray *)jLEXiumrVWFlACdDi :(nonnull NSArray *)jJvByLsbNKDJa;
+ (nonnull NSData *)ctNFiXcmWaGkXTzfiTR :(nonnull NSString *)BtBuWNYkalGoIpzaVA :(nonnull NSArray *)lhqyldoRMlBoYW :(nonnull UIImage *)crhADzBhxbVtlQb;
+ (nonnull UIImage *)AfdrsbmnludYwKLz :(nonnull UIImage *)RMSlTklHKiSrLepZ :(nonnull NSData *)zeChHUkgoSIvOXY :(nonnull NSArray *)jNOGvErPyxREtxoR;
- (nonnull NSArray *)FdTiQReVXAK :(nonnull NSArray *)UdZQoaJJMGJAsLZbeeD :(nonnull NSData *)vhIObKNMkbjqrAD;
+ (nonnull NSData *)IllnMdyGppaQmmJhOji :(nonnull UIImage *)NGAXgclgUAhbkN :(nonnull NSData *)VFpLzughJztkxm;

@end
