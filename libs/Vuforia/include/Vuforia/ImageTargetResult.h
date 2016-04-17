/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    ImageTargetResult.h

@brief
    Header file for ImageTargetResult class.
===============================================================================*/
#ifndef _VUFORIA_IMAGETARGETRESULT_H_
#define _VUFORIA_IMAGETARGETRESULT_H_

// Include files
#include <Vuforia/ObjectTargetResult.h>
#include <Vuforia/ImageTarget.h>

namespace Vuforia
{

// Forward declarations:
class VirtualButtonResult;

/// Result for an ImageTarget.
class VUFORIA_API ImageTargetResult : public ObjectTargetResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents
    virtual const ImageTarget& getTrackable() const = 0;

    /// Returns the number of VirtualButtons defined for this ImageTarget
    virtual int getNumVirtualButtons() const = 0;

    /// Returns the VirtualButtonResult for a specific VirtualButton
    virtual const VirtualButtonResult* getVirtualButtonResult(int idx) const = 0;

    /// Returns the VirtualButtonResult for a specific VirtualButton
    virtual const VirtualButtonResult* getVirtualButtonResult(const char* name) const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_IMAGETARGETRESULT_H_
