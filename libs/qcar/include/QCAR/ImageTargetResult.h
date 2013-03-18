/*==============================================================================
            Copyright (c) 2012-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    ImageTargetResult.h

@brief
    Header file for ImageTargetResult class.

==============================================================================*/
#ifndef _QCAR_IMAGETARGETRESULT_H_
#define _QCAR_IMAGETARGETRESULT_H_

// Include files
#include <QCAR/TrackableResult.h>
#include <QCAR/ImageTarget.h>

namespace QCAR
{

// Forward declarations:
class VirtualButtonResult;

/// Result for an ImageTarget.
class QCAR_API ImageTargetResult : public TrackableResult
{
public:

    /// Returns the corresponding Trackable that this result represents
    virtual const ImageTarget& getTrackable() const = 0;

    /// Returns the number of VirtualButtons defined for this ImageTarget
    virtual int getNumVirtualButtons() const = 0;

    /// Returns the VirtualButtonResult for a specific VirtualButton
    virtual const VirtualButtonResult* getVirtualButtonResult(int idx) const = 0;

    /// Returns the VirtualButtonResult for a specific VirtualButton
    virtual const VirtualButtonResult* getVirtualButtonResult(const char* name) const = 0;
};

} // namespace QCAR

#endif //_QCAR_IMAGETARGETRESULT_H_
