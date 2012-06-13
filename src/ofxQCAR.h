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
- (void)initApplication;    // Initialise the application
- (void)initApplicationAR;  // Initialise the AR parts of the application
- (void)postInitQCAR;       // Do the things that need doing after initialisation
@end

enum ofxQCAR_MarkerCorner {
    OFX_QCAR_MARKER_CORNER_TOP_LEFT     = 0,
    OFX_QCAR_MARKER_CORNER_TOP_RIGHT    = 1,
    OFX_QCAR_MARKER_CORNER_BOTTOM_RIGHT = 2,
    OFX_QCAR_MARKER_CORNER_BOTTOM_LEFT  = 3,
};

class ofxQCAR_Marker {
public:
    ofxQCAR_Marker() {
        scaleX = 1;
        scaleY = 1;
        markerRotationLeftRight = 0;
        markerRotationUpDown = 0;
        markerName = "";
    }
    ofMatrix4x4 projectionMatrix;
    ofMatrix4x4 modelViewMatrix;
    float scaleX;
    float scaleY;
    
    ofRectangle markerRect;
    ofVec2f markerCenter;
    ofVec2f markerCorners[4];
    ofVec3f markerRotation;
    float markerRotationLeftRight;
    float markerRotationUpDown;
    string markerName;
};

class ofxQCAR_UpdateCallback;

class ofxQCAR : public ofBaseApp
{
/**
 *  this allows ofxQCAR_UpdateCallback to make
 *  changes directly to ofxQCAR, even private members.
 */
friend class ofxQCAR_UpdateCallback;
    
public:
    
     ofxQCAR();
    ~ofxQCAR();
    
	static ofxQCAR * getInstance() {
		if(!_instance) {
			_instance = new ofxQCAR();
        }
        return _instance;
	};
    
    virtual void addTarget(const string targetName, const string targetPath);
    
    virtual void setup();
    virtual void update();
    virtual void draw();
    virtual void exit();
    
    virtual void pause();
    virtual void resume();
    
    virtual void begin();
    virtual void end();
    
    void drawMarkerRect();
    void drawMarkerCenter();
    void drawMarkerCorners();
    void drawMarkerBounds();
    
    void torchOn();
    void torchOff();
    void autoFocusOn();
    void autoFocusOff();
    
    ofMatrix4x4 getProjectionMatrix();
    ofMatrix4x4 getModelViewMatrix();
    ofRectangle getMarkerRect();
    ofVec2f     getMarkerCenter();
    ofVec2f     getMarkerCorner(ofxQCAR_MarkerCorner cornerIndex);
    ofVec3f     getMarkerRotation();
    float       getMarkerRotationLeftRight();
    float       getMarkerRotationUpDown();
    string      getMarkerName();
    bool hasFoundMarker();
    
private:
    
    static ofxQCAR * _instance;
    vector<ofxQCAR_Marker> markersFound;
    
};