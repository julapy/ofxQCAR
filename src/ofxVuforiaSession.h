/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import <Foundation/Foundation.h>
#import <QCAR/Matrices.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/State.h>

#define E_INITIALIZING_QCAR         100

#define E_INITIALIZING_CAMERA       110
#define E_STARTING_CAMERA           111
#define E_STOPPING_CAMERA           112
#define E_DEINIT_CAMERA             113

#define E_INIT_TRACKERS             120
#define E_LOADING_TRACKERS_DATA     121
#define E_STARTING_TRACKERS         122
#define E_STOPPING_TRACKERS         123
#define E_UNLOADING_TRACKERS_DATA   124
#define E_DEINIT_TRACKERS           125

#define E_CAMERA_NOT_STARTED        150

#define E_INTERNAL_ERROR                -1

// An AR application must implement this protocol in order to be notified of
// the different events during the life cycle of an AR application
@protocol ofxVuforiaSessionDelegate

@required
// this method is called to notify the application that the initialization (initAR) is complete
// usually the application then starts the AR through a call to startAR
- (void) onInitARDone:(NSError *)error;

// the application must initialize its tracker(s)
- (bool) doInitTrackers;

// the application must initialize the data associated to its tracker(s)
- (bool) doLoadTrackersData;

// the application must starts its tracker(s)
- (bool) doStartTrackers;

// the application must stop its tracker(s)
- (bool) doStopTrackers;

// the application must unload the data associated its tracker(s)
- (bool) doUnloadTrackersData;

// the application must deinititalize its tracker(s)
- (bool) doDeinitTrackers;

@optional
// optional method to handle the QCAR callback - can be used to swap dataset for instance
- (void) onQCARUpdate: (QCAR::State *) state;

@end

@interface ofxVuforiaSession : NSObject

- (id)initWithDelegate:(id<ofxVuforiaSessionDelegate>) delegate;

// initialize the AR library. This is an asynchronous method. When the initialization is complete, the callback method initARDone will be called
- (void) initAR:(int) QCARInitFlags ARViewBoundsSize:(CGSize) ARViewBoundsSize orientation:(UIInterfaceOrientation) ARViewOrientation;

// start the AR session
- (bool) startAR:(QCAR::CameraDevice::CAMERA) camera error:(NSError **)error;

// pause the AR session
- (bool) pauseAR:(NSError **)error;

// resume the AR session
- (bool) resumeAR:(NSError **)error;

// stop the AR session
- (bool) stopAR:(NSError **)error;

// utility methods

// stop the camera.
// This can be used if you want to switch between the front and the back camera for instance
- (bool) stopCamera:(NSError **)error;

@property (nonatomic, readwrite) BOOL isRetinaDisplay;
@property (nonatomic, readwrite) BOOL cameraIsStarted;
@property (nonatomic, readwrite) QCAR::Matrix44F projectionMatrix;

// Viewport geometry
@property (nonatomic, readwrite) struct tagViewport {
  int posX;
  int posY;
  int sizeX;
  int sizeY;
} viewport;

@end
