#include "ofApp.h"


static const string kLicenseKey = "AfJ6d4//////AAAAAck2JyVaKEJarsb9283lT4EiMz7jNMKKEPuFlDhX9shBx1A41N05tPNEMHb4IMvsx3DNpjbyXLrUQJdJcwS2IzV4NdmwY7R8CkxZFeVKEotcSjh296otcRMmZPAYWRQAFL7f4ljQLMSVjvDFZRLf9/X5uIR+wNNTqK47d1NpPhDBv2usiT0Z8SxSej5Dn919ue2p8o8QGk/KThAFPVCwIQxigXauDlECHFB0EHvoNNatMVsjyMC3hKU/btXbCFMa2wL5ZM/nQgVeqveMv5eOygzCCLkDIMC2R8QRQzqAvH4h2I0YBJ0CMxD98AP45wEwxLOOLMRFdIOi2THxpVhWHSHiU/b6XSX96FHY/0eM3aul";

//--------------------------------------------------------------
void ofApp::setup(){	
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    teapotImage.load("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    ofxQCAR& QCAR = ofxQCAR::getInstance();
    QCAR.setLicenseKey(kLicenseKey); // ADD YOUR APPLICATION LICENSE KEY HERE.
    QCAR.addMarkerDataPath("qcar_assets/Qualcomm.xml");
    QCAR.autoFocusOn();
    QCAR.setCameraPixelsFlag(true);
    QCAR.setup();
}

void ofApp::qcarInitialised() {
    scanTarget();
}

bool ofApp::scanTarget() {
    ofxQCAR::getInstance().scanCustomTarget();
    return true;
}

bool ofApp::saveTarget() {
    ofxQCAR& QCAR = ofxQCAR::getInstance();

    if(QCAR.hasFoundGoodQualityTarget()) {
        QCAR.saveCustomTarget();
        return true;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Low Quality Image"
                                                        message:@"The image has very little detail, please try another."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
    [alertView release];
    
    return false;
}

bool ofApp::isScanning() {
    return ofxQCAR::getInstance().isScanningCustomTarget();
}


bool ofApp::isTracking() {
    return ofxQCAR::getInstance().isTrackingCustomTarget();
}


void ofApp::update(){
    ofxQCAR::getInstance().update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofxQCAR& QCAR = ofxQCAR::getInstance();

    QCAR.drawBackground();

    if(QCAR.isScanningCustomTarget()) {
        int screenW = ofGetWidth();
        int markerW = screenW * 0.9;
        ofRectangle markerRect(0, 0, markerW, markerW);
        markerRect.x = (int)((ofGetWidth() - markerRect.width) * 0.5);
        markerRect.y = (int)((ofGetHeight() - markerRect.height) * 0.5);
        
        ofPushStyle();
        ofNoFill();
        ofSetLineWidth(3);
        if(QCAR.hasFoundGoodQualityTarget()) {
            ofSetColor(ofColor::green);
        } else {
            ofSetColor(ofColor::red);
        }
        ofDrawRectangle(markerRect);
        ofPopStyle();
    }
    
    if (QCAR.hasFoundMarker()) {

        ofSetColor(ofColor::yellow);
        QCAR.drawMarkerBounds();
        ofSetColor(ofColor::cyan);
        QCAR.drawMarkerCenter();
        QCAR.drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        glEnable(GL_DEPTH_TEST);
        ofEnableNormalizedTexCoords();
        
        QCAR.begin();
        teapotImage.getTexture().bind();
        ofScale(3, 3, 3);
        ofDrawTeapot();
        teapotImage.getTexture().unbind();
        QCAR.end();
        
        ofDisableNormalizedTexCoords();
        glDisable(GL_DEPTH_TEST);
    }
}

//--------------------------------------------------------------
void ofApp::exit(){
    ofxQCAR::getInstance().exit();
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    //
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    //
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    //
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

