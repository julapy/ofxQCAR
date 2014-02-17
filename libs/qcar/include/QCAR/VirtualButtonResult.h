/*==============================================================================
Copyright (c) 2012-2013 Qualcomm Connected Experiences, Inc.
All Rights Reserved.
Proprietary - Qualcomm Connected Experiences, Inc.

@file 
    VirtualButtonResult.h

@brief
    Header file for VirtualButtonResult class.
==============================================================================*/
#ifndef _QCAR_VIRTUALBUTTONRESULT_H_
#define _QCAR_VIRTUALBUTTONRESULT_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/System.h>
#include <QCAR/VirtualButton.h>

namespace QCAR
{

/// Tracking result for a VirtualButton.
class QCAR_API VirtualButtonResult : private NonCopyable
{
public:
    
    /// Returns the corresponding VirtualButton that this result represents
    virtual const VirtualButton& getVirtualButton() const = 0;

    /// Returns true if the virtual button is pressed.
    virtual bool isPressed() const = 0;

protected:
    virtual ~VirtualButtonResult()  {}
};

} // namespace QCAR

#endif //_QCAR_VIRTUALBUTTONRESULT_H_
