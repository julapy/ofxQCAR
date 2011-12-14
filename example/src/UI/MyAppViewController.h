//
//  MenuViewController.h
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ofMain.h"

@interface MyAppViewController : UIViewController

- (UIButton*) makeButtonWithFrame : (CGRect)frame 
                          andText : (NSString*)text;

- (void) creatApp : (ofBaseApp*)app withFrame : (CGRect)rect;

@end
