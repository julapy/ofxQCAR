/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file
    Vuforia_iOS.h

@brief
    Header file for global Vuforia methods that are specific to the iOS version.
===============================================================================*/

#ifndef _VUFORIA_VUFORIA_IOS_H_
#define _VUFORIA_VUFORIA_IOS_H_

namespace Vuforia
{

// iOS specific initialisation flags, numbered to avoid clashes with INIT_FLAGS
enum IOS_INIT_FLAGS {
    ROTATE_IOS_90  = 128,  ///< <b>iOS:</b> Rotates rendering 90 degrees
    ROTATE_IOS_180 = 256,  ///< <b>iOS:</b> Rotates rendering 180 degrees
    ROTATE_IOS_270 = 512,  ///< <b>iOS:</b> Rotates rendering 270 degrees
    ROTATE_IOS_0   = 1024  ///< <b>iOS:</b> Rotates rendering 0 degrees
};


/// Sets Vuforia initialization parameters
/**
 <b>iOS:</b> Called to set the Vuforia initialization parameters prior to calling Vuforia::init().
 Refer to the enumeration Vuforia::INIT_FLAGS and Vuforia::IOS_INIT_FLAGS for
 applicable flags.
 Returns an integer (0 on success).
 */
int VUFORIA_API setInitParameters(int flags, const char* licenseKey);
   

/// Sets the current rotation to be applied to the projection and background
/**
 <b>iOS:</b> Called to set any rotation on the Vuforia rendered video background and
 projection matrix applied to an augmentation after an auto rotation.  This is
 used for integration of Vuforia with Unity on iOS.
 See sample apps for how to handle auto-rotation on non-Unity apps.
 */
void VUFORIA_API setRotation(int rotation); 


/// Initializes Vuforia
/**
 <b>iOS:</b> Called to initialize Vuforia.  Initialization is progressive, so this function
 should be called repeatedly until it returns 100 or a negative value.
 Returns an integer representing the percentage complete (negative on error).
 */
int VUFORIA_API init();

} // namespace Vuforia

#endif //_VUFORIA_VUFORIA_IOS_H_
