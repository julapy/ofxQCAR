/*==============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.


Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    HandheldTransformModel.h

@brief
    Header file for HandheldTransformModel class. 
==============================================================================*/
#ifndef _VUFORIA_HANDHELD_TRANSFORM_MODEL_H_
#define _VUFORIA_HANDHELD_TRANSFORM_MODEL_H_

#include <Vuforia/Vectors.h>
#include <Vuforia/TransformModel.h>
#include <Vuforia/System.h>

namespace Vuforia
{

/// HandheldTransformModel class.
/**
*  The HanheldTransformModel define a handheld model that can be mainly
*  used for 3DOF tracker (rotation only) while used in a mobile tracking
*  context. Mobile tracking context corresponds to scenario when user
*  move a mobile device around its body, mainly executing a 3d motion
*  that can be fitted to a spherical model.
*  It supports a pivot model, representing the center of rotation,
*  when moving the device around, reference for the tracked pose 
*  that can be use to correct the pose provided by the tracker. 
*  The pivot point (3d vector) will be used to correct the current
*  estimated rotation, to take in consideration current rotation point.
*  For a handheld model this corresponds to the body pivot.
*  The default value used is based on average anthropomorphic 
*  measurements.
*  The pivot point is at the center of the device, so the vector 
*  should be given in the device coordinate system. The pivot point is 
*  used to correct the position of the device based on the device rotation. 
*  For the time being, in order to position the device with respect to the
*  body developers need to apply a translation to the device pose in their 
*  app code (say, move the device along the Y axis to the elbow height 
*  position, e.g. 0.9m for a 1.8 tall person).
*/
class VUFORIA_API HandheldTransformModel : public TransformModel
{
public:
    /// Returns the TransformModel instance's type
    virtual TYPE getType() const;

    /// Constructor.
    HandheldTransformModel();

    /// Copy constructor.
    HandheldTransformModel(const HandheldTransformModel& other);

    /// Define a Head Transform Model with a pivot point
    HandheldTransformModel(const Vec3F& pivotPos);

    /// Set the Pivot Point
    virtual bool setPivotPoint(const Vec3F& pivot);

    // Get the Pivot Point
    virtual const Vec3F& getPivotPoint() const;
    
    // Destructor
    virtual ~HandheldTransformModel();

protected:
    Vec3F pivotPosition;
};

} // namespace Vuforia

#endif //_VUFORIA_HANDHELD_TRANSFORM_MODEL_H_
