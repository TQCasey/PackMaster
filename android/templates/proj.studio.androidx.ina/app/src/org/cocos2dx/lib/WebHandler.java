package org.cocos2dx.lib;

import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.Toast;

/**
 * webview处理类
 * @author JasonWang
 */
public class WebHandler {

	public static final String INTERFACE_TAG = "df_interface";
	public static final int CMD_GET_USERDATA			= 1001; //获取用户资料
	public static final int CMD_SEND_DOWNLOAD			= 1002; //下载
	public static final int CMD_SEND_WEB_INPUT		= 1003; //调出输入框
	public static final int CMD_WEB_GO_BACK		= 1004; //模拟返回键 如果能返回则返回，如果不能 则关闭webView
	public static final int CMD_WEB_GETINFO		= 1; //模拟返回键 如果能返回则返回，如果不能 则关闭webView
	public static final int CMD_WEB_CLOSE		= 0; //关闭webView
	
	private Context mContext;
	private Cocos2dxWebView mWebView;
	public JavaScriptInterface mJs;
	public static int luaFuncId = -1;
	public static String actInfoStr;
	
	public WebHandler(Context context, Cocos2dxWebView webView) {
		this.mContext = context;
		this.mWebView = webView;
	}

	public void setFuncId(int luaFuncId){
		WebHandler.luaFuncId = luaFuncId;
	}

	/**
	 * 调用网页内js
	 * @param funcName
	 * @param param
	 */
	public void doJsFuction(final String funcName, final String param){
		Log.i("WebHandler", "javascript:" + funcName+"("+param+")");
		if(mWebView!=null){
			WebView wv = mWebView; 
			if(wv!=null){
				AppActivity.mActivity.runOnUiThread(new Runnable() {
				    @Override
				    public void run() {
						if(TextUtils.isEmpty(param)){
							mWebView.loadUrl("javascript:" + funcName+"()");
						}else{
							mWebView.loadUrl("javascript:" + funcName+"("+param+")");
						}
				    }
				});
			}
		}
	}

	/**
	 * 向网页内添加js
	 * @param function
	 */
	public void adJsFunction(String function){
		if(mWebView!=null){
			WebView wv = mWebView;
			if(wv!=null){
				wv.loadUrl("javascript:" + function);
			}
		}
	}

	/**
	 * 获取js接口对象
	 * @return JavaScriptInterface
	 */
	public JavaScriptInterface getJSInterface(){
		if(mJs==null){
			mJs = new JavaScriptInterface();
		}
		return mJs;
	}

	/**
	 * 添加JavaScriptInterface，默认值
	 */
	public void addJSInterface(){
		if(mJs==null){
			mJs = new JavaScriptInterface();
		}
		addJSInterface(mJs, INTERFACE_TAG);
	}

	/**
	 * 自定义添加JavaScriptInterface
	 * @param jsObject js接口对象对象
	 * @param jsName
	 */
	public void addJSInterface(Object jsObject, String jsName){
		if(mWebView!=null){
			WebView wv = mWebView;
			if(wv!=null){
				wv.addJavascriptInterface(jsObject, jsName);
			}
		}
	}

	public void endJSInterface(){

	}

	/**
	 * js 通信接口
	 * @author JasonWang
	 */
	public class JavaScriptInterface{
		@JavascriptInterface
		public String getData(String json){
			try {
				JSONObject jo = new JSONObject(json);
				int cmd = jo.optInt("cmd");
				if(cmd == CMD_GET_USERDATA){
					return getUserData();
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return null;
		}
		
		@JavascriptInterface
		public void sendData(String json){
			try {
				JSONObject jo = new JSONObject(json);
				int cmd = jo.optInt("cmd");

				Log.d("wanpg", "收到js回调："+cmd);
				switch (cmd) {
				case CMD_SEND_DOWNLOAD:
					go2Download(jo.optString("url"));
					break;
					
				case CMD_SEND_WEB_INPUT:
					showEditView(jo);
					break;
					
				case CMD_WEB_GO_BACK:
					doWebViewBack();
					break;
					
				case CMD_WEB_GETINFO:
					if (actInfoStr != null) {
						doJsFuction("mb2js", actInfoStr);
					} else
						send2Lua(json);
					break;
										
				default:
					send2Lua(json);
					break;
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	}

	//一下为私有方法进行数据处理
	/**
	 * 获取用户信息
	 * @return String
	 * 	{"mid":1,"money":800,"platformid":"xxxxx","deviceid":"dfsddsdfd","macaddr":"aa:bb:cc:dd:ee:ff","version":"1.0.0"}
	 */
	private String getUserData(){
		try {
			JSONObject jo = new JSONObject();
			jo.put("platformid", 1);
			return jo.toString();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return "";
	}


//	private DownloadHandler mDownloadHandler;
	/**
	 * 去下载
	 * @param url
	 */
	@JavascriptInterface
	private void go2Download(String url){
//		if(mDownloadHandler==null)
//			mDownloadHandler = new DownloadHandler(mContext);
//		mDownloadHandler.startDownload(url);
		Log.i("WebHandler", "go2Download");
	}
	
	@JavascriptInterface
	private void doWebViewBack() {
		Log.i("WebHandler", "doWebViewBack");
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				if (mWebView != null ) return;
				if (mWebView.canGoBack())
					mWebView.goBack();
				else
					;
			}
		});
	}

	@JavascriptInterface
	private void send2Lua(final String json) {
		if(json==null)
			return ;
		AppActivity.mActivity.runOnGLThread(new Runnable() {
            @Override
            public void run() {
            	if (luaFuncId>0)
	                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId, json);
            }
		});
	}
	

	private void showEditView(JSONObject jo) {
		final String cbFuncName = jo.optString("cb_func");
		String str = jo.optString("value");
		if("null".equals(str)){
			str = "";
		}
		new WebInputDialog(mContext, new WebInputDialog.WebInputDialogCallBack() {
			
			@Override
			public void onCallBack(final String string) {
				WebView wv = mWebView;
				if(wv!=null){
					wv.getHandler().post(new Runnable() {
						
						@Override
						public void run() {
							doJsFuction(cbFuncName, string);
						}
					});
				}
			}
		}).showDialog(str);
	}
}
