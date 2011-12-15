#include "testApp.h"

//--------------------------------------------------------------
void testApp :: setup()
{	
	ofRegisterTouchEvents( this );
	ofxAccelerometer.setup();
	ofxiPhoneAlerts.addListener( this );
	ofBackground( 127 );
    
    teapotImage.loadImage( "qcar_assets/TextureTeapotBrass.png" );
    
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
    
    if( qcar.hasFoundMarker() )
        drawTeapot();
}

void testApp :: drawTeapot ()
{
    float objectScale = 3.0f;
    
    ofSetColor( ofColor::white );
    ofEnableNormalizedTexCoords();
    
    glEnable( GL_DEPTH_TEST );
    glEnable( GL_CULL_FACE );
    
    glPushMatrix();
    glTranslatef( ofGetWidth() * 0.5, ofGetHeight() * 0.5, 0 );
    {
        glEnableClientState( GL_TEXTURE_COORD_ARRAY );
        glEnableClientState( GL_VERTEX_ARRAY );
        glEnableClientState( GL_NORMAL_ARRAY );
        
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf( qcar.getProjectionMatrix().getPtr() );
        
        glMatrixMode( GL_MODELVIEW );
        glLoadMatrixf( qcar.getModelViewMatrix().getPtr() );
        glTranslatef( 0.0f, 0.0f, -objectScale );
        glScalef( objectScale, objectScale, objectScale );
        
        teapotImage.getTextureReference().bind();
        
        glTexCoordPointer( 2, GL_FLOAT, 0, (const GLvoid*)&teapotTexCoords[ 0 ] );
        glVertexPointer( 3, GL_FLOAT, 0, (const GLvoid*)&teapotVertices[ 0 ] );
        glNormalPointer( GL_FLOAT, 0, (const GLvoid*)&teapotNormals[ 0 ] );
        glDrawElements( GL_TRIANGLES, NUM_TEAPOT_OBJECT_INDEX, GL_UNSIGNED_SHORT, (const GLvoid*)&teapotIndices[ 0 ] );
        
        teapotImage.getTextureReference().unbind();
        
        glDisableClientState( GL_TEXTURE_COORD_ARRAY );
        glDisableClientState( GL_VERTEX_ARRAY );
        glDisableClientState( GL_NORMAL_ARRAY );
    }
    glPopMatrix();
    
    glDisable( GL_DEPTH_TEST );
    glDisable( GL_CULL_FACE );
    
    ofDisableNormalizedTexCoords();
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

