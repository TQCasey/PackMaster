//声明了一个下载成功的block类型
typedef void (^onImageDownLoadFinish) (int);

@interface FileDownLoader : NSObject {
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
+ (FileDownLoader*)manager;
-(void)addToDownloader:(NSDictionary *)dict ;

@end
