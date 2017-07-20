//
//  MendezTransformsView.h
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MendezTransformView.h"

@interface MendezTransformsView : UIView {
    MendezTransformView *left;
    MendezTransformView *difference;
    MendezTransformView *reverse;
    MendezTransformView *right;
    UILabel *leftLabel;
    UILabel *differenceLabel;
    UILabel *reverseLabel;
    UILabel *rightLabel;
}

- (id)initWithFrame:(CGRect)frame;

- (void)setTransforms: (int)n left: (float*)a right: (float*)b;
- (void)layoutSubviews;
- (UILabel*)makeLabel: (NSString*)labeltext;

@end
