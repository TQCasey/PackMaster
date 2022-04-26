package com.zhijian.common.utility;

import android.annotation.SuppressLint;
import android.app.AppOpsManager;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.LocaleList;
import android.os.Vibrator;
import android.telephony.PhoneNumberUtils;
import android.util.Log;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustEvent;
import com.appsflyer.AppsFlyerLib;
import com.zhijian.domino.R;
import com.facebook.appevents.AppEventsConstants;
import com.lahm.library.EasyProtectorLib;
import com.zhijian.common.MyApplication;
import com.zhijian.common.iap.google.GooglePay;
import com.zhijian.common.InstallReferrer;
import com.zhijian.common.ShareMgr;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lib.WebHandler;
import org.cocos2dx.lib.emulator.FindEmulator;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;

public class LuaCallEvent {
	
	private static String retstr = "";
	private static Toast 	mToast = null;
    private static final String CHECK_OP_NO_THROW = "checkOpNoThrow";
    private static final String OP_POST_NOTIFICATION = "OP_POST_NOTIFICATION";

	public static void InitAppInfo(final int luaFunc) {
		String model = android.os.Build.MODEL;
		String name = "Guest_";
		if (model != null) {
			String names[] = model.split(" ");
			int length = names.length;
			if (length >= 3) {
				name = names[length - 2] + " " + names[length - 1];
			} else {
				name = model;
			}
		}
		TreeMap<String, Object> map = new TreeMap<String, Object>();
		map.put("imei", SimUtil.getDeviceId());
		map.put("name", name);
		map.put("imsi", SimUtil.getSimOperator());
		map.put("os_version", android.os.Build.VERSION.RELEASE);
		map.put("version_sdk", android.os.Build.VERSION.SDK);
		map.put("mac_id", SimUtil.getMacId());
		map.put("sim_type", SimUtil.getSimType());
		map.put("net_operator", SimUtil.getNetworkOperator());  //回注册的网络运营商的代码
		map.put("net_countryIso", SimUtil.getNetworkCountryIso());  //回注册的网络运营商的国家代码
		map.put("language", getLanguage());       //系统语言
		map.put("brand", android.os.Build.BRAND);       //手机型号
		map.put("androidId", DeviceInfo.getInstance().getAndroidID());       //AndroidID
		map.put("appsflyerId", AppsFlyerLib.getInstance().getAppsFlyerUID(AppActivity.mActivity));
		map.put("adjustId", Adjust.getAdid());
		map.put("gms_adid", MyApplication.gms_adid);
		// String pushRid = AppActivity.mActivity.rid;
		// String pushTid = AppActivity.mActivity.tid;
		// if(pushRid != null && pushRid.length() > 0 && pushTid != null &&
		// pushTid.length() > 0){
		// map.put("pushRid", pushRid);
		// map.put("pushTid", pushTid);
		// }
		map.put("isSimulator", FindEmulator.isSimulator(AppActivity.mActivity)?"1":"0");
		map.put("trick_param", getTrickParams());

		String accessToken = AppActivity.mActivity.accessToken;
		if (accessToken != null && accessToken.length() > 0) {
			map.put("accessToken", accessToken);
		}

		map.put("device_info", DeviceInfo.getInstance().getDeviceInfo());

		JsonUtil json = new JsonUtil(map);
		final String deviceInfo = json.toString();

		AppActivity.mActivity.runOnGLThread(new Runnable() {
			@Override
			public void run() {
				try {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc,
							deviceInfo);
					Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});

		// AppActivity.mActivity.runOnUiThread(new Runnable() {
			// @Override
			// public void run() {
				// try {
					// AppActivity.mActivity.dismissStartDialog();
				// } catch (Exception e) {
					// handle_exception(e);
				// }
			// }
		// });
	}

	private static String getTrickParams() {
		StringBuffer ret = new StringBuffer();
		AppActivity act = AppActivity.mActivity;
		ret.append(EasyProtectorLib.checkIsRoot()?"rooted|":"not rooted|");
		ret.append(EasyProtectorLib.checkIsDebug(act)?"debug|":"not debug|");
		int r = 10000 + new Random().nextInt(55534);
		ret.append(EasyProtectorLib.checkIsPortUsing("127.0.0.1", r)?"port|":"not port|");
		//ret.append(EasyProtectorLib.checkXposedExistAndDisableIt()?"xposed|":"not xposed|");
		String pkg_name = Integer.toString(R.string.ACTION_ON_REGISTERED);
		ret.append(EasyProtectorLib.checkIsRunningInVirtualApk(pkg_name, null)?"virtual|":"not virtual|");
		ret.append(EasyProtectorLib.checkIsRunningInEmulator(act, null)?"emulator|":"not emulator|");
		ret.append(checkCloned()?"cloned|":"not cloned|");

		Log.i("trick_param", ret.toString());

		return ret.toString();
	}

	/* 是否被双开 */
	public static boolean checkCloned() {
		try {
			Class v0_2 = Class.forName("android.app.ActivityThread");
			Object v13 = v0_2.getDeclaredMethod("currentActivityThread").invoke(null);
			Field v0_3 = v0_2.getDeclaredField("sPackageManager");
			v0_3.setAccessible(true);
			if (!Proxy.isProxyClass(v0_3.get(v13).getClass())) {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	/* exception handler for LUA_CALL_JAVA */
	private static void handle_exception(Exception e) {
		e.printStackTrace();
	}

	/**
	 * 获取系统语言
	 * @return
	 */
	public static String getLanguage() {
		Locale locale;
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
			locale = LocaleList.getDefault().get(0);
		} else locale = Locale.getDefault();

		return locale.getLanguage() + "-" + locale.getCountry();
	}

	public static void getInviteRoomInfo(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					AppActivity.mActivity.getInvitRoomInfo(luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void resartApp() {
		try {
			AppActivity.mActivity.restartApp();
		} catch (Exception e) {
			handle_exception(e);
		}
	}

	public static void ShowStartDialog() {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					AppActivity.mActivity.showStartDialog(false);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void dismissStartDialog(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					AppActivity.mActivity.dismissStartDialog();
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static int isVideoFinished(final int luaFunc) {
		try {
			boolean isFinish = AppActivity.mActivity.isVideoFinished(luaFunc);
			int videoState = isFinish ? 1 : 0;
			return videoState;
		} catch (Exception e) {
			handle_exception(e);
		}
		return 1;
	}

	public static void ChoosePictureForHead(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					ImagePicker.getInstance().openPhotoForHead(luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void CapturePictureForHead(final int luaFunc) {
		AppActivity.mActivity.tryCapturePictureForHead(luaFunc);
	}

	public static void ChoosePictureForFeedback(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					ImagePicker.getInstance().openPhotoForFeedback(luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static String GetIpByDress(final String address) {
		System.out.println("GetIpByDress address : " + address);
		java.net.InetAddress x;
		String ip = "";

		try {
			x = java.net.InetAddress.getByName(address);
			ip = x.getHostAddress();

			System.out.println("GetIpByDress ip : " + ip);
		} catch (Exception e) {
			handle_exception(e);
		}
		return ip;
	}

	public static void vibrate(final int vibrateTime) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					Vibrator v = (Vibrator) AppActivity.mActivity
							.getSystemService(Context.VIBRATOR_SERVICE);
					v.vibrate(vibrateTime * 1000);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	//firebase 上报事件
	public static void eventReport(final String event_name) {
		AppActivity.mActivity.firebaseLog(event_name);
	}

	public static void errorReport(final String text) {
	}

	public static void facebookLogin(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().facebookLogin(luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void facebookLogout(final int luaFun) {
		try {
			FbLoginAndShare.instance().facebookLogout();
		} catch (Exception e) {
			handle_exception(e);
		}
	}

	public static void facebookRequestDlg(final String postUrl,
			final String postData) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().showRequestDlg();
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void requestFbFriendId(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().RequestFbLoginFriend(luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void requestInvetableFriendList(final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().RequestInvitableFriendList(
							luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void requestInviteFriendWithId(final String friendIds,
			final String title, final String message, final int luaFunc) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().showInviteFriendDlg(friendIds,
							title, message, luaFunc);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void requestFbShareDlg(final String shareTitle,
			final String shareContent, final String imgPath, final int luaFun) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().showShareDialog(shareTitle,
							shareContent, imgPath, luaFun);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void requestFbShareDlgEx(final String shareTitle,
			final String shareContent, final String imgPath, final String url,
			final int luaFun) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					FbLoginAndShare.instance().showShareDialogEx(shareTitle,
							shareContent, imgPath, luaFun, url);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void GetGcmRegId(final int handle) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					AppActivity.mActivity.GetGcmId(handle);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void acquireWakeLock(final int luaFun) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					AppActivity.mActivity.acquireWakeLock();
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void releaseWakeLock(final int luaFun) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					AppActivity.mActivity.releaseWakeLock();
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void OpenOneUrl(String url) {
		try {
			Intent intent = new Intent(Intent.ACTION_VIEW);
			intent.setData(Uri.parse(url));
			intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			AppActivity.mActivity.startActivity(intent);
		} catch (Exception e) {
			handle_exception(e);
		}
	}

	public static void checkGooglePay(final String postUrl,final String postData, final String encryptChar, final int luaFun) {
		new Thread (new Runnable() {

			@Override
			public void run() {
				try {
					GooglePay.getmInstance().checkGooglePay(luaFun, postUrl,postData, encryptChar);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		}).start();
		
	}

	public static void startGooglePay(final String skuId, final String orderId,final int luaFun) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					GooglePay.getmInstance().startGooglePay(luaFun, skuId,orderId);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void getGoogleProductInfo(final String productIds,final int luaFun) {
		new Thread (new Runnable() {
			
			@Override
			public void run() {
				try {
					GooglePay.getmInstance().getProductInfo(productIds, luaFun);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		}).start();
		
	}

	public static void startMimoPay(final String userId, final String orderId,
			final String productName, final String productPrice,
			final int paymode, final int luaFun,final int useAbcpay) {
	}

	public static void startCodaPay(final String userId,final String orderId,
			final String productName, final String productPrice,
			final int paymode, final int luaFun) {
	}

	/*
	 * 事件上报
	 */
	public static void tracklog(final String eventname,
			final String subeventname) {
		if (subeventname == null || subeventname.equals(""))
			AppActivity.mActivity.firebaseLog(eventname);
		else
			AppActivity.mActivity.firebaseLog(eventname+"+"+subeventname);
	}

	/* app flyer */
	public static void af_tracklog(final String evt_type, final String jsondat) {
		JSONObject json = null;

		if (evt_type == null || evt_type.equals(""))
			return;

		// decode
		try {
			json = new JSONObject(jsondat);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			handle_exception(e1);
		}

		// /

		Map<String, Object> ev = new HashMap<String, Object>();

		Iterator<?> it = json.keys();

		while (it.hasNext()) {
			String key = it.next().toString();
			String value = null;

			try {
				value = json.getString(key);
			} catch (JSONException e) {
				handle_exception(e);
			}

			//
			if (value == null)
				continue;

			System.out.println("af track log >> key = " + key + ",value = "
					+ value);
			ev.put(key, value);
		}

		AppsFlyerLib.getInstance().trackEvent(AppActivity.mActivity, evt_type, ev);
	}

	/*
	 * adjust事件打点
	 * @param eventToken 事件token
	 */
	public static void adjust_tracklog(final String eventToken, final String subEvent) {
		if (eventToken != null && !eventToken.equals("")){
			AdjustEvent adjustEvent = new AdjustEvent(eventToken);
			adjustEvent.addCallbackParameter("subEvent", subEvent);
			Adjust.trackEvent(adjustEvent);
		}
	}
	
	/*
	 * facebook tracklog API
     */
	public static void fb_tracklog(final String evt_type, final String jsondat) {
		JSONObject json = null;

		if (evt_type == null || evt_type.length() <= 0 || jsondat == null || jsondat.length() <= 0) {
			/* facebook tracklog */
			return ;
		}

		// decode
		try {
			json = new JSONObject(jsondat);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			handle_exception(e1);
		}

		// /

		Bundle parameters = new Bundle();

		Iterator<?> it = json.keys();
		
		double money  	= 0;

		//
		while (it.hasNext()) {
			String key = it.next().toString();
			String value = null;

			try {
				value = json.getString(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				handle_exception(e);
			}

			//
			if (value == null)
				continue;
			
			if (key.equals ("fb_money")) {
				
				money = Integer.parseInt(value);
				
			} else {
				
				System.out.println("fb track log >> key = " + key + ",value = " + value);
				parameters.putString(key, value);
			}
			
		}
		
		if (evt_type.equals(AppEventsConstants.EVENT_NAME_INITIATED_CHECKOUT)) {
			
			parameters.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, "product");
			
		}
			
		AppActivity.fblogger.logEvent (evt_type, money, parameters);
	}

	public static void showLoadingDlg(final String tipStr, final String imgPath,final String param) {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					LoadingDialog.show(AppActivity.mActivity, tipStr, imgPath,param);
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void closeLoadingDlg() {
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					LoadingDialog.dismissDlg();
				} catch (Exception e) {
					handle_exception(e);
				}
			}
		});
	}

	public static void setActivityFuncId(final int luaFunc) {
		WebHandler.luaFuncId = luaFunc;
	}

	public static void setActInfoStr(final String str) {
		WebHandler.actInfoStr = str;
	}

	public static String getBatteryInfo() {
		try {
			String str = AppActivity.mActivity.getBatteryInfo();
			return str;
		} catch (Exception e) {
			return "";
		}
	}

	public static String getNetWorkInfo() {

		try {
			String str = AppActivity.mActivity.getNetWorkInfo();
			return str;
		} catch (Exception e) {
			return "";
		}
	}

	/* write SDcard file (with overwrite) */
	public static void writeSDCardFile(final String filepath,
			final String content) {
		try {
			/*
			 * if SDCard media mounted
			 */
			if (Environment.getExternalStorageState().equals(
					Environment.MEDIA_MOUNTED)) {

				/*
				 * re-write whole file content
				 */
				File sdCardDir = Environment.getExternalStorageDirectory();
				File file = new File(sdCardDir.getCanonicalPath() + filepath);

				/*
				 * if not exists , create it
				 */
				if (!file.exists()) {
					String dirname = file.getParent();
					boolean pdir = new File(dirname).mkdirs();

					file.createNewFile();
				}

				/*
				 * write file
				 */
				FileOutputStream fos = new FileOutputStream(file, false);
				fos.write(content.getBytes());
				fos.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/* read SDCard file */
	public static String readSDCardFile(final String filepath) {
		try {
			/*
			 * if SDCard media mounted
			 */
			if (Environment.getExternalStorageState().equals(
					Environment.MEDIA_MOUNTED)) {

				/*
				 * re-write whole file content
				 */
				File sdCardDir = Environment.getExternalStorageDirectory();
				File file = new File(sdCardDir.getCanonicalPath() + filepath);

				/*
				 * if not exists ,return null
				 */
				if (!file.exists()) {
                	return "";
				}

				/*
				 * read file
				 */
				FileInputStream fis = new FileInputStream(file);
				BufferedReader br = new BufferedReader(new InputStreamReader(
						fis));
				StringBuilder sb = new StringBuilder("");
				String line = null;

				/*
				 * read line by line
				 */
				while ((line = br.readLine()) != null) {
					sb.append(line);
				}

				br.close();

				return sb.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
        return "";
	}

	private static boolean deleteDir(File dir) {

		try {
			if (dir.isDirectory()) {

				String[] children = dir.list();

				for (int i = 0; i < children.length; i++) {
					boolean success = deleteDir(new File(dir, children[i]));
					if (!success) {
						return false;
					}
				}
			}

			// delete root
			return dir.delete();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	/*
	 * delete SDCard file
	 */
	public static void deleteSDCardFile(final String filepath) {

		try {
			/*
			 * if SDCard media mounted
			 */
			if (Environment.getExternalStorageState().equals(
					Environment.MEDIA_MOUNTED)) {

				/*
				 * re-write whole file content
				 */
				File sdCardDir = Environment.getExternalStorageDirectory();
				File file = new File(sdCardDir.getCanonicalPath() + filepath);

				/*
				 * if not exists ,return null
				 */
				if (!file.exists()) {
					return;
				}

				/*
				 * delete file
				 */
				if (file.isFile()) {

					file.delete();

				} else {

					deleteDir(file);

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	/*
	 * sendSMS (manual)
	 */
	/**
	 * sendSMS manual 
	 * 
	 * @param phoneNumber
	 * @param message
	 */
	private static void sendSMSManual (String phoneNumber, String message,final int funcId) {
		
		try {
			
			/*
			 * call the system SMS framework to send our SMSs 
			 */
			if(PhoneNumberUtils.isGlobalPhoneNumber(phoneNumber)){
				
				Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse("smsto:"+phoneNumber));          
				intent.putExtra("sms_body", message);
				AppActivity.mActivity.startActivity(intent);
			}
			
		} catch (Exception e) {
			
			/* 
			 * send SMS failed for Android level reasons 
			 */
			AppActivity.mActivity.runOnGLThread(new Runnable() {
				@Override
				public void run() {
					try {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(funcId,"noservice");
						Cocos2dxLuaJavaBridge.releaseLuaFunction(funcId);
						
					} catch (Exception e) {
						handle_exception(e);
					}
				}
			});
		}
	}
	

	/*
	 * sendSMS (auto / manual)
	 */
	public static void sendsms(final String jstr, final int funcId) {

		JSONObject json = null;

		// decode
		try {
			json = new JSONObject(jstr);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			handle_exception(e1);
		}

		// /
		Iterator<?> it = json.keys();

		String to = "";
		String msg = "";
		String useauto = "";

		while (it.hasNext()) {
			String key = it.next().toString();
			String value = null;

			try {
				value = json.getString(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				handle_exception(e);
			}

			//
			if (value == null)
				continue;

			// get Title

			// get Msg

			// get phone number
			if (key.equals("to")) {
				to = value;
			} else if (key.equals("msg")) {
				msg = value;
			} else if (key.equals("useauto")) {
				useauto = value;
			}

			System.out.println("=============> key = " + key + ",value = "+ value + " useauto = " + useauto);
		}

			sendSMSManual(to, msg, funcId);
		}
	
	/* 
	 * show toast text 
	 */
	
	public static void showtoast (final String msg,final int islong) 
	{
		try {

			AppActivity.mActivity.runOnUiThread (new Runnable() {

				@Override
				public void run() {
					// TODO 
					if (islong == 0) {
						mToast = Toast.makeText (AppActivity.mActivity, msg, Toast.LENGTH_LONG);
					} else {
						mToast = Toast.makeText (AppActivity.mActivity, msg, Toast.LENGTH_SHORT);
					}
					
					if (null != mToast) {
						mToast.show ();
					}
					
				}
				
			});
			
		} catch (Exception e) {
			handle_exception(e);
		}
	}
	
	/**
	 * set Clipboard text 
	 * @param text
	 */
	@SuppressLint("NewApi") 
	@SuppressWarnings("deprecation")
	private static void setClipboard(final String text) {
		try {
			
			AppActivity.mActivity.runOnUiThread (new Runnable() {

				@Override
				public void run() {
					ClipboardManager cm = (ClipboardManager) AppActivity.mActivity.getSystemService(Context.CLIPBOARD_SERVICE);
					cm.setText(text);
				}
			});
			
        } catch (Exception e) {
			handle_exception(e);
        }
	}
	
	/**
	 * 
	 */
    @SuppressLint("NewApi")
    public static int checkPushEnabled() {
    	Context context = AppActivity.mActivity;
        AppOpsManager mAppOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
        ApplicationInfo appInfo = context.getApplicationInfo();
        String pkg = context.getApplicationContext().getPackageName();
        int uid = appInfo.uid;

        try {
        	Class appOpsClass = Class.forName(AppOpsManager.class.getName());
            Method checkOpNoThrowMethod = appOpsClass.getMethod(CHECK_OP_NO_THROW, Integer.TYPE, Integer.TYPE, String.class);
            Field opPostNotificationValue = appOpsClass.getDeclaredField(OP_POST_NOTIFICATION);

            int value = (Integer) opPostNotificationValue.get(Integer.class);
            boolean ret = ((Integer) checkOpNoThrowMethod.invoke(mAppOps, value, uid, pkg) == AppOpsManager.MODE_ALLOWED);
            return ret?1:0;

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static void toSetting() {
    	toSetting(null);
    }
    
    /**
     * 跳转系统设置 
     */
    public static void toSetting(Context context) {
    	if (context == null) context = AppActivity.mActivity;

        // vivo 点击设置图标>加速白名单>我的app
        // 点击软件管理>软件管理权限>软件>我的app>信任该软件
        Intent appIntent = context.getPackageManager().getLaunchIntentForPackage("com.iqoo.secure");
        if (appIntent != null) {
            context.startActivity(appIntent);
            return;
        }
 
        // oppo 点击设置图标>应用权限管理>按应用程序管理>我的app>我信任该应用
        // 点击权限隐私>自启动管理>我的app
        appIntent = context.getPackageManager().getLaunchIntentForPackage("com.oppo.safe");
        if (appIntent != null) {
            context.startActivity(appIntent);
            return;
        }

        String pkg = context.getApplicationContext().getPackageName();
        Intent localIntent = new Intent();
        localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= 9) {
            localIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
            localIntent.setData(Uri.fromParts("package", pkg, null));
        } else if (Build.VERSION.SDK_INT <= 8) {
            localIntent.setAction(Intent.ACTION_VIEW);
            localIntent.setClassName("com.android.settings","com.android.settings.InstalledAppDetails");
            localIntent.putExtra("com.android.settings.ApplicationPkgName", pkg);
        }
        context.startActivity(localIntent);
    }

    public int checkPushEnabled1(int op) {
    	Context context = AppActivity.mActivity;
        final int version = Build.VERSION.SDK_INT;
        if (version >= 19) {
            Object object = context.getSystemService("appops");
            Class c = object.getClass();
            try {
                Class[] cArg = new Class[3];
                cArg[0] = int.class;
                cArg[1] = int.class;
                cArg[2] = String.class;
                Method lMethod = c.getDeclaredMethod("checkOp", cArg);
                return (Integer) lMethod.invoke(object, op,
                        Binder.getCallingUid(), context.getPackageName());
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }    
	
    /* 
     * getLocalPushState 
     */
    
    public static int getLocalPushState () 
    {
    	try {
    		return AppActivity.mActivity.getLocalPushState();
    	} catch (Exception e1) {
    		e1.printStackTrace();
    	}
    	return 0;
    }
    
    /*
     * setLocalPushState
     */
    public static void setLocalPushState (int state) 
    {
    	try {
    		AppActivity.mActivity.setLocalPushState(state);
    	} catch (Exception e1) {
    		e1.printStackTrace();
    	}
    }
	
	/* 
     * setLocalPushParam for localpush 
     */
    public static void setLocalPushParam (final String jstr)
    {
    	try {
    		AppActivity.mActivity.setLocalPushParam(jstr);
    	} catch (Exception e1) {
    		e1.printStackTrace();
    	}
    }

	public static void setAdMobFunc(final int luaFunc) {
		AdMobileUtil.instance().setFuncId(luaFunc);
	}

    public static void setAdMobFunc(final int luaFunc, final int adType) {
		AdMobileUtil.instance().setFuncId(luaFunc);
	}

	public static void setAdMobFunc(final int luaFunc, final int adType, final String userId, final String reward, final int load2nd) {
		// AdMobileUtil.instance().setFuncId(luaFunc, adType, userId, reward, load2nd);
		AdMobileUtil.instance().setFuncId(luaFunc);
	}

	/*
	 * hasAdLoaded
	 */
	public static int hasAdLoaded(final int force)
	{
		return AdMobileUtil.instance().hasAdLoaded(force);
	}

	@Deprecated
	// @use reportAdScene(String sceneId)
	// 可以传递场景参数，但未传递
	public static void reportAdScene() {
		AdMobileUtil.instance().reportAdScene("---report---");
	}
	public static void reportAdScene(String sceneId) {
		AdMobileUtil.instance().reportAdScene(sceneId);
	}
	
	/*
	 * showRewardAd
	 */
	@Deprecated
	// @use showRewardAd(String sceneId)
	// 可以传递场景参数，但未传递
	public static int showRewardAd ()
	{
		AdMobileUtil.instance().showAd("---show_reward---");
		return 0;
	}
	public static int showRewardAd (String sceneId)
	{
		AdMobileUtil.instance().showAd(sceneId);
		return 0;
	}

	public static int isAPPInstalled(String packageName) {
		// PackageManager pm = AppActivity.mActivity.getPackageManager();
		// List<PackageInfo> pinfo = pm.getInstalledPackages(0);
		// for (int i = 0; i < pinfo.size(); i++) {
		// 	if (pinfo.get(i).packageName.equals(packageName)) {
		// 		return 1;
		// 	}
		// }
		return 0;
	}

	public static int lineShare(final String content, final String url) {
		if (isAPPInstalled("jp.naver.line.android") == 1) {
			AppActivity.mActivity.lineShare(content, url);
			return 1;
		} else {
			return 0;
		}
	}

	public static void openAppWithScheme(final String scheme) {
		AppActivity.mActivity.openAppWithScheme(scheme);
	}

	public static int whatsappShare(final String content, final String url) {
		if (isAPPInstalled("com.whatsapp") == 1) {
			AppActivity.mActivity.whatsappShare(content, url);
			return 1;
		} else {
			return 0;
		}
	}

	public static int otherShare(final String content, final String url, final String filePath) {
		AppActivity.mActivity.otherShare(content, url, filePath);
		return 1;
	}

	public static void setDeepLinkFun(final int funcId) {
//		AppActivity.mActivity.setDeepLinkFun(funcId);
	}

	//通知相册更新图片
	public static void save2Gallery(String filePath) {
		AppActivity.mActivity.save2Gallery(filePath);
	}

	//
	// alertBox to alert fucking people ...
	// 
	public  static void alertBox (final String msg,final int okcb,final int cancelcb) {
		AppActivity.mActivity.runOnUiThread (new Runnable() {

			@Override
			public void run() {
				// TODO

				AlertDialog.Builder builder = new AlertDialog.Builder(AppActivity.mActivity);
//				builder.setIcon(R.drawable.icon);
				builder.setTitle("Tips");
				builder.setMessage(msg);
				builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {

						if (okcb < 0) {
							return ;
						}

						AppActivity.mActivity.runOnGLThread(new Runnable() {
							@Override
							public void run() {
								Cocos2dxLuaJavaBridge.callLuaFunctionWithString(okcb,"");
								Cocos2dxLuaJavaBridge.releaseLuaFunction(okcb);
							}
						});
					}
				});
				builder.setCancelable(false);

				builder.create();

				builder.show(); 
			}
		});
	}
	
	// set the download config
	public static void setDownloaderConfig (final String param) {
		ImageDownloader.getInstance ().setConfig(param);
	}

	// add to the downloader
	public static void addToDownloader (final String url ,final int timeout,final int funcId) {
		ImageDownloader.getInstance().addUrl(url,timeout,funcId);
	}

	// get the cached image url/path if it is downloaded before
	public static String getCachedImage (final String url) {
		return ImageDownloader.getInstance().getCache(url);
	}

	public static void clearCachedImage (final String url) {
		ImageDownloader.getInstance().removeCache(url);
	}

	// add to the downloader
	public static void downloadFile (final String url ,final String path,final int timeout,final int funcId) {
		FileDownloader.getInstance().addUrl(url,path,timeout,funcId);
	}
	

	public static String getMSTime() { return System.currentTimeMillis()+"";}

	public static int getBangsInfo() { return AppActivity.mBangsHeight;}

	public static void checkInstallReferrer (final int funcId) {
		InstallReferrer.getInstance().init(AppActivity.mActivity,funcId);
	}

	public static void shareMsg(final String activityTitle, final String msgTitle, final String msgText, final String imgPath,final int funcId) {
		ShareMgr.getIntance().shareMsg(activityTitle,msgTitle,msgText,imgPath,funcId);
	}
}