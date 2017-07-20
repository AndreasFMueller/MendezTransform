//
//  SphereGrid.h
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Rotation.h"

@interface SphereGrid : NSObject {
    float  *z;
    float  *s;
    float  *xvalues;
    float  *yvalues;
}

@property (readwrite,retain) Rotation *rotation;

@property (readonly) NSUInteger width;
@property (readonly) NSUInteger height;

- (void)resizeWidth: (NSUInteger)_width height: (NSUInteger)_height;

- (id)init;
- (id)initWidth: (NSUInteger)_width height: (NSUInteger)_height;
- (void)dealloc;

- (NSUInteger)hoffset: (float)phi;
- (NSUInteger)voffset: (float)theta;

- (void)prepare: (float[3])v to: (float[3])w;

- (NSUInteger)hoffsetV: (float[3])vec;
- (NSUInteger)voffsetV: (float[3])vec;

- (float)phi: (float[3])vec;
- (float)theta: (float[3])vec;

@end

