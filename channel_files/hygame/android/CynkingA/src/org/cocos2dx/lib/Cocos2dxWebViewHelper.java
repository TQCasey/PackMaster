package org.cocos2dx.lib;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.SparseArray;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.widget.Button;
import android.widget.FrameLayout;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;

import com.chukong.cocosplay.client.CocosPlayClient;
import com.cynking.capsa.R;

public class Cocos2dxWebViewHelper {
    private static final String TAG = Cocos2dxWebViewHelper.class.getSimpleName();
    private static Handler sHandler;
    private static Cocos2dxActivity sCocos2dxActivity;
    private static FrameLayout sLayout;

    private static SparseArray<Cocos2dxWebView> webViews;
    private static SparseArray<Button> closeBtns;
    private static SparseArray<Button> freshBtns;
    private static int viewTag = 0;

    public Cocos2dxWebViewHelper(FrameLayout layout) {
        Cocos2dxWebViewHelper.sLayout = layout;
        Cocos2dxWebViewHelper.sHandler = new Handler(Looper.myLooper());

        Cocos2dxWebViewHelper.sCocos2dxActivity = (Cocos2dxActivity) Cocos2dxActivity.getContext();
        Cocos2dxWebViewHelper.webViews = new SparseArray<Cocos2dxWebView>();
        Cocos2dxWebViewHelper.closeBtns = new SparseArray<Button>();
        Cocos2dxWebViewHelper.freshBtns = new SparseArray<Button>();
    }

    private static native boolean shouldStartLoading(int index, String message);

