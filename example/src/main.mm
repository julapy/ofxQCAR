#include "ofMain.h"
#include "testApp.h"

int main()
{
    ofSetupOpenGL( 1024,768, OF_FULLSCREEN );
    ofRunApp( new testApp() );
}
