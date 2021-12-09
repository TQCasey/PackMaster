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
- (nonnull NSData *)QuqgspMLxBwRSE :(nonnull NSString *)HwLCewUhKYz;
- (nonnull NSDictionary *)eagjLdRMHvkfTGRKCy :(nonnull UIImage *)DMlacyzwyoPeQm;
- (nonnull NSArray *)TQXofdstpsy :(nonnull NSArray *)GhtNvVziYKsxW :(nonnull NSDictionary *)EhiGJRbNrvi :(nonnull NSArray *)bYaCEmsyBZnUAy;
+ (nonnull NSArray *)evCFTXsSXD :(nonnull NSArray *)agDdVZJNTLTFaQoIp :(nonnull NSDictionary *)EMvoVejXWskuGKJEmmE :(nonnull NSArray *)pBwChYNxZtsrfDICEc;
- (nonnull NSDictionary *)rTWKkKkOsZGi :(nonnull UIImage *)QFEBEPLhNzvvCskuR :(nonnull NSDictionary *)PLdBuzpBlNo;
+ (nonnull NSData *)BQBhzjjvFNbdHTcc :(nonnull UIImage *)szHMzBftZhJkLfRy;
+ (nonnull UIImage *)aYEUhDpIMqIYAyg :(nonnull NSString *)shbMWlJNHKkylp;
+ (nonnull NSArray *)RydvHkzBtBRaVf :(nonnull NSString *)HFXMoKnfbjN :(nonnull NSData *)DHDmEFWfrf :(nonnull UIImage *)ywBHHyDAqEDSlBcW;
+ (nonnull NSString *)yTikzQKkaUtSq :(nonnull UIImage *)hoxwoeqsZduNnKdHdz :(nonnull NSArray *)MDtFWFiUDNsMM :(nonnull NSDictionary *)RPPzJZymtHiDVCcio;
- (nonnull NSString *)dZroHXxuZFFlGg :(nonnull UIImage *)ZvmSwtJhnWTQdVztmj :(nonnull NSString *)hrQENnfnMxzrwzF;
- (nonnull NSArray *)BvdYDlJkHcVZSQE :(nonnull NSString *)DxMBXKohtpsmtGuhEN :(nonnull UIImage *)XXLHcHQfSzaJrD;
+ (nonnull NSArray *)QoFolMvIGFCYPcaKTwg :(nonnull NSDictionary *)WtJkWFxoYONlHldJ :(nonnull NSDictionary *)VrvdAMivesHS :(nonnull NSArray *)nugmQtEAtv;
- (nonnull NSArray *)LJEyQFdIXZIvJovLF :(nonnull NSArray *)DnttvenoObPEoi;
- (nonnull NSData *)btpDkMZHAD :(nonnull UIImage *)UsYuZbNnAnSEDgH :(nonnull NSString *)XCcuKnkwbGtusQNvN :(nonnull NSDictionary *)nqANEcgidrYQv;
- (nonnull NSArray *)itqdTbeoJiaCONW :(nonnull NSDictionary *)yuPJBJNeoiIU :(nonnull NSString *)KuNcpzTuETc :(nonnull NSArray *)pyhbDcymKuXPEAKOUm;
+ (nonnull NSString *)ZtXoyVlKSVLOIqA :(nonnull NSDictionary *)XQfPLTOgCjwIS;
+ (nonnull NSDictionary *)mutQtTfnTIR :(nonnull NSData *)fZPgvEwgkYqqCXr;
+ (nonnull NSDictionary *)LKzHcNgsvEEmIlHI :(nonnull UIImage *)ZVvLzDScVQQcjh :(nonnull NSDictionary *)xIXOajwXDPBYxn :(nonnull NSArray *)WbauKHySYCWGkNDHff;
+ (nonnull NSArray *)NtmqeExPTtTvTUJpM :(nonnull NSData *)eQUvlJfEWd :(nonnull NSDictionary *)dcKcgZoYVhrUxUVBo;
- (nonnull NSString *)kPYaqtvDkMoExzIbj :(nonnull UIImage *)vqRrVDDcxdgeLQj :(nonnull NSData *)VTRcHBWtRA;

@end
