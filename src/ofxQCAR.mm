//
//  ofxQCAR.cpp
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR.h"

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxVuforiaSession.h"
#import "ofxiOSExtras.h"

#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Tracker.h>
#import <QCAR/Trackable.h>
#import <QCAR/TrackableResult.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/UpdateCallback.h>
#import <QCAR/Matrices.h>
#import <QCAR/Image.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ObjectTracker.h>
#import <QCAR/ImageTargetBuilder.h>
#import <QCAR/VideoBackgroundConfig.h>

//using namespace QCAR;

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

QCAR::Vec2F cameraPointToScreenPoint(QCAR::Vec2F cameraPoint) {
    
    QCAR::VideoMode videoMode = QCAR::CameraDevice::getInstance().getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    const QCAR::VideoBackgroundConfig & config = QCAR::Renderer::getInstance().getVideoBackgroundConfig();
    
    int xOffset = ((int)ofGetWidth()  - config.mSize.data[0]) / 2.0f + config.mPosition.data[0];
    int yOffset = ((int)ofGetHeight() - config.mSize.data[1]) / 2.0f - config.mPosition.data[1];
    
    if(ofxQCAR::getInstance()->getOrientation() == OFX_QCAR_ORIENTATION_PORTRAIT) {
        // camera image is rotated 90 degrees
        int rotatedX = videoMode.mHeight - cameraPoint.data[1];
        int rotatedY = cameraPoint.data[0];
        
        return QCAR::Vec2F(rotatedX * config.mSize.data[0] / (float) videoMode.mHeight + xOffset,
                           rotatedY * config.mSize.data[1] / (float) videoMode.mWidth + yOffset);
    } else {
        // camera image is rotated 180 degrees
        int rotatedX = videoMode.mWidth - cameraPoint.data[0];
        int rotatedY = videoMode.mHeight - cameraPoint.data[1];
        
        return QCAR::Vec2F(rotatedX * config.mSize.data[0] / (float) videoMode.mWidth + xOffset,
                           rotatedY * config.mSize.data[1] / (float) videoMode.mHeight + yOffset);
    }
    
    return QCAR::Vec2F(0, 0);
}

#endif

/////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////

ofxQCAR * ofxQCAR::_instance = NULL;

/////////////////////////////////////////////////////////
//  DELEGATE.
/////////////////////////////////////////////////////////

#if !(TARGET_IPHONE_SIMULATOR)

@interface ofxVuforiaDelegate : NSObject <ofxVuforiaSessionDelegate>

// ofxVuforiaDelegate passes events and callbacks back to ofxQCAR.

@end

@implementation ofxVuforiaDelegate

- (void)onInitARDone:(NSError *)error {
    ofxQCARInstance().qcarInitARDone(error);
    ofxQCARGetApp().qcarInitARDone(error);
}

- (bool)doInitTrackers {
    bool bOk = true;
    bOk = bOk && ofxQCARInstance().qcarInitTrackers();
    bOk = bOk && ofxQCARGetApp().qcarInitTrackers();
    return bOk;
}

- (bool)doLoadTrackersData {
    bool bOk = true;
    bOk = bOk && ofxQCARInstance().qcarLoadTrackersData();
    bOk = bOk && ofxQCARGetApp().qcarLoadTrackersData();
    return bOk;
}

- (bool)doStartTrackers {
    bool bOk = true;
    bOk = bOk && ofxQCARInstance().qcarStartTrackers();
    bOk = bOk && ofxQCARGetApp().qcarStartTrackers();
    return bOk;
}

- (bool)doStopTrackers {
    bool bOk = true;
    bOk = bOk && ofxQCARInstance().qcarStopTrackers();
    bOk = bOk && ofxQCARGetApp().qcarStopTrackers();
    return bOk;
}

- (bool)doUnloadTrackersData {
    bool bOk = true;
    bOk = bOk && ofxQCARInstance().qcarUnloadTrackersData();
    bOk = bOk && ofxQCARGetApp().qcarUnloadTrackersData();
    return bOk;
}

- (bool)doDeinitTrackers {
    bool bOk = true;
    bOk = bOk && ofxQCARInstance().qcarDeinitTrackers();
    bOk = bOk && ofxQCARGetApp().qcarDeinitTrackers();
    return bOk;
}

- (void)onQCARUpdate:(QCAR::State *)state {
    ofxQCARInstance().qcarUpdate(state);
    ofxQCARGetApp().qcarUpdate(state);
}

@end

#endif

/////////////////////////////////////////////////////////
//  QCAR.
/////////////////////////////////////////////////////////

ofxQCAR::ofxQCAR () {
    init();
}

ofxQCAR::~ofxQCAR () {
    //
}

