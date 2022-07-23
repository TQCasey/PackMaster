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

import android.app.ExpandableListActivity;
import android.content.Context;
import android.media.AudioManager;
import android.media.SoundPool;
import android.util.Log;

import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.chukong.cocosplay.client.CocosPlayClient;

import java.util.ArrayList;
import java.util.HashMap;

public class Cocos2dxSound {
    // ===========================================================
    // Constants
    // ===========================================================

    private static final String TAG = "Cocos2dxSound";

    // ===========================================================
    // Fields
    // ===========================================================

    private final Context mContext;
    private SoundPool mSoundPool;
    private float mLeftVolume;
    private float mRightVolume;

    // sound path and stream ids map
    // a file may be played many times at the same time
    // so there is an array map to a file path
    private final HashMap<String,SoundSrc> mSoundMap = new HashMap<>();

    private static final int MAX_SIMULTANEOUS_STREAMS_DEFAULT = 30;
    private static final int MAX_SIMULTANEOUS_STREAMS_I9100 = 20;
    private static final float SOUND_RATE = 1.0f;
    private static final int SOUND_PRIORITY = 1;
    private static final int SOUND_QUALITY = 5;
    private static final int src_steam_id_base = 0x8888;

    private final static int INVALID_SOUND_ID = -1;
    private final static int INVALID_STREAM_ID = -1;
    private static int seedid              = src_steam_id_base;
    private static int  mute_sound_id  = -1;
    private static ExecutorService  mThreadPool = Executors.newFixedThreadPool (4);

    private long m_lastNanoTime = 0;


    // ===========================================================
    // Constructors
    // ===========================================================

    public Cocos2dxSound(final Context context) {
        this.mContext = context;

        this.initData();

    }

    private int generateID () {
        return seedid++;
    }

