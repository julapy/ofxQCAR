/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other 
countries.

@file
    UIGLViewProtocol.h
 
@brief
    <b>iOS:</b> Header file for the iOS-specific UIGLViewProtocol protocol.
===============================================================================*/
#ifndef _UIGLVIEWPROTOCOL_H_
#define _UIGLVIEWPROTOCOL_H_

/**
 <b>iOS:</b> This protocol applies only to the iOS platform.<BR>
 <BR>
 UIGLViewProtocol protocol.  The apps's UIView-derived class may conform to
 UIGLViewProtocol to allow Vuforia to call the renderFrameVuforia method when it
 wishes to render the current frame.  This is an informal protocol.  The
 view hierarchy is traversed asking each node whether it respondsToSelector
 renderFrameVuforia.  Note: if more than one view in the hierarchy responds to 
 this selector then only one will be chosen, and it is undefined which that
 will be.
 If no view that responds to renderFrameVuforia is found, then the application
 is responsible for scheduling its own rendering.
 */
@protocol UIGLViewProtocol
/// <b>iOS:</b> Called by Vuforia to render the current frame
- (void)renderFrameVuforia;
@end

#endif // _UIGLVIEWPROTOCOL_H_
