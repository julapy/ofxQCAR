/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

package cc.openframeworks.androidEmptyExample;

import java.lang.ref.WeakReference;
import java.util.Vector;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Color;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.Toast;

import com.qualcomm.QCAR.QCAR;
import com.qualcomm.vuforia.Vuforia;


/** The main activity for the ImageTargets sample. */
public class ImageTargets extends Activity
{
    private final static String TAG = "ImageTargets";
    
    // Focus mode constants:
    private static final int FOCUS_MODE_NORMAL = 0;
    private static final int FOCUS_MODE_CONTINUOUS_AUTO = 1;
    
    // Application status constants:
    private static final int APPSTATUS_UNINITED = -1;
    private static final int APPSTATUS_INIT_APP = 0;
    private static final int APPSTATUS_INIT_QCAR = 1;
    private static final int APPSTATUS_INIT_TRACKER = 2;
    private static final int APPSTATUS_INIT_APP_AR = 3;
    private static final int APPSTATUS_LOAD_TRACKER = 4;
    private static final int APPSTATUS_INITED = 5;
    private static final int APPSTATUS_CAMERA_STOPPED = 6;
    private static final int APPSTATUS_CAMERA_RUNNING = 7;
    
    // Name of the native dynamic libraries to load:
    private static final String NATIVE_LIB_SAMPLE = "ImageTargetsNative";
    private static final String NATIVE_LIB_QCAR = "Vuforia";
    
    // Constants for Hiding/Showing Loading dialog
    static final int HIDE_LOADING_DIALOG = 0;
    static final int SHOW_LOADING_DIALOG = 1;
    
    private View mLoadingDialogContainer;
    
    // Our OpenGL view:
    private QCARSampleGLView mGlView;
    
    // Our renderer:
    private ImageTargetsRenderer mRenderer;
    
    // Display size of the device:
    private int mScreenWidth = 0;
    private int mScreenHeight = 0;
    
    // Constant representing invalid screen orientation to trigger a query:
    private static final int INVALID_SCREEN_ROTATION = -1;
    
    // Last detected screen rotation:
    private int mLastScreenRotation = INVALID_SCREEN_ROTATION;
    
    // Keeps track of the current camera
    int mCurrentCamera = CAMERA_DEFAULT;
    
    // The current application status:
    private int mAppStatus = APPSTATUS_UNINITED;
    
    // The async tasks to initialize the Vuforia SDK:
    private InitVuforiaTask mInitVuforiaTask;
    private LoadTrackerTask mLoadTrackerTask;
    
    // An object used for synchronizing Vuforia initialization, dataset loading
    // and
    // the Android onDestroy() life cycle event. If the application is destroyed
    // while a data set is still being loaded, then we wait for the loading
    // operation to finish before shutting down Vuforia:
    private Object mShutdownLock = new Object();
    
    // Vuforia initialization flags:
    private int mVuforiaFlags = 0;
    
    // The textures we will use for rendering:
    private Vector<Texture> mTextures;
    
    // Detects the double tap gesture for launching the Camera menu
    private GestureDetector mGestureDetector;
    
    // Contextual Menu Options for Camera Flash - Autofocus
    private boolean mFlash = false;
    private boolean mContAutofocus = false;
    private boolean mExtendedTracking = false;
    
    private View mFlashOptionView;
    
    private RelativeLayout mUILayout;
    
    boolean mIsDroidDevice = false;
    
    /** Static initializer block to load native libraries on start-up. */
    static
    {
        loadLibrary(NATIVE_LIB_QCAR);
        loadLibrary(NATIVE_LIB_SAMPLE);
    }
    
    /**
     * Creates a handler to update the status of the Loading Dialog from an UI
     * Thread
     */
    static class LoadingDialogHandler extends Handler
    {
        private final WeakReference<ImageTargets> mImageTargets;
        
        
        LoadingDialogHandler(ImageTargets imageTargets)
        {
            mImageTargets = new WeakReference<ImageTargets>(imageTargets);
        }
        
        
        public void handleMessage(Message msg)
        {
            ImageTargets imageTargets = mImageTargets.get();
            if (imageTargets == null)
            {
                return;
            }
            
            if (msg.what == SHOW_LOADING_DIALOG)
            {
                imageTargets.mLoadingDialogContainer
                    .setVisibility(View.VISIBLE);
                
            } else if (msg.what == HIDE_LOADING_DIALOG)
            {
                imageTargets.mLoadingDialogContainer.setVisibility(View.GONE);
            }
        }
    }
    
