//
//  MenuViewController.m
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//

#import "MyAppViewController.h"
#import "ofxQCAR_ViewController.h"
#import "testApp.h"

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

    ofxQCAR_ViewController * viewController;
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        viewController = [[[ofxQCAR_ViewController alloc] initWithAppInPortraitMode:new testApp()] autorelease];
    } else if(UIInterfaceOrientationIsLandscape(orientation)) {
        viewController = [[[ofxQCAR_ViewController alloc] initWithAppInLandscapeMode:new testApp()] autorelease];
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

@end
