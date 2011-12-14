//
//  MyAppDelegate.m
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppDelegate.h"
#import "MyAppViewController.h"

@implementation MyAppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ super applicationDidFinishLaunching: application ];
    
    /**
     *
     *  Below is where you insert your own UIViewController and take control of the App.
     *  In this example im creating a UINavigationController and adding it as my RootViewController to the window. (this is essential)
     *  UINavigationController is handy for managing the navigation between multiple view controllers, more info here,
     *  http://developer.apple.com/library/ios/#documentation/uikit/reference/UINavigationController_Class/Reference/Reference.html
     *
     *  I then push MyAppViewController onto the UINavigationController stack.
     *  MyAppViewController is a custom view controller with a 3 button menu.
     *
     **/
    
    self.navigationController = [ [ UINavigationController alloc ] init ];
    [ self.window setRootViewController: self.navigationController ];
    
    [ self.navigationController pushViewController : [ [ [ MyAppViewController alloc ] init ] autorelease ]
                                          animated : YES ];
    
    //--- style the UINavigationController
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.topItem.title = @"ofxiOS";
    
    return YES;
}

- (void) dealloc
{
    self.navigationController = nil;
    
    [ super dealloc ];
}

@end
