/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <QuartzCore/QuartzCore.h>

#import "ARViewController.h"
#import "QCARutils.h"
#import "EAGLView.h"
#import "Texture.h"

@interface ARViewController ()
- (int)loadTextures:(NSArray *)textureList;
- (void) unloadViewData;
- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;
@end

@implementation ARViewController

@synthesize arView;
@synthesize arViewSize;

- (id)init
{
    self = [super init];
    if (self) {
        qUtils = [QCARutils getInstance];
    }
    return self;
}

- (void)dealloc
{
    [self unloadViewData];
    [super dealloc];
}


- (void) unloadViewData
{
    // undo everything created in loadView and viewDidLoad
    // called from dealloc and viewDidUnload so has to be defensive
    
    // Release the textures array
    if (textures != nil)
    {
        [textures release];
        textures = nil;
    }
    
    [qUtils destroyAR];
    
    if (arView != nil)
    {
        [arView release];
        arView = nil;
    }
    
    if (parentView != nil)
    {
        [parentView release];
        parentView = nil;
    }
}


#pragma mark --- View lifecycle ---
// Implement loadView to create a view hierarchy programmatically, without using a nib.
// Invoked when UIViewController.view is accessed for the first time.
- (void)loadView
{
    NSLog(@"ARVC: loadView");
    
    // We are going to rotate our EAGLView by 90/270 degrees as the camera's idea of orientation is different to the screen,
    // so its width must be equal to the screen's height, and height to width
    CGRect viewBounds;
    viewBounds.origin.x = 0;
    viewBounds.origin.y = 0;
    viewBounds.size.width = arViewSize.height;
    viewBounds.size.height = arViewSize.width;
    arView = [[EAGLView alloc] initWithFrame: viewBounds];
    
    // we add a parent view as EAGLView doesn't like being the immediate child of a VC
    parentView = [[UIView alloc] initWithFrame: viewBounds];
    [parentView addSubview:arView];
    self.view = parentView;
}


- (void)viewDidLoad
{
    NSLog(@"ARVC: viewDidLoad");
    
    // load the list of textures requested by the view, and tell it about them
    if (textures == nil)
        [self loadTextures:arView.textureList];
    [arView useTextures:textures];
   
    // set the view size for initialisation, and go do it...
    [qUtils createARofSize:arViewSize forDelegate:arView];
    arVisible = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ARVC: viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    // resume here as in viewWillAppear the view hasn't always been stitched into the hierarchy
    // which means QCAR won't find our EAGLView
    NSLog(@"ARVC: viewDidAppear");
    if (arVisible == NO)
        [qUtils resumeAR];
    
    arVisible = YES;    
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"ARVC: viewDidDisappear");
    if (arVisible == YES)
        [qUtils pauseAR];
    
    arVisible = NO;
}


- (void)viewDidUnload
{
    NSLog(@"ARVC: viewDidUnload");
    
    [super viewDidUnload];
    
    [self unloadViewData];
}


- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation
{
    CGPoint centre, pos;
    NSInteger rot;

    // Set the EAGLView's position (its centre) to be the centre of the window, based on orientation
    centre.x = arViewSize.width / 2;
    centre.y = arViewSize.height / 2;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"ARVC: Rotating to Portrait");
        pos = centre;
        rot = 90;
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"ARVC: Rotating to Upside Down");        
        pos = centre;
        rot = 270;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"ARVC: Rotating to Landscape Left");        
        pos.x = centre.y;
        pos.y = centre.x;
        rot = 180;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"ARParent: Rotating to Landscape Right");
        pos.x = centre.y;
        pos.y = centre.x;
        rot = 0;
    }

    arView.layer.position = pos;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rot * M_PI  / 180);
    arView.transform = rotate;  
}


#pragma mark --- Data management ---
////////////////////////////////////////////////////////////////////////////////
// Load the textures for use by OpenGL
- (int)loadTextures:(NSArray *)textureList
{
    int nErr = noErr;
    int nTextures = [textureList count];
    textures = [[NSMutableArray array] retain];
    
    @try {
        for (int i = 0; i < nTextures; ++i) {
            Texture* tex = [[[Texture alloc] init] autorelease];
            NSString* file = [textureList objectAtIndex:i];
            
            nErr = [tex loadImage:file] == YES ? noErr : 1;
            [textures addObject:tex];
            
            if (noErr != nErr) {
                break;
            }
        }
    }
    @catch (NSException* e) {
        NSLog(@"NSMutableArray addObject exception");
    }
    
    assert([textures count] == nTextures);
    if ([textures count] != nTextures) {
        nErr = 1;
    }
    
    return nErr;
}


@end
