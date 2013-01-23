/*==============================================================================
            Copyright (c) 2010-2012 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    Trackable.h

@brief
    Header file for Trackable class.

==============================================================================*/
#ifndef _QCAR_TRACKABLE_H_
#define _QCAR_TRACKABLE_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/Matrices.h>
#include <QCAR/System.h>

namespace QCAR
{

/// Base class for all objects that can be tracked.
/**
 *  Every Trackable has a name, an id and a type.
 *  See the TYPE enum for a list of all classes that derive from Trackable.
 */
class QCAR_API Trackable : private NonCopyable
{
public:
    /// Types of Trackables
    enum TYPE {
        UNKNOWN_TYPE,       ///< A trackable of unknown type
        IMAGE_TARGET,       ///< A trackable of ImageTarget type
        MULTI_TARGET,       ///< A trackable of MultiTarget type
        MARKER,             ///< A trackable of Marker type
    };
    
    /// Returns the type of 3D object (e.g. MARKER)
    virtual TYPE getType() const = 0;

    /// Returns true if the object is of or derived of the given type
    virtual bool isOfType(TYPE type) const = 0;
        
    /// Returns a unique id for all 3D trackable objects
    virtual int getId() const = 0;

    /// Returns the Trackable's name
    virtual const char* getName() const = 0;

    /// Sets the given user data for this Trackable. Returns true if successful
    virtual bool setUserData(void* userData) = 0;

    /// Returns the pointer previously set by setUserData()
    virtual void* getUserData() const = 0;

    virtual ~Trackable()  {}
};

} // namespace QCAR

#endif //_QCAR_TRACKABLE_H_
