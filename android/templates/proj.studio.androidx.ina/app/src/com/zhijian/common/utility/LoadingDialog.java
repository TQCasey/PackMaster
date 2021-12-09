package com.zhijian.common.utility;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import com.zhijian.domino.R;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Camera;
import android.graphics.Color;
import android.graphics.Matrix;
import android.os.Build;
import android.os.Bundle;
import android.provider.CalendarContract.Colors;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.Interpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.Transformation;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.Random;

@SuppressLint("NewApi")
public class LoadingDialog extends Dialog {
	private static LoadingDialog loadingDlg = null;
	private static Context m_context = null;
	private static String m_tipsStr = null;
	private static String m_imgPath = null;
	private static int  m_Color = Color.argb(0xff, 0xff, 0xff, 0xff);
	private static boolean m_Bold = false;
	
	private static int icons [] = {
			R.drawable.common_loading_chips,
			R.drawable.common_loading_chips2,
			R.drawable.common_loading_chips3,
			R.drawable.common_loading_chips4,
		};
	
	private static int curIndex = 0;
	
	public static LoadingDialog getInstance(Context context){
		if (null == loadingDlg) {
			loadingDlg = new LoadingDialog(context, R.style.Dialog_FullscreenTransparent);
		}
		loadingDlg.requestWindowFeature(Window.FEATURE_NO_TITLE);
		loadingDlg.setCancelable(false);
		loadingDlg.setCanceledOnTouchOutside(false);
		
		loadingDlg.setContentView(R.layout.loading_layout);
		return loadingDlg;
	}
	
	private LoadingDialog(Context context,int theme) {
		super(context,theme);
		m_context = context;

		//刘海屏设置全屏，否则会留一条黑带
		if (Build.VERSION.SDK_INT >= 28) {
			WindowManager.LayoutParams lp = getWindow().getAttributes();
			lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
			getWindow().setAttributes(lp);
		}

		//设置全屏
		getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
	}

