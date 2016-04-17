/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Area.h

@brief
    Header file for Area class.
===============================================================================*/

#ifndef _VUFORIA_AREA_H_
#define _VUFORIA_AREA_H_

#include <Vuforia/Vuforia.h>

namespace Vuforia
{

/// Area is the base class for 2D shapes used in Vuforia
class VUFORIA_API Area
{
public:
    enum TYPE {
        RECTANGLE,
        RECTANGLE_INT,
        INVALID
    };

    virtual TYPE getType() const = 0;

    virtual ~Area();

private:
    Area& operator=(const Area& other);
};

} // namespace Vuforia


#endif // _VUFORIA_AREA_H_
