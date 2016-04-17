/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    VideoBackgroundConfig.h

@brief
    Header file for VideoBackgroundConfig struct.
===============================================================================*/
#ifndef _VUFORIA_VIDEOBACKGROUNDTEXTUREINFO_H_
#define _VUFORIA_VIDEOBACKGROUNDTEXTUREINFO_H_

// Include files
#include <Vuforia/Vectors.h>
#include <Vuforia/Vuforia.h>

namespace Vuforia
{

/// Video background configuration
struct VideoBackgroundTextureInfo
{
    /// Width and height of the video background texture in pixels
    /**
     *  Describes the size of the texture in the graphics unit
     *  depending on the particular hardware it will be a power of two
     *  value immediately after the image size
     */
    Vec2I mTextureSize;

    /// Width and height of the video background image in pixels
    /**
     *  Describe the size of the image inside the texture. This corresponds
     *  to the size of the image delivered by the camera
     */
    Vec2I mImageSize;

    /// Format of the video background image
    /**
     *  Describe the pixel format of the camera image.
     */
    PIXEL_FORMAT mPixelFormat;
};

} // namespace Vuforia

#endif //_VUFORIA_VIDEOBACKGROUNDTEXTUREINFO_H_
