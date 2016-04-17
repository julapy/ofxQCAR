/*==============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.


Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    HeadTransformModel.h

@brief
    Header file for HeadTransformModel class. 
==============================================================================*/
#ifndef _VUFORIA_HEAD_TRANSFORM_MODEL_H_
#define _VUFORIA_HEAD_TRANSFORM_MODEL_H_

#include <Vuforia/TransformModel.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

/// HeadTransformModel class.
/**
*  The HeadTransformModel define a head model that can be mainly
*  used for 3DOF tracker (rotation only) while used in a head tracking
*  context. It supports a pivot model, representing the neck pivot 
*  point in reference to the tracked pose that can be use to correct 
*  the pose provided by the tracker.
*  The pivot point (3d vector) will be used to correct the current 
*  estimated rotation, to take in consideration current rotation point.
*  For a head model this corresponds to the neck pivot.
*  The default value used is based on average anthropomorphic
*  measurements.
*/
class VUFORIA_API HeadTransformModel : public TransformModel
{
public:
    /// Returns the TransformModel instance's type
    virtual TYPE getType() const;

    /// Constructor.
    HeadTransformModel();

    /// Copy constructor.
    HeadTransformModel(const HeadTransformModel& other);

    /// Define a Head Transform Model with a pivot point
    HeadTransformModel(const Vec3F& pivotPos);

    /// Set the Pivot Point
    virtual bool setPivotPoint(const Vec3F& pivot);

    // Get the Pivot Point
    virtual const Vec3F& getPivotPoint() const;

    // Destructor
    virtual ~HeadTransformModel();

protected:
    Vec3F pivotPosition;
};

} // namespace Vuforia

#endif //_VUFORIA_HEAD_TRANSFORM_MODEL_H_
