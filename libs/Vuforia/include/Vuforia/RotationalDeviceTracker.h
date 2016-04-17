/*==============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.


Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    RotationalDeviceTracker.h

@brief
    Header file for RotationalDeviceTracker class. 
==============================================================================*/
#ifndef _VUFORIA_ROTATIONAL_DEVICE_TRACKER_H_
#define _VUFORIA_ROTATIONAL_DEVICE_TRACKER_H_

#include <Vuforia/DeviceTracker.h>

namespace Vuforia
{
class TransformModel;
class HandheldTransformModel;
class HeadTransformModel;


/// RotationalDeviceTracker class.
/**
*  The RotationalDeviceTracker tracks a device in the world by relying on
*  sensor tracking. The RotationalDeviceTracker publishes device trackable
*  result. Device Trackable results are in world coordinate system 
*  and use a physical unit (meter).
*  A rotational device tracker can use model correction to improve the 
*  returned pose based on the context usage (e.g. on the  head for doing 
*  head tracking,  holding device in your hands for handheld tracking, etc). 
*  This tracker also supports a pose prediction mode to improve the quality 
*  of returned pose. You should only use this mode in VR configuration!
*/
class VUFORIA_API RotationalDeviceTracker : public DeviceTracker
{
public:

    /// Returns the Tracker class' type
    static Type getClassType();
    
    /// Reset the current pose.
    /**
    *  Reset the current pose heading in the world coordinate system.
    *  Useful if you want to reset the direction the device is pointing too
    *  without impacting the current pitch or roll angle (your horizon).
    */
    virtual bool recenter() = 0;


    ///  Enable pose prediction to reduce latency.
    /**
    *  Recommended to use this mode for VR experience.
    *  Return true if pose prediction is supported
    */
    virtual bool setPosePrediction(bool enable) = 0;


    // Get the current pose prediction mode
    /**
    *  by default prediction is off.
    */
    virtual bool getPosePrediction() const = 0;


    /// Enable usage of a model correction for the pose
    /**
    *  Specify a correction mode of the returned pose.
    *  Correction mode are based on transformation model, defining the context
    *  usage of the tracker.
    *  For example, if you device tracker for doing head tracking (VR), you
    *  can set a HeadTransformModel to the tracker and pose will be adjusted 
    *  consequently. The rotational device tracker support two transform models:
    *  - HeadTransformModel: for head tracking (VR, rotational AR experience)
    *  - HandheldTransformModel: for handheld tracking.
    *  by default no transform model is used.
    *  Passing NULL as argument disable the usage of the model correction.
    */
    virtual bool setModelCorrection(const TransformModel* transformationmodel) = 0;


    /// Get the current correction model
    /**
    *  return the currently set transform model used for correction.
    *  by default no transform model are used, will return to null.
    */
    virtual const TransformModel* getModelCorrection() const = 0;


    /// Return the default head transform model
    /**
    *  utility method to get the recommended Head model. 
    *  Unit is in meter.
    */
    virtual const HeadTransformModel* getDefaultHeadModel() const = 0;


    /// Returns the default handheld transform model
    /**
    *  utility method to get the recommended handheld model.
    *  Unit is in meter.
    */   
    virtual const HandheldTransformModel* getDefaultHandheldModel() const = 0;
};


} // namespace Vuforia

#endif //_VUFORIA_DEVICE_FROM_INERTIAL_TRACKER_H_
