//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"

#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>
#import <QCAR/UIGLViewProtocol.h>


ofxQCAR :: ofxQCAR ()
{
    //
}

ofxQCAR :: ~ofxQCAR ()
{
    //
}

void ofxQCAR :: setup ()
{
    //
}

void ofxQCAR :: update ()
{
    //
}

void ofxQCAR :: draw ()
{
    //
}

void ofxQCAR :: exit ()
{
    QCAR :: deinit();
}