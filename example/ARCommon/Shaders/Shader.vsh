/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


const char* vertexShader = MAKESTRING(
attribute vec4 vertexPosition;
attribute vec4 vertexNormal;
attribute vec2 vertexTexCoord;

varying vec2 texCoord;
varying vec4 normal;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    gl_Position = modelViewProjectionMatrix * vertexPosition;
    normal = vertexNormal;
    texCoord = vertexTexCoord;
}
);
