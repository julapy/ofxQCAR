/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    ObjectTracker.h

@brief
    Header file for ObjectTracker class.
===============================================================================*/
#ifndef _VUFORIA_OBJECT_TRACKER_H_
#define _VUFORIA_OBJECT_TRACKER_H_

// Include files
#include <Vuforia/Tracker.h>

namespace Vuforia
{

// Forward Declaration
class Trackable;
class DataSet;
class ImageTargetBuilder;
class TargetFinder;

/// ObjectTracker class.
/**
 *  The ObjectTracker tracks ObjectTargets, ImageTargets, CylinderTargets
 *  or MultiTargets contained in a DataSet. 
 *  The ObjectTracker class provides methods for creating, activating and
 *  deactivating datasets. Note that methods for activating and deactivating 
 *  datasets should not be called while the ObjectTracker is working at the 
 *  same time. Doing so will make these methods block and wait until the 
 *  tracker has finished.
 *  The suggested way of swapping datasets is during the execution of
 *  UpdateCallback, which guarantees that the ObjectTracker is not working
 *  concurrently. Alternatively the ObjectTracker can be stopped explicitly.
 *  However, this is a very expensive operation.
 */
class VUFORIA_API ObjectTracker : public Tracker
{
public:

    /// Returns the Tracker class' type
    static Type getClassType();

    /// Factory function for creating an empty dataset.
    /**
     *  Returns the new instance on success, NULL otherwise. Use
     *  DataSet::destroyDataSet() to destroy a DataSet that is no longer needed.
     */      
    virtual DataSet* createDataSet() = 0;

    /// Destroys the given dataset and releases allocated resources.
    /// Returns false if the given dataset is currently active.
    virtual bool destroyDataSet(DataSet* dataset) = 0;

    /// Activates the given dataset.
    /**
     *  This function will return true if the DataSet was successfully 
     *  activated and false otherwise.
     *  The recommended way to activate datasets is during the execution of the
     *  UpdateCallback, which guarantees that the ObjectTracker is not working
     *  concurrently.
     */    
    virtual bool activateDataSet(DataSet* dataset) = 0;
    
    /// Deactivates the given dataset.
    /**
     *  This function will return true if the DataSet was successfully
     *  deactivated and false otherwise (E.g. because this dataset is not
     *  currently active).
     *  The recommended way to deactivate datasets is during the execution of 
     *  the UpdateCallback, which guarantees that the ObjectTracker is not 
     *  working concurrently.
     */    
    virtual bool deactivateDataSet(DataSet* dataset) = 0;

    /// Returns the idx-th active dataset. Returns NULL if no DataSet has
    /// been activated or if idx is out of range.
    virtual DataSet* getActiveDataSet(const int idx = 0) = 0;

    /// Returns the number of currently activated dataset. 
    virtual int getActiveDataSetCount() const = 0;

    /// Returns instance of ImageTargetBuilder to be used for generated
    /// target image from current scene.
    virtual ImageTargetBuilder* getImageTargetBuilder() = 0;
    
    /// Returns instance of TargetFinder to be used for retrieving
    /// targets by cloud-based recognition.
    virtual TargetFinder* getTargetFinder() = 0;

    ///  Persist/Reset Extended Tracking
    /**
     *  In persistent Extended Tracking mode, the environment map will only
     *  ever be reset when the developer calls resetExtendedTracking().
     *  This function will return true if persistent Extended Tracking
     *  was set successfully (or was already set to the specified value)
     *  and false otherwise.
     */
    virtual bool persistExtendedTracking(bool on) = 0;
 
    /// Resets environment map for Extended Tracking
    /**
     *  Environment map can only be reset by the developer if persistent
     *  extended tracking is enabled.
     *  This function will return true if environment map was reset
     *  successfully and false otherwise.
     */
    virtual bool resetExtendedTracking() = 0;

};

} // namespace Vuforia

#endif //_VUFORIA_OBJECT_TRACKER_H_
