//
//  ofxQCARViewController.h
//
//  Created by lukasz karluk on 19/01/12.
//

#import <UIKit/UIKit.h>
#import "ofxiPhoneViewController.h"

@interface ofxQCAR_ViewController : ofxiPhoneViewController {
    //
}

- (id)initWithApp:(ofxiPhoneApp *)app;
- (id)initWithAppInPortraitMode:(ofxiPhoneApp *)app;
- (id)initWithAppInLandscapeMode:(ofxiPhoneApp *)app;

- (void)handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;

@end
