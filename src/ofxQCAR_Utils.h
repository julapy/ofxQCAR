//
//  ofxQCAR_Utils.h
//  emptyExample
//
//  Created by lukasz karluk on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QCAR/Tool.h>
#import "ofxQCAR_Settings.h"

// Application status
typedef enum _status {
    APPSTATUS_UNINITED,
    APPSTATUS_INIT_APP,
    APPSTATUS_INIT_QCAR,
    APPSTATUS_INIT_APP_AR,
    APPSTATUS_INIT_TRACKER,
    APPSTATUS_INITED,
    APPSTATUS_CAMERA_STOPPED,
    APPSTATUS_CAMERA_RUNNING,
    APPSTATUS_ERROR
} status;

@interface ofxQCAR_Utils : NSObject
{
@private
    
    // OpenGL projection matrix
    QCAR::Matrix44F projectionMatrix;
    
    struct tagARData {
        CGRect screenRect;
        NSMutableArray* textures;   // Teapot textures
        int QCARFlags;              // QCAR initialisation flags
        status appStatus;           // Current app status
        int errorCode;              // if appStatus == APPSTATUS_ERROR
    } ARData;
}

- (void)onCreate;
- (void)onDestroy;
- (void)onResume;
- (void)onPause;

@end
