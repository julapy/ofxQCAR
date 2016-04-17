/*==============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    EyeID.h

@brief
    Header file for EyeID enum. 
==============================================================================*/
#ifndef _VUFORIA_EYEID_H_
#define _VUFORIA_EYEID_H_

namespace Vuforia
{

enum EYEID
{
    EYEID_MONOCULAR=0,    ///< Identifier for a monocular (single) eye
    EYEID_LEFT,           ///< Identifier for the left eye
    EYEID_RIGHT,          ///< Identifier for the right eye
    EYEID_COUNT,          ///< Number of EYEID options
};

} // namespace Vuforia

#endif //_VUFORIA_EYEWEAR_H_
