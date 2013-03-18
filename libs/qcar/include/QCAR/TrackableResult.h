/*==============================================================================
            Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    TrackableResult.h

@brief
    Header file for TrackableResult class.

==============================================================================*/
#ifndef _QCAR_TRACKABLERESULT_H_
#define _QCAR_TRACKABLERESULT_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/Matrices.h>
#include <QCAR/System.h>
#include <QCAR/Trackable.h>

namespace QCAR
{

/// Base class for all result objects.
/**
 *  A TrackableResult is an object that represents the state of a Trackable
 *  which was found in a given frame. Every TrackableResult has a corresponding
 *  Trackable, a type, a 6DOF pose and a status (e.g. tracked).
 *  See the TYPE enum for a list of all classes that derive from TrackableResult.
 */
class QCAR_API TrackableResult : private NonCopyable
{
public:
    /// Types of TrackableResults
    enum TYPE {
        UNKNOWN_TYPE,           ///< A TrackableResult of unknown type
        IMAGE_TARGET_RESULT,    ///< A TrackableResult of ImageTargetResult type
        MULTI_TARGET_RESULT,    ///< A TrackableResult of MultiTargetResult type
        MARKER_RESULT,          ///< A TrackableResult of MarkerResult type
    };

    /// Status of a TrackableResults
    enum STATUS {
        UNKNOWN,            ///< The state of the TrackableResult is unknown
        UNDEFINED,          ///< The state of the TrackableResult is not defined
                            ///< (this TrackableResult does not have a state)
        DETECTED,           ///< The TrackableResult was detected
        TRACKED             ///< The TrackableResult was tracked
    };

    /// Returns the type of this result. (e.g. MARKER_RESULT)
    virtual TYPE getType() const = 0;

    /// Returns true if the object is of or derived of the given type
    virtual bool isOfType(TYPE type) const = 0;

    /// Returns the tracking status
    virtual STATUS getStatus() const = 0;

    /// Returns the corresponding Trackable that this result represents
    virtual const Trackable& getTrackable() const = 0;

    /// Returns the current pose matrix in row-major order
    virtual const Matrix34F& getPose() const = 0;

    virtual ~TrackableResult()  {}
};

} // namespace QCAR

#endif //_QCAR_TRACKABLERESULT_H_
