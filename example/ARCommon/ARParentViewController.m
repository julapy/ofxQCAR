/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import "ARParentViewController.h"
#import "ARViewController.h"
#import "OverlayViewController.h"

@implementation ARParentViewController

@synthesize arViewRect;

// initialisation functions set up size of managed view
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        arViewRect.size = [[UIScreen mainScreen] bounds].size;
        arViewRect.origin.x = arViewRect.origin.y = 0;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arViewRect.size = [[UIScreen mainScreen] bounds].size;
        arViewRect.origin.x = arViewRect.origin.y = 0;
    }
    return self;    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        arViewRect.size = [[UIScreen mainScreen] bounds].size;
        arViewRect.origin.x = arViewRect.origin.y = 0;
    }
    return self;    
}

- (void)dealloc
{
    [arViewController release];
    [overlayViewController release];
    [parentView release];
    [super dealloc];
}

- (void) loadView
{
    NSLog(@"ARParentVC: creating");
    parentView = [[UIView alloc] initWithFrame:arViewRect];
    
    // Add the EAGLView and the overlay view to the window
    arViewController = [[ARViewController alloc] init];
    
    // need to set size here to setup camera image size for AR
    arViewController.arViewSize = arViewRect.size;
    [parentView addSubview:arViewController.view];
    
    // Create an auto-rotating overlay view and its view controller (used for
    // displaying UI objects, such as the camera control menu)
    overlayViewController = [[OverlayViewController alloc] init];
    [parentView addSubview: overlayViewController.view];
    
    self.view = parentView;
}

- (void)viewDidLoad
{
    NSLog(@"ARParentVC: loading");
    // it's important to do this from here as arViewController has the wrong idea of orientation
    [arViewController handleARViewRotation:self.interfaceOrientation];
    // we also have to set the overlay view to the correct width/height for the orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
}


- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@"ARParentVC: appearing");
    // make sure we're oriented/sized properly before reappearing/restarting
    [arViewController handleARViewRotation:self.interfaceOrientation];
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    [arViewController viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated 
{
    NSLog(@"ARParentVC: appeared");
    [arViewController viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"ARParentVC: dissappeared");
    [arViewController viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Support all orientations
    return YES;
    
    // Support both portrait orientations
    //return (UIInterfaceOrientationPortrait == interfaceOrientation ||
    //        UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);

    // Support both landscape orientations
    //return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation ||
    //        UIInterfaceOrientationLandscapeRight == interfaceOrientation);
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // ensure overlay size and AR orientation is correct for screen orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    [arViewController handleARViewRotation:interfaceOrientation];
}


// touch handlers
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    if (1 == [touch tapCount])
    {
        // Show camera control action sheet
        [overlayViewController showOverlay];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}

@end
