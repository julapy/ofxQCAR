/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    MultiTargetResult.h

@brief
    Header file for MultiTargetResult class.
===============================================================================*/
#ifndef _VUFORIA_MULTITARGETRESULT_H_
#define _VUFORIA_MULTITARGETRESULT_H_

// Include files
#include <Vuforia/ObjectTargetResult.h>
#include <Vuforia/MultiTarget.h>

namespace Vuforia
{

/// Result for a MultiTarget.
class VUFORIA_API MultiTargetResult : public ObjectTargetResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents
    virtual const MultiTarget& getTrackable() const = 0;

    /// Returns the number of Trackables that form this MultiTarget
    virtual int getNumPartResults() const = 0;

    // Provides access to the TrackableResult for a specific part
    virtual const TrackableResult* getPartResult(int idx) const = 0;

    // Provides access to the TrackableResult for a specific part
    virtual const TrackableResult* getPartResult(const char* name) const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_MULTITARGETRESULT_H_
