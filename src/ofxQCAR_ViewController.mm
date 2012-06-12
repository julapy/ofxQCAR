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
    viewBounds.size.width = arViewSize.height;
    viewBounds.size.height = arViewSize.width;
    
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
    CGPoint centre, pos;
    NSInteger rot;
    
    // Set the EAGLView's position (its centre) to be the centre of the window, based on orientation
    centre.x = arViewSize.width / 2;
    centre.y = arViewSize.height / 2;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"ARVC: Rotating to Portrait");
        pos = centre;
        rot = 90;
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"ARVC: Rotating to Upside Down");        
        pos = centre;
        rot = 270;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"ARVC: Rotating to Landscape Left");        
        pos.x = centre.y;
        pos.y = centre.x;
        rot = 180;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"ARParent: Rotating to Landscape Right");
        pos.x = centre.y;
        pos.y = centre.x;
        rot = 0;
    }
    
    self.glView.layer.position = pos;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rot * M_PI  / 180);
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
