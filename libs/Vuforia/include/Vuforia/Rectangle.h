/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Rectangle.h

@brief
    Header file for Rectangle class.
===============================================================================*/
#ifndef _VUFORIA_RECTANGLE_H_
#define _VUFORIA_RECTANGLE_H_

#include <Vuforia/Area.h>

namespace Vuforia
{

/// Rectangle defines a 2D rectangular area
class VUFORIA_API Rectangle : public Area
{
public:
    Rectangle();

    Rectangle(const Rectangle& other);

    Rectangle(float leftTopX, float leftTopY,
              float rightBottomX, float rightBottomY);

    virtual ~Rectangle();

    Rectangle& operator=(const Rectangle& other);

    float getLeftTopX() const;

    float getLeftTopY() const;

    float getRightBottomX() const;

    float getRightBottomY() const;

    float getWidth() const;

    float getHeight() const;

    float getAreaSize() const;

    virtual TYPE getType() const;

protected:
    float left,top,right,bottom;
};


// Integer version of the Rectangle class
class VUFORIA_API RectangleInt : public Area
{
public:
    RectangleInt();

    RectangleInt(const RectangleInt& other);

    RectangleInt(int leftTopX, int leftTopY,
        int rightBottomX, int rightBottomY);

    virtual ~RectangleInt();

    RectangleInt& operator=(const RectangleInt& other);

    int getLeftTopX() const;

    int getLeftTopY() const;

    int getRightBottomX() const;

    int getRightBottomY() const;

    int getWidth() const;

    int getHeight() const;

    int getAreaSize() const;

    virtual TYPE getType() const;

protected:
    int left,top,right,bottom;
};

} // namespace Vuforia



#endif // _VUFORIA_RECTANGLE_H_
