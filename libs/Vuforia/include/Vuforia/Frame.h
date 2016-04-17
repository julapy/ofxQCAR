/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Frame.h

@brief
    Header file for Frame class.
===============================================================================*/
#ifndef _VUFORIA_FRAME_H_
#define _VUFORIA_FRAME_H_

// Include files
#include <Vuforia/Vuforia.h>

namespace Vuforia
{

// Forward declarations
class Image;
class FrameData;

/// Frame is a collection of different representations of a single
/// camerasnapshot
/**
 *  A Frame object can include an arbitrary number of image representations in
 *  different formats or resolutions together with a time stamp and frame index.
 *  Frame implements the RAII pattern: A newly created frame holds
 *  new image data whereas copies of the share this data. The image data held by
 *  Frame exists as long as one or more Frame objects referencing this image
 *  data exist.
 */
class VUFORIA_API Frame
{
public:
    /// Creates a new frame
    Frame();

    /// Creates a reference to an existing frame
    Frame(const Frame& other);

    /// Destructor
    ~Frame();

    /// Thread save assignment operator
    Frame& operator=(const Frame& other);

    /// A time stamp that defines when the original camera image was shot
    /**
     *  Value in seconds representing the offset to application startup time.
     *  Independent from image creation the time stamp always refers to the time
     *  the camera image was shot.
     */
    double getTimeStamp() const;

    /// Index of the frame
    int getIndex() const;

    /// Number of images in the images-array
    unsigned int getNumImages() const;

    /// Read-only access to an image
    const Image* getImage(int idx) const;

protected:
    FrameData* mData;
};

} // namespace Vuforia

#endif // _VUFORIA_FRAME_H_
