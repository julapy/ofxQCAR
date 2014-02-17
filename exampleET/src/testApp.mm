#include "testApp.h"

//--------------------------------------------------------------
// starts extended tracking when touch touchDown
// use startExtendedTracking() and stopExtendedTracking()

void testApp::setup(){	
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    touchPoint.x = touchPoint.y = -1;
    
    scaleExtTrack = 3;

    ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->addTarget("QualcommExtra1.xml", "QualcommExtra1.xml");
    
    
    qcar->autoFocusOn();
    qcar->setCameraPixelsFlag(true);
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

        ofDisableDepthTest();
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
        
        ofEnableDepthTest();
        ofEnableNormalizedTexCoords();
        
        qcar->begin();
        teapotImage.getTextureReference().bind();
        ofScale(scaleExtTrack, scaleExtTrack, scaleExtTrack);
        ofDrawTeapot();
        teapotImage.getTextureReference().unbind();
        qcar->end();
        
        ofDisableNormalizedTexCoords();
    }
    
    ofDisableDepthTest();
    
    /**
     *  access to camera pixels.
     */
    int cameraW = qcar->getCameraWidth();
    int cameraH = qcar->getCameraHeight();
    unsigned char * cameraPixels = qcar->getCameraPixels();
    if(cameraW > 0 && cameraH > 0 && cameraPixels != NULL) {
        if(cameraImage.isAllocated() == false ) {
            cameraImage.allocate(cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        }
        cameraImage.setFromPixels(cameraPixels, cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        if(qcar->getOrientation() == OFX_QCAR_ORIENTATION_PORTRAIT) {
            cameraImage.rotate90(1);
        } else if(qcar->getOrientation() == OFX_QCAR_ORIENTATION_LANDSCAPE) {
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
        ofRect(cameraX, cameraY, cameraW, cameraH);
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
void testApp::exit(){
    ofxQCAR::getInstance()->exit();
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
     ofxQCAR * qcar = ofxQCAR::getInstance();
    scaleExtTrack=20;
      qcar->startExtendedTracking();

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set(-1, -1);
     ofxQCAR * qcar = ofxQCAR::getInstance();
    scaleExtTrack=3;
     qcar->stopExtendedTracking();
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
     ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->addExtraTarget("QualcommExtra2.xml");
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

