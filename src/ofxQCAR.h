//
//  ofxQCAR.h
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "ofMain.h"

#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>
#import <QCAR/UIGLViewProtocol.h>
#import <QCAR/UpdateCallback.h>
#import <QCAR/ImageTarget.h>

class ofxQCAR : public ofBaseApp, public QCAR::UpdateCallback
{
public:
    
     ofxQCAR ();
    ~ofxQCAR ();
    
    virtual void setup  ();
    virtual void update ();
    virtual void draw   ();
    virtual void exit   ();
    
    virtual bool initQCAR       ();
    virtual bool loadTracker    ();
    virtual bool startQCAR      ();
    virtual bool startCamera    ();
    virtual bool stopCamera     ();
    virtual void configureVideoBackground   ();
    
    virtual void QCAR_onUpdate ( QCAR::State& state );
    
protected:
    
    bool bInitialised;
    
    QCAR::Matrix44F projectionMatrix;
    QCAR::Matrix44F modelViewMatrix;
    
};