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

@synthesize image;

- (id)init: (UIImage*)_image {
    CGImageRef  imageRef = [_image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    self = [super initWidth: (int)width height: (int)height];
    if (self) {
        self.image = _image;
        //
        imageData = (unsigned char *)calloc(height * width * 4, sizeof(unsigned char));
        CGContextRef context = CGBitmapContextCreate(imageData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(context);
    }
    return self;
}

- (float)valueX: (int)x Y: (int)y {
    return imageData[4 * x + 4 * y * self.width + 1] / 255.;
}


- (float)value: (float[3])vec {
    int x = [self hoffsetV: vec];
    int y = [self voffsetV: vec];
    return [self valueX: x Y: y];
}

- (void)dealloc {
    free(imageData);
}


@end
