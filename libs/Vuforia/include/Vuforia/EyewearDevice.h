/*===============================================================================
Copyright (c) 2016 PTC Inc. All Rights Reserved.

Confidential and Proprietary - Protected under copyright and other laws.
Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
EyewearDevice.h

@brief
Header file for EyewearDevice class.
==============================================================================*/
#ifndef _VUFORIA_EYEWEAR_DEVICE_H_
#define _VUFORIA_EYEWEAR_DEVICE_H_

// parent classes
#include <Vuforia/Device.h>

// other dependencies
#include <Vuforia/EyewearCalibrationProfileManager.h>
#include <Vuforia/EyewearUserCalibrator.h>

namespace Vuforia
{

/// Specialization of Device which is provided when Vuforia is running on a dedicated Eyewear device.
class VUFORIA_API EyewearDevice : public Device
{
public:
    /// Device orientation
    enum ORIENTATION
    {
        ORIENTATION_UNDEFINED = 0,  ///< The device's orientation is undefined.
        ORIENTATION_PORTRAIT,       ///< The device orientation is portrait
        ORIENTATION_LANDSCAPE_LEFT, ///< The device orientation is landscape rotated left from portrait
        ORIENTATION_LANDSCAPE_RIGHT ///< The device orientation is landscape rotated right from portrait
    };

    /// Returns the EyewearDevice class' type
    static Type getClassType();

    /// Returns true if the Eyewear device detected has a see-through display.
    virtual bool isSeeThru() const = 0;

    /// Returns true if the Eyewear device has a display for each eye (i.e. stereo), false otherwise.
    virtual bool isDualDisplay() const = 0;

    /// Switch between 2D (duplication/mono) and 3D (extended/stereo) modes on eyewear device.
    /**
     * \param enable set to true to switch to 3D (stereo) mode or false for 2D (mono) mode
     * \return true if successful or false if the device doesn't support this operation.
     */
    virtual bool setDisplayExtended(bool enable) = 0;

    /// Returns true if the Eyewear device display is extended across each eye
    virtual bool isDisplayExtended() const = 0;

    /// Returns true if the Eyewear device dual display mode is only for OpenGL content.
    /**
     * Some Eyewear devices don't support stereo for 2D (typically Android widget)
     * content. On these devices 2D content is rendered to each eye automatically
     * without the need for the app to create a split screen view. On such devices
     * this method will return true.
     */
    virtual bool isDisplayExtendedGLOnly() const = 0;

    /// Returns the correct screen orientation to use when rendering for the eyewear device.
    virtual ORIENTATION getScreenOrientation() const = 0;

    /// Turn predictive tracking on or off
    /**
     * Predictive tracking uses device sensors to predict user motion and reduce perceived latency.
     * By default predictive tracking is enabled on devices that support this enhancement.
     * \param enable set to true to enable predictive tracking or false to disable predictive tracking.
     * \return true if successful or false if the device doesn't support this operation.
     */
    virtual bool setPredictiveTracking(bool enable) = 0;

    /// Returns true if predictive tracking is enabled
    virtual bool isPredictiveTrackingEnabled() const = 0;

    /// Get the calibration profile manager.
    /**
     * Note: Calibration profiles are only relevant to see-through Eyewear devices.
     * \return A reference to the calibration profile manager.
     */
    virtual EyewearCalibrationProfileManager& getCalibrationProfileManager() = 0;

    /// Gets the calibrator used for creating custom user calibration experiences for see-thru eyewear.
    /**
     * \return A reference to the calibrator object
     */
    virtual EyewearUserCalibrator& getUserCalibrator() = 0;

};

} // namespace Vuforia

#endif // _VUFORIA_EYEWEAR_DEVICE_H_
