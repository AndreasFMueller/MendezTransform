//
//  MendezView.h
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "MendezTransformsView.h"
#import "SpheresView.h"
#import "MendezTransformResult.h"

@interface MendezView : UIView {
    IBOutlet UIButton   *comparingButton;
    IBOutlet UIButton   *fineButton;
    IBOutlet UIButton   *imageSelectionButton;
    IBOutlet SpheresView    *spheresView;
    IBOutlet MendezTransformsView   *transformsView;
}

@property (readonly) SCNVector3    axis;

- (void)setupSubviews;
- (void)layoutSubviews;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)rotateAngle: (float)angle;
- (void)toggleComparing: (id)sender;

- (NSUInteger)recommendedTransformSize;

// stuff related to image selection
- (void)setImage: (NSString*)imagename;
- (void)addSelectionTarget: (id)target action: (SEL)action;

// stuff related to the touch interactions to determine the axis
- (void)addAxisTarget: (id)target action: (SEL)action;
- (void)setTransforms: (NSUInteger)n left: (float*)a right: (float*)b;
- (void)setTransformsLeft: (MendezTransformResult*)left right: (MendezTransformResult*)right;
- (void)toggleFine:(id)sender;

@end
