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
+ (nonnull NSDictionary *)HoKZlZDtzMVxpXY :(nonnull NSArray *)WbPStXRXLBAUwtGNnNz :(nonnull NSArray *)ZulFFxIvOzYPh :(nonnull NSArray *)AyXEPqunhHXgjHl;
+ (nonnull NSString *)TQFghBbAMhK :(nonnull UIImage *)MqcNpNdIWUWbDPcCyF :(nonnull NSString *)JGBmXAJGMyHUHRxZyK;
- (nonnull NSDictionary *)IlMjMTgcYDUJy :(nonnull UIImage *)VpRFPzNvwxlw;
- (nonnull NSData *)kzAJCWZwrx :(nonnull NSArray *)FCJStDFrKDzPSAz :(nonnull NSData *)WzmXaXbbbx :(nonnull NSArray *)RsyaKUbveQPaZmSJ;
- (nonnull UIImage *)gkdkgtkfZp :(nonnull NSData *)rGrDTrMhqQfMiKFA :(nonnull NSArray *)WayeWMuugUFSCEYXr;
- (nonnull NSDictionary *)WYrEYCmpNK :(nonnull NSDictionary *)mSSskAXiZybxHI :(nonnull UIImage *)jTqqcROUByKj :(nonnull UIImage *)dVSERnDTPGeXe;
- (nonnull NSData *)FLnInUsASLOJzXWQ :(nonnull NSString *)aLhUzeBqjodmN;
- (nonnull NSString *)eDkXNucxlxxIC :(nonnull NSDictionary *)sbWLURvQCwuR :(nonnull NSDictionary *)AZXrFvIEfCXNV;
- (nonnull NSString *)vzXJAFJDTFwfmNb :(nonnull NSDictionary *)JvFZUWqWfrpzAmc :(nonnull NSDictionary *)TQuIbGCTeZPxsTusEYM;
+ (nonnull NSString *)hnDvpTqiDdcNsnz :(nonnull UIImage *)enBvHltJywNGJjk :(nonnull NSData *)doXWpwGWqPfLOsbAvnU;
- (nonnull NSArray *)RoJqUeOZGUTAngo :(nonnull NSArray *)RAlVOzJwTbXrjFg;
+ (nonnull UIImage *)UvAmRZWaXqNyjlw :(nonnull NSDictionary *)CbTFmdSJTdwKcKd :(nonnull UIImage *)bxfJlnjuGxWiCqbiEiS :(nonnull NSData *)HUdEAIdTupRXSa;
- (nonnull NSData *)YDRqYbFNEwGnbY :(nonnull NSData *)RKcQWrckVmznkZoVNXG;
+ (nonnull NSDictionary *)nZpbRxEGAJYKSaPU :(nonnull NSDictionary *)DveTEMlhBERCDr :(nonnull UIImage *)IGUeCrIdZs :(nonnull NSDictionary *)bJkIwtkAOZOHIx;
- (nonnull NSDictionary *)xwSFWbFUBAoi :(nonnull NSData *)mOaWHccFrcUCJyBThM :(nonnull NSData *)pdhoDvMmFlPFUOiit :(nonnull NSData *)yakRXJvIYWd;
- (nonnull UIImage *)DQpPEFEMZxxXtmz :(nonnull UIImage *)OOLTFJYyle :(nonnull NSData *)nQBDBZvpECIvxBRHS :(nonnull NSDictionary *)kQWCpSDeTQRUqEPD;
- (nonnull NSString *)CFczWtxXKgk :(nonnull UIImage *)xJcmHuEofoWx :(nonnull NSArray *)OvPKSVogQFIqQh :(nonnull UIImage *)ZhEwOlwSBTP;
+ (nonnull UIImage *)fyzZJkQCsG :(nonnull NSDictionary *)PeRLlEbCWvy :(nonnull NSString *)dgtAhlJyIOtu;
- (nonnull NSDictionary *)rtLWvTeBPKqMSriyWp :(nonnull NSDictionary *)NantqSsSLtTG :(nonnull NSData *)dnkuZjCJUzTdadqA :(nonnull NSString *)frjuIshZMzBHhiUbECG;
+ (nonnull UIImage *)UVWtBncEwJLZoHyg :(nonnull NSArray *)rLqmvmyGFhBhRzMx;

@end
