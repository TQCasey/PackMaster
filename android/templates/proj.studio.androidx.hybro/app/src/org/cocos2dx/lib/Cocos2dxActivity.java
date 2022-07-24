/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lib;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.PixelFormat;
import android.hardware.display.DisplayManager;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.os.Bundle;
import android.os.Message;
import android.preference.PreferenceManager.OnActivityResultListener;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.chukong.cocosplay.client.CocosPlayClient;
import com.hybro.common.utility.PermissionsChecker;

import org.cocos2dx.lib.Cocos2dxHelper.Cocos2dxHelperListener;
import org.cocos2dx.utils.PSNative;
import org.cocos2dx.utils.PSNetwork;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.HashMap;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLDisplay;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.appcompat.app.AppCompatActivity;

public abstract class Cocos2dxActivity extends AppCompatActivity implements Cocos2dxHelperListener {
    // ===========================================================
    // Constants
    // ===========================================================

    private final static String TAG = Cocos2dxActivity.class.getSimpleName();

    // ===========================================================
    // Fields
    // ===========================================================
    
    private Cocos2dxGLSurfaceView mGLSurfaceView = null;
    private int[] mGLContextAttrs = null;
    private Cocos2dxHandler mHandler = null;   
    private static Cocos2dxActivity sContext = null;
    private Cocos2dxVideoHelper mVideoHelper = null;
    private Cocos2dxWebViewHelper mWebViewHelper = null;
   	private Cocos2dxEditBoxHelper mEditBoxHelper = null;
    protected boolean hasFocus = false;
    private static HashMap <String,Boolean> navigationMap = null;
    private RelativeLayout mAdViewContainer;
    private static boolean s_destroyFlag = false;

    public Cocos2dxGLSurfaceView getGLSurfaceView(){
        return  mGLSurfaceView;
    }

    public class Cocos2dxEGLConfigChooser implements GLSurfaceView.EGLConfigChooser
    {
        protected int[] configAttribs;
        public Cocos2dxEGLConfigChooser(int redSize, int greenSize, int blueSize, int alphaSize, int depthSize, int stencilSize)
        {
            configAttribs = new int[] {redSize, greenSize, blueSize, alphaSize, depthSize, stencilSize};
        }
        public Cocos2dxEGLConfigChooser(int[] attribs)
        {
            configAttribs = attribs;
        }
        
        public EGLConfig selectConfig(EGL10 egl, EGLDisplay display, EGLConfig[] configs, int[] attribs)
        {
            for (EGLConfig config : configs) {
                int d = findConfigAttrib(egl, display, config,
                        EGL10.EGL_DEPTH_SIZE, 0);
                int s = findConfigAttrib(egl, display, config,
                        EGL10.EGL_STENCIL_SIZE, 0);
                if ((d >= attribs[4]) && (s >= attribs[5])) {
                    int r = findConfigAttrib(egl, display, config,
                            EGL10.EGL_RED_SIZE, 0);
                    int g = findConfigAttrib(egl, display, config,
                             EGL10.EGL_GREEN_SIZE, 0);
                    int b = findConfigAttrib(egl, display, config,
                              EGL10.EGL_BLUE_SIZE, 0);
                    int a = findConfigAttrib(egl, display, config,
                            EGL10.EGL_ALPHA_SIZE, 0);
                    if ((r >= attribs[0]) && (g >= attribs[1])
                            && (b >= attribs[2]) && (a >= attribs[3])) {
                        return config;
                    }
                }
            }
            return null;
        }

        private int findConfigAttrib(EGL10 egl, EGLDisplay display,
                EGLConfig config, int attribute, int defaultValue) {
            int[] value = new int[1];
            if (egl.eglGetConfigAttrib(display, config, attribute, value)) {
                return value[0];
            }
            return defaultValue;
        }
        
