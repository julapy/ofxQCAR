//
//  ofxQCAR.h
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "ofMain.h"
#import "ofxQCARUtils.h"

class ofxQCAR : public ofBaseApp
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
    
    const ofMatrix4x4& getProjectionMatrix  () { return projectionMatrix; }
    const ofMatrix4x4& getModelViewMatrix   () { return modelViewMatrix; }
    const bool& hasFoundMarker () { return bFoundMarker; }
    
protected:
    
    bool bInitialised;
    bool bFoundMarker;
    
    ofMatrix4x4 projectionMatrix;
    ofMatrix4x4 modelViewMatrix;
    
};