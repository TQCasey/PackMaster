
/**
 * @c MSWebView
 * This class is a wrapper class for @c WKWebView. @c MSWebView blocks all JavaScript text boxes from appearing.
 *
 * It's highly recommended that the caller uses @c `evaluateJavaScript:completionHandler:` whenever code can be reworked
 * to make use of completion blocks to keep the advantages of asynchronicity. It solely fires off the javascript execution within
 * @c WKWebView and does not wait or return.
 *
 * MSWebView currently does not support a few other features of WKWebView, such as pagination -- as WKWebView.
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class MSWebView;

@protocol MSWebViewDelegate <NSObject>

@optional

- (BOOL)webView:(MSWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(WKNavigationType)navigationType;

- (void)webViewDidStartLoad:(MSWebView *)webView;

- (void)webViewDidFinishLoad:(MSWebView *)webView;

- (void)webView:(MSWebView *)webView
didFailLoadWithError:(NSError *)error;

@end

typedef void (^MSWebViewJavascriptEvaluationCompletionHandler)(id result, NSError *error);

@interface MSWebView : UIView

@property (weak, nonatomic) id<MSWebViewDelegate> delegate;

// When set to `YES`, `shouldConformToSafeArea` sets constraints on the WKWebView to always stay within the safe area
// using the MSWebView's safeAreaLayoutGuide. Otherwise, the WKWebView will be constrained directly to MSWebView's
// anchors to fill the whole container. Default is `NO`.
//
// This property has no effect on versions of iOS less than 11 or phones other than iPhone X.
@property (nonatomic, assign) BOOL shouldConformToSafeArea;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;

- (void)loadData:(NSData *)data
        MIMEType:(NSString *)MIMEType
textEncodingName:(NSString *)encodingName
         baseURL:(NSURL *)baseURL;

@property (nonatomic) BOOL allowsLinkPreview;
@property (nonatomic, readonly) BOOL allowsPictureInPictureMediaPlayback;

- (void)loadHTMLString:(NSString *)string
               baseURL:(NSURL *)baseURL;

- (void)loadRequest:(NSURLRequest *)request;
- (void)stopLoading;
- (void)reload;

@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;
- (void)goBack;
- (void)goForward;

@property (nonatomic) BOOL scalesPageToFit;
@property (nonatomic, readonly) UIScrollView *scrollView;

- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(MSWebViewJavascriptEvaluationCompletionHandler)completionHandler;

// When using WKWebView, always returns @"" and solely fires the javascript execution without waiting on it.
// If you need a guaranteed return value from `stringByEvaluatingJavaScriptFromString:`, please use
// `evaluateJavaScript:completionHandler:` instead.
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString;

@property (nonatomic, readonly) BOOL allowsInlineMediaPlayback;
@property (nonatomic, readonly) BOOL mediaPlaybackRequiresUserAction;
@property (nonatomic, readonly) BOOL mediaPlaybackAllowsAirPlay;

- (void)mp_setScrollable:(BOOL)scrollable;

@end