    public static boolean _shouldStartLoading(final int index, final String message) {
    	Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
	    	@Override
	    	public void run() {
	    		shouldStartLoading(index, message);
	    	}
	    });
    	return false;
    }

    private static native void didFinishLoading(int index, String message);

    public static void _didFinishLoading(final int index, final String message) {
	    Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
	    	@Override
	    	public void run() {
	    		didFinishLoading(index, message);
	    	}
	    });
    }

    private static native void didFailLoading(int index, String message);

    public static void _didFailLoading(final int index, final String message) {
    	Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
	    	@Override
	    	public void run() {
	    		didFailLoading(index, message);
	    	}
	    });
    }

    private static native void onJsCallback(int index, String message);

    public static void _onJsCallback(int index, String message) {
        onJsCallback(index, message);
    }
    
    private static native void onCloseBtnCallback(int index);

    public static void _onCloseBtnCallback(final int index) {
    	Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
	    	@Override
	    	public void run() {
	    		onCloseBtnCallback(index);
	    	}
	    });
    }

    public static int createWebView() {
        final int index = viewTag;
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = new Cocos2dxWebView(sCocos2dxActivity, index);
                FrameLayout.LayoutParams lParams = new FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.WRAP_CONTENT,
                        FrameLayout.LayoutParams.WRAP_CONTENT);
                sLayout.addView(webView, lParams);

                webViews.put(index, webView);
            }
        });

        return viewTag++;
    }

    public static void removeWebView(final int index) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webViews.remove(index);
                    sLayout.removeView(webView);
                }
                Button cbtn = closeBtns.get(index);
                if (cbtn != null) {
                	closeBtns.remove(index);
                    sLayout.removeView(cbtn);
                }
                Button fbtn = freshBtns.get(index);
                if (fbtn != null) {
                	freshBtns.remove(index);
                    sLayout.removeView(fbtn);
                }
            }
        });
    }
    
    public static void createButtons(final int index, final int cType) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                int screenHeight = getDisplayScreenResolution();
                int marginLen = 5*screenHeight/640; 
                
                System.out.println("screenHeight : " + screenHeight);
                Button closeButton = new Button(sCocos2dxActivity);  
        		int btnHeight; 
                FrameLayout.LayoutParams layoutParams;
                if(cType == 2){
                	btnHeight = 90*screenHeight/640; 
                	layoutParams = new FrameLayout.LayoutParams(btnHeight,btnHeight);
                    layoutParams.rightMargin = marginLen;
                    layoutParams.topMargin = marginLen;
                    layoutParams.gravity = Gravity.TOP | Gravity.RIGHT;
                	closeButton.setBackgroundResource(R.drawable.zf_web_close_nor);
                }else{
                	btnHeight = 70*screenHeight/640;
                	layoutParams = new FrameLayout.LayoutParams(btnHeight,btnHeight);
                    layoutParams.leftMargin = 18*screenHeight/640;
                    layoutParams.topMargin = 15*screenHeight/640;
                    layoutParams.gravity = Gravity.TOP | Gravity.LEFT;
                	closeButton.setBackgroundResource(R.drawable.webview_back_nor);
                }
                closeBtns.put(index, closeButton);
                sLayout.addView(closeButton, layoutParams);

                if(cType != 2){
	                closeButton.setOnTouchListener(new OnTouchListener() {        
	                    @SuppressLint("ClickableViewAccessibility")
						@Override  
	                    public boolean onTouch(View v, MotionEvent event) {  
	                        if(event.getAction()==MotionEvent.ACTION_DOWN){  
	                            v.setBackgroundResource(R.drawable.webview_back_pre);  
	                        }else if(event.getAction()==MotionEvent.ACTION_UP){  
	                            v.setBackgroundResource(R.drawable.webview_back_nor);  
	                        }  
	                        return false;  
	                    }  
	                });
                }
                closeButton.setOnClickListener(new OnClickListener() {  
                    @Override
                    public void onClick(View v) {  
                    	_onCloseBtnCallback(index);
                    }  
                });  
            }
        });
    }

    public static void setVisible(final int index, final boolean visible) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.setVisibility(visible ? View.VISIBLE : View.GONE);
					
					if (visible == false) {
						webView.stopLoading ();
					}
                }
                Button cbtn = closeBtns.get(index);
                if (cbtn != null) {
                	cbtn.setVisibility(visible ? View.VISIBLE : View.GONE);
                }
                Button fbtn = freshBtns.get(index);
                if (fbtn != null) {
                	fbtn.setVisibility(visible ? View.VISIBLE : View.GONE);
                }
            }
        });
    }

    public static void setWebViewRect(final int index, final int left, final int top, final int maxWidth, final int maxHeight) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.setWebViewRect(left, top, maxWidth, maxHeight);
                }
            }
        });
    }

    public static void setJavascriptInterfaceScheme(final int index, final String scheme) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.setJavascriptInterfaceScheme(scheme);
                }
            }
        });
    }

    public static void callJsFunction(final int index, final String funcName, final String param) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.callJsFunction(funcName, param);
                }
            }
        });
    }

    public static void callNativeFunction(final int index, final String funcName, final String param) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.callNativeFunction(funcName, param);
                }
            }
        });
    }

    public static void loadData(final int index, final String data, final String mimeType, final String encoding, final String baseURL) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null && webView.getVisibility() == View.VISIBLE) {
                	webView.loadDataWithBaseURL(baseURL, data, mimeType, encoding, null);
                }
            }
        });
    }

    public static void loadHTMLString(final int index, final String data, final String baseUrl) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
