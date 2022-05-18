package com.zhijian.common.utility;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class FileDownloader {

    // instance
    private static FileDownloader m_instance            = null;
    private final HashMap<String,Item>mItemMap          = new HashMap<>();
    private static ExecutorService mFixedThreadPool     = null;
    private static int              mThreadNums         = 4;
    private static int              defTimeOut          = 8;
    private Handler                 mHandler            = null;

    private FileDownloader () {

        mHandler            = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);

                Item    item = null;

                switch (msg.what) {
                    case 1: {
                        item = mItemMap.get(msg.obj);
                        if (item == null) {
                            return;
                        }

                        item.state = (msg.arg1 == 1) ? ItemState.DONE : ItemState.FREE;

                        // call the caller
                        for (int i = 0; i < item.callbacks.size(); i++) {

                            final int callback = item.callbacks.get(i);

                            final boolean finalIsOK = msg.arg1 == 1;
                            final Item finalItem = item;
                            AppActivity.mActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    try {

                                        TreeMap<String, Object> map = new TreeMap<String, Object>();
                                        map.put("url", finalItem.url);
                                        map.put("isok", finalIsOK);
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

                        break;
                    }
                }

            }
        };
    }

    enum ItemState  {
        FREE,
        DOWNLOADING,
        DONE,
    }

    public static FileDownloader  getInstance() {
        if (m_instance == null) {
            m_instance = new FileDownloader();
        }

        return m_instance;
    }

    private  void makePool () {
        if (mFixedThreadPool == null) {
            // start thread
            mFixedThreadPool = Executors.newFixedThreadPool(mThreadNums);
        }
    }

    public void UnZipFolder(String zipFileString, String outPathString) throws Exception {
        ZipInputStream inZip = new ZipInputStream(new FileInputStream(zipFileString));
        ZipEntry zipEntry;
        String szName = "";
        while ((zipEntry = inZip.getNextEntry()) != null) {
            szName = zipEntry.getName();
            if (zipEntry.isDirectory()) {
                // get the folder name of the widget
                szName = szName.substring(0, szName.length() - 1);
                File folder = new File(outPathString + File.separator + szName);
                folder.mkdirs();
            } else {

                File file = new File(outPathString + File.separator + szName);

                if (file.getParentFile() != null && !file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                file.createNewFile();
                // get the output stream of the file
                FileOutputStream out = new FileOutputStream(file);
                int len;
                byte[] buffer = new byte[1024];
                // read (len) bytes into buffer
                while ((len = inZip.read(buffer)) != -1) {
                    // write (len) byte from buffer at the position 0
                    out.write(buffer, 0, len);
                    out.flush();
                }
                out.close();
            }
        }
        inZip.close();
    }

    void addUrl (final String url,final String path, int tmo, final int callback) {

        if (url.length() <= 0) {
            return ;
        }

        System.out.printf ("FileDownloader : addToDownloader (%s)\n",url);

        // first to check if file already existed
        // if yes,return directly
        // or else download it
        Item item = mItemMap.get(url);

        if (item == null) {
            item = new Item(url,path,tmo);
            mItemMap.put(url,item);
        }

        if (item != null) {

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
                        downloadFile (url);
                    }
                });
            }
        }

    }

    public String getFileExt (String filename) {
        if (filename == null) {
            return "";
        }
        int i = filename.lastIndexOf(".");
        return i == -1 ? "" : filename.substring(i + 1);
    }

    public String getFilePathWithoutExt (String filename) {
        if (filename == null) {
            return "";
        }
        int i = filename.lastIndexOf(".");
        return i == -1 ? filename : filename.substring(0,i);
    }

    private void downloadFile (String uurl) {

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
            conn.setRequestProperty("Accept-Encoding", "identity");

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

                    File imgDir         = new File (item.cachePath);

                    if (imgDir.getParentFile() != null && !imgDir.getParentFile().exists()) {
                        imgDir.getParentFile().mkdirs();
                    }

                    byte[] buff = bos.toByteArray();
                    bos.close();

                    FileOutputStream  fos = new FileOutputStream(item.cachePath);
                    fos.write(buff,0,buff.length);
                    fos.close();

                    //
                    // additional operation
                    // note that if we failed with unzipping file
                    // we still mark the isOK be false
                    //
                    String ext = getFileExt (item.cachePath);
                    String filepath = imgDir.getParentFile().getPath();

                    if (ext.equals("zip")) {
                        //
                        // stupid code,if zip extension name met , we will try to unzip it
                        //
                        UnZipFolder(item.cachePath, filepath);
                    }

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

    public class Item {

        String              url;
        String              cachePath;
        int                 time;
        int 				tmo;
        ItemState           state;
        ArrayList<Integer>  callbacks;

        public Item (String url,String path,int tmo) {

            this.url        = url;
            this.cachePath  = path;
            this.callbacks  = new ArrayList<>();
            this.time       = 0;
            this.tmo 		= tmo;
            this.state      = checkState ();
        }

        private ItemState checkState () {
            try {
                File file = new File(this.cachePath);

                // if not exists ,return null
                if (!file.exists()) {
                    return ItemState.FREE;
                } else {
                    return ItemState.DONE;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            return ItemState.FREE;
        }
    }

}
