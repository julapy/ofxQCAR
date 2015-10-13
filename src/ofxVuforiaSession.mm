/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxVuforiaSession.h"
#import <QCAR/QCAR.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/Tool.h>
#import <QCAR/Renderer.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/UpdateCallback.h>

namespace {
    // --- Data private to this unit ---
    
    // instance of the seesion
    // used to support the QCAR callback
    // there should be only one instance of a session
    // at any given point of time
    ofxVuforiaSession* instance = nil;
    
    // QCAR initialisation flags (passed to QCAR before initialising)
    int mQCARInitFlags;
    
    // camera to use for the session
    QCAR::CameraDevice::CAMERA mCamera = QCAR::CameraDevice::CAMERA_DEFAULT;
    
    // class used to support the QCAR callback mechanism
    class VuforiaApplication_UpdateCallback : public QCAR::UpdateCallback {
        virtual void QCAR_onUpdate(QCAR::State& state);
    } qcarUpdate;

    // NSerror domain for errors coming from the Sample application template classes
    NSString * SAMPLE_APPLICATION_ERROR_DOMAIN = @"vuforia_sample_application";
}

@interface ofxVuforiaSession ()

@property (nonatomic, retain) NSString * licenseKey;
@property (nonatomic, readwrite) CGSize mARViewBoundsSize;
@property (nonatomic, readwrite) UIInterfaceOrientation mARViewOrientation;
@property (nonatomic, readwrite) BOOL mIsActivityInPortraitMode;
@property (nonatomic, readwrite) BOOL cameraIsActive;

// ofxVuforiaSessionDelegate delegate (receives callbacks in response to particular
// events, such as completion of Vuforia initialisation)
@property (nonatomic, assign) id delegate;

@end


@implementation ofxVuforiaSession
@synthesize viewport;

- (id)initWithDelegate:(id<ofxVuforiaSessionDelegate>) delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        // we keep a reference of the instance in order to implemet the QCAR callback
        instance = self;
    }
    return self;
}

- (void)dealloc
{
    instance = nil;
    [self setDelegate:nil];
    [super dealloc];
}

// build a NSError
- (NSError *) NSErrorWithCode:(int) code {
    return [NSError errorWithDomain:SAMPLE_APPLICATION_ERROR_DOMAIN code:code userInfo:nil];
}

- (NSError *) NSErrorWithCode:(NSString *) description code:(NSInteger)code{
    NSDictionary *userInfo = @{
                           NSLocalizedDescriptionKey: description
                           };
    return [NSError errorWithDomain:SAMPLE_APPLICATION_ERROR_DOMAIN
                                     code:code
                                 userInfo:userInfo];
}

- (void) NSErrorWithCode:(int) code error:(NSError **) error{
    if (error != NULL) {
        *error = [self NSErrorWithCode:code];
    }
}

// Determine whether the device has a retina display
- (BOOL)isRetinaDisplay
{
    // If UIScreen mainScreen responds to selector
    // displayLinkWithTarget:selector: and the scale property is 2.0, then this
    // is a retina display
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && 2.0 == [UIScreen mainScreen].scale);
}

// Initialize the Vuforia SDK
- (void) initAR:(int) QCARInitFlags
     boundsSize:(CGSize) ARViewBoundsSize
    orientation:(UIInterfaceOrientation) ARViewOrientation
     licenseKey:(NSString *) AppLicenseKey {

    self.cameraIsActive = NO;
    self.cameraIsStarted = NO;
    mQCARInitFlags = QCARInitFlags;
    self.isRetinaDisplay = [self isRetinaDisplay];
    self.mARViewOrientation = ARViewOrientation;
    self.licenseKey = AppLicenseKey;

    // If this device has a retina display, we expect the view bounds to
    // have been scaled up by a factor of 2; this allows it to calculate the size and position of
    // the viewport correctly when rendering the video background
    // The ARViewBoundsSize is the dimension of the AR view as seen in portrait, even if the orientation is landscape
    self.mARViewBoundsSize = ARViewBoundsSize;
    
    // Initialising QCAR is a potentially lengthy operation, so perform it on a
    // background thread
    [self performSelectorInBackground:@selector(initQCARInBackground) withObject:nil];
}

