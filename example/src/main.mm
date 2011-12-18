#include "ofMain.h"
#include "testApp.h"

int main()
{
    ofAppiPhoneWindow *window = new ofAppiPhoneWindow();
    window->enableDepthBuffer();
    
    ofSetupOpenGL( ofPtr<ofAppBaseWindow>( window ), 1024,768, OF_FULLSCREEN );
    ofRunApp( new testApp() );
}
