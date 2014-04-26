/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxQCAR_Utils.h"
#import <QCAR/QCAR.h>
#import <QCAR/QCAR_iOS.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tracker.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ImageTracker.h>
#import <QCAR/MultiTarget.h>
#import <QCAR/MarkerTracker.h>
#import <QCAR/VideoBackgroundConfig.h>

static NSString* const DatasetErrorTitle = @"Dataset Error";

@interface ofxQCAR_Utils()
- (void)updateApplicationStatus:(status)newStatus;
- (void)bumpAppStatus;
- (void)initQCAR;
- (int)initTracker;
- (void)loadTracker;
- (void)startCamera;
- (void)stopCamera;
- (void)configureVideoBackground;
- (void)cameraDidStart;
- (void)cameraDidStop;
@end

static ofxQCAR_Utils *qUtils = nil; // singleton class

#pragma mark --- Class interface for DataSet list ---
@implementation DataSetItem

@synthesize name;
@synthesize path;
@synthesize dataSet;

- (id) initWithName:(NSString *)theName andPath:(NSString *)thePath
{
    self = [super init];
    if (self) {
        name = [theName copy]; // copy retains
        path = [thePath copy]; // copy retains
        dataSet = nil;
    }
    return self;    
}

- (void)dealloc
{
    [name release];
    [path release];
    [super dealloc];
}

@end

#pragma mark --- Class implementation ---

@implementation ofxQCAR_Utils

@synthesize viewSize;
@synthesize delegate;

@synthesize contentScalingFactor;
@synthesize targetsList;
@synthesize QCARFlags;
@synthesize appStatus;
@synthesize errorCode;

@synthesize targetType;
@synthesize viewport;

@synthesize projectionMatrix;

@synthesize config;

@synthesize videoStreamStarted;

@synthesize noOfCameras, activeCamera, cameraTorchOn, cameraContinuousAFOn;

@synthesize isVisualSearchOn,vsAutoControlEnabled, orientationChanged;

@synthesize orientation;

// initialise QCARutils
- (id) init
{
    if ((self = [super init]) != nil)
    {
        currentDataSet = nil;
        contentScalingFactor = 1.0f; // non-Retina is default
        appStatus = APPSTATUS_UNINITED;
        viewSize = [[UIScreen mainScreen] bounds].size; // set as full screen
        
        targetType = TYPE_IMAGETARGETS;
        targetsList = [[NSMutableArray alloc] init];
        
        // Initial camera settings
        cameraTorchOn = NO;
        cameraContinuousAFOn = YES;
        videoStreamStarted = NO;
        // Select the camera to open, set this to QCAR::CameraDevice::CAMERA_FRONT
        // to activate the front camera instead.
        activeCamera = QCAR::CameraDevice::CAMERA_BACK;
        noOfCameras = 1;
    }
    
    return self;
}


// return QCARutils singleton, initing if necessary
+ (ofxQCAR_Utils *) getInstance
{
    if (qUtils == nil)
    {
        qUtils = [[ofxQCAR_Utils alloc] init];
    }
        
    return qUtils;
}


// discard resources
- (void)dealloc {
    if(targetsList != nil) {
        [targetsList release];
        targetsList = nil;
    }
    [super dealloc];
}


- (void)addTargetName:(NSString *)theName atPath:(NSString *)thePath {
    DataSetItem * dataSet = [[DataSetItem alloc] initWithName:theName andPath:thePath];
    if(dataSet == nil) {
        return;
    }
    [targetsList addObject:dataSet];
    [dataSet release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![[alertView title] isEqualToString:DatasetErrorTitle]) {
        exit(0);
    }
}


- (void)restoreCameraSettings
{
    [self cameraSetTorchMode:cameraTorchOn];
    [self cameraSetContinuousAFMode:cameraContinuousAFOn];
}


- (void)cameraSetTorchMode:(BOOL)switchOn
{
    bool switchTorchOn = YES == switchOn ? true : false;
    
    if (true == QCAR::CameraDevice::getInstance().setFlashTorchMode(switchTorchOn))
    {
        cameraTorchOn = switchOn;
    }
}


- (void)cameraSetContinuousAFMode:(BOOL)switchOn
{
    int focusMode = YES == switchOn ? QCAR::CameraDevice::FOCUS_MODE_CONTINUOUSAUTO : QCAR::CameraDevice::FOCUS_MODE_NORMAL;
    
    if (true == QCAR::CameraDevice::getInstance().setFocusMode(focusMode))
    {
        cameraContinuousAFOn = switchOn;
    }
}