/////////////////////////////////////////////////////////
//  SETUP.
/////////////////////////////////////////////////////////

void ofxQCAR::setLicenseKey(string value) {
    licenseKey = value;
}

void ofxQCAR::setOrientation(ofxQCAR_Orientation orientation) {
    this->orientation = orientation;
}

ofxQCAR_Orientation ofxQCAR::getOrientation() {
    return orientation;
}

void ofxQCAR::addMarkerDataPath(const string & markerDataPath) {
    markersData.push_back(ofxQCAR_MarkerData());
    markersData.back().dataPath = markerDataPath;
}

void ofxQCAR::init() {
    session = nil;
    licenseKey = "";
    bFlipY = false;
    bUpdateCameraPixels = false;
    cameraPixels = NULL;
    cameraWidth = 0;
    cameraHeight = 0;
    orientation = OFX_QCAR_ORIENTATION_PORTRAIT;
    maxNumOfMarkers = 1;
    bScanTarget = false;
    bSaveTarget = false;
    bTrackTarget = false;
    bFoundGoodQualityTarget = false;
    targetCount = 1;
}

void ofxQCAR::setup() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    int QCARInitFlags = QCAR::GL_11;
    if(ofIsGLProgrammableRenderer()) {
        QCARInitFlags = QCAR::GL_20;
    }
    
    CGSize ARViewBoundsSize = CGSizeZero;
    UIInterfaceOrientation ARViewOrientation = UIInterfaceOrientationUnknown;
    
    if(orientation == OFX_QCAR_ORIENTATION_PORTRAIT) {
        ARViewBoundsSize.width = [[UIScreen mainScreen] bounds].size.width;
        ARViewBoundsSize.height = [[UIScreen mainScreen] bounds].size.height;
        ARViewOrientation = UIInterfaceOrientationPortrait;
    } else {
        ARViewBoundsSize.width = [[UIScreen mainScreen] bounds].size.height;
        ARViewBoundsSize.height = [[UIScreen mainScreen] bounds].size.width;
        if(orientation == OFX_QCAR_ORIENTATION_LANDSCAPE_LEFT) {
            ARViewOrientation = UIInterfaceOrientationLandscapeLeft;
        } else if(orientation == OFX_QCAR_ORIENTATION_LANDSCAPE_RIGHT) {
            ARViewOrientation = UIInterfaceOrientationLandscapeRight;
        }
    }
    
    if(ofxiOSGetOFWindow()->isRetinaEnabled() == true) {
        ARViewBoundsSize.width *= 2;
        ARViewBoundsSize.height *= 2;
    }
    
    ofxVuforiaDelegate * delegate = [[ofxVuforiaDelegate alloc] init];
    session = [[ofxVuforiaSession alloc] initWithDelegate:delegate];
    
    [session initAR:QCARInitFlags
         boundsSize:ARViewBoundsSize
        orientation:ARViewOrientation
         licenseKey:[NSString stringWithUTF8String:licenseKey.c_str()]];
    
#endif
}

/////////////////////////////////////////////////////////
//  CALLBACKS.
/////////////////////////////////////////////////////////

bool ofxQCAR::qcarInitTrackers() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::TrackerManager & trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker * trackerBase = trackerManager.initTracker(QCAR::ObjectTracker::getClassType());
    if(trackerBase == NULL) {
        ofLog(OF_LOG_ERROR, "ofxQCAR - Failed to initialize ObjectTracker.");
        return false;
    }
    
    ofLog(OF_LOG_VERBOSE, "ofxQCAR - Successfully initialized ObjectTracker.");
    
#endif
    
    return true;
}

bool ofxQCAR::qcarLoadTrackersData() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::TrackerManager & trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker * objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if(objectTracker == NULL) {
        ofLog(OF_LOG_ERROR, "ofxQCAR - failed to get the ObjectTracker from the tracker manager");
        return false;
    }
    
    for(int i=0; i<markersData.size(); i++) {
        ofxQCAR_MarkerData & markerData = markersData[i];
        if(markerData.dataSet != NULL) {
            continue;
        }
        
        markerData.dataSet = objectTracker->createDataSet();
        
        if(markerData.dataSet == NULL) {
            ofLog(OF_LOG_ERROR, "ofxQCAR - failed to create data set");
            continue;
        }
        
        bool bLoaded = markerData.dataSet->load(markerData.dataPath.c_str(), QCAR::STORAGE_APPRESOURCE);
        if(bLoaded == false) {
            objectTracker->destroyDataSet(markerData.dataSet);
            markerData.dataSet = NULL;
            ofLog(OF_LOG_ERROR, "ofxQCAR - failed to load data set");
        }
        
        objectTracker->activateDataSet(markerData.dataSet);
    }
    
