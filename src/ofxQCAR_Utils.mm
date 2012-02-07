//
//  ofxQCAR_Utils.m
//  emptyExample
//
//  Created by lukasz karluk on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxQCAR_Utils.h"
#import "ofxQCAR_Settings.h"

#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/UpdateCallback.h>

///////////////////////////////////////////////////////
//  RESIZE UTILS.
///////////////////////////////////////////////////////

static ofRectangle cropToSize ( const ofRectangle& srcRect, const ofRectangle& dstRect )
{
    float wRatio, hRatio, scale;
    
    wRatio = dstRect.width  / (float)srcRect.width;
    hRatio = dstRect.height / (float)srcRect.height;
    
    scale = MAX( wRatio, hRatio );
    
    ofRectangle			rect;
    rect.x		= ( dstRect.width  - ( srcRect.width  * scale ) ) * 0.5;
    rect.y		= ( dstRect.height - ( srcRect.height * scale ) ) * 0.5;
    rect.width	= srcRect.width  * scale;
    rect.height	= srcRect.height * scale;
    
    return rect;
}

static ofRectangle fitToSize  ( const ofRectangle& srcRect, const ofRectangle& dstRect )
{
    float wRatio, hRatio, scale;
    
    wRatio = dstRect.width  / (float)srcRect.width;
    hRatio = dstRect.height / (float)srcRect.height;
    
    scale = MIN( wRatio, hRatio );
    
    ofRectangle			rect;
    rect.x		= ( dstRect.width  - ( srcRect.width  * scale ) ) * 0.5;
    rect.y		= ( dstRect.height - ( srcRect.height * scale ) ) * 0.5;
    rect.width	= srcRect.width  * scale;
    rect.height	= srcRect.height * scale;
    
    return rect;
}

////////////////////////////////////////////////////////////////////////////////
namespace {
    class QCAR_UpdateCallback : public QCAR::UpdateCallback {
        virtual void QCAR_onUpdate(QCAR::State& state);
    } qcarUpdate;
}

////////////////////////////////////////////////////////////////////////////////
@interface ofxQCAR_Utils (PrivateMethods)
- (void)updateApplicationStatus:(status)newStatus;
- (void)bumpAppStatus;
- (void)initApplication;
- (void)initQCAR;
- (void)initApplicationAR;
- (void)loadTracker;
- (void)startCamera;
- (void)stopCamera;
- (void)configureVideoBackground;
- (QCAR::Vec2F)cameraPointToScreenPoint:(QCAR::Vec2F)cameraPoint;
@end

static ofxQCAR_Utils *qcarUtils = nil; // singleton class

////////////////////////////////////////////////////////////////////////////////
@implementation ofxQCAR_Utils

@synthesize delegate;

+ (ofxQCAR_Utils *) getInstance
{
    return qcarUtils;
}

- (id) initWithDelegate : (id) del
{
    if( ( self = [ super init ] ) )
    {
        self.delegate = del;
        bFoundMarker = false;
        scaleX = 1.0;
        scaleY = 1.0;
        
#ifdef USE_OPENGL1
        ARData.QCARFlags = QCAR::GL_11;
#else
        ARData.QCARFlags = QCAR::GL_20;
#endif
        
        NSLog(@"QCAR OpenGL flag: %d", ARData.QCARFlags);
        
        qcarUtils = self;
    }
    
    return self;
}

- (void) dealloc
{
    self.delegate = nil;
    qcarUtils = nil;
    
    [ super dealloc ];
}

////////////////////////////////////////////////////////////////////////////////
- (void)onCreate
{
    NSLog(@"ofxQCAR_Utils onCreate()");
    ARData.appStatus = APPSTATUS_UNINITED;
    
    [self updateApplicationStatus:APPSTATUS_INIT_APP];
}


////////////////////////////////////////////////////////////////////////////////
- (void)onDestroy
{
    NSLog(@"ofxQCAR_Utils onDestroy()");
    // Release the textures array
    [ARData.textures release];
    
    // Deinitialise QCAR SDK
    QCAR::deinit();
}


