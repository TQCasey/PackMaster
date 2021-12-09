package org.cocos2dx.lib;

import java.lang.reflect.Method;
import java.net.URI;
import java.net.URLEncoder;

import org.cocos2dx.lua.AppActivity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

public class Cocos2dxWebView extends WebView {

    private static final String TAG = Cocos2dxWebViewHelper.class.getSimpleName();
    private int mViewTag;
    private String mJSScheme;
    private WebHandler mWebHandler;
    private boolean isListenKeyPad = false;

    FrameLayout.LayoutParams frameLayoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,
        FrameLayout.LayoutParams.WRAP_CONTENT);

    public Cocos2dxWebView(Context context) {
                this(context, -1);
            }

    @SuppressLint("SetJavaScriptEnabled")
    public Cocos2dxWebView(Context context, int viewTag) {
        super(context);
        listenKeyPad();
        this.mViewTag = viewTag;
        this.mJSScheme = "";
        this.setBackgroundColor(0);
        this.setFocusable(true);
        this.setFocusableInTouchMode(true);

        this.setVerticalScrollBarEnabled(false);
        this.setHorizontalScrollBarEnabled(false);

        this.getSettings().setSupportZoom(false);
        this.getSettings().setJavaScriptEnabled(true);

        this.getSettings().setDomStorageEnabled(true);      //是否开启本地DOM存储
    //    this.getSettings().setUseWideViewPort(true);        //设置Webivew支持标签的viewport属性
    //  this.getSettings().setLoadWithOverviewMode(true);   //设置Webivew网页自适应

        mWebHandler = new WebHandler(AppActivity.mActivity, this);
        mWebHandler.addJSInterface();

        // `searchBoxJavaBridge_` has big security risk. http://jvn.jp/en/jp/JVN53768697
        try {
            Method method = this.getClass().getMethod("removeJavascriptInterface", new Class[]{String.class});
            method.invoke(this, "searchBoxJavaBridge_");
        } catch (Exception e) {
            Log.d(TAG, "This API level do not support `removeJavascriptInterface`");
        }

        this.setWebViewClient(new Cocos2dxWebViewClient());
        this.setWebChromeClient(new WebChromeClient());
    }

    public void setJavascriptInterfaceScheme(String scheme) {
        this.mJSScheme = scheme != null ? scheme : "";
    }

    public void callJsFunction(String funcName,  String param) {
    	mWebHandler.doJsFuction(funcName, param);
    }

    public void callNativeFunction(String funcName,  String param) {
        switch (funcName){
            case "listen keypad":
                isListenKeyPad = true;
                break;
            default:
                break;
        }
    }

    public void setScalesPageToFit(boolean scalesPageToFit) {
        this.getSettings().setSupportZoom(scalesPageToFit);
    }

    class Cocos2dxWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String urlString) {
            /*
             * 2018 / 11 / 29 casey
             * fix crash Illegal character in query at index 80 
             */

            //urlString = "https://track.mialltrack.com/aff_c?aid=986501&oid=422545&source=alfa_14&aff_sub={click_id}";

            String rstr = urlString;//URLEncoder.encode(urlString);
            URI uri = null;
            try {
                uri = URI.create(rstr);
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (uri != null) {
                String sche = uri.getScheme();
                if (sche != null) {
                    if (sche.equals(mJSScheme)) {

                        Cocos2dxWebViewHelper._onJsCallback(mViewTag, rstr);
                        return true;

                    } else if (sche.equals("gojek")) {

                        /* 2018 / 11 / 29 casey
                         * fix crash , can not find ident for activity
                         */
                        try {
                            Intent intent = new Intent(Intent.ACTION_VIEW);
                            intent.setData(Uri.parse(rstr));
                            AppActivity.mActivity.startActivity(intent);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        /*
                         * even error occurred , return true finaly
                         */
                        return true;
                     } else if (sche.equals("sms")) {

                        /* 2019 / 8 / 13 author
                         * add sms for pay
                         */
                        try {
                            Intent intent = new Intent(Intent.ACTION_VIEW);
                            intent.setType("vnd.android-dir/mms-sms");
                            intent.setData(Uri.parse(rstr));
                            AppActivity.mActivity.startActivity(intent);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        /*
                         * even error occurred , return true finaly
                         */
                        return true;
                    } else if (urlString.startsWith("https://web-pay.line.me")) {

                        /* 2019 / 8 / 30 author
                         * add intent for pay
                         */
                        try {
                            Intent intent = new Intent(Intent.ACTION_VIEW);
                            intent.setData(Uri.parse(rstr));
                            AppActivity.mActivity.startActivity(intent);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        /*
                         * even error occurred , return true finaly
                         */
                        return true;
                    }
                }

            }
            return Cocos2dxWebViewHelper._shouldStartLoading(mViewTag, rstr);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
        	super.onPageStarted(view, url, favicon);
        	Cocos2dxWebViewHelper._shouldStartLoading(mViewTag, url);
        }
        
        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            Cocos2dxWebViewHelper._didFinishLoading(mViewTag, url);
        }

        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            super.onReceivedError(view, errorCode, description, failingUrl);
            Cocos2dxWebViewHelper._didFailLoading(mViewTag, failingUrl);
        }
        
        @Override
        public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error){
        	//handler.cancel(); 默认的处理方式，WebView变成空白页
        	//handler.proceed(); //接受证书
        	//handleMessage(Message msg); 其他处理
        }
    }
    
    public void setWebViewRect(int left, int top, int maxWidth, int maxHeight) {

        frameLayoutParams.leftMargin = left;
        frameLayoutParams.topMargin = top;
        frameLayoutParams.width = maxWidth;
        frameLayoutParams.height = maxHeight;
        frameLayoutParams.gravity = Gravity.TOP | Gravity.LEFT;
        this.setLayoutParams(frameLayoutParams);
    }

    private int usableHeightPrevious;
    //修复Android issue #5497
    private void listenKeyPad() {
        getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                possiblyResizeChildOfContent();
            }
        });
    }

    private void possiblyResizeChildOfContent() {
        if (!isListenKeyPad) return ;
        int usableHeightNow = computeUsableHeight();
        if (usableHeightNow != usableHeightPrevious && frameLayoutParams.height > 0) {
            int usableHeightSansKeyboard = getRootView().getHeight();
            int heightDifference = usableHeightSansKeyboard - usableHeightNow;
            if (heightDifference > (usableHeightSansKeyboard/4)) {
                // keyboard probably just became visible
                frameLayoutParams.height = usableHeightSansKeyboard - heightDifference;
            } else {
                // keyboard probably just became hidden
                frameLayoutParams.height = usableHeightSansKeyboard;
            }
            requestLayout();
            usableHeightPrevious = usableHeightNow;
        }
    }

    private int computeUsableHeight() {
        Rect r = new Rect();
        getWindowVisibleDisplayFrame(r);
        return (r.bottom - r.top);// 全屏模式下： return r.bottom
    }
}
