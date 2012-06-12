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
#import <QCAR/Trackable.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/CameraDevice.h>

#endif

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

ofxQCAR * ofxQCAR::_instance = NULL;
bool bBeginDraw = false;

/////////////////////////////////////////////////////////
//  DELEGATE.
/////////////////////////////////////////////////////////

@implementation ofxQCAR_Delegate

- (void)initApplication {
    //
}

- (void)initApplicationAR {
    //
}

- (void)postInitQCAR {
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
}

@end

/////////////////////////////////////////////////////////
//  QCAR.
/////////////////////////////////////////////////////////

ofxQCAR::ofxQCAR () {
    //
}

ofxQCAR::~ofxQCAR () {
    //
}

/////////////////////////////////////////////////////////
//  SETUP.
/////////////////////////////////////////////////////////

void ofxQCAR::addTarget(string targetName, string targetPath) {
#if !(TARGET_IPHONE_SIMULATOR)
    NSString * name = [[NSString alloc] initWithUTF8String:targetName.c_str()];
    NSString * path = [[NSString alloc] initWithUTF8String:targetPath.c_str()];
    [[ofxQCAR_Utils getInstance] addTargetName:name atPath:path];
#endif
}

void ofxQCAR::setup() {
    /**
     *  IMPORTANT!
     *  when background clear is set to true,
     *  it interferes with QCAR and stops it from rendering.
     *  since the camera image changes on every frame and clears the background anyway, 
     *  it's ok to set it to false.
     */
    ofSetBackgroundAuto(false);
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    [ofxQCAR_Utils getInstance].QCARFlags = QCAR::GL_11;
    
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

ofMatrix4x4 ofxQCAR :: getProjectionMatrix () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)    
    
//    if( utils )
//        return utils->projectionMatrix;
//    else
//        return ofMatrix4x4();
    
#else
    
    return ofMatrix4x4();
    
#endif
}

ofMatrix4x4 ofxQCAR :: getModelViewMatrix () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)    
    
//    if( utils )
//        return utils->modelViewMatrix;
//    else
//        return ofMatrix4x4();
    
#else
    
    return ofMatrix4x4();
    
#endif
}

ofRectangle ofxQCAR :: getMarkerRect ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
//    if( utils )
//        return utils->markerRect;
//    else
//        return ofRectangle();
    
#else
    
    return ofRectangle();
    
#endif
}

ofVec2f ofxQCAR :: getMarkerCenter ()
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
//    if( utils )
//        return utils->markerCenter;
//    else
//        return ofVec2f();
    
#else
    
    return ofVec2f();
    
#endif
}

ofVec2f ofxQCAR :: getMarkerCorner ( ofxQCAR_MarkerCorner cornerIndex )
{
#if !(TARGET_IPHONE_SIMULATOR)    
    
//    if( utils )
//        return utils->markerCorners[ cornerIndex ];
//    else
//        return ofVec2f();
    
#else
    
    return ofVec2f();
    
#endif
}

bool ofxQCAR :: hasFoundMarker () 
{ 
#if !(TARGET_IPHONE_SIMULATOR)     
    
//    if( utils )
//        return utils->bFoundMarker;
//    else
//        return false;
    
#else
    
    return false;
    
#endif
}

ofVec3f ofxQCAR :: getMarkerRotation ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
//    if( utils )
//        return utils->markerRotation;
//    else
//        return ofVec3f();
    
#else
    
    return ofVec3f();
    
#endif
}

float ofxQCAR :: getMarkerRotationLeftRight ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
//    if( utils )
//        return utils->markerRotationLeftRight;
//    else
//        return 0;
    
#else
    
    return 0;
    
#endif
}

float ofxQCAR :: getMarkerRotationUpDown ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
//    if( utils )
//        return utils->markerRotationUpDown;
//    else
//        return 0;
    
#else
    
    return 0;
    
#endif
}

string ofxQCAR :: getMarkerName ()
{
#if !(TARGET_IPHONE_SIMULATOR)     
    
//    if( utils )
//        return utils->markerName;
//    else
//        return "";
    
#else
    
    return "";
    
#endif
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

void ofxQCAR::begin () {
    if(bBeginDraw) { // begin() can not be called again before end() being called first.
        return;
    }
    
    bBeginDraw = true;
    
    glPushMatrix();
    glTranslatef(ofGetWidth() * 0.5, ofGetHeight() * 0.5, 0);

    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(getProjectionMatrix().getPtr());
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(getModelViewMatrix().getPtr());
    
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
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    QCAR::Renderer::getInstance().end();
    
    //--- restore openFrameworks render configuration.
    
//    glViewport(0, 0, ofGetWidth(), ofGetHeight());
//    ofSetupScreen();
//    
//    glDisable(GL_DEPTH_TEST);
//    glDisable(GL_CULL_FACE);
//    
//    glDisable(GL_TEXTURE_2D);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_NORMAL_ARRAY);
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
#endif
}

void ofxQCAR::drawMarkerRect() {

    begin();

    float markerW = getMarkerRect().width;
    float markerH = getMarkerRect().height;
    ofRect(-markerW * 0.5, 
           -markerH * 0.5, 
           markerW, 
           markerH);
    
    end();
}

void ofxQCAR::drawMarkerCenter() {
    const ofVec2f& markerCenter = getMarkerCenter();
    ofCircle(markerCenter.x, markerCenter.y, 4);
}

void ofxQCAR::drawMarkerCorners() {
    for(int i=0; i<4; i++) {
        const ofVec2f& markerCorner = getMarkerCorner((ofxQCAR_MarkerCorner)i);
        ofCircle(markerCorner.x, markerCorner.y, 4);
    }
}

void ofxQCAR::drawMarkerBounds() {
    for(int i=0; i<4; i++) {
        int j = (i + 1) % 4;
        const ofVec2f& mc1 = getMarkerCorner((ofxQCAR_MarkerCorner)i);
        const ofVec2f& mc2 = getMarkerCorner((ofxQCAR_MarkerCorner)j);
        
        ofLine(mc1.x, mc1.y, mc2.x, mc2.y);
    }
}

/////////////////////////////////////////////////////////
//  EXIT.
/////////////////////////////////////////////////////////

void ofxQCAR::exit() {
#if !(TARGET_IPHONE_SIMULATOR)
    [ofxQCAR_Utils getInstance].delegate = nil;
    [[ofxQCAR_Utils getInstance] pauseAR];
    [[ofxQCAR_Utils getInstance] destroyAR];
#endif
}
