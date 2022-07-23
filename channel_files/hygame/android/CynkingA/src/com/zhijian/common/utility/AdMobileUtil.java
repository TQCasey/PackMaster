package com.zhijian.common.utility;

import android.content.res.Resources;
import android.os.Handler;
import android.util.Log;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import com.cynking.capsa.R;
import com.zhijian.common.MyApplication;

import com.tradplus.ads.open.TradPlusSdk;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.open.reward.RewardAdListener;
import com.tradplus.ads.open.reward.TPReward;
//import com.tradplus.ads.base.common.TPError;
//import com.tradplus.ads.mobileads.TradPlusInterstitial;
//import com.tradplus.ads.mobileads.util.TestDeviceUtil;
//import com.tradplus.ads.network.OnAllInterstatitialLoadedStatusListener;
//import com.tradplus.ads.mobileads.TradPlusInterstitialExt;
//import com.tradplus.ads.open.interstitial.InterstitialAdListener;
//import com.tradplus.ads.open.interstitial.TPInterstitial;
//import com.tradplus.ads.open.LoadAdEveryLayerListener;
//import com.tradplus.ads.network.CanLoadListener;
//import com.tradplus.ads.mobileads.TradPlus;

/**
 * utils for ad， include google admob and facebook reward ad
 */
public class AdMobileUtil {
    static AdMobileUtil s_instance = null;
    public AppActivity mActivity = null;
    public static final Resources res = AppActivity.mActivity.getResources();
    public static final String TAG = "admob";
    private static final String TRAD_PLUS_TAG = "tradpluslog";
    public static final String tradPlus_adUnitId = (String) res.getText(R.string.tradPlus_adUnitId);
    public static final String tradPlus_appId = (String) res.getText(R.string.tradPlus_appId);

