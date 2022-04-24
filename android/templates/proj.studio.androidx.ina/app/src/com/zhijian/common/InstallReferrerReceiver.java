package com.zhijian.common;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class InstallReferrerReceiver extends BroadcastReceiver {

    static private String referrer = null;

    @Override
    public void onReceive(Context context, Intent intent) {
        referrer = intent.getStringExtra("referrer");
        Log.d("installreferrer",referrer);
        if (referrer != null && referrer.length() > 0) {
            Log.d("installreferrer","Sucess" + referrer);
        }
    }

    static public String getReferrer () {
        return referrer;
    }
}
