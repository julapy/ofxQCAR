//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxQCAR_Utils.h"
#import "ofxiPhoneExtras.h"

#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Tracker.h>
#import <QCAR/Trackable.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/UpdateCallback.h>
#import <QCAR/Matrices.h>
#import <QCAR/Image.h>
#import <QCAR/QCAR_iOS.h>

using namespace QCAR;

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

Vec2F cameraPointToScreenPoint(Vec2F cameraPoint) {
    
    VideoMode videoMode = CameraDevice::getInstance().getVideoMode(CameraDevice::MODE_DEFAULT);
    VideoBackgroundConfig config = [ofxQCAR_Utils getInstance].config;
    
    int xOffset = ((int)ofGetWidth()  - config.mSize.data[0]) / 2.0f + config.mPosition.data[0];
    int yOffset = ((int)ofGetHeight() - config.mSize.data[1]) / 2.0f - config.mPosition.data[1];
    
    bool isActivityInPortraitMode = true;
    if(isActivityInPortraitMode) {
        // camera image is rotated 90 degrees
        int rotatedX = videoMode.mHeight - cameraPoint.data[1];
        int rotatedY = cameraPoint.data[0];
        
        return Vec2F(rotatedX * config.mSize.data[0] / (float) videoMode.mHeight + xOffset,
                     rotatedY * config.mSize.data[1] / (float) videoMode.mWidth + yOffset);
    } else {
        return Vec2F(cameraPoint.data[0] * config.mSize.data[0] / (float) videoMode.mWidth + xOffset,
                     cameraPoint.data[1] * config.mSize.data[1] / (float) videoMode.mHeight + yOffset);
    }
}

class ofxQCAR_UpdateCallback : public UpdateCallback {
    virtual void QCAR_onUpdate(State& state) {
        
        ofxQCAR * qcar = ofxQCAR::getInstance();
        
        qcar->markersFound.clear();
        
        for (int i = 0; i<state.getNumActiveTrackables(); ++i) {

            const Trackable* trackable = state.getActiveTrackable(i);
            if(!trackable) {
                continue;
            }
            
            if(trackable->getStatus() != Trackable::DETECTED &&
               trackable->getStatus() != Trackable::TRACKED) {
                continue;
            }
            
            Matrix44F modelViewMatrix = Tool::convertPose2GLMatrix(trackable->getPose());
            
            VideoBackgroundConfig config = [ofxQCAR_Utils getInstance].config;
            float scaleX = config.mSize.data[0] / (float)ofGetWidth();
            float scaleY = config.mSize.data[1] / (float)ofGetHeight();
            
            ofxQCAR_Marker marker;
            marker.modelViewMatrix = ofMatrix4x4(modelViewMatrix.data);
            marker.modelViewMatrix.scale(scaleY, scaleX, 1);
            marker.projectionMatrix = ofMatrix4x4([[ofxQCAR_Utils getInstance] projectionMatrix].data);
            
            for(int i=0; i<12; i++) {
                marker.poseMatrixData[i] = trackable->getPose().data[i];
            }
            
            Vec2F markerSize;
            if(trackable->getType() == Trackable::IMAGE_TARGET) {
                ImageTarget* imageTarget = (ImageTarget *)trackable;
                markerSize = imageTarget->getSize();
            }
            
            marker.markerName = trackable->getName();
            
            marker.markerRect.width  = markerSize.data[0];
            marker.markerRect.height = markerSize.data[1];
            
            float markerWH = marker.markerRect.width  * 0.5;
            float markerHH = marker.markerRect.height * 0.5;
            
            Vec3F corners[ 4 ];
            corners[0] = Vec3F(-markerWH,  markerHH, 0);     // top left.
            corners[1] = Vec3F( markerWH,  markerHH, 0);     // top right.
            corners[2] = Vec3F( markerWH, -markerHH, 0);     // bottom right.
            corners[3] = Vec3F(-markerWH, -markerHH, 0);     // bottom left.
            
            const CameraCalibration & cameraCalibration = CameraDevice::getInstance().getCameraCalibration();
            
            Vec2F cameraPoint = Tool::projectPoint(cameraCalibration,trackable->getPose(), Vec3F(0, 0, 0));
            Vec2F xyPoint = cameraPointToScreenPoint(cameraPoint);
            marker.markerCenter.x = xyPoint.data[0];
            marker.markerCenter.y = xyPoint.data[1];
            
            for(int i=0; i<4; i++) {
                Vec2F cameraPoint = Tool::projectPoint(cameraCalibration,trackable->getPose(), corners[i]);
                Vec2F xyPoint = cameraPointToScreenPoint(cameraPoint);
                marker.markerCorners[i].x = xyPoint.data[0];
                marker.markerCorners[i].y = xyPoint.data[1];
            }
            
            ofMatrix4x4 inverseModelView = marker.modelViewMatrix.getInverse();
            inverseModelView = inverseModelView.getTransposedOf(inverseModelView);
            marker.markerRotation.set(inverseModelView.getPtr()[8], inverseModelView.getPtr()[9], inverseModelView.getPtr()[10]);
            marker.markerRotation.normalize();
            marker.markerRotation.rotate(90, ofVec3f(0, 0, 1));
            
            marker.markerRotationLeftRight = marker.markerRotation.angle(ofVec3f(0, 1, 0)); // this only works in landscape mode.
            marker.markerRotationUpDown = marker.markerRotation.angle(ofVec3f(1, 0, 0));    // this only works in landscape mode.
            
            qcar->markersFound.push_back(marker);
        }
    }
    
} qcarUpdate;

