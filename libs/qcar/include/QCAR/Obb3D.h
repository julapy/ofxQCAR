/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    Obb2d.h

@brief
    Header file for Obb3d class.
===============================================================================*/
#ifndef _QCAR_OBB3D_H_
#define _QCAR_OBB3D_H_


#include <QCAR/QCAR.h>
#include <QCAR/Vectors.h>


namespace QCAR
{


/// An Obb3D represents a 3D bounding box oriented along z-direction
class QCAR_API Obb3D
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


} // namespace QCAR


#endif // _QCAR_OBB3D_H_
