/*===============================================================================
Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    Renderer.h

@brief
    Header file for Renderer class.
===============================================================================*/
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
 * pose data. It also exposes methods for configuring the rendering frame rate
 * in both AR and VR use cases. Some methods of the Renderer class must only be
 * called from the render thread.
 */
class QCAR_API Renderer : private NonCopyable
{
public:

    /// Application behavior aspects influencing the recommended render frame
    /// rate. Use as parameters to getRecommendedFps.
    enum FPSHINT_FLAGS
    {
        //// No FPS hint defined
        FPSHINT_NONE = 0,

        /// The application does not draw the video background (in optical see-
        /// through AR or VR mode). Do not set this flag when in video see-
        /// through AR mode.
        FPSHINT_NO_VIDEOBACKGROUND = 1 << 0,

        /// The application requests conservative power consumption to reduce
        /// heat accumulation and increase battery life. On some devices this
        /// may be at the cost of reduced application performance and decreased
        /// quality of experience.
        FPSHINT_POWER_EFFICIENCY = 1 << 1,

        /// The application uses content that requires a high rendering rate, 
        /// E.g. using smooth character animation or updating a physics engine.
        FPSHINT_FAST = 1 << 2,

        /// Default flags used by Vuforia to determine FPS settings
        FPSHINT_DEFAULT_FLAGS = FPSHINT_NONE
    };

    /// Target FPS value representing continuous rendering.
    static const int TARGET_FPS_CONTINUOUS;

    /// Returns the Renderer singleton instance.
    static Renderer& getInstance();

    /// Marks the beginning of rendering for the current frame and returns the
    /// State object.
    /**
    *  Returns the latest available State object. This state object may hold
    *  predicted Trackable poses if predicted tracking is turned on and
    *  available on the device. Please see Eyewear::setPredictiveTracking()
    *  for more details. Must only be called from the render thread.
    */
    virtual State begin() = 0;

    /// Marks the beginning of rendering for the given frame.
    /**
    *  Use this to draw a specific camera frame, rather than the latest
    *  available one. Must only be called from the render thread.
    */
    virtual void begin(State state) = 0;

    /// Draws the video background
    /**
    *  This should only be called between a begin() and end() calls.
    *  Must only be called from the render thread.
    */
    virtual bool drawVideoBackground() = 0;

    /// Marks the end of rendering for the current frame.
    /**
    *  Must only be called from the render thread.
    */
    virtual void end() = 0;

    /// Binds the video background texture to a given texture unit
    /**
    *  This should only be called between a begin() and end() calls.
    *  Must only be called from the render thread.
    */
    virtual bool bindVideoBackground(int unit) = 0;

    /// Configures the layout of the video background (location/size on screen
    virtual void setVideoBackgroundConfig(const VideoBackgroundConfig& cfg) = 0;
    
    /// Retrieves the current layout configuration of the video background
    virtual const VideoBackgroundConfig& getVideoBackgroundConfig() const = 0;

    /// Returns the texture info associated with the current video background
    virtual const VideoBackgroundTextureInfo& 
                                      getVideoBackgroundTextureInfo() = 0;

    /// Sets the texture id to use for updating video background data
    /**
    *  Use this in conjunction with bindVideoBackground. Must only be called
    *  from the render thread.
    */
    virtual bool setVideoBackgroundTextureID(int textureID) = 0;

    /// Calculate a perspective projection matrix and apply it to OpenGL
    /**
    *  Must only be called from the render thread.
    */
    virtual void setARProjection(float nearPlane, float farPlane) = 0;

    // Set a target rendering frame rate in frames per second
    /**
    *  Request a rendering frame rate that the application should target in its
    *  render loop. It is not guaranteed that the application and the device
    *  are able to deliver this frame rate. Use a fixed application setting such
    *  as '30', or '60' or query Renderer::getDefaultFps() to get
    *  a recommended fps setting from Vuforia. Use TARGET_FPS_CONTINUOUS to set
    *  continuous rendering if supported by given platform. Returns true if the 
    *  rate was set successfully, false otherwise.
    */    
    virtual bool setTargetFps(int fps) = 0;

    // Query recommended rendering frame rate based on application hints
    /**
    *  The target rendering frame rate of an AR or VR application is an
    *  important trade-off between optimal experience and device power usage.
    *  The choice is influenced by multiple parameters including device type,
    *  the active Trackers, the camera and/or sensor frame rates. Furthermore
    *  there are application specific trade offs to consider. These hints can be
    *  passed to the function as parameters (see FPS_HINT_FLAGS). For example,
    *  an application with animated content may need consistent 60 fps rendering
    *  even on a device that can only deliver poses at 30 fps. getDefaultFps 
    *  considers the device parameters as well as the application specific hints
    *  and returns a recommended frame rate. The returned value can then be set
    *  via setTargetFps. Note that getDefaultFps may return different values
    *  tuned to the active CameraDevice::Mode and active Trackers. Thus it is
    *  recommended to call this API after the application has completed the
    *  camera and tracker setup as well as when an application transitions
    *  between modes (For example when transitioning between AR to VR modes)
    */
    virtual int getRecommendedFps(int flags = FPSHINT_DEFAULT_FLAGS) const = 0;
};

} // namespace QCAR

#endif //_QCAR_RENDERER_H_
