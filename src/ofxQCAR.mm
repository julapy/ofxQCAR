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

bool bBeginDraw = false;

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
    
    bBeginDraw = false;
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
//  PAUSE / RESUME QCAR.
/////////////////////////////////////////////////////////

void ofxQCAR :: pause ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        [ utils onPause ];
    
#endif
}

void ofxQCAR :: resume ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        [ utils onResume ];
    
#endif
}

/////////////////////////////////////////////////////////
//  GETTERS.
/////////////////////////////////////////////////////////

ofMatrix4x4 ofxQCAR :: getProjectionMatrix () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        return utils->projectionMatrix;
    else
        return ofMatrix4x4();
    
#else
    
    return ofMatrix4x4();
    
#endif
}

ofMatrix4x4 ofxQCAR :: getModelViewMatrix () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        return utils->modelViewMatrix;
    else
        return ofMatrix4x4();
    
#else
    
    return ofMatrix4x4();
    
#endif
}

ofRectangle ofxQCAR :: getMarkerRect ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        return utils->markerRect;
    else
        return ofRectangle();
    
#else
    
    return ofRectangle();
    
#endif
}

ofVec2f ofxQCAR :: getMarkerCenter ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        return utils->markerCenter;
    else
        return ofVec2f();
    
#else
    
    return ofVec2f();
    
#endif
}

ofVec2f ofxQCAR :: getMarkerCorner ( ofxQCAR_MarkerCorner cornerIndex )
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
    if( utils )
        return utils->markerCorners[ cornerIndex ];
    else
        return ofVec2f();
    
#else
    
    return ofVec2f();
    
#endif
}

bool ofxQCAR :: hasFoundMarker () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)     
    
    if( utils )
        return utils->bFoundMarker;
    else
        return false;
    
#else
    
    return false;
    
#endif
}

ofVec3f ofxQCAR :: getMarkerRotation ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
    if( utils )
        return utils->markerRotation;
    else
        return ofVec3f();
    
#else
    
    return ofVec3f();
    
#endif
}

float ofxQCAR :: getMarkerRotationLeftRight ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
    if( utils )
        return utils->markerRotationLeftRight;
    else
        return 0;
    
#else
    
    return 0;
    
#endif
}

float ofxQCAR :: getMarkerRotationUpDown ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
    if( utils )
        return utils->markerRotationUpDown;
    else
        return 0;
    
#else
    
    return 0;
    
#endif
}

string ofxQCAR :: getMarkerName ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
    if( utils )
        return utils->markerName;
    else
        return "";
    
#else
    
    return "";
    
#endif
}

/////////////////////////////////////////////////////////
//  UPDATE.
/////////////////////////////////////////////////////////

void ofxQCAR :: update ()
{
    bBeginDraw = false;
}

/////////////////////////////////////////////////////////
//  BEGIN / END.
/////////////////////////////////////////////////////////

void ofxQCAR :: begin ()
{
    if( bBeginDraw )        // begin() can not be called again before end() being called first.
        return;
    
    bBeginDraw = true;
    
    glPushMatrix();
    glTranslatef( ofGetWidth() * 0.5, ofGetHeight() * 0.5, 0 );

    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf( getProjectionMatrix().getPtr() );
    
    glMatrixMode( GL_MODELVIEW );
    glLoadMatrixf( getModelViewMatrix().getPtr() );
    
    glScalef( 1, -1, 1 );
}

void ofxQCAR :: end ()
{
    if( !bBeginDraw )
        return;
    
    ofSetupScreen();

    glPopMatrix();
    
    bBeginDraw = false;
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
    begin();

    float markerW = getMarkerRect().width;
    float markerH = getMarkerRect().height;
    ofRect( -markerW * 0.5, -markerH * 0.5, markerW, markerH );
    
    end();
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
    
    if( utils )
    {
        [ utils onPause ];
        [ utils onDestroy ];
        
        [ utils release ];
        utils = nil;
    }
    
    if( delegate )
    {
        [ delegate release ];
        delegate = nil;
    }

#endif
}
