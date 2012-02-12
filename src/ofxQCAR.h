//
//  ofxQCAR.h
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "ofMain.h"

@interface ofxQCAR_Delegate : NSObject
-(void) qcar_initialised;
-(void) qcar_cameraStarted;
-(void) qcar_cameraStopped;
-(void) qcar_projectionMatrixReady;
-(void) qcar_update;
@end

enum ofxQCAR_MarkerCorner {
    OFX_QCAR_MARKER_CORNER_TOP_LEFT     = 0,
    OFX_QCAR_MARKER_CORNER_TOP_RIGHT    = 1,
    OFX_QCAR_MARKER_CORNER_BOTTOM_RIGHT = 2,
    OFX_QCAR_MARKER_CORNER_BOTTOM_LEFT  = 3,
};

class ofxQCAR : public ofBaseApp
{
public:
    
     ofxQCAR ();
    ~ofxQCAR ();
    
	static ofxQCAR* getInstance()
	{
		if( !_instance )
			_instance = new ofxQCAR();
        return _instance;
	};
    
    virtual void setup  ();
    virtual void update ();
    virtual void draw   ();
    virtual void exit   ();
    
    virtual void pause  ();
    virtual void resume ();
    
    void drawMarkerRect     ();
    void drawMarkerCenter   ();
    void drawMarkerCorners  ();
    void drawMarkerBounds   ();
    
    void torchOn        ();
    void torchOff       ();
    void autoFocusOn    ();
    void autoFocusOff   ();
    
    const ofMatrix4x4& getProjectionMatrix  ();
    const ofMatrix4x4& getModelViewMatrix   ();
    const ofRectangle& getMarkerRect        ();
    const ofVec2f&     getMarkerCenter      ();
    const ofVec2f&     getMarkerCorner      ( ofxQCAR_MarkerCorner cornerIndex );
    const bool& hasFoundMarker              ();
    
private:
    
    static ofxQCAR* _instance;
    
};