// Initialise QCAR
// (Performed on a background thread)
- (void)initQCARInBackground
{
    // Background thread must have its own autorelease pool
    @autoreleasepool {
        QCAR::setInitParameters(mQCARInitFlags, [self.licenseKey UTF8String]);
        
        // QCAR::init() will return positive numbers up to 100 as it progresses
        // towards success.  Negative numbers indicate error conditions
        NSInteger initSuccess = 0;
        do {
            initSuccess = QCAR::init();
        } while (0 <= initSuccess && 100 > initSuccess);
        
        if (100 == initSuccess) {
            // We can now continue the initialization of Vuforia
            // (on the main thread)
            [self performSelectorOnMainThread:@selector(prepareAR) withObject:nil waitUntilDone:NO];
        }
        else {
            // Failed to initialise QCAR:
            if (QCAR::INIT_NO_CAMERA_ACCESS == initSuccess) {
                // On devices running iOS 8+, the user is required to explicitly grant
                // camera access to an App.
                // If camera access is denied, QCAR::init will return
                // QCAR::INIT_NO_CAMERA_ACCESS.
                // This case should be handled gracefully, e.g.
                // by warning and instructing the user on how
                // to restore the camera access for this app
                // via Device Settings > Privacy > Camera
                [self performSelectorOnMainThread:@selector(showCameraAccessWarning) withObject:nil waitUntilDone:YES];
            }
            else {
                NSError * error;
                switch(initSuccess) {
                    case QCAR::INIT_LICENSE_ERROR_NO_NETWORK_TRANSIENT:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_LICENSE_ERROR_NO_NETWORK_TRANSIENT", nil) code:initSuccess];
                        break;
                        
                    case QCAR::INIT_LICENSE_ERROR_NO_NETWORK_PERMANENT:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_LICENSE_ERROR_NO_NETWORK_PERMANENT", nil) code:initSuccess];
                        break;
                        
                    case QCAR::INIT_LICENSE_ERROR_INVALID_KEY:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_LICENSE_ERROR_INVALID_KEY", nil) code:initSuccess];
                        break;
                        
                    case QCAR::INIT_LICENSE_ERROR_CANCELED_KEY:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_LICENSE_ERROR_CANCELED_KEY", nil) code:initSuccess];
                        break;
                        
                    case QCAR::INIT_LICENSE_ERROR_MISSING_KEY:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_LICENSE_ERROR_MISSING_KEY", nil) code:initSuccess];
                        break;
                        
                    case QCAR::INIT_LICENSE_ERROR_PRODUCT_TYPE_MISMATCH:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_LICENSE_ERROR_PRODUCT_TYPE_MISMATCH", nil) code:initSuccess];
                        break;
                        
                    default:
                        error = [self NSErrorWithCode:NSLocalizedString(@"INIT_default", nil) code:initSuccess];
                        break;
                        
                }
                // QCAR initialization error
                [self.delegate onInitARDone:error];
            }
        }
    }
}

// Prompts a dialog to warn the user that
// the camera access was not granted to this App and
// to provide instructions on how to restore it.
-(void) showCameraAccessWarning
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *message = [NSString stringWithFormat:@"User denied camera access to this App. To restore camera access, go to: \nSettings > Privacy > Camera > %@ and turn it ON.", appName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iOS8 Camera Access Warning" message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
}

// Quit App when user dismisses the camera access alert dialog
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"iOS8 Camera Access Warning"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDismissAppViewController" object:nil];
    }
}

