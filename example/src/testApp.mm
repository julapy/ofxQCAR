#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(127);
    
    /**
     *  IMPORTANT!
     *  when background clear is set to true,
     *  it interferes with QCAR and stops it from rendering.
     *  since the camera image changes on every frame and clears the background anyway, 
     *  it's ok to set it to false.
     */
    ofSetBackgroundAuto(false);
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    touchPoint.x = touchPoint.y = -1;

    ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->addTarget("Stones & Chips", "StonesAndChips.xml");
    qcar->addTarget("Tarmac", "Tarmac.xml");
    qcar->setup();
}

//--------------------------------------------------------------
void testApp::update(){
    ofxQCAR::getInstance()->update();
}

//--------------------------------------------------------------
void testApp::draw(){
    ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->draw();
    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
    
    if(qcar->hasFoundMarker()) {

        glDisable(GL_DEPTH_TEST);
        ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        ofSetLineWidth(3);
        
        bool bInside = false;
        if(bPressed) {
            vector<ofPoint> markerPoly;
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)0));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)1));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)2));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)3));
            bInside = ofInsidePoly(touchPoint, markerPoly);
        }
        
        ofSetColor(ofColor(255, 0, 255, bInside ? 150 : 50));
        qcar->drawMarkerRect();
        
        ofSetColor(ofColor::yellow);
        qcar->drawMarkerBounds();
        ofSetColor(ofColor::cyan);
        qcar->drawMarkerCenter();
        qcar->drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        glEnable(GL_DEPTH_TEST);
        ofEnableNormalizedTexCoords();
        
        teapotImage.getTextureReference().bind();
        ofDrawTeapot(qcar->getProjectionMatrix(), qcar->getModelViewMatrix(), 3);
        teapotImage.getTextureReference().unbind();
        
        ofDisableNormalizedTexCoords();
    }
    
    ofSetColor(ofColor::red);
    ofRect((ofGetWidth()-200) * 0.5, 
           (ofGetHeight()-200) * 0.5, 
           200, 200);
    
    glEnable(GL_DEPTH_TEST);
    
    if(bPressed) {
        ofSetColor(ofColor::red);
        ofDrawBitmapString("touch x = " + ofToString((int)touchPoint.x), 20, 40);
        ofDrawBitmapString("touch y = " + ofToString((int)touchPoint.y), 20, 60);
    }
}

//--------------------------------------------------------------
void testApp::exit(){
    ofxQCAR::getInstance()->exit();
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set(-1, -1);
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

