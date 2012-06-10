//
//  ofxQCAREAGLView.m
//
//  Created by lukasz karluk on 19/01/12.
//

#if !(TARGET_IPHONE_SIMULATOR)

#import "ofxQCAR_EAGLView.h"
#import "ofxiPhoneExtras.h"

#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>

@interface ofxQCAR_EAGLView (PrivateMethods)
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
@end

@implementation ofxQCAR_EAGLView

@synthesize delegate;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
	if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        
        touchScale = 1.0;
        touchesDict = [ [ NSMutableDictionary alloc ] init ];

		if( ofxiPhoneGetOFWindow()->isRetinaSupported() )
		{
			if( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] )
            {
				if( [[UIScreen mainScreen] scale] > 1 )
				{
					[self setContentScaleFactor:[[UIScreen mainScreen] scale]];
					touchScale = [[UIScreen mainScreen] scale];
				}
			}
		}
        
#ifdef USE_OPENGL1
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
#else
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
#endif
        
        if (!context) {
            NSLog(@"Failed to create ES context");
        }
        
        [ self createFramebuffer ];
    }
    
    return self;
}

- (void)dealloc
{
    [self deleteFramebuffer];
    
    // Tear down context
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    [context release];
    
    [touchesDict release];
    
    [super dealloc];
}

- (void)createFramebuffer
{
#ifdef USE_OPENGL1
    if (context && !defaultFramebuffer) {
        [EAGLContext setCurrentContext:context];
        
        // Create default framebuffer object
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        
        // Create colour renderbuffer and allocate backing store
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        
        // Allocate the renderbuffer's storage (shared with the drawable object)
        [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
        glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &framebufferWidth);
        glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &framebufferHeight);
        
        // Create the depth render buffer and allocate storage
        glGenRenderbuffersOES(1, &depthRenderbuffer);  
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, framebufferWidth, framebufferHeight);
        
        // Attach colour and depth render buffers to the frame buffer
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
        
        // Leave the colour render buffer bound so future rendering operations will act on it
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    }
#else
    if (context && !defaultFramebuffer) {
        [EAGLContext setCurrentContext:context];
        
        // Create default framebuffer object
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        // Create colour render buffer and allocate backing store
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        // Allocate the renderbuffer's storage (shared with the drawable object)
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        // Create the depth render buffer and allocate storage
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        
        // Attach colour and depth render buffers to the frame buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
        
        // Leave the colour render buffer bound so future rendering operations will act on it
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        }
    }
#endif
}

- (void)deleteFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
        
#ifdef USE_OPENGL1
        if (defaultFramebuffer) {
            glDeleteFramebuffersOES(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) {
            glDeleteRenderbuffersOES(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        
        if (depthRenderbuffer) {
            glDeleteRenderbuffersOES(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
#else
        if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        
        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
#endif
    }
}

- (void)setFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
        
        if (!defaultFramebuffer) {
            // Perform on the main thread to ensure safe memory allocation for
            // the shared buffer.  Block until the operation is complete to
            // prevent simultaneous access to the OpenGL context
            [self performSelectorOnMainThread:@selector(createFramebuffer) withObject:self waitUntilDone:YES];
        }
        
#ifdef USE_OPENGL1
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
#else
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
#endif
    }
}

- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;
    
    if (context) {
        [EAGLContext setCurrentContext:context];
        
#ifdef USE_OPENGL1
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        success = [context presentRenderbuffer: GL_RENDERBUFFER_OES];
#else
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
#endif
    }
    
    return success;
}

- (void)layoutSubviews
{
    // The framebuffer will be re-created at the beginning of the next
    // setFramebuffer method call.
    [self deleteFramebuffer];
}

- (void)renderFrameQCAR
{
    [ self.delegate performSelectorOnMainThread:@selector(timerLoop) withObject:nil waitUntilDone:NO ];
}

////////////////////////////////////////////////
//  OVERWRITE TO DISABLE.
////////////////////////////////////////////////

- (id) initWithFrame:(CGRect)frame andDepth:(bool)depth andAA:(bool)fsaaEnabled andNumSamples:(int)samples andRetina:(bool)retinaEnabled
{
	return self = [self initWithFrame:frame];
}

- (void)startRender 
{
    [self setFramebuffer];
}

- (void)finishRender 
{
    [self presentFramebuffer];
}

////////////////////////////////////////////////
//  TOUCH OVERWRITE.
////////////////////////////////////////////////

