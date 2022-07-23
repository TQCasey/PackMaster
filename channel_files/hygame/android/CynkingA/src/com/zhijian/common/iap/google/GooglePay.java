package com.zhijian.common.iap.google;

import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsParams;
import com.android.billingclient.api.SkuDetailsResponseListener;
import com.zhijian.common.http.PHPPost;
import com.zhijian.common.http.PHPResult;
import com.zhijian.common.utility.JsonUtil;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;


/**
 * 创建 BillingClient 的实例。
 * 实现 BillingClientStateListener 以接收有关服务状态的回调。
 * 在 BillingClient 实例上调用 startConnection()。
 * 移除与应用内购买相关的 onActivityResult() 代码，并将其移至 PurchasesUpdatedListener。
 */

public class GooglePay {
	private String TAG = "Domino ipa";
	private static GooglePay mInstance;
	private PurchasesUpdatedListener purchasesUpdatedListener;
	private BillingClient billingClient;
	private SkuDetails m_curSkuDetails;

	private int m_googlepay_luaFunc = -1;

	// (arbitrary) request code for the purchase flow
    static final int RC_REQUEST = 10001;
    private int m_luaFunc = -1;
    private String m_curPurchaseId = "";
    private boolean iap_is_ok = false;
    private String m_url = null;
    private String m_postData = null;
    private String m_encryptStr = null;
    
	public static GooglePay getmInstance() {
		if (mInstance == null) {
			mInstance = new GooglePay();
		}
		return mInstance;
	}

	public void showToastMsg (String msg){
		Toast toast = Toast.makeText(AppActivity.mActivity, msg, Toast.LENGTH_SHORT);
		toast.show();
	}
	private GooglePay(){
		this.initialize();
	}

	public void checkGooglePay(final int luaFunc, String postUrl, String postData, String EncryptStr) {
		Log.i(TAG, billingClient == null? "billingClient is null":"billingClient is not null");
		Log.i(TAG, iap_is_ok? "iap_is_ok is true":"iap_is_ok is false");
		if(billingClient == null || iap_is_ok)
			return;

		//	System.out.println("checkGooglePay");

		m_url = postUrl;
		m_postData = postData;
		m_encryptStr = EncryptStr;
		m_googlepay_luaFunc = luaFunc;

		this.checkGooglePlayConnection();
	}

	public void initialize() {
		// 初始化 BillingClient
		purchasesUpdatedListener = new PurchasesUpdatedListener() {
			@Override
			public void onPurchasesUpdated(BillingResult billingResult, List<Purchase> purchases) {
				// 支付回调
				int responseCode = billingResult.getResponseCode();
				// 购买成功
				if (responseCode == BillingClient.BillingResponseCode.OK) {
					for (Purchase purchase : purchases) {
						Log.d(TAG, "mSignature: " + purchase.getSignature() + ", mOriginalJson: " + purchase.getOriginalJson());
						if (purchase.getSku().equals(m_curPurchaseId)) {
							if(m_url != null && !m_url.equals("") && m_postData != null && !m_postData.equals("")){
								HashMap<String, Object> postParam = new HashMap<String, Object>();
								postParam.put("paymode", 1);
								postParam.put("signature", purchase.getSignature());
								postParam.put("purchase", purchase.getOriginalJson());
								final HashMap<String, String> postEntity = PHPPost.getPostEntity(m_postData, postParam, m_encryptStr);

								//成功地获得了sku购买信息
								payCompelete (purchase,postEntity);
								callbackLuaForPurchaseFinished("success");
							}
						}
					}
				} else if (responseCode == BillingClient.BillingResponseCode.USER_CANCELED) {
					//用户取消了购买流程
					callbackLuaForPurchaseFinished("cancell");
				} else {
					//出现其他错误，具体查询返回的状态码
					callbackLuaForPurchaseFinished(billingResult.getResponseCode() + "");

				}
			}
		};
		billingClient = BillingClient.newBuilder(AppActivity.mActivity)
				.setListener(purchasesUpdatedListener)
				.enablePendingPurchases()
				.build();
	}

