package org.cocos2dx.lib;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.view.View;
import android.view.WindowManager.LayoutParams;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;

public class WebInputDialog extends Dialog{

	public WebInputDialog(Context context, boolean cancelable,
			OnCancelListener cancelListener) {
		super(context, cancelable, cancelListener);
	}

	public WebInputDialog(Context context, int theme) {
		super(context, theme);
	}

	public WebInputDialog(Context context, WebInputDialogCallBack wdcb) {
		super(context, 11);//R.style.boyaa_web_input_dialog
		this.wdcb = wdcb; 
	}
	
	private Button mBtn;
	private EditText mEt;
	private WebInputDialogCallBack wdcb;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(11);//R.layout.dfqp_web_input_dialog
		mBtn = (Button) findViewById(11);//R.id.btn
		mEt = (EditText) findViewById(11);//R.id.et
		LayoutParams lp = this.getWindow().getAttributes();
		lp.width = LayoutParams.MATCH_PARENT;
		lp.height = LayoutParams.MATCH_PARENT;
		this.getWindow().setAttributes(lp);
		mBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if(wdcb!=null){
					wdcb.onCallBack(mEt.getText().toString());
				}
				WebInputDialog.this.dismiss();
			}
		});
		
		final Handler initHandler = new Handler();
		initHandler.postDelayed(new Runnable() {
			@Override
			public void run() {
				mEt.requestFocus();
				mEt.setSelection(mEt.getEditableText().toString().length());
				openKeyboard();
			}
		}, 200);
	}
	
	public interface WebInputDialogCallBack{
		void onCallBack(String string);
	}
	private void openKeyboard() {
		final InputMethodManager imm = (InputMethodManager) this.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.showSoftInput(mEt, 0);
	}
	

	public void showDialog(String str) {
		super.show();
		if(!TextUtils.isEmpty(str)){
			mEt.setText(str);
			mEt.setSelection(str.length());
		}
	}
	
	@Override
	protected void onStart() {
		super.onStart();
	}
	
	@Override
	public void dismiss() {
		hideImme(mEt);
		super.dismiss();
	}
	
	private void showImme(View v) {
		InputMethodManager imm = (InputMethodManager)getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
//		imm.showSoftInputFromInputMethod(v.getWindowToken(), InputMethodManager.SHOW_FORCED);
		imm.toggleSoftInputFromWindow(v.getWindowToken(), InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_NOT_ALWAYS);
	}
	
	private void hideImme(View v){
		InputMethodManager imm = (InputMethodManager)getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
		View v1 = getCurrentFocus();
		if(v1==null)
			v1 = v;
		if(v1!=null)
			imm.hideSoftInputFromWindow(v1.getWindowToken(), 0);
	}
	
}
