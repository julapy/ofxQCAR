//
//  ofxQCARViewController.m
//
//  Created by lukasz karluk on 19/01/12.
//

#import "ofxQCAR_ViewController.h"
#import "ofxQCAR_EAGLView.h"
#import "ofxiPhoneExtras.h"

@interface ofxQCAR_ViewController() {
    //
}

@end

@implementation ofxQCAR_ViewController

#if !(TARGET_IPHONE_SIMULATOR)

- (void)initGLViewWithFrame:(CGRect)frame {
    
    self.glView = [[[ofxQCAR_EAGLView alloc] initWithFrame:frame 
                                                  andDepth:ofxiPhoneGetOFWindow()->isDepthEnabled()
                                                     andAA:ofxiPhoneGetOFWindow()->isAntiAliasingEnabled()
                                             andNumSamples:ofxiPhoneGetOFWindow()->getAntiAliasingSampleCount()
                                                 andRetina:ofxiPhoneGetOFWindow()->isRetinaSupported()] autorelease];
    [self.view insertSubview:self.glView atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleARViewRotation:self.interfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleARViewRotation:self.interfaceOrientation];
}

- (void)destroy {
    [super destroy];
}

- (void)dealloc {
    [super dealloc];
}

- (void)timerLoop {
    [super timerLoop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES; // Support all orientations
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
                                         duration:(NSTimeInterval)duration {
    [self handleARViewRotation:interfaceOrientation];
}

- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation {
    
    CGPoint centre;
    NSInteger rot;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        centre.x = screenSize.width * 0.5;
        centre.y = screenSize.height * 0.5;
    } else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        centre.x = screenSize.height * 0.5;
        centre.y = screenSize.width * 0.5;
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        rot = 0;
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        rot = 180;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        rot = 90;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        rot = 270;
    } else {
        return;
    }
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rot * M_PI  / 180);
    
    self.glView.layer.position = centre;
    self.glView.transform = rotate;
}

- (void)lockGL {}                                           // NOT NEEDED - QCAR runs of its own timer loop.
- (void)unlockGL {}                                         // NOT NEEDED - QCAR runs of its own timer loop.
- (void)stopAnimation {}                                    // NOT NEEDED - QCAR runs of its own timer loop.
- (void)startAnimation {}                                   // NOT NEEDED - QCAR runs of its own timer loop.
- (void)setAnimationFrameInterval:(float)frameInterval {}   // NOT NEEDED - QCAR runs of its own timer loop.
- (void)setFrameRate:(float)rate {}                         // NOT NEEDED - QCAR runs of its own timer loop.

#endif

@end
