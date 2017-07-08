//
//  Mtransform.h
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SphereFunction.h"

@interface Mtransform : NSObject {
    float   *xvalues;
    float   *yvalues;
    float   *zvalues;
    float   *svalues;
}

@property (readonly) int width;
@property (readonly) int height;

- (id)initWidth: (int)w height:(int)h;
- (void)dealloc;

- (void)transform: (float*)data axis: (float[3])axis function: (SphereFunction*)f;

@end
