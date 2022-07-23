/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
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
package org.cocos2dx.lua;

import android.Manifest;
import android.annotation.TargetApi;
import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.PowerManager;
import android.os.Process;
import android.os.RemoteException;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowManager;
import android.widget.Toast;

import android.widget.RelativeLayout;
import android.graphics.Color;
import android.view.ViewGroup;

import com.adjust.sdk.Adjust;
import com.appsflyer.AppsFlyerLib;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.cynking.capsa.R;
import com.google.firebase.iid.FirebaseInstanceId;
import com.zhijian.common.LocalPushService;
import com.zhijian.common.LoginAcitivity;
import com.zhijian.common.iap.google.GooglePay;
import com.zhijian.common.utility.AdMobileUtil;
import com.zhijian.common.utility.AppStartDialog;
import com.zhijian.common.utility.DeviceState;
import com.zhijian.common.utility.FbLoginAndShare;
import com.zhijian.common.utility.ImagePicker;
import com.zhijian.common.utility.JsonUtil;
import com.zhijian.common.utility.PermissionsChecker;
import com.zhijian.common.InstallReferrer;
import com.zhijian.common.ShareMgr;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.TreeMap;

import androidx.core.content.FileProvider;

public class AppActivity extends Cocos2dxActivity {
	public static AppActivity mActivity;
	public static AppStartDialog mStartDialog;
	private Cocos2dxGLSurfaceView glSurfaceView;

	private RelativeLayout mWhiteBoard = null;

	private PowerManager m_powerManager;
	private PowerManager.WakeLock m_wakeLock;
	public AudioManager mAudioManager;

	private int m_regIdLuaFuncId = -1;
	private int m_deepLinkFuncId = -1;
	private String m_deepLinkFuncInfo = null;
	private String mParams = "";
	private String mPushInfo = "";
	public String accessToken = "";
	private int m_inviteLuaFuncId = -1;
	private int camera_funcId = -1;
	private FirebaseAnalytics mFirebaseAnalytics;

	private int m_localPushState = 0;

	public static AppEventsLogger fblogger = null;

	// static {
	// 	System.loadLibrary("fmodL");
	// }

	/*
	 * messager
	 */
	private Messenger mBoundServiceMessenger = null;
	private boolean mServiceConnected = false;

	public static int mBangsHeight = 0;//刘海屏高度

	private ServiceConnection conn = new ServiceConnection() {
		@Override
		public void onServiceDisconnected(ComponentName name) {
			mBoundServiceMessenger = null;
			mServiceConnected = false;
		}

		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			mBoundServiceMessenger = new Messenger(service);
			mServiceConnected = true;
			syncPushStat();
		}
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mChecker = new PermissionsChecker(this);
		mActivity = this;

		//FMOD
		// org.fmod.FMOD.init(this);
		
		// put a WhiteBoard overlay layer here to cover the screen before startDiaog begin to show  
		showWhiteBoard ();

		StrictMode.VmPolicy.Builder builder1 = new StrictMode.VmPolicy.Builder();
		StrictMode.setVmPolicy(builder1.build());

		try {
			showStartDialog(true);
		} catch (Exception e) {
			handle_exception(e);
		}

		checkPushParams(getIntent().getExtras(), true);

		initFacebook();
//		initAppsFlyer();
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

