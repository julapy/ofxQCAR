for this addon to work in OpenFrameworks 007 you must comment out the initWithFrame method in the ofxiPhone EAGLView class like so,

//- (id) initWithFrame:(CGRect)frame
//{
//	return [self initWithFrame:frame andDepth:false andAA:false andNumSamples:0 andRetina:false];
//}

i tried many thing to avoid making any changes to ofxiPhone but unfortunately this change was unavoidable.
having that method inside EAGLView makes it impossible to extend on EAGLView which is necessary in the case of ofxQCAR.