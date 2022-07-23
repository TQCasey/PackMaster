package com.zhijian.common.utility;

import android.app.Activity;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.opengl.GLES20;
import android.os.Build;
import android.os.Environment;
import android.os.LocaleList;
import android.os.StatFs;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.util.Log;

import org.cocos2dx.lua.AppActivity;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.LineNumberReader;
import java.util.Locale;
import java.util.TreeMap;
import java.util.UUID;

public class DeviceInfo {
	private static DeviceInfo device = new DeviceInfo();
	private static TelephonyManager telephonyManager = null;
	private static SensorManager sensorManager = null;

	public static DeviceInfo getInstance() {
		return device;
	}

	public static Context getContext() {
		return AppActivity.mActivity;
	}

	public static Activity getActivity() {
		return AppActivity.mActivity;
	}

	public TreeMap<String, Object> getDeviceInfoGroup() {
		TreeMap<String, Object> map = new TreeMap<String, Object>();
		map.put("imei", SimUtil.getDeviceId());
		map.put("name", getDeviceName());
		map.put("imsi", SimUtil.getSimOperator());
		map.put("os_version", android.os.Build.VERSION.RELEASE);
		map.put("version_sdk", android.os.Build.VERSION.SDK);
		map.put("mac_id", SimUtil.getMacId());
		map.put("sim_type", SimUtil.getSimType());
		String accessToken = AppActivity.mActivity.accessToken;
		if(accessToken != null && accessToken.length() > 0){
			map.put("accessToken", accessToken);
		}
		
		map.put("core_num", "" + getNumberOfCPUCores());//核心数
		map.put("cpu_name", "" + getCpuName());         //cpu型号
		map.put("board", android.os.Build.BOARD);       //存储型号
		map.put("brand", android.os.Build.BRAND);       //手机型号
		map.put("imsi_ex", SimUtil.getSimOperator());       //设备网络代码
		map.put("net_countryIso", SimUtil.getNetworkCountryIso());  //回注册的网络运营商的国家代码
		map.put("language", getLanguage());       //系统语言
		
        DisplayMetrics metric = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(metric);
		map.put("resolution", metric.heightPixels + "X"+ metric.widthPixels);//分辨率--屏幕密度:metric.density
		
		map.put("ram", getRAM());    //RAM
		map.put("total_memory", getTotalMemory());    //总存储
		
		return map;
	}
	
	public String getDeviceInfo() {
		TreeMap<String, Object> map = new TreeMap<String, Object>();
		map.put("core_num", "" + getNumberOfCPUCores());//核心数
		map.put("cpu_name", "" + getCpuName());         //cpu型号
		map.put("cpu_serial", "" + getCPUSerial()); // cpu序列号
		map.put("board", android.os.Build.BOARD);       //存储型号
		
        DisplayMetrics metric = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(metric);
		map.put("resolution", metric.heightPixels + "X"+ metric.widthPixels);//分辨率
		map.put("net_operator", SimUtil.getNetworkOperator());  //回注册的网络运营商的代码
		map.put("net_countryIso", SimUtil.getNetworkCountryIso());  //回注册的网络运营商的国家代码
		map.put("language", getLanguage());       //系统语言
		map.put("brand", android.os.Build.BRAND);       //手机厂商

		map.put("ram", getRAM());    //RAM
		map.put("total_memory", getTotalMemory());    //总存储
//		map.put("isEmulator", isEmulator() ? "true" : "false"); //
		
		JsonUtil json = new JsonUtil(map);
		final String deviceInfo = json.toString();
		
		return deviceInfo;
	}
	
	public static synchronized TelephonyManager getTelephonyManager() {
		if (telephonyManager == null) {
			telephonyManager = (TelephonyManager) getActivity()
					.getSystemService("phone");
		}
		return telephonyManager;
	}

	public static String getUUID() {
		return UUID.randomUUID().toString();
	}
	
