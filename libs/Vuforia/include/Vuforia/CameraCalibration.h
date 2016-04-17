/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    CameraCalibration.h

@brief
    Header file for CameraCalibration class.
===============================================================================*/
#ifndef _VUFORIA_CAMERACALIBRATION_H_
#define _VUFORIA_CAMERACALIBRATION_H_

// Include files
#include <Vuforia/Vectors.h>
#include <Vuforia/NonCopyable.h>

namespace Vuforia
{

/// Holds intrinsic camera parameters
class VUFORIA_API CameraCalibration : private NonCopyable
{
public:
    /// Returns the resolution of the camera as 2D vector.
    virtual Vec2F getSize() const = 0;

    /// Returns the focal length in x- and y-direction as 2D vector.
    virtual Vec2F getFocalLength() const = 0;

    /// Returns the principal point as 2D vector.
    virtual Vec2F getPrincipalPoint() const = 0;

    /// Returns the radial distortion as 4D vector.
    virtual Vec4F getDistortionParameters() const = 0;

    /// Returns the field of view in x- and y-direction as 2D vector.
    virtual Vec2F getFieldOfViewRads() const = 0;

protected:

    virtual ~CameraCalibration() {}
};

} // namespace Vuforia

#endif // _VUFORIA_CAMERACALIBRATION_H_
