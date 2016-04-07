/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.
 
@file 
    MetalRenderer.h

@brief
    Header file for Metal renderer classes.
===============================================================================*/


#ifndef _VUFORIA_METALRENDERER_H_
#define _VUFORIA_METALRENDERER_H_

// Include files
#if defined (__arm__) || (__arm64__)
#include <Metal/Metal.h>
#include <Vuforia/Renderer.h>

namespace Vuforia
{

/// Metal-specific classes

/**
*  MetalTextureData object passed to Vuforia to set the Metal texture pointer
*  to the video background texture created by the app.
*
 *  Use with Vuforia::Renderer::setVideoBackgroundTexture and in conjunction
 *  with Vuforia::Renderer::updateVideoBackgroundTexture
*/
class VUFORIA_API MetalTextureData : public TextureData
{
public:
    /**
    *  videoBackgroundTexture is a convenience that allows
    *  mVideoBackgroundTexture to be set when the object is constructed.
    */
    MetalTextureData(id<MTLTexture> videoBackgroundTexture = nil);
    ~MetalTextureData();

    virtual const void* buffer() const;

    id<MTLTexture> mVideoBackgroundTexture;
};


/**
*  MetalTextureUnit object passed to Vuforia to set the video background
*  texture unit after updating the background image data. The fragment texture
*  is set on the current render command encoder at the index specified by
*  mTextureIndex.
*
 *  Use with Vuforia::Renderer::updateVideoBackgroundTexture
*/
class VUFORIA_API MetalTextureUnit : public TextureUnit
{
public:
    /**
    *  textureIndex is a convenience that allows mTextureIndex to be
    *  set when the object is constructed.
    */
    MetalTextureUnit(int textureIndex = 0);
    ~MetalTextureUnit();

    virtual const void* buffer() const;

    int mTextureIndex;
};


/**
*  MetalRenderData object passed to Vuforia when performing Metal rendering
*  operations. Pass a pointer to the current drawable texture and a pointer
*  to a valid render command encoder encapsulated in the mData struct.
*
 *  Do not call endEncoding on the encoder before making all the Vuforia::Renderer
*  calls you require.
*
 *  After making all of your Vuforia::Renderer calls, you may call endEncoding on
 *  the encoder and pass a different encoder to Vuforia::Renderer::end, but the new
*  encoder passed to Vuforia::Renderer::end must have access to the current frame
*  buffer data in order for Vuforia to draw (blend) over it.  This means it
*  must be the same encoder that wrote the data, in which case its commands
*  will be in the buffer before Vuforia adds it commands, or a new encoder
*  that loads the data from the texture at the start of its render pass).
*
 *  Use with Vuforia::Renderer::begin and Vuforia::Renderer::end
*/
class VUFORIA_API MetalRenderData : public RenderData
{
public:
    MetalRenderData();
    ~MetalRenderData();

    virtual const void* buffer() const;

    struct {
        id<MTLTexture> drawableTexture;
        id<MTLRenderCommandEncoder> commandEncoder;
    } mData;
};

} // namespace Vuforia

#endif // (__arm__) || (__arm64__)
#endif // _VUFORIA_METALRENDERER_H_
