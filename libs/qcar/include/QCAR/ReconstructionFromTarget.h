/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    ReconstructionFromTarget.h

@brief
    Header file for ReconstructionFromTarget class.
===============================================================================*/
#ifndef _QCAR_RECONSTRUCTIONFROMTARGET_H_
#define _QCAR_RECONSTRUCTIONFROMTARGET_H_

#include <QCAR/QCAR.h>
#include <QCAR/Reconstruction.h>
#include <QCAR/Box3D.h>
#include <QCAR/Trackable.h>
#include <QCAR/Matrices.h>
#include <QCAR/Type.h>

namespace QCAR
{


/// A reconstruction of a plane with object(s) on top using an initialization 
/// target.
class QCAR_API ReconstructionFromTarget : public Reconstruction
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


} // namespace QCAR


#endif // _QCAR_RECONSTRUCTIONFROMTARGET_H_
