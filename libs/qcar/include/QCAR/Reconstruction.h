/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    Reconstruction.h

@brief
    Header file for Reconstruction class.
===============================================================================*/
#ifndef _QCAR_RECONSTRUCTION_H_
#define _QCAR_RECONSTRUCTION_H_

#include <QCAR/QCAR.h>
#include <QCAR/Type.h>
#include <QCAR/Rectangle.h>
#include <QCAR/NonCopyable.h>

namespace QCAR
{

/// Base interface for reconstructions with SmartTerrainBuilder in the Vuforia system.
class QCAR_API Reconstruction : private NonCopyable
{
public:

    /// Returns the reconstruction class' type
    static Type getClassType();

    /// Returns the instance's type
    virtual Type getType() const = 0;

    /// Set the maximum extent of the smart terrain in scene units
    /**
     *  The ground plane will not expand outside of this rectangle.
     *  Objects are only created inside the rectangle. Objects on the boundary
     *  of the rectangle will be cut off.
     */
    virtual bool setMaximumArea(const Rectangle& rect) = 0;

    /// Get the maximum extent of the smart terrain in scene units.
    /**
     *  Returns false if no maximum extent has been defined.
     */
    virtual bool getMaximumArea(Rectangle& rect) const = 0;

    /// Define how much the SmartTerrain ground plane mesh is diminished.
    /**
    *  Padding must be greater than or equal to 0.
    */
    virtual void setNavMeshPadding(float padding) = 0;

    /// Smart terrain reconstruction is started or continued if it was 
    /// previously stopped.
    virtual bool start() = 0;

    /// Smart terrain reconstruction is stopped, existing trackables are 
    /// still tracked.
    virtual bool stop() = 0;

    /// Resets the reconstruction, clearing out existing trackables.    
    /**
     *  The ground plane and all objects are cleared.
     *  The scene has to be scanned completely again.
     */
    virtual bool reset() = 0;

    /// Returns true if the terrain and objects are being updated
    virtual bool isReconstructing() const = 0;

protected:
    /// Destructor.
    virtual ~Reconstruction() {}
};


} // namespace QCAR


#endif // _QCAR_RECONSTRUCTION_H_