		//2.Set the format of window
		// Check the wifi is opened when the native is debug.
		if (nativeIsDebug()) {
			if (!isNetworkConnected()) {
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setTitle("Warning");
				builder.setMessage("Please open WIFI for debuging...");
				builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
						finish();
						System.exit(0);
					}
				});

				builder.setNegativeButton("Cancel", null);
				builder.setCancelable(true);
				builder.show();
			}
		}

		try {
			ImagePicker.getInstance().init(this);

			GooglePay.getmInstance();
			mAudioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
			DeviceState.getInstance().Init(this);
			//InstallReferrer.getInstance().init(this);
			ShareMgr.getIntance().init(this);
		} catch (Exception e) {
			handle_exception(e);
		}
		mFirebaseAnalytics = FirebaseAnalytics.getInstance(this);
		AdMobileUtil.instance().init(this);

		final View decorView = getWindow().getDecorView();
		decorView.post(new Runnable() {
			public void run() {
				checkCutout(decorView);
			}
		});
		if (LoginAcitivity.sLoginAcitivity != null){
			try{
				LoginAcitivity.sLoginAcitivity.delSelf();
			} catch (Exception e){
				e.printStackTrace();
			}
		}
	}

	@TargetApi(28)
	public void checkCutout(View decorView) {
		if(Build.VERSION.SDK_INT < 28) return ;

		WindowInsets rootWindowInsets = decorView.getRootWindowInsets();
		if (rootWindowInsets == null) {
			return ;
		}
		DisplayCutout displayCutout = rootWindowInsets.getDisplayCutout();
		if (displayCutout == null) {
			return ;
		}
		List<Rect> rects = displayCutout.getBoundingRects();
		if (rects != null && rects.size() == 1) {
			if (rects.size() == 1) {
				for (Rect rect : rects) {
					Log.e("TAG", "刘海屏区域：" + rect);
					mBangsHeight = rect.bottom;
				}
			}
		}else{
			//没有rect或有多个rect都当做非刘海屏处理
		}
	}

    private static SimpleDateFormat format;
	public void firebaseLog(String event){
		if(format == null){
			format = new SimpleDateFormat("yyyy/MM/dd-hh:mm", Locale.getDefault());
		}
		Bundle bundle = new Bundle();
		bundle.putString("time", format.format(System.currentTimeMillis()));
		mFirebaseAnalytics.logEvent(event, bundle);
	}
	private static void handle_exception(Exception e) {
		e.printStackTrace();
	}

	public void initFacebook(){
		try {
			FbLoginAndShare.instance().init();

			if (nativeIsLandScape()) {
				setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
			} else {
				setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
			}

			// fb event
			fblogger = AppEventsLogger.newLogger(this);
			fblogger.logEvent(AppEventsConstants.EVENT_NAME_ACTIVATED_APP);            // start App

		} catch (Exception e) {
			handle_exception(e);
		}
	}

