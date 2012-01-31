//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxQCAR_Utils.h"
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>
#import <QCAR/CameraDevice.h>

#endif

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

ofxQCAR* ofxQCAR :: _instance = NULL;

#if !(TARGET_IPHONE_SIMULATOR)

ofxQCAR_Utils *utils = nil;
ofxQCAR_Delegate *delegate = nil;

QCAR::Matrix44F qcarProjectionMatrix;
QCAR::Matrix44F qcarModelViewMatrix;

#endif

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
#if !(TARGET_IPHONE_SIMULATOR)
    
    qcarProjectionMatrix = utils.projectionMatrix;
    ofxQCAR::getInstance()->updateProjectionMatrix( qcarProjectionMatrix.data );
    
#endif
}

@end

/////////////////////////////////////////////////////////
//  QCAR.
/////////////////////////////////////////////////////////

ofxQCAR :: ofxQCAR ()
{
    bFoundMarker = false;
}

ofxQCAR :: ~ofxQCAR ()
{
    //
}

/////////////////////////////////////////////////////////
//  SETUP.
/////////////////////////////////////////////////////////

void ofxQCAR :: setup ()
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    if( !delegate )
        delegate = [[ ofxQCAR_Delegate alloc ] init ];
    
    if( !utils )
        utils = [[ ofxQCAR_Utils alloc ] initWithDelegate: delegate ];
        
    bFoundMarker = false;
    
    [ utils onCreate ];
    [ utils onResume ];
    
#endif
}

/////////////////////////////////////////////////////////
//  SETTERS.
/////////////////////////////////////////////////////////

void ofxQCAR ::torchOn ()
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::CameraDevice::getInstance().setFlashTorchMode(true);
    
#endif
}

void ofxQCAR :: torchOff ()
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::CameraDevice::getInstance().setFlashTorchMode(false);
    
#endif
}

void ofxQCAR :: autoFocusOn ()
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::CameraDevice::getInstance().startAutoFocus();
    
#endif
}

void ofxQCAR :: autoFocusOff ()
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::CameraDevice::getInstance().stopAutoFocus();
    
#endif
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
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();                          //-- render the video background
    
    bFoundMarker = state.getNumActiveTrackables() > 0;
    if( bFoundMarker )                                                                  //-- check if any trackables found
    {
        const QCAR::Trackable* trackable = state.getActiveTrackable( 0 );               //-- get the first trackable
        
        qcarModelViewMatrix = QCAR::Tool::convertPose2GLMatrix( trackable->getPose() ); //-- get the model view matrix
        modelViewMatrix.set( qcarModelViewMatrix.data );
        modelViewMatrix.scale( [ utils scaleY ], [ utils scaleX ], 1 );                 //-- have to scale matrix otherwise it looks scewed.
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
    
#endif
}

/////////////////////////////////////////////////////////
//  EXIT.
/////////////////////////////////////////////////////////

void ofxQCAR :: exit ()
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    [ utils onPause ];
    [ utils onDestroy ];
    
    [ utils release ];
    utils = nil;
    
    [ delegate release ];
    delegate = nil;

#endif
}
