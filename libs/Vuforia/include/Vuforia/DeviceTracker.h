/*==============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.


Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    DeviceTracker.h

@brief
    Header file for DeviceTracker class. 
==============================================================================*/
#ifndef _VUFORIA_DEVICE_TRACKER_H_
#define _VUFORIA_DEVICE_TRACKER_H_

#include <Vuforia/Tracker.h>
#include <Vuforia/Matrices.h>

namespace Vuforia
{

/// DeviceTracker class.
/**
*  The DeviceTracker tracks a device in the world frame of reference. A DeviceTracker
*  can be used to track the user's viewpoint or any environment elements that
*  are not objects in the camera frame of reference. A DeviceTracker generally relies
*  on the integration of multiple elements (such as sensors) and it includes the notion of
*  a system combining a domain model with multiple internal and hierarchical coordinate 
*  systems. A specialized DeviceTracker delivers DeviceTrackableResults to the State.
*  The pose of a DeviceTrackableResult is defined in the world frame of reference. 
*  In order to simplify native development with a DeviceTracker we also support an offset
*  transformation that can be internally applied to the returned pose. This offset can be 
*  used to reference multiple DeviceTrackers with respect to a common location/position in 
*  the world frame of reference. The offset can also be used to manage nested 
*  transformations (for example, a spaceship moving in the world frame of reference, 
*  and the user (device tracked) head defined in the spaceship frame of reference).
*/
class VUFORIA_API DeviceTracker : public Tracker
{
public:
    /// Returns the Tracker class' type
    static Type getClassType();

    /// Set the offset transform between World and Device (Base) frame of reference
    /**
    * 
    *  Set an offset transformation between the World Coordinate System and the 
    *  Device (Base) Coordinate System. By default this transformation is identity.
    *  Offset transform will be composed with the current pose of the device tracker
    *  This offset can used for advanced scenarios.
    *
    *  \param baseTransform  offset transformation
    *
    *  \return True if setting up the world device is successful, false otherwise
    *
    **/
    virtual bool setWorldToDeviceBaseTransform(const Matrix34F& baseTransform) = 0;

    /// Get the offset transform between World and Device Base frame of reference
    /**
    *
    *  Get the current offset transformation between the World Coordinate System and the
    *  Device Base Coordinate System. 
    *  
    *  \return the offset transformation matrix.
    *
    **/
    virtual Matrix34F getWorldToDeviceBaseTransform() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_DEVICE_TRACKER_H_
