//
//  ofxQCARViewController.m
//
//  Created by lukasz karluk on 19/01/12.
//

#import "ofxQCAR_ViewController.h"
#import "ofxQCAR_EAGLView.h"
#import "ofxQCAR.h"

@interface ofxQCAR_ViewController() {
    //
}

@end

@implementation ofxQCAR_ViewController

#if !(TARGET_IPHONE_SIMULATOR)

- (id)initWithApp:(ofxiPhoneApp *)app {
    return [self initWithAppInPortraitMode:app];
}

- (id)initWithAppInPortraitMode:(ofxiPhoneApp *)app {
    ofxQCAR::getInstance()->setOrientation(OFX_QCAR_ORIENTATION_PORTRAIT);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return [self initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) app:app];
}

- (id)initWithAppInLandscapeMode:(ofxiPhoneApp *)app {
    ofxQCAR::getInstance()->setOrientation(OFX_QCAR_ORIENTATION_LANDSCAPE);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return [self initWithFrame:CGRectMake(0, 0, screenSize.height, screenSize.width) app:app];
}

- (id)initWithFrame:(CGRect)frame app:(ofxiPhoneApp *)app {
    
    if((self = [super init])) {
        self.glView = [[[ofxQCAR_EAGLView alloc] initWithFrame:frame andApp:app] autorelease];
        self.glView.delegate = self;
        [self.view insertSubview:self.glView atIndex:0];
        [self.glView setup];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleARViewRotation:self.interfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleARViewRotation:self.interfaceOrientation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    ofxQCAR_Orientation orientation = ofxQCAR::getInstance()->getOrientation();
    if(orientation == OFX_QCAR_ORIENTATION_PORTRAIT) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    } else if(orientation == OFX_QCAR_ORIENTATION_LANDSCAPE) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
                                         duration:(NSTimeInterval)duration {
    [self handleARViewRotation:interfaceOrientation];
}

- (void)handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation {
    
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
    
    ofxQCAR_Orientation orientation = ofxQCAR::getInstance()->getOrientation();
    if(orientation == OFX_QCAR_ORIENTATION_LANDSCAPE) {
        rot -= 90;
    }
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rot * M_PI / 180);
    
    self.glView.layer.position = centre;
    self.glView.transform = rotate;
}

#endif

@end