- (void)cameraTriggerAF
{
    [self performSelector:@selector(cameraPerformAF) withObject:nil afterDelay:.4];
}


- (void)cameraPerformAF
{
    if (true == QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_TRIGGERAUTO))
    {
        cameraContinuousAFOn = NO;
    }
}


- (void)cameraCancelAF
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cameraPerformAF) object:nil];
}

#pragma mark --- external control of QCAR ---

////////////////////////////////////////////////////////////////////////////////
// create the Augmented Reality context
- (void)createARofSize:(CGSize)theSize forDelegate:(id)theDelegate
{
    NSLog(@"QCARutils onCreate()");
    
    if (appStatus != APPSTATUS_UNINITED)
        return;
    
    // to initialise QCAR we need the view size and a class for optional callbacks
    viewSize = theSize;
    delegate = theDelegate;

    // start the initialisation sequence here...
    [qUtils updateApplicationStatus:APPSTATUS_INIT_APP];
}


////////////////////////////////////////////////////////////////////////////////
// destroy the Augmented Reality context
- (void)destroyAR
{
    NSLog(@"QCARutils onDestroy()");
    
    if(appStatus == APPSTATUS_UNINITED) {
        return;
    }
    
    [self deactivateDataSet:currentDataSet];
    
    if(targetType != TYPE_FRAMEMARKERS) {
        for(DataSetItem * aDataSet in targetsList) {
            [self unloadDataSet:aDataSet.dataSet];
        }
        [targetsList removeAllObjects];
    }
    
    if(userDefDataSet != nil) {
        [self unloadUserDefinedTargets];
    }
    
    QCAR::deinit();
    
    appStatus = APPSTATUS_UNINITED;
}


////////////////////////////////////////////////////////////////////////////////
// pause the camera view and the tracking of targets
- (void)pauseAR
{
    NSLog(@"QCARutils onPause()");
    
    // If the app status is APPSTATUS_CAMERA_RUNNING, QCAR must have been fully
    // initialised
    if (APPSTATUS_CAMERA_RUNNING == qUtils.appStatus) {
        [qUtils updateApplicationStatus:APPSTATUS_CAMERA_STOPPED];
        
        // QCAR-specific pause operation
        QCAR::onPause();
    }
}


