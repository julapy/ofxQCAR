/*==============================================================================
Copyright (c) 2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    DeviceTrackableResult.h

@brief
    Header file for DeviceTrackableResult class. 
==============================================================================*/
#ifndef _VUFORIA_DEVICE_TRACKABLE_RESULT_H_
#define _VUFORIA_DEVICE_TRACKABLE_RESULT_H_

#include <Vuforia/TrackableResult.h>
#include <Vuforia/DeviceTrackable.h>

namespace Vuforia
{

/// DeviceTrackableResult class.
/**
*  The DeviceTrackableResult defines trackable results returned
*  by DeviceTrackers.
*/
class VUFORIA_API DeviceTrackableResult : public TrackableResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents
    virtual const DeviceTrackable& getTrackable() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_DEVICE_TRACKABLE_RESULT_H_
