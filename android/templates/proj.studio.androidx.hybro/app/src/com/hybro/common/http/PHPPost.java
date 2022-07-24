package com.hybro.common.http;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.params.HttpClientParams;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.hybro.common.utility.JsonUtil;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

public class PHPPost {
	public static final int TIMEOUT = 10000;
	private static int countTry502 = 0;
	private static int countTryOther = 0;

	public static Bitmap loadPic(String uri) {
		countTry502 = 0;
		countTryOther = 0;
		return httpGetPic(uri, 1);
	}

	public static Bitmap httpGetPic(String uri, int try502) {
		if (uri == null || 0 == uri.length())
			return null;
		if (countTry502 > 1 || countTryOther > 1)
			return null;
		Bitmap bitmap = null;	
		URL url = null;
		URLConnection connection = null;
		HttpURLConnection httpConnection = null;
		InputStream in = null;
		try {
			url = new URL(uri);
			connection = url.openConnection();
			
			httpConnection = (HttpURLConnection) connection;
			HttpURLConnection.setFollowRedirects(true);
			if (try502 != 2) {
				httpConnection.setDoOutput(true);
				httpConnection.setDoInput(true);
				httpConnection.setUseCaches(false);
				httpConnection.setAllowUserInteraction(false);
				httpConnection.setRequestMethod("GET");
			}
			httpConnection.connect();
			int responseCode = httpConnection.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) {
				in = httpConnection.getInputStream();
				ByteArrayOutputStream outstream = new ByteArrayOutputStream();
				byte[] buffer = new byte[512];
				int len = -1;
				while ((len = in.read(buffer)) != -1) {
					outstream.write(buffer, 0, len);
				}
				byte[] data = outstream.toByteArray();
				outstream.close();
				in.close();
				bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
			} else {
				Log.e("PHPPost", "responseCode=" + responseCode);
				if (502 == responseCode && 1 == try502) {
					countTry502 += 1;
					return httpGetPic(uri, 0);
				}else if (responseCode >= 300  && responseCode < 307) {
					String location = httpConnection.getHeaderField("Location");	
					return httpGetPic(location, 2);
				} else {
					countTryOther += 1;
					return httpGetPic(uri, 2);
				}

			}
		} catch (Exception e) {
			Log.e("PHPPost", e.toString());
			Log.e("PHPPost", uri);
			return bitmap;
		} finally {
			if (null != httpConnection) {
				httpConnection.disconnect();
				httpConnection = null;
			}
		}
		return bitmap;
	}

	public static File httpGetFile(String uri, int try502) {
		if (uri == null || 0 == uri.length())
			return null;
		if (countTry502 > 1 || countTryOther > 1)
			return null;
		File file = null;
		URL url = null;
		URLConnection connection = null;
		HttpURLConnection httpConnection = null;
		InputStream in = null;

		try {
			url = new URL(uri);
			connection = url.openConnection();

			httpConnection = (HttpURLConnection) connection;
			if (try502 != 2) {
				httpConnection.setDoOutput(true);
				httpConnection.setDoInput(true);
				httpConnection.setUseCaches(false);
				httpConnection.setAllowUserInteraction(false);
				httpConnection.setRequestMethod("GET");
			}
			httpConnection.connect();

			int responseCode = httpConnection.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) {
				file = File.createTempFile("httpGetFile", "");
				in = httpConnection.getInputStream();
				FileOutputStream fos = new FileOutputStream(file);
				byte[] buffer = new byte[512];
				int len = -1;
				while ((len = in.read(buffer)) != -1) {
					fos.write(buffer, 0, len);
				}
				fos.close();
				in.close();
			} else {
				Log.e("PHPPost", "responseCode=" + responseCode);
				if (502 == responseCode && 1 == try502) {
					countTry502 += 1;
					return httpGetFile(uri, 0);
				} else {
					countTryOther += 1;
					return httpGetFile(uri, 2);
				}
			}
		} catch (Exception e) {
			Log.e("PHPPost", e.toString());
			Log.e("PHPPost", uri);
		} finally {
			if (null != httpConnection) {
				httpConnection.disconnect();
				httpConnection = null;
			}
		}
		return null;
	}

	public static PHPResult post(Context context, String url, String data, int timeout) {
		PHPResult result = new PHPResult();
		
		HttpPost postRequest = new HttpPost(url);
		HttpClient client = null;
		HttpResponse response = null;

		HttpParams httpParams = new BasicHttpParams();
		HttpConnectionParams.setConnectionTimeout(httpParams, timeout);
		HttpConnectionParams.setSoTimeout(httpParams, timeout);
		HttpConnectionParams.setSocketBufferSize(httpParams, 8 * 1024); // Socket数据缓存默认8K
		HttpConnectionParams.setTcpNoDelay(httpParams, false);
		HttpConnectionParams.setStaleCheckingEnabled(httpParams, false);
		HttpClientParams.setRedirecting(httpParams, false);
		client = new DefaultHttpClient(httpParams);

		try {
			client.getParams().setParameter(HttpConnectionParams.CONNECTION_TIMEOUT, timeout);
			client.getParams().setParameter(HttpConnectionParams.SO_TIMEOUT, timeout);

			StringEntity entity = new StringEntity(data, HTTP.UTF_8);
			postRequest.setEntity(entity);
			postRequest.addHeader("content-type", "application/x-www-form-urlencoded");

			response = client.execute(postRequest);
			int code = response.getStatusLine().getStatusCode();
			result.code = code;
			if (code == HttpURLConnection.HTTP_OK) {
				result.retStr = EntityUtils.toString(response.getEntity());
				result.code = PHPResult.SUCCESS;
			} else {
				// same as above ?
				result.retStr = EntityUtils.toString(response.getEntity());
			}
		} catch (MalformedURLException e) {
			System.out.println("PHPPost"+ e.getStackTrace());
			// 抛出这一异常指示出现了错误的 URL。或者在规范字符串中找不到任何合法协议，或者无法分析字符串
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("MalformedURLException");
		} catch (ProtocolException e) {
			// 协议故障
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("ProtocolException");
		} catch (ConnectTimeoutException e) {
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("ConnectTimeoutException");
		} catch (IOException e) {
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("IOException");
		} catch (Exception e) {
			result.code = PHPResult.NETWORK_ERROR;
		} finally {
		}
		return result;
	}

	public static PHPResult postUrl(Context context, String url, HashMap<String, String> data, int timeout) {
		PHPResult result = new PHPResult();
//Log.d("Php post", "request url : " + url);
		HttpPost postRequest = new HttpPost(url);
		HttpClient client = null;
		HttpResponse response = null;

		client = new DefaultHttpClient();

		try {
//			client.getParams().setParameter(HttpConnectionParams.CONNECTION_TIMEOUT, timeout);
//			client.getParams().setParameter(HttpConnectionParams.SO_TIMEOUT,timeout);

			List<NameValuePair> postParams = new ArrayList<NameValuePair>();
			for (Map.Entry<String, String> entry : data.entrySet()) {
				postParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
			}

			HttpEntity entity = new UrlEncodedFormEntity(postParams);
			postRequest.setEntity(entity);

//Log.d("Php post", "client execute");
			response = client.execute(postRequest);
			int code = response.getStatusLine().getStatusCode();
			result.code = code;
Log.d("Php post", "response code : " + code);
			if (code == HttpURLConnection.HTTP_OK) {
				result.retStr = EntityUtils.toString(response.getEntity());
Log.d("Php post", "response retStr : " + result.retStr);
				result.code = PHPResult.SUCCESS;
			} else {
				// same as above ?
				result.retStr = EntityUtils.toString(response.getEntity());
			}
		} catch (MalformedURLException e) {
			// 抛出这一异常指示出现了错误的 URL。或者在规范字符串中找不到任何合法协议，或者无法分析字符串
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("MalformedURLException");
		} catch (ProtocolException e) {
			// 协议故障
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("ProtocolException");
		} catch (ConnectTimeoutException e) {
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("ConnectTimeoutException");
		} catch (IOException e) {
			result.code = PHPResult.NETWORK_ERROR;
			result.setError("IOException");
		} catch (Exception e) {
			result.code = PHPResult.NETWORK_ERROR;
		} finally {
		}
		return result;
	}

	public static HashMap<String, String> getPostEntity(String postData, HashMap<String, Object> param, String encryptStr) {
		String dStr = null;
		try {
			TreeMap<String, Object> treeMap = new TreeMap<String, Object>();

			// 将json字符串转换成jsonObject  
			JSONObject jsonObject = new JSONObject(postData);  
			Iterator<?> it = jsonObject.keys();  
			// 遍历jsonObject数据，添加到Map对象  
		   while (it.hasNext())  
		   {  
		       String key = String.valueOf(it.next());  
		       Object value = jsonObject.get(key);  
		       treeMap.put(key, value);  
		   } 
//		   treeMap.toString();
		   treeMap.put("param", param);
		   JsonUtil json = new JsonUtil(treeMap);
		   dStr = json.toString();
		} catch (JSONException e1) {
			e1.printStackTrace();
			return null;
		}  		
		
		String hashStr = JsonUtil.stringToMD5(encryptStr + dStr);
		Log.d("Php post", "d : " + dStr + ", s : " + hashStr);
		HashMap<String, String> postEntity = new HashMap<String, String>();
		postEntity.put("d", dStr);
		postEntity.put("s", hashStr);
		
		return postEntity;
	}
}
