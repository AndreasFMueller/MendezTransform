//
//  Mtransform.h
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SphereFunction.h"
#import "MendezTransformResult.h"

@interface Mtransform : NSObject {
    float   *xvalues;
    float   *yvalues;
    float   *zvalues;
    float   *svalues;
}

@property (readonly) NSUInteger width;
@property (readonly) NSUInteger height;
@property (readwrite) BOOL color;

- (id)initWidth: (NSUInteger)w height:(NSUInteger)h;
- (void)dealloc;

- (void)transformTo: (float*)data axis: (float[3])axis function: (SphereFunction*)f offset: (int)_offset;
- (MendezTransformResult*)transform: (float[3])axis function: (SphereFunction*)f;

@end