//------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	for(UITouch *touch in touches) {
		int touchIndex = 0;
		while([[touchesDict allValues] containsObject:[NSNumber numberWithInt:touchIndex]]) {
			touchIndex++;
		}
		
		[touchesDict setObject:[NSNumber numberWithInt:touchIndex] forKey:[NSValue valueWithPointer:touch]];
		
		CGPoint touchPoint = [touch locationInView:self];
		
		touchPoint.x*=touchScale; // this has to be done because retina still returns points in 320x240 but with high percision
		touchPoint.y*=touchScale;
		
		iPhoneGetOFWindow()->rotateXY(touchPoint.x, touchPoint.y);
		
		if( touchIndex==0 ){
			ofNotifyMousePressed(touchPoint.x, touchPoint.y, 0);
		}
		
		ofTouchEventArgs touchArgs;
		touchArgs.x = touchPoint.x;
		touchArgs.y = touchPoint.y;
		touchArgs.id = touchIndex;
		if([touch tapCount] == 2) ofNotifyEvent(ofEvents().touchDoubleTap,touchArgs);	// send doubletap
		ofNotifyEvent(ofEvents().touchDown,touchArgs);	// but also send tap (upto app programmer to ignore this if doubletap came that frame)
	}
}

//------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	//	NSLog(@"touchesMoved: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);
	
	for(UITouch *touch in touches) {
		int touchIndex = [[touchesDict objectForKey:[NSValue valueWithPointer:touch]] intValue];
		//		[activeTouches setObject:[NSNumber numberWithInt:touchIndex] forKey:[NSValue valueWithPointer:touch]];
		
		CGPoint touchPoint = [touch locationInView:self];
		
		touchPoint.x*=touchScale; // this has to be done because retina still returns points in 320x240 but with high percision
		touchPoint.y*=touchScale;
		
		iPhoneGetOFWindow()->rotateXY(touchPoint.x, touchPoint.y);
		
		if( touchIndex==0 ){
			ofNotifyMouseDragged(touchPoint.x, touchPoint.y, 0);			
		}		
		ofTouchEventArgs touchArgs;
		touchArgs.numTouches = [[event touchesForView:self] count];
		touchArgs.x = touchPoint.x;
		touchArgs.y = touchPoint.y;
		touchArgs.id = touchIndex;
		ofNotifyEvent(ofEvents().touchMoved, touchArgs);
	}
	
}

//------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//	NSLog(@"touchesEnded: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);
	for(UITouch *touch in touches) {
		int touchIndex = [[touchesDict objectForKey:[NSValue valueWithPointer:touch]] intValue];
		
		[touchesDict removeObjectForKey:[NSValue valueWithPointer:touch]];
		
		CGPoint touchPoint = [touch locationInView:self];
		
		touchPoint.x*=touchScale; // this has to be done because retina still returns points in 320x240 but with high percision
		touchPoint.y*=touchScale;
		
		iPhoneGetOFWindow()->rotateXY(touchPoint.x, touchPoint.y);
		
		if( touchIndex==0 ){
			ofNotifyMouseReleased(touchPoint.x, touchPoint.y, 0);						
		}
		
		ofTouchEventArgs touchArgs;
		touchArgs.numTouches = [[event touchesForView:self] count] - [touches count];
		touchArgs.x = touchPoint.x;
		touchArgs.y = touchPoint.y;
		touchArgs.id = touchIndex;
		ofNotifyEvent(ofEvents().touchUp, touchArgs);
	}
}

//------------------------------------------------------
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	for(UITouch *touch in touches) {
		int touchIndex = [[touchesDict objectForKey:[NSValue valueWithPointer:touch]] intValue];
		
		CGPoint touchPoint = [touch locationInView:self];
		
		touchPoint.x*=touchScale; // this has to be done because retina still returns points in 320x240 but with high percision
		touchPoint.y*=touchScale;
		
		iPhoneGetOFWindow()->rotateXY(touchPoint.x, touchPoint.y);
		
		ofTouchEventArgs touchArgs;
		touchArgs.numTouches = [[event touchesForView:self] count];
		touchArgs.x = touchPoint.x;
		touchArgs.y = touchPoint.y;
		touchArgs.id = touchIndex;
		ofNotifyEvent(ofEvents().touchCancelled, touchArgs);
	}
	
	[self touchesEnded:touches withEvent:event];
}

@end

#endif
