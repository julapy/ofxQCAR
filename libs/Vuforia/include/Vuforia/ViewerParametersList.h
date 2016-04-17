/*===============================================================================
Copyright (c) 2016 PTC Inc. All Rights Reserved.

Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
ViewerParametersList.h

@brief
Header file for ViewerParametersList class.
===============================================================================*/
#ifndef _VUFORIA_VIEWER_PARAMETERS_LIST_H_
#define _VUFORIA_VIEWER_PARAMETERS_LIST_H_

#include <Vuforia/System.h>
#include <Vuforia/NonCopyable.h>
#include <Vuforia/ViewerParameters.h>

namespace Vuforia
{

/// ViewerParametersList class
/**
 * The interface to the list of ViewerParameters that can be selected.
 * The list implements STL-like iterator semantics.
 */
class VUFORIA_API ViewerParametersList : private NonCopyable
{
public:
    /// Get the list of all supported Vuforia Viewers for authoring tools
    /**
     * Intended only for use in authoring tools (e.g. Unity)
     * To get the list of viewers in a Vuforia app you should use 
     * Device.getViewerList().
     */
    static ViewerParametersList& getListForAuthoringTools();

    /// Set a filter for a 3rd party VR SDK
    /**
     * Allows the list to be filtered for a specific 3rd party SDK. 
     * Known SDKs are "GEARVR" and "CARDBOARD".
     * To return to the default list of viewers set the filter to the empty string.
     */
    virtual void setSDKFilter(const char* filter) = 0;

    /// Returns the number of items in the list.
    virtual size_t size() const = 0;

    /// Returns the item at the specified index. NULL if the index is out of range.
    virtual const ViewerParameters* get(size_t idx) const = 0;

    /// Returns ViewerParameters for the specified viewer name and manufacturer. NULL if no viewer was matched.
    virtual const ViewerParameters* get(const char* name, 
                                        const char* manufacturer) const = 0;

    /// Returns a pointer to the first item in the list.
    virtual const ViewerParameters* begin() const = 0;

    /// Returns a pointer to just beyond the last element.
    virtual const ViewerParameters* end() const = 0;

};

} // namespace Vuforia

#endif // _VUFORIA_VIEWER_PARAMETERS_LIST_H_
