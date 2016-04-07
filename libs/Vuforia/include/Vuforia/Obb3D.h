/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Obb2d.h

@brief
    Header file for Obb3d class.
===============================================================================*/
#ifndef _VUFORIA_OBB3D_H_
#define _VUFORIA_OBB3D_H_


#include <Vuforia/Vuforia.h>
#include <Vuforia/Vectors.h>


namespace Vuforia
{


/// An Obb3D represents a 3D bounding box oriented along z-direction
class VUFORIA_API Obb3D
{
public:

    /// Constructor.
    Obb3D();

    /// Copy constructor.
    Obb3D(const Obb3D& other);

    /// Construct from center, half extents and rotation.
    Obb3D(const Vec3F& nCenter, const Vec3F& nHalfExtents,
        float nRotationZ);

    /// Returns the center of the bounding box.
    virtual const Vec3F& getCenter() const;

    /// Returns the half width, depth, and height of the bounding box.
    virtual const Vec3F& getHalfExtents() const;

    /// Returns the counter-clock-wise rotation angle (in radians) 
    /// of the bounding box with respect to the Z axis.
    virtual float getRotationZ() const;

    virtual ~Obb3D();

protected:
    Vec3F center;
    Vec3F halfExtents;
    float rotation;
};


} // namespace Vuforia


#endif // _VUFORIA_OBB3D_H_
