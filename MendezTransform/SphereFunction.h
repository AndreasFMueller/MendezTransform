//
//  SphereFunction.h
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SphereGrid.h"

@interface SphereFunction : SphereGrid {
    unsigned char   *imageData;
    UIImage *image;
}

@property (readwrite,retain) UIImage    *image;

- (id)init;
- (id)init: (UIImage*)_image;

- (float)valueX: (NSUInteger)x Y: (NSUInteger)y offset:(int)_offset;
- (float)value: (float[3])vec offset:(int)_offset;

- (void)dealloc;

@end
