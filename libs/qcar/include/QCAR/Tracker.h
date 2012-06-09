/*==============================================================================
            Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
			
@file 
    Tracker.h

@brief
    Header file for Tracker class.

==============================================================================*/
#ifndef _QCAR_TRACKER_H_
#define _QCAR_TRACKER_H_

// Include files
#include <QCAR/NonCopyable.h>

namespace QCAR
{

/// Base class for all tracker types.
/**
 *  The class exposes generic functionality for starting and stopping a
 *  given Tracker as well as querying the tracker type.
 *  See the TYPE enum for a list of all classes that derive from Tracker.
 */
class QCAR_API Tracker : private NonCopyable
{
public:

    /// Enumeration of the different tracker types
    enum TYPE {
        IMAGE_TRACKER,      ///< Tracks ImageTargets and MultiTargets.
        MARKER_TRACKER,     ///< Tracks Markers.
    };

    /// Returns the tracker type
    virtual TYPE getType() = 0;

    /// Starts the Tracker
    virtual bool start() = 0;

    /// Stops the Tracker
    virtual void stop() = 0;

    virtual ~Tracker() {}
};

} // namespace QCAR

#endif //_QCAR_TRACKER_H_