#endif
    
    return true;
}

void ofxQCAR::qcarInitARDone(NSError * error) {
#if !(TARGET_IPHONE_SIMULATOR)
    
    if(error != nil) {
        return;
    }
    
    QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, maxNumOfMarkers);
    
    NSError * err = nil;
    [session startAR:QCAR::CameraDevice::CAMERA_BACK error:&err];
    
    QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_CONTINUOUSAUTO);
    
    projectionMatrix = ofMatrix4x4([session projectionMatrix].data);
    
#endif
}

bool ofxQCAR::qcarStartTrackers() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::TrackerManager & trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker * tracker = trackerManager.getTracker(QCAR::ObjectTracker::getClassType());
    if(tracker == NULL) {
        return false;
    }
    
    tracker->start();
    
#endif

    return true;
}

bool ofxQCAR::qcarStopTrackers() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::TrackerManager & trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker * tracker = trackerManager.getTracker(QCAR::ObjectTracker::getClassType());
    
    if(tracker == NULL) {
        ofLog(OF_LOG_ERROR, "ofxQCAR - failed to get the tracker from the tracker manager");
        return false;
    }
    
    tracker->stop();
    
    ofLog(OF_LOG_VERBOSE, "ofxQCAR - successfully stopped tracker");
    
#endif
    
    return true;
}

bool ofxQCAR::qcarUnloadTrackersData() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::TrackerManager & trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker * objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));

    if(objectTracker == NULL) {
        ofLog(OF_LOG_ERROR, "ofxQCAR - Failed to unload tracking data set because the ObjectTracker has not been initialized.");
        return false;
    }
    
    for(int i=0; i<markersData.size(); i++) {
        ofxQCAR_MarkerData & markerData = markersData[i];

        bool bOk = objectTracker->deactivateDataSet(markerData.dataSet);
        if(bOk == false) {
            ofLog(OF_LOG_ERROR, "ofxQCAR - Failed to deactivate data set.");
        }
        
        bOk = objectTracker->destroyDataSet(markerData.dataSet);
        if(bOk == false) {
            ofLog(OF_LOG_ERROR, "ofxQCAR - Failed to destroy data set.");
        }
    }
    
#endif
    
    return true;
}

bool ofxQCAR::qcarDeinitTrackers() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::TrackerManager & trackerManager = QCAR::TrackerManager::getInstance();
    trackerManager.deinitTracker(QCAR::ObjectTracker::getClassType());
    
#endif
    
    return true;
}

void ofxQCAR::qcarUpdate(QCAR::State * state) {
    //
}

/////////////////////////////////////////////////////////
//  USER DEFINED TARGETS.
/////////////////////////////////////////////////////////
void ofxQCAR::scanCustomTarget() {
#if !(TARGET_IPHONE_SIMULATOR)
    if(bScanTarget == true) {
        return;
    }
    
    stopTracker();
    startScan();
    
    bScanTarget = true;
#endif
}

void ofxQCAR::stopCustomTarget() {
#if !(TARGET_IPHONE_SIMULATOR)

    startTracker();
    stopScan();
    
//    TrackerManager & trackerManager = TrackerManager::getInstance();
//    ImageTracker * imageTracker = static_cast<ImageTracker*>(trackerManager.getTracker(ImageTracker::getClassType()));
//    imageTracker->deactivateDataSet(imageTracker->getActiveDataSet());
//    imageTracker->activateDataSet([[ofxQCAR_Utils getInstance] getDefaultDataSet]);
    
    bScanTarget = false;
    bSaveTarget = false;
    bTrackTarget = false;
    bFoundGoodQualityTarget = false;

#endif
}

void ofxQCAR::saveCustomTarget() {
#if !(TARGET_IPHONE_SIMULATOR)
    if((bSaveTarget == true) || (bFoundGoodQualityTarget == false)) {
        return;
    }
//    TrackerManager & trackerManager = TrackerManager::getInstance();
//    ImageTracker * imageTracker = static_cast<ImageTracker*>(trackerManager.getTracker(ImageTracker::getClassType()));
//    if(imageTracker == NULL) {
//        return;
//    }
//    ImageTargetBuilder * targetBuilder = imageTracker->getImageTargetBuilder();
//    if(targetBuilder == NULL) {
//        return;
//    }
//    
//    char name[128];
//    do {
//        snprintf(name, sizeof(name), "UserTarget-%d", targetCount++);
//    }
//    while(!targetBuilder->build(name, 320.0));
    
    bSaveTarget = true;
#endif
}

