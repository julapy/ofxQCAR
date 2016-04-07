/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2013-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    WordResult.h

@brief
    Header file for WordResult class.
===============================================================================*/
#ifndef _VUFORIA_WORDRESULT_H_
#define _VUFORIA_WORDRESULT_H_

// Include files
#include <Vuforia/TrackableResult.h>
#include <Vuforia/Word.h>
#include <Vuforia/Obb2D.h>

namespace Vuforia
{

/// Trackable result for a Word.
class VUFORIA_API WordResult : public TrackableResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents.
    virtual const Word& getTrackable() const = 0;

    /// Returns the oriented bounding box in image space of the word.
    virtual const Obb2D& getObb() const = 0;
};
    
} // namespace Vuforia

#endif //_VUFORIA_WORDRESULT_H_