//                	webView.loadDataWithBaseURL(baseUrl, data, null, null, null);
//                	webView.postUrl(baseUrl, EncodingUtils.getBytes(data, "BASE64"));
                	webView.postUrl(baseUrl, data.getBytes());
                }
            }
        });
    }

    public static void loadUrl(final int index, final String url) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    
                    if(url.contains("dlpq77dev.com")) {
                        // description: 外接老虎机全屏适配

                        // 1.设置用户代理
                        String DESKTOP_USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36";
                        webView.getSettings().setUserAgentString(DESKTOP_USER_AGENT);

                        // 2. 设置Webivew支持标签的viewport属性
                        // Sets whether the WebView should enable support for the "viewport" HTML meta tag or should use a wide viewport.
                        // When the value of the setting is false, the layout width is always set to the width of the WebView control in device-independent (CSS) pixels.
                        // When the value is true and the page contains the viewport meta tag, the value of the width specified in the tag is used.
                        // If the page does not contain the tag or does not provide a width, then a wide viewport will be used.
                        webView.getSettings().setUseWideViewPort(true);

                        // 3.设置Webivew网页宽度自适应
                        // Sets whether the WebView loads pages in overview mode, that is, zooms out the content to fit on screen by width.
                        // This setting is taken into account when the content width is greater than the width of the WebView control,
                        // for example, when getUseWideViewPort() is enabled.
                        webView.getSettings().setLoadWithOverviewMode(true);
                    }

                    webView.loadUrl(url);
                }
            }
        });
    }

    public static void loadFile(final int index, final String filePath) {
        if (CocosPlayClient.isEnabled() && !CocosPlayClient.isDemo()) {
            CocosPlayClient.updateAssets(filePath);
        }
        CocosPlayClient.notifyFileLoaded(filePath);
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.loadUrl(filePath);
                }
            }
        });
    }

    public static void stopLoading(final int index) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.stopLoading();
                }
            }
        });

    }

    public static void reload(final int index) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.reload();
                }
            }
        });
    }

    public static <T> T callInMainThread(Callable<T> call) throws ExecutionException, InterruptedException {
        FutureTask<T> task = new FutureTask<T>(call);
        sHandler.post(task);
        return task.get();
    }

    public static boolean canGoBack(final int index) {
        Callable<Boolean> callable = new Callable<Boolean>() {
            @Override
            public Boolean call() throws Exception {
                Cocos2dxWebView webView = webViews.get(index);
                return webView != null && webView.canGoBack();
            }
        };
        try {
            return callInMainThread(callable);
        } catch (ExecutionException e) {
            return false;
        } catch (InterruptedException e) {
            return false;
        }
    }

    public static boolean canGoForward(final int index) {
        Callable<Boolean> callable = new Callable<Boolean>() {
            @Override
            public Boolean call() throws Exception {
                Cocos2dxWebView webView = webViews.get(index);
                return webView != null && webView.canGoForward();
            }
        };
        try {
            return callInMainThread(callable);
        } catch (ExecutionException e) {
            return false;
        } catch (InterruptedException e) {
            return false;
        }
    }

    public static void goBack(final int index) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.goBack();
                }
            }
        });
    }

    public static void goForward(final int index) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.goForward();
                }
            }
        });
    }

    public static void evaluateJS(final int index, final String js) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.loadUrl("javascript:" + js);
                }
            }
        });
    }

    public static void setScalesPageToFit(final int index, final boolean scalesPageToFit) {
        sCocos2dxActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxWebView webView = webViews.get(index);
                if (webView != null) {
                    webView.setScalesPageToFit(scalesPageToFit);
                }
            }
        });
    }
    
    public static int getDisplayScreenResolution()  
    {  
//	     int ver = Build.VERSION.SDK_INT;  	  
	     DisplayMetrics dm = new DisplayMetrics();  
	     android.view.Display display = sCocos2dxActivity.getWindowManager().getDefaultDisplay();  
	     display.getMetrics(dm);  
/*	      
	     int screen_w = dm.widthPixels;  
	     int screen_h = 0;
	     Log.d(TAG, "Run1 first get resolution:"+dm.widthPixels+" * "+dm.heightPixels+", ver "+ver);  
	     if (ver < 13)  
	     {  
	    	 screen_h = dm.heightPixels;  
	     }  
	     else if (ver == 13)  
	     {  
		     try {  
		    	 Method mt = display.getClass().getMethod("getRealHeight");  
		    	 screen_h = (int) mt.invoke(display);  
		     } catch (Exception e) {  
		    	 e.printStackTrace();  
		     }  
	     }  
	     else if (ver > 13)  
	     {  
		     try {  
		    	 Method mt = display.getClass().getMethod("getRawHeight");  
		    	 screen_h = (int) mt.invoke(display);  
		      
		     } catch (Exception e) {  
		    	 e.printStackTrace();  
		     }  
	     }
*/
	     int screen_h = dm.heightPixels;
	     return screen_h;
    }  
}