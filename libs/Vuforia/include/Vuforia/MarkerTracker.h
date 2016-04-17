/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    MarkerTracker.h

@brief
    Header file for MarkerTracker class.
===============================================================================*/
#ifndef _VUFORIA_MARKER_TRACKER_H_
#define _VUFORIA_MARKER_TRACKER_H_

// Include files
#include <Vuforia/Tracker.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

// Forward Declaration
class Marker;

/// MarkerTracker class.
/**
 *  The MarkerTracker tracks rectangular markers and provides methods for
 *  creating and destroying these dynamically.
 *  Note that the methods for creating and destroying markers should not be
 *  called while the MarkerTracker is working at the same time. Doing so will
 *  make these methods block and wait until the MarkerTracker has finished.
 *  The suggested way of doing this is during the execution of UpdateCallback,
 *  which guarantees that the MarkerTracker is not working concurrently.
 *  Alternatively the MarkerTracker can be stopped explicitly.
 */
class VUFORIA_API MarkerTracker : public Tracker
{
public:

    /// Returns the Tracker class' type
    static Type getClassType();

    /// Creates a new Marker
    /**
     *  Creates a new marker of the given name, size and id. Returns the new
     *  instance on success, NULL otherwise. Use MarkerTracker::destroyMarker
     *  to destroy the returned Marker when it is no longer needed.
     */   
    virtual Marker* createFrameMarker(int markerId, const char* name,
                                    const Vuforia::Vec2F& size) = 0;

    /// Destroys a Marker 
    virtual bool destroyMarker(Marker* marker) = 0;

    /// Returns the total number of Markers that have been created.
    virtual int getNumMarkers() const = 0;

    /// Returns a pointer to a Marker object
    virtual Marker* getMarker(int idx) const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_MARKER_TRACKER_H_
