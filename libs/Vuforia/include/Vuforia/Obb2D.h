/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2013-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Obb2d.h

@brief
    Header file for Obb2d class.
===============================================================================*/
#ifndef _VUFORIA_OBB2D_H_
#define _VUFORIA_OBB2D_H_

#include <Vuforia/Vuforia.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

/// An Obb2D represents a 2D oriented bounding box
class VUFORIA_API Obb2D
{
public:

    /// Constructor.
    Obb2D();

    /// Copy constructor.
    Obb2D(const Obb2D& other);

    /// Construct from center, half extents and rotation.
    Obb2D(const Vec2F& nCenter, const Vec2F& nHalfExtents,
        float nRotation);

    /// Returns the center of the bounding box.
    virtual const Vec2F& getCenter() const;

    /// Returns the half width and half height of the bounding box.
    virtual const Vec2F& getHalfExtents() const;

    /// Returns the counter-clock-wise rotation angle (in radians) 
    /// of the bounding box with respect to the X axis.
    virtual float getRotation() const;

    virtual ~Obb2D();

protected:
    Vec2F center;
    Vec2F halfExtents;
    float rotation;
};


} // namespace Vuforia


#endif // _VUFORIA_OBB2D_H_
