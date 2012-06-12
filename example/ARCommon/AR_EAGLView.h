/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QCAR/UIGLViewProtocol.h>
#import "ofxQCAR_Utils.h"

@class Texture;

// structure to point to an object to be drawn
@interface Object3D : NSObject {
    unsigned int numVertices;
    const float *vertices;
    const float *normals;
    const float *texCoords;
    
    unsigned int numIndices;
    const unsigned short *indices;
    
    Texture *texture;
}

@property (nonatomic) unsigned int numVertices;
@property (nonatomic) const float *vertices;
@property (nonatomic) const float *normals;
@property (nonatomic) const float *texCoords;

@property (nonatomic) unsigned int numIndices;
@property (nonatomic) const unsigned short *indices;

@property (nonatomic, assign) Texture *texture;

@end


@class QCARutils;

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView
// subclass.  The view content is basically an EAGL surface you render your
// OpenGL scene into.  Note that setting the view non-opaque will only work if
// the EAGL surface has an alpha channel.
@interface AR_EAGLView : UIView <UIGLViewProtocol>

{
@public
    NSMutableArray *textureList; // list of textures to load
    
@protected
    ofxQCAR_Utils *qUtils; // QCAR utils class
    
    EAGLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    // The OpenGL ES names for the framebuffer and renderbuffers used to render
    // to this view.
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    
    NSMutableArray* textures;   // loaded textures
    NSMutableArray *objects3D;  // objects to draw
    BOOL renderingInited;
    
#ifndef USE_OPENGL1
    // OpenGL 2 data
    GLuint shaderProgramID;
    GLint vertexHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
#endif
}

@property (nonatomic, retain) NSMutableArray *textureList;

- (void) useTextures:(NSMutableArray *)theTextures;

// for overriding in the EAGLView subclass
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
- (void)initRendering;
- (void)initShaders;

@end
