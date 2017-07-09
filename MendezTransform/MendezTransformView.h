//
//  MendezTransformView.h
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MendezTransformView : UIView {
    int n;
    float *data;
}

@property (readwrite) float min;
@property (readwrite) float max;

- (id)initWithFrame: (CGRect)frame;
- (void)dealloc;
- (void)setData: (float*)_data length: (int)_n;
- (void)setDifference: (float*)_a minus: (float*)_b length: (int)_n mirror:(BOOL)_mirror;

@end
