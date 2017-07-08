//
//  SphereGrid.m
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SphereGrid.h"

@implementation SphereGrid

@synthesize width, height;

- (id)initWidth: (int)_width height: (int)_height {
    self = [super init];
    if (self) {
        height = _height;
        width = _width;
        if (0 != (_width % 8)) {
            NSLog(@"width is not divisible by 4");
        }
        z = (float *)malloc((height + 1) * sizeof(float));
        s = (float *)malloc((height + 1) * sizeof(float));
        xvalues = (float *)malloc((width + 1) * sizeof(float));
        yvalues = (float *)malloc((width + 1) * sizeof(float));
        int thetai;
        for (thetai = 0; thetai <= height; thetai++) {
            float   theta = thetai * M_PI / height;
            z[thetai] = cos(theta);
            s[thetai] = sin(theta);
        }
        int phii;
        for (phii = 0; phii <= width; phii++) {
            float   phi = phii * 2 * M_PI / width;
            xvalues[phii] = cos(phi);
            yvalues[phii] = sin(phi);
        }
    }
    return self;
}

- (void)dealloc {
    free(z);
    free(s);
    free(xvalues);
    free(yvalues);
}

- (int)hoffset: (float)phi {
    int h = truncf((phi / 2 * M_PI) * width);
    return h;
}

- (int)voffset: (float)theta {
    int v = truncf((theta / M_PI) * height);
    return v;
}

static int findinterval(float *r, float R, int min, int max) {
    //NSLog(@"look for %f between %d (%f) and %d (%f)", R, min, r[min], max, r[max]);
    if (1 == (max - min)) {
        return min;
    }
    int mid = (max + min) / 2;
    float   Rmid = r[mid];
    if ((r[min] <= R) && (R < Rmid)) {
        return findinterval(r, R, min, mid);
    }
    int result = findinterval(r, R, mid, max);
    //NSLog(@"result index: %d (%f)", result, r[result]);
    return result;
}

static int rfindinterval(float *r, float R, int min, int max) {
    //NSLog(@"look for %f between %d (%f) and %d (%f) (reverse)", R, min, r[min], max, r[max]);

    if (1 == (max - min)) {
        return min;
    }
    int mid = (max + min) / 2;
    float   Rmid = r[mid];
    if ((r[min] > R) && (R >= Rmid)) {
        return rfindinterval(r, R, min, mid);
    }
    int result = rfindinterval(r, R, mid, max);
    //NSLog(@"result index: %d (%f)", result, r[result]);
    return result;
}

- (int)hoffsetV: (float[3])vec {
    //NSLog(@"find hoffset for %f,%f,%f", vec[0], vec[1], vec[2]);
    float l = hypotf(vec[0], vec[1]);
    if (0 == l) {
        return 0;
    }
    float xx = vec[0] / l;
    float yy = vec[1] / l;
    //NSLog(@"xx = %f, yy = %f", xx, yy);
    //
    if ((xx >= 0) && (yy >= 0) && (yy <= xx)) {
        //NSLog(@"0 - 45 Grad");
        return findinterval(yvalues, yy, 0, self.width / 8);
    }
    
    if ((yy >= 0) && (yy >= xx) && (yy >= -xx)) {
        //NSLog(@"45 - 135 Grad");
        return rfindinterval(xvalues, xx, self.width / 8, 3 * self.width / 8);
    }
    
    if ((xx <= 0) && (xx <= yy) && (yy <= -xx)) {
        //NSLog(@"135 - 215 Grad");
        return rfindinterval(yvalues, yy, 3 * self.width / 8, 5 * self.width / 8);
    }
    
    if ((yy <= 0) && (yy <= xx) && (xx <= -yy)) {
        //NSLog(@"215 - 305 Grad");
        return findinterval(xvalues, xx, 5 * self.width / 8, 7 * self.width / 8);
    }
    
    if ((yy <= 0) && (xx >= 0) && (-yy <= xx)) {
        //NSLog(@"305 - 360 Grad");
        return findinterval(yvalues, yy, 7 * self.width / 8, self.width);
    }
    
    NSLog(@"point not found: xx = %f, yy = %f", xx, yy);
    return 0;
}

- (int)voffsetV: (float[3])vec {
    //NSLog(@"find the voffset for %f,%f,%f", vec[0], vec[1], vec[2]);
    float zz = vec[2];
    return height - 1 - rfindinterval(z, zz, 0, height);
}

- (float)phi: (float[3])vec {
    return [self hoffsetV: vec] * 2 * M_PI / self.width;
}

- (float)theta: (float[3])vec {
    return (self.height - 1 - [self voffsetV: vec]) * M_PI / self.height;
}

@end

