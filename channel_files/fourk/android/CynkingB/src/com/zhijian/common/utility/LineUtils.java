package com.zhijian.common.utility;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;
import android.content.res.Resources;

import com.linecorp.linesdk.LineAccessToken;
import com.linecorp.linesdk.LineApiResponse;
import com.linecorp.linesdk.LineCredential;
import com.linecorp.linesdk.LineProfile;
import com.linecorp.linesdk.api.LineApiClient;
import com.linecorp.linesdk.api.LineApiClientBuilder;
import com.linecorp.linesdk.auth.LineLoginApi;
import com.linecorp.linesdk.auth.LineLoginResult;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import com.zhijian.domino.R;

import java.util.List;
import java.util.TreeMap;

public class LineUtils {
    private static LineUtils s_LineUtils = null;
    private static AppActivity act = null;
    private LineApiClient lineApiClient;
    private static final Resources res = AppActivity.mActivity.getResources();
    private static final String CHANNEL_ID = (String)res.getText(R.string.line_app_id);
    private int m_curLuaFuncId = -1;

    public LineUtils(){
        act = AppActivity.mActivity;
        LineApiClientBuilder apiClientBuilder = new LineApiClientBuilder(act.getApplicationContext(), CHANNEL_ID);
        lineApiClient = apiClientBuilder.build();
    }

    public static LineUtils getInstance(){
        if (s_LineUtils == null)
            s_LineUtils = new LineUtils();

        return s_LineUtils;
    }

    public void lineLogin(final int luaFunc) {
        m_curLuaFuncId = luaFunc;
        try {
            Intent loginIntent;

            if (isAPPInstalled()) loginIntent = LineLoginApi.getLoginIntent(act, CHANNEL_ID);
            else loginIntent = LineLoginApi.getLoginIntentWithoutLineAppAuth(act, CHANNEL_ID);

//            loginIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            act.startActivityForResult(loginIntent, act.LINE_REQUEST_CODE);
        } catch (Exception e) {
            Log.e("line", e.toString());
        }
    }

    public void lineLogout(final int luaFunc) {
        LineApiResponse apiResponse = lineApiClient.logout();

        if(apiResponse.isSuccess()){
            Toast.makeText(act.getApplicationContext(), "Logout Successful", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(act.getApplicationContext(), "Logout Failed", Toast.LENGTH_SHORT).show();
            Log.e("line", "Logout Failed: " + apiResponse.getErrorData().toString());
        }
    }

    public void refreshTokenTask() {
        LineApiResponse<LineAccessToken> response = lineApiClient.refreshAccessToken();

        if (response.isSuccess()) {
            String updatedAccessToken = lineApiClient.getCurrentAccessToken().getResponseData().getAccessToken();

            // Update the view
//			TextView accessTokenField = (TextView) findViewById(R.id.accessTokenField);
//			accessTokenField.setText(updatedAccessToken);
            Toast.makeText(act.getApplicationContext(), "Access Token has been refreshed.", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(act.getApplicationContext(), "Could not refresh the access token.", Toast.LENGTH_SHORT).show();
            Log.e("line", response.getErrorData().toString());
        }
    }

    public void verifyTokenTask() {
        LineApiResponse<LineCredential> response = lineApiClient.verifyToken();

        if (response.isSuccess()) {
            StringBuilder toastStringBuilder = new StringBuilder("Access Token is VALID and contains the permissions ");

            for (String temp : response.getResponseData().getPermission()) {
                toastStringBuilder.append(temp + ", ");
            }
            Toast.makeText(act.getApplicationContext(), toastStringBuilder.toString(), Toast.LENGTH_SHORT).show();

        } else {
            Toast.makeText(act.getApplicationContext(), "Access Token is NOT VALID", Toast.LENGTH_SHORT).show();
        }
    }

    public void getProfileTask() {
        LineApiResponse<LineProfile> apiResponse = lineApiClient.getProfile();
        if(apiResponse.isSuccess()) {
        } else {
            Toast.makeText(act.getApplicationContext(), "Failed to get profile.", Toast.LENGTH_SHORT).show();
            Log.e("line", "Failed to get Profile: " + apiResponse.getErrorData().toString());
        }
    }

    public void lineLoginResult(int requestCode, int resultCode, Intent data) {
        LineLoginResult result = LineLoginApi.getLoginResultFromIntent(data);
        LineProfile line_profile;
        LineCredential line_credential;

        TreeMap<String, Object> map = new TreeMap<String, Object>();

        switch (result.getResponseCode()) {

            case SUCCESS:
                line_profile = result.getLineProfile();
                line_credential = result.getLineCredential();
                Uri pictureUrl = line_profile.getPictureUrl();
                String mnick = line_profile.getDisplayName();
                String userId = line_profile.getUserId();
                String status = line_profile.getStatusMessage();
                String token = line_credential.getAccessToken().getAccessToken();
                map.put("result", 0);
                map.put("uid", userId);
                map.put("mnick", mnick);
                map.put("token", token);
                if (pictureUrl != null)
                    map.put("head_url", pictureUrl);
                if (status != null)
                    map.put("status_msg", status);
                break;

            case CANCEL:
                Log.e("lineLogin", "LINE Login Canceled by user!!");
                map.put("result", 1);
                break;

            default:
                Log.e("lineLogin", result.getErrorData().toString());
                map.put("result", 2);
                break;
        }
        lineLoginRst(map);
    }

    public void lineLoginRst(TreeMap<String, Object> map)
    {
        if(m_curLuaFuncId >= 0)
        {
            JsonUtil json = new JsonUtil(map);
            final String fbInfo = json.toString();
            System.out.println("fbInfo = " + fbInfo + ", m_curLuaFuncId = " + m_curLuaFuncId);
            AppActivity.mActivity.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_curLuaFuncId, fbInfo);
                    Cocos2dxLuaJavaBridge.releaseLuaFunction(m_curLuaFuncId);
                    m_curLuaFuncId = -1;
                }
            });
        }
    }

    /**
     * line app 是否安装
     */
    public static boolean isAPPInstalled() {
        PackageManager pm = AppActivity.mActivity.getPackageManager();
        List<PackageInfo> pinfo = pm.getInstalledPackages(0);
        for (int i = 0; i < pinfo.size(); i++) {
            if (pinfo.get(i).packageName.equals("jp.naver.line.android")) {
                return true;
            }
        }
        return false;
    }
}
