/*==============================================================================
            Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    ImageTracker.h

@brief
    Header file for ImageTracker class.

==============================================================================*/
#ifndef _QCAR_IMAGE_TRACKER_H_
#define _QCAR_IMAGE_TRACKER_H_

// Include files
#include <QCAR/Tracker.h>

namespace QCAR
{

// Forward Declaration
class Trackable;
class DataSet;
class ImageTargetBuilder;
class TargetFinder;

/// ImageTracker class.
/**
 *  The ImageTracker tracks ImageTargets and MultiTargets contained
 *  in a DataSet. 
 *  The ImageTracker class provides methods for creating, activating and
 *  deactivating datasets. Note that methods for swapping the active dataset
 *  should not be called while the ImageTracker is working at the same time.
 *  Doing so will make these methods block and wait until the tracker has
 *  finished.
 *  The suggested way of swapping datasets is during the execution of
 *  UpdateCallback, which guarantees that the ImageTracker is not working
 *  concurrently. Alternatively the ImageTracker can be stopped explicitly.
 *  However, this is a very expensive operation.
 */
class QCAR_API ImageTracker : public Tracker
{
public:

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
     *  The recommended way to swap datasets is during the execution of the
     *  UpdateCallback, which guarantees that the ImageTracker is not working
     *  concurrently.
     */    
    virtual bool activateDataSet(DataSet* dataset) = 0;
    
    /// Deactivates the given dataset.
    /**
     *  This function will return true if the DataSet was successfully
     *  deactivated and false otherwise (E.g. because this dataset is not
     *  currently active).
     *  The recommended way to swap datasets is during the execution of the
     *  UpdateCallback, which guarantees that the ImageTracker is not working
     *  concurrently.
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

};

} // namespace QCAR

#endif //_QCAR_IMAGE_TRACKER_H_