    private Handler loadingDialogHandler = new LoadingDialogHandler(this);
    
    /** An async task to initialize Vuforia asynchronously. */
    private class InitVuforiaTask extends AsyncTask<Void, Integer, Boolean>
    {
        // Initialize with invalid value:
        private int mProgressValue = -1;
        
        
        protected Boolean doInBackground(Void... params)
        {
            // Prevent the onDestroy() method to overlap with initialization:
            synchronized (mShutdownLock)
            {
                QCAR.setInitParameters(ImageTargets.this, mVuforiaFlags, "");
                
                do
                {
                    // QCAR.init() blocks until an initialization step is
                    // complete, then it proceeds to the next step and reports
                    // progress in percents (0 ... 100%).
                    // If QCAR.init() returns -1, it indicates an error.
                    // Initialization is done when progress has reached 100%.
                    mProgressValue = QCAR.init();
                    
                    // Publish the progress value:
                    publishProgress(mProgressValue);
                    
                    // We check whether the task has been canceled in the
                    // meantime (by calling AsyncTask.cancel(true)).
                    // and bail out if it has, thus stopping this thread.
                    // This is necessary as the AsyncTask will run to completion
                    // regardless of the status of the component that
                    // started is.
                } while (!isCancelled() && mProgressValue >= 0
                    && mProgressValue < 100);
                
                return (mProgressValue > 0);
            }
        }
        
        
        protected void onProgressUpdate(Integer... values)
        {
            // Do something with the progress value "values[0]", e.g. update
            // splash screen, progress bar, etc.
        }
        
        
        protected void onPostExecute(Boolean result)
        {
            // Done initializing Vuforia, proceed to next application
            // initialization status:
            if (result)
            {
                Log.d(TAG, "InitVuforiaTask::onPostExecute: Vuforia "
                    + "initialization successful");
                
                updateApplicationStatus(APPSTATUS_INIT_TRACKER);
            } else
            {
                // Create dialog box for display error:
                AlertDialog dialogError = new AlertDialog.Builder(
                    ImageTargets.this).create();
                
                dialogError.setButton(DialogInterface.BUTTON_POSITIVE, "OK",
                    new DialogInterface.OnClickListener()
                    {
                        public void onClick(DialogInterface dialog, int which)
                        {
                            // Exiting application:
                            System.exit(1);
                        }
                    });
                
                String logMessage;
                
                // NOTE: Check if initialization failed because the device is
                // not supported. At this point the user should be informed
                // with a message.
                logMessage = getInitializationErrorString(mProgressValue);
                
                // Log error:
                Log.e(TAG, "InitVuforiaTask::onPostExecute: " + logMessage
                        + " Exiting.");
                
                // Show dialog box with error message:
                dialogError.setMessage(logMessage);
                dialogError.show();
            }
        }
    }
    
    
    // Returns the error message for each error code
    private String getInitializationErrorString(int code)
    {
        if (code == Vuforia.INIT_DEVICE_NOT_SUPPORTED)
            return getString(R.string.INIT_ERROR_DEVICE_NOT_SUPPORTED);
        if (code == Vuforia.INIT_NO_CAMERA_ACCESS)
            return getString(R.string.INIT_ERROR_NO_CAMERA_ACCESS);
        if (code == Vuforia.INIT_LICENSE_ERROR_MISSING_KEY)
            return getString(R.string.INIT_LICENSE_ERROR_MISSING_KEY);
        if (code == Vuforia.INIT_LICENSE_ERROR_INVALID_KEY)
            return getString(R.string.INIT_LICENSE_ERROR_INVALID_KEY);
        if (code == Vuforia.INIT_LICENSE_ERROR_NO_NETWORK_TRANSIENT)
            return getString(R.string.INIT_LICENSE_ERROR_NO_NETWORK_TRANSIENT);
        if (code == Vuforia.INIT_LICENSE_ERROR_NO_NETWORK_PERMANENT)
            return getString(R.string.INIT_LICENSE_ERROR_NO_NETWORK_PERMANENT);
        if (code == Vuforia.INIT_LICENSE_ERROR_CANCELED_KEY)
            return getString(R.string.INIT_LICENSE_ERROR_CANCELED_KEY);
        if (code == Vuforia.INIT_LICENSE_ERROR_PRODUCT_TYPE_MISMATCH)
            return getString(R.string.INIT_LICENSE_ERROR_PRODUCT_TYPE_MISMATCH);
        else
        {
            return getString(R.string.INIT_LICENSE_ERROR_UNKNOWN_ERROR);
        }
    }
    
    
    /** An async task to load the tracker data asynchronously. */
    private class LoadTrackerTask extends AsyncTask<Void, Integer, Boolean>
    {
        protected Boolean doInBackground(Void... params)
        {
            // Prevent the onDestroy() method to overlap:
            synchronized (mShutdownLock)
            {
                // Load the tracker data set:
                return (loadTrackerData() > 0);
            }
        }
        
        
        protected void onPostExecute(Boolean result)
        {
            Log.d(TAG, "LoadTrackerTask::onPostExecute: execution "
                    + (result ? "successful" : "failed"));
            
            if (result)
            {
                // Done loading the tracker, update application status:
                updateApplicationStatus(APPSTATUS_INITED);
            } else
            {
                // Create dialog box for display error:
                AlertDialog dialogError = new AlertDialog.Builder(
                    ImageTargets.this).create();
                
                dialogError.setButton(DialogInterface.BUTTON_POSITIVE, "Close",
                    new DialogInterface.OnClickListener()
                    {
                        public void onClick(DialogInterface dialog, int which)
                        {
                            // Exiting application:
                            System.exit(1);
                        }
                    });
                
                // Show dialog box with error message:
                dialogError.setMessage("Failed to load tracker data.");
                dialogError.show();
            }
        }
    }
    
    
    /** Stores screen dimensions */
    private void storeScreenDimensions()
    {
        // Query display dimensions:
        DisplayMetrics metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
        mScreenWidth = metrics.widthPixels;
        mScreenHeight = metrics.heightPixels;
    }
    
    
    /**
     * Called when the activity first starts or the user navigates back to an
     * activity.
     */
    protected void onCreate(Bundle savedInstanceState)
    {
        Log.d(TAG, "onCreate");
        super.onCreate(savedInstanceState);
        
        // Load any sample specific textures:
        mTextures = new Vector<Texture>();
        loadTextures();
        
        // Configure Vuforia to use OpenGL ES 2.0
        mVuforiaFlags = QCAR.GL_20;
        
        // Creates the GestureDetector listener for processing double tap
        mGestureDetector = new GestureDetector(this, new GestureListener());
        
        // Update the application status to start initializing application:
        updateApplicationStatus(APPSTATUS_INIT_APP);
        
        mIsDroidDevice = android.os.Build.MODEL.toLowerCase().startsWith(
            "droid");
        
    }
    
    
    /**
     * We want to load specific textures from the APK, which we will later use
     * for rendering.
     */
    private void loadTextures()
    {
        mTextures.add(Texture.loadTextureFromApk("TextureTeapotBrass.png",
            getAssets()));
        mTextures.add(Texture.loadTextureFromApk("TextureTeapotBlue.png",
            getAssets()));
        mTextures.add(Texture.loadTextureFromApk("TextureTeapotRed.png",
            getAssets()));
        mTextures
            .add(Texture.loadTextureFromApk("Buildings.jpeg", getAssets()));
    }
    
    
    /** Native tracker initialization and deinitialization. */
    public native int initTracker();
    
    
    public native void deinitTracker();
    
    
    /** Native functions to load and destroy tracking data. */
    public native int loadTrackerData();
    
    
    public native void destroyTrackerData();
    
    
    /** Native sample initialization. */
    public native void onQCARInitializedNative();
    
    
    /** Native methods for starting and stopping the desired camera. */
    private native void startCamera(int camera);
    
    
    private native void stopCamera();
    
    
    /**
     * Native method for setting / updating the projection matrix for AR content
     * rendering
     */
    private native void setProjectionMatrix();
    
    
    /** Native method for starting / stopping off target tracking */
    private native boolean startExtendedTracking();
    
    
    private native boolean stopExtendedTracking();
    
    
    /** Called when the activity will start interacting with the user. */
    protected void onResume()
    {
        Log.d(TAG, "onResume");
        super.onResume();
        
        // This is needed for some Droid devices to force portrait
        if (mIsDroidDevice)
        {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }
        
        // Vuforia-specific resume operation
        QCAR.onResume();
        
        // We may start the camera only if the Vuforia SDK has already been
        // initialized
        if (mAppStatus == APPSTATUS_CAMERA_STOPPED)
        {
            updateApplicationStatus(APPSTATUS_CAMERA_RUNNING);
        }
        
        // Resume the GL view:
        if (mGlView != null)
        {
            mGlView.setVisibility(View.VISIBLE);
            mGlView.onResume();
        }
        
    }
    
    
    /**
     * Updates projection matrix and viewport after a screen rotation change was
     * detected.
     */
    public void updateRenderView()
    {
        int currentScreenRotation = getWindowManager().getDefaultDisplay()
            .getRotation();
        if (currentScreenRotation != mLastScreenRotation)
        {
            // Set projection matrix if there is already a valid one:
            if (QCAR.isInitialized()
                && (mAppStatus == APPSTATUS_CAMERA_RUNNING))
            {
                Log.d(TAG, "updateRenderView");
                
                // Query display dimensions:
                storeScreenDimensions();
                
                // Update viewport via renderer:
                mRenderer.updateRendering(mScreenWidth, mScreenHeight);
                
                // Update projection matrix:
                setProjectionMatrix();
                
                // Cache last rotation used for setting projection matrix:
                mLastScreenRotation = currentScreenRotation;
            }
        }
    }
    
    
    /** Callback for configuration changes the activity handles itself */
    public void onConfigurationChanged(Configuration config)
    {
        Log.d(TAG, "onConfigurationChanged");
        super.onConfigurationChanged(config);
        
        storeScreenDimensions();
        
        // Invalidate screen rotation to trigger query upon next render call:
        mLastScreenRotation = INVALID_SCREEN_ROTATION;
    }
    
    
    /** Called when the system is about to start resuming a previous activity. */
    protected void onPause()
    {
        Log.d(TAG, "onPause");
        super.onPause();
        
        if (mGlView != null)
        {
            mGlView.setVisibility(View.INVISIBLE);
            mGlView.onPause();
        }
        
        // Turn off the flash
        if (mFlashOptionView != null && mFlash)
        {
            // OnCheckedChangeListener is called upon changing the checked state
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1)
            {
                ((Switch) mFlashOptionView).setChecked(false);
            } else
            {
                ((CheckBox) mFlashOptionView).setChecked(false);
            }
        }
        
