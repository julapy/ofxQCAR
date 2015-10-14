/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

package cc.openframeworks.androidEmptyExample;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;


/**
 * Texture is a support class for the Vuforia samples applications.
 * 
 * Exposes functionality for loading a texture from the APK.
 * 
 * */

public class Texture
{
    public static final String TAG = "Texture";

    public int mWidth;      // / The width of the texture.
    public int mHeight;     // / The height of the texture.
    public int mChannels;   // / The number of channels.
    public byte[] mData;    // / The pixel data.
    
    
    /** Returns the raw data */
    public byte[] getData()
    {
        return mData;
    }
    
    
    /** Factory function to load a texture from the APK. */
    public static Texture loadTextureFromApk(String fileName,
        AssetManager assets)
    {
        InputStream inputStream = null;
        try
        {
            inputStream = assets.open(fileName, AssetManager.ACCESS_BUFFER);
            
            BufferedInputStream bufferedStream = new BufferedInputStream(
                inputStream);
            Bitmap bitMap = BitmapFactory.decodeStream(bufferedStream);
            
            int[] data = new int[bitMap.getWidth() * bitMap.getHeight()];
            bitMap.getPixels(data, 0, bitMap.getWidth(), 0, 0,
                bitMap.getWidth(), bitMap.getHeight());
            
            // Convert:
            byte[] dataBytes = new byte[bitMap.getWidth() * bitMap.getHeight()
                * 4];
            for (int p = 0; p < bitMap.getWidth() * bitMap.getHeight(); ++p)
            {
                int colour = data[p];
                dataBytes[p * 4] = (byte) (colour >>> 16);    // R
                dataBytes[p * 4 + 1] = (byte) (colour >>> 8);     // G
                dataBytes[p * 4 + 2] = (byte) colour;            // B
                dataBytes[p * 4 + 3] = (byte) (colour >>> 24);    // A
            }
            
            Texture texture = new Texture();
            texture.mWidth = bitMap.getWidth();
            texture.mHeight = bitMap.getHeight();
            texture.mChannels = 4;
            texture.mData = dataBytes;
            
            return texture;
        } catch (IOException e)
        {
            Log.e(TAG, "Failed to log texture '" + fileName + "' from APK");
            Log.i(TAG, e.getMessage());
            return null;
        }
    }
}
