/*==============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    EyewearCalibrationProfileManager.h

@brief
    Header file for EyewearCalibrationProfileManager class.
==============================================================================*/

#ifndef _QCAR_EYEWEAR_CALIBRATION_PROFILE_MANAGER_H_
#define _QCAR_EYEWEAR_CALIBRATION_PROFILE_MANAGER_H_

#include <QCAR/NonCopyable.h>
#include <QCAR/Matrices.h>
#include <QCAR/EyeID.h>

namespace QCAR
{

/// Class that provides functionality to manage calibration profiles for see-through devices.
/**
 *
 * <br><b>This API is only supported in the Vuforia SDK for Digital %Eyewear.</b><br><br>
 *
 * AR calibration for see-through devices is specific to the user and device,
 * this class provides functionality to manage multiple user calibration profiles.
 * 
 * - Calibration profiles are numbered 0 (the fixed default profile) and then
 *   user defined profiles 1 to \link getMaxCount() \endlink.
 *   At present the SDK supports a maximum of 10 user profiles.
 * 
 * - A default profile is always present and has the special profile ID of 0.
 *
 * - The stored calibration for a profile is retrieved by a call to 
 *   Eyewear.getProjectionMatrix.
 *
 * - An active profile can be set (see \link setActiveProfile \endlink) after
 *   which the calibration data for that profile will be returned by default
 *   when calling Eyewear.getProjectionMatrix.
 */
class QCAR_API EyewearCalibrationProfileManager : private NonCopyable
{
public:

    /// Get the number of profile slots provided.
    /**
     * At present the SDK supports a maximum of 10 user profiles, this may
     * change in future SDK releases.
     */
    virtual int getMaxCount() const = 0;

    /// Get the number of user calibration profiles stored.
    /**
     * Use this method when building a profile selection UI to get the number of
     * profiles that the user can select from.
     * \return a number between 0 and \link getMaxCount() \endlink.
     */
    virtual int getUsedCount() const = 0;

    /// Returns true if the specified profile slot contains data.
    virtual bool isProfileUsed(const int profileID) const = 0;

    /// Get the ID of the active user calibration profile.
    /**
     * \return a number between 0 and \link getMaxCount() \endlink.
     */
    virtual int getActiveProfile() const = 0;

    /// Set a calibration profile as active.
    /**
     * \param profileID a number between 1  and \link getMaxCount() \endlink.
     * \return true if the active profile is changed, false otherwise (e.g. if the specified profile is not valid)
     */
    virtual bool setActiveProfile(const int profileID) = 0;
    
    /// Get the projection matrix for the specified profile and eye.
    /**
     * \param profileID a number between 0  and \link getMaxCount() \endlink.
     * \param eyeID the Eye to retrieve the projection matrix for, one of \link EYEID_MONOCULAR  \endlink, \link EYEID_LEFT \endlink or \link EYEID_RIGHT \endlink.
     * \return the stored projection matrix, will contain all 0's if no data is stored for the profile.
     */
    virtual Matrix44F getProjectionMatrix(const int profileID, const EYEID eyeID) const = 0;

    /// Store a projection matrix to a calibration profile.
    /**
     * \param profileID a number between 1  and \link getMaxCount() \endlink.
     * \param eyeID the Eye that this projection matrix is calibrated for, one of \link EYEID_MONOCULAR  \endlink, \link EYEID_LEFT \endlink or \link EYEID_RIGHT \endlink.
     * \param projectionMatrix the projection matrix to store
     * \return true if the new projection matrix was stored successfully, false otherwise.
     */
    virtual bool setProjectionMatrix(const int profileID, const EYEID eyeID, const Matrix44F& projectionMatrix) = 0;

    /// Get the display name associated with a profile.
    /**
     * \return a unicode string, if no display name has been provided for the specified profile an empty string will be returned.
     */
    virtual const UInt16* getProfileName(const int profileID) const = 0;

    /// Set a display name associated with a profile.
    virtual bool setProfileName(const int profileID, const UInt16* name) = 0;

    /// Delete all stored data for the specified profile.
    /**
     * If the specified profile was the active profile then the default profile becomes active.
     */
    virtual bool clearProfile(const int profileID) = 0;
    
};

} // namespace QCAR

#endif //_QCAR_EYEWEAR_CALIBRATION_PROFILE_MANAGER_H_
