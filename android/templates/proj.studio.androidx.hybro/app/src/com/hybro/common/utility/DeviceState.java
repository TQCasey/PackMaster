package com.hybro.common.utility;

import java.util.TreeMap;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.BatteryManager;
import android.os.Parcel;
import android.telephony.PhoneStateListener;
import android.telephony.SignalStrength;
import android.telephony.TelephonyManager;

public class DeviceState {
	
	private static DeviceState	mInstance 			= new DeviceState ();
	private Context				mCtx				= null;
	
	private ConnectivityManager mConnMgr			= null;
	
	/* for battery */
	private BroadcastReceiver  	batteryLevelRcvr 	= null;
	private int 				mBatteryLevel 		= 0;		/* 0 ~ 100 , -1 for charging -2 for charging full */
	private boolean 			bCharging 			= false;
	private boolean 			bChargeFull			= false;
	
	/* for wifi */
	private WifiManager 		mWifiManager 		= null;
	private BroadcastReceiver  	wifiLevelRcvr 		= null;
	private int 				mWifiLevel 			= 0;
	private int 				mLinkSpeed 			= 0;
	private String 				strUnit				= "";
	
	/* for GPRS */
	private int 				mSignalLevel 		= 0;
	private TelephonyManager	mTelManager 		= null;
	MyPhoneStateListener 		mTelListener 		= null;
	
	/* for macro */
	int 						RANGE				= 100;
	
	
	/* checkInited () */
	private boolean checkInited () {
		return mCtx != null;
	}

	/* getInstance () */
	public static DeviceState getInstance () {
		return mInstance;
	}
	
	/* onDestroy () */
	public void onDestroy() {
		unregisterRcver();
	}
	
	/* onPause () */
	public void onPause () {
		unregisterRcver();
	}
	
	/* onResume */
	public void onResume () {
		registerRcver();
	}
	
	/* Init () */
	public DeviceState Init (Context ctx) {
		
		if (checkInited ()) 
			return mInstance;
		
		mCtx = ctx;
		registerRcver();
		
		mConnMgr 		= (ConnectivityManager)mCtx.getSystemService(Context.CONNECTIVITY_SERVICE);		// 
		mWifiManager	= (WifiManager) mCtx.getSystemService(mCtx.WIFI_SERVICE); 						// ȡ��WifiManager����
		mTelManager		= (TelephonyManager) mCtx.getSystemService(Context.TELEPHONY_SERVICE);			
		mTelListener	=  new MyPhoneStateListener();
		
		return mInstance;
	}
	
	private class MyPhoneStateListener extends PhoneStateListener  {
		
		@Override
		public void onSignalStrengthsChanged(SignalStrength signalStrength) {
			super.onSignalStrengthsChanged(signalStrength);
			
			try {
				Parcel out = Parcel.obtain();
				signalStrength.writeToParcel(out, 0);
				
				MySignalStrength mss = new MySignalStrength(out);
				
				mSignalLevel = mss.getLevel();
			} catch (Exception e) {
				//
			}
		}
    };/* End of private Class */  
	
