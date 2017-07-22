//
//  Rotation.h
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SpherePoint.h"
#import "VectorTypes.h"

@interface Rotation : NSObject {
    float m[9];
}

- (id)init: (float[3])axis;
- (id)initVector: (AppVector3)axis;
- (spherepoint)point: (float[3])v;
- (void)vector: (float[3])v frompoint: (spherepoint)x;
- (spherepoint)rotate: (spherepoint)x;
- (void)rotate: (float[3])v to: (float[3])w;

@end

