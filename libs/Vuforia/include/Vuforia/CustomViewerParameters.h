/*===============================================================================
Copyright (c) 2015-2016 PTC Inc. All Rights Reserved.

Copyright (c) 2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.

@file
    CustomViewerParameters.h

@brief
    Header file for CustomViewerParameters class.
===============================================================================*/
#ifndef _VUFORIA_CUSTOM_VIEWER_PARAMETERS_H_
#define _VUFORIA_CUSTOM_VIEWER_PARAMETERS_H_

#include <Vuforia/ViewerParameters.h>

namespace Vuforia
{

/// Editable container class for parameters needed to define a viewer
class VUFORIA_API CustomViewerParameters : public ViewerParameters
{
public:
    /// Construct an empty object for the supplied version, name and manufacturer.
    CustomViewerParameters(float version, const char* name, const char* manufacturer);

    /// Copy constructor
    CustomViewerParameters(const CustomViewerParameters&);

    /// Assignment operator
    CustomViewerParameters& operator=(const CustomViewerParameters&);

    /// Set the type of button in the viewer.
    virtual void setButtonType(BUTTON_TYPE val);

    /// Set the distance between the phone screen and the viewer lens' in meters.
    virtual void setScreenToLensDistance(float val);

    /// Set the distance between the viewer lens' in meters.
    virtual void setInterLensDistance(float val);

    /// Set how the phone sits with in the viewer.
    virtual void setTrayAlignment(TRAY_ALIGNMENT val);

    /// Set the distance between the lens' and the tray position in meters.
    virtual void setLensCentreToTrayDistance(float val);

    /// Clear the list of distortion coefficients.
    virtual void clearDistortionCoefficients();

    /// Add a new value to the list of distortion coefficients.
    virtual void addDistortionCoefficient(float val);

    /// Set the field-of-view of the lens'.
    /**
     * \param val a Vector containing the half angles in order Outer (ear), Inner (nose), top, bottom
     */
    virtual void setFieldOfView(const Vec4F& val);

    /// Set the flag indicating whether the viewer contains a magnet.
    virtual void setContainsMagnet(bool val);

};

} // namespace Vuforia

#endif // _VUFORIA_CUSTOM_VIEWER_PARAMETERS_H_
