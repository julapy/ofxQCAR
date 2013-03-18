/*==============================================================================
            Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    Renderer.h

@brief
    Header file for Renderer class.

==============================================================================*/
#ifndef _QCAR_RENDERER_H_
#define _QCAR_RENDERER_H_

// Include files
#include <QCAR/Matrices.h>
#include <QCAR/Vectors.h>
#include <QCAR/State.h>
#include <QCAR/NonCopyable.h>
#include <QCAR/QCAR.h>

namespace QCAR 
{

// Forward declarations
class State;
struct VideoBackgroundConfig;
struct VideoBackgroundTextureInfo;

/// Renderer class
/**
 * The Renderer class provides methods to fulfill typical AR related tasks
 * such as rendering the video background and 3D objects with up to date
 * pose data. Methods of the Renderer class must only be called from the render
 * thread.
 */
class QCAR_API Renderer : private NonCopyable
{
public:
    /// Returns the Renderer singleton instance.
    static Renderer& getInstance();

    /// Marks the beginning of rendering for the current frame and returns the
    /// State object.
    virtual State begin() = 0;

    /// Draws the video background
    /// This should only be called between a begin() and end() calls
    virtual bool drawVideoBackground() = 0;

    /// Marks the end of rendering for the current frame.
    virtual void end() = 0;

    /// Binds the video background texture to a given texture unit
    /// This should only be called between a begin() and end() calls
    virtual bool bindVideoBackground(int unit) = 0;

    /// Configures the layout of the video background (location on the screen
    /// and size).
    virtual void setVideoBackgroundConfig(const VideoBackgroundConfig& cfg) = 0;
    
    /// Retrieves the current layout configuration of the video background.
    virtual const VideoBackgroundConfig& getVideoBackgroundConfig() const = 0;

    /// Returns the texture info associated with the current video background
    virtual const VideoBackgroundTextureInfo& 
                                      getVideoBackgroundTextureInfo() = 0;

    /// Tells QCAR where the texture id to use for updating video
    /// background data
    virtual bool setVideoBackgroundTextureID(int textureID) = 0;

    /// Tool method to calculate a perspective projection matrix for AR
    /// rendering and apply it to OpenGL
    virtual void setARProjection(float nearPlane, float farPlane) = 0;
};

} // namespace QCAR

#endif //_QCAR_RENDERER_H_
