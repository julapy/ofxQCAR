/*===============================================================================
Copyright (c) 2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.

@file 
    SmartTerrainTrackable.h

@brief
    Header file for SmartTerrainSmartTerrainTrackable class.
===============================================================================*/
#ifndef _QCAR_SMARTTERRAINTRACKABLE_H_
#define _QCAR_SMARTTERRAINTRACKABLE_H_

// Include files
#include <QCAR/Trackable.h>

namespace QCAR
{

// Forward declarations:
class Rectangle;
class Mesh;

/// The base class of all SmartTerrain trackables 
/**
 * The SmartTerrainTrackable class represents any trackable that is
 *  reconstructed  and tracked by the SmartTerrainTracker. It provides access
 *  to all common properties. SmartTerrainTrackables are reconstructed in an
 *  object graph. Elements of this hierarchy are the derived classes
 *  Surface and Prop. A Surface represents navigable ground plane and may 
 *  have multiple Prop child objects that represent objects on this plane.
 */
class QCAR_API SmartTerrainTrackable : public Trackable
{
public:

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the mesh that represents this SmartTerrainTrackable
    /**
     *  The mesh represents either a ground Surface or a Prop on top of the
     *  Surface depending on the derived class. The mesh will change over time.
     */
    virtual const Mesh* getMesh() const = 0;
    
    /// Returns the mesh revision, which is increased on every geometry update
    virtual int getRevision() const = 0;

    /// Get the local pose relative to the parent SmartTerrainTrackable
    virtual const Matrix34F& getLocalPose() const = 0;

    /// Returns the parent SmartTerrainTrackable
    /**
     *  Returns NULL if this is the root object
     */
    virtual const SmartTerrainTrackable* getParent() const = 0;

    /// Returns the number of SmartTerrainTrackable child objects
    virtual unsigned int getChildrenCount() const = 0;

    /// Returns the SmartTerrainTrackable child object at at the given index
    /**
     *  Returns NULL if the index is invalid.
     */
    virtual const SmartTerrainTrackable* getChild(unsigned int idx) const = 0;
};

} // namespace QCAR

#endif //_QCAR_SMARTTERRAINTRACKABLE_H_
