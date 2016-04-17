//
//  ofxQCAR_App.h
//  UserDefinedTargets
//
//  Created by Lukasz Karluk on 19/05/13.
//
//

#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#import <Vuforia/State.h>

class ofxQCAR_App : public ofxiOSApp {

public:

    virtual void qcarInitARDone(NSError * error) {
        // copy this method to your app to receive this callback.
    }

    virtual bool qcarInitTrackers() {
        return true; // copy this method to your app to receive this callback.
    }
    
    virtual bool qcarLoadTrackersData() {
        return true; // copy this method to your app to receive this callback.
    }
    
    virtual bool qcarStartTrackers() {
        return true; // copy this method to your app to receive this callback.
    }
    
    virtual bool qcarStopTrackers() {
        return true; // copy this method to your app to receive this callback.
    }
    
    virtual bool qcarUnloadTrackersData() {
        return true; // copy this method to your app to receive this callback.
    }
    
    virtual bool qcarDeinitTrackers() {
        return true; // copy this method to your app to receive this callback.
    }
    
    virtual void qcarUpdate(Vuforia::State * state) {
        // copy this method to your app to receive this callback.
    }
};
