package com.zhijian.common.utility;

import com.cynking.capsa.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;
import android.widget.VideoView;
import android.widget.Toast;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;

import java.lang.reflect.Method;

public class AppStartDialog extends AlertDialog {
	private Context m_context;
	private boolean isLandScape;
	private boolean playVideo;

	private int m_videoLuaFunc = -1;
//	private boolean isVideoFinished = false;
	private VideoView m_videoView = null;
	private ImageView m_bgImgae = null;
	private ImageView m_startIcon = null;

	private boolean m_isVideoEnded = false;

	public AppStartDialog(Activity context, boolean isLandScape, boolean playVideo) {
		super(context, R.style.Transparent);
		m_context = context;
		this.isLandScape = isLandScape;
		this.playVideo = playVideo;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		//刘海屏设置全屏，否则会留一条黑带
		if (Build.VERSION.SDK_INT >= 28) {
			WindowManager.LayoutParams lp = getWindow().getAttributes();
			lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
			getWindow().setAttributes(lp);
		}

		DisplayMetrics dm = getAccurateScreenDpi();
		if (dm == null) {
			android.view.Display display = ((Activity) m_context).getWindowManager().getDefaultDisplay();
			display.getMetrics(dm);
		}
		int screen_width = dm.widthPixels;
		int screen_height = dm.heightPixels;
		if (!isLandScape) {
			screen_width = dm.heightPixels;
			screen_height = dm.widthPixels;
		}
	 // TODO 动态添加布局(java方式)
 		RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(screen_width, screen_width);
 		RelativeLayout view = new RelativeLayout(m_context); 
        view.setLayoutParams(lp);//设置布局参数

        ImageView bgImg = new ImageView(m_context);
        bgImg.setImageResource(R.drawable.start_screen);
        bgImg.setScaleType(ScaleType.FIT_XY);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(screen_width, screen_width);
        view.addView(bgImg, layoutParams);
	    
		ImageView startIcon = new ImageView(getContext());
		startIcon.setImageResource(R.drawable.start_screen_icon);
		int IconWidth = 448*screen_height/1080;
		int IconHeight = 501*screen_height/1080;
		RelativeLayout.LayoutParams loadIconLayout = new RelativeLayout.LayoutParams(IconWidth,IconHeight);
		loadIconLayout.addRule(RelativeLayout.CENTER_IN_PARENT);
		view.addView(startIcon, loadIconLayout);

		m_bgImgae = bgImg;
		m_startIcon = startIcon;

		onEndPlayLaunchVideo ();

        setContentView(view);

		//设置全屏
		getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
	}
	
	
	private void onEndPlayLaunchVideo () {

		try {
			if (m_isVideoEnded) { // avoid re-enter
				return;
			}

			m_bgImgae.bringToFront();
			m_startIcon.bringToFront();
			m_isVideoEnded = true;

			Handler handler = new Handler();
			handler.postDelayed(new Runnable() {
				@Override
				public void run() {
					try {
						System.out.println("##### Video is Ending");
						if (m_videoLuaFunc >= 0) {
							AppActivity.mActivity.runOnGLThread(new Runnable() {
								@Override
								public void run() {
									Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_videoLuaFunc, "");
								}
							});

							System.out.println("##### Video is dismiss");
							AppActivity.mStartDialog = null;
							dismiss();
						}
						AppActivity.mActivity.hideWhiteBoard();
					} catch (Exception e ) {
						e.printStackTrace();
					}
				}
			}, 20);  // 延迟一帧

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public boolean isVideoFinished(int luaFunc) {
		m_videoLuaFunc = luaFunc;
		System.out.println("##### setVideoEnded Callback");

		if (m_isVideoEnded) {

			System.out.println("##### Video is Ended before,So we call Callback imm...");
			// if video is ended before , we should call the callback imm
			if (m_videoLuaFunc >= 0) {
				AppActivity.mActivity.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_videoLuaFunc, "");
					}
				});
			}
		}

		return m_isVideoEnded;
	}

	/**
	 * 获取精确的屏幕大小
	 */
	public DisplayMetrics getAccurateScreenDpi()
	{
		Display display = ((Activity) m_context).getWindowManager().getDefaultDisplay();
		try {
			DisplayMetrics dm = new DisplayMetrics();
			Class<?> c = Class.forName("android.view.Display");
			Method method = c.getMethod("getRealMetrics",DisplayMetrics.class);
			method.invoke(display, dm);
			return dm;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void onStart() {
		super.onStart();
	}

	@Override
	protected void onStop() {
		super.onStop();
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)  {
	    if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
	        return true;
	    }

	    return super.onKeyDown(keyCode, event);
	}

	@Override
	public void dismiss() {
		super.dismiss();
		System.out.println("##### Dismiss Dialog ....");
	}
}
