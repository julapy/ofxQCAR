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
#import <QCAR/ImageTarget.h>
#import <QCAR/CameraDevice.h>

#endif

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

ofxQCAR* ofxQCAR :: _instance = NULL;

#if !(TARGET_IPHONE_SIMULATOR)

ofxQCAR_Utils *utils = nil;
ofxQCAR_Delegate *delegate = nil;

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
    //
}

-(void) qcar_update
{
    //
}

@end

/////////////////////////////////////////////////////////
//  QCAR.
/////////////////////////////////////////////////////////

ofxQCAR :: ofxQCAR ()
{
    //
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
//  GETTERS.
/////////////////////////////////////////////////////////

const ofMatrix4x4& ofxQCAR :: getProjectionMatrix () 
{ 
    return utils->projectionMatrix;
}

const ofMatrix4x4& ofxQCAR :: getModelViewMatrix () 
{ 
    return utils->modelViewMatrix;
}

const bool& ofxQCAR :: hasFoundMarker () 
{ 
    return utils->bFoundMarker;
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
    
    //--- render the video background.
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();
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
