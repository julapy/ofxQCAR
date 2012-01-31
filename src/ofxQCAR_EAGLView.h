//
//  ofxQCAREAGLView.h
//  emptyExample
//
//  Created by lukasz karluk on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#if !(TARGET_IPHONE_SIMULATOR)

#import "EAGLView.h"
#import <QCAR/UIGLViewProtocol.h>
#import "ofxQCAR_Settings.h"

@interface ofxQCAR_EAGLView : EAGLView <UIGLViewProtocol>
{
@private
    EAGLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    // The OpenGL ES names for the framebuffer and renderbuffers used to render
    // to this view.
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    
#ifndef USE_OPENGL1
    // OpenGL 2 data
    unsigned int shaderProgramID;
    GLint vertexHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
#endif
    
	NSMutableDictionary	*touchesDict;
	int touchScale;
}
@end

#endif