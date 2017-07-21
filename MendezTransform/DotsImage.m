//
//  DotsImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "DotsImage.h"

@implementation DotsImage

@synthesize dots;

typedef struct dot_s {
    float x;
    float y;
    float z;
    float r;
} dot_t;

- (id)initWithSize: (CGSize)size dots: (NSUInteger)_dots {
    self = [super initWithSize: size];
    if (!self) {
        return nil;
    }
    // create random dots
    dots = _dots;
    dot_t   *dotset = (dot_t *)calloc(3 * self.dots, sizeof(dot_t));
    for (int i = 0; i < 3 * self.dots; i++) {
        float   phi = 2 * M_PI * random() / (float)RAND_MAX;
        float   theta = acos(1 - 2 * random() / (float)RAND_MAX);
        float s = sin(theta);
        dotset[i].z = cos(theta);
        dotset[i].x = s * cos(phi);
        dotset[i].y = s * sin(phi);
        dotset[i].r = 0.02 * (1 + 3 * random() / (float)RAND_MAX);
    }
    
    // create image
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
            unsigned char c[3] = { 0, 0, 0 };
            for (int i = 0; i < 3 * self.dots; i++) {
                float a = acos(dotset[i].x * x + dotset[i].y * y + dotset[i].z * z);
                if (a < dotset[i].r) {
                    c[i % 3] = 255;
                }
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
