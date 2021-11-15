//
//  SphereGrid.m
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SphereGrid.h"
#import "Debug.h"

@implementation SphereGrid

@synthesize rotation;

@synthesize width, height;

- (void)resizeWidth: (NSUInteger)_width height: (NSUInteger)_height {
    // remove data if it exists
    if (z) { free(z); }
    if (s) { free(s); }
    if (xvalues) { free(xvalues); }
    if (yvalues) { free(yvalues); }
    
    // check correct dimensions
    height = _height;
    width = _width;
    if (0 != (_width % 8)) {
        NSDebug1(@"width is not divisible by 4");
    }
    
    // allocate data arrays
    z = (float *)malloc((height + 1) * sizeof(float));
    s = (float *)malloc((height + 1) * sizeof(float));
    xvalues = (float *)malloc((width + 1) * sizeof(float));
    yvalues = (float *)malloc((width + 1) * sizeof(float));
    
    // fill arrays
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

- (id)init {
    self = [super init];
    if (self) {
        z = NULL;
        s = NULL;
        xvalues = NULL;
        yvalues = NULL;
        self.rotation = nil;
    }
    return self;
}

- (id)initWidth: (NSUInteger)_width height: (NSUInteger)_height {
    self = [super init];
    if (self) {
        z = NULL;
        s = NULL;
        xvalues = NULL;
        yvalues = NULL;
        [self resizeWidth: _width height: _height];
    }
    return self;
}

- (void)dealloc {
    free(z);
    free(s);
    free(xvalues);
    free(yvalues);
}

- (NSUInteger)hoffset: (float)phi {
    int h = truncf((phi / 2 * M_PI) * width);
    return h;
}

- (NSUInteger)voffset: (float)theta {
    int v = truncf((theta / M_PI) * height);
    return v;
}

static NSUInteger findinterval(float *r, float R, NSUInteger min, NSUInteger max) {
    //NSDebug(@"look for %f between %d (%f) and %d (%f)", R, min, r[min], max, r[max]);
    if (1 == (max - min)) {
        return min;
    }
    NSUInteger mid = (max + min) / 2;
    float   Rmid = r[mid];
    if ((r[min] <= R) && (R < Rmid)) {
        return findinterval(r, R, min, mid);
    }
    NSUInteger result = findinterval(r, R, mid, max);
    //NSDebug(@"result index: %d (%f)", result, r[result]);
    return result;
}

static NSUInteger rfindinterval(float *r, float R, NSUInteger min, NSUInteger max) {
    //NSDebug(@"look for %f between %d (%f) and %d (%f) (reverse)", R, min, r[min], max, r[max]);

    if (1 == (max - min)) {
        return min;
    }
    NSUInteger mid = (max + min) / 2;
    float   Rmid = r[mid];
    if ((r[min] > R) && (R >= Rmid)) {
        return rfindinterval(r, R, min, mid);
    }
    NSUInteger result = rfindinterval(r, R, mid, max);
    //NSDebug(@"result index: %d (%f)", result, r[result]);
    return result;
}

- (NSUInteger)hoffsetV: (float[3])vec {
    float   w[3];
    [self prepare: vec to: w];
    //NSDebug(@"find hoffset for %f,%f,%f", vec[0], vec[1], vec[2]);
    float l = hypotf(w[0], w[1]);
    if (0 == l) {
        return 0;
    }
    float xx = w[0] / l;
    float yy = w[1] / l;
    //NSDebug(@"xx = %f, yy = %f", xx, yy);
    //
    if ((xx >= 0) && (yy >= 0) && (yy <= xx)) {
        //NSDebug1(@"0 - 45 Grad");
        return findinterval(yvalues, yy, 0, self.width / 8);
    }
    
    if ((yy >= 0) && (yy >= xx) && (yy >= -xx)) {
        //NSDebug(@"45 - 135 Grad");
        return rfindinterval(xvalues, xx, self.width / 8, 3 * self.width / 8);
    }
    
    if ((xx <= 0) && (xx <= yy) && (yy <= -xx)) {
        //NSDebug(@"135 - 215 Grad");
        return rfindinterval(yvalues, yy, 3 * self.width / 8, 5 * self.width / 8);
    }
    
    if ((yy <= 0) && (yy <= xx) && (xx <= -yy)) {
        //NSDebug(@"215 - 305 Grad");
        return findinterval(xvalues, xx, 5 * self.width / 8, 7 * self.width / 8);
    }
    
    if ((yy <= 0) && (xx >= 0) && (-yy <= xx)) {
        //NSDebug(@"305 - 360 Grad");
        return findinterval(yvalues, yy, 7 * self.width / 8, self.width);
    }
    
    NSDebug(@"point not found: xx = %f, yy = %f", xx, yy);
    return 0;
}

- (NSUInteger)voffsetV: (float[3])vec {
    float   w[3];
    [self prepare: vec to: w];
    //NSDebug(@"find the voffset for %f,%f,%f", vec[0], vec[1], vec[2]);
    float zz = w[2];
    return height - 1 - rfindinterval(z, zz, 0, height);
}

- (float)phi: (float[3])vec {
    return [self hoffsetV: vec] * 2 * M_PI / self.width;
}

- (float)theta: (float[3])vec {
    return (self.height - 1 - [self voffsetV: vec]) * M_PI / self.height;
}

- (void)prepare: (float[3])v to: (float[3])w {
    if (self.rotation) {
        [self.rotation rotate:v to:w];
    } else {
        for (int i = 0; i < 3; i++) { w[i] = v[i]; }
    }
}


@end

