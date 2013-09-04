#include "testApp.h"

ofxQCAR * qcar = NULL;

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    qcar = ofxQCAR::getInstance();
    qcar->addTarget("Qualcomm.xml", "Qualcomm.xml");
    qcar->autoFocusOn();
    qcar->setCameraPixelsFlag(false);
    qcar->setup();
}

void testApp::qcarInitialised() {
    scanTarget();
}

bool testApp::scanTarget() {
    qcar->scanCustomTarget();
    return true;
}

bool testApp::saveTarget() {
    if(qcar->hasFoundGoodQualityTarget()) {
        qcar->saveCustomTarget();
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

bool testApp::isScanning() {
    return qcar->isScanningCustomTarget();
}

bool testApp::isTracking() {
    return qcar->isTrackingCustomTarget();
}

//--------------------------------------------------------------
void testApp::update(){
    qcar->update();
}

//--------------------------------------------------------------
void testApp::draw(){
    
    qcar->draw();

    if(qcar->isScanningCustomTarget()) {
        int screenW = ofGetWidth();
        int markerW = screenW * 0.9;
        ofRectangle markerRect(0, 0, markerW, markerW);
        markerRect.x = (int)((ofGetWidth() - markerRect.width) * 0.5);
        markerRect.y = (int)((ofGetHeight() - markerRect.height) * 0.5);
        
        ofPushStyle();
        ofNoFill();
        ofSetLineWidth(3);
        if(qcar->hasFoundGoodQualityTarget()) {
            ofSetColor(ofColor::green);
        } else {
            ofSetColor(ofColor::red);
        }
        ofRect(markerRect);
        ofPopStyle();
    }
    
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
        
        qcar->begin();
        teapotImage.getTextureReference().bind();
        ofScale(3, 3, 3);
        ofDrawTeapot();
        teapotImage.getTextureReference().unbind();
        qcar->end();
        
        ofDisableNormalizedTexCoords();
        glDisable(GL_DEPTH_TEST);
    }
}

//--------------------------------------------------------------
void testApp::exit(){
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

