/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Mesh.h

@brief
    Header file for Mesh class.
===============================================================================*/
#ifndef _VUFORIA_MESH_H_
#define _VUFORIA_MESH_H_

#include <Vuforia/System.h>
#include <Vuforia/Vectors.h>


namespace Vuforia
{

/// A triangle mesh contains positions and optionally normals
class VUFORIA_API Mesh
{
public:

    /// Returns the number of vertices, i.e. positions and normals
    virtual int getNumVertices() const = 0;

    /// Returns true if the mesh contains positions
    virtual bool hasPositions() const = 0;

    /// Provides access to the array of positions
    virtual const Vec3F* getPositions() const = 0;
    
    /// Provides access to the array of positions
    virtual const float* getPositionCoordinates() const = 0;

    /// Returns true if the mesh contains surface normals
    virtual bool hasNormals() const = 0;

    /// Provides access to the array of surface normals
    virtual const Vec3F* getNormals() const = 0;

    /// Provides access to the array of surface normals
    virtual const float* getNormalCoordinates() const = 0;

    /// Returns true if the mesh contains texture coordinates
    virtual bool hasUVs() const = 0;

    /// Provides access to the array of texture coordinates
    virtual const Vec2F* getUVs() const = 0;

    /// Provides access to the array of texture coordinates
    virtual const float* getUVCoordinates() const = 0;

    /// Returns the number of triangles
    virtual int getNumTriangles() const = 0;

    /// Provides access to the array triangle indices
    virtual const unsigned short* getTriangles() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_MESH_H_
