//
//  ofxQCAR_Marker.hpp
//  LaserEyes
//
//  Created by Lukasz Karluk on 30/11/2015.
//
//

#pragma once

#include "ofMatrix4x4.h"
#include "ofRectangle.h"

class ofxQCAR_Marker {
public:
    
    ofxQCAR_Marker();
    
    ofMatrix4x4 projectionMatrix;
    ofMatrix4x4 modelViewMatrix;
    float poseMatrixData[3*4];
    
    ofRectangle markerRect;
    ofVec2f markerCenter;
    ofVec2f markerCorners[4];
    ofVec3f markerRotation;
    float markerRotationLeftRight;
    float markerRotationUpDown;
    float markerAngleToCamera;
    string markerName;
};

