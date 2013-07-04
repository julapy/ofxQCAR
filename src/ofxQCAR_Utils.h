/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#if !(TARGET_IPHONE_SIMULATOR)

#import <Foundation/Foundation.h>
#import <QCAR/Tool.h>
#import <QCAR/DataSet.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/TrackableResult.h>
#import <QCAR/VideoBackgroundConfig.h>

// Target type - used by the app to tell QCAR its intent
typedef enum typeOfTarget {
    TYPE_IMAGETARGETS,
    TYPE_MULTITARGETS,
    TYPE_FRAMEMARKERS
} TargetType;

// Application status - used by QCAR initialisation
typedef enum _status {
    APPSTATUS_UNINITED,
    APPSTATUS_INIT_APP,
    APPSTATUS_INIT_QCAR,
    APPSTATUS_INIT_TRACKER,
    APPSTATUS_INIT_APP_AR,
    APPSTATUS_LOAD_TRACKER,
    APPSTATUS_INITED,
    APPSTATUS_CAMERA_STOPPED,
    APPSTATUS_CAMERA_RUNNING,
    APPSTATUS_ERROR
} status;

// Local error codes - offset by -1000 to allow for QCAR::init() error codes in QCAR.h
enum _errorCode {
    QCAR_ERRCODE_INIT_TRACKER = -1000,
    QCAR_ERRCODE_CREATE_DATASET = -1001,
    QCAR_ERRCODE_LOAD_DATASET = -1002,
    QCAR_ERRCODE_ACTIVATE_DATASET = -1003,
    QCAR_ERRCODE_DEACTIVATE_DATASET = -1004,
    QCAR_ERRCODE_DESTROY_DATASET = -1005,
    QCAR_ERRCODE_LOAD_TARGET = -1006,
    QCAR_ERRCODE_NO_NETWORK_CONNECTION = -1007,
    QCAR_ERRCODE_NO_SERVICE_AVAILABLE = -1008
};

#pragma mark --- Class interface for DataSet list ---
@interface DataSetItem : NSObject
{
@protected
    NSString *name;
    NSString *path;
    QCAR::DataSet *dataSet;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *path;
@property (nonatomic) QCAR::DataSet *dataSet;

- (id) initWithName:(NSString *)theName andPath:(NSString *)thePath;

@end


#pragma mark --- Class interface ---

@interface ofxQCAR_Utils : NSObject
{
@public
    CGSize viewSize;            // set in initialisation
    id delegate;                // a class that will handle optional callbacks
    
    CGFloat contentScalingFactor; // 1.0 normal, 2.0 for retina enabled
    NSMutableArray *targetsList;       // Array of DataSetItem - load target from this list of resources
    int QCARFlags;              // QCAR initialisation flags
    status appStatus;           // Current app status
    int errorCode;              // if appStatus == APPSTATUS_ERROR
    
    TargetType targetType;      // for app to inform QCARutils
    
    struct tagViewport {        // shared between users of QCARutils
        int posX;
        int posY;
        int sizeX;
        int sizeY;
    } viewport;
    
    QCAR::Matrix44F projectionMatrix; // OpenGL projection matrix
    
    QCAR::VideoBackgroundConfig config;
    
    BOOL videoStreamStarted;    // becomes true at first "camera is running"
    BOOL isVisualSearchOn;
    BOOL vsAutoControlEnabled;
    NSInteger noOfCameras;
    BOOL orientationChanged;
    UIInterfaceOrientation orientation;
    
@private
    QCAR::DataSet * userDefDataSet;
    QCAR::DataSet * currentDataSet; // the loaded DataSet
    BOOL cameraTorchOn;
    BOOL cameraContinuousAFOn;
    
@protected
    QCAR::CameraDevice::CAMERA activeCamera;
}

@property (nonatomic) CGSize viewSize;
@property (nonatomic, assign) id delegate;

@property (nonatomic) CGFloat contentScalingFactor;
@property (nonatomic, retain) NSMutableArray *targetsList;
@property (nonatomic) int QCARFlags;
@property (nonatomic) status appStatus;
@property (nonatomic) int errorCode;
@property (nonatomic) NSInteger noOfCameras;
@property (nonatomic) TargetType targetType;
@property (nonatomic) struct tagViewport viewport;

@property (nonatomic) QCAR::Matrix44F projectionMatrix;

@property (nonatomic) QCAR::VideoBackgroundConfig config;

@property (nonatomic) BOOL videoStreamStarted;

@property (nonatomic, readonly) BOOL cameraTorchOn;
@property (nonatomic, readonly) BOOL cameraContinuousAFOn;
@property (nonatomic) BOOL isVisualSearchOn;
@property (nonatomic) BOOL vsAutoControlEnabled;

@property (readwrite) BOOL orientationChanged;
@property (readwrite) UIInterfaceOrientation orientation;

@property (nonatomic, readonly) QCAR::CameraDevice::CAMERA activeCamera;

#pragma mark --- Class Methods ---

+ (ofxQCAR_Utils *) getInstance;

- (void)initApplication;
- (void)initApplicationAR;
- (void)postInitQCAR;

- (void)restoreCameraSettings;

- (void)createARofSize:(CGSize)theSize forDelegate:(id)theDelegate;
- (void)destroyAR;
- (void)pauseAR;
- (void)resumeAR;

- (void) addTargetName:(NSString *)theName atPath:(NSString *)thePath;

- (BOOL)unloadDataSet:(QCAR::DataSet *)theDataSet;
- (QCAR::DataSet *)loadDataSet:(NSString *)dataSetPath;
- (QCAR::DataSet *)getDefaultDataSet;
- (QCAR::DataSet *)getUserDefDataSet;
- (BOOL)deactivateDataSet:(QCAR::DataSet *)theDataSet;
- (BOOL)activateDataSet:(QCAR::DataSet *)theDataSet;
- (void) allowDataSetModification;
- (void) saveDataSetModifications;

- (QCAR::ImageTarget *) findImageTarget:(const char *) name;
- (QCAR::MultiTarget *) findMultiTarget;
- (QCAR::ImageTarget *) getImageTarget:(int)itemNo;

- (void)cameraSetTorchMode:(BOOL)switchOn;
- (void)cameraSetContinuousAFMode:(BOOL)switchOn;
- (void)cameraTriggerAF;
- (void)cameraCancelAF;
- (void)cameraPerformAF;
- (void) configureVideoBackground;

@end

#endif