/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    NonCopyable.h

@brief
    Header file for NonCopyable class.
===============================================================================*/
#ifndef _VUFORIA_NONCOPYABLE_H_
#define _VUFORIA_NONCOPYABLE_H_

// Include files
#include <Vuforia/System.h>

namespace Vuforia
{

/// Base class for objects that can not be copied
class VUFORIA_API NonCopyable
{
protected:
    NonCopyable()  {}  ///< Standard constructor
    ~NonCopyable()  {} ///< Standard destructor

private: 
    NonCopyable(const NonCopyable &);             ///< Hidden copy constructor
    NonCopyable& operator= (const NonCopyable &); ///< Hidden assignment operator
};

} // namespace Vuforia

#endif //_VUFORIA_NONCOPYABLE_H_