#endif

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

ofxQCAR * ofxQCAR::_instance = NULL;
NSMutableArray * targets = nil;
bool bBeginDraw = false;

/////////////////////////////////////////////////////////
//  DELEGATE.
/////////////////////////////////////////////////////////

@implementation ofxQCAR_Delegate

- (void)dealloc {
    [super dealloc];
}

- (void)initApplication {
    //
}

- (void)initApplicationAR {
    //
}

- (void)postInitQCAR {
#if !(TARGET_IPHONE_SIMULATOR)    
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
    
    QCAR::registerCallback(&qcarUpdate);    
#endif
}

@end

/////////////////////////////////////////////////////////
//  QCAR.
/////////////////////////////////////////////////////////

ofxQCAR::ofxQCAR () {
    cameraPixels = NULL;
    cameraWidth = 0;
    cameraHeight = 0;
}

ofxQCAR::~ofxQCAR () {
    //
}

/////////////////////////////////////////////////////////
//  SETUP.
/////////////////////////////////////////////////////////

void ofxQCAR::addTarget(string targetName, string targetPath) {
#if !(TARGET_IPHONE_SIMULATOR)
    if(targets == nil) {
        targets = [[NSMutableArray alloc] init];
    }
    
    NSString * name = [[[NSString alloc] initWithUTF8String:targetName.c_str()] autorelease];
    NSString * path = [[[NSString alloc] initWithUTF8String:targetPath.c_str()] autorelease];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           name, @"name",
                           path, @"path", nil];
    [targets addObject:dict];
    
    [[ofxQCAR_Utils getInstance] addTargetName:name atPath:path];
    
#endif
}

void ofxQCAR::setup() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    [ofxQCAR_Utils getInstance].QCARFlags = QCAR::GL_11 | QCAR::ROTATE_IOS_90;
    
    if(ofxiPhoneGetOFWindow()->isRetinaSupported()) {
        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            if([[UIScreen mainScreen] scale] > 1) {
                [ofxQCAR_Utils getInstance].contentScalingFactor = 2.0f;
            }
        }
    }
    
    [[ofxQCAR_Utils getInstance] createARofSize:[[UIScreen mainScreen] bounds].size 
                                    forDelegate:[[ofxQCAR_Delegate alloc] init]];
#endif
    
    bBeginDraw = false;
}

/////////////////////////////////////////////////////////
//  SETTERS.
/////////////////////////////////////////////////////////

