/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    UpdateCallback.h

@brief
    Header file for UpdateCallback class.
===============================================================================*/
#ifndef _VUFORIA_UPDATECALLBACK_H_
#define _VUFORIA_UPDATECALLBACK_H_

// Include files
#include <Vuforia/System.h>

namespace Vuforia
{

// Forward declarations
class State;

/// UpdateCallback interface
class VUFORIA_API UpdateCallback
{
public:
    /// Called by the SDK right after tracking finishes
    virtual void Vuforia_onUpdate(State& state) = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_UPDATECALLBACK_H_
