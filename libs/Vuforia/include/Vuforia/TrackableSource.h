/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    TrackableSource.h

@brief
    Header file for TrackableSource class.
===============================================================================*/
#ifndef _VUFORIA_TRACKABLESOURCE_H_
#define _VUFORIA_TRACKABLESOURCE_H_

// Include files:
#include <Vuforia/System.h>
#include <Vuforia/NonCopyable.h>

namespace Vuforia
{

/// TrackableSource
/**
 *  An opaque handle for creating a new Trackable in a DataSet.
 */
class VUFORIA_API TrackableSource : private NonCopyable
{

};

} // namespace Vuforia

#endif // _VUFORIA_TRACKABLESOURCE_H_
