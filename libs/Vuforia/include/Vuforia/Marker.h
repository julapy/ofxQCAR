/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Marker.h

@brief
    Header file for Marker class.
===============================================================================*/
#ifndef _VUFORIA_MARKER_H_
#define _VUFORIA_MARKER_H_

// Include files
#include <Vuforia/Trackable.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

/// A rectangular marker
class VUFORIA_API Marker : public Trackable
{
public:
    /// Type of markers
    enum MARKER_TYPE
    {
        INVALID,            ///< Invalid marker type
        ID_FRAME            ///< An id-encoded marker that stores the id
                            ///< in the frame
    };

    /// Returns the Trackable class' type
    static Type getClassType();

    /// Returns the size of the marker in 3D scene units.
    virtual Vec2F getSize() const = 0;

    /// Sets a new size (in 3D scene units) for the marker.
    virtual bool setSize(const Vec2F& size) = 0;

    /// Returns the marker ID (as opposed to the trackable's id, which can be
    /// queried using getId())
    virtual int getMarkerId() const = 0;

    /// Returns the marker type (as opposed to the trackable's type, which can
    /// be queried using getType())
    virtual MARKER_TYPE getMarkerType() const = 0;
};

} // namespace Vuforia

#endif //_VUFORIA_MARKER_H_