// Resume QCAR
- (bool) resumeAR:(NSError **)error {
    QCAR::onResume();
    
    // if the camera was previously started, but not currently active, then
    // we restart it
    if ((self.cameraIsStarted) && (! self.cameraIsActive)) {
        
        // initialize the camera
        if (! QCAR::CameraDevice::getInstance().init(mCamera)) {
            [self NSErrorWithCode:E_INITIALIZING_CAMERA error:error];
            return NO;
        }
        
        // start the camera
        if (!QCAR::CameraDevice::getInstance().start()) {
            [self NSErrorWithCode:E_STARTING_CAMERA error:error];
            return NO;
        }
        
        self.cameraIsActive = YES;

        // ask the application to start the tracker(s)
        if(! [self.delegate doStartTrackers] ) {
            [self NSErrorWithCode:-1 error:error];
            return NO;
        }
    }
    return YES;
}


// Pause QCAR
- (bool)pauseAR:(NSError **)error {
    if (self.cameraIsActive) {
        // Stop and deinit the camera
        if(! QCAR::CameraDevice::getInstance().stop()) {
            [self NSErrorWithCode:E_STOPPING_CAMERA error:error];
            return NO;
        }
        if(! QCAR::CameraDevice::getInstance().deinit()) {
            [self NSErrorWithCode:E_DEINIT_CAMERA error:error];
            return NO;
        }
        self.cameraIsActive = NO;

        // Stop the trackers
        if(! [self.delegate doStopTrackers]) {
            [self NSErrorWithCode:E_STOPPING_TRACKERS error:error];
            return NO;
        }
    }
    QCAR::onPause();
    return YES;
}

- (void) QCAR_onUpdate:(QCAR::State *) state {
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(onQCARUpdate:)]) {
        [self.delegate onQCARUpdate:state];
    }
}

- (void) prepareAR  {
    // we register for the callback
    QCAR::registerCallback(&qcarUpdate);

    // Tell QCAR we've created a drawing surface
    QCAR::onSurfaceCreated();
    
    
    // Frames from the camera are always landscape, no matter what the
    // orientation of the device.  Tell QCAR to rotate the video background (and
    // the projection matrix it provides to us for rendering our augmentation)
    // by the proper angle in order to match the EAGLView orientation
    if (self.mARViewOrientation == UIInterfaceOrientationPortrait)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.width, self.mARViewBoundsSize.height);
        QCAR::setRotation(QCAR::ROTATE_IOS_90);
        
        self.mIsActivityInPortraitMode = YES;
    }
    else if (self.mARViewOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.width, self.mARViewBoundsSize.height);
        QCAR::setRotation(QCAR::ROTATE_IOS_270);
        
        self.mIsActivityInPortraitMode = YES;
    }
    else if (self.mARViewOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.height, self.mARViewBoundsSize.width);
        QCAR::setRotation(QCAR::ROTATE_IOS_180);
        
        self.mIsActivityInPortraitMode = NO;
    }
    else if (self.mARViewOrientation == UIInterfaceOrientationLandscapeRight)
    {
        QCAR::onSurfaceChanged(self.mARViewBoundsSize.height, self.mARViewBoundsSize.width);
        QCAR::setRotation(1);
        
        self.mIsActivityInPortraitMode = NO;
    }
    

    [self initTracker];
}

- (void) initTracker {
    // ask the application to initialize its trackers
    if (! [self.delegate doInitTrackers]) {
        [self.delegate onInitARDone:[self NSErrorWithCode:E_INIT_TRACKERS]];
        return;
    }
    [self loadTrackerData];
}


- (void) loadTrackerData {
    // Loading tracker data is a potentially lengthy operation, so perform it on
    // a background thread
    [self performSelectorInBackground:@selector(loadTrackerDataInBackground) withObject:nil];
    
}

// *** Performed on a background thread ***
- (void)loadTrackerDataInBackground
{
    // Background thread must have its own autorelease pool
    @autoreleasepool {
        // the application can now prepare the loading of the data
        if(! [self.delegate doLoadTrackersData]) {
            [self.delegate onInitARDone:[self NSErrorWithCode:E_LOADING_TRACKERS_DATA]];
            return;
        }
    }
    
    [self.delegate onInitARDone:nil];
}

