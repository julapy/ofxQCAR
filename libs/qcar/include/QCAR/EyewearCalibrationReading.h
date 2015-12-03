/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    EyewearCalibrationReading.h

@brief
    Header file for EyewearCalibrationReading struct.
===============================================================================*/
#ifndef _QCAR_EYEWEARCALIBRATIONREADING_H_
#define _QCAR_EYEWEARCALIBRATIONREADING_H_

#include <QCAR/Matrices.h>

namespace QCAR
{

/// Structure for an eyewear calibration reading to be used with EyewearUserCalibration
struct EyewearCalibrationReading
{
    /// Pose matrix from a TrackableResult
    Matrix34F mPose;
    /// A scale in the range 0.0 - 1.0 that should specify the amount of rendering surface height the calibration shape fills
    float mScale;
    /// A position in the range -1.0 to 1.0 that specifies the horizontal center of the calibration shape on the rendering surface
    float mCenterX;
    /// A position in the range -1.0 to 1.0 that specifies the vertical center of the calibration shape on the rendering surface
    float mCenterY;
};

} // namespace QCAR

#endif //_QCAR_EYEWEARCALIBRATIONREADING_H_
