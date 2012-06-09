/*==============================================================================
            Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
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

    /// Factory function for creating an empty dataset. Returns the new instance on
    /// success, NULL otherwise.
    virtual DataSet* createDataSet() = 0;

    /// Destroys the given dataset and releases allocated resources.
    /// Returns false if the given dataset is currently active.
    virtual bool destroyDataSet(DataSet* dataset) = 0;

    /// Activates the given dataset.
    /**
     *  Only a single DataSet can be active at any one time. This function will
     *  return true if the DataSet was successfully activated and false
     *  otherwise (E.g. because another dataset is already active).
     *  The recommended way to swap datasets is during the execution of the
     *  UpdateCallback, which guarantees that the ImageTracker is not working
     *  concurrently.
     */    
    virtual bool activateDataSet(DataSet* dataset) = 0;
    
    /// Dectivates the given dataset.
    /**
     *  This function will return true if the DataSet was successfully
     *  deactivated and false otherwise (E.g. because this dataset is not
     *  currently active).
     *  The recommended way to swap datasets is during the execution of the
     *  UpdateCallback, which guarantees that the ImageTracker is not working
     *  concurrently.
     */    
    virtual bool deactivateDataSet(DataSet* dataset) = 0;

    /// Returns the currently active dataset. Returns NULL if no DataSet has
    /// been activated.
    virtual DataSet* getActiveDataSet() = 0;
};

} // namespace QCAR

#endif //_QCAR_IMAGE_TRACKER_H_
