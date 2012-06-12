//
//  ofxQCAREAGLView.h
//
//  Created by lukasz karluk on 19/01/12.
//

@protocol ofxQCAR_EAGLViewDelegate <NSObject>
@required
- (void) timerLoop;
@end

#if !(TARGET_IPHONE_SIMULATOR)

#import "EAGLView.h"
#import <QCAR/UIGLViewProtocol.h>
#import "ofxQCAR_Settings.h"
#import "ofxQCAR_Utils.h"

@interface ofxQCAR_EAGLView : EAGLView <UIGLViewProtocol>
{
    id <ofxQCAR_EAGLViewDelegate> delegate;
    
@private
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
    
	NSMutableDictionary	*touchesDict;
	int touchScale;
}

@property(nonatomic, assign) id delegate;

@end

#endif