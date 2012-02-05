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
#if !(TARGET_IPHONE_SIMULATOR)    
    
    return utils->projectionMatrix;
    
#else
    
    return ofMatrix4x4();
    
#endif
}

const ofMatrix4x4& ofxQCAR :: getModelViewMatrix () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)    
    
    return utils->modelViewMatrix;
    
#else
    
    return ofMatrix4x4();
    
#endif
}

const ofRectangle& ofxQCAR :: getMarkerRect ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    return utils->markerRect;
    
#else
    
    return ofRectangle();
    
#endif
}

const ofVec2f& ofxQCAR :: getMarkerCenter ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    return utils->markerCenter;
    
#else
    
    return ofVec2f();
    
#endif
}

const ofVec2f& ofxQCAR :: getMarkerCorner ( ofxQCAR_MarkerCorner cornerIndex )
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    return utils->markerCorners[ cornerIndex ];
    
#else
    
    return ofVec2f();
    
#endif
}

const bool& ofxQCAR :: hasFoundMarker () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)     
    
    return utils->bFoundMarker;
    
#else
    
    return false;
    
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

void ofxQCAR :: drawMarkerRect ()
{
    glPushMatrix();
    glTranslatef( ofGetWidth() * 0.5, ofGetHeight() * 0.5, 0 );
    {
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf( getProjectionMatrix().getPtr() );
        
        glMatrixMode( GL_MODELVIEW );
        glLoadMatrixf( getModelViewMatrix().getPtr() );
        
        float markerW = getMarkerRect().width;
        float markerH = getMarkerRect().height;
        
        ofRect( -markerW * 0.5, -markerH * 0.5, markerW, markerH );
        
        ofSetupScreen();
    }
    glPopMatrix();
}

void ofxQCAR :: drawMarkerCenter ()
{
    const ofVec2f& markerCenter = getMarkerCenter();
    ofCircle( markerCenter.x, markerCenter.y, 4 );
}

void ofxQCAR :: drawMarkerCorners ()
{
    for( int i=0; i<4; i++ )
    {
        const ofVec2f& markerCorner = getMarkerCorner( (ofxQCAR_MarkerCorner)i );
        ofCircle( markerCorner.x, markerCorner.y, 4 );
    }
}

void ofxQCAR :: drawMarkerBounds ()
{
    for( int i=0; i<4; i++ )
    {
        int j = ( i + 1 ) % 4;
        const ofVec2f& mc1 = getMarkerCorner( (ofxQCAR_MarkerCorner)i );
        const ofVec2f& mc2 = getMarkerCorner( (ofxQCAR_MarkerCorner)j );
        
        ofLine( mc1.x, mc1.y, mc2.x, mc2.y );
    }
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
