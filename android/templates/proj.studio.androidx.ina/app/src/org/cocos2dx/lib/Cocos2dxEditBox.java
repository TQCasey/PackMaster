/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2013-2015 Chukong Technologies Inc.

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

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Typeface;
import android.text.InputFilter;
import android.text.InputType;
import android.text.Spanned;
import android.text.method.PasswordTransformationMethod;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.FrameLayout;

import androidx.appcompat.widget.AppCompatEditText;

public class Cocos2dxEditBox extends AppCompatEditText implements SoftKeyboardStateHelper.SoftKeyboardStateListener {
    /**
     * The user is allowed to enter any text, including line breaks.
     */
    private final int kEditBoxInputModeAny = 0;

    /**
     * The user is allowed to enter an e-mail address.
     */
    private final int kEditBoxInputModeEmailAddr = 1;

    /**
     * The user is allowed to enter an integer value.
     */
    private final int kEditBoxInputModeNumeric = 2;

    /**
     * The user is allowed to enter a phone number.
     */
    private final int kEditBoxInputModePhoneNumber = 3;

    /**
     * The user is allowed to enter a URL.
     */
    private final int kEditBoxInputModeUrl = 4;

    /**
     * The user is allowed to enter a real number value. This extends kEditBoxInputModeNumeric by allowing a decimal point.
     */
    private final int kEditBoxInputModeDecimal = 5;

    /**
     * The user is allowed to enter any text, except for line breaks.
     */
    private final int kEditBoxInputModeSingleLine = 6;

    /**
     * The user is allowed to enter any text, except for line breaks.
     */
    private final int kEditBoxInputModeMultiLine = 7;

    /**
     * Indicates that the text entered is confidential data that should be obscured whenever possible. This implies EDIT_BOX_INPUT_FLAG_SENSITIVE.
     */
    private final int kEditBoxInputFlagPassword = 0;

    /**
     * Indicates that the text entered is sensitive data that the implementation must never store into a dictionary or table for use in predictive, auto-completing, or other accelerated input schemes. A credit card number is an example of sensitive data.
     */
    private final int kEditBoxInputFlagSensitive = 1;

    /**
     * This flag is a hint to the implementation that during text editing, the initial letter of each word should be capitalized.
     */
    private final int kEditBoxInputFlagInitialCapsWord = 2;

    /**
     * This flag is a hint to the implementation that during text editing, the initial letter of each sentence should be capitalized.
     */
    private final int kEditBoxInputFlagInitialCapsSentence = 3;

    /**
     * Capitalize all characters automatically.
     */
    private final int kEditBoxInputFlagInitialCapsAllCharacters = 4;

    private final int kKeyboardReturnTypeDefault = 0;
    private final int kKeyboardReturnTypeDone = 1;
    private final int kKeyboardReturnTypeSend = 2;
    private final int kKeyboardReturnTypeSearch = 3;
    private final int kKeyboardReturnTypeGo = 4;

    private int mInputFlagConstraints;
    private int mInputModeConstraints;
    private  int mMaxLength;
    private int mAdjustMode = 1;

    //OpenGL view scaleX
    private  float mScaleX;
    private  Context mContext;
    private int index = 0;
    private int state = 1;

    public  Cocos2dxEditBox(Context context){
        super(context);
        this.mContext = context;
    }
    
