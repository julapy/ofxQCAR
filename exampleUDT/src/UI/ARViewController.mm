//
//  ARViewController.m
//  UserDefinedTargets
//
//  Created by Lukasz Karluk on 19/05/13.
//
//

#import "ARViewController.h"
#import "ofxQCAR.h"
#import "testApp.h"

@interface ARViewController() {
    IBOutlet UIButton * button;
}
@end

@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
}

- (void)dealloc {
    [button release];
    [super dealloc];
}

- (IBAction)saveButtonPressed:(id)sender {
    testApp * app = (testApp *)ofGetAppPtr();
    if(app->isScanning()) {
        bool bSuccess = app->saveTarget();
        if(bSuccess) {
            [button setTitle:@"SCAN" forState:UIControlStateNormal];
        }
    } else if(app->isTracking()) {
        bool bSuccess = app->scanTarget();
        if(bSuccess) {
            [button setTitle:@"SAVE" forState:UIControlStateNormal];
        }
    }
    
}

@end
