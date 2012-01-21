//
//  ofxQCARViewController.m
//  emptyExample
//
//  Created by lukasz karluk on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR_ViewController.h"
#import "ofxQCAR_EAGLView.h"
#import "ofxiPhoneExtras.h"

@implementation ofxQCAR_ViewController

- (void) initGLViewWithFrame : (CGRect)frame
{
    self.glView = [ [ [ ofxQCAR_EAGLView alloc ] initWithFrame : frame
                                                      andDepth : iPhoneGetOFWindow()->isDepthEnabled()
                                                         andAA : iPhoneGetOFWindow()->isAntiAliasingEnabled() 
                                                 andNumSamples : iPhoneGetOFWindow()->getAntiAliasingSampleCount() 
                                                     andRetina : iPhoneGetOFWindow()->isRetinaSupported() ] autorelease ];
    [ self.view insertSubview: self.glView atIndex: 0 ];
}

-(void) lockGL {}                                           // NOT NEEDED - QCAR runs of its own timer loop.
-(void) unlockGL {}                                         // NOT NEEDED - QCAR runs of its own timer loop.
-(void) stopAnimation {}                                    // NOT NEEDED - QCAR runs of its own timer loop.
-(void) startAnimation {}                                   // NOT NEEDED - QCAR runs of its own timer loop.
-(void) setAnimationFrameInterval:(float)frameInterval {}   // NOT NEEDED - QCAR runs of its own timer loop.
-(void) setFrameRate:(float)rate {}                         // NOT NEEDED - QCAR runs of its own timer loop.

@end
