
#import "ImageDownLoader.h"
#import "CCLuaBridge.h"
#import <CommonCrypto/CommonDigest.h>

enum {
    ITEM_FREE,
    ITEM_DOWNLOADING,
    ITEM_DONE,
};

// ============================================================================
// Item Class
// ============================================================================
@interface Item : NSObject
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* md5;
@property (nonatomic, copy) NSString* cachePath;
@property (nonatomic) int time;
@property (nonatomic) int tmo;
@property (nonatomic) int state;
@property (nonatomic, strong) NSMutableArray *callbacks;

-(int) checkState;
-(Item*)initData:(NSString *)url tmo:(int)tmo;
- (NSString *)md5:(NSString *)string ;
@end

@implementation Item
-(int) checkState {
    
    std::string imgPath = cocos2d::FileUtils::getInstance()->getWritablePath() + "/image/" + [self.md5 UTF8String] + ".png";
    self.cachePath = [NSString stringWithFormat:@"%s",imgPath.c_str()];
    
    if (!cocos2d::FileUtils::getInstance()->isDirectoryExist(cocos2d::FileUtils::getInstance()->getWritablePath() + "/image/")) {
        cocos2d::FileUtils::getInstance()->createDirectory(cocos2d::FileUtils::getInstance()->getWritablePath() + "/image/");
    }
    
    if (cocos2d::FileUtils::getInstance()->isFileExist(imgPath)) {
//        NSLog (@"image already exist %@",self.cachePath);
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

-(Item*)initData:(NSString *)url tmo:(int)tmo {
    
    self.url = url;
    self.cachePath = @"";
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
// ImageDownLoader Class
// ============================================================================

@implementation ImageDownLoader
NSMutableDictionary *url_map;

+ (ImageDownLoader*)manager
{
    static ImageDownLoader* instance = nil;
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

-(void)requestImageUrl:(NSString *)imageUrl path:(NSString *)path cbId:(int)cbId callback:(onImageDownLoadFinish)callback {
    self.callback = callback;
    self.imageUrl = [imageUrl copy];
    self.savePath = [path copy];

    // 创建URL对象
    NSURL *url = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // 创建request对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak ImageDownLoader* weakSelf = self;
    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 如果请求到数据
        if (data) {
            // 下载完成，将图片保存到本地
            [data writeToFile:self.savePath atomically:YES];
            weakSelf.callback(cbId);
        }
//        [self autorelease];
    }];
}


// =======================================================
// downloader
// =======================================================
-(void)setDownloaderConfig:(NSDictionary *)dict {
//    NSLog(@"setDownloaderConfig ()");
}

- (NSString *)contentTypeForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

-(void)addToDownloader:(NSDictionary *)dict {
//    NSLog(@"addToDownloader ()");
    
    NSString * url = [dict objectForKey:@"url"];
    int tmo = [[dict objectForKey:@"tmo"] intValue];
    int luaCallFuncId = [[dict valueForKey:@"callback"]intValue];
    
    if (!url || url.length < 0) {
        return ;
    }
    
    Item *item = [self.mItemMap objectForKey:url];
    if (item == NULL) {
        
        // new fresh item
        item = [[Item alloc] initData:url tmo:tmo];
        
        // insert to mItemMap
        [self.mItemMap setValue:item forKey:url];
//        NSLog (@"Download New Fish for %@",url);
    } else {
        // old fish
//        NSLog (@"Download Old Fish for %@",url);
    }
    
    if (item.state == ITEM_DONE) {
        // callback item
        if (luaCallFuncId >= 0) {
//            NSLog(@"Download done for url %@",url);
            dispatch_async(dispatch_get_main_queue(), ^{
                cocos2d::LuaBridge::pushLuaFunctionById(luaCallFuncId);
                cocos2d::LuaValueDict dict;
                dict["url"] = cocos2d::LuaValue::stringValue([url UTF8String]);
                dict["path"] = cocos2d::LuaValue::stringValue([item.cachePath UTF8String]);
                cocos2d::LuaBridge::getStack()->pushLuaValueDict(dict);
                cocos2d::LuaBridge::getStack()->executeFunction(1);
                cocos2d::LuaBridge::releaseLuaFunctionById(luaCallFuncId);
            });
        }
    } else {
        if (item.state == ITEM_DOWNLOADING) {
            // add to downloading queue
            [item.callbacks addObject:[NSString stringWithFormat:@"%d",luaCallFuncId]];
//            NSLog (@"Download busy url %@",url);
        } else {
//            NSLog(@"Download start url %@",url);
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
                        // check if the filecontent is PNG or JPEG data etc or not
                        NSString *fmt = [self contentTypeForImageData:data];
                        if (fmt && fmt.length > 0) {
                            [data writeToFile:item.cachePath atomically:YES];
//                            NSLog(@"Download OK : %@",item.cachePath);
                            path = item.cachePath;
                            // all happy
                            item.state = ITEM_DONE;
                        } else {
                            // still mark it as failed
                            item.state = ITEM_FREE;
                        }
                    } else {
                        // anyway when we faild to download image
                        // we still need to notify the callers however
                        // we need set the item.state to free
                        // for that we need re-download later ..
                        //                         2019/8/14 casey
                        item.state = ITEM_FREE;
                    }
                    
                    if (item.state == ITEM_FREE) {
//                        NSLog(@"Download failed");
                    }
                    
                    // notify the callers
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (int i = 0 ; i < item.callbacks.count ; i ++ ){
                            int funcId = [item.callbacks [i] intValue];
                            if (funcId >= 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    cocos2d::LuaValueDict dict;
                                    cocos2d::LuaBridge::pushLuaFunctionById(funcId);
                                    dict["url"] = cocos2d::LuaValue::stringValue([url UTF8String]);
                                    dict["path"] = cocos2d::LuaValue::stringValue([path UTF8String]);
                                    cocos2d::LuaBridge::getStack()->pushLuaValueDict(dict);
                                    cocos2d::LuaBridge::getStack()->executeFunction(1);
                                    cocos2d::LuaBridge::releaseLuaFunctionById(funcId);
                                });
                            }
                        }
                    });
                    
                }];
                
                [dataTask resume];
            } @catch (NSException *e) {
                NSLog(@"%@",e);
            }
        }
    }
}

