#include "testApp.h"

//--------------------------------------------------------------
void testApp :: setup()
{	
	ofRegisterTouchEvents( this );
	ofxAccelerometer.setup();
	ofxiPhoneAlerts.addListener( this );
	ofBackground( 127 );
    
    qcar.setup();
}

//--------------------------------------------------------------
void testApp :: update()
{
    qcar.update();
}

//--------------------------------------------------------------
void testApp :: draw()
{
	qcar.draw();
}

//--------------------------------------------------------------
void testApp :: exit()
{
    ofUnregisterTouchEvents( this );
	ofxiPhoneAlerts.removeListener( this );
    
    qcar.exit();
}

//--------------------------------------------------------------
void testApp :: touchDown(ofTouchEventArgs &touch)
{
    //
}

//--------------------------------------------------------------
void testApp :: touchMoved(ofTouchEventArgs &touch)
{
    //
}

//--------------------------------------------------------------
void testApp :: touchUp(ofTouchEventArgs &touch)
{
    //
}

//--------------------------------------------------------------
void testApp :: touchDoubleTap(ofTouchEventArgs &touch)
{
    //
}

//--------------------------------------------------------------
void testApp :: lostFocus()
{
    //
}

//--------------------------------------------------------------
void testApp :: gotFocus()
{
    //
}

//--------------------------------------------------------------
void testApp :: gotMemoryWarning()
{
    //
}

//--------------------------------------------------------------
void testApp :: deviceOrientationChanged(int newOrientation)
{
    //
}

//--------------------------------------------------------------
void testApp :: touchCancelled(ofTouchEventArgs& args)
{
    //
}

