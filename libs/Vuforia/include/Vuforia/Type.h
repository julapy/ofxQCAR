/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Type.h

@brief
    Header file for Type class.
===============================================================================*/
#ifndef _VUFORIA_TYPE_H_
#define _VUFORIA_TYPE_H_

// Include files
#include <Vuforia/System.h>

namespace Vuforia
{

/// Class supporting a Vuforia-internal type system
/**
 *  The size of a Type class instance is only 16 bits, therefore
 *  it should be passed around by value for efficiency reasons.
 */
class VUFORIA_API Type
{
public:
    
    Type();
    Type(UInt16 data);

    UInt16 getData() const;

    /// Checks whether the type is an exact match with
    /// or has been derived from another type:
    bool isOfType(const Type type) const;

private:
    /// Internal type data:
    UInt16 mData;
};

} // namespace Vuforia


#endif // _VUFORIA_TYPE_H_
