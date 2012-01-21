#include "ofMain.h"
#include "ofxiOSWindow.h"
#include "testApp.h"

int main()
{
    ofxiOSWindow *iosWindow = new ofxiOSWindow();
    ofSetupOpenGL( ofPtr<ofAppBaseWindow>( iosWindow ), 1024,768, OF_FULLSCREEN );
    iosWindow->startAppWithDelegate( "MyAppDelegate" );
}