        if (mAppStatus == APPSTATUS_CAMERA_RUNNING)
        {
            updateApplicationStatus(APPSTATUS_CAMERA_STOPPED);
        }
        
        // Vuforia-specific pause operation
        QCAR.onPause();
    }
    
    
    /** Native function to deinitialize the application. */
    private native void deinitApplicationNative();
    
    
    /** The final call you receive before your activity is destroyed. */
    protected void onDestroy()
    {
        Log.d(TAG, "onDestroy");
        super.onDestroy();
        
        // Cancel potentially running tasks
        if (mInitVuforiaTask != null
            && mInitVuforiaTask.getStatus() != InitVuforiaTask.Status.FINISHED)
        {
            mInitVuforiaTask.cancel(true);
            mInitVuforiaTask = null;
        }
        
        if (mLoadTrackerTask != null
            && mLoadTrackerTask.getStatus() != LoadTrackerTask.Status.FINISHED)
        {
            mLoadTrackerTask.cancel(true);
            mLoadTrackerTask = null;
        }
        
        // Ensure that all asynchronous operations to initialize Vuforia
        // and loading the tracker datasets do not overlap:
        synchronized (mShutdownLock)
        {
            
            // Do application deinitialization in native code:
            deinitApplicationNative();
            
            // Unload texture:
            mTextures.clear();
            mTextures = null;
            
            // Destroy the tracking data set:
            destroyTrackerData();
            
            // Deinit the tracker:
            deinitTracker();
            
            // Deinitialize Vuforia SDK:
            QCAR.deinit();
        }
        
        System.gc();
    }
    
    
    /**
     * NOTE: this method is synchronized because of a potential concurrent
     * access by onResume() and InitQCARTask.onPostExecute().
     */
    private synchronized void updateApplicationStatus(int appStatus)
    {
        // Exit if there is no change in status:
        if (mAppStatus == appStatus)
            return;
        
        // Store new status value:
        mAppStatus = appStatus;
        
        // Execute application state-specific actions:
        switch (mAppStatus)
        {
            case APPSTATUS_INIT_APP:
                // Initialize application elements that do not rely on Vuforia
                // initialization:
                initApplication();
                
                // Proceed to next application initialization status:
                updateApplicationStatus(APPSTATUS_INIT_QCAR);
                break;
            
            case APPSTATUS_INIT_QCAR:
                // Initialize Vuforia SDK asynchronously to avoid blocking the
                // main (UI) thread.
                //
                // NOTE: This task instance must be created and invoked on the
                // UI thread and it can be executed only once!
                try
                {
                    mInitVuforiaTask = new InitVuforiaTask();
                    mInitVuforiaTask.execute();
                } catch (Exception e)
                {
                    Log.e(TAG, "Initializing Vuforia SDK failed");
                }
                break;
            
            case APPSTATUS_INIT_TRACKER:
                // Initialize the ObjectTracker:
                if (initTracker() > 0)
                {
                    // Proceed to next application initialization status:
                    updateApplicationStatus(APPSTATUS_INIT_APP_AR);
                }
                break;
            
            case APPSTATUS_INIT_APP_AR:
                // Initialize Augmented Reality-specific application elements
                // that may rely on the fact that the Vuforia SDK has been
                // already initialized:
                initApplicationAR();
                
                // Proceed to next application initialization status:
                updateApplicationStatus(APPSTATUS_LOAD_TRACKER);
                break;
            
            case APPSTATUS_LOAD_TRACKER:
                // Load the tracking data set:
                //
                // NOTE: This task instance must be created and invoked on the
                // UI thread and it can be executed only once!
                try
                {
                    mLoadTrackerTask = new LoadTrackerTask();
                    mLoadTrackerTask.execute();
                } catch (Exception e)
                {
                    Log.e(TAG, "Loading tracking data set failed");
                }
                break;
            
            case APPSTATUS_INITED:
                // Hint to the virtual machine that it would be a good time to
                // run the garbage collector:
                //
                // NOTE: This is only a hint. There is no guarantee that the
                // garbage collector will actually be run.
                System.gc();
                
                // Native post initialization:
                onQCARInitializedNative();
                
                // Activate the renderer:
                mRenderer.mIsActive = true;
                
                // Now add the GL surface view. It is important
                // that the OpenGL ES surface view gets added
                // BEFORE the camera is started and video
                // background is configured.
                addContentView(mGlView, new LayoutParams(
                    LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
                
                // Sets the UILayout to be drawn in front of the camera
                mUILayout.bringToFront();
                
                // Start the camera:
                updateApplicationStatus(APPSTATUS_CAMERA_RUNNING);
                
                break;
            
            case APPSTATUS_CAMERA_STOPPED:
                // Call the native function to stop the camera:
                stopCamera();
                break;
            
            case APPSTATUS_CAMERA_RUNNING:
                // Call the native function to start the camera:
                startCamera(mCurrentCamera);
                
                // Hides the Loading Dialog
                loadingDialogHandler.sendEmptyMessage(HIDE_LOADING_DIALOG);
                
                // Sets the layout background to transparent
                mUILayout.setBackgroundColor(Color.TRANSPARENT);
                
                // Set continuous auto-focus if supported by the device,
                // otherwise default back to regular auto-focus mode.
                // This will be activated by a tap to the screen in this
                // application.
                boolean result = setFocusMode(FOCUS_MODE_CONTINUOUS_AUTO);
                if (!result)
                {
                    Log.e(TAG, "Unable to enable continuous autofocus");
                    mContAutofocus = false;
                    setFocusMode(FOCUS_MODE_NORMAL);
                } else
                {
                    mContAutofocus = true;
                }
                
                break;
            
            default:
                throw new RuntimeException("Invalid application state");
        }
    }
    
    
    /** Tells native code whether we are in portait or landscape mode */
    private native void setActivityPortraitMode(boolean isPortrait);
    
    
    /** Initialize application GUI elements that are not related to AR. */
    private void initApplication()
    {
        setActivityPortraitMode(true);
        
        // Query display dimensions:
        storeScreenDimensions();
        
        // As long as this window is visible to the user, keep the device's
        // screen turned on and bright:
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }
    
    
    /** Native function to initialize the application. */
    private native void initApplicationNative(int width, int height);
    
    
    /** Initializes AR application components. */
    private void initApplicationAR()
    {
        // Do application initialization in native code (e.g. registering
        // callbacks, etc.):
        initApplicationNative(mScreenWidth, mScreenHeight);
        
        // Create OpenGL ES view:
        int depthSize = 16;
        int stencilSize = 0;
        boolean translucent = QCAR.requiresAlpha();
        
        mGlView = new QCARSampleGLView(this);
        mGlView.init(translucent, depthSize, stencilSize);
        
        mRenderer = new ImageTargetsRenderer();
        mRenderer.mActivity = this;
        mGlView.setRenderer(mRenderer);
        
        LayoutInflater inflater = LayoutInflater.from(this);
        mUILayout = (RelativeLayout) inflater.inflate(R.layout.camera_overlay,
            null, false);
        
        mUILayout.setVisibility(View.VISIBLE);
        mUILayout.setBackgroundColor(Color.BLACK);
        
        // Gets a reference to the loading dialog
        mLoadingDialogContainer = mUILayout
            .findViewById(R.id.loading_indicator);
        
        // Shows the loading indicator at start
        loadingDialogHandler.sendEmptyMessage(SHOW_LOADING_DIALOG);
        
        // Adds the inflated layout to the view
        addContentView(mUILayout, new LayoutParams(LayoutParams.MATCH_PARENT,
            LayoutParams.MATCH_PARENT));
        
    }
    
    
    /** Tells native code to switch dataset as soon as possible */
    private native void switchDatasetAsap(int datasetId);
    
    
    private native boolean autofocus();
    
    
    private native boolean setFocusMode(int mode);
    
    
    /** Activates the Flash */
    private native boolean activateFlash(boolean flash);
    
    
    /** Returns the number of registered textures. */
    public int getTextureCount()
    {
        return mTextures.size();
    }
    
    
    /** Returns the texture object at the specified index. */
    public Texture getTexture(int i)
    {
        return mTextures.elementAt(i);
    }
    
    
    /** A helper for loading native libraries stored in "libs/armeabi*". */
    public static boolean loadLibrary(String nLibName)
    {
        try
        {
            System.loadLibrary(nLibName);
            Log.i(TAG, "Native library lib" + nLibName + ".so loaded");
            return true;
        } catch (UnsatisfiedLinkError ulee)
        {
            Log.e(TAG, "The library lib" + nLibName
                + ".so could not be loaded");
        } catch (SecurityException se)
        {
            Log.e(TAG, "The library lib" + nLibName
                + ".so was not allowed to be loaded");
        }
        
        return false;
    }
    
    
    public boolean onTouchEvent(MotionEvent event)
    {
        // Process the Gestures
        return mGestureDetector.onTouchEvent(event);
    }
    
    /**
     * Process Tap event for autofocus
     */
    private class GestureListener extends
        GestureDetector.SimpleOnGestureListener
    {
        public boolean onDown(MotionEvent e)
        {
            return true;
        }
        
        
        public boolean onSingleTapUp(MotionEvent e)
        {
            // Calls the Autofocus Native Method
            autofocus();
            
            // Triggering manual auto focus disables continuous
            // autofocus
            mContAutofocus = false;
            
            return true;
        }
        
    }
    
    final static int CMD_BACK = -1;
    final static int CMD_EXTENDED_TRACKING = 1;
    final static int CMD_AUTOFOCUS = 2;
    final static int CMD_FLASH = 3;
    final static int CMD_CAMERA_FRONT = 4;
    final static int CMD_CAMERA_REAR = 5;
    final static int CMD_DATASET_STONES_AND_CHIPS_DATASET = 6;
    final static int CMD_DATASET_TARMAC_DATASET = 7;
    
    final static int STONES_AND_CHIPS_DATASET_ID = 0;
    final static int TARMAC_DATASET_ID = 1;
    
    final static int CAMERA_DEFAULT = 0;
    final static int CAMERA_BACK = 1;
    final static int CAMERA_FRONT = 2;
    
    


    
    private void showToast(String text)
    {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
    
}
