/*==============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    EyeID.h

@brief
    Header file for EyeID enum. 
==============================================================================*/
#ifndef _QCAR_EYEID_H_
#define _QCAR_EYEID_H_

namespace QCAR
{

enum EYEID
{
    EYEID_MONOCULAR = 0,    ///< Identifier for a monocular (single) eye
    EYEID_LEFT = 1,         ///< Identifier for the left eye
    EYEID_RIGHT = 2,        ///< Identifier for the right eye
};

} // namespace QCAR

#endif //_QCAR_EYEWEAR_H_
