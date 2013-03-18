/*==============================================================================
            Copyright (c) 2012-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    MultiTargetResult.h

@brief
    Header file for MultiTargetResult class.

==============================================================================*/
#ifndef _QCAR_MULTITARGETRESULT_H_
#define _QCAR_MULTITARGETRESULT_H_

// Include files
#include <QCAR/TrackableResult.h>
#include <QCAR/MultiTarget.h>

namespace QCAR
{

/// Result for a MultiTarget.
class QCAR_API MultiTargetResult : public TrackableResult
{
public:

    /// Returns the corresponding Trackable that this result represents
    virtual const MultiTarget& getTrackable() const = 0;

    /// Returns the number of Trackables that form this MultiTarget
    virtual int getNumPartResults() const = 0;

    // Provides access to the TrackableResult for a specific part
    virtual const TrackableResult* getPartResult(int idx) const = 0;

    // Provides access to the TrackableResult for a specific part
    virtual const TrackableResult* getPartResult(const char* name) const = 0;
};

} // namespace QCAR

#endif //_QCAR_MULTITARGETRESULT_H_
