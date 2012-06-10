/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <Foundation/Foundation.h>
#import <QCAR/Tool.h>
#import <QCAR/DataSet.h>
#import <QCAR/ImageTarget.h>

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
    QCAR_ERRCODE_LOAD_TARGET = -1006
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
    
    BOOL videoStreamStarted;    // becomes true at first "camera is running"
    
@private
    QCAR::DataSet * currentDataSet; // the loaded DataSet
    BOOL cameraTorchOn;
    BOOL cameraContinuousAFOn;
}

@property (nonatomic) CGSize viewSize;
@property (nonatomic, assign) id delegate; 

@property (nonatomic) CGFloat contentScalingFactor;
@property (nonatomic, retain) NSMutableArray *targetsList;
@property (nonatomic) int QCARFlags;           
@property (nonatomic) status appStatus;        
@property (nonatomic) int errorCode;

@property (nonatomic) TargetType targetType;
@property (nonatomic) struct tagViewport viewport;

@property (nonatomic) QCAR::Matrix44F projectionMatrix;

@property (nonatomic) BOOL videoStreamStarted;

@property (nonatomic, readonly) BOOL cameraTorchOn;
@property (nonatomic, readonly) BOOL cameraContinuousAFOn;

#pragma mark --- Class Methods ---

+ (ofxQCAR_Utils *) getInstance;

- (void)createARofSize:(CGSize)theSize forDelegate:(id)theDelegate;
- (void)destroyAR;
- (void)pauseAR;
- (void)resumeAR;

- (void) addTargetName:(NSString *)theName atPath:(NSString *)thePath;

- (BOOL)unloadDataSet:(QCAR::DataSet *)theDataSet;
- (QCAR::DataSet *)loadDataSet:(NSString *)dataSetPath;
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

@end
