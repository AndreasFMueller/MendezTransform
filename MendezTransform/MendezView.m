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

- (AppVector3)axis {
    return SCN2App3(spheresView.axis);
}

- (void)setAxis: (AppVector3)a {
    // XXX
    axis = App2SCN3(a);
}

- (void)layoutSubviews {
    NSLog(@"MendezView layoutSubviews");
    spheresView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width/2);
    
    float controlsheight = 80;
    float height = self.bounds.size.height - self.bounds.size.width/2 - controlsheight;
    
    float buttonunit = self.bounds.size.width / 12;
    float buttony = self.bounds.size.height - controlsheight;
    
    transformsView.frame = CGRectMake(0, self.bounds.size.width/2,
                                      self.bounds.size.width, height);
    
    comparingButton.frame = CGRectMake(3, buttony + 3, 2 * buttonunit - 6, controlsheight - 6);
    fineButton.frame = CGRectMake(2 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    
    axisButton.frame = CGRectMake(3 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    
    randomButton.frame = CGRectMake(4 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    colorButton.frame = CGRectMake(8 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    smoothButton.frame = CGRectMake(9 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    
    imageSelectionButton.frame = CGRectMake(10 * buttonunit + 3, buttony + 3, 2 * buttonunit - 6, controlsheight - 6);
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95];
    
    spheresView = [[SpheresView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    spheresView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
    [self addSubview: spheresView];
    
    transformsView = [[MendezTransformsView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    [self addSubview: transformsView];
    
    comparingButton = [[UIButton alloc] init];
    comparingButton.backgroundColor = [UIColor whiteColor];
    [comparingButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [comparingButton setTitle: @"Rotate" forState: UIControlStateNormal];
    [comparingButton addTarget: self action: @selector(toggleComparing:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: comparingButton];
    
    fineButton = [[UIButton alloc] init];
    fineButton.backgroundColor = [UIColor whiteColor];
    [fineButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [fineButton setTitle: @"Fine" forState: UIControlStateNormal];
    [fineButton addTarget: self action: @selector(toggleFine:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: fineButton];
    
    axisButton = [[UIButton alloc] init];
    axisButton.backgroundColor = [UIColor whiteColor];
    [axisButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [axisButton setTitle: @"Axis" forState: UIControlStateNormal];
    [axisButton addTarget: spheresView action: @selector(toggleAxis:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: axisButton];
    
    randomButton = [[UIButton alloc] init];
    randomButton.backgroundColor = [UIColor whiteColor];
    [randomButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [randomButton setTitle: @"Random" forState: UIControlStateNormal];
    [self addSubview: randomButton];
    
    smoothButton = [[UIButton alloc] init];
    smoothButton.backgroundColor = [UIColor whiteColor];
    [smoothButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [smoothButton setTitle: @"Smooth" forState: UIControlStateNormal];
    [self addSubview: smoothButton];
    
    // Button to switch to color mode
    colorButton = [[UIButton alloc] init];
    colorButton.backgroundColor = [UIColor whiteColor];
    [colorButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [colorButton setTitle: @"Mono" forState: UIControlStateNormal];
    [colorButton addTarget: self action: @selector(colorPressed:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: colorButton];
    
    // Button to request the image selection
    imageSelectionButton = [[UIButton alloc] init];
    imageSelectionButton.backgroundColor = [UIColor whiteColor];
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
    SCNVector3  a = axis;
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

- (void)setImage: (UIImage*) image {
    [spheresView setImage: image];
}

- (void)addSelectionTarget: (id)target action: (SEL)action {
    [imageSelectionButton addTarget:target action:action forControlEvents: UIControlEventTouchUpInside];
}

- (void)addAxisChangedTarget: (id)_target action: (SEL)_action {
    [spheresView addAxisChangedTarget:_target action: _action];
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

- (AppVector3)prerotation {
    return SCN2App3(spheresView.prerotation);
}

- (void)setPrerotation:(AppVector3)r {
    NSLog(@"setting prerotation in MendezView");
    spheresView.prerotation = App2SCN3(r);
}

- (void)addRandomButtonTarget: (id)target action: (SEL)action {
    [randomButton addTarget: target action: action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSmoothButtonTarget: (id)target action: (SEL)action {
    [smoothButton addTarget: target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
