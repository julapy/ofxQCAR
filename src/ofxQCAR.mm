//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"
#import "ofxiPhoneExtras.h"

#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>


QCAR::Matrix44F qcarProjectionMatrix;
QCAR::Matrix44F qcarModelViewMatrix;


ofxQCAR :: ofxQCAR ()
{
    bInitialised = false;
    bFoundMarker = false;
}

ofxQCAR :: ~ofxQCAR ()
{
    //
}

void ofxQCAR :: setup ()
{
    if( bInitialised )
        return;
    
    QCAR::onSurfaceCreated();
    QCAR::onSurfaceChanged( ofGetWidth(), ofGetHeight() );
    
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
    QCAR::setInitParameters( QCAR::ROTATE_IOS_90 );
    
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
//    QCAR::registerCallback( this );
    
    // Initialisation is complete, start QCAR
    QCAR::onResume();

    return true;
}

bool ofxQCAR :: startCamera ()
{
    if( QCAR::CameraDevice::getInstance().init() )  //-- Initialise the camera
    {
        /**
         *  Configure video background.
         **/
        
        QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
        QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);        //-- get the default video mode

        ofRectangle screenRect( 0, 0, ofGetWidth(), ofGetHeight() );
        ofRectangle videoRect( 0, 0, videoMode.mHeight, videoMode.mWidth );
        ofRectangle imageRect = ofxQCARUtils :: cropToSize( videoRect, screenRect );
        imageRect.x = 0;    // qcar positions the camera image in the middle of the screen, so no need to move the image.
        imageRect.y = 0;
        
        QCAR::VideoBackgroundConfig config;                                                             //-- configure the video background
        config.mEnabled = true;
        config.mSynchronous = true;
        config.mPosition.data[0] = imageRect.x;
        config.mPosition.data[1] = imageRect.y;
        config.mSize.data[0] = imageRect.width;
        config.mSize.data[1] = imageRect.height;
        
        QCAR::Renderer::getInstance().setVideoBackgroundConfig( config );                               //-- set the config
        
        /**
         *  Start the camera.
         **/
        
        if( QCAR::CameraDevice::getInstance().selectVideoMode( QCAR::CameraDevice::MODE_DEFAULT ) )     //-- select the default mode
        {
            if( QCAR::CameraDevice::getInstance().start() )                                             //-- start camera capturing
            {
                QCAR::Tracker::getInstance().start();                                                   //-- start the tracker
                
                const QCAR::CameraCalibration& cameraCalibration = QCAR::Tracker::getInstance().getCameraCalibration();
                qcarProjectionMatrix = QCAR::Tool::getProjectionGL( cameraCalibration, 2.0f, 2000.0f ); //-- cache the projection matrix
                projectionMatrix.set( qcarProjectionMatrix.data );
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

void ofxQCAR :: update ()
{
    if( !bInitialised )
        return;
}

void ofxQCAR :: draw ()
{
    if( !bInitialised )
        return;
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();                          //-- render the video background
    
    bFoundMarker = state.getNumActiveTrackables() > 0;
    if( bFoundMarker )                                                                  //-- check if any trackables found
    {
        const QCAR::Trackable* trackable = state.getActiveTrackable( 0 );               //-- get the first trackable
        
        qcarModelViewMatrix = QCAR::Tool::convertPose2GLMatrix( trackable->getPose() ); //-- get the model view matrix
        modelViewMatrix.set( qcarModelViewMatrix.data );
    }
    
    QCAR::Renderer::getInstance().end();
}

void ofxQCAR :: exit ()
{
    QCAR :: deinit();
}
