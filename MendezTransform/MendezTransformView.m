//
//  MendezTransformView.m
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezTransformView.h"

@implementation MendezTransformView

@synthesize min, max, color, scale, length;

- (NSUInteger)dataLength {
    return ((self.color) ? 3 : 1) * self.length;
}

- (id)initWithFrame: (CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        length = 0;
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
    if ((self.color != _data.color) || (self.length != _data.length)) {
        color = _data.color;
        length = _data.length;
        data = (float *)realloc(data, _data.dataLength * sizeof(float));
        for (int i = 0; i < _data.dataLength; i++) {
            data[i] = 0;
        }
    }
    int j = 0;
    int maxoffset = (self.color) ? 3 : 1;
    for (int offset = 0; offset < maxoffset; offset++) {
        float   *d = [_data dataAtOffset: offset];
        for (int i = 0; i < self.length; i++) {
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
    if ((self.color != a.color) || (self.length != a.length)) {
        color = a.color;
        length = a.length;
        data = (float *)realloc(data, a.dataLength * sizeof(float));
        for (int i = 0; i < a.dataLength; i++) {
            data[i] = 0;
        }
    }
    int j = 0;
    int maxoffset = (self.color) ? 3 : 1;
    for (int offset = 0; offset < maxoffset; offset++) {
        float   *da = [a dataAtOffset: offset];
        float   *db = [b dataAtOffset: offset];
        for (int i = 0; i < self.length; i++) {
            if (_mirror) {
                data[j++] = da[i] - db[self.length - i - 1];
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

- (void)drawBackground {
    // get dimensions for drawing
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

    // start graphics context
    CGContextRef    ctx = UIGraphicsGetCurrentContext();
    
    // fill background rectangle with bright gray color
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    
    CGContextFillRect(ctx, CGRectMake(0, 0, width, height));
}

- (void)drawMonoData: (float *)_data color: (CGColorRef)_color {
    // get dimensions for drawing
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    // start graphics context
    CGContextRef    ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, _color);
    
#define X(x) (width * x / self.length)
#define Y(y) (height * (max - between(scale * y, min, max)) / (max - min))
    
    // create a path from all the points
    if (self.length > 0) {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, X(0), Y(0));
        for (int i = 0; i < self.length; i++) {
            CGContextAddLineToPoint(ctx, X(i), Y(_data[i]));
        }
        CGContextAddLineToPoint(ctx, X(self.length-1), Y(0));
        CGContextFillPath(ctx);
    } else {
        NSLog(@"no data to draw");
    }
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, X(0), Y(0));
    CGContextAddLineToPoint(ctx, X(self.length-1), Y(0));
    CGContextStrokePath(ctx);
}

- (void)drawRectMono:(CGRect)rect {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceCMYK();
    CGFloat components[5] = { 0, 0, 0, 1, 1 };
    CGColorRef  _color = CGColorCreate(colorspace, components);
    [self drawMonoData: data color: _color];
}

- (void)drawRectColor: (CGRect)rect {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceCMYK();
    CGFloat redcomponents[5] = { 0, 0.8, 0.8, 0, 1 };
    [self drawMonoData: data color: CGColorCreate(colorspace, redcomponents)];
    CGFloat greencomponents[5] = { 0.8, 0, 0.8, 0, 0.5 };
    [self drawMonoData: data + self.length color: CGColorCreate(colorspace, greencomponents)];
    CGFloat bluecomponents[5] = { 0.8, 0.6, 0, 0, 0.5 };
    [self drawMonoData: data + 2 * self.length color: CGColorCreate(colorspace, bluecomponents)];
}

- (void)drawRect: (CGRect)rect {
    if (0 == self.length) {
        return;
    }
    [self drawBackground];
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
