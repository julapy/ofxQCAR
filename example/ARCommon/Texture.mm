/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#import "Texture.h"

// Private method declarations
@interface Texture (PrivateMethods)
- (BOOL)copyImageDataForOpenGL:(CFDataRef)imageData;
@end

@implementation Texture

@synthesize width, height, textureID, pngData;


- (id)init
{
    self = [super init];
    pngData = NULL;
    
    return self;
}


- (BOOL)loadImage:(NSString*)filename
{
    BOOL ret = NO;
    
    // Build the full path of the image file
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* fullPath = [resourcePath stringByAppendingPathComponent:filename];
    
    // Create a UIImage with the contents of the file
    UIImage* uiImage = [UIImage imageWithContentsOfFile:fullPath];
    
    if (uiImage) {
        // Get the inner CGImage from the UIImage wrapper
        CGImageRef cgImage = uiImage.CGImage;
        
        // Get the image size
        width = CGImageGetWidth(cgImage);
        height = CGImageGetHeight(cgImage);
        
        // Record the number of channels
        channels = CGImageGetBitsPerPixel(cgImage)/CGImageGetBitsPerComponent(cgImage);
        
        // Generate a CFData object from the CGImage object (a CFData object represents an area of memory)
        CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
        
        // Copy the image data for use by Open GL
        ret = [self copyImageDataForOpenGL: imageData];
        CFRelease(imageData);
    }
    
    return ret;
}


- (void)dealloc
{
    if (pngData) {
        delete[] pngData;
    }
    
    [super dealloc];
}

@end


@implementation Texture (TexturePrivateMethods)

- (BOOL)copyImageDataForOpenGL:(CFDataRef)imageData
{    
    if (pngData) {
        delete[] pngData;
    }
    
    pngData = new unsigned char[width * height * channels];
    const int rowSize = width * channels;
    const unsigned char* pixels = (unsigned char*)CFDataGetBytePtr(imageData);

    // Copy the row data from bottom to top
    for (int i = 0; i < height; ++i) {
        memcpy(pngData + rowSize * i, pixels + rowSize * (height - 1 - i), width * channels);
    }
    
    return YES;
}

@end
