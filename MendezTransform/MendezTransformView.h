//
//  MendezTransformView.h
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MendezTransformResult.h"

@interface MendezTransformView : UIView {
    NSUInteger n;
    float *data;
}

@property (readwrite) float min;
@property (readwrite) float max;
@property (readwrite) BOOL color;
@property (readwrite) float scale;

- (id)initWithFrame: (CGRect)frame;
- (void)dealloc;
- (void)setData: (MendezTransformResult*)data;
- (void)setDifference: (MendezTransformResult*)a minus: (MendezTransformResult*)b mirror:(BOOL)_mirror;
- (void)drawRectColor: (CGRect)rect;
- (void)drawRectMono: (CGRect)rect;

- (void)handleTouches:(NSSet*)touches;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