////////////////////////////////////////////////////////////////////////////////
- (void)onResume
{
    NSLog(@"ofxQCAR_Utils onResume()");
    
    // If the app status is APPSTATUS_CAMERA_STOPPED, QCAR must have been fully
    // initialised
    if (APPSTATUS_CAMERA_STOPPED == ARData.appStatus) {
        // QCAR-specific resume operation
        QCAR::onResume();
        
        [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
    }
}


////////////////////////////////////////////////////////////////////////////////
- (void)onPause
{
    NSLog(@"ofxQCAR_Utils onPause()");
    
    // If the app status is APPSTATUS_CAMERA_RUNNING, QCAR must have been fully
    // initialised
    if (APPSTATUS_CAMERA_RUNNING == ARData.appStatus) {
        [self updateApplicationStatus:APPSTATUS_CAMERA_STOPPED];
        
        // QCAR-specific pause operation
        QCAR::onPause();
    }
}

////////////////////////////////////////////////////////////////////////////////
- (void)onUpdate:(QCAR::Trackable*)trackable
{
    bool b1, b2;
    b1 = trackable->getStatus() == QCAR::Trackable::DETECTED;
    b2 = trackable->getStatus() == QCAR::Trackable::TRACKED;
    
    bFoundMarker = b1 || b2;
    
    if( !bFoundMarker )
    {
        modelViewMatrix = ofMatrix4x4();
        
        if ((delegate != nil) && [delegate respondsToSelector:@selector(qcar_update)])
            [delegate performSelectorOnMainThread:@selector(qcar_update) withObject:nil waitUntilDone:YES];
        
        return;
    }
    
    modelViewMatrix = ofMatrix4x4( QCAR::Tool::convertPose2GLMatrix( trackable->getPose() ).data );
    modelViewMatrix.scale( scaleY, scaleX, 1 );
    
    QCAR::Vec2F markerSize;
    if( trackable->getType() == QCAR::Trackable::IMAGE_TARGET )
    {
        QCAR::ImageTarget* imageTarget = static_cast<QCAR::ImageTarget*>(trackable);
        markerSize = imageTarget->getSize();
    }
    
    markerRect.width  = markerSize.data[ 0 ];
    markerRect.height = markerSize.data[ 1 ];
    
    float markerWH = markerRect.width  * 0.5;
    float markerHH = markerRect.height * 0.5;
    
    QCAR::Vec3F corners[ 4 ];
    corners[ 0 ] = QCAR::Vec3F( -markerWH,  markerHH, 0 );     // top left.
    corners[ 1 ] = QCAR::Vec3F(  markerWH,  markerHH, 0 );     // top right.
    corners[ 2 ] = QCAR::Vec3F(  markerWH, -markerHH, 0 );     // bottom right.
    corners[ 3 ] = QCAR::Vec3F( -markerWH, -markerHH, 0 );     // bottom left.
    
    const QCAR::CameraCalibration& cameraCalibration = QCAR::Tracker::getInstance().getCameraCalibration();
    
    QCAR::Vec2F cameraPoint = QCAR::Tool::projectPoint(cameraCalibration,trackable->getPose(), QCAR::Vec3F( 0, 0, 0 ) );
    QCAR::Vec2F xyPoint = [ self cameraPointToScreenPoint: cameraPoint ];
    markerCenter.x = xyPoint.data[ 0 ];
    markerCenter.y = xyPoint.data[ 1 ];

    for( int i=0; i<4; i++ )
    {
        QCAR::Vec2F cameraPoint = QCAR::Tool::projectPoint(cameraCalibration,trackable->getPose(), corners[ i ] );
        QCAR::Vec2F xyPoint = [ self cameraPointToScreenPoint: cameraPoint ];
        markerCorners[ i ].x = xyPoint.data[ 0 ];
        markerCorners[ i ].y = xyPoint.data[ 1 ];
    }
    
    if ((delegate != nil) && [delegate respondsToSelector:@selector(qcar_update)])
        [delegate performSelectorOnMainThread:@selector(qcar_update) withObject:nil waitUntilDone:YES];

}

////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    exit(0);
}

