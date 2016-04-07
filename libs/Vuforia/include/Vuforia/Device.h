/*==============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
Device.h

@brief
Header file for Device class.
==============================================================================*/
#ifndef _VUFORIA_DEVICE_H_
#define _VUFORIA_DEVICE_H_

// parent classes
#include <Vuforia/NonCopyable.h>

// other dependencies
#include <Vuforia/Type.h>
#include <Vuforia/ViewerParameters.h>
#include <Vuforia/ViewerParametersList.h>
#include <Vuforia/RenderingPrimitives.h>

namespace Vuforia
{

/// Vuforia abstract representation of the Device (hardware) that it is running on
/**
 * This class provides for the management of the viewer that Vuforia will
 * create RenderingPrimitives for. A viewer is hardware worn by the user for
 * example a VR enclosure for a mobile phone or a dedicated eyewear device.
 */
class VUFORIA_API Device : private NonCopyable
{
public:

    enum MODE
    {
        MODE_AR = 0,    ///< Augmented Reality (AR) mode
        MODE_VR         ///< Virtual Reality (VR) mode
    };

    /// Get the singleton instance
    static Device& getInstance();

    /// Returns the Device class' type
    static Type getClassType();

    /// Returns the Device instance's type
    virtual Type getType() const = 0;

    /// Checks whether the Device instance's type equals or has been
    /// derived from a give type
    virtual bool isOfType(Type type) const = 0;

    /// Set the rendering mode to either AR (MODE_AR) or VR (MODE_VR).
    /**
     * Note: It is not possible to set the mode to AR until a CameraDevice has been initialised.
     */
    virtual bool setMode(MODE m) = 0;

    /// Get the current rendering mode.
    virtual MODE getMode() const = 0;

    /// Set the currently selected viewer to active. Updates available RenderingPrimitives.
    virtual void setViewerActive(bool active) = 0;

    /// Returns true if a viewer is active, false otherwise.
    virtual bool isViewerActive() const = 0;

    /// Get the list of ViewerParameters known to the system.
    virtual ViewerParametersList& getViewerList() = 0;

    /// Select the viewer to use, either with ViewerParameters from the ViewerParametersList or CustomViewerParameters.
    virtual bool selectViewer(const ViewerParameters& vp) = 0;

    /// Returns the ViewerParameters for the currently selected viewer.
    virtual ViewerParameters getSelectedViewer() const = 0;

    /// Set a flag to indicate that the device configuration has changed, and thus RenderingPrimitives need to be regenerated
    virtual void setConfigurationChanged() = 0;

    /// Returns a copy of the RenderingPrimitives for the current configuration
    /**
     * Each RenderingPrimitives object is immutable, and is tailored to the environment it is created in.
     * External configuration changes will require a new RenderingPrimitives object to be retrieved.<br>
     * The relevant configuration changes are:
     * - display size and/or orientation
     * - mode (AR or VR)
     * - video mode
     * - inserting the device into a viewer (indicated by Device::setViewerActive())
     *
     * Platform-specific lifecycle transitions (eg Pause/Resume) can cause the configuration to change,
     * so it is advisable to re-retrieve the RenderingPrimitives after those transitions.<br>
     * Note that this method returns a copy, which has an associated cost; performant apps should
     * avoid calling this method if the configuration has not changed.<br>
     * Note: For AR MODE the RenderingPrimitives will not be valid until a CameraDevice has been initialised.
     */
    virtual const RenderingPrimitives getRenderingPrimitives() = 0;

};

} // namespace Vuforia

#endif // _VUFORIA_DEVICE_H_
