#include "ofApp.h"

static const string kLicenseKey = "AfJ6d4//////AAAAAck2JyVaKEJarsb9283lT4EiMz7jNMKKEPuFlDhX9shBx1A41N05tPNEMHb4IMvsx3DNpjbyXLrUQJdJcwS2IzV4NdmwY7R8CkxZFeVKEotcSjh296otcRMmZPAYWRQAFL7f4ljQLMSVjvDFZRLf9/X5uIR+wNNTqK47d1NpPhDBv2usiT0Z8SxSej5Dn919ue2p8o8QGk/KThAFPVCwIQxigXauDlECHFB0EHvoNNatMVsjyMC3hKU/btXbCFMa2wL5ZM/nQgVeqveMv5eOygzCCLkDIMC2R8QRQzqAvH4h2I0YBJ0CMxD98AP45wEwxLOOLMRFdIOi2THxpVhWHSHiU/b6XSX96FHY/0eM3aul";

//--------------------------------------------------------------
void ofApp::setup(){
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    teapotImage.load("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    touchPoint.x = touchPoint.y = -1;

    ofxQCAR& QCAR = ofxQCAR::getInstance();
    QCAR.setLicenseKey(kLicenseKey); // ADD YOUR APPLICATION LICENSE KEY HERE.
    QCAR.addMarkerDataPath("qcar_assets/Qualcomm.xml");
    QCAR.autoFocusOn();
    QCAR.setCameraPixelsFlag(true);
    QCAR.setup();
}

//--------------------------------------------------------------
void ofApp::update(){
    ofxQCAR & QCAR = ofxQCAR::getInstance();
    QCAR.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofxQCAR& QCAR = ofxQCAR::getInstance();
    QCAR.drawBackground();
    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
    
    if(QCAR.hasFoundMarker()) {

        ofDisableDepthTest();
        ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        ofSetLineWidth(3);
        
        bool bInside = false;
        if(bPressed) {
            vector<ofPoint> markerPoly;
            markerPoly.push_back(QCAR.getMarkerCorner((ofxQCAR_MarkerCorner)0));
            markerPoly.push_back(QCAR.getMarkerCorner((ofxQCAR_MarkerCorner)1));
            markerPoly.push_back(QCAR.getMarkerCorner((ofxQCAR_MarkerCorner)2));
            markerPoly.push_back(QCAR.getMarkerCorner((ofxQCAR_MarkerCorner)3));
            bInside = ofInsidePoly(touchPoint, markerPoly);
        }
        
        if(bInside == true) {
            ofSetColor(ofColor(255, 0, 255, 150));
        } else {
            ofSetColor(ofColor(255, 0, 255, 50));
        }
        QCAR.drawMarkerRect();
        
        ofSetColor(ofColor::yellow);
        QCAR.drawMarkerBounds();
        ofSetColor(ofColor::cyan);
        QCAR.drawMarkerCenter();
        QCAR.drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        ofEnableDepthTest();
        ofEnableNormalizedTexCoords();
        
        QCAR.begin();
        teapotImage.getTexture().bind();
        ofSetColor(255, 230);
        ofScale(3, 3, 3);
        ofDrawTeapot();
        ofSetColor(255);
        teapotImage.getTexture().unbind();
        QCAR.end();
        
        ofDisableNormalizedTexCoords();
        
        QCAR.begin();
        ofNoFill();
        ofSetColor(255, 0, 0, 200);
        ofSetLineWidth(6);
        float radius = 20;
        ofPushMatrix();
        ofTranslate(markerPoint.x, markerPoint.y);
        ofDrawCircle(0, 0, radius);
        ofDrawLine(-radius, 0, radius, 0);
        ofDrawLine(0, -radius, 0, radius);
        ofPopMatrix();
        ofFill();
        ofSetColor(255);
        ofSetLineWidth(1);
        QCAR.end();
    }
    
    ofDisableDepthTest();
    
    /**
     *  access to camera pixels.
     */
    int cameraW = QCAR.getCameraWidth();
    int cameraH = QCAR.getCameraHeight();
    unsigned char * cameraPixels = QCAR.getCameraPixels();
    if(cameraW > 0 && cameraH > 0 && cameraPixels != NULL) {
        if(cameraImage.isAllocated() == false ) {
            cameraImage.allocate(cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        }
        cameraImage.setFromPixels(cameraPixels, cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        if(QCAR.getOrientation() == OFX_QCAR_ORIENTATION_PORTRAIT) {
            cameraImage.rotate90(1);
        } else if(QCAR.getOrientation() == OFX_QCAR_ORIENTATION_LANDSCAPE) {
            cameraImage.mirror(true, true);
        }

        cameraW = cameraImage.getWidth() * 0.5;
        cameraH = cameraImage.getHeight() * 0.5;
        int cameraX = 0;
        int cameraY = ofGetHeight() - cameraH;
        cameraImage.draw(cameraX, cameraY, cameraW, cameraH);
        
        ofPushStyle();
        ofSetColor(ofColor::white);
        ofNoFill();
        ofSetLineWidth(3);
        ofDrawRectangle(cameraX, cameraY, cameraW, cameraH);
        ofPopStyle();
    }
    
    if(bPressed) {
        ofSetColor(ofColor::red);
        ofDrawBitmapString("touch x = " + ofToString((int)touchPoint.x), ofGetWidth() - 140, ofGetHeight() - 40);
        ofDrawBitmapString("touch y = " + ofToString((int)touchPoint.y), ofGetWidth() - 140, ofGetHeight() - 20);
        ofSetColor(ofColor::white);
    }
}

//--------------------------------------------------------------
void ofApp::exit(){
    ofxQCAR::getInstance().exit();
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
    markerPoint = ofxQCAR::getInstance().screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
    markerPoint = ofxQCAR::getInstance().screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set(-1, -1);
    markerPoint = ofxQCAR::getInstance().screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

