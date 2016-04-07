/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Prop.h

@brief
    Header file for Prop class.
===============================================================================*/
#ifndef _VUFORIA_PROP_H_
#define _VUFORIA_PROP_H_

// Include files
#include <Vuforia/SmartTerrainTrackable.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

// Forward declarations:
class Obb3D;
class Mesh;

/// A trackable that refers to an unknown object on a smart terrain Surface
/**
 * The Prop class provides access to all data of a reconstructed object,
 * including the mesh and the bounding box. It inherits from
 * SmartTerrainTrackable where the Mesh represents the overall extents of
 * the ground plane.
 */
class VUFORIA_API Prop : public SmartTerrainTrackable
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Get the axis-aligned bounding box of the Prop. 
    /**
     *  The bounding box will change over time.
     */
    virtual const Obb3D& getBoundingBox() const = 0;

    /// Get the local 2D position relative to the parent SmartTerrainTrackable
    virtual const Vec2F& getLocalPosition() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_PROP_H_
