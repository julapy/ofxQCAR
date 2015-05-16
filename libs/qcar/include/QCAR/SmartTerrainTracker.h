/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    SmartTerrainTracker.h

@brief
    Header file for SmartTerrainTracker class.
===============================================================================*/
#ifndef _QCAR_SMARTTERRAINTRACKER_H_
#define _QCAR_SMARTTERRAINTRACKER_H_

#include <QCAR/QCAR.h>
#include <QCAR/NonCopyable.h>
#include <QCAR/Trackable.h>
#include <QCAR/SmartTerrainBuilder.h>
#include <QCAR/SmartTerrainTrackable.h>

namespace QCAR
{

/// 
class QCAR_API SmartTerrainTracker : public Tracker
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
    virtual bool setScaleToMillimeter(float scaleFactor) =0;

    /// Gets the scaling factor from millimeters to scene units.
    virtual float getScaleToMillimeter() const = 0;

    /// Gets a reference to the SmartTerrainBuilder.
    virtual SmartTerrainBuilder& getSmartTerrainBuilder() = 0;
};


} // namespace QCAR


#endif // _QCAR_SMARTTERRAINTRACKER_H_
