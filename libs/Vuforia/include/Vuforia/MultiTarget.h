/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    MultiTarget.h

@brief
    Header file for MultiTarget class.
===============================================================================*/
#ifndef _VUFORIA_MULTITARGET_H_
#define _VUFORIA_MULTITARGET_H_

// Include files
#include <Vuforia/Trackable.h>
#include <Vuforia/ObjectTarget.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/Trackable.h>

namespace Vuforia
{

// Forward declarations
struct Matrix34F;

/// A set of multiple targets with a fixed spatial relation
/**
 *  Methods to modify a MultiTarget must not be called while the
 *  corresponding DataSet is active. The dataset must be deactivated first
 *  before reconfiguring a MultiTarget.
 */
class VUFORIA_API MultiTarget : public ObjectTarget
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the number of Trackables that form the MultiTarget.
    virtual int getNumParts() const = 0;

    /// Provides write access to a specific Trackable.
    /**
     *  Returns NULL if the index is invalid.
     */
    virtual Trackable* getPart(int idx) = 0;

    /// Provides read-only access to a specific Trackable.
    /**
     *  Returns NULL if the index is invalid.
     */
    virtual const Trackable* getPart(int idx) const = 0;

    /// Provides write access to a specific Trackable.
    /**
     *  Returns NULL if no Trackable with the given name exists
     *  in the MultiTarget.
     */
    virtual Trackable* getPart(const char* name) = 0;

    /// Provides read-only access to a specific Trackable.
    /**
     *  Returns NULL if no Trackable with the given name exists
     *  in the MultiTarget.
     */
    virtual const Trackable* getPart(const char* name) const = 0;

    /// Adds a Trackable to the MultiTarget.
    /**
     *  Returns the index of the new part on success.
     *  Returns -1 in case of error, e.g. when adding a Part that is already
     *  added or if the corresponding DataSet is currently active. Use the
     *  returned index to set the Part's pose via setPartPose().
     */
    virtual int addPart(Trackable* trackable) = 0;

    /// Removes a Trackable from the MultiTarget.
    /**
     *  Returns true on success.
     *  Returns false if the index is invalid or if the corresponding DataSet
     *  is currently active.
     */
    virtual bool removePart(int idx) = 0;

    /// Defines a Part's spatial offset to the MultiTarget center
    /**
     *  Per default a new Part has zero offset (no translation, no rotation).
     *  In this case the pose of the Part is identical with the pose of the
     *  MultiTarget. If there is more than one Part in a MultiTarget
     *  then at least one must have an offset, or the Parts are co-located.
     *  Returns false if the index is invalid or if the corresponding DataSet
     *  is currently active.
     */
    virtual bool setPartOffset(int idx, const Matrix34F& offset) = 0;

    /// Retrieves the spatial offset of a Part to the MultiTarget center
    /**
     *  Returns false if the Part's index is invalid.
     */
    virtual bool getPartOffset(int idx, Matrix34F& offset) const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_MULTITARGET_H_
