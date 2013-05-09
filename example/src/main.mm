#include "ofMain.h"
#include "testApp.h"
#include "ofGLES2Renderer.h"

int main(){
    ofGLES2Renderer * renderer;
    renderer = new ofGLES2Renderer();
    ofSetCurrentRenderer(ofPtr<ofBaseRenderer>(renderer));
    
    ofAppiPhoneWindow *window = new ofAppiPhoneWindow();
    window->enableDepthBuffer();
    window->enableRetinaSupport();
    
    ofSetupOpenGL( ofPtr<ofAppBaseWindow>( window ), 1024,768, OF_FULLSCREEN );
    window->startAppWithDelegate( "MyAppDelegate" );
}