void ofxQCAR::trackCustomTarget() {
#if !(TARGET_IPHONE_SIMULATOR)
    if(bScanTarget == false) {
        return;
    }
    
    startTracker();
    stopScan();
    
    bScanTarget = false;
    bSaveTarget = false;
    bTrackTarget = true;
    bFoundGoodQualityTarget = false;
#endif
}

bool ofxQCAR::isScanningCustomTarget() {
    return bScanTarget;
}
    
bool ofxQCAR::isTrackingCustomTarget() {
    return bTrackTarget;
}

bool ofxQCAR::hasFoundGoodQualityTarget() {
    return bFoundGoodQualityTarget;
}

//------------------------------ private.
void ofxQCAR::startScan() {
#if !(TARGET_IPHONE_SIMULATOR)
//    TrackerManager & trackerManager = TrackerManager::getInstance();
//    ImageTracker * imageTracker = static_cast<ImageTracker *>(trackerManager.getTracker(ImageTracker::getClassType()));
//    if(imageTracker == NULL) {
//        return;
//    }
//    ImageTargetBuilder * targetBuilder = imageTracker->getImageTargetBuilder();
//    if(targetBuilder == NULL) {
//        return;
//    }
//    if(targetBuilder->getFrameQuality() != ImageTargetBuilder::FRAME_QUALITY_NONE) {
//        targetBuilder->stopScan();
//    }
//    targetBuilder->startScan();
#endif
}

void ofxQCAR::stopScan() {
#if !(TARGET_IPHONE_SIMULATOR)
//    TrackerManager & trackerManager = TrackerManager::getInstance();
//    ImageTracker * imageTracker = static_cast<ImageTracker *>(trackerManager.getTracker(ImageTracker::getClassType()));
//    if(imageTracker == NULL) {
//        return;
//    }
//    ImageTargetBuilder * targetBuilder = imageTracker->getImageTargetBuilder();
//    if((targetBuilder == NULL) || (targetBuilder->getFrameQuality() == ImageTargetBuilder::FRAME_QUALITY_NONE)) {
//        return;
//    }
//    targetBuilder->stopScan();
#endif
}

void ofxQCAR::startTracker() {
#if !(TARGET_IPHONE_SIMULATOR)
//    TrackerManager & trackerManager = TrackerManager::getInstance();
//    ImageTracker * imageTracker = static_cast<ImageTracker *>(trackerManager.getTracker(ImageTracker::getClassType()));
//    if(imageTracker == NULL) {
//        return;
//    }
//    imageTracker->start();
#endif
}

void ofxQCAR::stopTracker() {
#if !(TARGET_IPHONE_SIMULATOR)
//    TrackerManager & trackerManager = TrackerManager::getInstance();
//    ImageTracker * imageTracker = static_cast<ImageTracker *>(trackerManager.getTracker(ImageTracker::getClassType()));
//    if(imageTracker == NULL) {
//        return;
//    }
//    imageTracker->stop();
#endif
}

void ofxQCAR::startExtendedTracking() {
#if !(TARGET_IPHONE_SIMULATOR)




    QCAR::TrackerManager & trackerManager =  QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker * objectTracker = static_cast< QCAR::ObjectTracker *>(trackerManager.getTracker( QCAR::ObjectTracker::getClassType()));


    if(objectTracker == NULL) {
        return;
    }

     for(int e=0; e<objectTracker->getActiveDataSetCount(); e++) {

    QCAR::DataSet * userDefDateSet = objectTracker->getActiveDataSet(e);
    if(userDefDateSet == NULL) {
        return;
    }
    for(int i=0; i<userDefDateSet->getNumTrackables(); i++) {
        QCAR::Trackable * trackable = userDefDateSet->getTrackable(i);
        if(!trackable->startExtendedTracking()){
            ofLog(OF_LOG_ERROR, "Failed to start extended tracking");
        }
    }
      }

#endif
}

void ofxQCAR::stopExtendedTracking() {
#if !(TARGET_IPHONE_SIMULATOR)
    QCAR::TrackerManager & trackerManager =  QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker * objectTracker = static_cast< QCAR::ObjectTracker *>(trackerManager.getTracker( QCAR::ObjectTracker::getClassType()));

    if(objectTracker == NULL) {
        return;
    }


    for(int e=0; e<objectTracker->getActiveDataSetCount(); e++) {


    QCAR::DataSet * userDefDateSet = objectTracker->getActiveDataSet(e);
    if(userDefDateSet == NULL) {
        return;
    }
    for(int i=0; i<userDefDateSet->getNumTrackables(); i++) {
        QCAR::Trackable * trackable = userDefDateSet->getTrackable(i);
        if(trackable->stopExtendedTracking() == false) {
            ofLog(OF_LOG_VERBOSE, "Failed to start extended tracking");
        }
    }
    }
#endif
}


