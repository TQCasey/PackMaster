package com.zhijian.common.utility;

import java.util.Arrays;
import java.util.Iterator;
import java.util.TreeMap;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.Profile;
import com.facebook.ProfileTracker;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.Sharer;
import com.facebook.share.model.GameRequestContent;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.GameRequestDialog;
import com.facebook.share.widget.ShareDialog;
import com.cynking.capsa.R;

public class FbLoginAndShare {
	private static FbLoginAndShare mInstance = null;
	private static Activity mContext = null;
	
    public CallbackManager callbackManager;
    private GameRequestDialog requestDialog;
    private int m_curLuaFuncId = -1;
    public ProfileTracker profileTracker;
    private Boolean m_isRequestFriend = false;
    private ShareDialog shareDialog;
    private int m_curShareFuncId = -1;
    
	public static FbLoginAndShare instance() {
		if (null == mInstance) {
			mInstance = new FbLoginAndShare();
		}
		return mInstance;
	}
	
	public void init()
	{
		try {

			mContext = AppActivity.mActivity;
			FacebookSdk.sdkInitialize(mContext.getApplicationContext());
			facebookRegister();
	        
        	String ads_id = Integer.toString(R.string.facebook_ads_id);
	        AppEventsLogger.activateApp(mContext, ads_id);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void configFacebook (final String jstr) {
		JSONObject json = null;

		// decode
		try {
			json = new JSONObject(jstr);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			//handle_exception(e1);
		}

		Iterator<?> it = json.keys();

		String appid = "";
		String adsid = "";

		while (it.hasNext()) {
			String key = it.next().toString();
			String value = null;

			try {
				value = json.getString(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				//handle_exception(e);
			}

			//
			if (value == null)
				continue;

			if (key.equals("appid")) {
				appid = value.toString();
			} else if (key.equals("adsid")) {
				adsid = value.toString();
			}
		}

		/* if validate */
		if (appid.length() > 0) {
			
			/* reset old facebook app id if in case */
			facebookLogout ();
			
			/* set new facebook app id */
			FacebookSdk.setApplicationId(appid);
			
			/* facebook is necessary */
			if (adsid.length() > 0) {
				
				/* set new advertise id if there is */
				AppEventsLogger.activateApp(mContext, adsid);
			}
		}
	}

    public void facebookRegister(){
    	callbackManager = CallbackManager.Factory.create();
    	requestDialog = new GameRequestDialog(mContext);
    	requestDialog.registerCallback(callbackManager,
		    new FacebookCallback<GameRequestDialog.Result>() {
			    @Override
			    public void onSuccess(GameRequestDialog.Result result) {
			    	String id = result.getRequestId();
			    	System.out.println("RequestId : " + id);
			    	facebookInvitRst("success");
			    }
			    @Override
			    public void onCancel() {
			    	System.out.print("GameRequestDialog onCancel");
			    	facebookInvitRst("cancel");
			    }
			    @Override
			    public void onError(FacebookException error) {
			    	System.out.print("GameRequestDialog error : " + error.getStackTrace());
			    	facebookInvitRst("error");
			    }
			}
	    );   	

    	LoginManager.getInstance().registerCallback(callbackManager,
            new FacebookCallback<LoginResult>() {
                @Override
                public void onSuccess(LoginResult loginResult) {
                	AccessToken accessToken = loginResult.getAccessToken();
                	if(accessToken != null&& !accessToken.isExpired())
                	{
                		String tokenId = accessToken.getToken();
            			String userId = accessToken.getUserId();
            			if(tokenId != null && userId != null)
            			{
            				facebookLoginRst(0, tokenId, userId);
            				return;
            			}
                	}
                }

                @Override
                public void onCancel() {
                	AccessToken accessToken = AccessToken.getCurrentAccessToken();
            		if (accessToken != null) {
            			String tokenId = accessToken.getToken();
            			String userId = accessToken.getUserId();
            			if(tokenId != null && userId != null)
            			{
            				facebookLoginRst(0, tokenId, userId);
            				return;
            			}
            		}
            		facebookLoginRst(1, null, null);
                }

                @Override
                public void onError(FacebookException exception) {
                	facebookLoginRst(2, null, null);
                }
			});

    	 shareDialog = new ShareDialog(mContext);
         shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
			@Override
			public void onSuccess(Sharer.Result result) {
				facebookShareRst(1);
			}

			@Override
			public void onCancel() {
				facebookShareRst(3);
			}

			@Override
			public void onError(FacebookException error) {
				facebookShareRst(2);
			}
		});

    	profileTracker = new ProfileTracker() {
            @Override
            protected void onCurrentProfileChanged(Profile oldProfile, Profile currentProfile) {
//            	System.out.println("fbInfo currentProfile id = " + currentProfile.getId());	
//            	facebookLoginRst(0, currentProfile);
            	AccessToken accessToken = AccessToken.getCurrentAccessToken();
        		if (accessToken != null) {
        			String tokenId = accessToken.getToken();
        			String userId = accessToken.getUserId();
        			if(tokenId != null && userId != null)
        			{
        				facebookLoginRst(0, tokenId, userId);
        				return;
        			}
        		}
            }
        };
    }
    
    public void facebookInvitRst(final String ret)
    {
		if(m_curShareFuncId >= 0)
		{
			AppActivity.mActivity.runOnGLThread(new Runnable() {
	            @Override
	            public void run() {
	            	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_curShareFuncId,  ret);
	    			Cocos2dxLuaJavaBridge.releaseLuaFunction(m_curShareFuncId);
	    			m_curShareFuncId = -1;
	            }
	        });
		}
    }
    
