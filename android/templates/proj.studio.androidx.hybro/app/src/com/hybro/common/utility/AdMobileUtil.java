package com.hybro.common.utility;

import android.content.res.Resources;
import android.os.Handler;
import android.util.Log;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import com.cynking.capsa.R;
import com.hybro.common.MyApplication;

/**
 * utils for ad， include google admob and facebook reward ad
 */
public class AdMobileUtil {
    static AdMobileUtil s_instance = null;
    public AppActivity mActivity = null;
    public static final Resources res = AppActivity.mActivity.getResources();
    public static final String TAG = "admob";
    private static final String TRAD_PLUS_TAG = "tradpluslog";

    private static Handler mHandler = new Handler();
    private static Runnable mRunnable = null;
    private static Runnable mRunnableManualLoad = null;
    private static int retryTimes = 0;
    private boolean isFBReardLoading = false;

    public static int luaFuncId = -1;
    public static String errString = "";
    public static long manualLastLoadTime = 0;
    public static int manualLoadTimes = 0;

    public static AdMobileUtil instance() {
        if (s_instance == null)
            s_instance = new AdMobileUtil();
        return s_instance;
    }

    public void init(AppActivity act) {

    }

    /**
     * reportAdScene 用户进入广告场景时调用，用于统计广告场景触达率。
     */
    public void reportAdScene(String sceneId) {

    }

    /**
     * @param id     callback id
     */
    public void setFuncId(int id) {
        luaFuncId = id;

        AppActivity.mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {

            }
        });
    }

    public static String getCurError(){
        return s_instance.errString;
    }

    /*
     * hasAdLoaded
     */
    public static int hasAdLoaded(final int force) {
        return 0;
    }

    public void stopTimer() {
        try {
            if (mRunnable != null) {
                mHandler.removeCallbacks(mRunnable);
                mRunnable = null;
            }
        } catch (NullPointerException e) {

        } catch (Exception e) {

        }
    }

    public void showAd(String sceneId) {
        AppActivity.mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {

                } catch (NullPointerException e) {
                    Log.i(TAG, e.toString());
                    errString = "show NullPointerException";
                } catch (Exception e) {
                    Log.i(TAG, e.toString());
                    errString = "show Exception";
                }
            }
        });
    }

    public void callLua(final String flag) {
        if (luaFuncId <= 0) return;
        mActivity.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                try {
                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId, flag);
                } catch (NullPointerException e) {

                } catch (Exception e) {

                }
            }
        });
    }

    public static boolean isGooglePlayServiceAvailable() {
        try {
            int status = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(AppActivity.mActivity);
            if (status == ConnectionResult.SUCCESS) {
                Log.i(TAG, "GooglePlayServicesUtil service is available.");
                return true;
            } else {
                Log.i(TAG, "GooglePlayServicesUtil service is NOT available.");
                return false;
            }
        } catch (NullPointerException e) {

        } catch (Exception e) {

        }
        return false;
    }

    public void onResume() {

    }

    public void onDestroy() {

    }
}
