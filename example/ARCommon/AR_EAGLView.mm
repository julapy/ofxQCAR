/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <QuartzCore/QuartzCore.h>
#import "AR_EAGLView.h"
#import "Texture.h"
#import <QCAR/QCAR.h>
#import <QCAR/Renderer.h>

#import "ofxQCAR_Utils.h"

#define USE_OPENGL1
#define renderFrameQCAR_TEMPLATE

#ifndef USE_OPENGL1
#import "ShaderUtils.h"
#define MAKESTRING(x) #x
#import "Shaders/Shader.fsh"
#import "Shaders/Shader.vsh"
#endif


@implementation Object3D

@synthesize numVertices;
@synthesize vertices;
@synthesize normals;
@synthesize texCoords;
@synthesize numIndices;
@synthesize indices;
@synthesize texture;

@end

@interface AR_EAGLView (PrivateMethods)
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
- (int)loadTextures;
- (void)initRendering;
@end


@implementation AR_EAGLView

@synthesize textureList;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// test to see if the screen has hi-res mode
- (BOOL) isRetinaEnabled
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
            &&
            ([UIScreen mainScreen].scale == 2.0));
}

// use to allow this view to access loaded textures
- (void) useTextures:(NSMutableArray *)theTextures
{
    textures = theTextures;
}
 

#pragma mark ---- view lifecycle ---
/////////////////////////////////////////////////////////////////
//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
	if (self) {
        qUtils = [ofxQCAR_Utils getInstance];
        objects3D = [[NSMutableArray alloc] initWithCapacity:2];
        textureList = [[NSMutableArray alloc] initWithCapacity:2];
        
        // switch on hi-res mode if available
        if ([self isRetinaEnabled])
        {
            self.contentScaleFactor = 2.0f;
            qUtils.contentScalingFactor = self.contentScaleFactor;
        }
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        
#ifdef USE_OPENGL1
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        qUtils.QCARFlags = QCAR::GL_11;
#else
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        qUtils.QCARFlags = QCAR::GL_20;
#endif
        
        NSLog(@"QCAR OpenGL flag: %d", qUtils.QCARFlags);
        
        if (!context) {
            NSLog(@"Failed to create ES context");
        }
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
    [objects3D release];
    [textureList release];
    [super dealloc];
}


/////////////////////////////////////////////////////////////////
//
- (void)layoutSubviews
{
    NSLog(@"EAGLView: layoutSubviews");
    
    // The framebuffer will be re-created at the beginning of the next setFramebuffer method call.
    [self deleteFramebuffer];
    
    // Initialisation done once, or once per screen size change
    [self initRendering];
}


#pragma mark --- OpenGL essentials ---
/////////////////////////////////////////////////////////////////
//
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


/////////////////////////////////////////////////////////////////
//
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


/////////////////////////////////////////////////////////////////
//
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


/////////////////////////////////////////////////////////////////
//
- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;
    
    if (context) {
        [EAGLContext setCurrentContext:context];
        
#ifdef USE_OPENGL1
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
#else
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
#endif
        
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    return success;
}


/////////////////////////////////////////////////////////////////
// TEMPLATE - this is app specific and
// expected to be overridden in EAGLView.mm
- (void) setup3dObjects
{
    for (int i=0; i < [textures count]; i++)
    {
        Object3D *obj3D = [[Object3D alloc] init];

        obj3D.numVertices = 0;
        obj3D.vertices = nil;
        obj3D.normals = nil;
        obj3D.texCoords = nil;
        
        obj3D.numIndices = 0;
        obj3D.indices = nil;
        
        obj3D.texture = [textures objectAtIndex:i];

        [objects3D addObject:obj3D];
        [obj3D release];
    }
}


////////////////////////////////////////////////////////////////////////////////
// Initialise OpenGL 2.x shaders
- (void)initShaders
{
#ifndef USE_OPENGL1
    // OpenGL 2 initialisation
    shaderProgramID = ShaderUtils::createProgramFromBuffer(vertexShader, fragmentShader);
    
    if (0 < shaderProgramID) {
        vertexHandle = glGetAttribLocation(shaderProgramID, "vertexPosition");
        normalHandle = glGetAttribLocation(shaderProgramID, "vertexNormal");
        textureCoordHandle = glGetAttribLocation(shaderProgramID, "vertexTexCoord");
        mvpMatrixHandle = glGetUniformLocation(shaderProgramID, "modelViewProjectionMatrix");
    }
    else {
        NSLog(@"Could not initialise augmentation shader");
    }
#endif
}


////////////////////////////////////////////////////////////////////////////////
// Initialise OpenGL rendering
- (void)initRendering
{
    if (renderingInited)
        return;
    
    // Define the clear colour
    glClearColor(0.0f, 0.0f, 0.0f, QCAR::requiresAlpha() ? 0.0f : 1.0f);
    
    // Generate the OpenGL texture objects
    for (int i = 0; i < [textures count]; ++i) {
        GLuint nID;
        Texture* texture = [textures objectAtIndex:i];
        glGenTextures(1, &nID);
        [texture setTextureID: nID];
        glBindTexture(GL_TEXTURE_2D, nID);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [texture width], [texture height], 0, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)[texture pngData]);
    }
    
    // set up objects using the above textures.
    [self setup3dObjects];
    
    if (QCAR::GL_20 & qUtils.QCARFlags) {
        [self initShaders];
    }
    
    renderingInited = YES;
}


////////////////////////////////////////////////////////////////////////////////
// Draw the current frame using OpenGL
//
// This code is a TEMPLATE for the subclassing EAGLView to complete
//
// The subclass override of this method is called by QCAR when it wishes to render the current frame to
// the screen.
//
// *** QCAR will call the subclassed method on a single background thread ***
- (void)renderFrameQCAR
{
#ifdef renderFrameQCAR_TEMPLATE 
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
//    if (QCAR::GL_11 & qUtils.QCARFlags) {
//        glEnable(GL_TEXTURE_2D);
//        glDisable(GL_LIGHTING);
//        glEnableClientState(GL_VERTEX_ARRAY);
//        glEnableClientState(GL_NORMAL_ARRAY);
//        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    }
//    
//    glEnable(GL_DEPTH_TEST);
//    glEnable(GL_CULL_FACE);
//    
//    for (int i = 0; i < state.getNumActiveTrackables(); ++i) {        
//        // Render using the appropriate version of OpenGL
//        if (QCAR::GL_11 & qUtils.QCARFlags){
//            ////////////////////////////////////////////////
//            // In subclass, draw augmentations in OpenGL ES 1.1 here
//            ////////////////////////////////////////////////
//        }
//#ifndef USE_OPENGL1
//        else {
//            ////////////////////////////////////////////////
//            // In subclass, draw augmentations in OpenGL ES 2.0 here
//            ////////////////////////////////////////////////
//        }
//#endif
//    }
//    
//    glDisable(GL_DEPTH_TEST);
//    glDisable(GL_CULL_FACE);
//    
//    if (QCAR::GL_11 & qUtils.QCARFlags) {
//        glDisable(GL_TEXTURE_2D);
//        glDisableClientState(GL_VERTEX_ARRAY);
//        glDisableClientState(GL_NORMAL_ARRAY);
//        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    }
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];
#endif //renderFrameQCAR_TEMPLATE
}

@end
