//
//  SphereFunction.m
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SphereFunction.h"

@implementation SphereFunction

- (UIImage *)image {
    return image;
}

- (void)setImage: (UIImage *)_image {
    NSLog(@"new image");
    image = _image;
    CGImageRef  imageRef = [_image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    // resize the parent class
    [self resizeWidth: width height: height];
    
    imageData = (unsigned char *)realloc(imageData, height * width * 4 * sizeof(unsigned char));
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
}

- (id)init {
    self = [super init];
    if (self) {
        imageData = NULL;
    }
    return self;
}

- (id)init: (UIImage*)_image {
    self = [super init];
    if (self) {
        imageData = NULL;
        self.image = _image;
    }
    return self;
}

- (float)valueX: (NSUInteger)x Y: (NSUInteger)y {
    if (NULL == imageData) {
        return 0;
    }
    // take the green channel
    return imageData[4 * x + 4 * y * self.width + 1] / 255.;
}

- (float)value: (float[3])vec {
    if (NULL == imageData) {
        return 0;
    }
    NSUInteger x = [self hoffsetV: vec];
    NSUInteger y = [self voffsetV: vec];
    return [self valueX: x Y: y];
}

- (void)dealloc {
    free(imageData);
}


@end
