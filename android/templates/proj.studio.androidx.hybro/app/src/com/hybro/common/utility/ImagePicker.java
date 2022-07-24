package com.hybro.common.utility;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.FileUtils;
import android.os.ParcelFileDescriptor;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.util.Log;
import android.webkit.MimeTypeMap;

import androidx.core.content.FileProvider;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class ImagePicker{
    public static final int     NONE = 0;
    public static final int     PHOTO_CAPTURE_HEAD = 1;     // 鎷嶇収鑾峰緱澶村儚
    public static final int     PHOTO_PICTURE_HEAD = 2;     // 鐩稿唽閫夋嫨澶村儚
    public static final int     PHOTORESOULT = 3;   // 缁撴灉
    public static final int     PHOTO_PICTURE_FEEDBACK = 4;     // 閫夋嫨鍙嶉鍥惧儚
    public static final String  IMAGE_UNSPECIFIED = "image/*";

    private static ImagePicker instance = null;
    private static Activity    activity = null;
    private int m_luaFunc = 0;
    private int m_headIndex = 0;
    private int m_feedBackIndex = 0;

    /*
     * for the indent call bitmap data size must be less than 40K
     * We use a private bitmap var to solve this problem
     *
     *                                          2017-6-2 casey
     */
    private static Uri          mUri;
    private int                 pic_size    = 570;


    public static ImagePicker getInstance(){
        if(instance == null){
            instance = new ImagePicker();
        }
        return instance;
    }

    // 鍒濆鍖�
    public void init(Activity activity){
        ImagePicker.activity = activity;

    }

    // 鎵撳紑鐩稿唽鑾峰緱澶村儚
    public void openPhotoForHead(int luaFunc){
        try {
            m_luaFunc = luaFunc;
            Intent intent = new Intent(Intent.ACTION_PICK, null);
            intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, IMAGE_UNSPECIFIED);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            activity.startActivityForResult(intent, PHOTO_PICTURE_HEAD);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 鎵撳紑鐩告満
    public void openCameraForHead(int luaFunc){
        m_luaFunc = luaFunc;

        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File tempFile = null;
//        if(Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
//                ||!Environment.isExternalStorageRemovable()){
//            tempFile=activity.getExternalCacheDir();
//        }else{
        tempFile=activity.getCacheDir();
//        }
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        Uri photoURI = null;
        if (Build.VERSION.SDK_INT >= 24) {
            photoURI = FileProvider.getUriForFile(activity, activity.getApplicationContext().getPackageName() + ".myprovider", new File(tempFile, "@cc_cameraCache.png"));
        } else {
            photoURI = Uri.fromFile(new File(tempFile, "@cc_cameraCache.png"));
        }

        intent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
        activity.startActivityForResult(intent, PHOTO_CAPTURE_HEAD);
    }

    public void openPhotoForFeedback(int luaFunc){
        m_luaFunc = luaFunc;

        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_PICK);
        // 设置文件类型
        intent.setType("image/*");
        activity.startActivityForResult(intent, PHOTO_PICTURE_FEEDBACK);
    }

    public void callbackLuaForPicture(final String picPath )
    {
        if(m_luaFunc < 0)
            return;
        AppActivity.mActivity.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(m_luaFunc,picPath);
                System.out.println("picPath : " + picPath);
                Cocos2dxLuaJavaBridge.releaseLuaFunction(m_luaFunc);
                m_luaFunc = -1;
            }
        });
    }

    // 鍥炶皟
    public void onActivityResult(int requestCode, int resultCode, Intent data){

        if (resultCode == NONE)
            return;

        // 鎷嶇収
        if (requestCode == PHOTO_CAPTURE_HEAD) {
            // 鐢熸垚鏂扮殑
            File picture = new File(getDiskCacheDir() + "/@cc_cameraCache.png");
            Uri uri;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                uri = FileProvider.getUriForFile(activity, activity.getApplicationContext().getPackageName() + ".myprovider", picture);
            } else {
                uri = Uri.fromFile(picture);
            }
            startPhotoZoom(uri, pic_size);
        }

        if (data == null)
            return;

        // 璇诲彇鐩稿唽缂╂斁鍥剧墖
        if (requestCode == PHOTO_PICTURE_HEAD) {
            System.out.println ("hello world ====> "  + data.getData());
            startPhotoZoom(data.getData(),pic_size);
        }

        // 璇诲彇鐩稿唽缂╂斁鍥剧墖
        if (requestCode == PHOTO_PICTURE_FEEDBACK) {
            Uri dataUri = data.getData();
            String path = getPath(dataUri);
            int maxSize = 600*1024;
            if (path != null)
            {
                String img_path = path;
                long size = getFileSize(path);
                String tmp = getDiskCacheDir() + "/" + "feedback_ori.jpg";
                //larger than 600K, compress
                //if it's png format and smaller than 750K, only convert to jpg format
                if (size < 750000){
                    if (compressImage(path, tmp, null, maxSize, dataUri)) img_path = tmp;
                } else {
                    //otherwise
                    BitmapFactory.Options options = new BitmapFactory.Options();
                    options.inJustDecodeBounds = true;
                    BitmapFactory.decodeFile(path, options);

                    int heightRatio, widthRatio;
                    if (options.outWidth == 0) {
                        options = null;
                    } else {
                        if (options.outWidth > options.outHeight){
                            widthRatio = Math.round((float) options.outWidth / (float) 1280);
                            heightRatio = Math.round((float) options.outHeight / (float) 720);
                        }else{
                            widthRatio = Math.round((float) options.outHeight / (float) 1280);
                            heightRatio = Math.round((float) options.outWidth / (float) 720);
                        }
                        int inSampleSize = heightRatio > widthRatio ? heightRatio : widthRatio;//用最大

                        options.inJustDecodeBounds = false;
                        options.inSampleSize = inSampleSize;
                    }

                    if (compressImage(path, tmp, options, maxSize, dataUri)) img_path = tmp;
                }
                callbackLuaForPicture(img_path);
                return;
            }
            return;
        }

        // 澶勭悊缁撴灉
        if (requestCode == PHOTORESOULT) {
            String path = "";

            Bitmap photo;
            try {
                photo = BitmapFactory.decodeStream(activity.getContentResolver().openInputStream(mUri));
                path = getDiskCacheDir() + "/head" + m_headIndex + ".jpg";
                m_headIndex++;
                saveMyBitmap(path, photo, Bitmap.CompressFormat.JPEG);
            } catch (FileNotFoundException e) {

                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }

            callbackLuaForPicture(path);
        }
    }
    public static Bitmap getBitmapFromUri(Uri uri) {
        try {
            ParcelFileDescriptor parcelFileDescriptor =
                    activity.getContentResolver().openFileDescriptor(uri, "r");
            FileDescriptor fileDescriptor = parcelFileDescriptor.getFileDescriptor();
            Bitmap image = BitmapFactory.decodeFileDescriptor(fileDescriptor);
            parcelFileDescriptor.close();
            return image;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 压缩图片到size以下，通过options或quality控制压缩方式
     * @param inPath 原始图片路径
     * @param outPath 目标图片路径
     * @param options 参数可以设置长宽系数，可以为null
     * @param size 大小限制，如果options压缩达不到这个值，则通过压缩quality
     *             quality压缩比重(0-100),越小压缩越狠，100表示不压缩，不影响图片长度宽度
     */
    public static boolean compressImage(String inPath, String outPath, BitmapFactory.Options options, int size, Uri uri) {
        boolean ret = false;
        Bitmap bitmap = BitmapFactory.decodeFile(inPath, options);
        if (bitmap == null && uri != null) bitmap = getBitmapFromUri(uri);

        int quality = 100;
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, baos);
            int length = baos.toByteArray().length;
            int step = 3;

            while (length > size && quality>=30) {
                baos.reset();
                if (length/(float) size > 1.1) step = 6;
                else step = 3;
                quality -= step;
                bitmap.compress(Bitmap.CompressFormat.JPEG, quality, baos);
                length = baos.toByteArray().length;
            }
            FileOutputStream fileOutputStream = new FileOutputStream(outPath);
            fileOutputStream.write(baos.toByteArray());
            ret = true;
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            bitmap.recycle();
            bitmap= null;
            return ret;
        }
    }

    /**
     *  zoom pic
     *
     *  fix android 4.4 + zoom scale bug
     *
     */
    private void startPhotoZoom (Uri uri, int size) {

        try {
            File file = new File(activity.getExternalCacheDir(), "small.jpg");

            mUri = Uri.fromFile(file);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                file = uriToFileApiQ(uri, activity);
                mUri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".myprovider", file);
            }

            Intent intent = new Intent("com.android.camera.action.CROP");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                intent.setDataAndType(mUri, "image/*");
            } else {
                intent.setDataAndType(uri, "image/*");
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION); //添加这一句表示对目标应用临时授权该Uri所代表的文件
            }
            // crop为true是设置在开启的intent中设置显示的view可以剪裁
            intent.putExtra("crop", "true");
            if (Build.MANUFACTURER.equals("HUAWEI")) {
                intent.putExtra("aspectX", 9998);
                intent.putExtra("aspectY", 9999);
            } else {
                intent.putExtra("aspectX", 1);
                intent.putExtra("aspectY", 1);
            }
            intent.putExtra("scale", true);

            // outputX,outputY 是剪裁图片的宽高
            intent.putExtra("outputX", size);
            intent.putExtra("outputY", size);

            intent.putExtra("return-data", false);
            intent.putExtra(MediaStore.EXTRA_OUTPUT, mUri);
            intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());

            try {
                activity.startActivityForResult(intent, PHOTORESOULT);
            } catch (Exception e) {
                // 解决截取后部分机型秒退
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    public static File uriToFileApiQ(Uri uri, Context context) {
        File file = null;
        if(uri == null) return file;
        //android10以上转换
        if (uri.getScheme().equals(ContentResolver.SCHEME_FILE)) {
            file = new File(uri.getPath());
        } else if (uri.getScheme().equals(ContentResolver.SCHEME_CONTENT)) {
            //把文件复制到沙盒目录
            ContentResolver contentResolver = context.getContentResolver();
            String displayName = System.currentTimeMillis()+ Math.round((Math.random() + 1) * 1000)
                    +"."+ MimeTypeMap.getSingleton().getExtensionFromMimeType(contentResolver.getType(uri));

            try {
                InputStream is = contentResolver.openInputStream(uri);
                File cache = new File(context.getExternalFilesDir(Environment.DIRECTORY_PICTURES).getAbsolutePath(), displayName);
                FileOutputStream fos = new FileOutputStream(cache);
                FileUtils.copy(is, fos);
                file = cache;
                fos.close();
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return file;
    }

    public void saveMyBitmap(String filePath, Bitmap mBitmap, Bitmap.CompressFormat format){
        File f = new File(filePath);
        try {
            f.createNewFile();
        } catch (IOException e) {
        }
        FileOutputStream fOut = null;
        try {
            fOut = new FileOutputStream(f);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(fOut != null){
            try {
                mBitmap.compress(format, 100, fOut);
                fOut.flush();
            } catch (NullPointerException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                fOut.close();
                mBitmap.recycle();
                mBitmap = null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }else{
            if (mBitmap != null) {
                mBitmap.recycle();
            }
            mBitmap = null;
        }
    }

    private Bitmap getImageThumbnail(String imagePath, int width) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        // 鑾峰彇鍥剧墖鐨勫鍜岄珮
        Bitmap bitmap = BitmapFactory.decodeFile(imagePath, options);
        float realWidth = options.outWidth;
        float realHeight = options.outHeight;
        System.out.println("鐪熷疄鍥剧墖楂樺害锛�" + realHeight + "瀹藉害:" + realWidth);
        // 缂╂斁姣�
        int scale = (int) ((realHeight > realWidth ? realHeight : realWidth) / width);
        if (scale <= 0)
        {
            scale = 1;
        }
        options.inSampleSize = scale;
        options.inJustDecodeBounds = false;
        // 娉ㄦ剰杩欐瑕佹妸options.inJustDecodeBounds 璁句负 false,杩欐鍥剧墖鏄璇诲彇鍑烘潵鐨勩��
        bitmap = BitmapFactory.decodeFile(imagePath, options);
        return bitmap;
    }

    private String getRealPathFromURI(Uri contentURI) {
        Cursor cursor = null;
        try {
            cursor = AppActivity.mActivity.getContentResolver()
                    .query(contentURI, null, null, null, null);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (cursor == null) {
            return contentURI.getPath();
        } else {
            try {
                cursor.moveToFirst();
                int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
                String path = cursor.getString(idx);
                cursor.close();
                return path;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return contentURI.getPath();
    }

    public String getDiskCacheDir(){
        String cachePath = null;
        //Environment.getExtemalStorageState() 鑾峰彇SDcard鐨勭姸鎬�
        //Environment.MEDIA_MOUNTED 鎵嬫満瑁呮湁SDCard,骞朵笖鍙互杩涜璇诲啓

        try {
//            if(Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
//                    &&!Environment.isExternalStorageRemovable()){
//                cachePath=activity.getExternalCacheDir().getPath();
//            }else{
            cachePath=activity.getCacheDir().getPath();
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cachePath;
    }

    public static String getPath(final Uri uri) {
        Context context = AppActivity.mActivity;
        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return activity.getExternalFilesDir(Environment.DIRECTORY_PICTURES) + "/" + split[1];
                }

                // TODO handle non-primary volumes
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {

                final String id = DocumentsContract.getDocumentId(uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[] {
                        split[1]
                };

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {

            // Return the remote address
            if (isGooglePhotosUri(uri))
                return uri.getLastPathSegment();

            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }

    /**
     * Get the value of the data column for this Uri. This is useful for
     * MediaStore Uris, and other file-based ContentProviders.
     *
     * @param context The context.
     * @param uri The Uri to query.
     * @param selection (Optional) Filter used in the query.
     * @param selectionArgs (Optional) Selection arguments used in the query.
     * @return The value of the _data column, which is typically a file path.
     */
    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {

        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }

    /**
     * 获取指定文件大小 　　
     */
    public static long getFileSize(String path){
        long size = 0;
        try{
            File file = new File(path);
            if (file.exists()) {
                FileInputStream fis = null;
                fis = new FileInputStream(file);
                size = fis.available();
            } else {
                Log.e("aaaa", "文件不存在!=========");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            return size;
        }
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is Google Photos.
     */
    public static boolean isGooglePhotosUri(Uri uri) {
        return "com.google.android.apps.photos.content".equals(uri.getAuthority());
    }
}
