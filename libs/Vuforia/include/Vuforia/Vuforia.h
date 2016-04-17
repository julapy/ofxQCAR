/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Vuforia.h

@brief
    Header file for global Vuforia methods.
===============================================================================*/
#ifndef _VUFORIA_VUFORIA_H_
#define _VUFORIA_VUFORIA_H_

// Include files
#include <Vuforia/System.h>

namespace Vuforia
{

// Forward declarations
class UpdateCallback;
class VideoSource;

/// Initialization flags
/**
 *  Use when calling init()
 */
enum INIT_FLAGS {
    GL_11 = 1,          ///< Deprecated: OpenGL ES 1.1 rendering; not supported.
    GL_20 = 2,          ///< Enables OpenGL ES 2.0 rendering
    METAL = 4,          ///< Enables Metal rendering, available on Apple platforms
};

/// Return codes for init() function
enum {
    INIT_ERROR = -1,                                ///< Error during initialization
    INIT_DEVICE_NOT_SUPPORTED = -2,                 ///< The device is not supported
    INIT_NO_CAMERA_ACCESS = -3,                     ///< Cannot access the camera
    INIT_LICENSE_ERROR_MISSING_KEY = -4,            ///< License key is missing
    INIT_LICENSE_ERROR_INVALID_KEY = -5,            ///< Invalid license key passed to SDK
    INIT_LICENSE_ERROR_NO_NETWORK_PERMANENT = -6,   ///< Unable to verify license key due to network (Permanent error)
    INIT_LICENSE_ERROR_NO_NETWORK_TRANSIENT = -7,   ///< Unable to verify license key due to network (Transient error)
    INIT_LICENSE_ERROR_CANCELED_KEY = -8,           ///< Provided key is no longer valid
    INIT_LICENSE_ERROR_PRODUCT_TYPE_MISMATCH = -9,  ///< Provided key is not valid for this product
    INIT_EXTERNAL_DEVICE_NOT_DETECTED = -10         ///< Dependent external device not detected/plugged in
};


/// Pixel encoding types
enum PIXEL_FORMAT {
    UNKNOWN_FORMAT = 0,         ///< Unknown format - default pixel type for
                                ///< undefined images
    RGB565 = 1,                 ///< A color pixel stored in 2 bytes using 5
                                ///< bits for red, 6 bits for green and 5 bits
                                ///< for blue
    RGB888 = 2,                 ///< A color pixel stored in 3 bytes using
                                ///< 8 bits each
    GRAYSCALE = 4,              ///< A grayscale pixel stored in one byte
    YUV = 8,                    ///< A color pixel stored in 12 or more bits
                                ///< using Y, U and V planes
    RGBA8888 = 16,              ///< A color pixel stored in 32 bits using 8 bits
                                ///< each and an alpha channel.
    INDEXED = 32,               ///< One byte per pixel where the value maps to
                                ///< a domain-specific range.
};


/// Use when calling setHint()
enum HINT {
    /// How many image targets to detect and track at the same time
    /**
     *  This hint tells the tracker how many image shall be processed
     *  at most at the same time. E.g. if an app will never require
     *  tracking more than two targets, this value should be set to 2.
     *  Default is: 1.
     */
    HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS = 0,

    /// How many object targets to detect and track at the same time
    /**
    *  This hint tells the tracker how many 3D objects shall be processed
    *  at most at the same time. E.g. if an app will never require
    *  tracking more than 1 target, this value should be set to 1.
    *  Default is: 1.
    */
    HINT_MAX_SIMULTANEOUS_OBJECT_TARGETS = 1,

    /// Force delayed loading for object target Dataset
    /**
    *  This hint tells the tracker to enable/disable delayed loading 
    *  of object target datasets upon first detection. 
    *  Loading time of large object dataset will be reduced 
    *  but the initial detection time of targets will increase.
    *  Please note that the hint should be set before loading 
    *  any object target dataset to be effective.
    *  To enable delayed loading set the hint value to 1.
    *  To disable delayed loading set the hint value to 0.
    *  Default is: 0.
    */
    HINT_DELAYED_LOADING_OBJECT_DATASETS = 2,
};

/// Types of storage locations for datasets
enum STORAGE_TYPE {
    STORAGE_APP,            ///< Storage private to the application
    STORAGE_APPRESOURCE,    ///< Storage for assets bundled with the
                            ///< application
    STORAGE_ABSOLUTE        ///< Helper type for specifying an absolute path
};

/// Types of coordinate system that can be used for poses.
enum COORDINATE_SYSTEM_TYPE {
    COORDINATE_SYSTEM_UNKNOWN = 0, ///< Unknown coordinate system
    COORDINATE_SYSTEM_CAMERA = 1,  ///< Pose will be relative to the camera frame of reference
    COORDINATE_SYSTEM_WORLD = 2,   ///< Pose will be relative to the world frame of reference
};

/// Deinitializes Vuforia
void VUFORIA_API deinit();


/// Sets a hint for the Vuforia SDK
/**
 *  Hints help the SDK to understand the developer's needs.
 *  However, depending on the device or SDK version the hints
 *  might not be taken into consideration.
 *  Returns false if the hint is unknown or deprecated.
 *  For a boolean value 1 means true and 0 means false.
 */
bool VUFORIA_API setHint(unsigned int hint, int value);


/// Registers an object to be called when new tracking data is available
void VUFORIA_API registerCallback(UpdateCallback* object);


/// Enables the delivery of certain pixel formats via the State object
/**
 *  Per default the state object will only contain images in formats
 *  that are required for internal processing, such as gray scale for
 *  tracking. setFrameFormat() can be used to enforce the creation of
 *  images with certain pixel formats. Notice that this might include
 *  additional overhead.
 */
bool VUFORIA_API setFrameFormat(PIXEL_FORMAT format, bool enabled);


/// Returns the number of bits used to store a single pixel of a given format
/**
 *  Returns 0 if the format is unknown.
 */
int VUFORIA_API getBitsPerPixel(PIXEL_FORMAT format);


/// Indicates whether the rendering surface needs to support an alpha channel
/// for transparency
bool VUFORIA_API requiresAlpha();


/// Returns the number of bytes for a buffer with a given size and format
/**
 *  Returns 0 if the format is unknown.
 */
int VUFORIA_API getBufferSize(int width, int height, PIXEL_FORMAT format);


/// Executes AR-specific tasks upon the onResume activity event
void VUFORIA_API onResume();


/// Executes AR-specific tasks upon the onResume activity event
void VUFORIA_API onPause();


/// Executes AR-specific tasks upon the onSurfaceCreated render surface event
void VUFORIA_API onSurfaceCreated();


/// Executes AR-specific tasks upon the onSurfaceChanged render surface event
void VUFORIA_API onSurfaceChanged(int width, int height);

} // namespace Vuforia

#endif //_VUFORIA_VUFORIA_H_
