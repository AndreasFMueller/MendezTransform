//
//  GridImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "GridImage.h"

@implementation GridImage

@synthesize lines;

- (id)initWithSize: (CGSize)size lines: (NSUInteger)_lines {
    self = [super initWithSize: size];
    if (nil == self) {
        return nil;
    }
    lines = _lines;
    // create image
    int width = size.width;
    int height = size.height;
    int l = width * height * 4;
    unsigned char *data = (unsigned char *)malloc(l);
    for (int i = 0; i < l; i++) {
        data[i] = 255;
    }
    
    unsigned char   *w = data;
    int tstep = height / (2 * lines);
    int pstep = width / (4 * lines);
    for (int t = 0; t < height; t++) {
        for (int p = 0; p < width; p++) {
            float   phi = 2 * M_PI * p / (float)width;
            float   theta = M_PI * t / (float)height;
            float   s = sinf(theta);
            float   x = s * cosf(phi);
            float   y = s * sinf(phi);
            float   z = cosf(theta);
            unsigned char c[3] = { 0, 0, 0 };
            int     tt = t / tstep;
            int     pp = p / pstep;
            if ((1 == (tt % 2)) ^ (1 == (pp % 2))) {
                c[0] = 255 * fabsf(x);
                c[1] = 255 * fabsf(y);
                c[2] = 255 * fabsf(z);
            }
            *(w++) = c[0];
            *(w++) = c[1];
            *(w++) = c[2];
            w++;
        }
    }
    
    [self imageFromData: data];
    free(data);
    return self;
}

@end
