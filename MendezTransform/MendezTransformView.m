//
//  MendezTransformView.m
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezTransformView.h"

@implementation MendezTransformView

@synthesize min, max;

- (id)initWithFrame: (CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        n = 0;
        data = NULL;
        min = -0.1;
        max = 1.1;
    }
    return self;
}

- (void)dealloc {
    if (data) {
        free(data);
        data = NULL;
    }
}

- (void)setData: (float*)_data length: (int)_n {
    NSLog(@"got new data length %d", _n);
    if (_n != n) {
        n = _n;
        data = realloc(data, n * sizeof(float));
    }
    for (int i = 0; i < n; i++) {
        data[i] = _data[i];
    }
    [self setNeedsDisplay];
}

- (void)setDifference: (float*)_a minus: (float*)_b length: (int)_n mirror:(BOOL)_mirror {
    if (_n != n) {
        n = _n;
        data = realloc(data, n * sizeof(float));
    }
    for (int i = 0; i < n; i++) {
        if (_mirror) {
            data[i] = _a[i] - _b[n - i - 1];

        } else {
            data[i] = _a[i] - _b[i];
        }
    }
}

float   between(float y, float minvalue, float maxvalue) {
    //NSLog(@"between(%f, %f, %f)", y, minvalue, maxvalue);
    if (y < minvalue) {
        return minvalue;
    }
    if (y > maxvalue) {
        return maxvalue;
    }
    return y;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawing contents of MendezTransformView (size %d)", n);
    // get dimensions for drawing
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

    // start graphics context
    CGContextRef    ctx = UIGraphicsGetCurrentContext();
    
    // fill background rectangle with bright gray color
    CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 1);
    CGContextSetRGBStrokeColor(ctx, 0.9, 0.9, 0.9, 1);
    
    CGContextFillRect(ctx, CGRectMake(0, 0, width, height));
    
    CGContextSetLineWidth(ctx, 2);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
 
#define X(x) (width * x / n)
#define Y(y) (height * (max - between(y, min, max)) / (max - min))
    
    // create a path from all the points
    if (n > 0) {
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, X(0), Y(0));
        for (int i = 0; i < n; i++) {
            CGContextAddLineToPoint(ctx, X(i), Y(data[i]));
        }
        CGContextAddLineToPoint(ctx, X(n-1), Y(0));
        CGContextFillPath(ctx);
    } else {
        NSLog(@"no data to draw");
    }
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, X(0), Y(0));
    CGContextAddLineToPoint(ctx, X(n-1), Y(0));
    CGContextStrokePath(ctx);
}

@end
