/*==============================================================================
            Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    VideoBackgroundConfig.h

@brief
    Header file for VideoBackgroundConfig struct.

==============================================================================*/
#ifndef _QCAR_VIDEOBACKGROUNDTEXTUREINFO_H_
#define _QCAR_VIDEOBACKGROUNDTEXTUREINFO_H_

// Include files
#include <QCAR/Vectors.h>
#include <QCAR/QCAR.h>

namespace QCAR
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

} // namespace QCAR

#endif //_QCAR_VIDEOBACKGROUNDTEXTUREINFO_H_
