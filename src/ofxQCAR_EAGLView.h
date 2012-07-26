//
//  ofxQCAREAGLView.h
//
//  Created by lukasz karluk on 19/01/12.
//

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxiOSEAGLView.h"
#import <QCAR/UIGLViewProtocol.h>

@interface ofxQCAR_EAGLView : ofxiOSEAGLView <UIGLViewProtocol> {
    //
}

@end

#endif