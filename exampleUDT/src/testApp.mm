#include "testApp.h"

ofxQCAR * qcar = NULL;

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(0);
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    qcar = ofxQCAR::getInstance();
    qcar->autoFocusOn();
    qcar->setCameraPixelsFlag(true);
    qcar->setup();
}

void testApp::qcarInitialised() {
    qcar->startUserDefinedTarget();
}

//--------------------------------------------------------------
void testApp::update(){
    qcar->update();
}

//--------------------------------------------------------------
void testApp::draw(){
    
    qcar->draw();
    
    int screenW = ofGetWidth();
    int markerW = screenW * 0.8;
    ofRectangle markerRect(0, 0, markerW, markerW);
    markerRect.x = (int)((ofGetWidth() - markerRect.width) * 0.5);
    markerRect.y = (int)((ofGetHeight() - markerRect.height) * 0.5);

    ofPushStyle();
    ofNoFill();
    ofSetLineWidth(10);
    if(qcar->hasFoundGoodQualityTarget()) {
        ofSetColor(ofColor::green);
    } else {
        ofSetColor(ofColor::red);
    }
    ofRect(markerRect);
    ofPopStyle();
    
    if(qcar->hasFoundMarker()) {

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
        glDisable(GL_DEPTH_TEST);
    }
}

//--------------------------------------------------------------
void testApp::exit(){
    qcar->stopUserDefinedTarget();
    qcar->exit();
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    //
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    //
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    //
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

