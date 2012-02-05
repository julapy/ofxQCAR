//
//  ofxQCAR_Utils.h
//  emptyExample
//
//  Created by lukasz karluk on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofMain.h"
#import <Foundation/Foundation.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>

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
@public
    
    ofMatrix4x4 projectionMatrix;
    ofMatrix4x4 modelViewMatrix;
    float scaleX;
    float scaleY;
    bool bFoundMarker;
    
    ofRectangle markerRect;
    ofVec2f markerCenter;
    ofVec2f markerCorners[ 4 ];
    
@private
    
    struct tagARData {
        CGRect screenRect;
        NSMutableArray* textures;   // Teapot textures
        int QCARFlags;              // QCAR initialisation flags
        status appStatus;           // Current app status
        int errorCode;              // if appStatus == APPSTATUS_ERROR
    } ARData;
}

@property(nonatomic,retain) id delegate;

+ (ofxQCAR_Utils *) getInstance;

- (id)initWithDelegate : (id)delegate;

- (void)onCreate;
- (void)onDestroy;
- (void)onResume;
- (void)onPause;
- (void)onUpdate:(QCAR::Trackable*)trackable;

@end

#endif
