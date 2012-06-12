//
//  ofxQCARViewController.m
//
//  Created by lukasz karluk on 19/01/12.
//

#import "ofxQCAR_ViewController.h"
#import "ofxQCAR.h"

@implementation ofxQCAR_ViewController

#if !(TARGET_IPHONE_SIMULATOR)

- (void)initGLViewWithFrame:(CGRect)frame {
    // We are going to rotate our EAGLView by 90/270 degrees as the camera's idea of orientation is different to the screen,
    // so its width must be equal to the screen's height, and height to width
    CGRect viewBounds;
    viewBounds.origin.x = 0;
    viewBounds.origin.y = 0;
    viewBounds.size.width = [UIScreen mainScreen].bounds.size.height;
    viewBounds.size.height = [UIScreen mainScreen].bounds.size.width;
    
    self.glView = [[[ofxQCAR_EAGLView alloc] initWithFrame:viewBounds] autorelease];
    ((ofxQCAR_EAGLView*)self.glView).delegate = self;
    [self.view insertSubview:self.glView atIndex:0];
}

- (void)destroy {
    ((ofxQCAR_EAGLView*)self.glView).delegate = nil;
    [super destroy];
}

- (void)dealloc {
    ((ofxQCAR_EAGLView*)self.glView).delegate = nil;
    [super dealloc];
}

- (void)timerLoop {
    [super timerLoop];
}

- (void)lockGL {}                                           // NOT NEEDED - QCAR runs of its own timer loop.
- (void)unlockGL {}                                         // NOT NEEDED - QCAR runs of its own timer loop.
- (void)stopAnimation {}                                    // NOT NEEDED - QCAR runs of its own timer loop.
- (void)startAnimation {}                                   // NOT NEEDED - QCAR runs of its own timer loop.
- (void)setAnimationFrameInterval:(float)frameInterval {}   // NOT NEEDED - QCAR runs of its own timer loop.
- (void)setFrameRate:(float)rate {}                         // NOT NEEDED - QCAR runs of its own timer loop.

#endif

@end
