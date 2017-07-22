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
    [mendezView addColorTarget: self action: @selector(toggleColor:)];
    leftFunction = [[SphereFunction alloc] init];
    rightFunction = [[SphereFunction alloc] init];
    
    float   a[3] = { prerotate/sqrt(3), prerotate/sqrt(3), prerotate/sqrt(3) };
    leftFunction.rotation = [[Rotation alloc] init: a];
    
    mendezView.prerotation = SCNVector3Make(a[0], a[1], a[2]);
    
    Mtransform_size = [mendezView recommendedTransformSize];
    mtransform = [[Mtransform alloc] initWidth: Mtransform_size height:Mtransform_size];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    Mtransform_size = [mendezView recommendedTransformSize];
    mtransform = [[Mtransform alloc] initWidth: Mtransform_size height:Mtransform_size];
    [self setImage: [UIImage imageNamed: @"m42-final.jpg"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recompute {
    SCNVector3 axis = mendezView.axis;

    dispatch_group_t group = dispatch_group_create();
    MendezTransformResult __block  *left = nil;
    MendezTransformResult __block   *right = nil;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        left = [mtransform transformVector: axis function: leftFunction];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        right = [mtransform transformVector: axis function: rightFunction];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    [mendezView setTransformsLeft: left right: right];
}

- (void)setImage: (UIImage *)image {
    [mendezView setImage: image];
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

- (void)toggleColor:(id)sender {
    NSLog(@"color toggled");
    color = !color;
    mtransform.color = color;
    [self recompute];
}


@end
