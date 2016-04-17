/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    TrackerManager.h

@brief
    Header file for TrackerManager class.
===============================================================================*/
#ifndef _VUFORIA_TRACKER_MANAGER_H_
#define _VUFORIA_TRACKER_MANAGER_H_

// Include files
#include <Vuforia/Tracker.h>
#include <Vuforia/NonCopyable.h>

namespace Vuforia
{

// Forward declarations:
class StateUpdater;

/// TrackerManager class.
/**
 *  The TrackerManager singleton provides methods for accessing the trackers
 *  available in Vuforia as well as initializing specific trackers required by the
 *  application. See the Tracker base class for a list of available tracker
 *  types.
 */
class VUFORIA_API TrackerManager : private NonCopyable
{
public:
    /// Returns the TrackerManager singleton instance.
    static TrackerManager& getInstance();

    /// Initializes the tracker of the given type
    /**
     *  Initializing a tracker must not be done when the CameraDevice
     *  is initialized or started. This function will return NULL if the
     *  tracker of the given type has already been initialized or if the
     *  CameraDevice is currently initialized.
     */
    virtual Tracker* initTracker(Type type) = 0;

    /// Returns the instance of the given tracker type
    /**
     *  See the Tracker base class for a list of available tracker classes.
     *  This function will return NULL if the tracker of the given type has
     *  not been initialized.
     */
    virtual Tracker* getTracker(Type type) = 0;

    /// Deinitializes the tracker of the given type
    /**
     *  Deinitializes the tracker of the given type and frees any resources
     *  used by the tracker.
     *  Deinitializing a tracker must not be done when the CameraDevice
     *  is initialized or started. This function will return false if the
     *  tracker of the given type has not been initialized or if the
     *  CameraDevice is currently initialized.
     */
    virtual bool deinitTracker(Type type) = 0;

    /// Returns the StateUpdater instance
    virtual StateUpdater& getStateUpdater() = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_TRACKER_MANAGER_H_
