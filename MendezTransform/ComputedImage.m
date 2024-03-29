//
//  ComputedImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ComputedImage.h"
#import "Debug.h"

@implementation ComputedImage

@synthesize width, height, image;

-(id)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        NSDebug(@"iniatialize computed %d x %d image", size.width, size.height);
        width = size.width;
        height = size.height;
        image = nil;
    }
    return self;
}

- (void)imageFromData:(unsigned char*)data {
    NSDebug(@"constructing %d x %d images from data", self.width, self.height);
    int l = self.width * self.height * 4;
    CFDataRef   cfdata = CFDataCreate(nil, data, l);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(cfdata);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * self.width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big|kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(self.width, self.height,
                                        bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef,
                                        bitmapInfo,
                                        provider, NULL, NO, renderingIntent);
    if (nil == imageRef) {
        NSDebug1(@"cannot construct an CGIImageRef");
        return;
    }
    image = [UIImage imageWithCGImage: imageRef];
}

@end
