/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    TrackableResult.h

@brief
    Header file for TrackableResult class.
===============================================================================*/
#ifndef _VUFORIA_TRACKABLERESULT_H_
#define _VUFORIA_TRACKABLERESULT_H_

// Include files
#include <Vuforia/NonCopyable.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/System.h>
#include <Vuforia/Trackable.h>
#include <Vuforia/Vuforia.h>

namespace Vuforia
{
    
/// Base class for all result objects.
/**
 *  A TrackableResult is an object that represents the state of a Trackable
 *  which was found in a given frame. Every TrackableResult has a corresponding
 *  Trackable, a type, a 6DOF pose and a status (e.g. tracked).
 */
class VUFORIA_API TrackableResult : private NonCopyable
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the TrackableResult instance's type
    virtual Type getType() const = 0;

    /// Checks whether the TrackableResult instance's type equals or has been
    /// derived from a give type
    virtual bool isOfType(Type type) const = 0;

    /// A time stamp that defines when the trackable result was generated
    /**
    *  Value in seconds representing the offset to application startup time.
    *  The timestamp can be used to compare trackable results.
    */
    virtual double getTimeStamp() const = 0;


    /// Status of a TrackableResults
    enum STATUS {
        UNKNOWN,            ///< The state of the TrackableResult is unknown
        UNDEFINED,          ///< The state of the TrackableResult is not defined
                            ///< (this TrackableResult does not have a state)
        DETECTED,           ///< The TrackableResult was detected
        TRACKED,            ///< The TrackableResult was tracked
        EXTENDED_TRACKED    ///< The Trackable Result was extended tracked
    };

    /// Returns the tracking status
    virtual STATUS getStatus() const = 0;

    /// Returns the corresponding Trackable that this result represents
    virtual const Trackable& getTrackable() const = 0;

    /// Returns the current pose matrix in row-major order
    /**
    *  A pose is defined in a base coordinate system and defines a transformation
    *  from a target coordinate system to a base coordinate system.
    */
    virtual const Matrix34F& getPose() const = 0;

    /// Returns the base coordinate system defined for the pose
    virtual COORDINATE_SYSTEM_TYPE getCoordinateSystem() const = 0;

    virtual ~TrackableResult()  {}
};

} // namespace Vuforia

#endif //_VUFORIA_TRACKABLERESULT_H_
