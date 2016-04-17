/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    VirtualButtonResult.h

@brief
    Header file for VirtualButtonResult class.
===============================================================================*/
#ifndef _VUFORIA_VIRTUALBUTTONRESULT_H_
#define _VUFORIA_VIRTUALBUTTONRESULT_H_

// Include files
#include <Vuforia/NonCopyable.h>
#include <Vuforia/System.h>
#include <Vuforia/VirtualButton.h>

namespace Vuforia
{

/// Tracking result for a VirtualButton.
class VUFORIA_API VirtualButtonResult : private NonCopyable
{
public:
    
    /// Returns the corresponding VirtualButton that this result represents
    virtual const VirtualButton& getVirtualButton() const = 0;

    /// Returns true if the virtual button is pressed.
    virtual bool isPressed() const = 0;

protected:
    virtual ~VirtualButtonResult()  {}
};

} // namespace Vuforia

#endif //_VUFORIA_VIRTUALBUTTONRESULT_H_
