//
//  VectorTypes.h
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//
#import <SceneKit/SceneKit.h>

#ifndef VectorTypes_h
#define VectorTypes_h

typedef struct AppVector3 {
    float x;
    float y;
    float z;
} AppVector3;

typedef struct AppVector4 {
    float x;
    float y;
    float z;
    float w;
} AppVector4;

AppVector3  AppVector3Make(float x, float y, float z);
AppVector4  AppVector4Make(float x, float y, float z, float w);
AppVector4  AppVector4RotationMake(AppVector3 axis, float angle);

float AppVector3Length(AppVector3 a);
AppVector3  AppVector3Normalized(AppVector3 a);
AppVector3  AppVector3Cross(AppVector3 a, AppVector3 b);
float   AppVector3Dot(AppVector3 a, AppVector3 b);

float   SCNVector3Length(SCNVector3 a);
SCNVector3  SCNVector3Normalized(SCNVector3 a);
SCNVector3  SCNVector3Cross(SCNVector3 a, SCNVector3 b);
float   SCNVector3Dot(SCNVector3 a, SCNVector3 b);

SCNVector4  SCNVector4RotationMake(SCNVector3 axis, float angle);

SCNVector3  App2SCN3(AppVector3 v);
SCNVector4  App2SCN4(AppVector4 v);
AppVector3  SCN2App3(SCNVector3 v);
AppVector4  SCN2App4(SCNVector4 v);

typedef struct SCNPolar {
    float phi;
    float theta;
    float r;
} SCNPolar;

typedef struct AppPolar {
    float phi;
    float theta;
    float r;
} AppPolar;

SCNPolar    SCNPolarMake(float phi, float theta, float r);
SCNVector3  SCNPolar2Vector3(SCNPolar p);
SCNPolar    SCNVector32Polar(SCNVector3 v);

AppPolar    AppPolarMake(float phi, float theta, float r);
AppVector3  AppPolar2Vector3(AppPolar p);
AppPolar    AppVector32Polar(AppVector3 v);

AppPolar    SCN2AppPolar(SCNPolar p);
SCNPolar    App2SCNPolar(AppPolar p);

#endif /* VectorTypes_h */
