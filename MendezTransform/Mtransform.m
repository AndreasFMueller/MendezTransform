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
#import <stdint.h>
#include <mach/mach_init.h>
#include <mach/thread_act.h>
#include <mach/thread_info.h>
#include "Debug.h"

@implementation Mtransform

@synthesize width, height, color;

typedef struct thread_time {
    int64_t user_time_us;
    int64_t system_time_us;
} thread_time_t;


static int64_t time_value_to_us(time_value_t const t) {
    return (int64_t)t.seconds * 1000000 + t.microseconds;
}

static thread_time_t thread_time() {
    thread_basic_info_data_t basic_info;
    mach_msg_type_number_t count = THREAD_BASIC_INFO_COUNT;
    kern_return_t const result = thread_info(mach_thread_self(), THREAD_BASIC_INFO, (thread_info_t)&basic_info, &count);
    if (result == KERN_SUCCESS) {
        return (thread_time_t){
            .user_time_us   = time_value_to_us(basic_info.user_time),
            .system_time_us = time_value_to_us(basic_info.system_time)
        };
    } else {
        return (thread_time_t){-1, -1};
    }
}

static thread_time_t thread_time_sub(thread_time_t const a, thread_time_t const b) {
    return (thread_time_t){
        .user_time_us   = a.user_time_us   - b.user_time_us,
        .system_time_us = a.system_time_us - b.system_time_us
    };
}

- (id)initWidth: (NSUInteger)w height:(NSUInteger)h {
    self = [super init];
    if (self) {
        width = w;
        height = h;
        color = NO;
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

- (void)transformTo: (float*)data axis: (float[3])axis function: (SphereFunction*)f  offset:(int)_offset {
    thread_time_t   start = thread_time();
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
            S += [f value: w offset: _offset];
        }
        data[i] = S / height;
    }
    thread_time_t   end = thread_time();
    thread_time_t   total = thread_time_sub(end, start);
    NSDebug(@"Mendez-Transform computation complete user: %llu system: %llu", total.user_time_us, total.system_time_us);
}

- (MendezTransformResult *)transform: (float[3])axis function: (SphereFunction*)f {
    MendezTransformResult   *result = [[MendezTransformResult alloc] init: height color: self.color];
    if (!self.color) {
        [self transformTo: [result dataAtOffset: 0] axis: axis function: f offset: 1];
    } else {
        dispatch_group_t    group = dispatch_group_create();
        for (int _offset = 0; _offset < 3; _offset++) {
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self transformTo: [result dataAtOffset: _offset] axis: axis function: f offset: _offset];
            });
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    return result;
}

- (MendezTransformResult *)transformVector:(AppVector3)axis function:(SphereFunction *)f {
    float    v[3];
    v[0] = axis.x;
    v[1] = axis.y;
    v[2] = axis.z;
    return [self transform: v function: f];
}

- (void)dealloc {
    free(xvalues);
    free(yvalues);
    free(zvalues);
    free(svalues);
}

@end
