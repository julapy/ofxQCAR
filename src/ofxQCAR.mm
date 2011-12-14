//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"

ofxQCAR :: ofxQCAR ()
{
    bInitialised = false;
}

ofxQCAR :: ~ofxQCAR ()
{
    //
}

void ofxQCAR :: setup ()
{
    QCAR::onSurfaceCreated();
    QCAR::onSurfaceChanged( ofGetHeight(), ofGetWidth() );
    
    bool bSuccess = true;

    bSuccess = initQCAR();
    if( !bSuccess )
        return;
    
    bSuccess = loadTracker();
    if( !bSuccess )
        return;

    bSuccess = startQCAR();
    if( !bSuccess )
        return;
    
    bSuccess = startCamera();
    if( !bSuccess )
        return;
    
    bInitialised = true;
}

bool ofxQCAR :: initQCAR ()
{
    //-- TODO : have to determine if its QCAR::GL_11 or QCAR::GL_20
    int qcarGLVersion = QCAR::GL_11;
    QCAR::setInitParameters( qcarGLVersion );
    
    int nPercentComplete = 0;
    do
    {
        nPercentComplete = QCAR::init();
    } while( nPercentComplete >= 0  && nPercentComplete < 100 );
    
    NSLog(@"QCAR::init percent: %d", nPercentComplete);
    
    if( nPercentComplete < 0 )
        return false;
    
    return true;
}

bool ofxQCAR :: loadTracker ()
{
    int nPercentComplete = 0;
    do
    {
        nPercentComplete = QCAR::Tracker::getInstance().load();
    } while( nPercentComplete >= 0  && nPercentComplete < 100 );
    
    if( nPercentComplete < 0 ) 
        return false;
    
    return true;
}

bool ofxQCAR :: startQCAR ()
{
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    
    // Register a callback function that gets called every time a
    // tracking cycle has finished and we have a new AR state
    // available
    QCAR::registerCallback( this );
    
    // Initialisation is complete, start QCAR
    QCAR::onResume();

    return true;
}

bool ofxQCAR :: startCamera ()
{
    // Initialise the camera
    if (QCAR::CameraDevice::getInstance().init()) {
        // Configure video background
        configureVideoBackground();
        
        // Select the default mode
        if (QCAR::CameraDevice::getInstance().selectVideoMode(QCAR::CameraDevice::MODE_DEFAULT)) {
            // Start camera capturing
            if (QCAR::CameraDevice::getInstance().start()) {
                // Start the tracker
                QCAR::Tracker::getInstance().start();
                
                // Cache the projection matrix
                const QCAR::CameraCalibration& cameraCalibration = QCAR::Tracker::getInstance().getCameraCalibration();
                projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, 2.0f, 2000.0f);
            }
        }
    }
    else
    {
        return false;
    }
    
    return true;
}

bool ofxQCAR :: stopCamera ()
{
    QCAR::Tracker::getInstance().stop();
    QCAR::CameraDevice::getInstance().stop();
    QCAR::CameraDevice::getInstance().deinit();
    
    return true;
}

void ofxQCAR :: configureVideoBackground ()
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    
    // Compare aspect ratios of video and screen.  If they are different
    // we use the full screen size while maintaining the video's aspect
    // ratio, which naturally entails some cropping of the video.
    // Note - screenRect is portrait but videoMode is always landscape,
    // which is why "width" and "height" appear to be reversed.
    float arVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
    float arScreen = ofGetHeight() / ofGetWidth();
    
    if (arVideo > arScreen)
    {
        // Video mode is wider than the screen.  We'll crop the left and right edges of the video
        config.mSize.data[0] = (int)ofGetWidth() * arVideo;
        config.mSize.data[1] = (int)ofGetWidth();
    }
    else
    {
        // Video mode is taller than the screen.  We'll crop the top and bottom edges of the video.
        // Also used when aspect ratios match (no cropping).
        config.mSize.data[0] = (int)ofGetHeight();
        config.mSize.data[1] = (int)ofGetHeight() / arVideo;
    }
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}


void ofxQCAR :: QCAR_onUpdate ( QCAR::State& state )
{
    //
}

void ofxQCAR :: update ()
{
    if( !bInitialised )
        return;
    
    //
}

void ofxQCAR :: draw ()
{
    if( !bInitialised )
        return;
    
    // Render the video background
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    
    // Did we find any trackables this frame?
    if (state.getNumActiveTrackables() > 0) {
        
        // Get the first trackable
        const QCAR::Trackable* trackable = state.getActiveTrackable(0);
        
        // Get the model view matrix
        modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
    }
    
    QCAR::Renderer::getInstance().end();

}

void ofxQCAR :: exit ()
{
    QCAR :: deinit();
}