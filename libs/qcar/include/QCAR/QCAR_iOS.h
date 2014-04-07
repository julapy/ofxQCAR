/*==============================================================================
            Copyright (c) 2010-2013 Qualcomm Connected Experiences, Inc.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary

@file
    QCAR_iOS.h

@brief
    Header file for global QCAR methods that are specific to the iOS version.

==============================================================================*/
#ifndef _QCAR_QCAR_IOS_H_
#define _QCAR_QCAR_IOS_H_

namespace QCAR
{

// iOS specific initialisation flags
enum IOS_INIT_FLAGS {
    ROTATE_IOS_90 = 4,      ///< <b>iOS:</b> Rotates rendering 90 degrees
    ROTATE_IOS_180 = 8,     ///< <b>iOS:</b> Rotates rendering 180 degrees
    ROTATE_IOS_270 = 16,    ///< <b>iOS:</b> Rotates rendering 270 degrees
    ROTATE_IOS_0 = 32       ///< <b>iOS:</b> Rotates rendering 0 degrees
};


/// Sets QCAR initialization parameters
/**
 <b>iOS:</b> Called to set the QCAR initialization parameters prior to calling QCAR::init().
 Refer to the enumeration QCAR::INIT_FLAGS and QCAR::IOS_INIT_FLAGS for
 applicable flags.
 Returns an integer (0 on success).
 */
int QCAR_API setInitParameters(int flags);
   

/// Sets the current rotation to be applied to the projection and background
/**
 <b>iOS:</b> Called to set any rotation on the QCAR rendered video background and
 projection matrix applied to an augmentation after an auto rotation.  This is
 used for integration of QCAR with Unity on iOS.
 See sample apps for how to handle auto-rotation on non-Unity apps.
 */
void QCAR_API setRotation(int rotation); 
    
/// Initializes QCAR
/**
 <b>iOS:</b> Called to initialize QCAR.  Initialization is progressive, so this function
 should be called repeatedly until it returns 100 or a negative value.
 Returns an integer representing the percentage complete (negative on error).
 */
int QCAR_API init();

} // namespace QCAR

#endif //_QCAR_QCAR_IOS_H_

