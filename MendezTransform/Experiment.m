//
//  Experiment.m
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Experiment.h"
#import "Mtransform.h"
#import "SpherePoint.h"

@implementation Experiment

- (id)init: (NSString*)imagefilename {
    NSLog(@"opening image %@", imagefilename);
    self = [super init];
    if (self) {
        NSLog(@"creating the experiment");
        image = [UIImage imageNamed: imagefilename];
        if (nil == image) {
            NSLog(@"no image");
        }
        NSLog(@"image size: %.0fx%.0f", image.size.width, image.size.height);
    }
    return self;
}

#define Mtransform_size 1000

- (void)run {
    SphereFunction  *f = [[SphereFunction alloc] init: image];
    Mtransform  *M = [[Mtransform alloc] initWidth: Mtransform_size height: Mtransform_size];
    spherepoint sp;
    sp.phi = M_PI / 6;
    sp.theta = M_PI / 6;
    float   v[3];
    point2vector(sp, v);
    float   result[Mtransform_size];
    [M transform: result axis: v function: f];
    for (int i = 0; i < Mtransform_size; i++) {
        NSLog(@"Mf[%3d] = %7.4f", i, result[i]);
    }
}

@end
