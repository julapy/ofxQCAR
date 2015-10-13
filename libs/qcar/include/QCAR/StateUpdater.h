/*===============================================================================
Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file
StateUpdater.h

@brief
Header file for StateUpdater class.
===============================================================================*/
#ifndef _QCAR_STATE_UPDATER_H_
#define _QCAR_STATE_UPDATER_H_

// Include files
#include <QCAR/System.h>
#include <QCAR/NonCopyable.h>
#include <QCAR/State.h>

namespace QCAR
{

/// StateUpdater class
/**
*  The StateUpdater class exposes APIs for on-demand creation of new State
*  instances. While the QCAR::UpdateCallback implements a “push” model for new
*  State instances being made available when a new camera frame has finished
*  processing, the StateUpdater follows a “pull” model. The StateUpdater can be
*  used to request the latest available state asynchronously from the camera
*  update rate, where the Trackable poses may be updated given inertial
*  measurements since the last camera frame. On devices where inertial/
*  predictive tracking is not available StateUpdater will simply return the
*  latest camera-based state.
*/
class StateUpdater : private NonCopyable
{
public:
    
    /// Attempts to update the State from latest tracking data and returns it
    /**
    *  Integrates latest available inertial measurements to create the most
    *  up-to-date State instance. Note that the State created may contain poses
    *  that are no longer in sync with the last camera frame. Thus this function's
    *  primary use cases are VR as well as AR on see-through Eyewear devices
    *  where tight visual registration with a rendered video background is not
    *  required. On devices where inertial/predictive tracking is not available
    *  updateState() will simply return the latest camera-based state.
    */
    virtual State updateState() = 0;

    /// Accessor for the last state created from updateState()
    virtual State getLatestState() const = 0;
};

} // namespace QCAR

#endif //_QCAR_STATE_UPDATER_H_