        @Override
        public EGLConfig chooseConfig(EGL10 egl, EGLDisplay display) 
        {
            int[] numConfigs = new int[1];
            if(egl.eglGetConfigs(display, null, 0, numConfigs))
            {
                EGLConfig[] configs = new EGLConfig[numConfigs[0]];
                int[] EGLattribs = {
                        EGL10.EGL_RED_SIZE, configAttribs[0], 
                        EGL10.EGL_GREEN_SIZE, configAttribs[1],
                        EGL10.EGL_BLUE_SIZE, configAttribs[2],
                        EGL10.EGL_ALPHA_SIZE, configAttribs[3],
                        EGL10.EGL_DEPTH_SIZE, configAttribs[4],
                        EGL10.EGL_STENCIL_SIZE,configAttribs[5],
                        EGL10.EGL_RENDERABLE_TYPE, 4, //EGL_OPENGL_ES2_BIT
                        EGL10.EGL_NONE
                                    };
                int[] choosedConfigNum = new int[1];
                
                egl.eglChooseConfig(display, EGLattribs, configs, numConfigs[0], choosedConfigNum);
                if(choosedConfigNum[0]>0)
                {
                    return selectConfig(egl, display, configs, configAttribs);
                }
                else
                {
                    int[] defaultEGLattribs = {
                            EGL10.EGL_RED_SIZE, 5, 
                            EGL10.EGL_GREEN_SIZE, 6,
                            EGL10.EGL_BLUE_SIZE, 5,
                            EGL10.EGL_ALPHA_SIZE, 0,
                            EGL10.EGL_DEPTH_SIZE, 0,
                            EGL10.EGL_STENCIL_SIZE,0,
                            EGL10.EGL_RENDERABLE_TYPE, 4, //EGL_OPENGL_ES2_BIT
                            EGL10.EGL_NONE
                                        };
                    int[] defaultEGLattribsAlpha = {
                            EGL10.EGL_RED_SIZE, 4, 
                            EGL10.EGL_GREEN_SIZE, 4,
                            EGL10.EGL_BLUE_SIZE, 4,
                            EGL10.EGL_ALPHA_SIZE, 4,
                            EGL10.EGL_DEPTH_SIZE, 0,
                            EGL10.EGL_STENCIL_SIZE,0,
                            EGL10.EGL_RENDERABLE_TYPE, 4, //EGL_OPENGL_ES2_BIT
                            EGL10.EGL_NONE
                                        };
                    int[] attribs = null;
                    //choose one can use
                    if(this.configAttribs[3] == 0)
                    {
                        egl.eglChooseConfig(display, defaultEGLattribs, configs, numConfigs[0], choosedConfigNum);
                        attribs = new int[]{5,6,5,0,0,0};
                    }
                    else
                    {
                        egl.eglChooseConfig(display, defaultEGLattribsAlpha, configs, numConfigs[0], choosedConfigNum);
                        attribs = new int[]{4,4,4,4,0,0};
                    }
                    if(choosedConfigNum[0] > 0)
                    {
                        return selectConfig(egl, display, configs, attribs);
                    }
                    else
                    {
                        Log.e(DEVICE_POLICY_SERVICE, "Can not select an EGLConfig for rendering.");
                        return null;
                    }
                }
            }
            Log.e(DEVICE_POLICY_SERVICE, "Can not select an EGLConfig for rendering.");
            return null;
        }

    }
    
    public static Context getContext() {
        return sContext;
    }
    