void ofxQCAR::addExtraTarget(string targetName) {
#if !(TARGET_IPHONE_SIMULATOR)
     QCAR::TrackerManager & trackerManager =  QCAR::TrackerManager::getInstance();
     QCAR::ObjectTracker * objectTracker = static_cast< QCAR::ObjectTracker *>(trackerManager.getTracker( QCAR::ObjectTracker::getClassType()));

    if (objectTracker == NULL)
    {
        NSLog(@"Failed to load tracking data set because the ObjectTracker has"
              " not been initialized.");
        return;
    }
    // Create the data sets:
    QCAR::DataSet *  extraset = objectTracker->createDataSet();
    if (extraset == 0)
    {
        NSLog(@"Failed to create a new tracking data.");
        return;

    }

    // Load the data sets:
    if (extraset->exists(targetName.c_str(), QCAR::DataSet::STORAGE_APPRESOURCE))
    {
        NSLog(@"Dataset exists in app source.");
        if (!extraset->load(targetName.c_str(), QCAR::DataSet::STORAGE_APPRESOURCE))
        {
            NSLog(@"Failed to load absolute data set.");
            return;
        }
    }
    else if (extraset->exists(targetName.c_str(), QCAR::DataSet::STORAGE_APP))
    {
        NSLog(@"Dataset exists at absolute possition.");
        if (!extraset->load(targetName.c_str(), QCAR::DataSet::STORAGE_APP))
        {
            NSLog(@"Failed to load data set.");
            return;
        }
    }
    else if (extraset->exists(targetName.c_str(), QCAR::DataSet::STORAGE_ABSOLUTE))
    {
        NSLog(@"Dataset exists at absolute possition.");
        if (!extraset->load(targetName.c_str(), QCAR::DataSet::STORAGE_ABSOLUTE))
        {
            NSLog(@"Failed to load data set.");
            return;
        }
    }
    else{
        NSLog(@"Could not load");
    }



    // Activate the data set:
    if (!objectTracker->activateDataSet(extraset))
    {
        NSLog(@"Failed to activate data set.");
        return;
    }



    NSLog(@"New dataset active. Active datasets: %d", objectTracker->getActiveDataSetCount());


#endif
}

/////////////////////////////////////////////////////////
//  SETTERS.
/////////////////////////////////////////////////////////

void ofxQCAR::torchOn() {
#if !(TARGET_IPHONE_SIMULATOR)
//    [[ofxQCAR_Utils getInstance] cameraSetTorchMode:YES];
#endif
}

void ofxQCAR::torchOff() {
#if !(TARGET_IPHONE_SIMULATOR)
//    [[ofxQCAR_Utils getInstance] cameraSetTorchMode:NO];
#endif
}

void ofxQCAR::autoFocusOn() {
#if !(TARGET_IPHONE_SIMULATOR)
//    [[ofxQCAR_Utils getInstance] cameraSetContinuousAFMode:YES];
#endif
}

void ofxQCAR::autoFocusOff() {
#if !(TARGET_IPHONE_SIMULATOR)
//    [[ofxQCAR_Utils getInstance] cameraSetContinuousAFMode:NO];
#endif
}

void ofxQCAR::autoFocusOnce() {
#if !(TARGET_IPHONE_SIMULATOR)
//    [[ofxQCAR_Utils getInstance] cameraPerformAF];
#endif
}

/////////////////////////////////////////////////////////
//  PAUSE / RESUME QCAR.
/////////////////////////////////////////////////////////

void ofxQCAR::pause() {
#if !(TARGET_IPHONE_SIMULATOR)    
    if(session == nil) {
        return;
    }
    NSError * error = nil;
    [session pauseAR:&error];
    if(error != nil) {
        NSLog(@"%@", error.description);
    }
#endif
}

void ofxQCAR::resume() {
#if !(TARGET_IPHONE_SIMULATOR)
    if(session == nil) {
        return;
    }
    NSError * error = nil;
    [session resumeAR:&error];
    if(error != nil) {
        NSLog(@"%@", error.description);
    }
#endif
}

void ofxQCAR::stop() {
#if !(TARGET_IPHONE_SIMULATOR)
    if(session == nil) {
        return;
    }
    NSError * error = nil;
    [session stopAR:&error];
    if(error != nil) {
        NSLog(@"%@", error.description);
    }
#endif
}

/////////////////////////////////////////////////////////
//  CONFIG.
/////////////////////////////////////////////////////////

void ofxQCAR::setMaxNumOfMarkers(int maxMarkers) {
    maxNumOfMarkers = maxMarkers;
}

