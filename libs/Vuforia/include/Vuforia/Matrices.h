/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Matrices.h

@brief
    Header file for Matrix34F and Matrix44F structs.
===============================================================================*/
#ifndef _VUFORIA_MATRIX_H_
#define _VUFORIA_MATRIX_H_

namespace Vuforia
{

/// Matrix with 3 rows and 4 columns of float items
struct Matrix34F {
    float data[3*4];   ///< Array of matrix items
};


/// Matrix with 4 rows and 4 columns of float items
struct Matrix44F {
    float data[4*4];   ///< Array of matrix items
};

} // namespace Vuforia

#endif //_VUFORIA_MATRIX_H_
