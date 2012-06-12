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
    EAGLContext *context;
    
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    
	NSMutableDictionary	*touchesDict;
	int touchScale;
}

@property(nonatomic, assign) id delegate;

@end

#endif