void ofxQCAR::torchOn() {
#if !(TARGET_IPHONE_SIMULATOR)
    [[ofxQCAR_Utils getInstance] cameraSetTorchMode:YES];
#endif
}

void ofxQCAR::torchOff() {
#if !(TARGET_IPHONE_SIMULATOR)
    [[ofxQCAR_Utils getInstance] cameraSetTorchMode:NO];
#endif
}

void ofxQCAR::autoFocusOn() {
#if !(TARGET_IPHONE_SIMULATOR)
    [[ofxQCAR_Utils getInstance] cameraSetContinuousAFMode:YES];
#endif
}

void ofxQCAR::autoFocusOff() {
#if !(TARGET_IPHONE_SIMULATOR)
    [[ofxQCAR_Utils getInstance] cameraSetContinuousAFMode:NO];
#endif
}

/////////////////////////////////////////////////////////
//  PAUSE / RESUME QCAR.
/////////////////////////////////////////////////////////

void ofxQCAR::pause() {
#if !(TARGET_IPHONE_SIMULATOR)    
    [[ofxQCAR_Utils getInstance] pauseAR];
#endif
}

void ofxQCAR::resume() {
#if !(TARGET_IPHONE_SIMULATOR)    
    [[ofxQCAR_Utils getInstance] resumeAR];
#endif
}

/////////////////////////////////////////////////////////
//  GETTERS.
/////////////////////////////////////////////////////////

bool ofxQCAR::hasFoundMarker() { 
    return numOfMarkersFound() > 0;
}

int ofxQCAR::numOfMarkersFound() {
    return markersFound.size();
}

ofxQCAR_Marker ofxQCAR::getMarker(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i];
    } else {
        return ofxQCAR_Marker();
    }
}

ofMatrix4x4 ofxQCAR::getProjectionMatrix(unsigned int i) { 
    if(i < numOfMarkersFound()) {
        return markersFound[i].projectionMatrix;
    } else {
        return ofMatrix4x4();
    }
}

ofMatrix4x4 ofxQCAR::getModelViewMatrix(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].modelViewMatrix;
    } else {
        return ofMatrix4x4();
    }
}

ofRectangle ofxQCAR::getMarkerRect(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerRect;
    } else {
        return ofRectangle();
    }
}

ofVec2f ofxQCAR::getMarkerCenter(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerCenter;
    } else {
        return ofVec2f();
    }
}

ofVec2f ofxQCAR::getMarkerCorner(ofxQCAR_MarkerCorner cornerIndex, unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerCorners[cornerIndex];
    } else {
        return ofVec2f();
    }
}

ofVec3f ofxQCAR::getMarkerRotation(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerRotation;
    } else {
        return ofVec3f();
    }
}

float ofxQCAR::getMarkerRotationLeftRight(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerRotationLeftRight;
    } else {
        return 0;
    }
}

float ofxQCAR::getMarkerRotationUpDown(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerRotationUpDown;
    } else {
        return 0;
    }
}

string ofxQCAR::getMarkerName(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerName;
    } else {
        return "";
    }
}

ofVec2f ofxQCAR::point3DToScreen2D(ofVec3f point, unsigned int i) {
    if(i < numOfMarkersFound()) {
        
        ofxQCAR_Marker & marker = markersFound[i];
        Matrix34F pose;
        for(int i=0; i<12; i++) {
            pose.data[i] = marker.poseMatrixData[i];
        }
        
        const CameraCalibration& cameraCalibration = CameraDevice::getInstance().getCameraCalibration();
        Vec2F cameraPoint = Tool::projectPoint(cameraCalibration, pose, Vec3F(point.x, point.y, point.z));
        Vec2F xyPoint = cameraPointToScreenPoint(cameraPoint);
        ofVec2f screenPoint(xyPoint.data[ 0 ], xyPoint.data[ 1 ]);
        return screenPoint;
    } else {
        return ofVec2f();
    }
}

int ofxQCAR::getCameraWidth() {
    return cameraWidth;
}

