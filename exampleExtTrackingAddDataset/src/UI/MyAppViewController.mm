//
//  MenuViewController.m
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//

#import "MyAppViewController.h"
#import "ofxQCAR_ViewController.h"
#import "ofApp.h"

@interface MyAppViewController() {
    int orientation;
}
@end

@implementation MyAppViewController

- (id)init {
    self = [super init];
    if(self) {
        orientation = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)launchButtonPressed:(id)sender {

    if(orientation == -1) { // orientation will not be set on iOS6 and needs to be set here.
        orientation = self.interfaceOrientation;
    }
    
    ofxQCAR_ViewController * viewController;
    if((orientation) == UIInterfaceOrientationPortrait || (orientation) == UIInterfaceOrientationPortraitUpsideDown) {
        viewController = [[[ofxQCAR_ViewController alloc] initWithAppInPortraitMode:new ofApp()] autorelease];
    } else if((orientation) == UIInterfaceOrientationLandscapeLeft || (orientation) == UIInterfaceOrientationLandscapeRight) {
        viewController = [[[ofxQCAR_ViewController alloc] initWithAppInLandscapeMode:new ofApp()] autorelease];
    }

    [self.navigationController pushViewController:viewController animated:YES];
    self.navigationController.navigationBar.topItem.title = @"Qualcomm AR";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    /**
     *  orientation value is originally set to -1
     *  the very first time this method is called,
     *  is when it tries to set the orientation to
     *  the value of Supported Device Orientations.
     *  so the first value is saved,
     *  and locked off to that orientation.
     */
    if(orientation == -1) {
        orientation = toInterfaceOrientation;
        return YES;
    }
    
    return (UIInterfaceOrientation)orientation == toInterfaceOrientation;
}

#ifdef __IPHONE_6_0

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#endif

@end
