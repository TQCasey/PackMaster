package com.hybro.common;

import androidx.multidex.MultiDexApplication;


public class MyApplication extends MultiDexApplication {
	private static MyApplication instance;
    public static String gms_adid = "";

    public MyApplication() {
        instance = this;
    }

    public static MyApplication getInstance() {
         return instance;
    }
    
    @Override
    public void onCreate() {
        super.onCreate();
    }
}
