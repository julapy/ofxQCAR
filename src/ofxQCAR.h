//
//  ofxQCAR.h
//  emptyExample
//
//  Created by lukasz karluk on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "ofMain.h"

@interface ofxQCAR_Delegate : NSObject
-(void) qcar_initialised;
-(void) qcar_cameraStarted;
-(void) qcar_cameraStopped;
-(void) qcar_projectionMatrixReady;
-(void) qcar_update;
@end


class ofxQCAR : public ofBaseApp
{
public:
    
     ofxQCAR ();
    ~ofxQCAR ();
    
	static ofxQCAR* getInstance()
	{
		if( !_instance )
			_instance = new ofxQCAR();
        return _instance;
	};
    
    virtual void setup  ();
    virtual void update ();
    virtual void draw   ();
    virtual void exit   ();
    
    void torchOn        ();
    void torchOff       ();
    void autoFocusOn    ();
    void autoFocusOff   ();
    
    const ofMatrix4x4& getProjectionMatrix  ();
    const ofMatrix4x4& getModelViewMatrix   ();
    const bool& hasFoundMarker              ();
    
private:
    
    static ofxQCAR* _instance;
    
};