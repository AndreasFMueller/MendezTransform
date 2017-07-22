//
//  Rotation.m
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rotation.h"
#import "SpherePoint.h"

@implementation Rotation

static float sqr(float x) { return x * x; }

- (id)init: (float[3])axis {
    self = [super init];
    if (self) {
        float angle = sqrtf(sqr(axis[0]) + sqr(axis[1]) + sqr(axis[2]));
        float c = cosf(angle);
        float s = sinf(angle);
        float v[3] = { axis[0] / angle, axis[1] / angle, axis[2] / angle };
        m[0] = sqr(v[0]) * (1 - c) + c;
        m[1] = v[0] * v[1] * (1 - c) + v[2] * s;
        m[2] = v[0] * v[2] * (1 - c) - v[1] * s;
        m[3] = v[0] * v[1] * (1 - c) - v[2] * s;
        m[4] = sqr(v[1]) * (1 - c) + c;
        m[5] = v[2] * v[1] * (1 - c) + v[0] * s;
        m[6] = v[0] * v[2] * (1 - c) + v[1] * s;
        m[7] = v[1] * v[2] * (1 - c) - v[0] * s;
        m[8] = sqr(v[2]) * (1 - c) + c;
    }
    return self;
}

- (id)initVector:(AppVector3)axis {
    float a[3] = { axis.x, axis.y, axis.z };
    return [self init: a];
}

- (void)rotate: (float[3])v to: (float[3]) w {
    w[0] = m[0] * v[0] + m[3] * v[1] + m[6] * v[2];
    w[1] = m[1] * v[0] + m[4] * v[1] + m[7] * v[2];
    w[2] = m[2] * v[0] + m[5] * v[1] + m[8] * v[2];
}

- (spherepoint)rotate: (spherepoint)x {
    float v[3];
    [self vector: v frompoint: x];
    float w[3];
    [self rotate: v to: w];
    return [self point: w];
}

- (spherepoint)point: (float[3])v {
    return vector2point(v);
}

- (void)vector: (float[3])v frompoint: (spherepoint)x {
    point2vector(x, v);
}

@end
