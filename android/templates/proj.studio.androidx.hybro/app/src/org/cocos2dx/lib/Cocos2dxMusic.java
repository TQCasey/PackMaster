/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2013-2014 Chukong Technologies Inc.

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

import java.io.FileInputStream;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.LogRecord;

import com.chukong.cocosplay.client.CocosPlayClient;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

public class Cocos2dxMusic {
    // ===========================================================
    // Constants
    // ===========================================================

    private static final String TAG = Cocos2dxMusic.class.getSimpleName();

    // ===========================================================
    // Fields
    // ===========================================================

    private final Context mContext;
    private MediaPlayer mBackgroundMediaPlayer;
    private float mLeftVolume;
    private float mRightVolume;
    private boolean mPaused; // whether music is paused state.
    private boolean mIsLoop = false;
    private boolean mManualPaused = false; // whether music is paused manually before the program is switched to the background.
    private String mCurrentPath;

    // music service
    private HandlerThread mHandlerThread = null;
    private Handler mWorkerHandler = null;

    private final int CMD_PREPARE = 0;
    private final int CMD_PLAY = 1;
    private final int CMD_PAUSE = 2;
    private final int CMD_STOP = 3;
    private final int CMD_RESUME = 4;
    private final int CMD_CLEAR = 5;
    private final int CMD_REWIND = 6;
    private final int CMD_END = 7;
    private final int CMD_ENTER_BACK = 8;
    private final int CMD_ENTER_FORGE = 9;
    private final int CMD_SET_VOLUME = 10;

    
    // ===========================================================
    // Constructors
    // ===========================================================

    public Cocos2dxMusic(final Context context) {
        this.mContext = context;

        this.checkToStartWorkerThread ();

        this.initData();
    }

