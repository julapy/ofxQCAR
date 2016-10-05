//
//  ofxQCAREAGLView.m
//
//  Created by lukasz karluk on 19/01/12.
//

#import "ofxQCAR_EAGLView.h"
#import "ofxQCAR.h"

@implementation ofxQCAR_EAGLView

- (void)dealloc {
    [super dealloc];
}

- (void)renderFrameQCAR {
//  Previously the glview was being drawn on the main thread.
//  But now with the Vuforia 4.2.3, this was locking up the main thread,
//  which resulted with native UI being very slow and sometime unresponsive.
//  glview is now being rendered on another thread which is managed by Vuforia.
//  Below is the old code, in case in the future it needs to be reverted.
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self drawView];
//    });
    
    [self drawView];
}

- (void)stopAnimation {
#if !(TARGET_IPHONE_SIMULATOR)    

    ofxQCAR::getInstance()->pause();
    
#else
    
    [super stopAnimation];
    
#endif
}

- (void)startAnimation {
#if !(TARGET_IPHONE_SIMULATOR)    
    
    ofxQCAR::getInstance()->resume();
    
#else
    
    [super startAnimation];

#endif
}

@end