// Configure QCAR with the video background size
- (void)configureVideoBackgroundWithViewWidth:(float)viewWidth andHeight:(float)viewHeight
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    
    // Determine the orientation of the view.  Note, this simple test assumes
    // that a view is portrait if its height is greater than its width.  This is
    // not always true: it is perfectly reasonable for a view with portrait
    // orientation to be wider than it is high.  The test is suitable for the
    // dimensions used in this sample
    if (self.mIsActivityInPortraitMode) {
        // --- View is portrait ---
        
        // Compare aspect ratios of video and screen.  If they are different we
        // use the full screen size while maintaining the video's aspect ratio,
        // which naturally entails some cropping of the video
        float aspectRatioVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
        float aspectRatioView = viewHeight / viewWidth;
        
        if (aspectRatioVideo < aspectRatioView) {
            // Video (when rotated) is wider than the view: crop left and right
            // (top and bottom of video)
            
            // --============--
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // - =          = _
            // --============--
            
            config.mSize.data[0] = (int)videoMode.mHeight * (viewHeight / (float)videoMode.mWidth);
            config.mSize.data[1] = (int)viewHeight;
        }
        else {
            // Video (when rotated) is narrower than the view: crop top and
            // bottom (left and right of video).  Also used when aspect ratios
            // match (no cropping)
            
            // ------------
            // -          -
            // -          -
            // ============
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // =          =
            // ============
            // -          -
            // -          -
            // ------------
            
            config.mSize.data[0] = (int)viewWidth;
            config.mSize.data[1] = (int)videoMode.mWidth * (viewWidth / (float)videoMode.mHeight);
        }
    }
    else {
        // --- View is landscape ---
        float temp = viewWidth;
        viewWidth = viewHeight;
        viewHeight = temp;
        
        // Compare aspect ratios of video and screen.  If they are different we
        // use the full screen size while maintaining the video's aspect ratio,
        // which naturally entails some cropping of the video
        float aspectRatioVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
        float aspectRatioView = viewWidth / viewHeight;
        
        if (aspectRatioVideo < aspectRatioView) {
            // Video is taller than the view: crop top and bottom
            
            // --------------------
            // ====================
            // =                  =
            // =                  =
            // =                  =
            // =                  =
            // ====================
            // --------------------
            
            config.mSize.data[0] = (int)viewWidth;
            config.mSize.data[1] = (int)videoMode.mHeight * (viewWidth / (float)videoMode.mWidth);
        }
        else {
            // Video is wider than the view: crop left and right.  Also used
            // when aspect ratios match (no cropping)
            
            // ---====================---
            // -  =                  =  -
            // -  =                  =  -
            // -  =                  =  -
            // -  =                  =  -
            // ---====================---
            
            config.mSize.data[0] = (int)videoMode.mWidth * (viewHeight / (float)videoMode.mHeight);
            config.mSize.data[1] = (int)viewHeight;
        }
    }
    
    // Calculate the viewport for the app to use when rendering
    viewport.posX = ((viewWidth - config.mSize.data[0]) / 2) + config.mPosition.data[0];
    viewport.posY = (((int)(viewHeight - config.mSize.data[1])) / (int) 2) + config.mPosition.data[1];
    viewport.sizeX = config.mSize.data[0];
    viewport.sizeY = config.mSize.data[1];
 
#ifdef DEBUG_SAMPLE_APP
    NSLog(@"VideoBackgroundConfig: size: %d,%d", config.mSize.data[0], config.mSize.data[1]);
    NSLog(@"VideoMode:w=%d h=%d", videoMode.mWidth, videoMode.mHeight);
    NSLog(@"width=%7.3f height=%7.3f", viewWidth, viewHeight);
    NSLog(@"ViewPort: X,Y: %d,%d Size X,Y:%d,%d", viewport.posX,viewport.posY,viewport.sizeX,viewport.sizeY);
#endif
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}

