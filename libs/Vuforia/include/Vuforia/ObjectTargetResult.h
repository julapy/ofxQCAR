/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    ObjectTarget.h

@brief
    Header file for the ObjectTargetResult class.  Exposes the result of 
    detecting and tracking a three dimensional rigid body.
===============================================================================*/

#ifndef _VUFORIA_OBJECTTARGETRESULT_H_
#define _VUFORIA_OBJECTTARGETRESULT_H_

// Include files
#include <Vuforia/TrackableResult.h>
#include <Vuforia/ObjectTarget.h>

namespace Vuforia
{

/// Result from detecting and tracking a rigid three dimensional body.
class VUFORIA_API ObjectTargetResult : public TrackableResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents
    virtual const ObjectTarget& getTrackable() const = 0;

};

} // namespace Vuforia

#endif //_VUFORIA_OBJECTTARGETRESULT_H_

