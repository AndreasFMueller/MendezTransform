//
//  MendezView.m
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezView.h"
#import "ImageSelectionController.h"

@implementation MendezView

- (SCNVector3)axis {
    return spheresView.axis;
}

- (void)layoutSubviews {
    NSLog(@"MendezView layoutSubviews");
    spheresView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width/2);
    float controlsheight = 80;
    float height = self.bounds.size.height - self.bounds.size.width/2 - controlsheight;
    
    transformsView.frame = CGRectMake(0, self.bounds.size.width/2,
                                      self.bounds.size.width, height);
    
    rotationangle.frame = CGRectMake(0, self.bounds.size.height - controlsheight,
                                     self.bounds.size.width/3, controlsheight);
    resetRotationButton.frame = CGRectMake(self.bounds.size.width/3, self.bounds.size.height - controlsheight,
                                           2 * controlsheight, controlsheight);
    
    imageSelectionButton.frame = CGRectMake(self.bounds.size.width * 3/4, self.bounds.size.height - controlsheight, self.bounds.size.width / 4, controlsheight);
}

- (void)setupSubviews {
    spheresView = [[SpheresView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    spheresView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
    [self addSubview: spheresView];
    
    transformsView = [[MendezTransformsView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    [self addSubview: transformsView];
    
    // Slider to set the rotation angle
    rotationangle = [[UISlider alloc] initWithFrame: CGRectMake(0,0,1,1)];
    [self addSubview: rotationangle];
    rotationangle.minimumValue = -M_PI;
    rotationangle.maximumValue = M_PI;
    rotationangle.value = 0;
    
    [rotationangle addTarget: self action:@selector(rotate:) forControlEvents:UIControlEventValueChanged];
    
    resetRotationButton = [[UIButton alloc] init];
    [resetRotationButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [resetRotationButton setTitle: @"Reset" forState: UIControlStateNormal];
    [resetRotationButton addTarget: self action: @selector(rotate0:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: resetRotationButton];
    
    // Button to request the image selection
    imageSelectionButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    [imageSelectionButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [imageSelectionButton setTitle: @"Select Image" forState: UIControlStateNormal];

    [self addSubview: imageSelectionButton];
    
    // now resize all the subviews
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        NSLog(@"bounds: %fx%f", frame.size.width, frame.size.height);
        [self setupSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        NSLog(@"bounds: %fx%f", self.bounds.size.width, self.bounds.size.height);
        [self setupSubviews];
    }
    return self;
}

- (void)rotateAngle: (float)angle {
    SCNVector3  a = self.axis;
    [spheresView rotate: SCNVector4Make(a.x, a.y, a.z, angle)];
}


- (IBAction)rotate: (id)sender {
    [self rotateAngle: rotationangle.value];
}

- (IBAction)rotate0: (id)sender {
    rotationangle.value = 0;
    [self rotateAngle: 0];
}


- (void)setImage: (NSString*) imagename {
    [spheresView setImage: imagename];
}

- (void)addSelectionTarget: (id)target action: (SEL)action {
    [imageSelectionButton addTarget:target action:action forControlEvents: UIControlEventTouchUpInside];
}

- (void)addAxisTarget: (id)_target action: (SEL)_action {
    [spheresView addTouchTarget:_target action: _action];
}

- (void)setTransforms: (int)n left: (float*)a right: (float*)b {
    [transformsView setTransforms: n left: a right: b];
}


@end
