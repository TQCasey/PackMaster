package com.zhijian.common;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import com.zhijian.common.utility.JsonUtil;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;

import java.io.File;
import java.util.TreeMap;

public class ShareMgr {

    private static ShareMgr mInstance = null;
    private static Activity mActivity = null;
    private int mFuncId = -1;
    final int SHARE_MSG = 0xDA3B;

    public static ShareMgr getIntance () {
        if (mInstance == null) {
            mInstance = new ShareMgr();
        }
        return mInstance;
    }

    public void init (AppActivity activity) {
        mActivity = activity;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data){

        if (requestCode == SHARE_MSG) {

            TreeMap<String, Object> map = new TreeMap<String, Object>();
            JsonUtil json = null;
            String installParamstr = "";

            map.put ("ret",resultCode);

            json = new JsonUtil(map);
            installParamstr = json.toString();
            callLua(mFuncId,installParamstr);
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

    /**
     *
     * 分享功能
     * @param activityTitle
     *            Activity的名字
     * @param msgTitle
     *            消息标题
     * @param msgText
     *            消息内容
     * @param imgPath
     *            图片路径，不分享图片则传null
     * #param funcId
     *            lua 回调函数id
     *
     */
    public void shareMsg(final String activityTitle, final String msgTitle, final String msgText, final String imgPath,final int funcId) {
        try {

            mFuncId = funcId;

            Intent intent = new Intent(Intent.ACTION_SEND);
            if (imgPath == null || imgPath.equals("")) {
                intent.setType("text/plain"); // 纯文本
            } else {
                File f = new File(imgPath);
                if (f != null && f.exists() && f.isFile()) {
                    intent.setType("image/jpg");
                    Uri u = Uri.fromFile(f);
                    intent.putExtra(Intent.EXTRA_STREAM, u);
                }
            }
            intent.putExtra(Intent.EXTRA_SUBJECT, msgTitle);
            intent.putExtra(Intent.EXTRA_TEXT, msgText);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mActivity.startActivityForResult(Intent.createChooser(intent, activityTitle),SHARE_MSG);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}
