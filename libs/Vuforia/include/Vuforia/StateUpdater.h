/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
StateUpdater.h

@brief
Header file for StateUpdater class.
===============================================================================*/
#ifndef _VUFORIA_STATE_UPDATER_H_
#define _VUFORIA_STATE_UPDATER_H_

// Include files
#include <Vuforia/System.h>
#include <Vuforia/NonCopyable.h>
#include <Vuforia/State.h>

namespace Vuforia
{

/// StateUpdater class
/**
* The StateUpdater class exposes APIs for on-demand generation of new State
* instances. The StateUpdater can be used to request the latest available state
* asynchronously from the update rate of the camera. This provides trackable
* poses representing updates from trackers that don't rely only on the
* camera frames (e.g. DeviceTrackers) or use predictive tracking.
* In this way, the StateUpdater utilizes a pull model for obtaining states, which
* differs from the push model provided with Vuforia::UpdateCallback.
*
* On devices where device trackers / predictive tracking is not available,
* StateUpdater will return the latest camera derived state.
*/
class StateUpdater : private NonCopyable
{
public:
    
    /// Attempts to update the State from latest tracking data and returns it
    /**
    *  Integrates latest available tracker measurements to create the most
    *  up-to-date State instance. Note that the State created may contain poses
    *  that are no longer in sync with the last camera frame. Thus this function's
    *  primary use cases are VR as well as AR on see-through Eyewear devices
    *  where tight visual registration with a rendered video background is not
    *  required. On devices where device trackers /predictive tracking is not 
    *  available updateState() will simply return the latest camera-based state.
    */
    virtual State updateState() = 0;

    /// Accessor for the last state created from updateState()
    virtual State getLatestState() const = 0;

    /// Return the current time stamp
    /**
    *  Return the current time stamp using similar measurement unit and reference 
    *  as for state objects (e.g. frame, trackable results). 
    */    
    virtual double getCurrentTimeStamp() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_STATE_UPDATER_H_