// Start QCAR camera with the specified view size
- (bool)startCamera:(QCAR::CameraDevice::CAMERA)camera viewWidth:(float)viewWidth andHeight:(float)viewHeight error:(NSError **)error
{
    // initialize the camera
    if (! QCAR::CameraDevice::getInstance().init(camera)) {
        [self NSErrorWithCode:-1 error:error];
        return NO;
    }
    
    // select the default video mode
    if(! QCAR::CameraDevice::getInstance().selectVideoMode(QCAR::CameraDevice::MODE_DEFAULT)) {
        [self NSErrorWithCode:-1 error:error];
        return NO;
    }
    
    // start the camera
    if (!QCAR::CameraDevice::getInstance().start()) {
        [self NSErrorWithCode:-1 error:error];
        return NO;
    }
    
    // we keep track of the current camera to restart this
    // camera when the application comes back to the foreground
    mCamera = camera;
    
    // ask the application to start the tracker(s)
    if(! [self.delegate doStartTrackers] ) {
        [self NSErrorWithCode:-1 error:error];
        return NO;
    }
    
    // configure QCAR video background
    [self configureVideoBackgroundWithViewWidth:viewWidth andHeight:viewHeight];
    
    // Cache the projection matrix
    const QCAR::CameraCalibration& cameraCalibration = QCAR::CameraDevice::getInstance().getCameraCalibration();
    
    // NOTE!
    // the original code from the Vuforia example,
    // has the GL projection near and far clipping values at >> 2.0f, 5000.0f
    // but this was causing the model triangles to flicker.
    // by increasing the near clipping to a larger value, this prevents the flickering behaviour.
    
    _projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, 100.0f, 10000.0f);
    return YES;
}


- (bool) startAR:(QCAR::CameraDevice::CAMERA)camera error:(NSError **)error {
    // Start the camera.  This causes QCAR to locate our EAGLView in the view
    // hierarchy, start a render thread, and then call renderFrameQCAR on the
    // view periodically
    if (! [self startCamera: camera viewWidth:self.mARViewBoundsSize.width andHeight:self.mARViewBoundsSize.height error:error]) {
        return NO;
    }
    self.cameraIsActive = YES;
    self.cameraIsStarted = YES;

    return YES;
}

// Stop QCAR camera
- (bool)stopAR:(NSError **)error {
    // Stop the camera
    if (self.cameraIsActive) {
        // Stop and deinit the camera
        QCAR::CameraDevice::getInstance().stop();
        QCAR::CameraDevice::getInstance().deinit();
        self.cameraIsActive = NO;
    }
    self.cameraIsStarted = NO;

    // ask the application to stop the trackers
    if(! [self.delegate doStopTrackers]) {
        [self NSErrorWithCode:E_STOPPING_TRACKERS error:error];
        return NO;
    }
    
    // ask the application to unload the data associated to the trackers
    if(! [self.delegate doUnloadTrackersData]) {
        [self NSErrorWithCode:E_UNLOADING_TRACKERS_DATA error:error];
        return NO;
    }
    
    // ask the application to deinit the trackers
    if(! [self.delegate doDeinitTrackers]) {
        [self NSErrorWithCode:E_DEINIT_TRACKERS error:error];
        return NO;
    }
    
    // Pause and deinitialise QCAR
    QCAR::onPause();
    QCAR::deinit();
    
    return YES;
}

// stop the camera
- (bool) stopCamera:(NSError **)error {
    if (self.cameraIsActive) {
        // Stop and deinit the camera
        QCAR::CameraDevice::getInstance().stop();
        QCAR::CameraDevice::getInstance().deinit();
        self.cameraIsActive = NO;
    } else {
        [self NSErrorWithCode:E_CAMERA_NOT_STARTED error:error];
        return NO;
    }
    self.cameraIsStarted = NO;
    
    // Stop the trackers
    if(! [self.delegate doStopTrackers]) {
        [self NSErrorWithCode:E_STOPPING_TRACKERS error:error];
        return NO;
    }

    return YES;
}

- (void) errorMessage:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SAMPLE_APPLICATION_ERROR_DOMAIN
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

////////////////////////////////////////////////////////////////////////////////
// Callback function called by the tracker when each tracking cycle has finished
void VuforiaApplication_UpdateCallback::QCAR_onUpdate(QCAR::State& state)
{
    if (instance != nil) {
        [instance QCAR_onUpdate:&state];
    }
}

@end

#endif
