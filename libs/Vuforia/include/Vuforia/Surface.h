/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Surface.h

@brief
    Header file for Surface class.
===============================================================================*/
#ifndef _VUFORIA_SURFACE_H_
#define _VUFORIA_SURFACE_H_

// Include files
#include <Vuforia/SmartTerrainTrackable.h>

namespace Vuforia
{

// Forward declarations:
class Rectangle;
class Mesh;

/// A trackable representing a dynamically expanding terrain with objects on top.
/**
 * The Surface class provides access to all data of the reconstructed ground
 * plane. It inherits from SmartTerrainTrackable where the Mesh represents the
 * overall extents of the ground plane. In addition a NavMesh represents the
 * navigable portion of that mesh with objects cut out.
 */
class VUFORIA_API Surface : public SmartTerrainTrackable
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();
    
    /// Returns the navigation mesh where the mesh boundary has been padded
    /**
     *  The mesh will change over time.
     */
    virtual const Mesh* getNavMesh() const = 0;

    /// Returns the axis-aligned bounding box of the ground mesh
    /**
     *  The bounding box will change over time.
     */
    virtual const Rectangle& getBoundingBox() const = 0;  

    /// Returns the number of indices for ground mesh boundaries
    /**
     *  Each consecutive pair of indices defines a line segment. As a whole this
     *  defines a polygon that represents the outer extents of the Surface mesh.
     *  The mesh boundaries will change over time.
     */
    virtual int getNumMeshBoundaries() const = 0;

    /// Returns the line list that represents all boundaries.
    /** 
     *  Each consecutive pair of indices defines a line segment. As a whole this
     *  defines a polygon that represents the outer extents of the Surface mesh.
     *  The indices refer to points in the mesh.
     */
    virtual const unsigned short* getMeshBoundaries() const = 0;
    
};

} // namespace Vuforia

#endif //_VUFORIA_SURFACE_H_