	/* registerRcver () */
	private void registerRcver () {
		if (!checkInited ()) 
			return ;
		
		try {
			monitorBatteryState ();
			monitorWifiState ();
			
			if (null != mTelListener) {
				mTelManager.listen(mTelListener, PhoneStateListener.LISTEN_SIGNAL_STRENGTHS);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/* unregisterRcver () */
	private void unregisterRcver () {
		if (!checkInited ()) 
			return ;
		
		try {
			mCtx.unregisterReceiver (batteryLevelRcvr);
			mCtx.unregisterReceiver (wifiLevelRcvr);
			
			if (null != mTelListener) {
				mTelManager.listen(mTelListener, PhoneStateListener.LISTEN_NONE);  
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/* battery receiver () */
	private void monitorBatteryState() {
		
		if (null == batteryLevelRcvr) {
			batteryLevelRcvr = new BroadcastReceiver() {

			public void onReceive(Context context, Intent intent) {
				
				int rawlevel 	= intent.getIntExtra("level", -1);
                int scale 		= intent.getIntExtra("scale", -1);
                int status 		= intent.getIntExtra("status", -1);
                int level 		= -1;
                
                if (rawlevel >= 0 && scale > 0) {
                    level = (rawlevel * 100) / scale;
                }
                
                mBatteryLevel 	= level ;
                bCharging	  	= false;
                bChargeFull		= false;

                switch (status) {
                case BatteryManager.BATTERY_STATUS_CHARGING:			/* is charging */
                	bCharging = true;
                    break;
                case BatteryManager.BATTERY_STATUS_FULL:				/* charging full */
                	bChargeFull = true;
                    break;
                default:
                    break;
                }
			}
		};
		}
		
		IntentFilter 		batteryLevelFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		mCtx.registerReceiver (batteryLevelRcvr, batteryLevelFilter);
	}
	
	public String getBatteryInfo () {

		TreeMap<String, Object> map = new TreeMap<String, Object>();
		
		map.put("charging", bCharging);
		map.put("chargefull", bChargeFull);
		map.put("level", mBatteryLevel);
		
		JsonUtil json = new JsonUtil(map);
		final String binfo = json.toString();
		
		return binfo;
	}
	
	/* wifi receiver */
	private void monitorWifiState () {
		
		if (null == wifiLevelRcvr) {
			
			wifiLevelRcvr = new BroadcastReceiver () {

				@Override
				public void onReceive(Context context, Intent intent) {
					
					try {
						if (null != mWifiManager) {
					        WifiInfo info 	= mWifiManager.getConnectionInfo();
					        
					        if (null != info && info.getBSSID() != null) {
					        	
					            mWifiLevel 	=  	WifiManager.calculateSignalLevel(info.getRssi(), RANGE);
					            mLinkSpeed	= 	info.getLinkSpeed();
					            strUnit		= 	info.LINK_SPEED_UNITS;
					            
					        }
						}
					} catch (Exception e) {
						
					}
				}
				
			};
			
		}
		
		IntentFilter 		wifiLevelFilter = new IntentFilter(WifiManager.RSSI_CHANGED_ACTION);
		mCtx.registerReceiver (wifiLevelRcvr, wifiLevelFilter);
		
	}
	
	public String getNetWorkInfo () {
		
		//
		TreeMap<String, Object> map = new TreeMap<String, Object>();
		
		if (null == mConnMgr || null == mWifiManager) {
			
			map.put("type", "OFFLINE");
			
		} else {
		
	        NetworkInfo networkInfo 		= mConnMgr.getActiveNetworkInfo ();
	        
	        if (null == networkInfo) {
	        	map.put("type", "OFFLINE");
	        } else {
	        
		        int 	nType 					= networkInfo.getType();
				
		        if (nType == ConnectivityManager.TYPE_MOBILE) {
		        	
		        	// GPRS 
		        	map.put("type", "GPRS");
		        	map.put("level", mSignalLevel * 20);
		        	
		        } else if (nType == ConnectivityManager.TYPE_WIFI) {
		        	
		        	// WIFI 
		        	map.put("type", "WIFI");
		        	map.put("level", mWifiLevel);
		        	map.put("linkspeed",mLinkSpeed);
		        	map.put("unit",strUnit);
		        	
		        } else {
		        	
		        	// check the on/off line status 
		        	
		        	try {
						State GPRSState = mConnMgr.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).getState();
						State WIFIState = mConnMgr.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState();
						
						if (State.CONNECTED != GPRSState && State.CONNECTED != WIFIState) {
				        	
							// offline 
				        	map.put("type", "OFFLINE");
				        	
						} else {
							
							// nType
				        	map.put("type", nType);
						}
		        	} catch (Exception e) {
		        		
		        		// OFFLINE 
		        		map.put("type", "OFFLINE");
		        	}
		        }
	        }
		}
        
		JsonUtil json = new JsonUtil(map);
		final String netinfo = json.toString();
		return netinfo;
	}
}