	// 检查 Google Play 连接
	public boolean checkGooglePlayConnection() {
		if(billingClient == null) {
			this.initialize();
			return false;
		}
		// 连接OK
		if (billingClient.isReady())
			return true;

		// 开始连接
		billingClient.startConnection(new BillingClientStateListener() {
			@Override
			public void onBillingSetupFinished(BillingResult billingResult) {
				// Logic from ServiceConnection.onServiceConnected should be moved here.
				Log.d(TAG, "OnIabSetupFinishedListener getResponseCode:"+billingResult.getResponseCode());
				if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
					// Have webeen disposed of in the meantime? If so, quit.
					iap_is_ok = true;
					Log.d(TAG, "Setupsuccessful. Querying inventory.");
					try {
						queryPurchasesAsync();
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					Log.d(TAG, "OnIabSetupFinishedListener result.isFailed!");
					iap_is_ok = false;
				}
				if(m_googlepay_luaFunc >= 0)
				{
					AppActivity.mActivity.runOnGLThread(new Runnable() {
						@Override
						public void run() {
							String result = iap_is_ok == true ? "1" : "0";
							Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_googlepay_luaFunc,result);
							Cocos2dxLuaJavaBridge.releaseLuaFunction(m_googlepay_luaFunc);
						}
					});
				}
			}

			@Override
			public void onBillingServiceDisconnected() {
				// Logic from ServiceConnection.onServiceDisconnected should be moved here.
				iap_is_ok = false;
			}

			// 查询购买信息
			private void queryPurchasesAsync() {
				Purchase.PurchasesResult purchasesResult = billingClient.queryPurchases(BillingClient.SkuType.INAPP);
				if (purchasesResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
					// 有购买信息，待消耗
					List<Purchase> purchases = purchasesResult.getPurchasesList();
					for (Purchase purchase : purchases) {
						Log.d(TAG, "mSignature: " + purchase.getSignature() + ", mOriginalJson: " + purchase.getOriginalJson());
						if(m_url != null && !m_url.equals("") && m_postData != null && !m_postData.equals("")){
							HashMap<String, Object> postParam = new HashMap<String, Object>();
							postParam.put("paymode", 1);
							postParam.put("signature", purchase.getSignature());
							postParam.put("purchase", purchase.getOriginalJson());

							final HashMap<String, String> postEntity = PHPPost.getPostEntity(m_postData, postParam, m_encryptStr);
							payCompelete (purchase,postEntity);
						}
					}
				}

				// 如果支持订阅，将添加订阅处理
				/*BillingResult featureSupported = billingClient.isFeatureSupported(BillingClient.FeatureType.SUBSCRIPTIONS);
				if (featureSupported.getResponseCode() == BillingClient.BillingResponseCode.OK) {
					// 查询订阅
				}*/
			}
		});

