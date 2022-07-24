package com.hybro.common;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.util.Log;

import com.cynking.capsa.R;

import org.cocos2dx.lua.AppActivity;
import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.util.Calendar;

import androidx.core.app.NotificationCompat;

public class LocalPushService extends Service {
	
	public class AlarmInfo {
		
		long 	stime;
		long 	etime;
		String 	title;
		String  content;
		
		public AlarmInfo () 
		{
			stime = 0;
			etime = 0;
			title = "";
			content = "";
		}
		
	}
	
	private static int m_notifiId 				= 1000;
	
	private static final int maxAlaram 		= 4;
	private static AlarmInfo [] m_alarmInfo 		= null;
	
	private static Handler m_handler				= null;
	private static Runnable m_runnable 			= null;
	private static int CHECK_MSEC					= 1000 * 60 * 30; 	// 30 min
	
	private static String dtag 					= "LocalPushService";
	private static int m_checkPushState 			= 0;
	
	/* 
	 * Messager 
	 */
    private static final int MSG_ID 			= 1;
    private static final int REPLY_MSG_ID 		= 2;
    
    static class BoundServiceHandler extends Handler{
        private final WeakReference<LocalPushService> mService;
        public BoundServiceHandler(LocalPushService service){
            mService = new WeakReference<LocalPushService>(service);
        }
        @Override
        public void handleMessage(Message msg) {
            switch(msg.what){
            case MSG_ID:
            	m_checkPushState = msg.arg1;
            	Log.d(dtag, "LocalPushService.pushState = " + msg.arg1);
                break;
                
            default:
                    super.handleMessage(msg);
            }
        }
    }
    private final Messenger mMessenger = new Messenger(new BoundServiceHandler(this));
    @Override
    public IBinder onBind(Intent intent) {
    	
    	Log.d(dtag, "onBind");
		init_pushparam (intent);
		startTimer ();
        
		return mMessenger.getBinder();
    }
	
	@Override
	public void onStart(Intent intent, int startId) {
		
		Log.d(dtag, "onStart");
		super.onStart(intent, startId);
	}
	
	public void showNotification(String title,String content, String rid, String tid,String param){
		
		Intent intent = new Intent(this, AppActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        
        if(rid != null && rid.length() > 0 && tid != null && tid.length() > 0){
        	intent.putExtra("rid", rid);
        	intent.putExtra("tid", tid);
        }
        
        if (param != null && param.length() > 0) {
        	intent.putExtra("param", param);
        }
        
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

//        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.icon)
                .setContentTitle(title)
                .setContentText(content)
                .setAutoCancel(true)
//                .setSound(defaultSoundUri)
                .setDefaults(Notification.DEFAULT_ALL)
                .setContentIntent(pendingIntent);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        m_notifiId++;
        //Log.v("LocalPushService", "m_notifiId = " + m_notifiId);
        notificationManager.notify(m_notifiId /* ID of notification */, notificationBuilder.build());
	}
	
	public void showNotice (final String title,final String content, final String rid, final String tid,final String param)
	{
		try {
			showNotification (title,content,rid,tid,param);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	@Override
	public void onCreate() {
		
		Log.d(dtag, "onCreate");
		
		super.onCreate();
		
		try {
			m_alarmInfo = new AlarmInfo [maxAlaram]; 
			for (int i = 0 ; i < maxAlaram ; i ++) {
				m_alarmInfo [i] = new AlarmInfo();
			}
			
			// timer 
			m_handler	=	new Handler(); 
			
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	private void startTimer () 
	{
		if (null == m_handler) 
			return ;
		
		Log.d(dtag, "startTimer");
		
		try {
			
			// cancel previous timer
			if (null != m_runnable) {
				Log.d(dtag, "remove old runnable");
				m_handler.removeCallbacks(m_runnable);
			}
			
			Log.d(dtag, "create new runnable");
			
			// create new timer 
			m_runnable	=	new Runnable() {  
			    @Override  
			    public void run() {  
			        // TODO Auto-generated method stub  
			    	
			    	Log.d(dtag, "checkTimeIndex");
			    	
			    	final AlarmInfo ai = getInTimeIndex ();
			    	if (ai != null) {
			    		
		                if (m_checkPushState > 0) {
		                	Log.d(dtag, "in time,show the notice we have");
		                	showNotice(ai.title, ai.content, "", "", "");
		                } else {
		                	Log.d(dtag, "in time,but pushState is off");
		                }
			    		
			    	}
			    	
			    	m_handler.postDelayed(this, CHECK_MSEC);  
			    }  
			};  
			
			/* start right now */
			Log.d(dtag, "start runnable");
			
			/* for the on/off command came later than the pushService 
			 * so we delay to start the pushService 
			 */
			m_handler.postDelayed(m_runnable, 15 * 1000);
			
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	// 
	private AlarmInfo getInTimeIndex () 
	{
		try {
			Calendar instance = Calendar.getInstance();
			long emsec = instance.getTimeInMillis() / 1000;
			
			instance.set(Calendar.HOUR_OF_DAY, 00);
			instance.set(Calendar.MINUTE, 00);
			instance.set(Calendar.SECOND, 00);
			
			long smsec = instance.getTimeInMillis() / 1000;
			long tdiff = emsec - smsec ;
			
			for (int i = maxAlaram - 1 ; i >= 0 ; i --) {
				
				AlarmInfo ai = m_alarmInfo [i];
				
				if (ai != null) {
					
					Log.d(dtag, "check time : tdiff = " + tdiff + " , stime = " + ai.stime + " etime = " + ai.etime);
					if (ai.stime > 0 && ai.etime > 0 && ai.stime <= tdiff && tdiff <= ai.etime) {
						return ai;
					}
					
				}
				
			}
		} catch (Exception e1) {
			e1.printStackTrace();
			return null;
		}
		return null;
	}
	
	private void init_pushparam (Intent intent) 
	{
		try {

			Bundle b = intent.getExtras();
			String jstr = b.getString("pushparam");

			JSONArray jsonArray = new JSONArray(jstr);
			for (int i = 0; i < jsonArray.length(); i++) {

				JSONObject jsonObject = jsonArray.getJSONObject(i);
				
				if (null != jsonObject) {

					int stime 		= jsonObject.getInt("stime");
					int etime 		= jsonObject.getInt("etime");
					String title 	= jsonObject.getString("title");
					String content 	= jsonObject.getString("content");
	
					AlarmInfo ai = m_alarmInfo [i];
					
					if (null != ai) {
						ai.stime 	= stime;
						ai.etime 	= etime;
						ai.title 	= title;
						ai.content 	= content;
						
						Log.d(dtag, "idx = " + i + ": stime = " + stime + ",etime = " + etime + ",title = " + title + ",content = " + content);
					}
					
				}
			}

		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		Log.d(dtag, "onStartCommand");
		return super.onStartCommand(intent, flags, startId);
	}
	
	@Override
	public void onDestroy() {
		Log.d(dtag, "onDestroy");
		super.onDestroy();
	}

}