////////////////////////////////////////////////////////////////////////////////
- (void)updateApplicationStatus:(status)newStatus
{
    if (newStatus != ARData.appStatus && APPSTATUS_ERROR != ARData.appStatus) {
        ARData.appStatus = newStatus;
        
        switch (ARData.appStatus) {
            case APPSTATUS_INIT_APP:
                // Initialise the application
                [self initApplication];
                [self updateApplicationStatus:APPSTATUS_INIT_QCAR];
                break;
                
            case APPSTATUS_INIT_QCAR:
                // Initialise QCAR
                [self performSelectorInBackground:@selector(initQCAR) withObject:nil];
                break;
                
            case APPSTATUS_INIT_APP_AR:
                // AR-specific initialisation
                [self initApplicationAR];
                [self updateApplicationStatus:APPSTATUS_INIT_TRACKER];
                break;
                
            case APPSTATUS_INIT_TRACKER:
                // Load tracker data
                [self performSelectorInBackground:@selector(loadTracker) withObject:nil];
                break;
                
            case APPSTATUS_INITED:
                // These two calls to setHint tell QCAR to split work over
                // multiple frames.  Depending on your requirements you can opt
                // to omit these.
                QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
                QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
                
                // Here we could also make a QCAR::setHint call to set the
                // maximum number of simultaneous targets                
                // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
                
                // Register a callback function that gets called every time a
                // tracking cycle has finished and we have a new AR state
                // available
                QCAR::registerCallback(&qcarUpdate);
                
                // Initialisation is complete, start QCAR
                QCAR::onResume();
                
                if ((delegate != nil) && [delegate respondsToSelector:@selector(qcar_initialised)])
                    [delegate performSelectorOnMainThread:@selector(qcar_initialised) withObject:nil waitUntilDone:YES];
                
                [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
                break;
                
            case APPSTATUS_CAMERA_RUNNING:
                [self startCamera];
                
                if ((delegate != nil) && [delegate respondsToSelector:@selector(qcar_projectionMatrixReady)])
                    [delegate performSelectorOnMainThread:@selector(qcar_projectionMatrixReady) withObject:nil waitUntilDone:YES];
                
                break;
                
            case APPSTATUS_CAMERA_STOPPED:
                [self stopCamera];
                break;
                
            default:
                NSLog(@"updateApplicationStatus: invalid app status");
                break;
        }
    }
    
    if (APPSTATUS_ERROR == ARData.appStatus) {
        // Application initialisation failed, display an alert view
        UIAlertView* alert;
        const char *msgNetwork = "Network connection required to initialize camera "
        "settings. Please check your connection and restart the application.";
        const char *msgDevice = "Failed to initialize QCAR because this device is not supported.";
        const char *msgDefault = "Application initialisation failed.";
        const char *msg = msgDefault;
        
        switch (ARData.errorCode) {
            case QCAR::INIT_CANNOT_DOWNLOAD_DEVICE_SETTINGS:
                msg = msgNetwork;
                break;
            case QCAR::INIT_DEVICE_NOT_SUPPORTED:
                msg = msgDevice;
                break;
            case QCAR::INIT_ERROR:
            default:
                break;
        }
        
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithUTF8String:msg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


////////////////////////////////////////////////////////////////////////////////
// Bump the application status on one step
- (void)bumpAppStatus
{
    [self updateApplicationStatus:(status)(ARData.appStatus + 1)];
}


////////////////////////////////////////////////////////////////////////////////
// Initialise the application
- (void)initApplication
{
    // Get the device screen dimensions
    int w = ofGetWidth();
    int h = ofGetHeight();
    ARData.screenRect = CGRectMake( 0, 0, w, h );
    
    // Inform QCAR that the drawing surface has been created
    QCAR::onSurfaceCreated();
    
    // Inform QCAR that the drawing surface size has changed
    QCAR::onSurfaceChanged(ARData.screenRect.size.width, ARData.screenRect.size.height);
}


////////////////////////////////////////////////////////////////////////////////
// Initialise QCAR [performed on a background thread]
- (void)initQCAR
{
    // Background thread must have its own autorelease pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    QCAR::setInitParameters(ARData.QCARFlags);
    QCAR::setInitParameters( QCAR::ROTATE_IOS_90 );
    
    int nPercentComplete = 0;
    
    do {
        nPercentComplete = QCAR::init();
    } while (0 <= nPercentComplete && 100 > nPercentComplete);
    
    NSLog(@"QCAR::init percent: %d", nPercentComplete);
    
    if (0 > nPercentComplete) {
        ARData.appStatus = APPSTATUS_ERROR;
        ARData.errorCode = nPercentComplete;
    }    
    
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
    [pool release];    
} 


////////////////////////////////////////////////////////////////////////////////
// Initialise the AR parts of the application
- (void)initApplicationAR
{
    // 
}


////////////////////////////////////////////////////////////////////////////////
// Load the tracker data [performed on a background thread]
- (void)loadTracker
{
    static bool trackerLoaded = NO;
    
    if (trackerLoaded == NO)
    {
        int nPercentComplete = 0;
        
        // Background thread must have its own autorelease pool
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        // Load the tracker data
        do {
            nPercentComplete = QCAR::Tracker::getInstance().load();
        } while (0 <= nPercentComplete && 100 > nPercentComplete);
        
        if (0 > nPercentComplete) {
            ARData.appStatus = APPSTATUS_ERROR;
            ARData.errorCode = nPercentComplete;
        }
        
        [pool release];
        
        trackerLoaded = YES;
    }
    
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
}


////////////////////////////////////////////////////////////////////////////////
// Start capturing images from the camera
- (void)startCamera
{
    // Initialise the camera
    if (QCAR::CameraDevice::getInstance().init()) {
        // Configure video background
        [self configureVideoBackground];
        
        // Select the default mode
        if (QCAR::CameraDevice::getInstance().selectVideoMode(QCAR::CameraDevice::MODE_DEFAULT)) {
            // Start camera capturing
            if (QCAR::CameraDevice::getInstance().start()) {
                // Start the tracker
                QCAR::Tracker::getInstance().start();
                
                // Cache the projection matrix
                const QCAR::CameraCalibration& cameraCalibration = QCAR::Tracker::getInstance().getCameraCalibration();
                projectionMatrix = ofMatrix4x4( QCAR::Tool::getProjectionGL(cameraCalibration, 2.0f, 2000.0f).data );
            }
        }
    }
    
    if ((delegate != nil) && [delegate respondsToSelector:@selector(qcar_cameraStarted)])
        [delegate performSelectorOnMainThread:@selector(qcar_cameraStarted) withObject:nil waitUntilDone:YES];
}


////////////////////////////////////////////////////////////////////////////////
// Stop capturing images from the camera
- (void)stopCamera
{
    QCAR::Tracker::getInstance().stop();
    QCAR::CameraDevice::getInstance().stop();
    QCAR::CameraDevice::getInstance().deinit();
    
    if ((delegate != nil) && [delegate respondsToSelector:@selector(qcar_cameraStopped)])
        [delegate performSelectorOnMainThread:@selector(qcar_cameraStopped) withObject:nil waitUntilDone:YES];
}


////////////////////////////////////////////////////////////////////////////////
// Configure the video background
- (void)configureVideoBackground
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    ofRectangle screenRect( 0, 0, ARData.screenRect.size.width, ARData.screenRect.size.height );
    ofRectangle videoRect( 0, 0, videoMode.mHeight, videoMode.mWidth );
    ofRectangle imageRect = cropToSize( videoRect, screenRect );
    imageRect.x = 0;    // qcar positions the camera image in the middle of the screen, so no need to move the image.
    imageRect.y = 0;
    
    scaleX = imageRect.width / (float)screenRect.width;
    scaleY = imageRect.height / (float)screenRect.height;
    
    QCAR::VideoBackgroundConfig config;                                                             //-- configure the video background
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = imageRect.x;
    config.mPosition.data[1] = imageRect.y;
    config.mSize.data[0] = imageRect.width;
    config.mSize.data[1] = imageRect.height;
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}

- (QCAR::Vec2F)cameraPointToScreenPoint:(QCAR::Vec2F)cameraPoint;
{
    QCAR::VideoMode videoMode = QCAR::CameraDevice::getInstance().getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    QCAR::VideoBackgroundConfig config = QCAR::Renderer::getInstance().getVideoBackgroundConfig();
    
    int xOffset = ((int) ofGetWidth()  - config.mSize.data[0]) / 2.0f + config.mPosition.data[0];
    int yOffset = ((int) ofGetHeight() - config.mSize.data[1]) / 2.0f - config.mPosition.data[1];
    
    bool isActivityInPortraitMode = true;
    if( isActivityInPortraitMode )
    {
        // camera image is rotated 90 degrees
        int rotatedX = videoMode.mHeight - cameraPoint.data[1];
        int rotatedY = cameraPoint.data[0];
        
        return QCAR::Vec2F(rotatedX * config.mSize.data[0] / (float) videoMode.mHeight + xOffset,
                           rotatedY * config.mSize.data[1] / (float) videoMode.mWidth + yOffset);
    }
    else
    {
        return QCAR::Vec2F(cameraPoint.data[0] * config.mSize.data[0] / (float) videoMode.mWidth + xOffset,
                           cameraPoint.data[1] * config.mSize.data[1] / (float) videoMode.mHeight + yOffset);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Callback function called by the tracker when each tracking cycle has finished
void QCAR_UpdateCallback::QCAR_onUpdate(QCAR::State& state)
{
    int numTrackables;
    numTrackables = QCAR::Tracker::getInstance().getNumTrackables();
    
    QCAR::Trackable* trackable;
    
    for( int i=0; i<numTrackables; i++ )
    {
        trackable = QCAR::Tracker::getInstance().getTrackable( i );
        if( !trackable )
            continue;

        bool b1, b2;
        b1 = trackable->getStatus() == QCAR::Trackable::DETECTED;
        b2 = trackable->getStatus() == QCAR::Trackable::TRACKED;
        
        if( b1 || b2 )
        {
            [[ ofxQCAR_Utils getInstance ] onUpdate: trackable ];
            return;
        }
    }
    
    // if we get here then no active trackables were found.
    
    if( trackable )
        [[ ofxQCAR_Utils getInstance ] onUpdate: trackable ];
}

@end

#endif
