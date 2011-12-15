//
//  ofxQCARUtils.h
//  emptyExample
//
//  Created by lukasz karluk on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#include "ofMain.h"

class ofxQCARUtils
{
    
    public :
	
	static ofRectangle cropToSize ( const ofRectangle& srcRect, const ofRectangle& dstRect )
    {
        float wRatio, hRatio, scale;
        
        wRatio = dstRect.width  / (float)srcRect.width;
        hRatio = dstRect.height / (float)srcRect.height;
        
        scale = MAX( wRatio, hRatio );
        
        ofRectangle			rect;
        rect.x		= ( dstRect.width  - ( srcRect.width  * scale ) ) * 0.5;
        rect.y		= ( dstRect.height - ( srcRect.height * scale ) ) * 0.5;
        rect.width	= srcRect.width  * scale;
        rect.height	= srcRect.height * scale;
        
        return rect;
    }
    
	static ofRectangle fitToSize  ( const ofRectangle& srcRect, const ofRectangle& dstRect )
    {
        float wRatio, hRatio, scale;
        
        wRatio = dstRect.width  / (float)srcRect.width;
        hRatio = dstRect.height / (float)srcRect.height;
        
        scale = MIN( wRatio, hRatio );
        
        ofRectangle			rect;
        rect.x		= ( dstRect.width  - ( srcRect.width  * scale ) ) * 0.5;
        rect.y		= ( dstRect.height - ( srcRect.height * scale ) ) * 0.5;
        rect.width	= srcRect.width  * scale;
        rect.height	= srcRect.height * scale;
        
        return rect;
    }
};
