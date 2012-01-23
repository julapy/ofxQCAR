//
//  ofxQCAR_Utils.m
//  emptyExample
//
//  Created by lukasz karluk on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR_Utils.h"
#import "ofMain.h"

#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>

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
@end

////////////////////////////////////////////////////////////////////////////////
@implementation ofxQCAR_Utils

- (id) init
{
    if( ( self = [ super init ] ) )
    {
#ifdef USE_OPENGL1
        ARData.QCARFlags = QCAR::GL_11;
#else
        ARData.QCARFlags = QCAR::GL_20;
#endif
        
        NSLog(@"QCAR OpenGL flag: %d", ARData.QCARFlags);
    }
    
    return self;
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
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
                
                // Initialisation is complete, start QCAR
                QCAR::onResume();
                
                [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
                break;
                
            case APPSTATUS_CAMERA_RUNNING:
                [self startCamera];
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
    ARData.screenRect = [[UIScreen mainScreen] bounds];
    
    // Inform QCAR that the drawing surface has been created
    QCAR::onSurfaceCreated();
    
    // Inform QCAR that the drawing surface size has changed
    QCAR::onSurfaceChanged(ARData.screenRect.size.height, ARData.screenRect.size.width);
}


////////////////////////////////////////////////////////////////////////////////
// Initialise QCAR [performed on a background thread]
- (void)initQCAR
{
    // Background thread must have its own autorelease pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    QCAR::setInitParameters(ARData.QCARFlags);
    
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
    
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
    [pool release];
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
                projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, 2.0f, 2000.0f);
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Stop capturing images from the camera
- (void)stopCamera
{
    QCAR::Tracker::getInstance().stop();
    QCAR::CameraDevice::getInstance().stop();
    QCAR::CameraDevice::getInstance().deinit();
}


////////////////////////////////////////////////////////////////////////////////
// Configure the video background
- (void)configureVideoBackground
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    
    // Compare aspect ratios of video and screen.  If they are different
    // we use the full screen size while maintaining the video's aspect
    // ratio, which naturally entails some cropping of the video.
    // Note - screenRect is portrait but videoMode is always landscape,
    // which is why "width" and "height" appear to be reversed.
    float arVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
    float arScreen = ARData.screenRect.size.height / ARData.screenRect.size.width;
    
    if (arVideo > arScreen)
    {
        // Video mode is wider than the screen.  We'll crop the left and right edges of the video
        config.mSize.data[0] = (int)ARData.screenRect.size.width * arVideo;
        config.mSize.data[1] = (int)ARData.screenRect.size.width;
    }
    else
    {
        // Video mode is taller than the screen.  We'll crop the top and bottom edges of the video.
        // Also used when aspect ratios match (no cropping).
        config.mSize.data[0] = (int)ARData.screenRect.size.height;
        config.mSize.data[1] = (int)ARData.screenRect.size.height / arVideo;
    }
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}

@end