    private void initData() {
        if (Cocos2dxHelper.getDeviceModel().indexOf("GT-I9100") != -1) {
            this.mSoundPool = new SoundPool(Cocos2dxSound.MAX_SIMULTANEOUS_STREAMS_I9100, AudioManager.STREAM_MUSIC, Cocos2dxSound.SOUND_QUALITY);
        }
        else {
            this.mSoundPool = new SoundPool(Cocos2dxSound.MAX_SIMULTANEOUS_STREAMS_DEFAULT, AudioManager.STREAM_MUSIC, Cocos2dxSound.SOUND_QUALITY);
        }

        this.mSoundPool.setOnLoadCompleteListener(new OnLoadCompletedListener());

        this.mLeftVolume = 0.5f;
        this.mRightVolume = 0.5f;
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

    public void clearAll (final String path) {
        try {
            SoundSrc src;
            for (String key : mSoundMap.keySet()) {
                src = mSoundMap.get(key);
                if (src != null) {
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.unload(src.streamID.get(i));
                    }
                    src.streamID.clear();
                }
            }
			
			// clear all map 
			mSoundMap.clear ();
			
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
    public int preloadEffect(final String path) {

        if (CocosPlayClient.isEnabled() && !CocosPlayClient.isDemo()) {
            CocosPlayClient.updateAssets(path);
        }

        CocosPlayClient.notifyFileLoaded(path);

        SoundSrc  src      = mSoundMap.get (path);

        if (src == null) {
            src             = new SoundSrc() ;
            src.soundID     = createSoundIDFromAsset(path);
            // save value just in case if file is really loaded
            if (src.soundID != Cocos2dxSound.INVALID_SOUND_ID) {
                mSoundMap.put(path,src);
            }
        }

        src.setParam(false,0,0,0);

        return src.id;
    }

    public int preloadEffect(final String path,final boolean loop, float pitch, float pan, float gain) {

        if (CocosPlayClient.isEnabled() && !CocosPlayClient.isDemo()) {
            CocosPlayClient.updateAssets(path);
        }

        CocosPlayClient.notifyFileLoaded(path);

        SoundSrc  src      = mSoundMap.get (path);

        if (src == null) {
            src             = new SoundSrc() ;
            src.soundID     = createSoundIDFromAsset(path);
            // save value just in case if file is really loaded
            if (src.soundID != Cocos2dxSound.INVALID_SOUND_ID) {
                mSoundMap.put(path,src);
            }
        }

        src.setParam(loop,pitch,pan,gain);

        return src.id;
    }

    public void unloadEffect(final String path) {
        try {
            // stop effects
            final SoundSrc src = this.mSoundMap.get(path);
            if (src != null) {
                for (final Integer steamID : src.streamID) {
                    this.mSoundPool.stop(steamID);
                }

                // unload effect
                final Integer soundID = src.soundID;
                if (soundID != null) {
                    this.mSoundPool.unload(soundID);
                }

                this.mSoundMap.remove(path);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int playEffect(final String path, final boolean loop, float pitch, float pan, float gain){

        SoundSrc src = this.mSoundMap.get(path);

        if (src != null) {
            // parameters; pan = -1 for left channel, 1 for right channel, 0 for both channels

            // play sound
            src.setParam(loop, pitch, pan, gain);

            System.out.printf("Sound : play " + path + "\n");
            // return the stram id
            return this.doPlayEffect(path, src.soundID.intValue(), loop, pitch, pan, gain);

        } else {

            System.out.printf("Sound : preload " + path + "\n");

            // return the src id
            return this.preloadEffect(path,loop, pitch, pan, gain);
        }
    }

    public SoundSrc getSrcByID (int srcid) {
        SoundSrc src;
        for (String path : this.mSoundMap.keySet()) {
            src = this.mSoundMap.get(path) ;
            if (src.id == srcid) {
                return src;
            }
        }
        return null;
    }

    public SoundSrc getSrcByStreamID (int streamID) {
        SoundSrc src;
        for (String path : this.mSoundMap.keySet()) {
            src = this.mSoundMap.get(path) ;

            for (int i = 0 ; i < src.streamID.size() ; i++) {
                if (src.streamID.get(i) == streamID) {
                    return src;
                }
            }
        }
        return null;
    }


    public void stopEffect(final int id) {

        try {
            SoundSrc src = null;

            if (id > src_steam_id_base) {

                // src id
                src = getSrcByID(id);
                if (src != null) {

                    // stop all for we don't kwon which is the playing stream Id
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.stop(src.streamID.get(i));
                    }

                    src.streamID.clear();
                }

            } else {
                // stream id
                src = getSrcByStreamID(id);
                if (src != null) {
                    this.mSoundPool.stop(id);
                    if (src.streamID.contains(id)) {
                        src.streamID.remove(id);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pauseEffect(final int id) {

        try {
            SoundSrc src = null;

            if (id > src_steam_id_base) {

                // src id
                src = getSrcByID(id);
                if (src != null) {

                    // pause all for we don't kwon which is the playing stream Id
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.pause(src.streamID.get(i));
                    }
                }

            } else {
                // stream id
                src = getSrcByStreamID(id);
                if (src != null) {
                    this.mSoundPool.pause(id);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void resumeEffect(final int id) {

        try {
            SoundSrc src = null;

            if (id > src_steam_id_base) {

                // src id
                src = getSrcByID(id);
                if (src != null) {

                    // resume all for we don't kwon which is the playing stream Id
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.resume(src.streamID.get(i));
                    }
                }

            } else {
                // stream id
                src = getSrcByStreamID(id);
                if (src != null) {
                    this.mSoundPool.resume(id);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pauseAllEffects() {

        try {
            SoundSrc src;
            for (String key : mSoundMap.keySet()) {
                src = mSoundMap.get(key);
                if (src != null) {
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.pause(src.streamID.get(i));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void resumeAllEffects() {
        try {
            SoundSrc src;
            for (String key : mSoundMap.keySet()) {
                src = mSoundMap.get(key);
                if (src != null) {
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.resume(src.streamID.get(i));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("unchecked")
    public void stopAllEffects() {

        try {
            SoundSrc src;
            for (String key : mSoundMap.keySet()) {
                src = mSoundMap.get(key);
                if (src != null) {
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.stop(src.streamID.get(i));
                    }
                    src.streamID.clear();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public float getEffectsVolume() {
        return (this.mLeftVolume + this.mRightVolume) / 2;
    }

    public void setEffectsVolume(float volume) {

        try {
            // volume should be in [0, 1.0]
            if (volume < 0) {
                volume = 0;
            }
            if (volume > 1) {
                volume = 1;
            }

            this.mLeftVolume = this.mRightVolume = volume;

            SoundSrc src;
            for (String key : mSoundMap.keySet()) {
                src = mSoundMap.get(key);
                if (src != null) {
                    for (int i = 0; i < src.streamID.size(); i++) {
                        this.mSoundPool.setVolume(src.streamID.get(i), this.mLeftVolume, this.mRightVolume);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void end() {
        try {
            this.mSoundPool.release();
            this.mSoundMap.clear();
            this.mLeftVolume = 0.5f;
            this.mRightVolume = 0.5f;

            this.initData();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int createSoundIDFromAsset(final String path) {
        int soundID = Cocos2dxSound.INVALID_SOUND_ID;

        if (path == null || path.trim().isEmpty()) return soundID;
        try {
            if (path.startsWith("/")) {
                soundID = this.mSoundPool.load(path, 0);
            } else {
                soundID = this.mSoundPool.load(this.mContext.getAssets().openFd(path), 0);
            }
        } catch (final Exception e) {
            soundID = Cocos2dxSound.INVALID_SOUND_ID;
            Log.e(Cocos2dxSound.TAG, "error: " + e.getMessage(), e);
        }

        // mSoundPool.load returns 0 if something goes wrong, for example a file does not exist
        if (soundID == 0) {
            soundID = Cocos2dxSound.INVALID_SOUND_ID;
        }

        return soundID;
    }

    private float clamp(float value, float min, float max) {
        return Math.max(min, (Math.min(value, max)));
    }

    private int doPlayEffect(final String path, final int soundId,
                             final boolean loop, final float pitch, final float pan, final float gain) {

        final SoundSrc src = this.mSoundMap.get(path);
        if (src == null) {
            return INVALID_STREAM_ID;
        }

        mThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                try {

                    float leftVolume = mLeftVolume * gain * (1.0f - clamp(pan, 0.0f, 1.0f));
                    float rightVolume = mRightVolume * gain * (1.0f - clamp(-pan, 0.0f, 1.0f));
                    float soundRate = clamp(SOUND_RATE * pitch, 0.5f, 2.0f);

                    // play sound
                    int streamID = mSoundPool.play(soundId, clamp(leftVolume, 0.0f, 1.0f),
                            clamp(rightVolume, 0.0f, 1.0f),
                            Cocos2dxSound.SOUND_PRIORITY, loop ? -1 : 0, soundRate);

                    // first to check if the streamID size () > 10
                    // if so , clean the streamID ,orelse add to the list
                    if (src.streamID.size() >= 4) {
                        // remove the header
                        mSoundPool.stop(src.streamID.get(0));
                        src.streamID.remove(0);
                    }

                    src.streamID.add(streamID);
					
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        return src.id;
    }

    public void onEnterBackground(){
        this.mSoundPool.autoPause();
    }

    public void onEnterForeground(){
        this.mSoundPool.autoResume();
    }

    public class SoundSrc {
        int                     id;
        Integer                 soundID;
        ArrayList<Integer>      streamID;

        public boolean          isLoop;
        public float            pitch;
        public float            pan;
        public float            gain;

        public SoundSrc () {
            id          = generateID();
            soundID     = INVALID_SOUND_ID;
            streamID    = new ArrayList<>();
        }

        public void setParam (boolean isLoop, float pitch, float pan, float gain) {

            this.isLoop = isLoop;
            this.pitch  = pitch;
            this.pan    = pan;
            this.gain   = gain;
        }
    }

    // ===========================================================
    // Inner and Anonymous Classes
    // ===========================================================

    public class OnLoadCompletedListener implements SoundPool.OnLoadCompleteListener {

        @Override
        public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
            if (status == 0) {

                try {
                    SoundSrc src;

                    for (String path : mSoundMap.keySet()) {
                        src = mSoundMap.get(path);
                        if (src != null) {

                            if (src.soundID == sampleId) {

                                if (mute_sound_id == -1) {
                                    // pick up the first sound as the mute sound
									// to avoid the SoundPool lag effect 
                                    mute_sound_id = sampleId;
                                    mSoundPool.play(sampleId,0,0,10,-1,1f);
                                }

//                                System.out.printf("Sound : loadComplete >> play " + path + "\n");
                                doPlayEffect(path, src.soundID.intValue(), src.isLoop, src.pitch, src.pan, src.gain);
                                break;
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
