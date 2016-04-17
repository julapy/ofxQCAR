#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxQCAR.h"
#include "Teapot.h"

class ofApp : public ofxQCAR_App {
	
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void qcarInitialised();
    bool scanTarget();
    bool saveTarget();
    bool isScanning();
    bool isTracking();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofImage teapotImage;
};


