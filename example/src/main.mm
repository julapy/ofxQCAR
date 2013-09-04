#include "ofMain.h"
#include "testApp.h"

int main(){
    ofAppiOSWindow * window = new ofAppiOSWindow();
    window->enableDepthBuffer();
    window->enableRetina();
    
    ofSetupOpenGL(window, 1024,768, OF_FULLSCREEN);
    window->startAppWithDelegate("MyAppDelegate");
}
