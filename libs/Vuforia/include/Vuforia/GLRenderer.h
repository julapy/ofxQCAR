/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    GLRenderer.h

@brief
    Header file for GL renderer classes.
===============================================================================*/


#ifndef _VUFORIA_GLRENDERER_H_
#define _VUFORIA_GLRENDERER_H_

// Include files
#include <Vuforia/Renderer.h>

namespace Vuforia 
{

/// GL-specific classes

/**
*  GLTextureData object passed to Vuforia to set the GL texture ID of the video
*  background texture created by the app.
*
*  Use with Vuforia::Renderer::setVideoBackgroundTexture and in conjunction
*  with Vuforia::Renderer::updateVideoBackgroundTexture
*/
class VUFORIA_API GLTextureData : public TextureData
{
public:
    /**
    *  videoBackgroundTextureID is a convenience that allows
    *  mVideoBackgroundTextureID to be set when the object is constructed.
    */
    GLTextureData(int videoBackgroundTextureID = 0);
    ~GLTextureData();

    virtual const void* buffer() const;

    int mVideoBackgroundTextureID;
};


/**
*  GLTextureUnit object passed to Vuforia which binds the texture to the
*  mTextureUnit value.
*
 *  Use with Vuforia::Renderer::updateVideoBackgroundTexture
*/
class VUFORIA_API GLTextureUnit : public TextureUnit
{
public:
    /**
    *  unit is a convenience that allows mTextureUnit to be
    *  set when the object is constructed.
    */
    GLTextureUnit(int unit = 0);
    ~GLTextureUnit();

    virtual const void* buffer() const;

    int mTextureUnit;
};

} // namespace Vuforia

#endif //_VUFORIA_GLRENDERER_H_