//	public void initAppsFlyer () {
//		// The Dev key cab be set here or in the manifest.xml
//		AppsFlyerLib.getInstance().startTracking(this.getApplication(), (String) mActivity.getResources().getText(R.string.appsflyer_dev_key));
//		AppsFlyerLib.getInstance().setCurrencyCode("CNY");
//	}

	private void hideSystemUI()
    {
		if(glSurfaceView == null)
			return;
    }
	
	public void showStartDialog(boolean playVideo){
		if(mStartDialog == null){
			mStartDialog = new AppStartDialog(this, nativeIsLandScape(), playVideo);
			mStartDialog.show();
		}
	}
	
	public void showWhiteBoard () {
		try {
			RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
			mWhiteBoard = new RelativeLayout(this);
			mWhiteBoard.setBackgroundColor(Color.WHITE);
			mWhiteBoard.setLayoutParams(lp);//璁剧疆甯冨眬鍙傛暟

			mWhiteBoard.bringToFront();
			mFrameLayout.addView(mWhiteBoard);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void hideWhiteBoard () {
		try {

			if (mWhiteBoard != null) {
				mWhiteBoard.setVisibility(View.INVISIBLE);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void dismissStartDialog() {
		if (null != mStartDialog) {
			if (mStartDialog.isShowing()) {
				mStartDialog.dismiss();
			}
			mStartDialog = null;
		}
		
		hideWhiteBoard ();
	}

	public boolean isVideoFinished(int luaFunc) {
		boolean isFinished = true;
		if (null != mStartDialog) {
			isFinished = mStartDialog.isVideoFinished(luaFunc);
			if (isFinished)
				dismissStartDialog();
		} else {

			System.out.println("##### InAppActivity :Ah,.. No StartDialog detected ,So Video must Ended before,So we call Callback imm...");
			// if video is ended before , we should call the callback imm
			if (luaFunc >= 0) {
				AppActivity.mActivity.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, "");
					}
				});
			}
		}
		
		if (isFinished) {
			hideWhiteBoard ();
		}
		
		return isFinished;
	}
	
	public void restartApp(){	
		System.out.println("=======================restartApp");
		
		Intent it = this.getPackageManager().getLaunchIntentForPackage(this.getPackageName());
		it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
		PendingIntent startit = PendingIntent.getActivity(AppActivity.mActivity, 0, it, PendingIntent.FLAG_UPDATE_CURRENT); 
		AlarmManager mgr = (AlarmManager) this.getSystemService(Context.ALARM_SERVICE);
		mgr.set(AlarmManager.RTC, System.currentTimeMillis() + 1000, startit);

		this.finish();
		Process.killProcess(Process.myPid());
	}
	
	@Override
    public void onStart() {
		try {
			super.onStart();
		} catch (Exception e) {
			e.printStackTrace ();
		}
    }

    @Override
	public void onResume() {
		try {
			AdMobileUtil.instance().onResume();
			if(mStartDialog != null){
				hasFocus = true;
			}
			super.onResume();
		} catch (Exception e) {
			e.printStackTrace ();
		}
	}

	public void capturePictureForHead() {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					ImagePicker.getInstance().openCameraForHead(camera_funcId);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	// 缺少相机权限时, 进入权限配置页面
	public void tryCapturePictureForHead(final int luaFuncId) {
		camera_funcId = luaFuncId;
		final String[] PERMISSIONS = new String[]{
				Manifest.permission.CAMERA
		};

		if (mChecker.lacksPermissions(PERMISSIONS)) {
            requestPermission(PERMISSIONS_CAMERA, PERMISSIONS);
		}else{
			capturePictureForHead();
		}
	}

    @Override
    protected void onNewIntent(Intent intent) {
    	super.onNewIntent(intent);
		checkPushParams(intent.getExtras(), false);
    }

	protected void checkPushParams(Bundle bundle, Boolean isSetup) {
		Log.i("aaa", "----checkPushParams--FuncId:" + m_inviteLuaFuncId + "---isSetup:" + (isSetup?"true":"false"));
        if(bundle != null){

	        if (bundle.containsKey("params"))
	        	mParams = bundle.getString("params");
			else
				mParams = "";

			if (bundle.containsKey("info"))
				mPushInfo = bundle.getString("info");
			else
				mPushInfo = "";

			if (bundle.containsKey("access_token"))
				accessToken = bundle.getString("access_token");

	        setInvitRoomInfo(isSetup);
        }
    }
   
    @Override
    public void onStop() {
		try {
			super.onStop();
		} catch (Exception e) {
			e.printStackTrace ();
		}
    }
    
    @Override
    protected void onDestroy() {
		try {
			// org.fmod.FMOD.close();
			AdMobileUtil.instance().onDestroy();
			super.onDestroy();
			FbLoginAndShare.instance().profileTracker.stopTracking();
			GooglePay.getmInstance().onDestroy();
			
			if(mServiceConnected){
				getApplicationContext().unbindService(conn);
				mServiceConnected = false;
			}
		} catch (Exception e) {
			e.printStackTrace ();
		}
    }
    
    public void acquireWakeLock() {
		if (null == m_wakeLock) {
			m_powerManager = (PowerManager) (getSystemService(Context.POWER_SERVICE));
			m_wakeLock = m_powerManager.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK | PowerManager.ON_AFTER_RELEASE, "Domino");
		}
		if(null != m_wakeLock){
			try {
				m_wakeLock.acquire();
			} catch (Exception e) {
				e.printStackTrace();
			}  
		}
    }  
       
    public void releaseWakeLock() {
        if(null != m_wakeLock){
			try {
				m_wakeLock.release();
				m_wakeLock = null;
			} catch (RuntimeException e) {
				e.printStackTrace();
			}  
		}
    }  
    	
    private boolean isNetworkConnected() {
        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);  
        if (cm != null) {  
            NetworkInfo networkInfo = cm.getActiveNetworkInfo();  
        ArrayList<Integer> networkTypes = new ArrayList<Integer>();
        networkTypes.add(ConnectivityManager.TYPE_WIFI);
        try {
            networkTypes.add(ConnectivityManager.class.getDeclaredField("TYPE_ETHERNET").getInt(null));
        } catch (NoSuchFieldException nsfe) {
        }
        catch (IllegalAccessException iae) {
            throw new RuntimeException(iae);
        }
        if (networkInfo != null && networkTypes.contains(networkInfo.getType())) {
                return true;  
            }  
        }  
        return false;  
    } 

    public void getInvitRoomInfo(int luaFuncId) {
    	
    	m_inviteLuaFuncId = luaFuncId;
		//regard as setup
    	setInvitRoomInfo(true);
    }

    /* CALLed when app enter background 
     * and wake by push
     */
    public void setInvitRoomInfo(Boolean isSetup) {

		Boolean flag = false;
    	if(m_inviteLuaFuncId > 0){
    		TreeMap<String, Object> map = new TreeMap<String, Object>();

    		if (mParams != null && mParams.length() > 0) {
    			map.put("params", mParams);
				flag = true;
    		}

			if (mPushInfo != null && mPushInfo.length() > 0) {
				map.put ("info", mPushInfo);
				flag = true;
			}

			if (flag) {
				map.put ("isSetup", isSetup?"true":"false");

				JsonUtil json = new JsonUtil(map);
				final String roomInfo = json.toString();

				Log.i("aaa", "-------setInvitRoomInfo------------roomInfo:"+roomInfo);
				this.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_inviteLuaFuncId, roomInfo);
					}
				});
			}
    	}
    }
    
	@Override
	public Cocos2dxGLSurfaceView onCreateView() { 
		glSurfaceView = new Cocos2dxGLSurfaceView(this);
		glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8); 
		return glSurfaceView; 
	}

    public void GetGcmId(int luaFuncId){
    	try {
			final String token = FirebaseInstanceId.getInstance().getToken();
			if (token == null || token.equals("")) {
				m_regIdLuaFuncId = luaFuncId;
			}else{
				Adjust.setPushToken(token);
				final int luaFunc = luaFuncId;
				AppsFlyerLib.getInstance().updateServerUninstallToken(getApplicationContext(), token);
				AppActivity.mActivity.runOnGLThread(new Runnable() {
			        @Override
			        public void run() {
			        	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, token);
			        	Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
			        }
			    });
			}
		} catch (UnsupportedOperationException e)
    	{
			e.printStackTrace();
    	}
    	catch (Exception e) {
			e.printStackTrace();
		}
    }

	public void uploadGcmId(final String token){
		Adjust.setPushToken(token);
		AppsFlyerLib.getInstance().updateServerUninstallToken(getApplicationContext(), token);
		if(m_regIdLuaFuncId >= 0){
			AppActivity.mActivity.runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_regIdLuaFuncId, token);
					Cocos2dxLuaJavaBridge.releaseLuaFunction(m_regIdLuaFuncId);
				}
			});
		}
    }
    
    private static native boolean nativeIsLandScape();
    private static native boolean nativeIsDebug();
    
    @SuppressLint("MissingSuperCall")
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
        FbLoginAndShare.instance().callbackManager.onActivityResult(requestCode, resultCode, data);
        ImagePicker.getInstance().onActivityResult(requestCode, resultCode, data);
		GooglePay.getmInstance().onActivityResult(requestCode, resultCode, data);
		ShareMgr.getIntance().onActivityResult(requestCode,resultCode,data);
    }

    @Override
    protected void permissionResult(int requestCode, int resultCode) {
		if (requestCode == PERMISSIONS_CAMERA) {
			if (resultCode == Cocos2dxActivity.PERMISSIONS_DENIED) {
				Log.i("permissions", "PERMISSIONS_CAMERA onActivityResult:DENIED");
				Toast.makeText(this, R.string.string_help_text, Toast.LENGTH_LONG).show();
			} else {
				Log.i("", "PERMISSIONS_CAMERA onActivityResult:granted");
				capturePictureForHead();
			}
		}
	}
    
    @Override
    public boolean onKeyDown(int keyCoder,KeyEvent event) //闂佹彃绉峰ù鍥礄閼恒儲娈堕柨娑樼暜ndroid闁归潧顑嗗┃锟介悗鍦仒缂嶅娼婚弬鎸庣闂佹鍠栧ú鏍嫬閸愩劌姣愰柡渚婃嫹  
    {  
		 if(keyCoder == KeyEvent.KEYCODE_BACK){
			 glSurfaceView.onKeyDown(keyCoder, event);
		 }  
		 return false;  
//    	return super.onKeyDown(keyCoder, event);
    }

	@Override
	public void showEditTextDialog(String pTitle, String pMessage,
			int pInputMode, int pInputFlag, int pReturnType, int pMaxLength) {
		// TODO Auto-generated method stub
		
	}

	public String getNetWorkInfo() {
		// TODO 閼奉亜濮╅悽鐔稿灇閻ㄥ嫭鏌熷▔鏇炵摠閺嶏拷
		return DeviceState.getInstance().getNetWorkInfo();
	}

	public String getBatteryInfo() {
		// TODO 閼奉亜濮╅悽鐔稿灇閻ㄥ嫭鏌熷▔鏇炵摠閺嶏拷
		return DeviceState.getInstance().getBatteryInfo();
	}  
	
	/* 
	 * check if the process is running 
	 */
	public boolean isServiceRunning (final String className) {
        
		ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningServiceInfo> info = activityManager.getRunningServices(Integer.MAX_VALUE);
		
        if (info == null || info.size() == 0) 
			return false;
        for (ActivityManager.RunningServiceInfo aInfo : info) {
            if (className.equals(aInfo.service.getClassName())) 
				return true;
        }
		
        return false;
    }
	
	/* 
	 * getLocalPushState 
	 */
	public int getLocalPushState ()
	{
		return m_localPushState;
	}
	
	private void syncPushStat () 
	{
		int state = m_localPushState;
		
        Message msg = Message.obtain(null, 1, state, 0);
        try{
            
            msg.replyTo = mBoundServiceMessenger;
            mBoundServiceMessenger.send(msg);
            
        }catch(RemoteException re){
            re.printStackTrace();
        }
	}
	
	/* 
	 * setLocalPushState 
	 */
	public void setLocalPushState (int state) 
	{
		m_localPushState = state;
		
		/* 
		 * if connected , send message to pushService 
		 */
		if (mServiceConnected) {
			
			syncPushStat ();
			
		} 
	}
	
	/* 
	 * setLocalPushParam 
	 */
    public  void setLocalPushParam (final String jstr)
    {
    	final boolean isdebug = false;
    	
		if (false == isServiceRunning (LocalPushService.class.getName()) || isdebug) {
			
			Intent indent = new Intent (this,LocalPushService.class);
			indent.putExtra("pushparam", jstr);
			boolean isOk = getApplicationContext().bindService(indent,conn,BIND_AUTO_CREATE);  
			System.out.println ("setLocalPushParam : startService.");
			
		} else {
			
			System.out.println ("setLocalPushParam : Already Started.");
			
		}
    }

    /**
     * 打开其他App
     */
    public void openAppWithScheme(String scheme)
    {
        try
        {
            Uri uri = Uri.parse(scheme);
            mActivity.startActivity(new Intent(Intent.ACTION_VIEW, uri));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * line分享
     */
    public void lineShare(String url, String content)
	{
		try
        {
            StringBuilder urlstr = new StringBuilder("line://msg/");
            urlstr.append("text/");
            urlstr.append(URLEncoder.encode(content + url, "UTF-8"));
            Uri uri = Uri.parse(urlstr.toString());
            mActivity.startActivity(new Intent(Intent.ACTION_VIEW, uri));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * whatsapp分享
     */
    public void whatsappShare(String url, String content)
	{
		try
        {
            StringBuilder urlstr = new StringBuilder("whatsapp://send?text=");
            urlstr.append(URLEncoder.encode(content +  url, "UTF-8"));
            Uri uri = Uri.parse(urlstr.toString());
            mActivity.startActivity(new Intent(Intent.ACTION_VIEW, uri));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

	/**
	 * 其他分享方式,带imgPath的只能分享出纯图
	 */
	public void otherShare(final String url, final String content, String imgPath) {
		Intent intent = new Intent(Intent.ACTION_SEND);
		if (imgPath == null || imgPath.equals("")) {
		   intent.setType("text/plain"); // 纯文本
		} else {
		   intent.setType("image/jpg");
		   Uri photoURI = FileProvider.getUriForFile(this, getApplicationContext().getPackageName() + ".myprovider", new File(imgPath));
		   intent.putExtra(Intent.EXTRA_STREAM, photoURI);
		}
		intent.putExtra(Intent.EXTRA_SUBJECT, "");
		intent.putExtra(Intent.EXTRA_TEXT, content + url);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		startActivity(intent);
	}

	/**
	 * 获取文件扩展名
	 * @return
	 */
	public static String getExtention(String filename) {
		int index = filename.lastIndexOf(".");

		if (index == -1) {
			return null;
		}
		String result = filename.substring(index + 1);
		return result;
	}

	public static void save2Gallery(String path)
	{
		try {
			String fileName = null;
			//系统相册目录
			String galleryPath= mActivity.getExternalFilesDir(Environment.DIRECTORY_PICTURES)
					+ File.separator + Environment.DIRECTORY_DCIM
					+File.separator+"Camera"+File.separator;
		 	// 原始文件
			File sourceFile = null;
			// 插入到图库的文件
			File Imagefile = null;
			FileOutputStream outputStream = null;
			Imagefile = new File(path);
			sourceFile = Imagefile;
			String pngName = Imagefile.getName();
			Bitmap bitmap = BitmapFactory.decodeFile(path);
			Imagefile = new File(galleryPath, pngName);
			fileName = Imagefile.toString();
			outputStream = new FileOutputStream(fileName);

			Bitmap.CompressFormat format = Bitmap.CompressFormat.PNG;
			String extension = getExtention(path);

			if (extension.equalsIgnoreCase("jpg"))
				format = Bitmap.CompressFormat.JPEG;
			if (null != outputStream) {
				bitmap.compress(format, 100, outputStream);
				outputStream.close();
			}
			MediaStore.Images.Media.insertImage(getContext().getContentResolver(),
					bitmap, fileName, null);
			Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
			Uri uri = Uri.fromFile(Imagefile);
			intent.setData(uri);
			getContext().sendBroadcast(intent);
			sourceFile.delete();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
}
