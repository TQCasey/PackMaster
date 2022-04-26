package com.zhijian.common;

import android.os.Bundle;
import android.os.RemoteException;
import android.util.Log;

import com.android.installreferrer.api.InstallReferrerClient;
import com.android.installreferrer.api.InstallReferrerStateListener;
import com.android.installreferrer.api.ReferrerDetails;
import com.zhijian.common.utility.JsonUtil;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;

import java.util.TreeMap;

public class InstallReferrer {

    private static InstallReferrer mInstance = null;
    private static InstallReferrerClient referrerClient = null;
    private String tag = "installreferrer";

    public static InstallReferrer getInstance () {
        if (mInstance == null) {
            mInstance = new InstallReferrer();
        }
        return mInstance;
    }

    public void uninit () {
        try {
            if (referrerClient != null) {
                referrerClient.endConnection();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void callLua(final int funcId,String json_param) {
        if (funcId > 0) {
            AppActivity.mActivity.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(funcId, json_param);
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(funcId);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    }

    public void init (AppActivity context,final int luaFuncId) {

        try {
            // if has connection already ,end it first
            if (referrerClient != null) {
                referrerClient.endConnection();
            }

            // build a new one
            referrerClient = InstallReferrerClient.newBuilder(context).build();

            referrerClient.startConnection(new InstallReferrerStateListener() {
                @Override
                public void onInstallReferrerSetupFinished(int responseCode) {

                    TreeMap<String, Object> map = new TreeMap<String, Object>();
                    JsonUtil json = null;
                    String installParamstr = "";

                    switch (responseCode) {
                        case InstallReferrerClient.InstallReferrerResponse.OK:
                            // Connection established.
                            Log.d(tag, "setup succeed");

                            ReferrerDetails response = null;

                            try {
                                response = referrerClient.getInstallReferrer();

                                String referrerUrl = response.getInstallReferrer();
                                long referrerClickTime = response.getReferrerClickTimestampSeconds();
                                long appInstallTime = response.getInstallBeginTimestampSeconds();
                                boolean instantExperienceLaunched = response.getGooglePlayInstantParam();
                                long clickTimestampServerSeconds = response.getReferrerClickTimestampServerSeconds ();
                                long installBeginTimestampServerSeconds = response.getInstallBeginTimestampServerSeconds ();
                                String installVersion = response.getInstallVersion();

                                Log.d(tag, "referrerUrl:" + referrerUrl);
                                Log.d(tag, "referrerClickTime:" + referrerClickTime);
                                Log.d(tag, "appInstallTime:" + appInstallTime);
                                Log.d(tag, "instantExperienceLaunched:" + instantExperienceLaunched);
                                Log.d(tag, "clickTimestampServerSeconds:" + clickTimestampServerSeconds);
                                Log.d(tag, "installBeginTimestampServerSeconds:" + installBeginTimestampServerSeconds);
                                Log.d(tag, "installVersion:" + installVersion);

                                map.put("referrerUrl",referrerUrl);
                                map.put("referrerClickTime",referrerClickTime);
                                map.put("appInstallTime",appInstallTime);
                                map.put("instantExperienceLaunched",instantExperienceLaunched);
                                map.put("clickTimestampServerSeconds",clickTimestampServerSeconds);
                                map.put("installBeginTimestampServerSeconds",installBeginTimestampServerSeconds);
                                map.put("installVersion",installVersion);
                                map.put ("ret","success");

                                json = new JsonUtil(map);
                                installParamstr = json.toString();

                                callLua(luaFuncId,installParamstr);

                            } catch (RemoteException e) {

                                Log.d(tag, "RemoteException:" + e.toString());

                                map.put ("ret","failed");

                                json = new JsonUtil(map);
                                installParamstr = json.toString();
                                callLua(luaFuncId,installParamstr);

                            } catch (Exception e) {
                                Log.d(tag, "Exception:" + e.toString());

                                map.put ("ret","failed");

                                json = new JsonUtil(map);
                                installParamstr = json.toString();
                                callLua(luaFuncId,installParamstr);
                            }

                            break;
                        case InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED:
                            // API not available on the current Play Store app.
                            Log.d(tag, "not supported");

                            map.put ("ret","not supported");

                            json = new JsonUtil(map);
                            installParamstr = json.toString();
                            callLua(luaFuncId,installParamstr);

                            break;

                        case InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE:
                            // Connection couldn't be established.
                            Log.d(tag, "not available");

                            map.put ("ret","not available");

                            json = new JsonUtil(map);
                            installParamstr = json.toString();
                            callLua(luaFuncId,installParamstr);

                            break;
                    }
                }

                @Override
                public void onInstallReferrerServiceDisconnected() {
                    // Try to restart the connection on the next request to
                    // Google Play by calling the startConnection() method.
                    Log.d(tag, "disconnected");

                    TreeMap<String, Object> map = new TreeMap<String, Object>();
                    JsonUtil json = null;
                    String installParamstr = "";

                    map.put ("ret","disconnected");

                    json = new JsonUtil(map);
                    installParamstr = json.toString();
                    callLua(luaFuncId,installParamstr);

                    referrerClient = null;
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