    public void setEditBoxViewRect(int left, int top, int maxWidth, int maxHeight) {
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,
                                                                            FrameLayout.LayoutParams.WRAP_CONTENT);
        layoutParams.leftMargin = left;
        layoutParams.topMargin = top;
        layoutParams.width = maxWidth;
        layoutParams.height = maxHeight;
        layoutParams.gravity = Gravity.TOP | Gravity.LEFT;
        this.setLayoutParams(layoutParams);
    }

    public float getOpenGLViewScaleX() {
        return mScaleX;
    }

    public void setOpenGLViewScaleX(float mScaleX) {
        this.mScaleX = mScaleX;
    }

    public void setIndex(int index){
        this.index = index;
    }

    public int getIndex(int index){
        return this.index;
    }

    public void setState(int state){
        this.state = state;
    }

    public int getState(int state){
        return this.state;
    }

    public  void setMaxLength(int maxLength){
        this.mMaxLength = maxLength;

        this.setFilters(new InputFilter[]{new InputFilter.LengthFilter(this.mMaxLength) });
    }

    public void setMultilineEnabled(boolean flag){
        this.mInputModeConstraints |= InputType.TYPE_TEXT_FLAG_MULTI_LINE;
    }

    public void setInputAlignment (int hAlignment,int vAlignment) {

        int gh = 0;

        if (hAlignment == 0) {
            gh = Gravity.LEFT;
        } else if (hAlignment == 1) {
            gh = Gravity.CENTER;
        } else {
            gh = Gravity.RIGHT;
        }

        if (vAlignment == 0) {
            gh |= Gravity.TOP;
        } else if (vAlignment == 1) {
            gh |= Gravity.CENTER_VERTICAL;
        } else {
            gh |= Gravity.BOTTOM;
        }

        this.setGravity(gh);
    }

    public void setAdjustMode(int mode) {
        mAdjustMode = mode;
    }

    public void adjustMode(final Activity activity) {
        Window window = activity.getWindow();
        if (mAdjustMode == 1)
            window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        else
            window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING);
    }

    public void setReturnType(int returnType) {
        switch (returnType) {
            case kKeyboardReturnTypeDefault:
                this.setImeOptions(EditorInfo.IME_ACTION_NONE | EditorInfo.IME_FLAG_NO_EXTRACT_UI);
                break;
            case kKeyboardReturnTypeDone:
                this.setImeOptions(EditorInfo.IME_ACTION_DONE | EditorInfo.IME_FLAG_NO_EXTRACT_UI);
                break;
            case kKeyboardReturnTypeSend:
                this.setImeOptions(EditorInfo.IME_ACTION_SEND | EditorInfo.IME_FLAG_NO_EXTRACT_UI);
                break;
            case kKeyboardReturnTypeSearch:
                this.setImeOptions(EditorInfo.IME_ACTION_SEARCH | EditorInfo.IME_FLAG_NO_EXTRACT_UI);
                break;
            case kKeyboardReturnTypeGo:
                this.setImeOptions(EditorInfo.IME_ACTION_GO | EditorInfo.IME_FLAG_NO_EXTRACT_UI);
                break;
            default:
                this.setImeOptions(EditorInfo.IME_ACTION_NONE | EditorInfo.IME_FLAG_NO_EXTRACT_UI);
                break;
        }
    }  


    public  void setInputMode(int inputMode){

        switch (inputMode) {
            case kEditBoxInputModeAny:
                this.mInputModeConstraints = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE;
                break;
            case kEditBoxInputModeEmailAddr:
                this.mInputModeConstraints = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS;
                break;
            case kEditBoxInputModeNumeric:
                this.mInputModeConstraints = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED;
                break;
            case kEditBoxInputModePhoneNumber:
                this.mInputModeConstraints = InputType.TYPE_CLASS_PHONE;
                break;
            case kEditBoxInputModeUrl:
                this.mInputModeConstraints = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_URI;
                break;
            case kEditBoxInputModeDecimal:
                this.mInputModeConstraints = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED;
                break;
            case kEditBoxInputModeSingleLine:
                this.mInputModeConstraints = InputType.TYPE_CLASS_TEXT;
                break;
            case kEditBoxInputModeMultiLine:
                this.setSingleLine(false);
                this.mInputModeConstraints = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE;
                break;
            default:

                break;
        }

        this.setInputType(this.mInputModeConstraints | this.mInputFlagConstraints);

    }

    @Override
    public boolean onKeyDown(final int pKeyCode, final KeyEvent pKeyEvent) {
    	//System.out.print ("keycode ===========================> " + pKeyCode);
        try {
	        switch (pKeyCode) {
	            case KeyEvent.KEYCODE_BACK:
                    Cocos2dxActivity activity = (Cocos2dxActivity)this.getActivity();
	                //To prevent program from going to background
	                activity.getGLSurfaceView().requestFocus();
	                return true;
	            default:
	                return super.onKeyDown(pKeyCode, pKeyEvent);
	        }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean onKeyPreIme(int keyCode, KeyEvent event) {
    	//System.out.print ("keycode ===========================> " + keyCode);
        return super.onKeyPreIme(keyCode, event);
    }

    public void setInputFlag(int inputFlag) {

        switch (inputFlag) {
            case kEditBoxInputFlagPassword:
                this.mInputFlagConstraints = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD;
                this.setTypeface(Typeface.DEFAULT);
                this.setTransformationMethod(new PasswordTransformationMethod());
                break;
            case kEditBoxInputFlagSensitive:
                this.mInputFlagConstraints = InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS;
                break;
            case kEditBoxInputFlagInitialCapsWord:
                this.mInputFlagConstraints = InputType.TYPE_TEXT_FLAG_CAP_WORDS;
                break;
            case kEditBoxInputFlagInitialCapsSentence:
                this.mInputFlagConstraints = InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
                break;
            case kEditBoxInputFlagInitialCapsAllCharacters:
                this.mInputFlagConstraints = InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
                break;
            default:
                break;
        }

        this.setInputType(this.mInputFlagConstraints | this.mInputModeConstraints);
    }

    public void onSoftKeyboardOpened(int keyboardHeightInPx){
        // state = 0;
    }

    public void onSoftKeyboardClosed(){
        if (state == 1) return ;
        Cocos2dxActivity activity = (Cocos2dxActivity)this.getActivity();
        activity.getGLSurfaceView().requestFocus();
        activity.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxEditBoxHelper.__editBoxEditingDidEnd(index, getText().toString());
            }
        });
        state = 1;
    }

    private Activity getActivity() {
        // Gross way of unwrapping the Activity so we can get the FragmentManager
        Context context = getContext();
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) {
                return (Activity)context;
            }
            context = ((ContextWrapper)context).getBaseContext();
        }
        throw new IllegalStateException("The MediaRouteButton's Context is not an Activity.");
    }
}
