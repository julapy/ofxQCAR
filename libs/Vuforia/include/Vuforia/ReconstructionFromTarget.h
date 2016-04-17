/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    ReconstructionFromTarget.h

@brief
    Header file for ReconstructionFromTarget class.
===============================================================================*/
#ifndef _VUFORIA_RECONSTRUCTIONFROMTARGET_H_
#define _VUFORIA_RECONSTRUCTIONFROMTARGET_H_

#include <Vuforia/Vuforia.h>
#include <Vuforia/Reconstruction.h>
#include <Vuforia/Box3D.h>
#include <Vuforia/Trackable.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/Type.h>

namespace Vuforia
{


/// A reconstruction of a plane with object(s) on top using an initialization 
/// target.
class VUFORIA_API ReconstructionFromTarget : public Reconstruction
{
public:
    /// Returns the reconstruction class' type
    static Type getClassType();

    /// Define the trackable which is used for starting smart terrain.
    /**
     *  The occluderVolume is an axis-aligned box, which defines the area 
     *  where the table is occluded by the target and its surrounding object.
     */
    virtual bool setInitializationTarget(const Trackable* trackable,
                                         const Box3D& occluderVolume) = 0;

    /// Define trackable which is used for starting smart terrain.
    /**
     *  The occluderVolume is an axis-aligned box, which defines the area 
     *  where the table is occluded by the target and its surrounding object.     
     *  offsetToOccluderPose is a pose matrix that allows to define a
     *  translational offset and rotation of the occluder volume with respect
     *  to the initialization target.
     */
    virtual bool setInitializationTarget(const Trackable* trackable,
                                         const Box3D& occluderVolume,
                                         const Matrix34F& offsetToOccluderPose) = 0;

    /// Returns the trackable used for initialization.
    /**
     *  Returns null if no initialization target has been defined.
     */
    virtual const Trackable* getInitializationTarget() const = 0;

protected:
    virtual ~ReconstructionFromTarget() {}
};


} // namespace Vuforia


#endif // _VUFORIA_RECONSTRUCTIONFROMTARGET_H_
