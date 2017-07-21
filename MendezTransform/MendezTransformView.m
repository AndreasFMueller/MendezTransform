//
//  MendezTransformView.m
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezTransformView.h"

@implementation MendezTransformView

@synthesize min, max, color, scale;

- (id)initWithFrame: (CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        n = 0;
        data = NULL;
        min = -0.1;
        max = 1.1;
        color = NO;
        scale = 1;
        self.backgroundColor = [UIColor colorWithRed: 0.9 green:0.9 blue:1 alpha:1];
    }
    return self;
}

- (void)dealloc {
    if (data) {
        free(data);
        data = NULL;
    }
}

- (void)setData: (MendezTransformResult*)_data {
    color = _data.color;
    int maxoffset = (self.color) ? 3 : 1;
    if (n != [_data length]) {
        n = _data.length;
        data = (float *)realloc(data, n * sizeof(float) * maxoffset);
    }
    int j = 0;
    for (int offset = 0; offset < maxoffset; offset++) {
        float   *d = [_data dataAtOffset: offset];
        for (int i = 0; i < n; i++) {
            data[j++] = d[i];
        }
    }
    [self setNeedsDisplay];
}

- (void)setDifference: (MendezTransformResult*)a minus: (MendezTransformResult*)b mirror:(BOOL)_mirror {
    if (a.length != b.length) {
        return;
    }
    if (a.color != b.color) {
        return;
    }
    color = a.color;
    int maxoffset = (self.color) ? 3 : 1;
    if (a.length != n) {
        n = a.length;
        data = (float *)realloc(data, n * sizeof(float) * maxoffset);
    }
    int j = 0;
    for (int offset = 0; offset < maxoffset; offset++) {
        float   *da = [a dataAtOffset: offset];
        float   *db = [b dataAtOffset: offset];
        for (int i = 0; i < n; i++) {
            if (_mirror) {
                data[j++] = da[i] - db[n - i - 1];
                
            } else {
                data[j++] = da[i] - db[i];
            }
        }
    }
    [self setNeedsDisplay];
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

- (void)drawRectMono:(CGRect)rect {
    if (0 == n) {
        return;
    }
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
#define Y(y) (height * (max - between(scale * y, min, max)) / (max - min))
    
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

- (void)drawRectColor: (CGRect)rect {
    NSLog(@"color display not implemented");
}


- (void)drawRect: (CGRect)rect {
    if (self.color) {
        [self drawRectColor: (CGRect)rect];
    } else {
        [self drawRectMono: (CGRect)rect];
    }
}

- (void)handleTouches:(NSSet*)touches {
    if (0 == [touches count]) {
        return;
    }
    UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex: 0];
    CGPoint where = [touch locationInView: self];
    float origin = self.bounds.origin.x + 20;
    float width = self.bounds.size.width - 40;
    float   t = (where.x - origin) / width;
    scale = 1 + 4 * between(t, 0, 1);
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches];
}



@end