    private void Play (final String path, final boolean isLoop) {

        try {
            if (path == null || path.length() <= 0) {
                return;
            }

            // release old resource and create a new one
            if (mBackgroundMediaPlayer != null) {
                mBackgroundMediaPlayer.release();
            }

            mBackgroundMediaPlayer = createMediaplayer(path);

            // record the path
            mCurrentPath = path;

            if (mBackgroundMediaPlayer == null) {
                Log.e(Cocos2dxMusic.TAG, "playBackgroundMusic: background media player is null");
            } else {
                try {
                    // if the music is playing or paused, stop it
                    if (mPaused) {
                        mBackgroundMediaPlayer.seekTo(0);
                        mBackgroundMediaPlayer.start();
                    } else if (mBackgroundMediaPlayer.isPlaying()) {
                        mBackgroundMediaPlayer.seekTo(0);
                    } else {
                        mBackgroundMediaPlayer.start();
                    }
                    mBackgroundMediaPlayer.setLooping(isLoop);
                    mPaused = false;
                    mIsLoop = isLoop;
                } catch (final Exception e) {
                    Log.e(Cocos2dxMusic.TAG, "playBackgroundMusic: error state");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void Pause () {
        try {
            if (this.mBackgroundMediaPlayer != null && this.mBackgroundMediaPlayer.isPlaying()) {
                this.mBackgroundMediaPlayer.pause();
                this.mPaused = true;
                this.mManualPaused = true;
            }
        } catch (final Exception e) {
            Log.e(Cocos2dxMusic.TAG, "playBackgroundMusic: error state");
        }
    }

    private void Stop () {
        try {
            if (mBackgroundMediaPlayer != null) {
                mBackgroundMediaPlayer.release();
                mBackgroundMediaPlayer = null;
            }

            mPaused = false;

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void Resume () {
        try {
            if (this.mBackgroundMediaPlayer != null && this.mPaused) {
                this.mBackgroundMediaPlayer.start();
                this.mPaused = false;
                this.mManualPaused = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void ClearAll () {
        try {
            if (mBackgroundMediaPlayer != null) {
                mBackgroundMediaPlayer.release();
            }

            initData();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void Rewind () {
        try {
            if (this.mBackgroundMediaPlayer != null) {
                playBackgroundMusic(mCurrentPath, mIsLoop);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    private void End () {
        try {
            if (this.mBackgroundMediaPlayer != null) {
                this.mBackgroundMediaPlayer.release();
            }

            this.initData();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void EnterBackground () {
        try{
            if (this.mBackgroundMediaPlayer != null && this.mBackgroundMediaPlayer.isPlaying()) {
                this.mBackgroundMediaPlayer.pause();
                this.mPaused = true;
            }
        } catch (final Exception e) {
            Log.e(Cocos2dxMusic.TAG, "playBackgroundMusic: error state");
        }
    }

    private void EnterForgeGround () {
        try {
            if (!this.mManualPaused) {
                if (this.mBackgroundMediaPlayer != null && this.mPaused) {
                    this.mBackgroundMediaPlayer.start();
                    this.mPaused = false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void SetVolume (float volume) {
        try {
            if (volume < 0.0f) {
                volume = 0.0f;
            }

            if (volume > 1.0f) {
                volume = 1.0f;
            }

            this.mLeftVolume = this.mRightVolume = volume;
            if (this.mBackgroundMediaPlayer != null) {
                this.mBackgroundMediaPlayer.setVolume(this.mLeftVolume, this.mRightVolume);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void checkToStartWorkerThread () {

        try {
            if (mHandlerThread == null || !mHandlerThread.isAlive()) {

                mHandlerThread = new HandlerThread("music_service");
                mHandlerThread.start();

                mWorkerHandler = new Handler(mHandlerThread.getLooper()) {
                    @Override
                    public void handleMessage(@NonNull Message msg) {
                        super.handleMessage(msg);
                        try {
                            Bundle item = null;
                            switch (msg.what) {
                                case CMD_PLAY:
                                    item = msg.getData();
                                    String path = item.getString("path");
                                    boolean isLoop = item.getBoolean("isLoop");
                                    Play(path, isLoop);
                                    break;

                                case CMD_PAUSE:
                                    Pause();
                                    break;

                                case CMD_STOP:
                                    Stop();
                                    break;

                                case CMD_CLEAR:
                                    ClearAll();
                                    break;

                                case CMD_RESUME:
                                    Resume();
                                    break;

                                case CMD_REWIND:
                                    Rewind();
                                    break;

                                case CMD_END:
                                    End();
                                    break;

                                case CMD_ENTER_BACK:
                                    EnterBackground();
                                    break;

                                case CMD_ENTER_FORGE:
                                    EnterForgeGround();
                                    break;

                                case CMD_SET_VOLUME:
                                    item = msg.getData();
                                    float volume = item.getFloat("volume");
                                    SetVolume(volume);
                                    break;
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                };

                mHandlerThread.setUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
                    @Override
                    public void uncaughtException(@NonNull Thread t, @NonNull Throwable e) {
                        e.printStackTrace();
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===========================================================
    // Getter & Setter
    // ===========================================================

    // ===========================================================
    // Methods for/from SuperClass/Interfaces
    // ===========================================================

    // ===========================================================
    // Methods
    // ===========================================================

    public void preloadBackgroundMusic(final String path) {
//        checkToStartWorkerThread ();
//        Message msg = Message.obtain (mWorkerHandler);
//        msg.what = CMD_PREPARE;
//        msg.sendToTarget();
    }

    public void clearAll (final String path) {
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_CLEAR;
        msg.sendToTarget();
    }
    
    public void playBackgroundMusic(final String path, final boolean isLoop) {
        checkToStartWorkerThread ();
        Bundle bundle = new Bundle();
        bundle.putString("path",path);
        bundle.putBoolean("isLoop",isLoop);

        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_PLAY;
        msg.setData(bundle);
        msg.sendToTarget();
    }

    public void stopBackgroundMusic() {
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_STOP;
        msg.sendToTarget();
    }

    public void pauseBackgroundMusic() {
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_PAUSE;
        msg.sendToTarget();
    }

    public void resumeBackgroundMusic() {
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_RESUME;
        msg.sendToTarget();
    }

    public void rewindBackgroundMusic() {
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_REWIND;
        msg.sendToTarget();
    }

    public boolean isBackgroundMusicPlaying() {

        if (this.mBackgroundMediaPlayer == null) {
            return false;
        } else {
            boolean ret = false;
            try{
	            ret = this.mBackgroundMediaPlayer.isPlaying();
	        } catch (final Exception e) {
	            Log.e(Cocos2dxMusic.TAG, "playBackgroundMusic: error state");
		    } finally {
                return ret;
            }
        }
    }

    public void end() {
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_END;
        msg.sendToTarget();
    }

    public float getBackgroundVolume() {
        if (this.mBackgroundMediaPlayer != null) {
            return (this.mLeftVolume + this.mRightVolume) / 2;
        } else {
            return 0.0f;
        }
    }

    public void setBackgroundVolume(float volume) {
        checkToStartWorkerThread ();
        Bundle bundle = new Bundle();
        bundle.putFloat("volume",volume);

        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_SET_VOLUME;
        msg.setData(bundle);
        msg.sendToTarget();
    }

    public void onEnterBackground(){
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_ENTER_BACK;
        msg.sendToTarget();
    }
    
    public void onEnterForeground(){
        checkToStartWorkerThread ();
        Message msg = Message.obtain (mWorkerHandler);
        msg.what = CMD_ENTER_FORGE;
        msg.sendToTarget();
    }
    
    private void initData() {
        this.mLeftVolume = 0.5f;
        this.mRightVolume = 0.5f;
        this.mBackgroundMediaPlayer = null;
        this.mPaused = false;
        this.mCurrentPath = null;
    }

    /**
     * create mediaplayer for music
     * 
     * @param path
     *            the pPath relative to assets
     * @return
     */
    private MediaPlayer createMediaplayer(final String path) {
        MediaPlayer mediaPlayer = new MediaPlayer();

        try {
            if (CocosPlayClient.isEnabled() && !CocosPlayClient.isDemo()) {
                CocosPlayClient.updateAssets(path);
            }
            CocosPlayClient.notifyFileLoaded(path);
            if (path.startsWith("/")) {
                final FileInputStream fis = new FileInputStream(path);
                mediaPlayer.setDataSource(fis.getFD());
                fis.close();
            } else {
        		final AssetFileDescriptor assetFileDescritor = this.mContext.getAssets().openFd(path);
        		mediaPlayer.setDataSource(assetFileDescritor.getFileDescriptor(), assetFileDescritor.getStartOffset(), assetFileDescritor.getLength());
            }

            mediaPlayer.prepare();

            mediaPlayer.setVolume(this.mLeftVolume, this.mRightVolume);
        } catch (final Exception e) {
            mediaPlayer = null;
            Log.e(Cocos2dxMusic.TAG, "error path: " + path);
            Log.e(Cocos2dxMusic.TAG, "error: " + e.getMessage(), e);
        } finally {
            return mediaPlayer;
        }
    }

    // ===========================================================
    // Inner and Anonymous Classes
    // ===========================================================
}
