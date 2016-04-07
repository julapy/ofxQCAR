/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    SmartTerrainTracker.h

@brief
    Header file for SmartTerrainTracker class.
===============================================================================*/
#ifndef _VUFORIA_SMARTTERRAINTRACKER_H_
#define _VUFORIA_SMARTTERRAINTRACKER_H_

#include <Vuforia/Vuforia.h>
#include <Vuforia/NonCopyable.h>
#include <Vuforia/Trackable.h>
#include <Vuforia/SmartTerrainBuilder.h>
#include <Vuforia/SmartTerrainTrackable.h>

namespace Vuforia
{

/// 
class VUFORIA_API SmartTerrainTracker : public Tracker
{
public:

    /// Returns the tracker class' type
    static Type getClassType();
    
    /// Set the scaling factor for SmartTerrain trackables from millimeters 
    /// into scene units.
    /* 
     * The default scaling factor is 1.0.
     * Returns false if the tracker is not in the stopped state, true if the 
     * scale is non-zero and we are able to set the scale factor.
     */
    virtual bool setScaleToMillimeter(float scaleFactor) = 0;

    /// Gets the scaling factor from millimeters to scene units.
    virtual float getScaleToMillimeter() const = 0;

    /// Gets a reference to the SmartTerrainBuilder.
    virtual SmartTerrainBuilder& getSmartTerrainBuilder() = 0;
};


} // namespace Vuforia


#endif // _VUFORIA_SMARTTERRAINTRACKER_H_
