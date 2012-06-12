/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#include <math.h>
#include <stdio.h>
#include "ShaderUtils.h"


namespace ShaderUtils
{
    // Print a 4x4 matrix
    void
    printMatrix(const float* mat)
    {
        for (int r = 0; r < 4; r++, mat += 4) {
            printf("%7.3f %7.3f %7.3f %7.3f", mat[0], mat[1], mat[2], mat[3]);
        }
    }
    
    
    // Print GL error information
    void
    checkGlError(const char* operation)
    { 
        for (GLint error = glGetError(); error; error = glGetError()) {
            printf("after %s() glError (0x%x)", operation, error);
        }
    }
    
    
    // Set the rotation components of a 4x4 matrix
    void
    setRotationMatrix(float angle, float x, float y, float z, 
                                   float *matrix)
    {
        double radians, c, s, c1, u[3], length;
        int i, j;
        
        radians = (angle * M_PI) / 180.0;
        
        c = cos(radians);
        s = sin(radians);
        
        c1 = 1.0 - cos(radians);
        
        length = sqrt(x * x + y * y + z * z);
        
        u[0] = x / length;
        u[1] = y / length;
        u[2] = z / length;
        
        for (i = 0; i < 16; i++) {
            matrix[i] = 0.0;
        }
        
        matrix[15] = 1.0;
        
        for (i = 0; i < 3; i++) {
            matrix[i * 4 + (i + 1) % 3] = u[(i + 2) % 3] * s;
            matrix[i * 4 + (i + 2) % 3] = -u[(i + 1) % 3] * s;
        }
        
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 3; j++) {
                matrix[i * 4 + j] += c1 * u[i] * u[j] + (i == j ? c : 0.0);
            }
        }
    }
    
    
    // Set the translation components of a 4x4 matrix
    void
    translatePoseMatrix(float x, float y, float z, float* matrix)
    {
        if (matrix) {
            // matrix * translate_matrix
            matrix[12] += (matrix[0] * x + matrix[4] * y + matrix[8]  * z);
            matrix[13] += (matrix[1] * x + matrix[5] * y + matrix[9]  * z);
            matrix[14] += (matrix[2] * x + matrix[6] * y + matrix[10] * z);
            matrix[15] += (matrix[3] * x + matrix[7] * y + matrix[11] * z);
        }
    }
    
    
    // Apply a rotation
    void
    rotatePoseMatrix(float angle, float x, float y, float z,
                                  float* matrix)
    {
        if (matrix) {
            float rotate_matrix[16];
            setRotationMatrix(angle, x, y, z, rotate_matrix);
            
            // matrix * scale_matrix
            multiplyMatrix(matrix, rotate_matrix, matrix);
        }
    }
    
    
    // Apply a scaling transformation
    void
    scalePoseMatrix(float x, float y, float z, float* matrix)
    {
        if (matrix) {
            // matrix * scale_matrix
            matrix[0]  *= x;
            matrix[1]  *= x;
            matrix[2]  *= x;
            matrix[3]  *= x;
            
            matrix[4]  *= y;
            matrix[5]  *= y;
            matrix[6]  *= y;
            matrix[7]  *= y;
            
            matrix[8]  *= z;
            matrix[9]  *= z;
            matrix[10] *= z;
            matrix[11] *= z;
        }
    }
    
    
    // Multiply the two matrices A and B and write the result to C
    void
    multiplyMatrix(float *matrixA, float *matrixB, float *matrixC)
    {
        int i, j, k;
        float aTmp[16];
        
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                aTmp[j * 4 + i] = 0.0;
                
                for (k = 0; k < 4; k++) {
                    aTmp[j * 4 + i] += matrixA[k * 4 + i] * matrixB[j * 4 + k];
                }
            }
        }
        
        for (i = 0; i < 16; i++) {
            matrixC[i] = aTmp[i];
        }
    }
    
    
    // Initialise a shader
    int
    initShader(GLenum nShaderType, const char* pszSource)
    {
        GLuint shader = glCreateShader(nShaderType);
        
        if (shader) {
            glShaderSource(shader, 1, &pszSource, NULL);
            glCompileShader(shader);
            GLint compiled = 0;
            glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
            
            if (!compiled) {
                GLint infoLen = 0;
                glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
                
                if (infoLen) {
                    char* buf = new char[infoLen];
                    glGetShaderInfoLog(shader, infoLen, NULL, buf);
                    printf("Could not compile shader %d: %s\n", shader, buf);
                    delete[] buf;
                }
            }
        }
        
        return shader;
    }
    
    
    // Create a shader program
    int
    createProgramFromBuffer(const char* pszVertexSource, const char* pszFragmentSource)
    {
        GLuint program = 0;
        GLuint vertexShader = initShader(GL_VERTEX_SHADER, pszVertexSource);
        GLuint fragmentShader = initShader(GL_FRAGMENT_SHADER, pszFragmentSource);
        
        if (vertexShader && fragmentShader) {
            program = glCreateProgram();
            
            if (program) {
                glAttachShader(program, vertexShader);
                checkGlError("glAttachShader");
                glAttachShader(program, fragmentShader);
                checkGlError("glAttachShader");
                
                glLinkProgram(program);
                GLint linkStatus;
                glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
                
                if (!GL_TRUE == linkStatus) {
                    GLint infoLen = 0;
                    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
                    
                    if (infoLen) {
                        char* buf = new char[infoLen];
                        glGetProgramInfoLog(program, infoLen, NULL, buf);
                        printf("Could not link program %d: %s\n", program, buf);
                        delete[] buf;
                    }
                }
            }
        }
        
        return program;
    }
    
    
    void
    setOrthoMatrix(float nLeft, float nRight, float nBottom, float nTop, 
                                float nNear, float nFar, float *nProjMatrix)
    {
        if (!nProjMatrix)
        {
            //         arLogMessage(AR_LOG_LEVEL_ERROR, "PLShadersExample", "Orthographic projection matrix pointer is NULL");
            return;
        }       
        
        int i;
        for (i = 0; i < 16; i++)
            nProjMatrix[i] = 0.0f;
        
        nProjMatrix[0] = 2.0f / (nRight - nLeft);
        nProjMatrix[5] = 2.0f / (nTop - nBottom);
        nProjMatrix[10] = 2.0f / (nNear - nFar);
        nProjMatrix[12] = -(nRight + nLeft) / (nRight - nLeft);
        nProjMatrix[13] = -(nTop + nBottom) / (nTop - nBottom);
        nProjMatrix[14] = (nFar + nNear) / (nFar - nNear);
        nProjMatrix[15] = 1.0f;
    }
    
}   // namespace ShaderUtils
