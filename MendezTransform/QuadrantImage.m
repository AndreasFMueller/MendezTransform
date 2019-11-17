//
//  QuadrantImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 17.11.19.
//  Copyright © 2019 Andreas Müller. All rights reserved.
//

#import "QuadrantImage.h"

@implementation QuadrantImage

- (id)initWithSize: (CGSize)size {
    self = [super initWithSize: size];
    if (self) {
        int width = size.width;
        int height = size.height;
        int l = width * height * 4;
        unsigned char *data = (unsigned char *)malloc(l);
        for (int i = 0; i < l; i++) {
            data[i] = 255;
        }
        unsigned char   *w = data;
        for (int t = 0; t < height; t++) {
            for (int p = 0; p < width; p++) {
                float   phi = 2 * M_PI * p / (float)width;
                float   theta = M_PI * t / (float)height;
                float   s = sinf(theta);
                float   x = s * cosf(phi);
                float   y = s * sinf(phi);
                float   z = cosf(theta);
                //NSLog(@"%d %d %d", x, y, z);
                *(w++) = (x >= 0) ? 255 : 0;
                *(w++) = (y >= 0) ? 255 : 0;
                *(w++) = (z >= 0) ? 255 : 0;
                w++;
            }
        }
        [self imageFromData: data];
        free(data);
    }
    return self;
}

@end
