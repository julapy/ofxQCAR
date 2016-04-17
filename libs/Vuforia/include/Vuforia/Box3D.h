/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Box3D.h

@brief
    Header file for Box3D class.
===============================================================================*/
#ifndef _VUFORIA_BOX3D_H_
#define _VUFORIA_BOX3D_H_

#include <Vuforia/Vuforia.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

/// A Box3D represents an axis-aligned 3D box
class VUFORIA_API Box3D
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


} // namespace Vuforia


#endif // _VUFORIA_BOX3D_H_
