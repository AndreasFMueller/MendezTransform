//
//  AxisImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 17.11.19.
//  Copyright © 2019 Andreas Müller. All rights reserved.
//

#import "AxisImage.h"
#import "Debug.h"

@implementation AxisImage

- (id)initWithSize: (CGSize) size direction: (int)d {
    self = [super initWithSize: size];
    if (self) {
        _direction = d;
        int width = size.width;
        int height = size.height;
        int l = width * height * 4;
        unsigned char *data = (unsigned char *)malloc(l);
        for (int i = 0; i < l; i++) {
            data[i] = ((i % 4) == 3) ? 255 : 0;
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
                //NSDebug(@"%d %d %d", x, y, z);
                switch (_direction) {
                    case DIRECTION_X:
                        w[0] = (x >= 0) ? 255 : 0;
                        break;
                    case DIRECTION_Y:
                        w[1] = (y >= 0) ? 255 : 0;
                        break;
                    case DIRECTION_Z:
                        w[2] = (z >= 0) ? 255 : 0;
                        break;
                }
                w += 4;
            }
        }
        [self imageFromData: data];
        free(data);
    }
    return self;
}

@end
