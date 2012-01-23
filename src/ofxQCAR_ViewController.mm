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
#import "ofxQCAR.h"

@implementation ofxQCAR_ViewController

- (void) initGLViewWithFrame : (CGRect)frame
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    // We are going to rotate our EAGLView by 90 degrees, so its width must be
    // equal to the screen's height, and height to width
//    CGRect viewBounds;
//    viewBounds.origin.x = 0;
//    viewBounds.origin.y = 0;
//    viewBounds.size.width = screenBounds.size.height;
//    viewBounds.size.height = screenBounds.size.width;
    
    self.glView = [ [ [ ofxQCAR_EAGLView alloc ] initWithFrame : screenBounds ] autorelease ];
    
//    CGPoint pos;
//    pos.x = screenBounds.size.width / 2;
//    pos.y = screenBounds.size.height / 2;
//    [ [ self.glView layer ] setPosition:pos ];
//    
//    CGAffineTransform rotate = CGAffineTransformMakeRotation( 90 * M_PI  / 180 );
//    self.glView.transform = rotate;
    
    [ self.view insertSubview: self.glView atIndex: 0 ];
}

-(void) lockGL {}                                           // NOT NEEDED - QCAR runs of its own timer loop.
-(void) unlockGL {}                                         // NOT NEEDED - QCAR runs of its own timer loop.
-(void) stopAnimation {}                                    // NOT NEEDED - QCAR runs of its own timer loop.
-(void) startAnimation {}                                   // NOT NEEDED - QCAR runs of its own timer loop.
-(void) setAnimationFrameInterval:(float)frameInterval {}   // NOT NEEDED - QCAR runs of its own timer loop.
-(void) setFrameRate:(float)rate {}                         // NOT NEEDED - QCAR runs of its own timer loop.

@end