		return false;
	}

	// 查询商品信息
	private void querySkuDetailsAsync(final String SKU_ID, final QueryCallback callback) {
		if (!checkGooglePlayConnection())
			return;

		List<String> skuList = new ArrayList<>();
		skuList.add(SKU_ID);

		SkuDetailsParams.Builder params = SkuDetailsParams.newBuilder();
		params.setSkusList(skuList).setType(BillingClient.SkuType.INAPP);

		billingClient.querySkuDetailsAsync(params.build(),
			new SkuDetailsResponseListener() {
				@Override
				public void onSkuDetailsResponse(BillingResult billingResult, List<SkuDetails> skuDetailsList) {
					// Process the result.
					if (billingResult.getResponseCode() != BillingClient.BillingResponseCode.OK) {
						return;
					}

					Log.d(TAG, "查询成功！");
					if(skuDetailsList != null && skuDetailsList.size() > 0) {
						for (final SkuDetails details :skuDetailsList) {
							if (SKU_ID.equals(details.getSku())) {
								m_curSkuDetails = details;
								if (callback != null) {
									callback.onResult(m_curSkuDetails);
								}
								break;
							}
						}
					}
				}
			});
	}

	// 启动支付弹框
	public void startGooglePay(final int luaFunc, final String productId, final String orderId) {
		if(!iap_is_ok){
			callbackLuaForPurchaseFinished("Nosurport");
			return;
		}

		if (!checkGooglePlayConnection())
			return;

		m_luaFunc = luaFunc;
		m_curPurchaseId = productId;

		//调用支付接口
		try{
			QueryCallback callback = new QueryCallback() {
				@Override
				public void onResult(final SkuDetails sku) {
					BillingFlowParams billingFlowParams = BillingFlowParams.newBuilder()
							.setSkuDetails(sku)
							.setObfuscatedAccountId(orderId)
							.build();
					billingClient.launchBillingFlow(AppActivity.mActivity, billingFlowParams);
				}
			};

			this.querySkuDetailsAsync(productId, callback);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 支付完成消耗
	private void payCompelete (final Purchase purchase,final HashMap<String, String> postEntity)
	{
		if(postEntity == null || purchase == null){
			return ;
		}
		/* 
		 * android API 4.0 + :
		 * Can not request network in UI-thread 
		 * use thread instead 
		 */
		Thread thread = new Thread(new Runnable() {

			@Override
			public void run() {
				/*
				 * call pay.Complete phpAPI 
				 */
				PHPResult phpResult = PHPPost.postUrl(AppActivity.mActivity, m_url, postEntity, 8);
				if(phpResult.code == PHPResult.SUCCESS){
					JSONObject jsonObject = null;  
					try {
						/* 
						 * if the pay.complete succeed ,we need consume the purchase imm 
						 */
						jsonObject = new JSONObject(phpResult.retStr);
						int ret = jsonObject.getInt("ret");
						if (jsonObject == null) return ;
						Log.i("GooglePay", "payCompelete ret:"+ret);
						if( ret == 1 || ret == -45) {
							/*
							 * consuming Purchase must be called at UI-thread
							 */
							AppActivity.mActivity.runOnUiThread(new Runnable() {
								@Override
								public void run() {
									// consume it all
									try {
										if (!checkGooglePlayConnection())
											return;

										ConsumeParams consumeParams = ConsumeParams.newBuilder()
											.setPurchaseToken(purchase.getPurchaseToken())
											.build();

										final ConsumeResponseListener listener = new ConsumeResponseListener() {
											@Override
											public void onConsumeResponse(BillingResult billingResult, String purchaseToken) {
												if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
													// 消费成功  处理自己的流程，比如存入数据库
													// 去应用的业务后台进行订单验证及返回结果
												} else {
													// 消费失败,后面查询消费记录后再次消费，否则，就只能等待退款
												}
											}
										};

										billingClient.consumeAsync(consumeParams, listener);

									} catch (Exception e) {
										e.printStackTrace();
									}
								}
							});
						}
					} catch (JSONException e1) {  
						e1.printStackTrace();  
					}  
				}
			}
		});
		thread.start();
	}

	// 购买结束回调
	public void callbackLuaForPurchaseFinished(final String result )
	{
		if(m_luaFunc < 0)
			return;
		AppActivity.mActivity.runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_luaFunc,result);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(m_luaFunc);
				m_luaFunc = -1;
			}
		});
	}

	
    // Listener that's called when we finish querying the items and subscriptions we own
	/*SkuDetailsResponseListener mGotInventoryListener = new SkuDetailsResponseListener() {
        @Override
        public void onQueryInventoryFinished(IabResult result, Inventory inventory) {
            if (mHelper== null)
            	return;
            if (result.isFailure()) {
            	return;
            }
            Log.d(TAG, "查询成功！");

            List<Purchase> purchases = inventory.getAllPurchases();
            if(purchases != null && purchases.size() > 0) {
            	for (final Purchase thisPurchase :purchases) { 
            		Log.d(TAG, "mSignature: " + thisPurchase.getSignature() + ", mOriginalJson: " + thisPurchase.getOriginalJson());
            		if(m_url != null && !m_url.equals("") && m_postData != null && !m_postData.equals("")){
            			HashMap<String, Object> postParam = new HashMap<String, Object>();
            			postParam.put("paymode", 1);
            			postParam.put("signature", thisPurchase.getSignature());
            			postParam.put("purchase", thisPurchase.getOriginalJson());
            			final HashMap<String, String> postEntity = PHPPost.getPostEntity(m_postData, postParam, m_encryptStr);
            			
            			payCompelete (thisPurchase,postEntity);
            		}
            	}
            }
        }
    };*/
    
	// get product details from varies productstr (with | concated)
	public void getProductInfo(final String productStr, final int luaFuncId) throws JSONException{

		if (!checkGooglePlayConnection())
			return;
    	
    	/*
    	 * max 20skus of calling getSkuDetails () and this must be a bug for billing module
    	 * instead we use another querySkuDetails () for getting > 20 numbers of items
    	 * 
    	 * 									2018/5/11 casey 
    	 */
    	try {
			System.out.println("productStr : " + productStr);

			// format as List
			String []productIds = productStr.split("\\|");
			List<String> skuList = Arrays.asList(productIds);

			SkuDetailsParams.Builder params = SkuDetailsParams.newBuilder();
			params.setSkusList(skuList).setType(BillingClient.SkuType.INAPP);

			billingClient.querySkuDetailsAsync(params.build(),
				new SkuDetailsResponseListener() {
					@Override
					public void onSkuDetailsResponse(BillingResult billingResult, List<SkuDetails> skuDetailsList) {
						// Process the result.
						if (billingResult.getResponseCode() != BillingClient.BillingResponseCode.OK) {
							return;
						}

						Log.d(TAG, "查询成功！");
						TreeMap<String, String> treeMap = new TreeMap<String, String>();

						if(skuDetailsList != null && skuDetailsList.size() > 0) {
							for (final SkuDetails d :skuDetailsList) {
								treeMap.put(d.getSku(), d.getPrice() + "|" + d.getPriceCurrencyCode() + "|" + d.getPriceAmountMicros());
							}

							// call lua func
							JsonUtil json = new JsonUtil(treeMap);
							final String skuInfo = json.toString();
							System.out.println("skuInfo : " + skuInfo);

							AppActivity.mActivity.runOnGLThread(new Runnable() {
								@Override
								public void run() {
									Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId,skuInfo);
									Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFuncId);
								}
							});
						}
					}
				});
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    
    /* Called when consumption is complete
    * 如果是消耗品的话 需要调用消耗方法
    */
	/*IabHelper.OnConsumeFinishedListener mConsumeFinishedListener = new IabHelper.OnConsumeFinishedListener() {
		@Override
		public void onConsumeFinished(Purchase purchase, IabResult result) {
			Log.d(TAG, "消耗操作完成.产品为:" + purchase + ", 结果: " + result);
			// if we were disposed of in the meantime, quit.
			if (mHelper == null)
				return;
			// 如果有多个消耗产品，应该在这里一一检查。这里只有一个消耗产品，所以不检查
			if (result.isSuccess()) {
				// 消耗成功后，填 写我们的逻辑。
			}
			else {
			}
		}
	};*/
	
	 /* Called when consumption is complete
	    * 如果是消耗品的话 需要调用消耗方法
	    */
	/*IabHelper.OnConsumeMultiFinishedListener mConsumeMultiFinishedListener= new IabHelper.OnConsumeMultiFinishedListener() {
		@Override
		public void onConsumeMultiFinished(List<Purchase> purchases,
				List<IabResult> results) {
			// TODO 自动生成的方法存根
		}  
	};*/



	
	/* Callback for when a purchase isfinished
	* 购买成功处理
	*/
