/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2010-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file 
    Tool.h

@brief
    Header file for global Tool functions.
===============================================================================*/
#ifndef _VUFORIA_TOOL_H_
#define _VUFORIA_TOOL_H_

// Include files
#include <Vuforia/System.h>
#include <Vuforia/Matrices.h>
#include <Vuforia/Vectors.h>

namespace Vuforia
{

// Forward declarations
class CameraCalibration;

/// Tool functions
namespace Tool
{
    /// Returns a 4x4 col-major OpenGL model-view matrix from a 3x4 Vuforia pose
    /// matrix.
    /**
     *  Vuforia uses 3x4 row-major matrices for pose data. convertPose2GLMatrix()
     *  takes such a pose matrix and returns an OpenGL compatible model-view
     *  matrix.
     */
    VUFORIA_API Matrix44F convertPose2GLMatrix(const Matrix34F& pose);

    /// Returns a 4x4 col-major OpenGL matrix from a 3x4 Vuforia matrix.
    /**
    *  Vuforia uses 3x4 row-major matrices.
    *  convert2GLMatrix() takes such a matrix and returns an OpenGL compatible matrix.
    */
    VUFORIA_API Matrix44F convert2GLMatrix(const Matrix34F& matrix34F);

    /// Returns a 4x4 col-major OpenGL perspective projection matrix from a 3x4 Vuforia perspective projection
    /// matrix.
    /**
    *  Vuforia uses 3x4 row-major matrices for perspective projection data. convertPerspectiveProjection2GLMatrix()
    *  takes such a perspective projection matrix and returns an OpenGL compatible perspective projection matrix.
    */
    VUFORIA_API Matrix44F convertPerspectiveProjection2GLMatrix(const Matrix34F& projection, float nearPlane, float farPlane);

    /// Returns an OpenGL style projection matrix.
    VUFORIA_API Matrix44F getProjectionGL(const CameraCalibration& calib,
                                       float nearPlane, float farPlane);

    /// Returns a projection matrix
    VUFORIA_API Matrix34F getProjection(const CameraCalibration& calib);

    /// Projects a 3D scene point into the camera image(device coordinates)
    /// given a pose in form of a 3x4 matrix.
    /**
     *  The projectPoint() function takes a 3D point in scene coordinates and
     *  transforms it using the given pose matrix. It then projects it into the
     *  camera image (pixel coordinates) using the given camera calibration.
     *  Note that camera coordinates are usually different from screen
     *  coordinates, since screen and camera resolution can be different.
     *  Transforming from camera to screen coordinates requires another
     *  transformation using the settings applied to the Renderer via the
     *  VideoBackgroundConfig structure.
     */
    VUFORIA_API Vec2F projectPoint(const CameraCalibration& calib,
                                const Matrix34F& pose, const Vec3F& point);

    /// Project a camera coordinate down to a plane aligned on the x-y plane with 
    /// the given pose.  Returns the offset along the plane from its origin.
    VUFORIA_API Vec2F projectPointToPlaneXY(const CameraCalibration& calib,
                                         const Matrix34F& pose, 
                                         const Vec2F& screenPoint);

    /// Multiplies two Vuforia pose matrices
    /**
     *  In order to apply a transformation A on top of a transformation B,
     *  perform: multiply(B,A).
     */
    VUFORIA_API Matrix34F multiply(const Matrix34F& matLeft,
                                const Matrix34F& matRight);

    /// Multiplies two Vuforia-style 4x4-matrices (row-major order)
    VUFORIA_API Matrix44F multiply(const Matrix44F& matLeft,
                                const Matrix44F& matRight);

    /// Multiplies 1 vector and 1 Vuforia-style 4x4-matrix (row-major order)
    VUFORIA_API Vec4F multiply(const Vec4F& vec,
                            const Matrix44F& mat);

    /// Multiplies 1 Vuforia-style 4x4-matrices (row-major order) and 1 vector
    VUFORIA_API Vec4F multiply(const Matrix44F& mat,
                            const Vec4F& vec);

    /// Multiplies two GL-style matrices (col-major order)
    VUFORIA_API Matrix44F multiplyGL(const Matrix44F& matLeft,
                                  const Matrix44F& matRight);

    /// Sets the translation part of a 3x4 pose matrix
    VUFORIA_API void setTranslation(Matrix34F& pose,
                                 const Vec3F& translation);

    /// Sets the rotation part of a 3x4 pose matrix using axis-angle as input
    /**
     *  The axis parameter defines the 3D axis around which the pose rotates.
     *  The angle parameter defines the angle in degrees for the rotation
     *  around that axis.
     */
    VUFORIA_API void setRotation(Matrix34F& pose,
                              const Vec3F& axis, float angle);

} // namespace Tool

} // namespace Vuforia

#endif //_VUFORIA_TOOL_H_
