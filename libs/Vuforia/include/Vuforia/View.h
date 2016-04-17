/*===============================================================================
Copyright 2015-2016 PTC Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.
===============================================================================*/

#ifndef _VUFORIA_VIEW_H_
#define _VUFORIA_VIEW_H_

namespace Vuforia
{

/// View types (used with RenderingPrimitives)
enum VIEW
{
    VIEW_SINGULAR,      ///< Identifier for singular screen on a mobile phone or
                        ///  tablet (HANDHELD device),
                        ///  or the full display in a viewer

    VIEW_LEFTEYE,       ///< Identifier for the left display of an HMD, or the
                        ///  left side of the screen when docked in a viewer

    VIEW_RIGHTEYE,      ///< Identifier for the right display of an HMD, or the
                        ///  right side of the screen when docked in a viewer

    VIEW_POSTPROCESS,   ///< Identifier for the post processing step of VR 
                        ///  rendering where the distorted scene is rendered to 
                        ///  the screen

    VIEW_COUNT          ///< Max possible number of views
};

} // namespace Vuforia

#endif //_VUFORIA_VIEW_H_
