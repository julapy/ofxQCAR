/*==============================================================================
Copyright (c) 2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    DeviceTrackable.h

@brief
    Header file for DeviceTrackable class. 
==============================================================================*/
#ifndef _VUFORIA_DEVICE_TRACKABLE_H_
#define _VUFORIA_DEVICE_TRACKABLE_H_

#include <Vuforia/Trackable.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/EyeID.h>
#include <Vuforia/TransformModel.h>

namespace Vuforia
{

/// DeviceTrackable class.
/**
*  "Base class representing devices the 3D pose of which can be tracked by DeviceTrackers."
*/
class VUFORIA_API DeviceTrackable : public Trackable
{    
public:
    /// Returns the Trackable class' type
    static Type getClassType();
};


} // namespace Vuforia

#endif //_VUFORIA_DEVICE_TRACKABLE_H_
