/*==============================================================================
Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
All Rights Reserved.
Qualcomm Confidential and Proprietary
==============================================================================*/

#import <AVFoundation/AVFoundation.h>
#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import "OverlayViewController.h"
#import "OverlayView.h"
#import "QCARutils.h"

@interface OverlayViewController (PrivateMethods)
+ (void) determineCameraCapabilities:(struct tagCameraCapabilities *) pCapabilities;
@end

@implementation OverlayViewController

- (id) init
{
    if ((self = [super init]) != nil)
    {
        selectedTarget = 0;
        qUtils = [QCARutils getInstance];
    }
        
    return self;
}


- (void)dealloc {
    [optionsOverlayView release];
    [super dealloc];
}


- (void) loadView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    optionsOverlayView = [[OverlayView alloc] initWithFrame: screenBounds];
    self.view = optionsOverlayView;
    
    // We're going to let the parent VC handle all interactions so disable any UI
    // Further on, we'll also implement a touch pass-through
    self.view.userInteractionEnabled = NO;
    
    // Get the camera capabilities
    [OverlayViewController determineCameraCapabilities:&cameraCapabilities];
}


- (void) handleViewRotation:(UIInterfaceOrientation)interfaceOrientation
{
    // adjust the size according to the rotation
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect overlayRect = screenRect;
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        overlayRect.size.width = screenRect.size.height;
        overlayRect.size.height = screenRect.size.width;
    }
    
    optionsOverlayView.frame = overlayRect;
}


// The user touched the screen - pass through
- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
    // pass events down to parent VC
    [super touchesBegan:touches withEvent:event];
}


// pop-up is invoked by parent VC
- (void) showOverlay
{
    // Show camera control action sheet
    mainOptionsAS = [[[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil] autorelease];
    
    // add torch and focus control buttons if supported by the device
    torchIx = -1;
    autofocusIx = -1;
    autofocusContIx = -1;
    int count = 0;
    
    if (YES == cameraCapabilities.torch)
    {
        // set button text according to the current mode (toggle)
        BOOL torchMode = [qUtils cameraTorchOn];
        NSString *text = YES == torchMode ? @"Torch off" : @"Torch on";
        torchIx = [mainOptionsAS addButtonWithTitle:text];
        ++count;
    }
    
    if (YES == cameraCapabilities.autofocus)
    {
        autofocusIx = [mainOptionsAS addButtonWithTitle:@"Autofocus"];
        ++count;
    }
    
    if (YES == cameraCapabilities.autofocusContinuous)
    {
        // set button text according to the current mode (toggle)
        BOOL contAFMode = [qUtils cameraContinuousAFOn];
        NSString *text = YES == contAFMode ? @"Continuous autofocus off" : @"Continuous autofocus on";
        autofocusContIx = [mainOptionsAS addButtonWithTitle:text];
        ++count;
    }
    
    // add 'select target' if there is more than one target
    selectTargetIx = -1;
    if (qUtils.targetsList && [qUtils.targetsList count] > 1)
    {
        selectTargetIx = [mainOptionsAS addButtonWithTitle:@"Select Target"];
        ++count;
    }
    
    NSInteger cancelIx = [mainOptionsAS addButtonWithTitle:@"Cancel"];
    [mainOptionsAS setCancelButtonIndex:cancelIx];
    
    if (0 < count)
    {
        self.view.userInteractionEnabled = YES;
        [mainOptionsAS showInView:self.view];
    }
}

// check to see if any content would be shown in showOverlay
+ (BOOL) doesOverlayHaveContent
{
    int count = 0;
    
    struct tagCameraCapabilities capabilities;
    [OverlayViewController determineCameraCapabilities:&capabilities];
    
    if (YES == capabilities.torch)
        ++count;
    
    if (YES == capabilities.autofocus)
        ++count;
    
    if (YES == capabilities.autofocusContinuous)
        ++count;
    
    if ([QCARutils getInstance].targetsList && [[QCARutils getInstance].targetsList count] > 1)
        ++count;
    
    return (count > 0);
}


// The user chose to select a target
- (void) targetSelectInView:(UIView *)theView
{
    targetOptionsAS = [[[UIActionSheet alloc] initWithTitle:@"Select Target"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil] autorelease];
    
    for (int i=0;i<[qUtils.targetsList count];i++)
    {
        DataSetItem *targetEntry = [qUtils.targetsList objectAtIndex:i];
        NSString *text = [(selectedTarget == i) ? @"* " : @"" stringByAppendingString:targetEntry.name];
        [targetOptionsAS addButtonWithTitle:text];
    }
    
    NSInteger cancelIx = [targetOptionsAS addButtonWithTitle:@"Cancel"];
    [targetOptionsAS setCancelButtonIndex:cancelIx];
        
    [targetOptionsAS showInView:theView];
}



// UIActionSheetDelegate event handlers

- (void) mainOptionClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == selectTargetIx)
    {
        // Select targets from here
        [self targetSelectInView:self.view];
    }
    else
    {
        if (torchIx == buttonIndex)
        {
            // toggle camera torch mode
            BOOL newTorchMode = ![qUtils cameraTorchOn];
            [qUtils cameraSetTorchMode:newTorchMode];
        }
        else if (autofocusContIx == buttonIndex)
        {
            // toggle camera continuous autofocus mode
            BOOL newContAFMode = ![qUtils cameraContinuousAFOn];
            [qUtils cameraSetContinuousAFMode:newContAFMode];
        }
        else if (autofocusIx == buttonIndex)
        {
            // trigger camera autofocus
            [qUtils cameraTriggerAF];
        }
        
        self.view.userInteractionEnabled = NO;
    }
}

- (void) targetOptionClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((buttonIndex < [qUtils.targetsList count]) && (buttonIndex != selectedTarget))
    {
        selectedTarget = buttonIndex;
        
        DataSetItem *targetEntry = [qUtils.targetsList objectAtIndex:selectedTarget];
        [qUtils activateDataSet:targetEntry.dataSet];
    }
    
    self.view.userInteractionEnabled = NO;
}


- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == mainOptionsAS)
        [self mainOptionClickedButtonAtIndex:buttonIndex];
    else if (actionSheet == targetOptionsAS)
        [self targetOptionClickedButtonAtIndex:buttonIndex];
}


+ (void) determineCameraCapabilities:(struct tagCameraCapabilities *) pCapabilities
{
    // Determine whether the back camera supports torch and autofocus
    NSArray* cameraArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice* camera in cameraArray)
    {
        if (AVCaptureDevicePositionBack == [camera position])
        {
            pCapabilities->autofocus = [camera isFocusModeSupported:AVCaptureFocusModeAutoFocus];
            pCapabilities->autofocusContinuous = [camera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
            pCapabilities->torch = [camera isTorchModeSupported:AVCaptureTorchModeOn];
            NSLog(@"autofocus: %d, autofocusContinuous: %d, torch %d", pCapabilities->autofocus, pCapabilities->autofocusContinuous, pCapabilities->torch);
        }
    }
}


@end
