/*==============================================================================
Copyright (c) 2013 Qualcomm Connected Experiences, Inc.
All Rights Reserved.
Proprietary - Qualcomm Connected Experiences, Inc.

@file 
    WordResult.h

@brief
    Header file for WordResult class.
==============================================================================*/
#ifndef _QCAR_WORDRESULT_H_
#define _QCAR_WORDRESULT_H_

// Include files
#include <QCAR/TrackableResult.h>
#include <QCAR/Word.h>
#include <QCAR/Obb2D.h>

namespace QCAR
{

/// Trackable result for a Word.
class QCAR_API WordResult : public TrackableResult
{
public:

    /// Returns the TrackableResult class' type
    static Type getClassType();

    /// Returns the corresponding Trackable that this result represents.
    virtual const Word& getTrackable() const = 0;

    /// Returns the oriented bounding box in image space of the word.
    virtual const Obb2D& getObb() const = 0;
};
    
} // namespace QCAR

#endif //_QCAR_WORDRESULT_H_
