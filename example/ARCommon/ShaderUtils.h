/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#ifndef __SHADERUTILS_H__
#define __SHADERUTILS_H__


#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


namespace ShaderUtils
{
    // Print a 4x4 matrix
    void printMatrix(const float* matrix);
    
    // Print GL error information
    void checkGlError(const char* operation);
    
    // Set the rotation components of a 4x4 matrix
    void setRotationMatrix(float angle, float x, float y, float z, 
                                  float *nMatrix);
    
    // Set the translation components of a 4x4 matrix
    void translatePoseMatrix(float x, float y, float z,
                                    float* nMatrix = NULL);
    
    // Apply a rotation
    void rotatePoseMatrix(float angle, float x, float y, float z, 
                                 float* nMatrix = NULL);
    
    // Apply a scaling transformation
    void scalePoseMatrix(float x, float y, float z, 
                                float* nMatrix = NULL);
    
    // Multiply the two matrices A and B and write the result to C
    void multiplyMatrix(float *matrixA, float *matrixB, 
                               float *matrixC);
    
    // Initialise a shader
    int initShader(GLenum nShaderType, const char* pszSource);
    
    // Create a shader program
    int createProgramFromBuffer(const char* pszVertexSource,
                                       const char* pszFragmentSource);
    
    void setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop,
                        float nNear, float nFar, float *nProjMatrix);
}

#endif  // __SHADERUTILS_H__
