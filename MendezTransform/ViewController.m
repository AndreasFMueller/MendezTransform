//
//  ViewController.m
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ViewController.h"
#import "SphereFunction.h"
#import "Mtransform.h"
#import "SpherePoint.h"
#import "MendezView.h"
#import "ImageSelectionController.h"

@interface ViewController ()

@end

@implementation ViewController

#define prerotate (M_PI / 2)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    mendezView = (MendezView *)self.view;
    [mendezView addSelectionTarget: self action: @selector(popupImageSelection:)];
    [mendezView addAxisTarget: self action: @selector(axisChanged:)];
    leftFunction = [[SphereFunction alloc] init];
    rightFunction = [[SphereFunction alloc] init];
    float   a[3] = { prerotate/sqrt(3), prerotate/sqrt(3), prerotate/sqrt(3) };
    leftFunction.rotation = [[Rotation alloc] init: a];
    Mtransform_size = [mendezView recommendedTransformSize];
    mtransform = [[Mtransform alloc] initWidth: Mtransform_size height:Mtransform_size];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    Mtransform_size = [mendezView recommendedTransformSize];
    mtransform = [[Mtransform alloc] initWidth: Mtransform_size height:Mtransform_size];
    [self setImage: @"m42-final.jpg"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recompute {
    SCNVector3 axis = mendezView.axis;
    float   v[3];
    v[0] = axis.x;
    v[1] = axis.y;
    v[2] = axis.z;
    MendezTransformResult   *left = [mtransform transform: v function: leftFunction];
    MendezTransformResult   *right = [mtransform transform: v function: rightFunction];
    [mendezView setTransformsLeft: left right: right];
}

- (void)setImage: (NSString *)imagename {
    // XXX other classes may also need to know the new image
    [mendezView setImage: imagename];
    UIImage *image = [UIImage imageNamed: imagename];
    [leftFunction setImage: image];
    [rightFunction setImage: image];
    [self recompute];
}

- (void)popupImageSelection:(id)sender {
    ImageSelectionController    *imageSelectionController = [[ImageSelectionController alloc] init];
    imageSelectionController.viewController = self;
    imageSelectionController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController: imageSelectionController animated: YES completion: nil];
    UIPopoverPresentationController *presentationController = (UIPopoverPresentationController*)imageSelectionController.presentationController;
    presentationController.sourceView = sender;
}


- (void)axisChanged:(id)sender {
    [self recompute];
}

@end
