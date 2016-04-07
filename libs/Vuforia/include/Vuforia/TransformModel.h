/*==============================================================================
Copyright (c) 2016 PTC Inc. All Rights Reserved.


Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file 
    TransformModel.h

@brief
    Header file for TransformModel class. 
==============================================================================*/
#ifndef _VUFORIA_TRANSFORM_MODEL_H_
#define _VUFORIA_TRANSFORM_MODEL_H_

#include <Vuforia/NonCopyable.h>
#include <Vuforia/Type.h>
#include <Vuforia/System.h>

namespace Vuforia
{

/// TransformModel class.
/**
*  The TransformModel define a domain specific model
*  that can be used by DeviceTracker. The Model defines 
*  specific transformation, representation of a tracked scenario.
*/
class VUFORIA_API TransformModel
{
public:

    /// Supported type for Transform model
    enum TYPE {
        TRANSFORM_MODEL_HEAD,        ///< Head Transform Model
        TRANSFORM_MODEL_HANDHELD,    ///< Handheld Transform Model
    };

    /// Returns the TransformModel instance's type
    virtual TYPE getType() const = 0;

    /// Destructor
    virtual ~TransformModel();

private:
    /// Assignment Operator
    TransformModel& operator=(const TransformModel& other);
};

} // namespace Vuforia

#endif //_VUFORIA_TRANSFORM_MODEL_H_
