//
//  MendezTransformResult.m
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezTransformResult.h"

@implementation MendezTransformResult

@synthesize length, color;

- (NSUInteger)dataLength {
    return ((self.color) ? 3 : 1) * length;
}

- (id)init: (NSUInteger)_length color: (BOOL)_color {
    self = [super init];
    if (self) {
        color = _color;
        maxoffset = (color) ? 3 : 1;
        length = _length;
        data = (float *)calloc(length * maxoffset, sizeof(float));
        NSUInteger maxi = maxoffset * length;
        for (NSUInteger i = 0; i < maxi; i++) {
            data[i] = 0;
        }
    }
    return self;
}

- (float*)dataAtOffset: (int)offset {
    int o = offset;
    if (o >= maxoffset) {
        o = maxoffset - 1;
    }
    return &data[o * length];
}

- (void)dealloc {
    if (data) { free(data); }
}

@end
