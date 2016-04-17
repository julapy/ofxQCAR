/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2013-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Word.h

@brief
    Header file for Word class.
===============================================================================*/
#ifndef _VUFORIA_WORD_H_
#define _VUFORIA_WORD_H_

// Include files
#include <Vuforia/System.h>
#include <Vuforia/Trackable.h>
#include <Vuforia/Vectors.h>
#include <Vuforia/Rectangle.h>
#include <Vuforia/Image.h>

namespace Vuforia
{

/// A Word represents a single element of writing.
class VUFORIA_API Word : public Trackable
{
public:
    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the Unicode character string for this word.
    virtual const UInt16* getStringU() const = 0;

    /// Returns the number of characters in the string excluding the null
    /// terminator.
    virtual int getLength() const = 0;

    /// Returns the number of code units in the Unicode string.
    virtual int getNumCodeUnits() const = 0;   

    /// Returns the size (width and height) of the word bounding box 
    ///(in 3D scene units).
    virtual Vec2F getSize() const = 0;

    /// Returns an image representing the bit mask of the letters in the word.
    /**
     * Each pixel in the image is represented by a byte (8-bit value).
     * A value of 255 represents an empty area, i.e. a pixel not covered 
     * by any letter of the word.
     * If a pixel is covered by a letter, then the pixel value represents 
     * the position of that letter in the word, i.e. 0 for the first character,
     * 1 for the second, 2 for the third, and so on.
     */
    virtual const Image* getMask() const = 0;

    /// Returns the bounding box of the letter at the given index.
    virtual const Rectangle* getLetterBoundingBox(int idx) const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_WORD_H_
