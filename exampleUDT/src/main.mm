#include "ofMain.h"
#include "testApp.h"

int main(){
    ofAppiPhoneWindow * window = new ofAppiPhoneWindow();
    window->enableDepthBuffer();
    window->enableRetina();
    window->enableRendererES2();
    
    ofSetupOpenGL(ofPtr<ofAppBaseWindow>(window), 1024,768, OF_FULLSCREEN);
    window->startAppWithDelegate("MyAppDelegate");
}
