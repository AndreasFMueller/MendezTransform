//
//  SpherePoint.h
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#ifndef SpherePoint_h
#define SpherePoint_h

typedef struct spherepoint {
    float phi;
    float theta;
} spherepoint;

spherepoint vector2point(float v[3]);

void    point2vector(spherepoint p, float v[3]);

#endif /* SpherePoint_h */