/*	IabHelper.OnIabPurchaseFinishedListener mPurchaseFinishedListener = new IabHelper.OnIabPurchaseFinishedListener() {
		@Override
		public void onIabPurchaseFinished(IabResult result, final Purchase purchase) {
			// TODO Auto-generated method stub      
			Log.d(TAG, "购买操作完成:" + result + ", 购买的产品: " + purchase);            
			if (mHelper == null) {
				callbackLuaForPurchaseFinished("Nosurport");
				return;
			}
			if (result.isFailure()) {	
				callbackLuaForPurchaseFinished("fail");
				return;
			}
			Log.d(TAG, "mSignature: " + purchase.getSignature() + ", mOriginalJson: " + purchase.getOriginalJson());
			if (purchase.getSku().equals(m_curPurchaseId)) {
				// mHelper.consumeAsync(purchase, mConsumeFinishedListener);
				if(m_url != null && !m_url.equals("") && m_postData != null && !m_postData.equals("")){
					HashMap<String, Object> postParam = new HashMap<String, Object>();
        			postParam.put("paymode", 1);
        			postParam.put("signature", purchase.getSignature());
        			postParam.put("purchase", purchase.getOriginalJson());
        			final HashMap<String, String> postEntity = PHPPost.getPostEntity(m_postData, postParam, m_encryptStr);
        			payCompelete (purchase,postEntity);
        		}
			}
			
			if(m_luaFunc >= 0)
    		{
				callbackLuaForPurchaseFinished("success");
    		}
		}
	};*/
    
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "onActivityResult(" + requestCode + "," + resultCode + "," + data);
      /*  if (mHelper == null) return;

        // Pass on the activity result to the helper for handling
        if (!mHelper.handleActivityResult(requestCode, resultCode, data)) {
            // not handled, so handle it ourselves (here's where you'd
            // perform any handling of activity results not related to in-app
            // billing...
        }
        else {
            Log.d(TAG, "onActivityResult handled by IABUtil.");
        }*/
    }
    
    public void onDestroy(){  
        // very important:
        Log.d(TAG, "Destroying helper.");
      /*  if (mHelper != null) {
            mHelper.disposeWhenFinished();
            mHelper = null;
        }*/
    }

	// 实现接口的回调方法
	public interface QueryCallback {
		void onResult(SkuDetails details);
	}
}