int ofxQCAR::getCameraHeight() {
    return cameraHeight;
}

unsigned char * ofxQCAR::getCameraPixels() {
    return cameraPixels;
}

/////////////////////////////////////////////////////////
//  UPDATE.
/////////////////////////////////////////////////////////

void ofxQCAR::update () {
    bBeginDraw = false;
}

/////////////////////////////////////////////////////////
//  BEGIN / END.
/////////////////////////////////////////////////////////

void ofxQCAR::begin(unsigned int i) {
    
    if(!hasFoundMarker()) {
        return;
    }
    
    if(bBeginDraw) { // begin() can not be called again before end() being called first.
        return;
    }
    
    bBeginDraw = true;
    
    glPushMatrix();
    glTranslatef(ofGetWidth() * 0.5, ofGetHeight() * 0.5, 0);

    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(getProjectionMatrix(i).getPtr());
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(getModelViewMatrix(i).getPtr());
    
    glScalef(1, -1, 1);
}

void ofxQCAR::end () {
    if(!bBeginDraw) {
        return;
    }
    
    ofSetupScreen();

    glPopMatrix();
    
    bBeginDraw = false;
}

/////////////////////////////////////////////////////////
//  DRAW.
/////////////////////////////////////////////////////////

void ofxQCAR::draw() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    //--- render the video background.
    
    State state = Renderer::getInstance().begin();
    Renderer::getInstance().drawVideoBackground();
    
    if([ofxQCAR_Utils getInstance].appStatus == APPSTATUS_CAMERA_RUNNING) {
        Frame frame = state.getFrame();
        const Image * image = frame.getImage(0);
        if(image) {
            cameraWidth = image->getBufferWidth();
            cameraHeight = image->getBufferHeight();
            cameraPixels = (unsigned char *)image->getPixels();
        }
    }
    
    Renderer::getInstance().end();
    
    //--- restore openFrameworks render configuration.
    
    glViewport(0, 0, ofGetWidth(), ofGetHeight());
    ofSetupScreen();
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
#else
    
    ofSetColor(ofColor::white);
    ofDrawBitmapString("QCAR does not run on the Simulator",
                       (int)(ofGetWidth() * 0.5 - 135),
                       (int)(ofGetHeight() * 0.5 + 10));
    
#endif
}

void ofxQCAR::drawMarkerRect(unsigned int i) {

    begin();

    float markerW = getMarkerRect(i).width;
    float markerH = getMarkerRect(i).height;
    ofRect(-markerW * 0.5, 
           -markerH * 0.5, 
           markerW, 
           markerH);
    
    end();
}

void ofxQCAR::drawMarkerCenter(unsigned int i) {
    const ofVec2f& markerCenter = getMarkerCenter(i);
    ofCircle(markerCenter.x, markerCenter.y, 4);
}

void ofxQCAR::drawMarkerCorners(unsigned int j) {
    for(int i=0; i<4; i++) {
        const ofVec2f& markerCorner = getMarkerCorner((ofxQCAR_MarkerCorner)i, j);
        ofCircle(markerCorner.x, markerCorner.y, 4);
    }
}

void ofxQCAR::drawMarkerBounds(unsigned int k) {
    for(int i=0; i<4; i++) {
        int j = (i + 1) % 4;
        const ofVec2f& mc1 = getMarkerCorner((ofxQCAR_MarkerCorner)i, k);
        const ofVec2f& mc2 = getMarkerCorner((ofxQCAR_MarkerCorner)j, k);
        
        ofLine(mc1.x, mc1.y, mc2.x, mc2.y);
    }
}

/////////////////////////////////////////////////////////
//  EXIT.
/////////////////////////////////////////////////////////

void ofxQCAR::exit() {
#if !(TARGET_IPHONE_SIMULATOR)

    markersFound.clear();

    [targets release];
    targets = nil;
    
    [[ofxQCAR_Utils getInstance] pauseAR];
    [[ofxQCAR_Utils getInstance] destroyAR];
    
#endif
}
