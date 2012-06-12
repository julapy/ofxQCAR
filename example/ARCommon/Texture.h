/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#import <Foundation/Foundation.h>

@interface Texture : NSObject {
    int width;
    int height;
    int channels;
    int textureID;
    unsigned char* pngData;
}

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic) int textureID;
@property (nonatomic, readonly) unsigned char* pngData;

- (BOOL)loadImage:(NSString*)filename;

@end
