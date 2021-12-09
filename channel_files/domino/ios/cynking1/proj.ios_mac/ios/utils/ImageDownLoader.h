//声明了一个下载成功的block类型
typedef void (^onImageDownLoadFinish) (int);

@interface ImageDownLoader : NSObject {
}
@property (nonatomic, copy) onImageDownLoadFinish callback;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString* savePath;
@property (nonatomic, strong) NSMutableDictionary *mItemMap;

//声明一个block传值的请求方法
/*
参数解释：
imageUrl：图片的地址；
callback: 当请求完进行回调；
*/
+ (ImageDownLoader*)manager;

-(void)requestImageUrl:(NSString *)imageUrl path:(NSString *)path cbId:(int)cbId callback:(onImageDownLoadFinish)callback;
-(void)setDownloaderConfig:(NSDictionary *)dict ;
-(void)addToDownloader:(NSDictionary *)dict ;
-(NSString *) getCachedImage:(NSDictionary *) dict;
-(void) clearCachedImage:(NSDictionary *) dict ;

@end
