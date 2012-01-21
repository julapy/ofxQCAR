//
//  ofxQCAREAGLView.m
//  emptyExample
//
//  Created by lukasz karluk on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ofxQCAR_EAGLView.h"
#import "ofxiPhoneExtras.h"
#import "ofxiOSWindow.h"

@implementation ofxQCAR_EAGLView

- (void)renderFrameQCAR
{
    ofxiOSWindow* iosWindow;
    iosWindow = (ofxiOSWindow*)iPhoneGetOFWindow();
    iosWindow->timerLoop();
}

@end
