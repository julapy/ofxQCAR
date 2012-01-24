//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"
#import "ofxQCAR_Utils.h"

#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>
#import <QCAR/CameraDevice.h>

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

ofxQCAR* ofxQCAR :: _instance = NULL;
ofxQCAR_Utils *utils;
ofxQCAR_Delegate *delegate;

QCAR::Matrix44F qcarProjectionMatrix;
QCAR::Matrix44F qcarModelViewMatrix;

/////////////////////////////////////////////////////////
//  DELEGATE.
/////////////////////////////////////////////////////////

@implementation ofxQCAR_Delegate

-(void) qcar_initialised
{
    //
}

-(void) qcar_cameraStarted
{
    //
}

-(void) qcar_cameraStopped
{
    //
}

-(void) qcar_projectionMatrixReady
{
    qcarProjectionMatrix = utils.projectionMatrix;
    ofxQCAR::getInstance()->updateProjectionMatrix( qcarProjectionMatrix.data );
}

@end

/////////////////////////////////////////////////////////
//  QCAR.
/////////////////////////////////////////////////////////

ofxQCAR :: ofxQCAR ()
{
    delegate = [[ ofxQCAR_Delegate alloc ] init ];
    
    utils = [[ ofxQCAR_Utils alloc ] initWithDelegate: delegate ];
    
    bFoundMarker = false;
}

ofxQCAR :: ~ofxQCAR ()
{
    [ utils release ];
}

/////////////////////////////////////////////////////////
//  SETUP.
/////////////////////////////////////////////////////////

void ofxQCAR :: setup ()
{
    [ utils onCreate ];
    [ utils onResume ];
}

/////////////////////////////////////////////////////////
//  SETTERS.
/////////////////////////////////////////////////////////

void ofxQCAR ::torchOn ()
{
    QCAR::CameraDevice::getInstance().setFlashTorchMode(true);
}

void ofxQCAR :: torchOff ()
{
    QCAR::CameraDevice::getInstance().setFlashTorchMode(false);
}

void ofxQCAR :: autoFocusOn ()
{
    QCAR::CameraDevice::getInstance().startAutoFocus();
}

void ofxQCAR :: autoFocusOff ()
{
    QCAR::CameraDevice::getInstance().stopAutoFocus();
}

/////////////////////////////////////////////////////////
//  UPDATE.
/////////////////////////////////////////////////////////

void ofxQCAR :: update ()
{
    //
}

/////////////////////////////////////////////////////////
//  DRAW.
/////////////////////////////////////////////////////////

void ofxQCAR :: draw ()
{
    QCAR::State state = QCAR::Renderer::getInstance().begin();                          //-- render the video background
    
    bFoundMarker = state.getNumActiveTrackables() > 0;
    if( bFoundMarker )                                                                  //-- check if any trackables found
    {
        const QCAR::Trackable* trackable = state.getActiveTrackable( 0 );               //-- get the first trackable
        
        qcarModelViewMatrix = QCAR::Tool::convertPose2GLMatrix( trackable->getPose() ); //-- get the model view matrix
        modelViewMatrix.set( qcarModelViewMatrix.data );
    }
    
    QCAR::Renderer::getInstance().end();
    
    //--- restore openFrameworks render configuration.
    
    glViewport( 0, 0, ofGetWidth(), ofGetHeight() );
    ofSetupScreen();
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

/////////////////////////////////////////////////////////
//  EXIT.
/////////////////////////////////////////////////////////

void ofxQCAR :: exit ()
{
    [ utils onPause ];
    [ utils onDestroy ];
}
