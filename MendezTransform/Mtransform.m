//
//  Mtransform.m
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mtransform.h"
#import "Rotation.h"

@implementation Mtransform

@synthesize width, height;

- (id)initWidth: (NSUInteger)w height:(NSUInteger)h {
    self = [super init];
    if (self) {
        width = w;
        height = h;
        zvalues = (float *)malloc(h * sizeof(float));
        svalues = (float *)malloc(h * sizeof(float));
        xvalues = (float *)malloc(w * sizeof(float));
        yvalues = (float *)malloc(w * sizeof(float));
        for (int thetai = 0; thetai < height; thetai++) {
            float   theta = (thetai + 0.5) * (M_PI / height);
            zvalues[thetai] = cosf(theta);
            svalues[thetai] = sinf(theta);
        }
        for (int phii = 0; phii < width; phii++) {
            float phi = (phii + 0.5) * (2 * M_PI / width);
            xvalues[phii] = cosf(phi);
            yvalues[phii] = sinf(phi);
        }
    }
    return self;
}

- (void)transform: (float*)data axis: (float[3])axis function: (SphereFunction*)f {
    NSLog(@"Computation of the Mendez-Transform start");
    // compute the angle
    float   l = hypotf(axis[0], axis[1]);
    float   angle = atan2f(l, axis[2]);
    
    // compute a rotation axis that brings the z-axis to axis
    float   raxis[3];
    if (0 == l) {
        raxis[0] = 0;
        raxis[1] = 0;
        raxis[2] = 1;
    } else {
        raxis[0] = angle * (-axis[1] / l);
        raxis[1] = angle * ( axis[0] / l);
        raxis[2] = 0;
    }
    // create the rotation from this axis
    Rotation    *rotation = [[Rotation alloc] init: raxis];
    for (int i = 0; i < height; i++) {
        float   z = zvalues[i];
        float   s = svalues[i];
        float   S = 0;
        for (int j = 0; j < width; j++) {
            float   v[3];
            v[0] = s * xvalues[j];
            v[1] = s * yvalues[j];
            v[2] = z;
            float   w[3];
            [rotation rotate: v to: w];
            S += [f value: w];
        }
        data[i] = S / height;
    }
    NSLog(@"Mendez-Transform computation complete");
}

- (void)dealloc {
    free(xvalues);
    free(yvalues);
    free(zvalues);
    free(svalues);
}

@end
