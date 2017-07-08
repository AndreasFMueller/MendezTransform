//
//  SphereGrid.h
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SphereGrid : NSObject {
    float  *z;
    float  *s;
    float  *xvalues;
    float  *yvalues;
}

@property (readwrite) int width;
@property (readwrite) int height;

- (id)initWidth: (int)_width height: (int)_height;
- (void)dealloc;

- (int)hoffset: (float)phi;
- (int)voffset: (float)theta;

- (int)hoffsetV: (float[3])vec;
- (int)voffsetV: (float[3])vec;

- (float)phi: (float[3])vec;
- (float)theta: (float[3])vec;

@end

