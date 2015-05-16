/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    Box3D.h

@brief
    Header file for Box3D class.
===============================================================================*/
#ifndef _QCAR_BOX3D_H_
#define _QCAR_BOX3D_H_

#include <QCAR/QCAR.h>
#include <QCAR/Vectors.h>

namespace QCAR
{

/// A Box3D represents an axis-aligned 3D box
class QCAR_API Box3D
{
public:

    /// Constructor.
    Box3D();

    /// Copy constructor.
    Box3D(const Box3D& other);

    /// Define a box by its minimum and maximum position.
    Box3D(const Vec3F& nMinPos, const Vec3F& nMaxPos);

    /// Returns the minimum position of the box.
    virtual const Vec3F& getMinimumPosition() const;

    /// Returns the maximum position of the box.
    virtual const Vec3F& getMaximumPosition() const;

    virtual ~Box3D();

protected:
    Vec3F minimumPosition;
    Vec3F maximumPosition;
};


} // namespace QCAR


#endif // _QCAR_BOX3D_H_
