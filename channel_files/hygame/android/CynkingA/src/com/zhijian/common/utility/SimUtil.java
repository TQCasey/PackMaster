package com.zhijian.common.utility;

import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.Reader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.Locale;
import java.util.UUID;

import org.cocos2dx.lua.AppActivity;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;

/**
 * SIM閸椻�充紣閸忛琚�
 * 
 * @author wujichang
 */
public class SimUtil {
	
	// 娌℃湁sim鍗�
	public static final int SIM_TYPE_NONE = -1;
	/**
	 * TELKOMSEL
	 */
	public static final int SIM_TYPE_TELKMOESL = 1;
	/**
	 * XL
	 */
	public static final int SIM_TYPE_XL = 2;
	/**
	 * INDOSAT
	 */
	public static final int SIM_TYPE_INDOSAT = 3;
	/**
	 * h3i
	 */
	public static final int SIM_TYPE_H3I = 4;
	
	public static int getSimType() {
		int type = SIM_TYPE_NONE;
		try {
		if (isCanUseSim()) {
	//			String imsi = getSimOperator();
	//			if (imsi != null && imsi.length() > 0){
	//				if(imsi.startsWith("51010")){
	//					type = SIM_TYPE_TELKMOESL;
	//				}else if(imsi.startsWith("51011")){
	//					type = SIM_TYPE_TELKMOESL;
	//				}else if(imsi.startsWith("51021")){
	//					type = SIM_TYPE_INDOSAT;
	//				}
	//			}
			TelephonyManager tm = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
					Context.TELEPHONY_SERVICE);
			String imsi = tm.getNetworkOperatorName();
			if (imsi != null && imsi.length() > 0){
				Locale defloc = Locale.getDefault();
				imsi = imsi.toLowerCase(defloc);
				if(imsi.contains("telkomsel")){
					type = SIM_TYPE_TELKMOESL;
				}else if(imsi.contains("xl")){
					type = SIM_TYPE_XL;
				}else if(imsi.contains("indosat")){
					type = SIM_TYPE_INDOSAT;
				}else if(imsi.contains("3")){
					type = SIM_TYPE_H3I;
				}
			}
		}
		} catch (Exception e) {
			//
		}
		return type;
	}
	
	/** 鑾峰彇鎵嬫満IMSI鍙风爜 */
	public static String getSimOperator() {
		String imsi = null;
		try {
		TelephonyManager telephonyManager = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
				Context.TELEPHONY_SERVICE);
		if (telephonyManager != null) {
			imsi = telephonyManager.getSubscriberId();
		}
		if (imsi == null){
			imsi = "";
		}
		} catch (Exception e) {
			
		}
		return imsi;
	}

	/** 鑾峰彇鎵嬫満IMSI鍙风爜 */
	public static String getNetworkCountryIso() {
		String iso = null;
		try {
			TelephonyManager telephonyManager = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
					Context.TELEPHONY_SERVICE);
			if (telephonyManager != null) {
				iso = telephonyManager.getNetworkCountryIso();
			}
			if (iso == null){
				iso = "";
			}
		} catch (Exception e) {

		}
		return iso;
	}

	/** 鑾峰彇鎵嬫満IMSI鍙风爜 */
	public static String getNetworkOperator() {
		String iso = null;
		try {
			TelephonyManager telephonyManager = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
					Context.TELEPHONY_SERVICE);
			if (telephonyManager != null) {
				iso = telephonyManager.getNetworkOperator();
			}
			if (iso == null){
				iso = "";
			}
		} catch (Exception e) {

		}
		return iso;
	}

	/**
	 * 鑾峰緱imei锛屽鏋滄棤娉曡幏寰椾細杩斿洖wifi mac銆傚鏋滈兘娌℃湁锛岃繑鍥�""
	 */
	public static String getDeviceId() {
		String imei = null;
		try {
		TelephonyManager telephonyManager = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
				Context.TELEPHONY_SERVICE);
		if (telephonyManager != null) {
			imei = telephonyManager.getDeviceId();
		}
		if (imei == null) {
			WifiManager mgr = (WifiManager) AppActivity.mActivity.getApplication().getSystemService(
					Context.WIFI_SERVICE);
			if (mgr != null) {
				WifiInfo wifiinfo = mgr.getConnectionInfo();
				if (wifiinfo != null) {
					imei = wifiinfo.getMacAddress();
				}
			}
		}
		if (imei == null) {
			String androidId = DeviceInfo.getAndroidID();
			if (androidId == null) 
				imei = getUniquePsuedoID();
			else
				imei = "androidId" + androidId;
		}
		
		System.out.println("getDeviceId imei = " + imei);
		} catch (Exception e) {
//			imei = ""
		}
		return imei;
	}
	
	/**
	 * 鑾峰彇鎵嬫満鐨凪AC鍦板潃
	 * 
	 * @return
	 */
	public static String getMacId () {
		String str = "";
		String macSerial = "";
		try {
			Process pp = Runtime.getRuntime().exec(
					"cat /sys/class/net/wlan0/address ");
			InputStreamReader ir = new InputStreamReader(pp.getInputStream());
			LineNumberReader input = new LineNumberReader(ir);

			for (; null != str;) {
				str = input.readLine();
				if (str != null) {
					macSerial = str.trim();// 鍘荤┖鏍�
					break;
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		if (macSerial == null || "".equals(macSerial)) {
			try {
				return loadFileAsString("/sys/class/net/eth0/address")
						.toUpperCase().substring(0, 17);
			} catch (Exception e) {
				e.printStackTrace();

			} finally {
				return "";
			}

		}
		
		System.out.println("============> " + macSerial.toString());
		return macSerial;
	}
	
	public static String loadFileAsString(String fileName) throws Exception {
		FileReader reader = new FileReader(fileName);
		String text = loadReaderAsString(reader);
		reader.close();
		return text;
	}

	public static String loadReaderAsString(Reader reader) throws Exception {
		StringBuilder builder = new StringBuilder();
		char[] buffer = new char[4096];
		int readLength = reader.read(buffer);
		while (readLength >= 0) {
			builder.append(buffer, 0, readLength);
			readLength = reader.read(buffer);
		}
		return builder.toString();
	}	

	
	/*
	public static String getMacId() {
		String macdress = null;
		WifiManager mgr = (WifiManager) AppActivity.mActivity.getApplication().getSystemService(
					Context.WIFI_SERVICE);
		if (mgr != null) {
			WifiInfo wifiinfo = mgr.getConnectionInfo();
			if (wifiinfo != null) {
				macdress = wifiinfo.getMacAddress();
			}
		}
		if (macdress == null) {
			macdress = "";
		}
		return macdress;
	}
	
	*/

	/** 鑾峰彇鎵嬫満鐢佃瘽鍙风爜 */
	public static String getPhoneNumbers() {
		String phoneNum = "";
		
		try {
		TelephonyManager telephonyManager = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
				Context.TELEPHONY_SERVICE);
			
		if (telephonyManager != null) {
			phoneNum = telephonyManager.getLine1Number();
		}
		} catch (Exception e) {
			//
		}
		return phoneNum;
	}

	// sim鍗℃槸鍚﹀彲璇�
	public static boolean isCanUseSim() {
		try {
			TelephonyManager mgr = (TelephonyManager) AppActivity.mActivity.getApplication().getSystemService(
					Context.TELEPHONY_SERVICE);

			return TelephonyManager.SIM_STATE_READY == mgr.getSimState();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 鑾峰彇璁惧mac鍦板潃
	 * 
	 * @return
	 */
	public static String getLocalMacAddress() {
		String mac = "";
		
		try {
		WifiManager wifi = (WifiManager) AppActivity.mActivity.getSystemService(Context.WIFI_SERVICE);
		WifiInfo info = wifi.getConnectionInfo();
			mac = info.getMacAddress();
		if (mac == null) {
			mac = "";
		}
		} catch (Exception e) {
			
		}
		return mac;
	}

	/**
	 * 鑾峰彇鏈満IP鍦板潃
	 * 
	 * @return
	 */
	public static String getLocalIpAddress() {
		String ip = "";
		try {
			for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
				NetworkInterface intf = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					if (!inetAddress.isLoopbackAddress()) {
						ip = inetAddress.getHostAddress().toString();
					}
				}
			}
		} catch (SocketException ex) {
			ex.printStackTrace();
		}
		return ip;
	}
	
	//鑾峰緱鐙竴鏃犱簩鐨凱suedo ID
	public static String getUniquePsuedoID() {
       String serial = null;

       String m_szDevIDShort = "35" + (Build.BOARD.length() % 10) + (Build.BRAND.length() % 10) + (Build.CPU_ABI.length() % 10) + (Build.DEVICE.length() % 10) + (Build.MANUFACTURER.length() % 10) + (Build.MODEL.length() % 10) + (Build.PRODUCT.length() % 10);

	    try {
	        serial = android.os.Build.class.getField("SERIAL").get(null).toString();
	       //API>=9 浣跨敤serial鍙�
	        return new UUID(m_szDevIDShort.hashCode(), serial.hashCode()).toString();
	    } catch (Exception exception) {
	        //serial闇�瑕佷竴涓垵濮嬪寲
	        serial = "cynking"; // 闅忎究涓�涓垵濮嬪寲
	    }
	    //浣跨敤纭欢淇℃伅鎷煎噾鍑烘潵鐨�15浣嶅彿鐮�
	    return new UUID(m_szDevIDShort.hashCode(), serial.hashCode()).toString();
	}
	
}
