//
//  VectorTypes.m
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VectorTypes.h"

AppVector3  AppVector3Make(float x, float y, float z) {
    AppVector3 result = { .x = x, .y = y, .z = z };
    return result;
}

AppVector4  AppVector4Make(float x, float y, float z, float w) {
    AppVector4  result = { .x = x, .y = y, .z = z, .w = w };
    return result;
}

AppVector4  AppVector4RotationMake(AppVector3 axis, float angle) {
    AppVector3 a = AppVector3Normalized(axis);
    AppVector4  result = { .x = a.x, .y = a.y, .z = a.z, .w = angle };
    return result;
}

static inline float    sqr(float x) { return x * x; }

float AppVector3Length(AppVector3 a) {
    return sqrtf(sqr(a.x) + sqr(a.y) + sqr(a.z));
}

AppVector3  AppVector3Normalized(AppVector3 a) {
    float l = AppVector3Length(a);
    if (l == 0) {
        return a;
    }
    return AppVector3Make(a.x/l, a.y/l, a.z/l);
}

AppVector3  AppVector3Cross(AppVector3 a, AppVector3 b) {
    return AppVector3Make(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    );
}

float   AppVector3Dot(AppVector3 a, AppVector3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

AppVector3  AppVector3Add(AppVector3 a, AppVector3 b) {
    return AppVector3Make(a.x + b.x, a.y + b.y, a.z + b.z);
}

AppVector3  AppVector3Multiply(AppVector3 a, float b) {
    return AppVector3Make(a.x * b, a.y * b, a.z * b);
}

float   SCNVector3Length(SCNVector3 a) {
    return sqrtf(sqr(a.x) + sqr(a.y) + sqr(a.z));
}

SCNVector3  SCNVector3Normalized(SCNVector3 a) {
    float l = SCNVector3Length(a);
    if (l == 0) {
        return a;
    }
    return SCNVector3Make(a.x/l, a.y/l, a.z/l);
}

SCNVector3  SCNVector3Cross(SCNVector3 a, SCNVector3 b) {
    return SCNVector3Make(
                          a.y * b.z - a.z * b.y,
                          a.z * b.x - a.x * b.z,
                          a.x * b.y - a.y * b.x
                          );
}

float   SCNVector3Dot(SCNVector3 a, SCNVector3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

SCNVector3  SCNVector3Add(SCNVector3 a, SCNVector3 b) {
    return SCNVector3Make(a.x + b.x, a.y + b.y, a.z + b.z);
}

SCNVector3  SCNVector3Multiply(SCNVector3 a, float b) {
    return SCNVector3Make(a.x * b, a.y * b, a.z * b);
}

SCNVector4  SCNVector4RotationMake(SCNVector3 axis, float angle) {
    SCNVector3 a = SCNVector3Normalized(axis);
    return SCNVector4Make(a.x, a.y, a.z, angle);
}

SCNVector3  App2SCN3(AppVector3 v) {
    return SCNVector3Make(-v.x, v.z, v.y);
}

SCNVector4  App2SCN4(AppVector4 v) {
    return SCNVector4Make(-v.x, v.z, v.y, v.w);
}

AppVector3  SCN2App3(SCNVector3 v) {
    return AppVector3Make(-v.x, v.z, v.y);
}

AppVector4  SCN2App4(SCNVector4 v) {
    return AppVector4Make(-v.x, v.z, v.y, v.w);
}

SCNPolar    SCNPolarMake(float phi, float theta, float r) {
    SCNPolar    result = { .phi = phi, .theta = theta, .r = r };
    return result;
}

SCNVector3  SCNPolar2Vector3(SCNPolar p) {
    float   s = p.r * sinf(p.theta);
    float   z = p.r * cosf(p.theta);
    return SCNVector3Make(s * cosf(p.phi), s * sinf(p.phi), z);
}

SCNPolar    SCNVector32Polar(SCNVector3 v) {
    SCNPolar    result;
    result.r = SCNVector3Length(v);
    result.phi = atan2f(v.y, v.x);
    result.theta = acosf(v.z / result.r);
    return result;
}

AppPolar        AppPolarMake(float phi, float theta, float r) {
    AppPolar    result = { .phi = phi, .theta = theta, .r = r };
    return result;
}

AppPolar    AppPolarSub(AppPolar a, AppPolar b) {
    return AppPolarMake(a.phi - b.phi, a.theta - b.theta, 1);
}

AppPolar    AppPolarAdd(AppPolar a, AppPolar b) {
    return AppPolarMake(a.phi + b.phi, a.theta + b.theta, 1);
}

AppPolar    AppPolarMultiply(AppPolar a, float s) {
    return AppPolarMake(s * a.phi, s * a.theta, s * a.r);
}

AppVector3  AppPolar2Vector3(AppPolar p) {
    float   s = p.r * sinf(p.theta);
    float   z = p.r * cosf(p.theta);
    return AppVector3Make(s * cosf(p.phi), s * sinf(p.phi), z);
}

AppPolar    AppVector32Polar(AppVector3 v) {
    AppPolar    result;
    result.r = AppVector3Length(v);
    result.phi = atan2f(v.y, v.x);
    result.theta = acosf(v.z / result.r);
    return result;
}

SCNPolar    App2SCNCPolar(AppPolar p) {
    return SCNVector32Polar(App2SCN3(AppPolar2Vector3(p)));
}

AppPolar    SCN2AppPolar(SCNPolar p) {
    return AppVector32Polar(SCN2App3(SCNPolar2Vector3(p)));
}


