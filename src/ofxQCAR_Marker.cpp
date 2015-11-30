//
//  ofxQCAR_Marker.cpp
//  LaserEyes
//
//  Created by Lukasz Karluk on 30/11/2015.
//
//

#include "ofxQCAR_Marker.h"

ofxQCAR_Marker::ofxQCAR_Marker() {
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