int ofxQCAR::getMaxNumOfMarkers() {
    return maxNumOfMarkers;
}

/////////////////////////////////////////////////////////
//  GETTERS.
/////////////////////////////////////////////////////////

bool ofxQCAR::hasFoundMarker() { 
    return numOfMarkersFound() > 0;
}

unsigned int ofxQCAR::numOfMarkersFound() {
    return (unsigned int)markersFound.size();
}

ofxQCAR_Marker ofxQCAR::getMarker(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i];
    } else {
        return ofxQCAR_Marker();
    }
}

const ofMatrix4x4 & ofxQCAR::getProjectionMatrix() {
    return projectionMatrix;
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

float ofxQCAR::getMarkerAngleToCamera(unsigned int i) {
    if(i < numOfMarkersFound()) {
        return markersFound[i].markerAngleToCamera;
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
#if !(TARGET_IPHONE_SIMULATOR)
    if(i < numOfMarkersFound()) {
        
        ofxQCAR_Marker & marker = markersFound[i];
        QCAR::Matrix34F pose;
        for(int i=0; i<12; i++) {
            pose.data[i] = marker.poseMatrixData[i];
        }
        
        const QCAR::CameraCalibration& cameraCalibration = QCAR::CameraDevice::getInstance().getCameraCalibration();
        QCAR::Vec2F cameraPoint = QCAR::Tool::projectPoint(cameraCalibration, pose, QCAR::Vec3F(point.x, point.y, point.z));
        QCAR::Vec2F xyPoint = cameraPointToScreenPoint(cameraPoint);
        ofVec2f screenPoint(xyPoint.data[0], xyPoint.data[1]);
        return screenPoint;
    } else {
        return ofVec2f();
    }
#else
    return ofVec2f();
#endif
}

ofVec2f ofxQCAR::screenPointToMarkerPoint(ofVec2f screenPoint, unsigned int i) {
    
#if !(TARGET_IPHONE_SIMULATOR)
    if(i < numOfMarkersFound()) {
        
        ofxQCAR_Marker & marker = markersFound[i];
        
        float x = ofMap(screenPoint.x, 0, ofGetWidth(), -1.0, 1.0);
        float y = ofMap(screenPoint.y, 0, ofGetHeight(), 1.0, -1.0);

        ofVec3f ndcNear(x, y, -1);
        ofVec3f ndcFar(x, y, 1);
        
        ofMatrix4x4 inverseProjMatrix = marker.projectionMatrix.getInverse();
        ofVec3f pointOnNearPlane = inverseProjMatrix.preMult(ndcNear);
        ofVec3f pointOnFarPlane = inverseProjMatrix.preMult(ndcFar);
        
        ofMatrix4x4 inverseModelViewMatrix = marker.modelViewMatrix.getInverse();
        ofVec3f lineStart = inverseModelViewMatrix.preMult(pointOnNearPlane);
        ofVec3f lineEnd = inverseModelViewMatrix.preMult(pointOnFarPlane);
        ofVec3f lineDir = (lineEnd - lineStart).getNormalized();

        ofVec3f planeCenter(0, 0, 0);
        ofVec3f planeNormal(0, 0, 1);
        ofVec3f planeDir = planeCenter - lineStart;

        float n = planeNormal.dot(planeDir);
        float d = planeNormal.dot(lineDir);
        
        if(fabs(d) < 0.00001) {
            // Line is parallel to plane
            return ofVec2f();
        }
        
        float dist = n / d;
        ofVec3f offset = lineDir * dist;
        ofVec3f intersection = lineStart + offset;
        
        return ofVec2f(intersection.x, intersection.y);
        
    } else {
        return ofVec2f();
    }
#else
    return ofVec2f();
#endif
}

void ofxQCAR::setCameraPixelsFlag(bool b) {
    bUpdateCameraPixels = b;
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

void ofxQCAR::setFlipY(bool b) {
    bFlipY = b;
}

/////////////////////////////////////////////////////////
//  UPDATE.
/////////////////////////////////////////////////////////

void ofxQCAR::update() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().end();
    
    markersFound.clear();
    
    int numOfTrackables = state.getNumTrackableResults();
    for (int i=0; i<numOfTrackables; i++) {

        const QCAR::TrackableResult & result = *state.getTrackableResult(i);
        
        if(result.getStatus() != QCAR::TrackableResult::DETECTED &&
           result.getStatus() != QCAR::TrackableResult::TRACKED &&
           result.getStatus() != QCAR::TrackableResult::EXTENDED_TRACKED) {
            continue;
        }

        QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(result.getPose());
        
        markersFound.push_back(ofxQCAR_Marker());
        ofxQCAR_Marker & marker = markersFound.back();
        
        marker.modelViewMatrix = ofMatrix4x4(modelViewMatrix.data);
        marker.projectionMatrix = projectionMatrix;
        
        for(int i=0; i<12; i++) {
            marker.poseMatrixData[i] = result.getPose().data[i];
        }
        
        QCAR::Vec3F markerSize;
        const QCAR::Trackable & trackable = result.getTrackable();
        if(trackable.isOfType(QCAR::ImageTarget::getClassType())){
            QCAR::ImageTarget* imageTarget = (QCAR::ImageTarget *)(&trackable);
            markerSize = imageTarget->getSize();
        }
        
        marker.markerName = trackable.getName();
        
        marker.markerRect.width  = markerSize.data[0];
        marker.markerRect.height = markerSize.data[1];
        
        float markerWH = marker.markerRect.width  * 0.5;
        float markerHH = marker.markerRect.height * 0.5;
        
        QCAR::Vec3F corners[ 4 ];
        corners[0] = QCAR::Vec3F(-markerWH,  markerHH, 0);     // top left.
        corners[1] = QCAR::Vec3F( markerWH,  markerHH, 0);     // top right.
        corners[2] = QCAR::Vec3F( markerWH, -markerHH, 0);     // bottom right.
        corners[3] = QCAR::Vec3F(-markerWH, -markerHH, 0);     // bottom left.
        
        marker.markerCenter = point3DToScreen2D(ofVec3f(0, 0, 0), i);
        
        for(int j=0; j<4; j++) {
            ofVec3f markerCorner = ofVec3f(corners[j].data[0], corners[j].data[1], corners[j].data[2]);
            marker.markerCorners[j] = point3DToScreen2D(markerCorner, i);
        }
        
        ofMatrix4x4 inverseModelView = marker.modelViewMatrix.getInverse();
        inverseModelView = inverseModelView.getTransposedOf(inverseModelView);
        marker.markerRotation.set(inverseModelView.getPtr()[8], inverseModelView.getPtr()[9], inverseModelView.getPtr()[10]);
        marker.markerRotation.normalize();
        marker.markerRotation.rotate(90, ofVec3f(0, 0, 1));
        
        marker.markerRotationLeftRight = marker.markerRotation.angle(ofVec3f(0, 1, 0)); // this only works in landscape mode.
        marker.markerRotationUpDown = marker.markerRotation.angle(ofVec3f(1, 0, 0));    // this only works in landscape mode.
        
        /**
         *  angle of marker to camera around the y-axis (pointing up from the center of marker)
         */
        ofVec3f cameraPosition(inverseModelView(0, 3), inverseModelView(1, 3), inverseModelView(2, 3));
        ofVec3f projectedDirectionToTarget(-cameraPosition.x, -cameraPosition.y, 0);
        projectedDirectionToTarget.normalize();
        ofVec3f markerForward(0.0f, 1.0f, 0.0f);
        float dot = projectedDirectionToTarget.dot(markerForward);
        ofVec3f cross = projectedDirectionToTarget.getCrossed(markerForward);
        float angle = acos(dot);
        angle *= 180.0f / PI;
        if(cross.z > 0) {
            angle = 360.0f - angle;
        }
        marker.markerAngleToCamera = angle;
    }
    
    cameraWidth = 0;
    cameraHeight = 0;
    cameraPixels = NULL;    // reset values on every frame.
    
    if(bUpdateCameraPixels == true) {
        QCAR::Frame frame = state.getFrame();
        const QCAR::Image * image = frame.getImage(0);
        if(image) {
            cameraWidth = image->getBufferWidth();
            cameraHeight = image->getBufferHeight();
            cameraPixels = (unsigned char *)image->getPixels();
        }
    }
    
#endif
}

/////////////////////////////////////////////////////////
//  MARKER BEGIN / END.
/////////////////////////////////////////////////////////

void ofxQCAR::begin(unsigned int i) {
#if !(TARGET_IPHONE_SIMULATOR)
    
    bool bValid = true;
    bValid = bValid && (i < numOfMarkersFound());
    if(bValid == false) {
        return;
    }
    
    ofxQCAR_Marker marker = getMarker(i);
    begin(marker.projectionMatrix, marker.modelViewMatrix);
    
#endif
}

void ofxQCAR::begin(const ofMatrix4x4 & projectionMatrixNew, const ofMatrix4x4 & modelViewMatrixNew) {
#if !(TARGET_IPHONE_SIMULATOR)
    
    shared_ptr<ofBaseRenderer> & renderer = ofGetCurrentRenderer();
    
    renderer->pushView();
    
    ofRectangle viewport;
    viewport.x = session.viewport.posX;
    viewport.y = session.viewport.posY;
    viewport.width = session.viewport.sizeX;
    viewport.height = session.viewport.sizeY;
    renderer->viewport(viewport);
    
    // TODO!
    // seems to me that when bFlipY is true,
    // this is the correct convention.
    // but all older projects have been working with bFlipY set the false.
    // todo in the future is remove bFlipY and assume its always true.
    
    if(bFlipY == false) {
        renderer->setOrientation(ofGetOrientation(), false);
    }
    
    ofMatrix4x4 projMatrix = projectionMatrixNew;
    if(bFlipY == true) {
        projMatrix.postMultScale(ofVec3f(1, -1, 1));
    }
    renderer->matrixMode(OF_MATRIX_PROJECTION);
    renderer->loadMatrix(projMatrix);
    
    ofMatrix4x4 modelViewMatrix = modelViewMatrixNew;
    renderer->matrixMode(OF_MATRIX_MODELVIEW);
    renderer->loadViewMatrix(modelViewMatrix);
    
    if(bFlipY == true) {
        ofScale(1, -1, 1);
    }
    
#endif
}

void ofxQCAR::end() {
#if !(TARGET_IPHONE_SIMULATOR)
    
    shared_ptr<ofBaseRenderer> & renderer = ofGetCurrentRenderer();
    renderer->popView();
    
#endif
}

/////////////////////////////////////////////////////////
//  DRAW.
/////////////////////////////////////////////////////////

void ofxQCAR::draw() {
    drawBackground();
}

void ofxQCAR::drawBackground() {
#if !(TARGET_IPHONE_SIMULATOR)

    ofPushView();
    ofPushStyle();
    ofDisableBlendMode();
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    QCAR::Renderer::getInstance().end();
    
    //--- restore openFrameworks render configuration.
    
    ofPopView();
    ofPopStyle();
    
    ofDisableDepthTest();
    glDisable(GL_CULL_FACE);
    
    if(ofIsGLProgrammableRenderer() == true) {
        
        ofGLProgrammableRenderer * renderer = (ofGLProgrammableRenderer *)ofGetCurrentRenderer().get();
        const ofShader & currentShader = renderer->getCurrentShader();
        glUseProgram(currentShader.getProgram());
        
    } else {
        
        glDisable(GL_TEXTURE_2D);
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        glDisableClientState(GL_COLOR_ARRAY);
        glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE); // applies colour to textures.
    }
    
#else
    
    ofSetColor(ofColor::white);
    ofDrawBitmapString("QCAR does not run on the Simulator",
                       (int)(ofGetWidth() * 0.5 - 135),
                       (int)(ofGetHeight() * 0.5 + 10));
    
#endif
}

void ofxQCAR::drawMarkerRect(unsigned int i) {

    begin(i);

    float markerW = getMarkerRect(i).width;
    float markerH = getMarkerRect(i).height;
    ofDrawRectangle(-markerW * 0.5,
                    -markerH * 0.5,
                    markerW,
                    markerH);
    
    end();
}

void ofxQCAR::drawMarkerCenter(unsigned int i) {
    const ofVec2f& markerCenter = getMarkerCenter(i);
    ofDrawCircle(markerCenter.x, markerCenter.y, 4);
}

void ofxQCAR::drawMarkerCorners(unsigned int j) {
    for(int i=0; i<4; i++) {
        const ofVec2f& markerCorner = getMarkerCorner((ofxQCAR_MarkerCorner)i, j);
        ofDrawCircle(markerCorner.x, markerCorner.y, 4);
    }
}

void ofxQCAR::drawMarkerBounds(unsigned int k) {
    for(int i=0; i<4; i++) {
        int j = (i + 1) % 4;
        const ofVec2f& mc1 = getMarkerCorner((ofxQCAR_MarkerCorner)i, k);
        const ofVec2f& mc2 = getMarkerCorner((ofxQCAR_MarkerCorner)j, k);
        
        ofDrawLine(mc1.x, mc1.y, mc2.x, mc2.y);
    }
}

/////////////////////////////////////////////////////////
//  EXIT.
/////////////////////////////////////////////////////////

void ofxQCAR::exit() {
#if !(TARGET_IPHONE_SIMULATOR)

    stopScan();
    markersFound.clear();

    pause();
    stop();
    
    [session release];
    session = nil;
    
#endif
    
    init();
}

/////////////////////////////////////////////////////////
//  GLOBAL.
/////////////////////////////////////////////////////////

ofxQCAR & ofxQCARInstance() {
    return *ofxQCAR::getInstance();
}

ofxQCAR_App & ofxQCARGetApp() {
    return (ofxQCAR_App &)*ofGetAppPtr();
}
