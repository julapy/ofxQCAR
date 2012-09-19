//
//  MenuViewController.m
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//

#import "MyAppViewController.h"
#import "ofxQCAR_ViewController.h"
#import "testApp.h"

@implementation MyAppViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)button1Pressed:(id)sender {
    ofxQCAR_ViewController * viewController;
    viewController = [[[ofxQCAR_ViewController alloc] initWithAppInPortraitMode:new testApp()] autorelease];
    [self launchWithQCARViewController:viewController];
}

- (IBAction)button2Pressed:(id)sender {
    ofxQCAR_ViewController * viewController;
    viewController = [[[ofxQCAR_ViewController alloc] initWithAppInLandscapeMode:new testApp()] autorelease];
    [self launchWithQCARViewController:viewController];
}

- (void)launchWithQCARViewController:(ofxQCAR_ViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
    self.navigationController.navigationBar.topItem.title = @"Qualcomm AR";
}

@end
