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

@synthesize leftTransform, rightTransform, differenceTransform, mirroredDifferenceTransform, spheresView;

- (SCNVector3)axis {
    return spheresView.axis;
}

- (void)resizeSubviews {
    spheresView.frame = CGRectMake(0, 0 * self.bounds.size.width/2, self.bounds.size.width, self.bounds.size.width/2);
    float twidth = self.bounds.size.width / 4;
    float labelheight = 30;
    float controlsheight = 100;
    float theight = self.bounds.size.height - self.bounds.size.width/2 - controlsheight - labelheight;
    float typosition = self.bounds.size.width/2 + 2 + labelheight;

    leftTransform.frame = CGRectMake(2, typosition, twidth - 4, theight - 4);
    rightTransform.frame = CGRectMake(3 * twidth + 2, typosition, twidth - 4, theight - 4);
    differenceTransform.frame = CGRectMake(twidth + 2, typosition, twidth - 4, theight - 4);
    mirroredDifferenceTransform.frame = CGRectMake(2 * twidth + 2, typosition, twidth - 4, theight - 4);
    
    leftLabel.frame = CGRectMake(0, typosition - labelheight, twidth, labelheight);
    rightLabel.frame = CGRectMake(3 * twidth, typosition - labelheight, twidth, labelheight);
    differenceLabel.frame = CGRectMake(twidth, typosition - labelheight, twidth, labelheight);
    mirroredDifferenceLabel.frame = CGRectMake(2 * twidth, typosition - labelheight, twidth, labelheight);
    
    rotationangle.frame = CGRectMake(0, self.bounds.size.height - controlsheight, self.bounds.size.width/3, controlsheight);
    
    imageSelection.frame = CGRectMake(self.bounds.size.width * 3/4, self.bounds.size.height - controlsheight, self.bounds.size.width / 4, controlsheight);
}

- (void)setupSubviews {
    spheresView = [[SpheresView alloc] initWithFrame: CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width, self.bounds.size.width/2)];
    spheresView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
    [self addSubview: spheresView];
    
    float twidth = self.bounds.size.width / 4;
    float theight = self.bounds.size.height - self.bounds.size.width/2 - 100;
    float typosition = self.bounds.size.width/2 - theight + 2;
    
    leftTransform = [[MendezTransformView alloc] initWithFrame: CGRectMake(2, typosition, twidth - 4, theight - 4)];
    [self addSubview: leftTransform];
    
    rightTransform = [[MendezTransformView alloc] initWithFrame: CGRectMake(3 * twidth + 2, typosition, twidth - 4, theight - 4)];
    [self addSubview: rightTransform];
    
    differenceTransform = [[MendezTransformView alloc] initWithFrame: CGRectMake(twidth + 2, typosition, twidth - 4, theight - 4)];
    [self addSubview: differenceTransform];
    differenceTransform.min = -1.1;
    
    mirroredDifferenceTransform = [[MendezTransformView alloc] initWithFrame: CGRectMake(2 * twidth + 2, typosition, twidth - 4, theight - 4)];
    [self addSubview: mirroredDifferenceTransform];
    mirroredDifferenceTransform.min = -1.1;
    
    leftLabel = [[UILabel alloc] init];
    [self addSubview: leftLabel];
    rightLabel = [[UILabel alloc] init];
    [self addSubview: rightLabel];
    differenceLabel = [[UILabel alloc] init];
    [self addSubview: differenceLabel];
    mirroredDifferenceLabel = [[UILabel alloc] init];
    [self addSubview: mirroredDifferenceLabel];
    
    leftLabel.text = @"Left";
    rightLabel.text = @"Right";
    differenceLabel.text = @"Difference";
    mirroredDifferenceLabel.text = @"Mirrored Difference";
    
    // Slider to set the rotation angle
    rotationangle = [[UISlider alloc] initWithFrame: CGRectMake(0,0,1,1)];
    [self addSubview: rotationangle];
    rotationangle.minimumValue = -M_PI;
    rotationangle.maximumValue = M_PI;
    rotationangle.value = 0;
    
    [rotationangle addTarget: self action:@selector(rotate:) forControlEvents:UIControlEventValueChanged];
    
    // Button to request the image selection
    imageSelection = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    [imageSelection setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [imageSelection setTitle: @"Select Image" forState: UIControlStateNormal];

    [self addSubview: imageSelection];
    
    // now resize all the subviews
    [self resizeSubviews];
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

- (IBAction)rotate: (id)sender {
    float   angle = rotationangle.value;
    SCNVector3  a = self.axis;
    [spheresView rotate: SCNVector4Make(a.x, a.y, a.z, angle)];
}

- (void)setImage: (NSString*) imagename {
    [spheresView setImage: imagename];
}

- (void)addSelectionTarget: (id)target action: (SEL)action {
    [imageSelection addTarget:target action:action forControlEvents: UIControlEventTouchUpInside];
}



@end
