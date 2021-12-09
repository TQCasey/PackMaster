package com.zhijian.domino;

import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

import org.cocos2dx.lua.AppActivity;

public class AppFireBaseInstanceIDService extends FirebaseInstanceIdService{
    @Override
    public void onTokenRefresh() {
        super.onTokenRefresh();
        String token = FirebaseInstanceId.getInstance().getToken();
        if (token != null) {
            Log.d("AppInstanceIDService", "onTokenRefresh: "+token);
            try {
                if (AppActivity.mActivity != null)
                    AppActivity.mActivity.uploadGcmId(token);
            } catch (NullPointerException e) {
            }
        }
    }
}