    public void facebookShareRst(final int ret)
    {
		if(m_curShareFuncId >= 0)
		{
			AppActivity.mActivity.runOnGLThread(new Runnable() {
	            @Override
	            public void run() {
	            	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_curShareFuncId,  ret + "");
	    			Cocos2dxLuaJavaBridge.releaseLuaFunction(m_curShareFuncId);
	    			m_curShareFuncId = -1;
	            }
	        });
		}
    }

    public void facebookLogin(int luaFuncId)
    {
    	m_curLuaFuncId = luaFuncId;
		AccessToken accessToken = AccessToken.getCurrentAccessToken();
		if (accessToken != null) {
			String tokenId = accessToken.getToken();
			String userId = accessToken.getUserId();
			if(tokenId != null && userId != null)
			{
				facebookLoginRst(0, tokenId, userId);
				return;
			}
		}
        
		// LoginManager.getInstance().logInWithPublishPermissions(this,
		// Arrays.asList("publish_actions"));
		String[] permission = {"public_profile", "email"};
        LoginManager.getInstance().logInWithReadPermissions(AppActivity.mActivity, Arrays.asList(permission));
    }
    
    public void facebookLogout()
    {
    	try {
			LoginManager.getInstance().logOut();
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
   
    public void facebookLoginRst(int ret, String accessToken, String userId)
    {
    	if(m_isRequestFriend == true)
    	{
    		showFriendDlg();
    		return;
    	}
    	TreeMap<String, Object> map = new TreeMap<String, Object>();
		map.put("result", ret);		

    	if(ret == 0)
    	{
    		map.put("token", accessToken);
    		map.put("uid", userId);
    	}
		JsonUtil json = new JsonUtil(map);
		final String fbInfo = json.toString();
		System.out.println("fbInfo = " + fbInfo + ", m_curLuaFuncId = " + m_curLuaFuncId);
		if(m_curLuaFuncId >= 0)
		{
			AppActivity.mActivity.runOnGLThread(new Runnable() {
	            @Override
	            public void run() {
	            	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_curLuaFuncId, fbInfo);
	    			Cocos2dxLuaJavaBridge.releaseLuaFunction(m_curLuaFuncId);
	    			m_curLuaFuncId = -1;
	            }
	        });
		}
    }
    
    public void showFriendDlg()
    {
    	m_isRequestFriend = false;
    	GameRequestContent content = new GameRequestContent.Builder()
//    	.setTitle((String)this.getResources().getText(R.string.facebook_share_title))
        .setMessage((String)mContext.getResources().getText(R.string.facebook_share_msg))
//        .setActionType(ActionType.SEND)
//        .setObjectId("1051333554898444")
        .setFilters(GameRequestContent.Filters.APP_NON_USERS)
        .build();
    	
    	requestDialog.show(content);
    }
    
    public void showInviteFriendDlg(String FriendIds, String title, String message, int luaFuncId)
    {
    	m_curShareFuncId = luaFuncId;
    	GameRequestContent content = new GameRequestContent.Builder()
    	.setTitle(title)
    	.setTo(FriendIds)
        .setMessage(message)
        .build();
    	
    	requestDialog.show(content);
    }
    
    public void showRequestDlg()
    {
		AccessToken accessToken = AccessToken.getCurrentAccessToken();
		if (accessToken != null) {
			showFriendDlg();
		}else{
			m_isRequestFriend = true;
			String[] permission = {"public_profile", "email"};
			LoginManager.getInstance().logInWithReadPermissions(AppActivity.mActivity, Arrays.asList(permission));
		}
    }
    
    public void RequestFbLoginFriend(final int luaFuncId)
    {
		new GraphRequest(
		    AccessToken.getCurrentAccessToken(),
		    "/me/friends",
		    null,
		    HttpMethod.GET,
		    new GraphRequest.Callback() {
		        @Override
		        public void onCompleted(GraphResponse response) {
	            	FacebookRequestError requestError = response.getError();
	                FacebookException exception = (requestError == null) ? null : requestError.getException();
	                if (response.getJSONObject() == null && exception == null) {
	                    exception = new FacebookException("GraphObjectPagingLoader received neither a result nor an error.");
	                }

	                if (exception != null) {
	                	System.out.println("GraphRequest error : " + exception.getMessage() + ", trace : " + exception.getStackTrace());
	                } else {
	                	final JSONObject graphObject = response.getJSONObject();

	                	AppActivity.mActivity.runOnGLThread(new Runnable() {
	         	            @Override
	         	            public void run() {
	         	            	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId, graphObject.toString());
	         	    			Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFuncId);
	         	            }
	                	});
	                }
		        }
		    }
		).executeAsync();
    } 
    
    public void RequestInvitableFriendList(final int luaFuncId)
    {
		Bundle bundle = new Bundle();
		bundle.putString("limit", "1000");
    	new GraphRequest(
		    AccessToken.getCurrentAccessToken(),
		    "/me/invitable_friends",
		    bundle,
		    HttpMethod.GET,
		    new GraphRequest.Callback() {
		        @Override
		        public void onCompleted(GraphResponse response) {
	            	FacebookRequestError requestError = response.getError();
	                FacebookException exception = (requestError == null) ? null : requestError.getException();
	                if (response.getJSONObject() == null && exception == null) {
	                    exception = new FacebookException("GraphObjectPagingLoader received neither a result nor an error.");
	                }

	                if (exception != null) {
	                	System.out.println("GraphRequest error : " + exception.getMessage() + ", trace : " + exception.getStackTrace());
	                } else {
	                	final JSONObject graphObject = response.getJSONObject();
	                	AppActivity.mActivity.runOnGLThread(new Runnable() {
	         	            @Override
	         	            public void run() {
	         	            	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFuncId, graphObject.toString());
	         	    			Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFuncId);
	         	            }
	                	});    
	                }
		        }
		    }
		).executeAsync();
    } 
    
    //https://www.facebook.com/CKDomino99/
    public void showShareDialog(final String shareTitle, final String shareContent, final String imgPath, final int luaFunc )
    {
    	m_curShareFuncId = luaFunc;
//    	System.out.println("shareTitle : " + shareTitle + ", + shareContent : " + shareContent + ", imgPath : " + imgPath);
    	if (ShareDialog.canShow(ShareLinkContent.class)) {
    	    ShareLinkContent linkContent = new ShareLinkContent.Builder()
    	            .setContentTitle(shareTitle)
    	            .setContentDescription(shareContent)
    	            .setContentUrl(Uri.parse("https://apps.facebook.com/ckdomino/"))
    	            .setImageUrl(Uri.parse(imgPath))
    	            .build();	    		
    	    shareDialog.show(linkContent);
    	}
    }

	public void showShareDialogEx(final String shareTitle, final String shareContent, final String imgPath, final int luaFunc, final String url) 
	{
		m_curShareFuncId = luaFunc;
		AppActivity.mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					if (url.equals("")) {
						facebookShareRst(2);
						return ;
					}

					if (ShareDialog.canShow(ShareLinkContent.class)) {
						ShareLinkContent linkContent = new ShareLinkContent.Builder()
							.setContentUrl(Uri.parse(imgPath))
							.setImageUrl(Uri.parse(url))
							.build();

						shareDialog.show(linkContent, ShareDialog.Mode.WEB);
					}
				} catch (Exception e) {
					facebookShareRst(2);
				}
			}
		});
	}
}
