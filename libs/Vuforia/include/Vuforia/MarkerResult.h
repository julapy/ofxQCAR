/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    MarkerResult.h

@brief
    Header file for MarkerResult class.
===============================================================================*/
#ifndef _VUFORIA_MARKERRESULT_H_
#define _VUFORIA_MARKERRESULT_H_

// Include files
#include <Vuforia/TrackableResult.h>
#include <Vuforia/Marker.h>

namespace Vuforia
{

/// Result for a Marker.
class VUFORIA_API MarkerResult : public TrackableResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents
    virtual const Marker& getTrackable() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_MARKERRESULT_H_
