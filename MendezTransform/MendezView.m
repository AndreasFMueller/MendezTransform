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
    
    comparingButton.frame = CGRectMake(0, self.bounds.size.height - controlsheight,
                                           2 * controlsheight, controlsheight);
    fineButton.frame = CGRectMake(2 * controlsheight, self.bounds.size.height - controlsheight,
                                  controlsheight, controlsheight);
    
    colorButton.frame = CGRectMake(self.bounds.size.width * 3/4 - controlsheight, self.bounds.size.height - controlsheight, controlsheight, controlsheight);
    
    imageSelectionButton.frame = CGRectMake(self.bounds.size.width * 3/4, self.bounds.size.height - controlsheight, self.bounds.size.width / 4, controlsheight);
}

- (void)setupSubviews {
    spheresView = [[SpheresView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    spheresView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
    [self addSubview: spheresView];
    
    transformsView = [[MendezTransformsView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    [self addSubview: transformsView];
    
    comparingButton = [[UIButton alloc] init];
    [comparingButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [comparingButton setTitle: @"Rotate" forState: UIControlStateNormal];
    [comparingButton addTarget: self action: @selector(toggleComparing:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: comparingButton];
    
    fineButton = [[UIButton alloc] init];
    [fineButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [fineButton setTitle: @"Fine" forState: UIControlStateNormal];
    [fineButton addTarget: self action: @selector(toggleFine:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: fineButton];
    
    // Button to switch to color mode
    colorButton = [[UIButton alloc] init];
    [colorButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [colorButton setTitle: @"Mono" forState: UIControlStateNormal];
    [colorButton addTarget: self action: @selector(colorPressed:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: colorButton];
    
    // Button to request the image selection
    imageSelectionButton = [[UIButton alloc] init];
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

- (void)toggleComparing: (id)sender {
    [self rotateAngle: 0];
    spheresView.comparing = !spheresView.comparing;
    if (spheresView.comparing) {
        [comparingButton setTitle: @"Find Axis" forState: UIControlStateNormal];
    } else {
        [comparingButton setTitle: @"Rotate" forState: UIControlStateNormal];
    }
}

- (void)toggleFine: (id)sender {
    spheresView.fine = !spheresView.fine;
    if (spheresView.fine) {
        [fineButton setTitle: @"Coarse" forState: UIControlStateNormal];
    } else {
        [fineButton setTitle: @"Fine" forState: UIControlStateNormal];
    }
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


- (void)setTransformsLeft: (MendezTransformResult*)left right: (MendezTransformResult*)right {
    [transformsView setTransformsLeft: left right: right];
}

- (NSUInteger)recommendedTransformSize {
    return [transformsView recommendedTransformSize];
}

- (void)addColorTarget: (id)target action: (SEL)action {
    colorTarget = target;
    colorAction = action;
}

- (void)colorPressed: (id)sender {
    if ([colorButton.titleLabel.text isEqualToString: @"Mono" ]) {
        [colorButton setTitle: @"Color" forState: UIControlStateNormal];
    } else {
        [colorButton setTitle: @"Mono" forState: UIControlStateNormal];
    }
    [colorTarget performSelector: colorAction withObject: self];
}

@end
