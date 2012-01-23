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

#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>

ofxQCAR* ofxQCAR :: _instance = NULL;
ofxQCAR_Utils *utils;

QCAR::Matrix44F qcarProjectionMatrix;
QCAR::Matrix44F qcarModelViewMatrix;

ofxQCAR :: ofxQCAR ()
{
    utils = [[ ofxQCAR_Utils alloc ] init ];
    
    bFoundMarker = false;
}

ofxQCAR :: ~ofxQCAR ()
{
    [ utils release ];
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
