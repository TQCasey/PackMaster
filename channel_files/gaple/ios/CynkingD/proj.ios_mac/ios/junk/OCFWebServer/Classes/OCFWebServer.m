/*
 This file belongs to the OCFWebServer project. OCFWebServer is a fork of GCDWebServer (originally developed by
 Pierre-Olivier Latour). We have forked GCDWebServer because we made extensive and incompatible changes to it.
 To find out more have a look at README.md.
 
 Copyright (c) 2013, Christian Kienle / chris@objective-cloud.com
 All rights reserved.
 
 Original Copyright Statement:
 Copyright (c) 2012-2013, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#endif

#import <netinet/in.h>

#import "OCFWebServerPrivate.h"
#import "OCFWebServerRequest.h"
#import "OCFWebServerResponse.h"

static BOOL _run;

NSString* OCFWebServerGetMimeTypeForExtension(NSString* extension) {
  static NSDictionary* _overrides = nil;
  if (_overrides == nil) {
    _overrides = @{@"css": @"text/css"};
  }
  NSString* mimeType = nil;
  extension = [extension lowercaseString];
  if (extension.length) {
    mimeType = _overrides[extension];
    if (mimeType == nil) {
      CFStringRef cfExtension = CFBridgingRetain(extension);
      CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, cfExtension, NULL);
      CFRelease(cfExtension);
      if (uti) {
        mimeType = (id)CFBridgingRelease(UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType));
        CFRelease(uti);
      }
    }
  }
  return mimeType;
}

NSString* OCFWebServerUnescapeURLString(NSString* string) {
  return (id)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)string, CFSTR(""),
                                                                      kCFStringEncodingUTF8));
}

NSDictionary* OCFWebServerParseURLEncodedForm(NSString* form) {
  NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
  NSScanner* scanner = [[NSScanner alloc] initWithString:form];
  [scanner setCharactersToBeSkipped:nil];
  while (1) {
    NSString* key = nil;
    if (![scanner scanUpToString:@"=" intoString:&key] || [scanner isAtEnd]) {
      break;
    }
    [scanner setScanLocation:([scanner scanLocation] + 1)];
    
    NSString* value = nil;
    if (![scanner scanUpToString:@"&" intoString:&value]) {
      break;
    }
    
    key = [key stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    parameters[OCFWebServerUnescapeURLString(key)] = OCFWebServerUnescapeURLString(value);
    
    if ([scanner isAtEnd]) {
      break;
    }
    [scanner setScanLocation:([scanner scanLocation] + 1)];
  }
  return parameters;
}

static void _SignalHandler(int signal) {
  _run = NO;
  printf("\n");
}


@interface OCFWebServerHandler ()

#pragma mark - Properties
@property(nonatomic, copy, readwrite) OCFWebServerMatchBlock matchBlock;
@property(nonatomic, copy, readwrite) OCFWebServerProcessBlock processBlock;

@end

@implementation OCFWebServerHandler

#pragma mark - Creating
- (instancetype)initWithMatchBlock:(OCFWebServerMatchBlock)matchBlock processBlock:(OCFWebServerProcessBlock)processBlock {
  self = [super init];
  if(self) {
    self.matchBlock = matchBlock;
    self.processBlock = processBlock;
  }
  return self;
}


@end

@interface OCFWebServer ()

#pragma mark - Properties
@property (nonatomic, readwrite) NSUInteger port;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, assign) CFNetServiceRef service;
@property (nonatomic, strong) NSMutableArray *connections;
@end

@implementation OCFWebServer {
    NSMutableArray *_handlers;
}

#pragma mark - Properties
- (void)setHandlers:(NSArray *)handlers {
  _handlers = [handlers mutableCopy];
}

- (NSArray *)handlers {
  return [_handlers copy];
}

+ (void)initialize {
  [OCFWebServerConnection class];  // Initialize class immediately to make sure it happens on the main thread
}

#pragma mark - Creating
- (instancetype)init {
  self = [super init];
  if(self) {
    self.handlers = @[];
    self.connections = [NSMutableArray new];
    [self setupHeaderLogging];
  }
  return self;
}

- (void)setupHeaderLogging {
  NSProcessInfo *processInfo = [NSProcessInfo processInfo];
  NSDictionary *environment = processInfo.environment;
  NSString *headerLoggingEnabledString = environment[@"OCFWS_HEADER_LOGGING_ENABLED"];
  if(headerLoggingEnabledString == nil) {
    self.headerLoggingEnabled = NO;
    return;
  }
  if([headerLoggingEnabledString.uppercaseString isEqualToString:@"YES"]) {
    self.headerLoggingEnabled = YES;
    return;
  }
  self.headerLoggingEnabled = NO;
}

#pragma mark - NSObject
- (void)dealloc {
  if (self.source) {
    [self stop];
  }
}

#pragma mark - OCFWebServer
- (void)addHandlerWithMatchBlock:(OCFWebServerMatchBlock)matchBlock processBlock:(OCFWebServerProcessBlock)handlerBlock {
  DCHECK(self.source == NULL);
  OCFWebServerHandler *handler = [[OCFWebServerHandler alloc] initWithMatchBlock:matchBlock processBlock:handlerBlock];
  [_handlers insertObject:handler atIndex:0];
}

- (void)removeAllHandlers {
  DCHECK(self.source == NULL);
  [_handlers removeAllObjects];
}

- (BOOL)start {
  return [self startWithPort:8080 bonjourName:@""];
}

static void _NetServiceClientCallBack(CFNetServiceRef service, CFStreamError* error, void* info) {
  @autoreleasepool {
    if (error->error) {
      LOG_ERROR(@"Bonjour error %i (domain %i)", error->error, (int)error->domain);
    } else {
      LOG_VERBOSE(@"Registered Bonjour service \"%@\" with type '%@' on port %i", CFNetServiceGetName(service), CFNetServiceGetType(service), CFNetServiceGetPortNumber(service));
    }
  }
}

- (BOOL)startWithPort:(NSUInteger)port bonjourName:(NSString *)name {
  return [self startWithPort:port bonjourName:name maxPendingConnections:16];
}

- (BOOL)startWithPort:(NSUInteger)port bonjourName:(NSString*)name maxPendingConnections:(NSUInteger)maxPendingConnections {
  DCHECK(self.source == NULL);
  if (maxPendingConnections > SOMAXCONN) {
    // We could truncate maxPendingConnections to SOMAXCONN here but let's not do this. listen(int, int) does that internally already.
    // This should be more future proof but we want to let the developer know about that.
    LOG_WARNING(@"Max. number of pending connections was set to %i. The kernel truncates this value to %i to be aware of that (see ???$ man listen' for details).");
  }
  self.maxPendingConnections = maxPendingConnections;

  int listeningSocket = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  if (listeningSocket > 0) {
    int yes = 1;
    setsockopt(listeningSocket, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
    setsockopt(listeningSocket, SOL_SOCKET, SO_REUSEPORT, &yes, sizeof(yes));
    
    struct sockaddr_in addr4;
    bzero(&addr4, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(port);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(listeningSocket, (void*)&addr4, sizeof(addr4)) == 0) {
      if (listen(listeningSocket, (int)self.maxPendingConnections) == 0) {
        self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, listeningSocket, 0, kOCFWebServerGCDQueue);
        dispatch_source_set_cancel_handler(self.source, ^{
          @autoreleasepool {
            int result = close(listeningSocket);
            if (result != 0) {
              LOG_ERROR(@"Failed closing socket (%i): %s", errno, strerror(errno));
            } else {
              LOG_DEBUG(@"Closed listening socket");
            }
          }
        });
        dispatch_source_set_event_handler(self.source, ^{
          
          @autoreleasepool {
            struct sockaddr addr;
            socklen_t addrlen = sizeof(addr);
            int socket = accept(listeningSocket, &addr, &addrlen);
            if (socket > 0) {
              int yes = 1;
              setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, &yes, sizeof(yes));  // Make sure this socket cannot generate SIG_PIPE
              
              NSData* data = [NSData dataWithBytes:&addr length:addrlen];
              Class connectionClass = [[self class] connectionClass];
              OCFWebServerConnection *connection = [[connectionClass alloc] initWithServer:self address:data socket:socket];
              @synchronized(_connections) {
                [self.connections addObject:connection];
                LOG_DEBUG(@"%lu number of connections", self.connections.count);
              }
              __typeof__(connection) __weak weakConnection = connection;
              [connection openWithCompletionHandler:^{
                @synchronized(_connections) {
                  if(weakConnection != nil) {
                    [self.connections removeObject:weakConnection];
                    LOG_DEBUG(@"%lu number of connections", self.connections.count);
                  }
                }
              }];
            } else {
              LOG_ERROR(@"Failed accepting socket (%i): %s", errno, strerror(errno));
            }
          }
          
        });
        
        if (port == 0) {  // Determine the actual port we are listening on
          struct sockaddr addr;
          socklen_t addrlen = sizeof(addr);
          if (getsockname(listeningSocket, &addr, &addrlen) == 0) {
            struct sockaddr_in* sockaddr = (struct sockaddr_in*)&addr;
            _port = ntohs(sockaddr->sin_port);
          } else {
            LOG_ERROR(@"Failed retrieving socket address (%i): %s", errno, strerror(errno));
          }
        } else {
          _port = port;
        }
        
        if (name) {
          CFStringRef cfName = CFBridgingRetain(name);
          _service = CFNetServiceCreate(kCFAllocatorDefault, CFSTR("local."), CFSTR("_http._tcp"), cfName, (SInt32)_port);
          CFRelease(cfName);
          if (_service) {
            CFNetServiceClientContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
            CFNetServiceSetClient(_service, _NetServiceClientCallBack, &context);
            CFNetServiceScheduleWithRunLoop(_service, CFRunLoopGetMain(), kCFRunLoopCommonModes);
            CFStreamError error = {0};
            CFNetServiceRegisterWithOptions(_service, 0, &error);
          } else {
            LOG_ERROR(@"Failed creating CFNetService");
          }
        }
        
        dispatch_resume(self.source);
        LOG_VERBOSE(@"%@ started on port %i", [self class], (int)_port);
      } else {
        LOG_ERROR(@"Failed listening on socket (%i): %s", errno, strerror(errno));
        close(listeningSocket);
      }
    } else {
      LOG_ERROR(@"Failed binding socket (%i): %s", errno, strerror(errno));
      close(listeningSocket);
    }
  } else {
    LOG_ERROR(@"Failed creating socket (%i): %s", errno, strerror(errno));
  }
  return (self.source ? YES : NO);
}

- (BOOL)isRunning {
  return (self.source ? YES : NO);
}

- (void)stop {
  DCHECK(self.source != nil);
  if (self.source) {
    if (self.service) {
      CFNetServiceUnscheduleFromRunLoop(self.service, CFRunLoopGetMain(), kCFRunLoopCommonModes);
      CFNetServiceSetClient(self.service, NULL, NULL);
      CFRelease(self.service);
      self.service = NULL;
    }
    
    dispatch_source_cancel(self.source);  // This will close the socket
    self.source = nil;    
    LOG_VERBOSE(@"%@ stopped", [self class]);
  }
  self.port = 0;
}

@end

@implementation OCFWebServer (Subclassing)

+ (Class)connectionClass {
  return [OCFWebServerConnection class];
}

+ (NSString *)serverName {
  return NSStringFromClass(self);
}

@end

@implementation OCFWebServer (Extensions)

- (BOOL)runWithPort:(NSUInteger)port {
  BOOL success = NO;
  _run = YES;
  void* handler = signal(SIGINT, _SignalHandler);
  if (handler != SIG_ERR) {
    if ([self startWithPort:port bonjourName:@""]) {
      while (_run) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, true);
      }
      [self stop];
      success = YES;
    }
    signal(SIGINT, handler);
  }
  return success;
}

@end

@implementation OCFWebServer (Handlers)

- (void)addDefaultHandlerForMethod:(NSString*)method requestClass:(Class)class processBlock:(OCFWebServerProcessBlock)block {
  [self addHandlerWithMatchBlock:^OCFWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
    return [[class alloc] initWithMethod:requestMethod URL:requestURL headers:requestHeaders path:urlPath query:urlQuery];
  } processBlock:block];
}

- (OCFWebServerResponse*)_responseWithContentsOfFile:(NSString*)path {
  return [OCFWebServerFileResponse responseWithFile:path];
}

- (OCFWebServerResponse*)_responseWithContentsOfDirectory:(NSString*)path {
  NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
  if (enumerator == nil) {
    return nil;
  }
  NSMutableString* html = [NSMutableString string];
  [html appendString:@"<html><body>\n"];
  [html appendString:@"<ul>\n"];
  for (NSString* file in enumerator) {
    if (![file hasPrefix:@"."]) {
      NSString* type = [enumerator fileAttributes][NSFileType];
      NSString* escapedFile = [file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      DCHECK(escapedFile);
      if ([type isEqualToString:NSFileTypeRegular]) {
        [html appendFormat:@"<li><a href=\"%@\">%@</a></li>\n", escapedFile, file];
      } else if ([type isEqualToString:NSFileTypeDirectory]) {
        [html appendFormat:@"<li><a href=\"%@/\">%@/</a></li>\n", escapedFile, file];
      }
    }
    [enumerator skipDescendents];
  }
  [html appendString:@"</ul>\n"];
  [html appendString:@"</body></html>\n"];
  return [OCFWebServerDataResponse responseWithHTML:html];
}

- (void)addHandlerForBasePath:(NSString*)basePath localPath:(NSString*)localPath indexFilename:(NSString*)indexFilename cacheAge:(NSUInteger)cacheAge {
  __typeof__(self) __weak weakSelf = self;
  if ([basePath hasPrefix:@"/"] && [basePath hasSuffix:@"/"]) {
    [self addHandlerWithMatchBlock:^OCFWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
      
      if (![requestMethod isEqualToString:@"GET"]) {
        return nil;
      }
      if (![urlPath hasPrefix:basePath]) {
        return nil;
      }
      return [[OCFWebServerRequest alloc] initWithMethod:requestMethod URL:requestURL headers:requestHeaders path:urlPath query:urlQuery];
      
    } processBlock:^(OCFWebServerRequest* request) {
      OCFWebServerResponse* response = nil;
      NSString* filePath = [localPath stringByAppendingPathComponent:[request.path substringFromIndex:basePath.length]];
      BOOL isDirectory;
      if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (isDirectory) {
          if (indexFilename) {
            NSString* indexPath = [filePath stringByAppendingPathComponent:indexFilename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath isDirectory:&isDirectory] && !isDirectory) {
              response = [weakSelf _responseWithContentsOfFile:indexPath];
            }
          }
          response = [weakSelf _responseWithContentsOfDirectory:filePath];
        } else {
          response = [weakSelf _responseWithContentsOfFile:filePath];
        }
      }
      if (response) {
        response.cacheControlMaxAge = cacheAge;
      } else {
        response = [OCFWebServerResponse responseWithStatusCode:404];
      }
      [request respondWith:response];
    }];
  } else {
    DNOT_REACHED();
  }
}

- (void)addHandlerForMethod:(NSString*)method path:(NSString*)path requestClass:(Class)class processBlock:(OCFWebServerProcessBlock)block {
  if ([path hasPrefix:@"/"] && [class isSubclassOfClass:[OCFWebServerRequest class]]) {
    [self addHandlerWithMatchBlock:^OCFWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
      
      if (![requestMethod isEqualToString:method]) {
        return nil;
      }
      if ([urlPath caseInsensitiveCompare:path] != NSOrderedSame) {
        return nil;
      }
      return [[class alloc] initWithMethod:requestMethod URL:requestURL headers:requestHeaders path:urlPath query:urlQuery];
      
    } processBlock:block];
  } else {
    DNOT_REACHED();
  }
}

- (void)addHandlerForMethod:(NSString*)method pathRegex:(NSString*)regex requestClass:(Class)class processBlock:(OCFWebServerProcessBlock)block {
  NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:NULL];
  if (expression && [class isSubclassOfClass:[OCFWebServerRequest class]]) {
    [self addHandlerWithMatchBlock:^OCFWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
      
      if (![requestMethod isEqualToString:method]) {
        return nil;
      }
      if ([expression firstMatchInString:urlPath options:0 range:NSMakeRange(0, urlPath.length)] == nil) {
        return nil;
      }
      return [[class alloc] initWithMethod:requestMethod URL:requestURL headers:requestHeaders path:urlPath query:urlQuery];
      
    } processBlock:block];
  } else {
    DNOT_REACHED();
  }
}

@end
