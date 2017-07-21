//
//  StripeImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "StripeImage.h"

@implementation StripeImage

@synthesize stripes;

- (id)initWithSize: (CGSize)size stripes: (int)s {
    self = [super initWithSize: size];
    if (self) {
        stripes = s;
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
                float   s = stripes * sinf(theta);
                int   x = roundf(s * cosf(phi));
                int   y = roundf(s * sinf(phi));
                int   z = roundf(stripes * cosf(theta));
                //NSLog(@"%d %d %d", x, y, z);
                *(w++) = 255 * ((2 * stripes + x) % 2);
                *(w++) = 255 * ((2 * stripes + y) % 2);
                *(w++) = 255 * ((2 * stripes + z) % 2);
                w++;
            }
        }
        [self imageFromData: data];
        free(data);
    }
    return self;
}

@end