-(NSString *) getCachedImage:(NSDictionary *) dict {

    NSString * url = [dict objectForKey:@"url"];
    
    if (!url || url.length < 0) {
        return @"";
    }
    
    Item *item = [self.mItemMap objectForKey:url];
    if (item == NULL) {
        
        // new fresh item
        item = [[Item alloc] initData:url tmo:10];
        
        // insert to mItemMap
        [self.mItemMap setValue:item forKey:url];
    } else {
        // old fish
    }
    
    if (item.state == ITEM_DONE) {
        return item.cachePath;
    }
    
    return @"";
}

-(void) clearCachedImage:(NSDictionary *) dict {
    
    NSString *url = [dict objectForKey:@"url"];
    if (!url || url.length < 0) {
        return ;
    }
    
    Item *item = [self.mItemMap objectForKey:url];
    if (item == NULL) {
        
        // new fresh item
        item = [[Item alloc] initData:url tmo:10];
        
        // insert to mItemMap
        [self.mItemMap setValue:item forKey:url];
    } else {
        // old fish
    }
    
    if (item.state == ITEM_DONE || item.state == ITEM_FREE) {
        
        // remove file
        if (cocos2d::FileUtils::getInstance()->isFileExist([item.cachePath UTF8String])) {
            cocos2d::FileUtils::getInstance()->removeFile([item.cachePath UTF8String]);
            
            // remove ItemMap url
            [self.mItemMap removeObjectForKey:url];
//            NSLog (@"===========> %@",self.mItemMap);
        }
    } else {
        // if it is downloading , do nothing
    }
}

-(void)dealloc{
    [super dealloc];
    [self.mItemMap release];
}

@end