	public static LoadingDialog show(Activity context, String tipsStr, String imgPath,String jstr) {
		
		Random rand = new Random();
    	curIndex = rand.nextInt(icons.length);
		m_tipsStr = tipsStr;
		m_imgPath = imgPath;
		
		JSONObject json = null;

		// decode
		try {
			json = new JSONObject(jstr);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			//handle_exception(e1);
		}

		Iterator<?> it = json.keys();

		while (it.hasNext()) {
			String key = it.next().toString();
			String value = null;

			try {
				value = json.getString(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				//handle_exception(e);
			}

			//
			if (value == null)
				continue;
			
			if (key.equals("color")) {
				try {
					JSONObject colorJson = json.getJSONObject (key);
					
					int r = colorJson.getInt ("r");
					int g = colorJson.getInt ("g");
					int b = colorJson.getInt ("b"); 
					int a = colorJson.getInt ("a");
					
					m_Color = Color.argb(a, r,g, b);
					
				} catch (JSONException e) {
					// TODO 自动生成的 catch 块
					e.printStackTrace();
				}
			} else if (key.equals("bold")) {
				m_Bold = value.toString().equals("1");
			}
		}
		
		
		if (null == loadingDlg) {
			getInstance(context);
		}
		loadingDlg.show();
		return loadingDlg;
	}
	
	@Override
	public void show() {

		// 设置焦点失能，防止弹出导航栏或虚拟键
		loadingDlg.getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
		super.show();

	//	AppActivity.mActivity.solveNavigationBar();		// 隐藏导航栏
	//	loadingDlg.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
	}

	public static void dismissDlg() {
		if (null != loadingDlg && loadingDlg.isShowing()) {
			loadingDlg.dismiss();
			loadingDlg = null;
		}
	}
	
    public static Bitmap zoomBitmap(Bitmap bitmap, int w, int h){    
        int width = bitmap.getWidth();    
        int height = bitmap.getHeight();    
        Matrix matrix = new Matrix();    
        float scaleWidth = ((float) w / width);    
        float scaleHeight = ((float) h / height);    
        matrix.postScale(scaleWidth, scaleHeight);

		Bitmap newBmp = null;
        try {
			newBmp = Bitmap.createBitmap(bitmap, 0, 0, width, height,
					matrix, true);
		} catch (Exception e) {
        	e.printStackTrace();
		} finally {

		}
        return newBmp;    
    }

	/**
	 * 获取精确的屏幕大小
	 */
	public DisplayMetrics getAccurateScreenDpi()
	{
		DisplayMetrics dm = new DisplayMetrics();
		Display display =  AppActivity.mActivity.getWindowManager().getDefaultDisplay();
		try {
			Class<?> c = Class.forName("android.view.Display");
			Method method = c.getMethod("getRealMetrics",DisplayMetrics.class);
			method.invoke(display, dm);
		}catch(Exception e){
			e.printStackTrace();
			display.getMetrics(dm);
		}finally {
			return dm;
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// 全面屏显示，需要时再开启
	//	solveFullScreenDisplay();

		DisplayMetrics dm = getAccurateScreenDpi();

		ImageView bk 		= (ImageView) findViewById(R.id.imageView_bk);
		ImageView strbk 	= (ImageView) findViewById(R.id.imageView_str_bk);
		ImageView light 	= (ImageView) findViewById(R.id.loading_light);
		final ImageView chip 		= (ImageView) findViewById(R.id.loading_chips);
		chip.setImageDrawable(AppActivity.mActivity.getResources().getDrawable(icons [curIndex]));
		TextView text		= (TextView) findViewById(R.id.loading_text);
		
        Bitmap image = null;  
        AssetManager am = m_context.getResources().getAssets();  
        try  
        {  
        	FileInputStream fis = new FileInputStream (m_imgPath);
//            InputStream is = am.open(m_imgPath);  
            image = BitmapFactory.decodeStream(fis);  
            fis.close();  
        }  
        catch (IOException e)  
        {  
//            e.printStackTrace();
        }
		
        if(image != null){
        	
        	Bitmap bmp = zoomBitmap (image,dm.widthPixels,dm.heightPixels);
        	if (bmp != null) {
				bk.setImageBitmap(bmp);
			}
        	strbk.setVisibility(View.INVISIBLE);
        }  
        
        if (m_tipsStr.length() > 0) {
        	
        	text.setText(m_tipsStr);
        	text.setTextColor(m_Color);
        	
        	if (m_Bold) 
        		text.getPaint().setFakeBoldText(true);
        	
        } else {
        	strbk.setVisibility(View.INVISIBLE);
        }
       
        // circel animation 
		RotateAnimation animation = new RotateAnimation(0, 359,
				Animation.RELATIVE_TO_SELF, 0.5f,
				Animation.RELATIVE_TO_SELF, 0.5f);
		animation.setDuration(1800);
		animation.setRepeatCount(Animation.INFINITE);
		
		animation.setInterpolator(new Interpolator (){

			@Override
			public float getInterpolation(float input) {
				// TODO 自动生成的方法存根
				return (float) (input * 1.5);
			}
			
		});
		
		light.setAnimation(animation);
		animation.start();
		
		// chip animation 
		int i = View.MeasureSpec.makeMeasureSpec(0, 0);
		int j = View.MeasureSpec.makeMeasureSpec(0, 0);
		chip.measure(i, j);
		
		float width = chip.getMeasuredWidth();
		float height = chip.getMeasuredHeight();
		
		System.out.println ("Animation3D width = " + width + " height = " + height);
		Rotate3dAnimation chip_animation =  new Rotate3dAnimation(90, 270, width / 2, height / 2,0,Rotate3dAnimation.ROTATE_Y_AXIS, true);
		chip_animation.setDuration(1400);
		chip_animation.setRepeatCount(Animation.INFINITE);
		chip.startAnimation(chip_animation);
		chip_animation.setAnimationListener(new AnimationListener() {
			
			@Override
			public void onAnimationStart(Animation animation) {
				// TODO 自动生成的方法存根
				
			}
			
			@Override
			public void onAnimationRepeat(Animation animation) {
				// TODO 自动生成的方法存根
				System.out.println ("Animation : onAnimationRepeat");
				
				curIndex ++;
				if (curIndex >= icons.length) { 
					curIndex = 0;
				}
				
				System.out.println ("Animation  curIndex = " + curIndex);
				
				chip.setImageDrawable(AppActivity.mActivity.getResources().getDrawable(icons [curIndex]));
			}
			
			@Override
			public void onAnimationEnd(Animation animation) {
				// TODO 自动生成的方法存根
				
			}
		});
		
	}

	/**
     * <P>shang</P>
     * <P>解决全屏显示问题</P>
     */
    public void solveFullScreenDisplay(){

        if (!AppActivity.mActivity.checkDeviceHasNavigationBar(AppActivity.mActivity)) {
            return;
        }

        // 全屏显示
        AppActivity.mActivity.solveMissionBar(loadingDlg.getContext(), loadingDlg.getWindow());
		
		View decorView = loadingDlg.getWindow().getDecorView();
		int uiOptions = decorView.getSystemUiVisibility();
		int flags = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
				| View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
				| View.SYSTEM_UI_FLAG_FULLSCREEN;
		uiOptions |= flags;

		decorView.setSystemUiVisibility(uiOptions);
    }

	@Override
	public void onStart() {
		super.onStart();
	}

	@Override
	public void onWindowFocusChanged(final boolean hasWindowFocus) {
	    super.onWindowFocusChanged(hasWindowFocus);
	    AppActivity.mActivity.onWindowFocusChanged(hasWindowFocus);
	}

	@Override
	protected void onStop() {
		super.onStop();
	}
	
}