	/**
	 * 获取号码，可能获取不到
	 * @return
	 */
	public static String getPhoneNumber() {
		TelephonyManager manager = getTelephonyManager();
		String phoneNumber = null;
		try {
			phoneNumber = manager.getLine1Number();
		} catch (Exception e) {
			e.printStackTrace();
			phoneNumber = null;
		}

		if (phoneNumber != null)
			return phoneNumber;
		return "";
	}
	
	/**
	 * 获取设备名称，如MI 5S
	 * @return
	 */
	public static String getDeviceName(){
		String model = android.os.Build.MODEL;
		String name = "Guest_";
		if (model != null) {
			String names[] = model.split(" ");
			int length = names.length;
			if (length >= 3) {
				name = names[length - 2] + " " + names[length - 1];
			} else {
				name = model;
			}
		}
		return name;
	}
	
	/**
	 * 获取系统语言
	 * @return
	 */
	public static String getLanguage() {
		Locale locale;
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
			locale = LocaleList.getDefault().get(0);
		} else locale = Locale.getDefault();

		return locale.getLanguage() + "-" + locale.getCountry();
	}

	//主板型号
	private static String getBoard(String str) {
		return android.os.Build.BOARD;
	}
	
	/**
	 * 获取核心数
	 * @return
	 */
    public int getNumberOfCPUCores() {
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.GINGERBREAD_MR1) {
            // Gingerbread doesn't support giving a single application access to both cores, but a
            // handful of devices (Atrix 4G and Droid X2 for example) were released with a dual-core
            // chipset and Gingerbread; that can let an app in the background run without impacting
            // the foreground application. But for our purposes, it makes them single core.
            return 1;
        }
        int cores;
        try {
            cores = new File("/sys/devices/system/cpu/").listFiles(CPU_FILTER).length;
        } catch (SecurityException e) {
            cores = -1;
        } catch (NullPointerException e) {
            cores = -1;
        }
        return cores;
    }

    private final FileFilter CPU_FILTER = new FileFilter() {
        @Override
        public boolean accept(File pathname) {
            String path = pathname.getName();
            //regex is slow, so checking char by char.
            if (path.startsWith("cpu")) {
                for (int i = 3; i < path.length(); i++) {
                    if (path.charAt(i) < '0' || path.charAt(i) > '9') {
                        return false;
                    }
                }
                return true;
            }
            return false;
        }
    };
    	
    public long[] getSDCardMemory() {
        long[] sdCardInfo=new long[2];
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            File sdcardDir = Environment.getExternalStorageDirectory();
            StatFs sf = new StatFs(sdcardDir.getPath());
            long bSize = sf.getBlockSize();
            long bCount = sf.getBlockCount();
            long availBlocks = sf.getAvailableBlocks();

            sdCardInfo[0] = bSize * bCount;//总大小
            sdCardInfo[1] = bSize * availBlocks;//可用大小
        }
        return sdCardInfo;
    }

    /**
     * 获取手机运行内存大小RAM,GB
     *
     * @return
     */
    private String getRAM() {
        String str1 = "/proc/meminfo";   // 系统内存信息文件
        String str2;
        String[] arrayOfString = null;
        try {
            FileReader localFileReader = new FileReader(str1);
            BufferedReader localBufferedReader = new BufferedReader(localFileReader, 8192);
            str2 = localBufferedReader.readLine();// 读取meminfo第一行，系统总内存大小

            arrayOfString = str2.split("\\s+");
            for (String num : arrayOfString) {
                Log.i(str2, num + "\t");
            }

            localBufferedReader.close();
            return String.valueOf(Integer.valueOf(arrayOfString[1]).intValue() / (1024*1024));
        } catch (IOException e) {
        }
        return "";
    }
    
    /**
     * 获取当前总内存大小,GB
     *
     * @return
     */
    public String getTotalMemory() {
        String totalSDMemory = String.valueOf(getSDCardMemory()[0] / (1024.0 * 1024.0 * 1024.0));
        totalSDMemory = totalSDMemory.substring(0, totalSDMemory.indexOf(".") + 3);
//        String availableMemory = String.valueOf(getSDCardMemory()[1] / (1024.0 * 1024.0 * 1024.0));
//        availableMemory = availableMemory.substring(0, totalSDMemory.indexOf(".") + 3);
        return totalSDMemory;
    }

    /**
     * 获取当前可用内存大小
     *
     * @return
     */
    private String getAvailMemory() {
        String availableMemory = String.valueOf(getSDCardMemory()[1] / (1024.0 * 1024.0 * 1024.0));
        availableMemory = availableMemory.substring(0, availableMemory.indexOf(".") + 3);
        
        return availableMemory;
//        ActivityManager am = (ActivityManager) getActivity().getSystemService(Context.ACTIVITY_SERVICE);
//        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
//        am.getMemoryInfo(mi);
//        return Formatter.formatFileSize(getActivity().getBaseContext(), mi.availMem);
    }

    public static String getMaxCpuFreq() {
        String result = "";
        ProcessBuilder cmd;
        try {
            String[] args = {"/system/bin/cat",
                    "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"};
            cmd = new ProcessBuilder(args);
            Process process = cmd.start();
            InputStream in = process.getInputStream();
            byte[] re = new byte[24];
            while (in.read(re) != -1) {
                result = result + new String(re);
            }
            in.close();
        } catch (IOException ex) {
            ex.printStackTrace();
            result = "N/A";
        }
        int maxFreq = Integer.parseInt(result.trim())/(1024);
        return String.valueOf(maxFreq);
    }

    // 获取CPU最小频率（单位KHZ）
    public static String getMinCpuFreq() {
        String result = "";
        ProcessBuilder cmd;
        try {
            String[] args = {"/system/bin/cat",
                    "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq"};
            cmd = new ProcessBuilder(args);
            Process process = cmd.start();
            InputStream in = process.getInputStream();
            byte[] re = new byte[24];
            while (in.read(re) != -1) {
                result = result + new String(re);
            }
            in.close();
        } catch (IOException ex) {
            ex.printStackTrace();
            result = "N/A";
        }
        int minFreq = Integer.parseInt(result.trim())/(1024);
        return String.valueOf(minFreq);
    }

    // 实时获取CPU当前频率（单位KHZ）
    public static String getCurCpuFreq() {
        String result = "N/A";
        try {
            FileReader fr = new FileReader(
                    "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq");
            BufferedReader br = new BufferedReader(fr);
            String text = br.readLine();
            result = text.trim() + "Hz";
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    //cpu 型号
    public static String getCpuName() {
        try {
            FileReader fr = new FileReader("/proc/cpuinfo");
            BufferedReader br = new BufferedReader(fr);
            String text = br.readLine();
            String[] array = text.split(":\\s+", 2);
            for (int i = 0; i < array.length; i++) {
            }
            br.close();
            return array[1];
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

	public static String getCPUSerial() {
		String str = "", strCPU = "", cpuAddress = "0000000000000000";
		try {
			// 读取CPU信息
			FileReader fr = new FileReader("/proc/cpuinfo");
//			Process pp = Runtime.getRuntime().exec("cat/proc/cpuinfo");
//			InputStreamReader ir = new InputStreamReader(pp.getInputStream());
			LineNumberReader input = new LineNumberReader(fr);
			// 查找CPU序列号
			for (int i = 1; i < 100; i++) {
				str = input.readLine();
				if (str != null) {
					// 查找到序列号所在行
					if (str.indexOf("Serial") > -1) {
						// 提取序列号
						strCPU = str.substring(str.indexOf(":") + 1,
								str.length());
						// 去空格
						cpuAddress = strCPU.trim();
						break;
					}
				} else {
					// 文件结尾
					break;
				}
			}
			fr.close();
		} catch (IOException ex) {
			// 赋予默认值
			ex.printStackTrace();
		}
		return cpuAddress;
	}

	//android id 恢复出厂设置后会变
	public static String getAndroidID() {
		return Secure.getString(getContext().getContentResolver(), Secure.ANDROID_ID);
	}
}