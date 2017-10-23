//
//  MendezTransformsView.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezTransformsView.h"
#import "HelpViewController.h"

@implementation MendezTransformsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#define HEIGHT 30

#define SHOWMIRROR  1

- (void)layoutSubviews {
#if SHOWREVERSE
    float   width = self.bounds.size.width / 4;
#else
    float   width = self.bounds.size.width / 3;
#endif
    float   height = self.bounds.size.height - HEIGHT;

    left.frame       = CGRectMake(            2, HEIGHT + 2, width - 4, height - 4);
    difference.frame = CGRectMake(    width + 2, HEIGHT + 2, width - 4, height - 4);
#if SHOWREVERSE
    reverse.frame    = CGRectMake(2 * width + 2, HEIGHT + 2, width - 4, height - 4);
    right.frame      = CGRectMake(3 * width + 2, HEIGHT + 2, width - 4, height - 4);
#else
    reverse.frame    = CGRectMake(3 * width + 2, HEIGHT + 2, width - 4, height - 4);
    right.frame      = CGRectMake(2 * width + 2, HEIGHT + 2, width - 4, height - 4);
#endif
    
    leftLabel.frame       = CGRectMake(          + 2, 0, width - 4, HEIGHT);
    differenceLabel.frame = CGRectMake(    width + 2, 0, width - 4, HEIGHT);
#if SHOWREVERSE
    reverseLabel.frame    = CGRectMake(2 * width + 2, 0, width - 4, HEIGHT);
    rightLabel.frame      = CGRectMake(3 * width + 2, 0, width - 4, HEIGHT);
#else
    reverseLabel.frame    = CGRectMake(3 * width + 2, 0, width - 4, HEIGHT);
    rightLabel.frame      = CGRectMake(2 * width + 2, 0, width - 4, HEIGHT);
#endif
    
}

- (UILabel *)makeLabel: (NSString*)labeltext {
    UILabel    *result = [[UILabel alloc] init];
    result.text = labeltext;
    [self addSubview: result];
    return result;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor colorWithRed: 0.95 green:0.95 blue:0.95 alpha:1];
    
    left       = [[MendezTransformView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];
    difference = [[MendezTransformView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];
    reverse    = [[MendezTransformView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];
    right      = [[MendezTransformView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];

    [self addSubview: left];
    [self addSubview: difference];
    [self addSubview: reverse];
    [self addSubview: right];

    difference.min = -0.5;
    difference.max = 0.5;
    reverse.min = -0.5;
    reverse.max = 0.5;

    leftLabel       = [self makeLabel: @"Left"];
    differenceLabel = [self makeLabel: @"Difference"];
    reverseLabel    = [self makeLabel: @"Mirrored Difference"];
    rightLabel      = [self makeLabel: @"Right"];
    
    [self setNeedsLayout];
}

- (void)setTransformsLeft: (MendezTransformResult*)a right: (MendezTransformResult*)b {
    [left setData: a];
    [right setData: b];
    [difference setDifference: a minus: b mirror: NO];
    [reverse setDifference: a minus: b mirror: YES];
}

- (NSUInteger)recommendedTransformSize {
    return left.bounds.size.width;
}

@end
