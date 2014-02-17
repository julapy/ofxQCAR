/*==============================================================================
Copyright (c) 2010-2013 Qualcomm Connected Experiences, Inc.
All Rights Reserved.
Proprietary - Qualcomm Connected Experiences, Inc.

@file 
    VideoMode.h

@brief
    Header file for VideoMode struct.
==============================================================================*/
#ifndef _QCAR_VIDEOMODE_H_
#define _QCAR_VIDEOMODE_H_

namespace QCAR
{

/// Implements access to the phone's built-in camera
struct VideoMode
{

    VideoMode() : mWidth(0), mHeight(0), mFramerate(0.f) {}

    int mWidth;       ///< Video frame width
    int mHeight;      ///< Video frame height
    float mFramerate; ///< Video frame rate
};

} // namespace QCAR

#endif // _QCAR_VIDEOMODE_H_
