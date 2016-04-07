/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    ImageTarget.h

@brief
    Header file for ImageTarget class.
===============================================================================*/
#ifndef _VUFORIA_IMAGETARGET_H_
#define _VUFORIA_IMAGETARGET_H_

// Include files
#include <Vuforia/Trackable.h>
#include <Vuforia/ObjectTarget.h>
#include <Vuforia/Vectors.h>


namespace Vuforia
{

// Forward declarations
class Area;
class VirtualButton;

/// A flat natural feature target
/**
 *  Methods to modify an ImageTarget must not be called while the
 *  corresponding DataSet is active. The dataset must be deactivated first
 *  before reconfiguring an ImageTarget.
 */
class VUFORIA_API ImageTarget : public ObjectTarget
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the number of virtual buttons defined for this ImageTarget.
    virtual int getNumVirtualButtons() const = 0;

    /// Provides write access to a specific virtual button.
    virtual VirtualButton* getVirtualButton(int idx) = 0;

    /// Provides read-only access to a specific virtual button.
    virtual const VirtualButton* getVirtualButton(int idx) const = 0;

    /// Returns a virtual button by its name
    /**
     *  Returns NULL if no virtual button with that name
     *  exists in this ImageTarget
     */
    virtual VirtualButton* getVirtualButton(const char* name) = 0;

    /// Returns a virtual button by its name
    /**
     *  Returns NULL if no virtual button with that name
     *  exists in this ImageTarget
     */
    virtual const VirtualButton* getVirtualButton(const char* name) const = 0;

    /// Creates a new virtual button and adds it to the ImageTarget
    /**
     *  Returns NULL if the corresponding DataSet is currently active.
     */
    virtual VirtualButton* createVirtualButton(const char* name, const Area& area) = 0;

    /// Removes and destroys one of the ImageTarget's virtual buttons
    /**
     *  Returns false if the corresponding DataSet is currently active.
     */
    virtual bool destroyVirtualButton(VirtualButton* button) = 0;

    /// Returns the meta data string for this ImageTarget.
    virtual const char* getMetaData() const = 0;

};

} // namespace Vuforia

#endif //_VUFORIA_IMAGETARGET_H_
