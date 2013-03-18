/*==============================================================================
            Copyright (c) 2012-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    MarkerResult.h

@brief
    Header file for MarkerResult class.

==============================================================================*/
#ifndef _QCAR_MARKERRESULT_H_
#define _QCAR_MARKERRESULT_H_

// Include files
#include <QCAR/TrackableResult.h>
#include <QCAR/Marker.h>

namespace QCAR
{

/// Result for a Marker.
class QCAR_API MarkerResult : public TrackableResult
{
public:

    /// Returns the corresponding Trackable that this result represents
    virtual const Marker& getTrackable() const = 0;

};

} // namespace QCAR

#endif //_QCAR_MARKERRESULT_H_
