package com.zhijian.common.utility;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class JsonUtil {
	private Map<String, Object> map;

	public JsonUtil() {
		map = new HashMap<String, Object>();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public JsonUtil(Map map) {
		this.map = map;
	}

	public void put(String key, Object value) {
		map.put(key, value);
	}

	@Override
	@SuppressWarnings("rawtypes")
	public String toString() {
		if (this.map.isEmpty()) {
			return "{}";
		}
		String result = "{";
		Set<String> keys = map.keySet();
		for (String key : keys) {
			Object value = map.get(key);
			if( value == null )
				continue;
			String valueString = value.toString();
			result += "\"" + unicode(key) + "\":";
			if (value instanceof JsonUtil) {
				result += valueString;
			} else if (value instanceof Map) {
				result += (new JsonUtil((Map) value).toString());
			} else if (value instanceof byte[]) {
				result += "\"\"";
			} else{
				result += "\"" + unicode(valueString) + "\"";
			}
			result += ",";
		}
		result = result.substring(0, result.length() - 1);
		result += "}";

		return result;
	}

	public static String unicode(String org) {
		if (org == null || org.length() == 0) return "";

		StringBuffer sb = new StringBuffer();
		for (char ch : org.toCharArray()) {
			switch(ch) {
				case '"':
					sb.append("\\\"");
					break;
				case '\\':
	                sb.append("\\\\");
	                break;
	            case '\b':
	                sb.append("\\b");
	                break;
	            case '\f':
	                sb.append("\\f");
	                break;
	            case '\n':
	                sb.append("\\n");
	                break;
	            case '\r':
	                sb.append("\\r");
	                break;
	            case '\t':
	                sb.append("\\t");
	                break;
	            case '/':
	                sb.append("\\/");
	                break;
	            default:
	            	if (ch >= '\u0000' && ch <= '\u001F') {
	                    String ss = Integer.toHexString(ch);
	                    sb.append("\\u");
	                    for (int k = 0; k < 4 - ss.length(); k++) {
	                        sb.append('0');
	                    }
	                    sb.append(ss.toUpperCase());
	                } else {
	                    sb.append(ch);
	                }
			}
		}
		return sb.toString();
	}
	
	 //
	  public static String getToUnicode(String zhStr){
	    	StringBuffer unicode = new StringBuffer();
	    	
			for (int i = 0; i < zhStr.length(); i++) {
				char c = zhStr.charAt(i);
				
				if(c>128){
					unicode.append("\\u" + Integer.toHexString(c));
				}else{
					unicode.append("\\" + c);
				}
			}
			return unicode.toString();
	    }
	
		/**
		 * 将字符串转成MD5值
		 * 
		 * @param string
		 * @return
		 */
		public static String stringToMD5(String string) {
			byte[] hash;

			try {
				hash = MessageDigest.getInstance("MD5").digest(string.getBytes("UTF-8"));
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
				return null;
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				return null;
			}

			StringBuilder hex = new StringBuilder(hash.length * 2);
			for (byte b : hash) {
				if ((b & 0xFF) < 0x10)
					hex.append("0");
				hex.append(Integer.toHexString(b & 0xFF));
			}

			return hex.toString();
		}
}
