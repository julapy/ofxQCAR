#include "testApp.h"

//--------------------------------------------------------------
void testApp :: setup()
{	
	ofRegisterTouchEvents( this );
	ofxAccelerometer.setup();
	ofxiPhoneAlerts.addListener( this );
	ofBackground( 127 );
    
    teapotImage.loadImage( "qcar_assets/TextureTeapotBrass.png" );
    teapotImage.mirror( true, false );  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    ofxQCAR::getInstance()->setup();
}

//--------------------------------------------------------------
void testApp :: update()
{
    ofxQCAR::getInstance()->update();
}

//--------------------------------------------------------------
void testApp :: draw()
{
    ofxQCAR *qcar;
    qcar = ofxQCAR::getInstance();
    qcar->draw();
    
    if( qcar->hasFoundMarker() )
    {
        ofSetColor( ofColor::white );
        ofEnableNormalizedTexCoords();

        teapotImage.getTextureReference().bind();
        ofDrawTeapot( qcar->getProjectionMatrix(), qcar->getModelViewMatrix(), 3 );
        teapotImage.getTextureReference().unbind();
        
        ofDisableNormalizedTexCoords();
    }

    //-- draw something flat with OF.
    
    ofSetColor( ofColor :: white );
    ofRect( 10, 10, 50, 50 );
}

//--------------------------------------------------------------
void testApp :: exit()
{
    ofUnregisterTouchEvents( this );
	ofxiPhoneAlerts.removeListener( this );
    
    ofxQCAR::getInstance()->exit();
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

