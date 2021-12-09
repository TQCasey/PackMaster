package com.zhijian.common;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.Intent.ShortcutIconResource;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.zhijian.domino.R;
import com.zhijian.common.utility.LuaCallEvent;
import com.zhijian.common.utility.PermissionsChecker;

import org.cocos2dx.lua.AppActivity;

import java.lang.reflect.Method;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

public class LoginAcitivity extends AppCompatActivity {
	final String[] setup_permissions = new String[]{
		Manifest.permission.READ_PHONE_STATE,
		//Manifest.permission.WRITE_EXTERNAL_STORAGE
	};
	boolean isSetup = false;
	ImageView startIcon;
	public static LoginAcitivity sLoginAcitivity = null;
	static Handler sHandler = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		sLoginAcitivity = this;

		//刘海屏设置全屏，否则会留一条黑带
		if (Build.VERSION.SDK_INT >= 28) {
			WindowManager.LayoutParams lp = getWindow().getAttributes();
			lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
			getWindow().setAttributes(lp);
		}

		// 设置全屏显示
		getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);

		DisplayMetrics dm = getAccurateScreenDpi();

		RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
		RelativeLayout view = new RelativeLayout(this);
		view.setBackgroundColor(Color.WHITE);
		view.setLayoutParams(lp);//设置布局参数

		int screen_width = dm.widthPixels;
		int screen_height = dm.heightPixels;
		if (getOrientation() == 1) {
			screen_width = dm.heightPixels;
			screen_height = dm.widthPixels;
		}
//		ImageView bgImg = new ImageView(this);
//		bgImg.setImageResource(R.drawable.start_screen);
//		bgImg.setScaleType(ScaleType.FIT_XY);
//		RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(screen_width, screen_width);
//		view.addView(bgImg, layoutParams);

		startIcon = new ImageView(this);
		startIcon.setImageResource(R.drawable.start_screen_icon);
		int IconWidth = 448*screen_height/1080;
		int IconHeight = 501*screen_height/1080;
		RelativeLayout.LayoutParams loadIconLayout = new RelativeLayout.LayoutParams(IconWidth,IconHeight);
		loadIconLayout.addRule(RelativeLayout.CENTER_IN_PARENT);
		view.addView(startIcon, loadIconLayout);
		setContentView(view);

		addShortcut();
		mChecker = new PermissionsChecker(this);
		isRequireCheck = true;
	}

	/**
	 * 获取精确的屏幕大小
	 */
	public DisplayMetrics getAccurateScreenDpi()
	{
		DisplayMetrics dm = new DisplayMetrics();
		Display display = getWindowManager().getDefaultDisplay();
		try {
			Class<?> c = Class.forName("android.view.Display");
			Method method = c.getMethod("getRealMetrics",DisplayMetrics.class);
			method.invoke(display, dm);
		}catch(Exception e){
			display.getMetrics(dm);
			e.printStackTrace();
		} finally {
			return dm;
		}
	}

	private void startApp() {
		isSetup = true;
		Intent i = new Intent(LoginAcitivity.this, AppActivity.class);
		i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
		startActivity(i);
		overridePendingTransition(0, 0);		// 进入退出无动画效果
//		sHandler = new Handler();
//		sHandler.postDelayed(new Runnable() {
//			public void run() {
//				delSelf();
//			}
//		}, 2000); //延迟2秒跳转
		delSelf();
	}

	public static void delSelf() {
		if (sLoginAcitivity != null){
			sLoginAcitivity.finish();
		}
		sLoginAcitivity = null;
		if (sHandler != null) {
			sHandler.removeCallbacksAndMessages(null);
			sHandler = null;
		}
	}

	private void addShortcut(){
		boolean isInstallShortcut = false;
		SharedPreferences settings = this.getSharedPreferences("InstallShortcut", 0);
		isInstallShortcut = settings.getBoolean("InstallShortcut", false);
		if (isInstallShortcut) {
			System.out.println("addShortcut return +++++++++++++++++++++++++++");
			return;
		}
		
		Intent shortcut = new Intent("com.android.launcher.action.INSTALL_SHORTCUT");
		shortcut.putExtra(Intent.EXTRA_SHORTCUT_NAME, (String)this.getResources().getText(R.string.app_name));
		ShortcutIconResource iconRes = Intent.ShortcutIconResource.fromContext(this, R.drawable.icon);
		shortcut.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, iconRes);
		shortcut.putExtra("duplicate", false);
		
		Intent intent = new Intent("android.intent.action.MAIN");
        intent.setClassName(this, getClass().getName());
        intent.addCategory("android.intent.category.LAUNCHER");
        // 这里添加2个flag 可以 消除 在按home 键时，再点快捷方式重启程序的bug
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
		
        shortcut.putExtra(Intent.EXTRA_SHORTCUT_INTENT, intent);
		this.sendBroadcast(shortcut);
		
		SharedPreferences.Editor e = settings.edit();
		e.putBoolean("InstallShortcut", true);
		e.commit();
	}

	private static final int PERMISSION_REQUEST_CODE = 0; // 系统权限管理页面的参数
	private PermissionsChecker mChecker; // 权限检测器
	private boolean isRequireCheck = true; // is the first time

	@Override
	protected void onResume() {
		super.onResume();
        if (mChecker.lacksPermissions(setup_permissions)) {
			if (isRequireCheck) requestPermissions(setup_permissions);
			else showMissingPermissionDialog();
			isRequireCheck = false;
			return;
		} else if (isRequireCheck) {
			startIcon.setVisibility(View.INVISIBLE);
		}
        isRequireCheck = false;
        if (!isSetup) startApp();
	}

	// 请求权限兼容低版本
	private void requestPermissions(String... permissions) {
		ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE);
	}

	/**
	 * 用户权限处理,
	 * 如果全部获取, 则直接过.
	 * 如果权限缺失, 则提示Dialog.
	 *
	 * @param requestCode  请求码
	 * @param permissions  权限
	 * @param grantResults 结果
	 */
	@Override
	public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
		if (requestCode == PERMISSION_REQUEST_CODE && hasAllPermissionsGranted(grantResults)) {
			startApp();
		} else {
			showMissingPermissionDialog();
		}
	}

	// 含有全部的权限
	private boolean hasAllPermissionsGranted(@NonNull int[] grantResults) {
		for (int grantResult : grantResults) {
			if (grantResult == PackageManager.PERMISSION_DENIED) {
				return false;
			}
		}
		return true;
	}

	// 显示缺失权限提示
	private void showMissingPermissionDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(LoginAcitivity.this);
		builder.setTitle(R.string.help);
		builder.setMessage(R.string.string_help_text);

		// 拒绝, 退出应用
		builder.setNegativeButton(R.string.quit, new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				finish();
			}
		});

		builder.setPositiveButton(R.string.settings, new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				LuaCallEvent.toSetting(LoginAcitivity.this);
			}
		});

		builder.show();
	}

	/**
	 * 读取Activity 节点  screenOrientation
	 */
	private int getOrientation() {
		try {
			PackageInfo packageInfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_ACTIVITIES);
			ActivityInfo[] activities = packageInfo.activities;
			for (ActivityInfo activity:activities) {
				if (activity.name.contains("LoginAcitivity"))
					return activity.screenOrientation;
			}
		} catch (NameNotFoundException e) {
			e.printStackTrace();
			return 1;
		}
		return 0;
	}
}