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
    
    ofxQCAR :: getInstance()->setup();
}

//--------------------------------------------------------------
void testApp :: update()
{
    ofxQCAR :: getInstance()->update();
}

//--------------------------------------------------------------
void testApp :: draw()
{
    ofxQCAR *qcar;
    qcar = ofxQCAR :: getInstance();
    qcar->draw();

    glViewport( 0, 0, ofGetWidth(), ofGetHeight() );
    ofSetupScreen();
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    ofSetColor( ofColor :: white );
    ofRect( 10, 10, 100, 100 );
    
    if( qcar->hasFoundMarker() )
    {
        ofSetColor( ofColor::white );
        ofEnableNormalizedTexCoords();

        teapotImage.getTextureReference().bind();
        {
            ofDrawTeapot( qcar->getProjectionMatrix(), qcar->getModelViewMatrix(), 3 );
        }
        teapotImage.getTextureReference().unbind();
        
        ofDisableNormalizedTexCoords();
    }
    
//    glPushMatrix();
//    {
//        float objectScale = 3.0;
//        glTranslatef( ofGetWidth() * 0.5, ofGetHeight() * 0.5, -objectScale );
//        glScalef( objectScale, objectScale, objectScale );
//        
//        ofSetColor( ofColor::white );
//        ofEnableNormalizedTexCoords();
//        teapotImage.getTextureReference().bind();
//        {
//            ofDrawTeapot();
//        }
//        teapotImage.getTextureReference().unbind();
//        ofDisableNormalizedTexCoords();
//    }
//    glPopMatrix();
}

//--------------------------------------------------------------
void testApp :: exit()
{
    ofUnregisterTouchEvents( this );
	ofxiPhoneAlerts.removeListener( this );
    
    ofxQCAR :: getInstance()->exit();
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

