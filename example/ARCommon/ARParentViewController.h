/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>

@class ARViewController, OverlayViewController;

@interface ARParentViewController : UIViewController {
    OverlayViewController* overlayViewController; // for the overlay view (buttons and action sheets)
    ARViewController* arViewController; // for the Augmented Reality view
    UIView *parentView; // a container view to allow use in tabbed views etc.
    
    CGRect arViewRect; // the size of the AR view
}

@property (nonatomic) CGRect arViewRect;

@end
