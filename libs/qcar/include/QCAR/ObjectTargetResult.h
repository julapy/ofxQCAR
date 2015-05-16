/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    ObjectTarget.h

@brief
    Header file for the ObjectTargetResult class.  Exposes the result of 
    detecting and tracking a three dimensional rigid body.
===============================================================================*/

#ifndef _QCAR_OBJECTTARGETRESULT_H_
#define _QCAR_OBJECTTARGETRESULT_H_

// Include files
#include <QCAR/TrackableResult.h>
#include <QCAR/ObjectTarget.h>

namespace QCAR
{

/// Result from detecting and tracking a rigid three dimensional body.
class QCAR_API ObjectTargetResult : public TrackableResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents
    virtual const ObjectTarget& getTrackable() const = 0;

};

} // namespace QCAR

#endif //_QCAR_OBJECTTARGETRESULT_H_

