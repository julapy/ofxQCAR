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

enum ofxQCAR_Orientation {
    OFX_QCAR_ORIENTATION_PORTRAIT,
    OFX_QCAR_ORIENTATION_LANDSCAPE
};

class ofxQCAR_Marker {
public:
    ofxQCAR_Marker() {
        scaleX = 1;
        scaleY = 1;
        markerRotationLeftRight = 0;
        markerRotationUpDown = 0;
        markerAngleToCamera = 0;
        markerName = "";
        for(int i=0; i<12; i++) {
            poseMatrixData[i] = 0;
        }
    }
    ofMatrix4x4 projectionMatrix;
    ofMatrix4x4 modelViewMatrix;
    float poseMatrixData[3*4];
    float scaleX;
    float scaleY;
    
    ofRectangle markerRect;
    ofVec2f markerCenter;
    ofVec2f markerCorners[4];
    ofVec3f markerRotation;
    float markerRotationLeftRight;
    float markerRotationUpDown;
    float markerAngleToCamera;
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
    
    void setOrientation(ofxQCAR_Orientation orientation);
    ofxQCAR_Orientation getOrientation();
    
    virtual void addTarget(const string targetName, const string targetPath);
    
    virtual void setup();
    virtual void update();
    virtual void draw();
    virtual void exit();
    
    virtual void pause();
    virtual void resume();
    
    virtual void begin(unsigned int i=0);
    virtual void end();
    
    void drawMarkerRect(unsigned int markerIndex=0);
    void drawMarkerCenter(unsigned int markerIndex=0);
    void drawMarkerCorners(unsigned int markerIndex=0);
    void drawMarkerBounds(unsigned int markerIndex=0);
    
    void torchOn();
    void torchOff();
    void autoFocusOn();
    void autoFocusOff();

    bool hasFoundMarker();
    int numOfMarkersFound();
    
    void setMaxNumOfMarkers(int maxNumOfMarkers);
    int getMaxNumOfMarkers();
    
    ofxQCAR_Marker getMarker(unsigned int markerIndex=0);
    ofMatrix4x4 getProjectionMatrix(unsigned int markerIndex=0);
    ofMatrix4x4 getModelViewMatrix(unsigned int markerIndex=0);
    ofRectangle getMarkerRect(unsigned int markerIndex=0);
    ofVec2f     getMarkerCenter(unsigned int markerIndex=0);
    ofVec2f     getMarkerCorner(ofxQCAR_MarkerCorner cornerIndex, unsigned int markerIndex=0);
    ofVec3f     getMarkerRotation(unsigned int markerIndex=0);
    float       getMarkerRotationLeftRight(unsigned int markerIndex=0);
    float       getMarkerRotationUpDown(unsigned int markerIndex=0);
    float       getMarkerAngleToCamera(unsigned int markerIndex=0);
    string      getMarkerName(unsigned int markerIndex=0);
    
    ofVec2f point3DToScreen2D(ofVec3f point, unsigned int markerIndex=0);
    
    void setCameraPixelsFlag(bool b);
    int getCameraWidth();
    int getCameraHeight();
    unsigned char * getCameraPixels();
    
private:
    
    static ofxQCAR * _instance;
    vector<ofxQCAR_Marker> markersFound;
    ofxQCAR_Orientation orientation;
    
    bool bUpdateCameraPixels;
    unsigned char * cameraPixels;
    int cameraWidth;
    int cameraHeight;
    
    int maxNumOfMarkers;
};