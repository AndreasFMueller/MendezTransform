//
//  MendezView.h
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "MendezTransformView.h"
#import "SpheresView.h"

@interface MendezView : UIView {
    UILabel *leftLabel;
    UILabel *rightLabel;
    UILabel *differenceLabel;
    UILabel *mirroredDifferenceLabel;
    UISlider    *rotationangle;
}

@property (retain,readwrite) SpheresView *spheresView;
@property (retain,readwrite) MendezTransformView *leftTransform;
@property (retain,readwrite) MendezTransformView *rightTransform;
@property (retain,readwrite) MendezTransformView *differenceTransform;
@property (retain,readwrite) MendezTransformView *mirroredDifferenceTransform;
@property (readwrite) SCNVector3    axis;

- (void)setupSubviews;
- (void)resizeSubviews;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (IBAction)rotate: (id)sender;

- (void)setImage: (NSString*)imagename;

@end
