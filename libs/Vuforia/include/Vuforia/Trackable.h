/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Trackable.h

@brief
    Header file for Trackable class.
===============================================================================*/
#ifndef _VUFORIA_TRACKABLE_H_
#define _VUFORIA_TRACKABLE_H_

// Include files
#include <Vuforia/NonCopyable.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/System.h>
#include <Vuforia/Type.h>

namespace Vuforia
{

/// Base class for all objects that can be tracked.
/**
 *  Every Trackable has a name, an id and a type.
 */
class VUFORIA_API Trackable : private NonCopyable
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the Trackable instance's type
    virtual Type getType() const = 0;

    /// Checks whether the Trackable instance's type equals or has been
    /// derived from a give type
    virtual bool isOfType(Type type) const = 0;
        
    /// Returns a unique id for all 3D trackable objects
    virtual int getId() const = 0;

    /// Returns the Trackable's name
    virtual const char* getName() const = 0;

    /// Sets the given user data for this Trackable. Returns true if successful
    virtual bool setUserData(void* userData) = 0;

    /// Returns the pointer previously set by setUserData()
    virtual void* getUserData() const = 0;

    /// Starts extended tracking for this Trackable. Returns true if successful
    virtual bool startExtendedTracking() = 0;

    /// Stops extended tracking for this Trackable. Returns true if successful
    virtual bool stopExtendedTracking() = 0;

    /// Returns true if extended tracking has been enabled, false otherwise.
    virtual bool isExtendedTrackingStarted() const = 0;

    virtual ~Trackable()  {}
};

} // namespace Vuforia

#endif //_VUFORIA_TRACKABLE_H_