////////////////////////////////////////////////////////////////////////////////
// resume the camera view and tracking of targets
- (void)resumeAR
{
    NSLog(@"QCARutils onResume()");
    
    // If the app status is APPSTATUS_CAMERA_STOPPED, QCAR must have been fully
    // initialised
    if (APPSTATUS_CAMERA_STOPPED == qUtils.appStatus) {
        // QCAR-specific resume operation
        QCAR::onResume();
        
        [qUtils updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
    }
}


#pragma mark --- QCAR initialisation ---
////////////////////////////////////////////////////////////////////////////////
- (void)updateApplicationStatus:(status)newStatus
{
    if (newStatus != appStatus && APPSTATUS_ERROR != appStatus) {
        appStatus = newStatus;
        
        switch (appStatus) {
            case APPSTATUS_INIT_APP:
                NSLog(@"APPSTATUS_INIT_APP");
                // Initialise the application
                [self initApplication];
                [self updateApplicationStatus:APPSTATUS_INIT_QCAR];
                break;
                
            case APPSTATUS_INIT_QCAR:
                NSLog(@"APPSTATUS_INIT_QCAR");
                // Initialise QCAR
                [self performSelectorInBackground:@selector(initQCAR) withObject:nil];
                break;
                
            case APPSTATUS_INIT_TRACKER:
                NSLog(@"APPSTATUS_INIT_TRACKER");
                // Initialise the tracker
                if ([self initTracker] > 0) {
                    [self updateApplicationStatus: APPSTATUS_INIT_APP_AR];
                }
                break;
                
            case APPSTATUS_INIT_APP_AR:
                NSLog(@"APPSTATUS_INIT_APP_AR");
                // AR-specific initialisation
                [self initApplicationAR];
                
                // skip the loading of a DataSet for markers
                if (targetType != TYPE_FRAMEMARKERS)
                    [self updateApplicationStatus:APPSTATUS_LOAD_TRACKER];
                else
                    [self updateApplicationStatus:APPSTATUS_INITED];
                break;
                
            case APPSTATUS_LOAD_TRACKER:
                NSLog(@"APPSTATUS_LOAD_TRACKER");
                // Load tracker data
                [self performSelectorInBackground:@selector(loadTracker) withObject:nil];
                
                break;
                
            case APPSTATUS_INITED:
                NSLog(@"APPSTATUS_INITED");
                // Tasks for after QCAR inited but before camera starts running
                QCAR::onResume(); // ensure it's called first time in
                [self postInitQCAR];
                
                [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
                break;
                
            case APPSTATUS_CAMERA_RUNNING:
                NSLog(@"APPSTATUS_CAMERA_RUNNING");
                // Start the camera and tracking
                [self startCamera];
                videoStreamStarted = YES;
                [self cameraDidStart];
                break;
                
            case APPSTATUS_CAMERA_STOPPED:
                NSLog(@"APPSTATUS_CAMERA_STOPPED");
                // Stop the camera and tracking
                [self stopCamera];
                [self cameraDidStop];
                break;
                
            default:
                NSLog(@"updateApplicationStatus: invalid app status");
                break;
        }
    }
    
    if (APPSTATUS_ERROR == appStatus) {
        // Application initialisation failed, display an alert view
        UIAlertView* alert;
        const char *msgDevice = "Failed to initialize QCAR because this device is not supported.";
        const char *msgDefault = "Application initialisation failed.";
        const char* msgNoNetwork = "Failed to initialize Visual Search because the device has no network connection.";
        const char* msgNoService = "Failed to initialize Visual Search because the service is not available.";
        
        const char *msg = msgDefault;
        
        switch (errorCode) {
            case QCAR_ERRCODE_NO_NETWORK_CONNECTION:
                msg = msgNoNetwork;
                break;
            case QCAR_ERRCODE_NO_SERVICE_AVAILABLE:
                msg = msgNoService;
                break;
            case QCAR::INIT_DEVICE_NOT_SUPPORTED:
                msg = msgDevice;
                break;
            case QCAR::INIT_ERROR:
            case QCAR_ERRCODE_INIT_TRACKER:
            case QCAR_ERRCODE_CREATE_DATASET:
            case QCAR_ERRCODE_LOAD_DATASET:
            case QCAR_ERRCODE_ACTIVATE_DATASET:
            case QCAR_ERRCODE_DEACTIVATE_DATASET:
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
    [self updateApplicationStatus:(status)(appStatus + 1)];
}


////////////////////////////////////////////////////////////////////////////////
// Initialise the application
- (void)initApplication
{
    // Inform QCAR that the drawing surface has been created
    QCAR::onSurfaceCreated();
    
    // Invoke optional application initialisation in the delegate class
    if ((delegate != nil) && [delegate respondsToSelector:@selector(initApplication)])
        [delegate performSelectorOnMainThread:@selector(initApplication) withObject:nil waitUntilDone:YES];
}


////////////////////////////////////////////////////////////////////////////////
// Initialise QCAR [performed on a background thread]
- (void)initQCAR
{
    // Background thread must have its own autorelease pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    QCAR::setInitParameters(QCARFlags);
    
    // QCAR::init() will return positive numbers up to 100 as it progresses towards success
    // and negative numbers for error indicators
    NSInteger initSuccess = 0;
    do {
        initSuccess = QCAR::init();
    } while (0 <= initSuccess && 100 > initSuccess);
    
    if (initSuccess != 100) {
        appStatus = APPSTATUS_ERROR;
        errorCode = initSuccess;
    }
    
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
    [pool release];
} 


////////////////////////////////////////////////////////////////////////////////
// Initialise the AR parts of the application
- (void)initApplicationAR
{
    // Invoke optional AR initialisation in the delegate class
    if ((delegate != nil) && [delegate respondsToSelector:@selector(initApplicationAR)])
        [delegate performSelectorOnMainThread:@selector(initApplicationAR) withObject:nil waitUntilDone:YES];
}


//////////////////////////////////////////////////////////////////////////////////
// Initialise the tracker [performed on a background thread]
- (int)initTracker
{
    int res = 0;
    
    // Initialize the image or marker tracker
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();

    if (targetType != TYPE_FRAMEMARKERS)
    {
        // Image Tracker...
        QCAR::Tracker* trackerBase = trackerManager.initTracker(QCAR::ImageTracker::getClassType());
        if (trackerBase == NULL)
        {
            NSLog(@"Failed to initialize ImageTracker.");
        }
        else
        {
            NSLog(@"Successfully initialized ImageTracker.");
            res = 1;
        }
    }
    else
    {
        // Marker Tracker...
        QCAR::Tracker* trackerBase = trackerManager.initTracker(QCAR::ImageTracker::getClassType());
        if (trackerBase == NULL)
        {
            NSLog(@"Failed to initialize MarkerTracker.");
        }
        else
        {
            NSLog(@"Successfully initialized MarkerTracker.");
            
            // Create the markers required
            QCAR::MarkerTracker* markerTracker = static_cast<QCAR::MarkerTracker*>(trackerBase);
            if (markerTracker == NULL)
            {
                NSLog(@"Failed to get MarkerTracker.");
            }
            else
            {
                NSLog(@"Successfully got MarkerTracker.");
                
                // Create frame markers:
                if (!markerTracker->createFrameMarker(0, "MarkerQ", QCAR::Vec2F(50,50)) ||
                    !markerTracker->createFrameMarker(1, "MarkerC", QCAR::Vec2F(50,50)) ||
                    !markerTracker->createFrameMarker(2, "MarkerA", QCAR::Vec2F(50,50)) ||
                    !markerTracker->createFrameMarker(3, "MarkerR", QCAR::Vec2F(50,50)))
                {
                    NSLog(@"Failed to create frame markers.");
                }
                else
                {
                    NSLog(@"Successfully created frame markers.");
                    res = 1;
                }
            }
        }
    }
    
    if (res == 0)
    {
        appStatus = APPSTATUS_ERROR;
        errorCode = QCAR_ERRCODE_INIT_TRACKER;
    }
    
    return res;
}


////////////////////////////////////////////////////////////////////////////////
// Load the tracker data [performed on a background thread]
- (void)loadTracker
{
    // Background thread must have its own autorelease pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    BOOL haveLoadedOneDataSet = NO;
    
    if (targetType != TYPE_FRAMEMARKERS)
    {
        // Load all the requested datasets
        for (DataSetItem *aDataSet in targetsList)
        {
            if (aDataSet.path != nil)
            {
                aDataSet.dataSet = [self loadDataSet:aDataSet.path];
                if (haveLoadedOneDataSet == NO)
                {
                    if (aDataSet.dataSet != nil)
                    {
                        // activate the first one in the list
                        [self activateDataSet:aDataSet.dataSet];
                        haveLoadedOneDataSet = YES;
                    }
                }
            }
        }
        
        // Check that we've loaded at least one target
        if (!haveLoadedOneDataSet)
        {
            NSLog(@"QCARutils: Failed to load any target");
            appStatus = APPSTATUS_ERROR;
            errorCode = QCAR_ERRCODE_LOAD_TARGET;
        }
    }
    
    //------------------------------------------------------------------ create a user defined data set.
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    if(imageTracker != nil) {
        userDefDataSet = imageTracker->createDataSet();
    }
    //------------------------------------------------------------------

    // Continue execution on the main thread
    if (appStatus != APPSTATUS_ERROR)
        [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
    [pool release];
}

////////////////////////////////////////////////////////////////////////////////
// Start capturing images from the camera
- (void)startCamera
{
    // Initialise the camera
    if (QCAR::CameraDevice::getInstance().init(activeCamera)) {
        // Configure video background
        [self configureVideoBackground];
        
        //// Select the default mode - given as example of how and where to set the Camera mode
        //if (QCAR::CameraDevice::getInstance().selectVideoMode(QCAR::CameraDevice::MODE_DEFAULT)) {
        
        // Start camera capturing
        if (QCAR::CameraDevice::getInstance().start()) {
            // Start the tracker
            QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
            QCAR::Tracker* tracker = trackerManager.getTracker(targetType == TYPE_FRAMEMARKERS ?
                                                               QCAR::MarkerTracker::getClassType() :
                                                               QCAR::ImageTracker::getClassType());
            if(tracker != 0)
                tracker->start();
            
            float nearPlane = 2.0f;
            float farPlane = 10000.0f;
            const QCAR::CameraCalibration& cameraCalibration = QCAR::CameraDevice::getInstance().getCameraCalibration();
            projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, nearPlane, farPlane);
        }
        
        // Restore camera settings
        [self restoreCameraSettings];
    }
}


////////////////////////////////////////////////////////////////////////////////
// Stop capturing images from the camera
- (void)stopCamera
{
    // Stop the tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker* tracker = trackerManager.getTracker(targetType == TYPE_FRAMEMARKERS ?
                                                       QCAR::MarkerTracker::getClassType() :
                                                       QCAR::ImageTracker::getClassType());
    if(tracker != 0)
        tracker->stop();
    
    QCAR::CameraDevice::getInstance().stop();
    QCAR::CameraDevice::getInstance().deinit();
}


////////////////////////////////////////////////////////////////////////////////
// Do the things that need doing after initialisation
- (void)postInitQCAR
{
    // Get the device screen dimensions, allowing for hi-res mode
    viewSize.width *= contentScalingFactor; // set by the view initialisation before QCAR initialisation
    viewSize.height *= contentScalingFactor;
    
    // Inform QCAR that the drawing surface size has changed
    QCAR::onSurfaceChanged(viewSize.width, viewSize.height);
    
    // let the delegate handle this if wanted
    if ((delegate != nil) && [delegate respondsToSelector:@selector(postInitQCAR)])
        [delegate performSelectorOnMainThread:@selector(postInitQCAR) withObject:nil waitUntilDone:YES];
}

////////////////////////////////////////////////////////////////////////////////
// Perform actions following the camera starting
- (void)cameraDidStart
{
    // Inform the delegate
    if ((delegate != nil) && [delegate respondsToSelector:@selector(cameraDidStart)]) {
        [delegate performSelectorOnMainThread:@selector(cameraDidStart) withObject:nil waitUntilDone:YES];
    }
}


////////////////////////////////////////////////////////////////////////////////
// Perform actions following the camera stopping
- (void)cameraDidStop
{
    // Inform the delegate
    if ((delegate != nil) && [delegate respondsToSelector:@selector(cameraDidStop)]) {
        [delegate performSelectorOnMainThread:@selector(cameraDidStop) withObject:nil waitUntilDone:YES];
    }
}


////////////////////////////////////////////////////////////////////////////////
// Configure the video background
- (void)configureVideoBackground
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    
    BOOL bOrientationLandscape = (viewSize.width > viewSize.height);
    
    // Compare aspect ratios of video and screen.  If they are different
    // we use the full screen size while maintaining the video's aspect
    // ratio, which naturally entails some cropping of the video.
    // Note - screenRect is portrait but videoMode is always landscape,
    // which is why "width" and "height" appear to be reversed.
    float arVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
    float arScreen = viewSize.height / viewSize.width;
    if(bOrientationLandscape) {
        arScreen = viewSize.width / viewSize.height;
    }
    
    if (arVideo > arScreen)
    {
        // Video mode is wider than the screen.  We'll crop the left and right edges of the video
        if(bOrientationLandscape) {
            config.mSize.data[0] = (int)viewSize.height * arVideo;
            config.mSize.data[1] = (int)viewSize.height;
        } else {
            config.mSize.data[0] = (int)viewSize.width;
            config.mSize.data[1] = (int)viewSize.width * arVideo;
        }
    }
    else
    {
        // Video mode is taller than the screen.  We'll crop the top and bottom edges of the video.
        // Also used when aspect ratios match (no cropping).
        if(bOrientationLandscape) {
            config.mSize.data[0] = (int)viewSize.width;
            config.mSize.data[1] = (int)viewSize.width / arVideo;
        } else {
            config.mSize.data[0] = (int)viewSize.height / arVideo;
            config.mSize.data[1] = (int)viewSize.height;
        }
    }
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}


#pragma mark --- configuration methods ---
////////////////////////////////////////////////////////////////////////////////
// Load and Unload Data Set

- (BOOL)unloadDataSet:(QCAR::DataSet *)theDataSet
{
    BOOL success = NO;
    
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (imageTracker == NULL)
    {
        NSLog(@"Failed to unload tracking data set because the ImageTracker has not been initialized.");
        errorCode = QCAR_ERRCODE_INIT_TRACKER;
    }
    else
    {
        // If activated deactivate the data set:
        if ((theDataSet == currentDataSet) && ![self deactivateDataSet:theDataSet])
        {
            NSLog(@"Failed to deactivate data set.");
            errorCode = QCAR_ERRCODE_DEACTIVATE_DATASET;
        }
        else
        {
            if (!imageTracker->destroyDataSet(theDataSet))
            {
                NSLog(@"Failed to destroy data set.");
                errorCode = QCAR_ERRCODE_DESTROY_DATASET;
            }
            else
            {
                NSLog(@"Successfully unloaded data set.");
                success = YES;
            }
        }
    }
    
    currentDataSet = nil;
    
    return success;
}

- (QCAR::DataSet *)loadDataSet:(NSString *)dataSetPath
{
    QCAR::DataSet *theDataSet = nil;
    
    const char* msg;
    const char* msgNotInit = "Failed to load tracking data set because the ImageTracker has not been initialized.";
    const char* msgFailedToCreate = "Failed to create a new tracking data.";
    const char* msgFailedToLoad = "Failed to load data set.";
    
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (imageTracker == NULL)
    {
        msg = msgNotInit;
        errorCode = QCAR_ERRCODE_INIT_TRACKER;
    }
    else
    {
        // Create the data sets:
        theDataSet = imageTracker->createDataSet();
        if (theDataSet == nil)
        {
            msg = msgFailedToCreate;
            errorCode = QCAR_ERRCODE_CREATE_DATASET;
        }
        else
        {
            // Load the data set from the App Bundle
            // If the DataSet were in the Documents folder we'd use STORAGE_ABSOLUTE and the full path
            if (!theDataSet->load([dataSetPath cStringUsingEncoding:NSASCIIStringEncoding], QCAR::DataSet::STORAGE_APPRESOURCE))
            {
                msg = msgFailedToLoad;
                errorCode = QCAR_ERRCODE_LOAD_DATASET;
                imageTracker->destroyDataSet(theDataSet);
                theDataSet = nil;
            }
            else
            {
                NSLog(@"Successfully loaded data set.");
            }
        }
    }
    
    if (theDataSet == nil)
    {
        NSString* nsMsg = [NSString stringWithUTF8String:msg];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:DatasetErrorTitle message:nsMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        NSLog(@"%@", nsMsg);
        [alert show];
        [alert release];
    }
    
    return theDataSet;
}

- (QCAR::DataSet *)getDefaultDataSet {
    if([targetsList count] == 0) {
        return nil;
    }
    
    DataSetItem * dataSetItem = [targetsList objectAtIndex:0];
    return dataSetItem.dataSet;
}

- (QCAR::DataSet *)getUserDefDataSet {
    return userDefDataSet;
}

- (BOOL)deactivateDataSet:(QCAR::DataSet *)theDataSet
{
    if ((currentDataSet == nil) || (theDataSet != currentDataSet))
    {
        NSLog(@"Invalid request to deactivate data set.");
        errorCode = QCAR_ERRCODE_DEACTIVATE_DATASET;
        return NO;
    }
    
    BOOL success = NO;
    
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (imageTracker == NULL)
    {
        NSLog(@"Failed to unload tracking data set because the ImageTracker has not been initialized.");
        errorCode = QCAR_ERRCODE_INIT_TRACKER;
    }
    else
    {
        // Activate the data set:
        if (!imageTracker->deactivateDataSet(theDataSet))
        {
            NSLog(@"Failed to deactivate data set.");
            errorCode = QCAR_ERRCODE_DEACTIVATE_DATASET;
        }
        else
        {
            success = YES;
        }
    }
    
    currentDataSet = nil;
    
    return success;
}


- (BOOL)activateDataSet:(QCAR::DataSet *)theDataSet
{
    // if we've previously recorded an activation, deactivate it
    if (currentDataSet != nil)
    {
        [self deactivateDataSet:currentDataSet];
    }
    BOOL success = NO;
    
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    
    if (imageTracker == NULL) {
        NSLog(@"Failed to load tracking data set because the ImageTracker has not been initialized.");
        errorCode = QCAR_ERRCODE_INIT_TRACKER;
    }
    else
    {
        // Activate the data set:
        if (!imageTracker->activateDataSet(theDataSet))
        {
            NSLog(@"Failed to activate data set.");
            errorCode = QCAR_ERRCODE_ACTIVATE_DATASET;
        }
        else
        {
            NSLog(@"Successfully activated data set.");
            currentDataSet = theDataSet;
            success = YES;
        }
    }
    
    return success;
}



- (void) allowDataSetModification
{
    QCAR::ImageTracker* it = reinterpret_cast<QCAR::ImageTracker*>(QCAR::TrackerManager::getInstance().getTracker(QCAR::ImageTracker::getClassType()));
    
    // Deactivate the data set prior to reconfiguration:
    it->deactivateDataSet(currentDataSet);
}


- (void) saveDataSetModifications
{
    QCAR::ImageTracker* it = reinterpret_cast<QCAR::ImageTracker*>(QCAR::TrackerManager::getInstance().getTracker(QCAR::ImageTracker::getClassType()));
    
    // Deactivate the data set prior to reconfiguration:
    it->activateDataSet(currentDataSet);
}

- (void)unloadUserDefinedTargets {
    BOOL success = NO;
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = static_cast<QCAR::ImageTracker*>(trackerManager.getTracker(QCAR::ImageTracker::getClassType()));
    if (imageTracker == NULL)
    {
        NSLog(@"Failed to destroy the tracking data set because the ImageTracker has not been initialized.");
        errorCode = QCAR_ERRCODE_INIT_TRACKER;
    }
    
    if (userDefDataSet != 0)
    {
        if (imageTracker->getActiveDataSet() && !imageTracker->deactivateDataSet(userDefDataSet))
        {
            NSLog(@"Failed to destroy the tracking data set because the data set could not be deactivated.");
            errorCode = QCAR_ERRCODE_DEACTIVATE_DATASET;
        }
        else
        {
            if (!imageTracker->destroyDataSet(userDefDataSet))
            {
                NSLog(@"Failed to destroy the tracking data set.");
                
            }
            else
            {
                NSLog(@"Successfully destroyed the data set.");
                
                success = YES;
            }
        }
    }
    
    userDefDataSet = nil;
}


#pragma mark --- target utilities ---
////////////////////////////////////////////////////////////////////////////////
// Target Utility methods


// In the current loaded data set, find the named target

- (QCAR::ImageTarget *) findImageTarget:(const char *) name
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = (QCAR::ImageTracker*)
    trackerManager.getTracker(QCAR::ImageTracker::getClassType());
    
    if (imageTracker != nil || currentDataSet == nil)
    {
        for(int i=0; i<currentDataSet->getNumTrackables(); i++)
        {
            if(currentDataSet->getTrackable(i)->isOfType(QCAR::ImageTarget::getClassType()))
            {
                if(!strcmp(currentDataSet->getTrackable(i)->getName(),name))
                    return reinterpret_cast<QCAR::ImageTarget*>(currentDataSet->getTrackable(i));
            }
        }
    }
    return NULL;
}


// See if there's a multi-target in the current data set

- (QCAR::MultiTarget *) findMultiTarget
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ImageTracker* imageTracker = (QCAR::ImageTracker*)
    trackerManager.getTracker(QCAR::ImageTracker::getClassType());
    QCAR::MultiTarget *mit = NULL;
    
    if (imageTracker == nil || currentDataSet == nil)
        return NULL;
    
    // Go through all Trackables to find the MultiTarget instance
    //
    for(int i=0; i<currentDataSet->getNumTrackables(); i++)
    {
        if(currentDataSet->getTrackable(i)->isOfType(QCAR::MultiTarget::getClassType()))
        {
            NSLog(@"MultiTarget exists -> no need to create one");
            mit = reinterpret_cast<QCAR::MultiTarget*>(currentDataSet->getTrackable(i));
            break;
        }
    }
    
    // If no MultiTarget was found, then let's create one.
    if(mit==NULL)
    {
        NSLog(@"No MultiTarget found -> creating one");
        mit = currentDataSet->createMultiTarget("FlakesBox");
        
        if(mit==NULL)
        {
            NSLog(@"ERROR: Failed to create the MultiTarget - probably the Tracker is running");
        }
    }
    
    return mit;
}


// get the Nth trackable in the data set

- (QCAR::ImageTarget *) getImageTarget:(int)itemNo
{
    assert(currentDataSet->getNumTrackables() > 0);
    
    if (currentDataSet->getNumTrackables() > itemNo)
    {
        QCAR::Trackable* trackable = currentDataSet->getTrackable(itemNo);
        
        assert(trackable);
        assert(trackable->getType().isOfType(QCAR::ImageTarget::getClassType()));
        return static_cast<QCAR::ImageTarget*>(trackable);
    }
    
    return NULL;
}

@end

#endif
