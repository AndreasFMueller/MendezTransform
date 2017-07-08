//
//  SpherePoint.m
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpherePoint.h"

spherepoint vector2point(float v[3]) {
    spherepoint result;
    float l = hypotf(v[0], v[1]);
    if (l == 0) {
        result.theta = (v[0] > 0) ? 0 : M_PI;
    } else {
        result.theta = acos(v[2] / l);
    }
    result.phi = atan2f(v[1], v[0]);
    return result;
}

void    point2vector(spherepoint p, float v[3]) {
    v[0] = sinf(p.theta) * cosf(p.phi);
    v[1] = sinf(p.theta) * sinf(p.phi);
    v[2] = cosf(p.theta);
}
