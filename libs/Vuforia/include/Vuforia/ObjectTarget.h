/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    ObjectTarget.h

@brief
    Header file for the ObjectTarget Trackable type.
===============================================================================*/
#ifndef _VUFORIA_OBJECTTARGET_H_
#define _VUFORIA_OBJECTTARGET_H_

// Include files
#include <Vuforia/Trackable.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

/// A target for tracking rigid three-dimensional bodies.
class VUFORIA_API ObjectTarget : public Trackable
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the system-wide unique id of the target.
    /**
     *  The target id uniquely identifies an ObjectTarget across multiple
     *  Vuforia sessions. The system wide unique id may be generated off-line.
     *  This is opposed to the function getId() which is a dynamically
     *  generated id and which uniquely identifies a Trackable within one run
     *  of Vuforia only.
     */
    virtual const char* getUniqueTargetId() const = 0;

    /// Returns the size (width, height, depth) of the target (in 3D scene units).
    virtual Vec3F getSize() const = 0;

    /// Set the size (width, height, depth) of the target (in 3D scene units).
    /**
     *  The dataset this target belongs to should not be active when calling
     *  this function, otherwise it will fail. 
     *  We expect the scale factor to be uniform, and if the given size
     *  corresponds to non-uniform scaling based on the original size, 
     *  we return false.
     *  Returns true if the size was set successfully, false otherwise.
     */
    virtual bool setSize(const Vec3F& size) = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_OBJECTTARGET_H_

