//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"
#import "ofxiPhoneExtras.h"
#import "ofxQCAR_Utils.h"

#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>

///////////////////////////////////////////////////////
//  RESIZE UTILS.
///////////////////////////////////////////////////////

static ofRectangle cropToSize ( const ofRectangle& srcRect, const ofRectangle& dstRect )
{
    float wRatio, hRatio, scale;
    
    wRatio = dstRect.width  / (float)srcRect.width;
    hRatio = dstRect.height / (float)srcRect.height;
    
    scale = MAX( wRatio, hRatio );
    
    ofRectangle			rect;
    rect.x		= ( dstRect.width  - ( srcRect.width  * scale ) ) * 0.5;
    rect.y		= ( dstRect.height - ( srcRect.height * scale ) ) * 0.5;
    rect.width	= srcRect.width  * scale;
    rect.height	= srcRect.height * scale;
    
    return rect;
}

static ofRectangle fitToSize  ( const ofRectangle& srcRect, const ofRectangle& dstRect )
{
    float wRatio, hRatio, scale;
    
    wRatio = dstRect.width  / (float)srcRect.width;
    hRatio = dstRect.height / (float)srcRect.height;
    
    scale = MIN( wRatio, hRatio );
    
    ofRectangle			rect;
    rect.x		= ( dstRect.width  - ( srcRect.width  * scale ) ) * 0.5;
    rect.y		= ( dstRect.height - ( srcRect.height * scale ) ) * 0.5;
    rect.width	= srcRect.width  * scale;
    rect.height	= srcRect.height * scale;
    
    return rect;
}

///////////////////////////////////////////////////////
//  
///////////////////////////////////////////////////////

QCAR::Matrix44F qcarProjectionMatrix;
QCAR::Matrix44F qcarModelViewMatrix;

ofxQCAR_Utils *utils;


ofxQCAR :: ofxQCAR ()
{
    utils = [[ ofxQCAR_Utils alloc ] init ];
    
    bFoundMarker = false;
}

ofxQCAR :: ~ofxQCAR ()
{
    //
}

void ofxQCAR :: setup ()
{
    [ utils onCreate ];
}

void ofxQCAR :: update ()
{
    //
}

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
}

void ofxQCAR :: exit ()
{
    [ utils onDestroy ];
}
