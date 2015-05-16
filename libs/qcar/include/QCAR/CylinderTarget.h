/*===============================================================================
Copyright (c) 2013-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    CylinderTarget.h

@brief
    Header file for CylinderTarget class.
===============================================================================*/
#ifndef _QCAR_CYLINDERTARGET_H_
#define _QCAR_CYLINDERTARGET_H_

// Include files
#include <QCAR/Trackable.h>
#include <QCAR/ObjectTarget.h>

namespace QCAR
{

/// A 3D trackable object of cylindrical or conical shape.
/**
 *  The CylinderTarget class exposes convenience functionality for setting the
 *  scene size of the object via any of its three defining geometric parameters:
 *  side length, top diameter and bottom diameter. 
 *  The object is always scaled uniformly, so changing any of its parameters 
 *  affects all others.
 */
class QCAR_API CylinderTarget : public ObjectTarget
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the side length of the cylinder target (in 3D scene units).
    virtual float getSideLength() const = 0;

    /// Sets the side length of the cylinder target (in 3D scene units).
    /**
     *  Note that the top and bottom diameter will be scaled accordingly.
     */
    virtual bool setSideLength(float sideLength) = 0;

    /// Returns the top diameter of the cylinder target (in 3D scene units).
    virtual float getTopDiameter() const = 0;

    /// Sets the top diameter of the cylinder target (in 3D scene units).
    /**
     *  Note that the height and bottom diameter will be scaled accordingly.
     */
    virtual bool setTopDiameter(float topDiameter) = 0;

    /// Returns the bottom diameter of the cylinder target (in 3D scene units).
    virtual float getBottomDiameter() const = 0;

    /// Sets the bottom diameter of the cylinder target (in 3D scene units).
    /**
     *  Note that the height and top diameter will be scaled accordingly.
     */
    virtual bool setBottomDiameter(float bottomDiameter) = 0;
};

} // namespace QCAR

#endif //_QCAR_CYLINDERTARGET_H_
