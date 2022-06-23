
#import "FileDownLoader.h"
#import "CCLuaBridge.h"
#import <CommonCrypto/CommonDigest.h>

#import "zip/SSZipArchive.h"

enum {
    ITEM_FREE,
    ITEM_DOWNLOADING,
    ITEM_DONE,
};

// ============================================================================
// Item Class
// ============================================================================
@interface FileItem : NSObject
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* md5;
@property (nonatomic, copy) NSString* cachePath;
@property (nonatomic) int time;
@property (nonatomic) int tmo;
@property (nonatomic) int state;
@property (nonatomic, strong) NSMutableArray *callbacks;

-(int) checkState;
-(FileItem*)initData:(NSString *)url tmo:(int)tmo;
- (NSString *)md5:(NSString *)string ;
@end

@implementation FileItem
-(int) checkState {
    if (cocos2d::FileUtils::getInstance()->isFileExist([self.cachePath UTF8String])) {
        NSLog (@"image already exist %@",self.cachePath);
        return ITEM_DONE;
    }
    
    return ITEM_FREE;
}

- (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

-(FileItem*)initData:(NSString *)url cachePath:(NSString*)cachePath tmo:(int)tmo {
    
    self.url = url;
    self.cachePath = cachePath;
    self.callbacks = [[NSMutableArray alloc] init];
    self.time = 0;
    self.tmo = tmo;
    self.md5 = [self md5:url];
    self.state = [self checkState];
    
    return self;
}

-(void) dealloc {
    [super dealloc];
    [self.callbacks release];
}
@end

// ============================================================================
// FileDownLoader Class
// ============================================================================

@implementation FileDownLoader
NSMutableDictionary *url_map;

+ (FileDownLoader*)manager
{
    static FileDownLoader* instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

-(id) init{
    self = [super init];
    self.mItemMap = [[NSMutableDictionary alloc] init];
    return self;
}

-(void)notifyItemCallers:(FileItem *) item url:(NSString*)url path:(NSString *)path {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0 ; i < item.callbacks.count ; i ++ ){
            int funcId = [item.callbacks [i] intValue];
            if (funcId >= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cocos2d::LuaValueDict dict;
                    cocos2d::LuaBridge::pushLuaFunctionById(funcId);
                    dict["url"] = cocos2d::LuaValue::stringValue([url UTF8String]);
                    dict["isok"] = cocos2d::LuaValue::booleanValue (item.state == ITEM_DONE);
                    dict["path"] = cocos2d::LuaValue::stringValue([path UTF8String]);
                    cocos2d::LuaBridge::getStack()->pushLuaValueDict(dict);
                    cocos2d::LuaBridge::getStack()->executeFunction(1);
                    cocos2d::LuaBridge::releaseLuaFunctionById(funcId);
                });
            }
        }
    });
}

-(void)addToDownloader:(NSDictionary *)dict {
    
    NSString * url = [dict objectForKey:@"url"];
    NSString *path = [dict objectForKey:@"path"];
    int tmo = [[dict objectForKey:@"tmo"] intValue];
    int luaCallFuncId = [[dict valueForKey:@"callback"]intValue];
    
    if (!url || url.length <= 0 || !path || path.length <= 0) {
        return ;
    }
    
    FileItem *item = [self.mItemMap objectForKey:url];
    if (item == NULL) {
        
        // new fresh item
        item = [[FileItem alloc] initData:url cachePath:path tmo:tmo];
        
        // insert to mItemMap
        [self.mItemMap setValue:item forKey:url];
    }
    
    if (item.state == ITEM_DOWNLOADING) {
        // add to downloading queue
        [item.callbacks addObject:[NSString stringWithFormat:@"%d",luaCallFuncId]];
        NSLog (@"Download busy url %@",url);
    } else {
        NSLog (@"Download start url %@",url);
        // start to download
        if (item.cachePath.length <= 0) {
            return ;
        }
        // add to callbacks
        [item.callbacks addObject:[NSString stringWithFormat:@"%d",luaCallFuncId]];
        item.state = ITEM_DOWNLOADING;
        
        NSURL *ns_url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:ns_url];
        
        @try{
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSString *path = @"";
                if (!error) {
                    
                    // make dirs
                    NSFileManager *manager = [NSFileManager defaultManager];
                    
                    NSArray *pathArr = [item.cachePath pathComponents];
                    NSArray *startOfPath = [pathArr subarrayWithRange:NSMakeRange(0, [pathArr count] - 1)];
                    NSString *dirname = [NSString pathWithComponents:startOfPath]; // /a/b/c
                    
                    if (![manager fileExistsAtPath:dirname]) {
                        [manager createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    [data writeToFile:item.cachePath atomically:YES];
                    NSLog(@"Download OK : %@",item.cachePath);
                    path = item.cachePath;
                    
                    // all happy
                    item.state = ITEM_DONE;
                    
                    //
                    // additional operation
                    // note that if we failed with unzipping file
                    // we still mark the isOK be true
                    // 2022/6/22 casey
                    //
                    if ([item.cachePath hasSuffix:@".zip"]) {
                        NSLog(@"UNzip %@ to %@",item.cachePath,dirname);
                        BOOL isSuccess = [SSZipArchive unzipFileAtPath:item.cachePath toDestination:dirname progressHandler : ^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                            
                        } completionHandler:^(NSString *path, BOOL succeeded, NSError * _Nullable error) {
                            if (NO == succeeded) {
                            }
                        }];
                    }
                    
                    // if we failed with unzippping file , we still need to notify the callers succeed
                    
                } else {
                    item.state = ITEM_FREE;
                }
                
                // notify the callers
                [self notifyItemCallers:item url:url path:path];
                
            }];
            
            [dataTask resume];
        } @catch (NSException *e) {
            NSLog(@"%@",e);
            
            // notify the callers
            item.state = ITEM_FREE;
            [self notifyItemCallers:item url:url path:path];
        }
    }
}

-(void)dealloc{
    [super dealloc];
    [self.mItemMap release];
}

@end
