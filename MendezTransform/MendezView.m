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
    float controlsheight = 80;
    float height = self.bounds.size.height - self.bounds.size.width/2 - controlsheight;
    
    float buttonunit = self.bounds.size.width / 12;
    float buttony = self.bounds.size.height - controlsheight;
    
    transformsView.frame = CGRectMake(0, 0,
                                      self.bounds.size.width, height);
    spheresView.frame = CGRectMake(0, height, self.bounds.size.width, self.bounds.size.width/2);

    comparingButton.frame = CGRectMake(3, buttony + 3, 2 * buttonunit - 6, controlsheight - 6);
    fineButton.frame = CGRectMake(2 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    
    axisButton.frame = CGRectMake(4 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    tailButton.frame = CGRectMake(3 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    
    randomButton.frame = CGRectMake(5 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    colorButton.frame = CGRectMake(8 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    smoothButton.frame = CGRectMake(9 * buttonunit + 3, buttony + 3, buttonunit - 6, controlsheight - 6);
    
    imageSelectionButton.frame = CGRectMake(10 * buttonunit + 3, buttony + 3, 2 * buttonunit - 6, controlsheight - 6);
    
    helpButton.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, 30);
}

- (UIButton *)makeButton: (NSString*)label {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor grayColor] forState: UIControlStateDisabled];
    [button setTitle: label forState: UIControlStateNormal];
    [self addSubview: button];
    return button;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95];
    
    spheresView = [[SpheresView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    spheresView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
    [self addSubview: spheresView];
    
    transformsView = [[MendezTransformsView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    [self addSubview: transformsView];
    
    comparingButton = [self makeButton: @"Rotate"];
    [comparingButton addTarget: self action: @selector(toggleComparing:) forControlEvents: UIControlEventTouchUpInside];
    
    fineButton = [self makeButton: @"Fine"];
    [fineButton addTarget: self action: @selector(toggleFine:) forControlEvents: UIControlEventTouchUpInside];
    
    axisButton = [self makeButton: @"Axis"];
    [axisButton addTarget: spheresView action: @selector(toggleAxis:) forControlEvents: UIControlEventTouchUpInside];
    
    randomButton = [self makeButton: @"Random"];
    
    tailButton = [self makeButton: @"Tail"];
    [tailButton addTarget: spheresView action: @selector(toggleTail:) forControlEvents: UIControlEventTouchUpInside];
    
    smoothButton = [self makeButton:@"Smooth"];
    
    // Button to switch to color mode
    colorButton = [self makeButton:@"Mono"];
    [colorButton addTarget: self action: @selector(colorPressed:) forControlEvents: UIControlEventTouchUpInside];
    
    // Button to request the image selection
    imageSelectionButton = [self makeButton:@"Select Image"];
    
    helpButton = [UIButton buttonWithType: UIButtonTypeInfoDark];
    [self addSubview: helpButton];
    
    // now resize all the subviews
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        NSLog(@"bounds: %fx%f", frame.size.width, frame.size.height);
        [self setupSubviews];
#ifdef DEBUG
        self.tabearoman = NO;
#endif
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        NSLog(@"bounds: %fx%f", self.bounds.size.width, self.bounds.size.height);
        [self setupSubviews];
#ifdef DEBUG
        self.tabearoman = NO;
#endif
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
        randomButton.enabled = NO;
        tailButton.enabled = NO;
    } else {
        [comparingButton setTitle: @"Rotate" forState: UIControlStateNormal];
        randomButton.enabled = YES;
        tailButton.enabled = YES;
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
    if (self.tabearoman) {
        [spheresView setLeftImage: [UIImage imageNamed: @"roman.jpg"]];
    } else {
        [spheresView setLeftImage: image];
    }
    [spheresView setRightImage: image];
}

- (void)addSelectionTarget: (id)target action: (SEL)action {
    [imageSelectionButton addTarget:target action:action forControlEvents: UIControlEventTouchUpInside];
}

- (void)addAxisChangedTarget: (id<AxisChanged>)_target action: (SEL)_action {
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
    if (!colorTarget) { return; }
    SEL selector = NSSelectorFromString(@"colorAction");
    IMP imp = [colorTarget methodForSelector: selector];
    void    (*func)(id, SEL) = (void *)imp;
    func(colorTarget, selector);
    // see https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    // for why this is a good fix for the warning caused by the following code
    //[colorTarget performSelector: colorAction withObject: self];
}

- (AppVector3)prerotation {
    return SCN2App3(spheresView.prerotation);
}

- (void)setPrerotation:(AppVector3)r {
    spheresView.prerotation = App2SCN3(r);
}

- (void)addRandomButtonTarget: (id)target action: (SEL)action {
    [randomButton addTarget: target action: action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSmoothButtonTarget: (id)target action: (SEL)action {
    [smoothButton addTarget: target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addHelpTarget:(id)target action:(SEL)action {
    [helpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
