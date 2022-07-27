package com.zhijian.common.utility;

import android.icu.text.SymbolTable;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ImageDownloader {

    // instance
    private static ImageDownloader m_instance                = null;
    private final HashMap<String,Item>mItemMap          = new HashMap<>();
    private static ExecutorService mFixedThreadPool     = null;
    private static int              mThreadNums         = 4;
    private static int              defTimeOut          = 8;
    private Handler                 mHandler            = null;
    private Looper                  mLooper             = null;

    private ImageDownloader () {

        mHandler            = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);

                Item    item = null;

                switch (msg.what) {
                    case 1:

                        item = mItemMap.get(msg.obj);
                        if (item == null) {
                            return ;
                        }

                        item.state = (msg.arg1 == 1) ? ItemState.DONE : ItemState.FREE;

                        // call the caller
                        for (int i = 0 ; i < item.callbacks.size() ; i ++) {

                            final int callback = item.callbacks.get(i);

                            final boolean finalIsOK = msg.arg1 == 1;
                            final Item finalItem = item;
                            AppActivity.mActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    try {

                                        TreeMap<String, Object> map = new TreeMap<String, Object>();
                                        map.put("url", finalItem.url);
                                        map.put("path", (finalIsOK == true)  ? finalItem.cachePath : "");
                                        JsonUtil json = new JsonUtil(map);

                                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, json.toString());
                                        Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            });
                        }

                        break;

                    case 2:

                        item = mItemMap.get(msg.obj) ;
                        if (item == null) {
                            item = new Item (msg.obj.toString(),defTimeOut);
                            mItemMap.put(msg.obj.toString(),item);
                        }

                        break;
                }

            }
        };
    }

    enum ItemState  {
        FREE,
        DOWNLOADING,
        DONE,
    }

    public static ImageDownloader getInstance() {
        if (m_instance == null) {
            m_instance = new ImageDownloader();
        }

        return m_instance;
    }

    void setConfig (String jstr) {

        System.out.printf ("downloader :  setDownloaderConfig ()\n");

        JSONObject json = null;

        // decode
        try {
            json = new JSONObject(jstr);
        } catch (JSONException e) {
            e.printStackTrace();
            return ;
        }

        if (json != null) {
            Iterator<?> it = json.keys();
            while (it.hasNext()) {
                String key = it.next().toString();
                String value = null;

                try {
                    value = json.getString(key);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if (value == null)
                    continue;

                if (key.equals("num")) {
                    mThreadNums = Integer.parseInt(value);
                } else if (key.equals("deftmo")) {
                    //
                }
            }
        }

        makePool ();
    }

    private  void makePool () {
        if (mFixedThreadPool == null) {
            // start thread
            mFixedThreadPool = Executors.newFixedThreadPool(mThreadNums);
        }
    }

    void addUrl (final String url, int tmo, final int callback) {

        if (url.length() <= 0) {
            return ;
        }

        System.out.printf ("downloader : addToDownloader ()\n");

        // first to check if file already existed
        // if yes,return directly
        // or else download it
        Item item = mItemMap.get(url);

        if (item == null) {
            item = new Item(url,tmo);
            mItemMap.put(url,item);
        }

        if (item != null) {
            if (item.state == ItemState.DONE) {
                // callback imm
                if (callback >= 0) {
                    final Item finalItem = item;
                    AppActivity.mActivity.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                TreeMap<String, Object> map = new TreeMap<String, Object>();
                                map.put("url",url);
                                map.put("path", finalItem.cachePath);
                                JsonUtil json = new JsonUtil(map);

                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, json.toString());
                                Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                }

            } else {

                if (item.state == ItemState.DOWNLOADING) {
                    // add to callback
                    item.callbacks.add(callback);

                } else {
                    // start to download
                    makePool();

                    if (item.cachePath.length() <= 0) {
                        return ;
                    }

                    item.callbacks.add(callback);
                    item.state = ItemState.DOWNLOADING;

                    mFixedThreadPool.execute(new Runnable() {
                        @Override
                        public void run() {
                            downloadImage (url);
                        }
                    });
                }
            }
        }

    }

    String getCache (String url) {
        System.out.printf ("downloader :  getCachedImage ()\n");

        Item item = mItemMap.get(url);

        if (item == null) {
            item = new Item (url,defTimeOut);
            mItemMap.put(url,item);
        }

        if (item != null) {
            if (item.state == ItemState.DONE) {
                return item.cachePath;
            }
        }

        return  "";
    }

    private void downloadImage (String uurl) {

        boolean isOK    = false;
        Item item       = mItemMap.get(uurl);
        if (item == null) {
            return ;
        }

        InputStream is = null;
        ByteArrayOutputStream bos = null;

        HttpURLConnection conn = null;

        try {

            URL url = new URL (item.url);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(item.tmo * 1000);
            conn.setReadTimeout(item.tmo * 1000);
            conn.setRequestProperty("Accept-Encoding", "identity");
            conn.connect();

            int resCode = conn.getResponseCode();
            if (resCode == HttpURLConnection.HTTP_OK) {
                is = conn.getInputStream();

                bos = new ByteArrayOutputStream();
                int len = conn.getContentLength();
                int wlen = 0;

                byte[] buff = new byte[1024];
                int bytes = 0;

                while ((bytes = is.read(buff)) != -1) {
                    bos.write(buff,0,bytes);
                    wlen += bytes;
                }

                if (wlen != len) {
                    isOK = false;
                } else {
                    isOK = true;
                }
            }

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (SocketTimeoutException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    isOK = false;
                }
            }

            if (isOK) {
                try {
                    byte[] buff = bos.toByteArray();
                    bos.close();

                    FileOutputStream  fos = new FileOutputStream(item.cachePath);
                    fos.write(buff,0,buff.length);
                    fos.close();

                } catch (FileNotFoundException e) {
                    isOK = false;
                } catch (Exception e) {
                    isOK = false;
                }
            }

            if (conn != null) {
                conn.disconnect();
                conn = null;
            }

            // If failed , try again next time
            // If Ok , cache it all the time
            Message msg = mHandler.obtainMessage();
            msg.what    = 1;
            msg.arg1    = isOK == true ? 1 : 0;
            msg.obj     = uurl;

            mHandler.sendMessage(msg);
        }
    }


    void removeCache (String url) {
        System.out.printf ("downloader :  clearCachedImage ()\n");

        try {
            Item item = mItemMap.get(url);

            if (item == null) {
                item = new Item(url, defTimeOut);

                // no need to put into mItemMap
            }

            if (item != null) {
                if (item.state == ItemState.DONE || item.state == ItemState.FREE) {
                    if (item.cachePath != "") {
                        File file = new File(item.cachePath);
                        if (file.exists()) {
                            file.delete();
                        }
                        mItemMap.remove(url);   // remove url
                    }
                } else {
                    // if it is downloading,not need to do
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String md5(String string) {
        if (TextUtils.isEmpty(string)) {
            return "";
        }
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
            byte[] bytes = md5.digest(string.getBytes());
            String result = "";
            for (byte b : bytes) {
                String temp = Integer.toHexString(b & 0xff);
                if (temp.length() == 1) {
                    temp = "0" + temp;
                }
                result += temp;
            }
            return result;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }

    public class Item {

        String              url;
        String              md5 ;
        String              cachePath;
        int                 time;
		int 				tmo;
        ItemState           state;
        ArrayList<Integer>  callbacks;

        public Item (String url,int tmo) {

            this.url        = url;
            this.cachePath  = "";
            this.callbacks  = new ArrayList<>();
            this.time       = 0;
			this.tmo 		= tmo;
            this.md5        = md5 (url);
            this.state      = checkState ();

//            if (this.state == ItemState.DONE) {
//                System.out.printf ("downloader : " + url + " is Downloaded yet!! \n");
//            } else {
//                System.out.printf ("downloader : " + url + " not Downloaded \n");
//            }

        }

        private ItemState checkState () {

            ItemState state = ItemState.FREE;

            // check local dir
            try {
                 // if SDCard media mounted
                if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {

                    // re-write whole file content
                    File sdCardDir      = AppActivity.mActivity.getExternalCacheDir();

                    String imgDirPath   = sdCardDir.getCanonicalPath() + File.pathSeparator + "images2" + File.pathSeparator;
                    File imgDir         = new File (imgDirPath);

                    if (!imgDir.exists()) {
                        imgDir.mkdirs();
                    }

                    this.cachePath      = imgDirPath + this.md5 + ".cynk";  //".pnga"

                    File file = new File(this.cachePath);

                    // if not exists ,return null
                    if (!file.exists()) {
                        return ItemState.FREE;
                    } else {
                        return ItemState.DONE;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            return ItemState.FREE;
        }
    }

}