    private static Handler mHandler = new Handler();
    private static Runnable mRunnable = null;
    private static Runnable mRunnableManualLoad = null;
    private static int retryTimes = 0;
    private boolean isFBReardLoading = false;
    private TPReward mTpReward;

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
        String disable_tp = (String) res.getText(R.string.disable_tradeplus);
        if (!disable_tp.equals("yes")) {
            TradPlusSdk.initSdk(MyApplication.getInstance(), tradPlus_appId);
            TradPlusSdk.setIsCNLanguageLog(true);
            // @Deprecate 5.x
            // TradPlus.invoker().initSDK(MyApplication.getInstance(), tradPlus_appId);
            // 用于测试FB广告，正式线需要去除
            // TestDeviceUtil.getInstance().setNeedTestDevice(true);
        }
        if (mActivity == null) {
            mActivity = act;
        }
    }

    /**
     * reportAdScene 用户进入广告场景时调用，用于统计广告场景触达率。
     */
    public void reportAdScene(String sceneId) {
        if(mTpReward != null) {
            mTpReward.entryAdScenario(sceneId);
        }

        /*@Deprecated 5.x
        if (mTradPlusInterstitial != null) {
            mTradPlusInterstitial.entryAdScenario();
        }*/
    }

    /**
     * @param id     callback id
     */
    public void setFuncId(int id) {
        luaFuncId = id;

        AppActivity.mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                delayLoadNext();
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
        if(s_instance.mTpReward != null && s_instance.mTpReward.isReady()) {
            //@Deprecate 5.x
        //if (s_instance.mTradPlusInterstitial != null && s_instance.mTradPlusInterstitial.isReady()) {
            Log.d(TAG, "hasAdLoaded = 1");
            return  1;
        } else {
            if (force == 1 ) {
            s_instance.stopTimer();
            s_instance.loadAd();
        }
            Log.d(TAG, "hasAdLoaded = 0");
            return  0;
    }
    }

    public void loadAd() {
        AppActivity.mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(TRAD_PLUS_TAG, "loadAd");
                try {
                    if (mTpReward == null) {
                        mTpReward = new TPReward(AppActivity.mActivity, tradPlus_adUnitId, true);
                        mTpReward.setAdListener(new RewardAdListener() {
                            @Override
                            public void onAdLoaded(TPAdInfo tpAdInfo) {
                                Log.i(TRAD_PLUS_TAG, "onAdLoaded: " + tpAdInfo.toString());
                                isFBReardLoading = false;
                            }

                            @Override
                            public void onAdFailed(TPAdError tpAdError) {
                                Log.i(TRAD_PLUS_TAG, "onAdFailed: " + tpAdError.getErrorMsg());
                                isFBReardLoading = false;
                            }

                            @Override
                            public void onAdImpression(TPAdInfo tpAdInfo) {
                                Log.i(TRAD_PLUS_TAG, "onAdImpression: " + tpAdInfo.toString());
                                callLua("play suc");
                                isFBReardLoading = false;
                            }

                            @Override
                            public void onAdClicked(TPAdInfo tpAdInfo) {
                                Log.i(TRAD_PLUS_TAG, "onAdClicked: " + tpAdInfo.toString());
                            }

                            @Override
                            public void onAdClosed(TPAdInfo tpAdInfo) {
                                Log.i(TRAD_PLUS_TAG, "onAdClosed: " + tpAdInfo.toString());
                                Log.i(TRAD_PLUS_TAG, "should show reward: " + (isFBReardLoading ? "true" : "false"));
                                if (isFBReardLoading) {
                                    callLua("closed");
                                }
                            }

                            @Override
                            public void onAdReward(TPAdInfo tpAdInfo) {
                                // 给用户发放奖励
                                // 在V6.4.5以后的版本，可以根据三方广告平台的文档来增加奖励验证功能（奖励验证需要开发者后台配合，TradPlus不提供后台服务奖励验证的功能）
                                Log.i(TAG, "onAdReward: ：" + tpAdInfo.toString());
                                isFBReardLoading = true;
                                callLua("reward");
                                }

                            @Override
                            public void onAdVideoError(TPAdInfo tpAdInfo, TPAdError tpAdError) {
                                Log.i(TRAD_PLUS_TAG, "onAdVideoError: " + tpAdInfo.toString());
                                isFBReardLoading = true;
                            }

                            @Override
                            public void onAdPlayAgainReward(TPAdInfo tpAdInfo) {
                                // play again
                            }

                        });
                    } else {
                        mTpReward.loadAd();
                    }
                } catch (NullPointerException e) {
                    errString = "load NullPointerException";
                    Log.i(TAG, e.toString());
                } catch (Exception e) {
                    errString = "load Exception";
                    Log.i(TAG, e.toString());
                }
            }
        });
    }

    public void delayManualLoadAd () {
        AppActivity.mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                long diffTime = System.currentTimeMillis() - manualLastLoadTime;
                Log.d(TAG, "delayManualLoadAd");
                Log.d(TAG, "diffTime:" + diffTime);
                Log.d(TAG, "manualLoadTimes:" + manualLoadTimes);

                if (mRunnableManualLoad == null && manualLoadTimes < 3) {
                    mRunnableManualLoad = new Runnable() {
                        public void run() {
                            if (mTpReward != null) {
                                Log.d(TAG, "mTradPlusInterstitial.load");
                                mTpReward.loadAd();
                                manualLoadTimes = manualLoadTimes + 1;
                                manualLastLoadTime = System.currentTimeMillis();
                                mRunnableManualLoad = null;
                            }
                        }
                    };
                    long delayTime = diffTime > 20000 ? 0 : 20000 - diffTime;
                    Log.d(TAG, "delayTime:" + delayTime);
                    mHandler.postDelayed(mRunnableManualLoad, delayTime);
                }
            }
        });
    }

    public void delayLoadNext() {
        errString = "waiting";
        if (mRunnable == null) {
            mRunnable = new Runnable() {
                public void run() {
                    loadAd();
                    stopTimer();
                }
            };
            mHandler.postDelayed(mRunnable, 10000);
        }
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
                    if (mTpReward != null) {
                        stopTimer();
                        Log.i(TRAD_PLUS_TAG, "展示广告");
                        mTpReward.showAd(AppActivity.mActivity, sceneId);
                    }
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
        if (mTpReward != null ) {
            try {
                //mTpReward.onResume();
            } catch (NullPointerException e) {

            } catch (Exception e) {

            }
        }
    }

    public void onDestroy() {
        if (mTpReward != null ) {
        try {
            //mTpReward.onDestroy();
        } catch (NullPointerException e) {

        } catch (Exception e) {

            }
        }
    }
}
