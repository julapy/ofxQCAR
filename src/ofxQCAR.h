//
//  ofxQCAR.h
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "ofMain.h"
#import "ofxQCAR_App.h"
#import "ofxQCAR_Marker.h"
#import <QCAR/DataSet.h>

class ofxQCAR_UpdateCallback;
@class ofxVuforiaSession;

//--------------------------------------------------------------
enum ofxQCAR_MarkerCorner {
    OFX_QCAR_MARKER_CORNER_TOP_LEFT     = 0,
    OFX_QCAR_MARKER_CORNER_TOP_RIGHT    = 1,
    OFX_QCAR_MARKER_CORNER_BOTTOM_RIGHT = 2,
    OFX_QCAR_MARKER_CORNER_BOTTOM_LEFT  = 3,
};

//--------------------------------------------------------------
enum ofxQCAR_Orientation {
    OFX_QCAR_ORIENTATION_PORTRAIT,
    OFX_QCAR_ORIENTATION_LANDSCAPE_LEFT,
    OFX_QCAR_ORIENTATION_LANDSCAPE_RIGHT
};

//--------------------------------------------------------------
class ofxQCAR_MarkerData {
public:
    ofxQCAR_MarkerData() {
        dataPath = "";
        storageType = QCAR::STORAGE_APPRESOURCE;
        dataSet = NULL;
    }
    string dataPath;
    QCAR::STORAGE_TYPE storageType;
    QCAR::DataSet * dataSet;
};

//--------------------------------------------------------------
class ofxQCAR
{
    
public:
    
     ofxQCAR();
    ~ofxQCAR();
    
	static ofxQCAR * getInstance() {
		if(!_instance) {
			_instance = new ofxQCAR();
        }
        return _instance;
	};
    
    void setLicenseKey(string value);
    
    void setOrientation(ofxQCAR_Orientation orientation);
    ofxQCAR_Orientation getOrientation();
    
    void addMarkerDataPath(const string & markerDataPath);
    void addMarkerDataPath(const ofxQCAR_MarkerData & markerData);
    
    bool qcarInitTrackers();
    bool qcarLoadTrackersData();
    void qcarInitARDone(NSError * error);
    bool qcarStartTrackers();
    bool qcarStopTrackers();
    bool qcarUnloadTrackersData();
    bool qcarDeinitTrackers();
    void qcarUpdate(QCAR::State * state);
    
    void scanCustomTarget();
    void stopCustomTarget();
    void saveCustomTarget();
    void trackCustomTarget();
    bool isTrackingCustomTarget();
    bool isScanningCustomTarget();
    bool hasFoundGoodQualityTarget();
    
    virtual void setup();
    virtual void update();
    virtual void exit();
    
    virtual void pause();
    virtual void resume();
    virtual void stop();
    
    virtual void begin(unsigned int i=0);
    virtual void begin(const ofMatrix4x4 & projectionMatrix, const ofMatrix4x4 & modelViewMatrix);
    virtual void end();

    OF_DEPRECATED_MSG("ofxQCAR::draw() is deprecated, use drawBackground() instead.", void draw());
    void drawBackground();
    void drawMarkerRect(unsigned int markerIndex=0);
    void drawMarkerCenter(unsigned int markerIndex=0);
    void drawMarkerCorners(unsigned int markerIndex=0);
    void drawMarkerBounds(unsigned int markerIndex=0);
    
    void torchOn();
    void torchOff();
    void autoFocusOn();
    void autoFocusOff();
    void autoFocusOnce();

    bool hasFoundMarker();
    unsigned int numOfMarkersFound();
    
    // this are just some values to use in a to complex programm
    // in order to move values across diffrerent parts. 
    float possX;
    float possY;
    float possXint;
    float possYint;
    
    void setMaxNumOfMarkers(int maxNumOfMarkers);
    int getMaxNumOfMarkers();
    
    ofxQCAR_Marker getMarker(unsigned int markerIndex=0);
    const ofMatrix4x4 & getProjectionMatrix();
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
    ofVec2f screenPointToMarkerPoint(ofVec2f screenPoint, unsigned int markerIndex=0);
    
    void setCameraPixelsFlag(bool b);
    int getCameraWidth();
    int getCameraHeight();
    unsigned char * getCameraPixels();
    
    void setFlipY(bool b);
    
    void startExtendedTracking();
    void stopExtendedTracking();
    void addExtraTarget(string targetName);
    
private:
    
    void init();
    
    void startScan();
    void stopScan();
    void startTracker();
    void stopTracker();
    
    static ofxQCAR * _instance;
    
    ofxVuforiaSession * session;
    string licenseKey;
    
    ofMatrix4x4 projectionMatrix;
    vector<ofxQCAR_MarkerData> markersData;
    vector<ofxQCAR_Marker> markersFound;
    ofxQCAR_Orientation orientation;
    
    bool bFlipY;
    
    bool bUpdateCameraPixels;
    unsigned char * cameraPixels;
    int cameraWidth;
    int cameraHeight;
    
    int maxNumOfMarkers;
    
    bool bScanTarget;
    bool bSaveTarget;
    bool bTrackTarget;
    bool bFoundGoodQualityTarget;
    int targetCount = 1;
};

//--------------------------------------------------------------
ofxQCAR & ofxQCARInstance();
ofxQCAR_App & ofxQCARGetApp();
