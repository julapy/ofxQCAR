/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.


Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
RenderingPrimitives.h

@brief
Header file for RenderingPrimitives class.
===============================================================================*/
#ifndef _VUFORIA_RENDERING_PRIMITIVES_H_
#define _VUFORIA_RENDERING_PRIMITIVES_H_

#include <Vuforia/View.h>
#include <Vuforia/ViewList.h>
#include <Vuforia/Mesh.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/Vectors.h>
#include <Vuforia/ViewerParameters.h>

namespace Vuforia
{

/// RenderingPrimitives class
/**
 * This class provides rendering primitives to be used when building
 * virtual reality experiences with an external VR viewer.
 *
 * The transformation measurement unit used is the same as the one used
 * to define the target size (usually meters).
 */
class VUFORIA_API RenderingPrimitives
{
public:
    virtual ~RenderingPrimitives();

    /// Copy constructor
    RenderingPrimitives(const RenderingPrimitives& other);

    /// Returns the set of views available for rendering from these primitives
    virtual ViewList& getRenderingViews() const;

    /// Returns a viewport for the given display in the format (x,y, width, height)
    virtual Vec4I getViewport(VIEW viewID) const;

    /// Returns a viewport for the given display in the format (x, y, width, height) normalized between 0 and 1
    virtual Vec4F getNormalizedViewport(VIEW viewID) const;

    /// Returns the projection matrix to use for the given view and the specified coordinate system
    virtual Matrix34F getProjectionMatrix(
        VIEW viewID, COORDINATE_SYSTEM_TYPE csType) const;

    /// Returns an adjustment matrix needed to correct for the different position of display relative to the eye
    /**
     * The returned matrix is to be applied to the tracker pose matrix during rendering.
     * The adjustment matrix is in meters, if your scene is defined in another unit 
     * you will need to adjust the matrix before use.
     */
    virtual Matrix34F getEyeDisplayAdjustmentMatrix(VIEW viewID) const;

    /// Returns the projection matrix to use when projecting the video background
    virtual Matrix34F getVideoBackgroundProjectionMatrix(
        VIEW viewID, COORDINATE_SYSTEM_TYPE csType) const;

    /// Returns a simple mesh suitable for rendering a video background texture
    virtual const Mesh& getVideoBackgroundMesh(VIEW viewID) const;

    /// Returns the recommended size to use when creating a texture to apply to the distortion mesh
    virtual const Vec2I getDistortionTextureSize(VIEW viewID) const;

    /// Returns a viewport for the given input to the distortion mesh in the format (x,y, width, height)
    virtual Vec4I getDistortionTextureViewport(VIEW viewID) const;

    /// Returns a barrel distortion mesh for the given view
    virtual const Mesh& getDistortionTextureMesh(VIEW viewID) const;

protected:
    RenderingPrimitives();
    class Impl;
    Impl* mImpl;
};


} // namespace Vuforia

#endif // _VUFORIA_RENDERING_PRIMITIVES_H_
