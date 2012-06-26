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

@property (nonatomic) CGSize arViewSize;

@end

@implementation ofxQCAR_ViewController

@synthesize arViewSize;

#if !(TARGET_IPHONE_SIMULATOR)

- (void)initGLViewWithFrame:(CGRect)frame {
    
    arViewSize = frame.size;
    
    // We are going to rotate our EAGLView by 90/270 degrees as the camera's idea of orientation is different to the screen,
    // so its width must be equal to the screen's height, and height to width
    CGRect viewBounds;
    viewBounds.origin.x = 0;
    viewBounds.origin.y = 0;
    viewBounds.size.width = arViewSize.width;
    viewBounds.size.height = arViewSize.height;
    
    self.glView = [[[ofxQCAR_EAGLView alloc] initWithFrame:viewBounds 
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
    // Support all orientations
    return YES;
    
    // Support both portrait orientations
    //return (UIInterfaceOrientationPortrait == interfaceOrientation ||
    //        UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
    
    // Support both landscape orientations
    //return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation ||
    //        UIInterfaceOrientationLandscapeRight == interfaceOrientation);
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
