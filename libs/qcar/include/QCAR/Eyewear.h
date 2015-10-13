/*==============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    Eyewear.h

@brief
    Header file for Eyewear class.
==============================================================================*/
#ifndef _QCAR_EYEWEAR_H_
#define _QCAR_EYEWEAR_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/Matrices.h>
#include <QCAR/CameraCalibration.h>
#include <QCAR/EyeID.h>
#include <QCAR/EyewearCalibrationProfileManager.h>
#include <QCAR/EyewearUserCalibrator.h>

namespace QCAR
{

/// Class that provides functionality specific to AR on Eyewear devices.
/**
 *
 * <br><b>This API is only supported in the Vuforia SDK for Digital %Eyewear.</b><br><br>
 *
 * Digital %Eyewear integration provides methods to detect and control an
 * Eyewear device and to retrieve calibration data needed to correctly
 * register augmentations with the real world.
 */
class QCAR_API Eyewear : private NonCopyable
{
public:

    /// Calibration profile ID for the current active profile.
    static const int EYEWEAR_PROFILE_ACTIVE = -1;
    /// Calibration profile ID for the default calibration.
    static const int EYEWEAR_PROFILE_DEFAULT = 0;

    enum ORIENTATION
    {
        ORIENTATION_UNDEFINED = 0,
        ORIENTATION_PORTRAIT,
        ORIENTATION_LANDSCAPE_LEFT,
        ORIENTATION_LANDSCAPE_RIGHT
    };

    /// Get the singleton instance
    static Eyewear& getInstance();

    /// Returns true if an Eyewear device is present, false otherwise.
    virtual bool isDeviceDetected() = 0;

    /// Inform Vuforia that the device has been inserted into a headset
    /**
     * <br><b>In order to use optimal camera settings you should call this
     * method before starting the camera. If the camera is already started
     * you should stop, deinitialize, initialize and restart it.</b><br>
     * Known identifier strings: "GearVR", "Cardboard"
     * \param id the identifier string for the headset (case insensitive)
     * \return true if successful, false if the detected device is a dedicated
     *         eyewear device, the camera has not been deinitialized, or no
     *         valid headset is found.
     */
    virtual bool setHeadsetPresent(const char* id) = 0;

    /// Inform Vuforia that the device has been removed from a headset.
    /**
     * \return true if successful, false if the detected device is a dedicated eyewear device.
     */
    virtual bool setHeadsetNotPresent() = 0;

    /// Returns true if the Eyewear device detected has a see-through display.
    virtual bool isSeeThru() = 0;

    /// Returns the correct screen orientation to use when rendering for the eyewear device.
    virtual ORIENTATION getScreenOrientation() = 0;

    /// Returns true if the Eyewear device has a stereo display, false otherwise.
    virtual bool isStereoCapable() = 0;

    /// Returns true if the Eyewear device is in stereo mode
    virtual bool isStereoEnabled() = 0;

    /// Returns true if the Eyewear device stereo mode is only for OpenGL content.
    /**
     * Some Eyewear devices don't support stereo for 2D (typically Android widget)
     * content. On these devices 2D content is rendered to each eye automatically
     * without the need for the app to create a split screen view. On such devices
     * this method will return true.
     */
    virtual bool isStereoGLOnly() = 0;

    /// Switch between 2D (mono) and 3D (stereo) modes on eyewear device.
    /**
     * \param enable set to true to switch to 3D (stereo) mode or false for 2D (mono) mode
     * \return true if successful or false if the device doesn't support this operation.
     */
    virtual bool setStereo(bool enable) = 0;

    /// Returns true if predictive tracking is enabled
    virtual bool isPredictiveTrackingEnabled() = 0;

    /// Turn predictive tracking on or off
    /**
     * Predictive tracking uses device sensors to predict user motion and reduce perceived latency.
     * By default predictive tracking is enabled on devices that support this enhancement.
     * \param enable set to true to enable predictive tracking or false to disable predictive tracking.
     * \return true if successful or false if the device doesn't support this operation.
     */
    virtual bool setPredictiveTracking(bool enable) = 0;

    /// Get the calibration profile manager.
    /**
     * Note: Calibration profiles are only relevant to see-through Eyewear devices.
     * \return A reference to the calibration profile manager.
     */
    virtual EyewearCalibrationProfileManager& getProfileManager() = 0;

    /// Specify the near and far planes used in the projection matrix
    /**
     * At this time these values are only used for generating the
     * projection matrix on occluded devices (video see-through).
     */
    virtual void setProjectionClippingPlanes(const CameraCalibration& cameraCalibration, float nearPlane, float farPlane) = 0;

    /// Get the projection matrix for the specified eye
    /**
     * \param eyeID the eye to get the calibrated projection matrix for, one of \link EYEID_MONOCULAR  \endlink, \link EYEID_LEFT \endlink or \link EYEID_RIGHT \endlink.
     * \param profileID the calibration profile to use, this defaults to the active profile.
     */
    virtual Matrix44F getProjectionMatrix(EYEID eyeID, int profileID = EYEWEAR_PROFILE_ACTIVE) = 0;

    /// Get an orthographic projection correct for the stereo rendering of the current device.
    /**
     * This projection is typically used for the rendering the video background.
     * When rendering for a stereo device it is common for the device to provide a surface equal
     * to the display area of each screen, the device stretches each half of the display to fill
     * each screen. However some devices provide a surface equal to the total display area for
     * both eyes and does not stretch the image. This method returns a projection corrected to be
     * appropriate to the device that the app is running on.
     */
    virtual Matrix44F getOrthographicProjectionMatrix() = 0;

    /// Gets the calibrator used for creating custom user calibration experiences
    /**
     * \return A reference to the calibrator object
     */
    virtual EyewearUserCalibrator& getCalibrator() = 0;
};

} // namespace QCAR

#endif //_QCAR_EYEWEAR_H_