    public void setKeepScreenOn(boolean value) {
        final boolean newValue = value;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mGLSurfaceView.setKeepScreenOn(newValue);
            }
        });
    }
    
    protected void onLoadNativeLibraries() {
        try {
            ApplicationInfo ai = getPackageManager().getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            Bundle bundle = ai.metaData;
            String libName = bundle.getString("android.app.lib_name");
            System.loadLibrary(libName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // ===========================================================
    // Constructors
    // ===========================================================
    
    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mChecker = new PermissionsChecker(this);

        //刘海屏设置全屏，否则会留一条黑带
        if (Build.VERSION.SDK_INT >= 28) {
            WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
            getWindow().setAttributes(lp);
        }

        // 设置全屏显示
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        // 隐藏底部导航栏虚拟键
        solveNavigationBar();

        // 隐藏顶部任务栏，需要时再开启(全面屏)
    //    solveMissionBar(this, this.getWindow());

        CocosPlayClient.init(this, false);

        onLoadNativeLibraries();

        sContext = this;
        this.mHandler = new Cocos2dxHandler(this);
        
        Cocos2dxHelper.init(this);
        
        this.mGLContextAttrs = getGLContextAttrs();
        this.init();

        if (mVideoHelper == null) {
            mVideoHelper = new Cocos2dxVideoHelper(this, mFrameLayout);
        }
        
        if(mWebViewHelper == null){
            mWebViewHelper = new Cocos2dxWebViewHelper(mFrameLayout);
        }
        
        if(mEditBoxHelper == null){
            mEditBoxHelper = new Cocos2dxEditBoxHelper(mFrameLayout);
        }

        mAdViewContainer = new RelativeLayout(this);
        FrameLayout.LayoutParams lParams = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT);
        mFrameLayout.addView(mAdViewContainer, lParams);

        Window window = this.getWindow();
        window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        
        PSNative.init(this);
        PSNetwork.init(this);

        DisplayManager.DisplayListener mDisplayListener = new DisplayManager.DisplayListener() {
            @Override
            public void onDisplayAdded(int displayId) {
                android.util.Log.i(TAG, "Display #" + displayId + " added.");
            }

            @Override
            public void onDisplayChanged(int displayId) {
                android.util.Log.i(TAG, "Display #" + displayId + " changed.");
                setDeviceOrientation(false);
            }

            @Override
            public void onDisplayRemoved(int displayId) {
                android.util.Log.i(TAG, "Display #" + displayId + " removed.");
            }
        };
        DisplayManager displayManager = (DisplayManager) getSystemService(Context.DISPLAY_SERVICE);
        displayManager.registerDisplayListener(mDisplayListener, null);
    }

    //native method,call GLViewImpl::getGLContextAttrs() to get the OpenGL ES context attributions
    private static native int[] getGLContextAttrs();
    
    // ===========================================================
    // Getter & Setter
    // ===========================================================

    // ===========================================================
    // Methods for/from SuperClass/Interfaces
    // ===========================================================

    @Override
    protected void onResume() {
        solveNavigationBar();    // 隐藏导航栏
        super.onResume();
        resumeIfHasFocus();
        setDeviceOrientation(true);
    }

    public void onSubWindowFocusChanged(boolean hasFocus) {
        this.hasFocus = hasFocus;
        resumeIfHasFocus();
    }
    
    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
    	Log.d(TAG, "onWindowFocusChanged() hasFocus=" + hasFocus);

        if (hasFocus) {
            solveNavigationBar();    // 隐藏导航栏
        }

    	super.onWindowFocusChanged(hasFocus);
    	if (this.hasFocus != hasFocus) onSubWindowFocusChanged(hasFocus);
    }

    public void setDeviceOrientation(boolean isInit) {
        int rotation = getWindowManager().getDefaultDisplay().getRotation();
        //为了与iOS方向定义保持一致这里进行转换
        if (1 == rotation) rotation = 3;//刘海在左侧
        else if (3 == rotation) rotation = 4;//刘海在右侧
        Cocos2dxHelper.setDeviceOrientation(rotation, isInit);
    }

    private void resumeIfHasFocus() {

        if(hasFocus || s_destroyFlag ) {
            s_destroyFlag = false;
        	Cocos2dxHelper.onResume();
        	mGLSurfaceView.onResume();
        }
	}

	@Override
    protected void onPause() {
        super.onPause();
        
        Cocos2dxHelper.onPause();
        mGLSurfaceView.onPause();
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        s_destroyFlag = true;
    }

    @Override
    public void showDialog(final String pTitle, final String pMessage) {
        Message msg = new Message();
        msg.what = Cocos2dxHandler.HANDLER_SHOW_DIALOG;
        msg.obj = new Cocos2dxHandler.DialogMessage(pTitle, pMessage);
        this.mHandler.sendMessage(msg);
    }

    @Override
    public void showEditTextDialog(final String pTitle, final String pContent, final int pInputMode, final int pInputFlag, final int pReturnType, final int pMaxLength) { 
        Message msg = new Message();
        msg.what = Cocos2dxHandler.HANDLER_SHOW_EDITBOX_DIALOG;
        msg.obj = new Cocos2dxHandler.EditBoxMessage(pTitle, pContent, pInputMode, pInputFlag, pReturnType, pMaxLength);
        this.mHandler.sendMessage(msg);
    }
    
    @Override
    public void runOnGLThread(final Runnable pRunnable) {
        this.mGLSurfaceView.queueEvent(pRunnable);
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        for (OnActivityResultListener listener : Cocos2dxHelper.getOnActivityResultListeners()) {
            listener.onActivityResult(requestCode, resultCode, data);
        }

        super.onActivityResult(requestCode, resultCode, data);
    }

    protected ResizeLayout mFrameLayout = null;
    // ===========================================================
    // Methods
    // ===========================================================
    public void init() {
        
        // FrameLayout
        ViewGroup.LayoutParams framelayout_params =
            new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                                       ViewGroup.LayoutParams.MATCH_PARENT);
        
        mFrameLayout = new ResizeLayout(this);
        
        mFrameLayout.setLayoutParams(framelayout_params);

        // Cocos2dxEditText layout
        ViewGroup.LayoutParams edittext_layout_params =
            new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                                       ViewGroup.LayoutParams.WRAP_CONTENT);
        Cocos2dxEditBox edittext = new Cocos2dxEditBox(this);
        edittext.setLayoutParams(edittext_layout_params);

        // ...add to FrameLayout
        mFrameLayout.addView(edittext);

        // Cocos2dxGLSurfaceView
        this.mGLSurfaceView = this.onCreateView();

        // ...add to FrameLayout
        mFrameLayout.addView(this.mGLSurfaceView);

        // Switch to supported OpenGL (ARGB888) mode on emulator
        if (isAndroidEmulator())
           this.mGLSurfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0);

        this.mGLSurfaceView.setCocos2dxRenderer(new Cocos2dxRenderer());
        this.mGLSurfaceView.setCocos2dxEditText(edittext);

        // Set framelayout as the content view
        setContentView(mFrameLayout);
    }
    
    public Cocos2dxGLSurfaceView onCreateView() {
        Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
        //this line is need on some device if we specify an alpha bits
        if(this.mGLContextAttrs[3] > 0) glSurfaceView.getHolder().setFormat(PixelFormat.TRANSLUCENT);

        Cocos2dxEGLConfigChooser chooser = new Cocos2dxEGLConfigChooser(this.mGLContextAttrs);
        glSurfaceView.setEGLConfigChooser(chooser);

        return glSurfaceView;
    }

   private final static boolean isAndroidEmulator() {
      String model = Build.MODEL;
      Log.d(TAG, "model=" + model);
      String product = Build.PRODUCT;
      Log.d(TAG, "product=" + product);
      boolean isEmulator = false;
      if (product != null) {
         isEmulator = product.equals("sdk") || product.contains("_sdk") || product.contains("sdk_");
      }
      return isEmulator;
   }

    /**
     * <P>shang</P>
     * <P>判断是否有虚拟按键</P>
     * @param context
     * @return
     */
    public static boolean checkDeviceHasNavigationBar(Context context) {

        if (navigationMap == null) {
            navigationMap = new HashMap<>();
            Resources rs = context.getResources();
            int id = rs.getIdentifier("config_showNavigationBar", "bool", "android");

            if (id > 0) {
                navigationMap.put("navigation", rs.getBoolean(id));
            //    hasNavigationBar = rs.getBoolean(id);
            }
            try {
                Class systemPropertiesClass = Class.forName("android.os.SystemProperties");
                Method m = systemPropertiesClass.getMethod("get", String.class);
                String navBarOverride = (String) m.invoke(systemPropertiesClass, "qemu.hw.mainkeys");
                if ("1".equals(navBarOverride)) {
                    navigationMap.put("navigation", false);
                //    hasNavigationBar = false;
                } else if ("0".equals(navBarOverride)) {
                    navigationMap.put("navigation", true);
                //    hasNavigationBar = true;
                }
            } catch (Exception e) {
            }

            if (!navigationMap.containsKey("navigation")) {
                navigationMap.put("navigation", false);
            }
        }

        return navigationMap.get("navigation");
    }

    /**
     * <P>shang</P>
     * <P>解决虚拟键导航栏隐藏问题</P>
     */
    public void solveNavigationBar() {
        //保持布局状态
        int uiOptions = View.SYSTEM_UI_FLAG_LAYOUT_STABLE|
                //布局位于状态栏下方
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION|
                //全屏
                View.SYSTEM_UI_FLAG_FULLSCREEN|
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN;
        if (checkDeviceHasNavigationBar(this)) {
            //隐藏导航栏
            uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | uiOptions;
        }
        if (Build.VERSION.SDK_INT>=19){
            uiOptions |= 0x00001000;
        }else{
            uiOptions |= View.SYSTEM_UI_FLAG_LOW_PROFILE;
        }

        Window window = this.getWindow();
        window.getDecorView().setSystemUiVisibility(uiOptions);
    }

    /**
     * <P>shang</P>
     * <P>解决任务栏黑条隐藏问题</P>
     */
    public void solveMissionBar(Context context, Window window){
        
        if (context == null || window == null) {
            return;
        }

        // 判断是否是Android 9.0以上，Android 8.0需单独适配
        if (Build.VERSION.SDK_INT>=28) {

            WindowManager.LayoutParams lp = window.getAttributes();
            lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
            window.setAttributes(lp);

        }else if (Build.VERSION.SDK_INT>=26) {

            String manufacturer = Build.MANUFACTURER;
            WindowManager.LayoutParams layoutParams = window.getAttributes();

            try{
                switch (manufacturer.toLowerCase()) {
                    case "huawei" :             // 验证机：华为荣耀10
                        int flagA = 0x00010000;
                        Class layoutParamsExCls = Class.forName("com.huawei.android.view.LayoutParamsEx");
                        Constructor con = layoutParamsExCls.getConstructor(WindowManager.LayoutParams.class);
                        Object layoutParamsExObj = con.newInstance(layoutParams);
                        Method methodA = layoutParamsExCls.getMethod("addHwFlags", int.class);
                        methodA.invoke(layoutParamsExObj, flagA);
                        break;
                    case "xiaomi" :             // 验证机：小米8 Lite
                        int flagB = 0x00000100 | 0x00000200 | 0x00000400;
                        Method methodB = Window.class.getMethod("addExtraFlags", int.class);
                        methodB.invoke(window, flagB);
                        break;
                    case "samsung" :
                    //    Method method = WindowInsets.class.getDeclaredMethod("getDisplayCutout");
                    //    Object displayCutoutInstance = method.invoke(windowInsets);
                        break;
                    case "vivo" :               // 未验证
                        int flagC = 0x00000020;
                        ClassLoader classLoader = context.getClassLoader();
                        Class ftFeature = classLoader.loadClass("android.util.FtFeature");
                        Method methodC = ftFeature.getMethod("isFeatureSupport", int.class);
                        methodC.invoke(ftFeature, flagC);
                        break;
                    case "oppo" :               // 未验证
                        context.getPackageManager().hasSystemFeature("com.oppo.feature.screen.heteromorphism");
                        break;
                    default :
                        break;
                }

            }catch(Exception e){
                Log.e("FullScreen Adapt", e.getMessage());
            }
        }
    }


    public static final int PERMISSIONS_CAMERA = 6;            // 请求相机的权限
    public static final int PERMISSIONS_RECORDER = 7;          // 请求录音的权限
    public static final int PERMISSIONS_GRANTED = 0; // 权限授权
    public static final int PERMISSIONS_DENIED = 1; // 权限拒绝
    private static final int PERMISSION_REQUEST_CODE = 0; // 系统权限管理页面的参数
    public PermissionsChecker mChecker; // 权限检测器
    private int cur_permission_code; // 当前正在查询的权限

    public void requestPermission(int code, String[] permissions) {
        Log.i("permissions", "--------------------------"+code);
        cur_permission_code = code;
        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE);
    }

    protected void permissionResult(int requestCode, int resultCode) {
    }

    /**
     * 用户权限处理,
     * 如果全部获取, 则直接过.
     * 如果权限缺失, 则提示Dialog.
     *
     * @param requestCode  请求码
     * @param permissions  权限
     * @param grantResults 结果
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            for (int grantResult : grantResults) {
                if (grantResult == PackageManager.PERMISSION_DENIED) {
                    permissionResult(cur_permission_code, PERMISSIONS_DENIED);
                    Log.i("permissions", "-------result-----------DENIED--------");
                    return;
                }
            }
            permissionResult(cur_permission_code, PERMISSIONS_GRANTED);
            Log.i("permissions", "-------result-----------GRANTED--------");
            return ;
        }
    }

    /**
     * @return adview container
     */
    public RelativeLayout getAdView() {
        return mAdViewContainer;
    }
}
