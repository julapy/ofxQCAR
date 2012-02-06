//
//  ofxQCARViewController.m
//  emptyExample
//
//  Created by lukasz karluk on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR_ViewController.h"

@implementation ofxQCAR_ViewController

#if !(TARGET_IPHONE_SIMULATOR)

- (void) initGLViewWithFrame : (CGRect)frame
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    self.glView = [ [ [ ofxQCAR_EAGLView alloc ] initWithFrame : screenBounds ] autorelease ];
    ((ofxQCAR_EAGLView*)self.glView).delegate = self;
    
    [ self.view insertSubview: self.glView atIndex: 0 ];
}

- (void) destroy
{
    ((ofxQCAR_EAGLView*)self.glView).delegate = nil;
    
    [ super destroy ];
}

- (void) dealloc
{
    ((ofxQCAR_EAGLView*)self.glView).delegate = nil;
    
    [ super dealloc ];
}

-(void) lockGL {}                                           // NOT NEEDED - QCAR runs of its own timer loop.
-(void) unlockGL {}                                         // NOT NEEDED - QCAR runs of its own timer loop.
-(void) stopAnimation {}                                    // NOT NEEDED - QCAR runs of its own timer loop.
-(void) startAnimation {}                                   // NOT NEEDED - QCAR runs of its own timer loop.
-(void) setAnimationFrameInterval:(float)frameInterval {}   // NOT NEEDED - QCAR runs of its own timer loop.
-(void) setFrameRate:(float)rate {}                         // NOT NEEDED - QCAR runs of its own timer loop.

#endif

@end
