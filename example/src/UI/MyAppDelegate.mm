//
//  MyAppDelegate.m
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppDelegate.h"
#import "ofxQCAR_ViewController.h"
#import "testApp.h"

@implementation MyAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ super applicationDidFinishLaunching: application ];
    
    testApp *app;
    app = new testApp();
    
    ofxQCAR_ViewController *viewController;
    viewController = [[[ ofxQCAR_ViewController alloc ] initWithFrame : [[ UIScreen mainScreen ] bounds ] 
                                                                  app : app ] autorelease ];

    [ self.window addSubview: viewController.view ];
    [ self.window makeKeyAndVisible ];
    
    return YES;
}

@end

