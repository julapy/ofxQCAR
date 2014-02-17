/*==============================================================================
Copyright (c) 2013 Qualcomm Connected Experiences, Inc.
All Rights Reserved.
Proprietary - Qualcomm Connected Experiences, Inc.

@file 
    Obb2d.h

@brief
    Header file for Obb2d class.
==============================================================================*/
#ifndef _QCAR_OBB2D_H_
#define _QCAR_OBB2D_H_


#include <QCAR/QCAR.h>
#include <QCAR/Vectors.h>


namespace QCAR
{


/// An Obb2D represents a 2D oriented bounding box
class QCAR_API Obb2D
{
public:

    Obb2D();

    Obb2D(const Obb2D& other);

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


} // namespace QCAR


#endif // _QCAR_OBB2D_H_
