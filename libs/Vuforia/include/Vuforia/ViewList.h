/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Confidential and Proprietary - Protected under copyright and other laws.
Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
ViewList.h

@brief
Header file for ViewList class.
==============================================================================*/
#ifndef _VUFORIA_VIEWLIST_H_
#define _VUFORIA_VIEWLIST_H_

#include <Vuforia/NonCopyable.h>
#include <Vuforia/View.h>

namespace Vuforia
{

/// ViewList class
/**
 * Contains the list of views to iterate over in a rendering loop.
 */
class VUFORIA_API ViewList
{
public:
    /// Returns the number of views in this list.
    virtual const size_t getNumViews() const = 0;

    /// Returns the VIEW at the specified index.
    virtual const VIEW getView(int idx) const = 0;

    /// Returns true if this list contains the specified VIEW.
    virtual const bool contains(VIEW view) const = 0;
};

} // namespace Vuforia

#endif // _VUFORIA_VIEWLIST_H_
