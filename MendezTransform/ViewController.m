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

#define Mtransform_size 200
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
    mtransform = [[Mtransform alloc] initWidth: Mtransform_size height:Mtransform_size];
    [self setImage: @"m42-final.jpg"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if 0
- (void)runExperiment {
    NSLog(@"running experiment");
    UIImage *image = [UIImage imageNamed: @"m42-final.jpg"];
    SphereFunction  *f = [[SphereFunction alloc] init: image];
    Mtransform  *M = [[Mtransform alloc] initWidth: Mtransform_size height: Mtransform_size];
    spherepoint sp;
    sp.phi = M_PI / 6;
    sp.theta = M_PI / 6;
    float   v[3];
    point2vector(sp, v);
    float   result[Mtransform_size];
    [M transform: result axis: v function: f];
    for (int i = 0; i < Mtransform_size; i++) {
        NSLog(@"Mf[%3d] = %7.4f", i, result[i]);
    }
    [rightTransform setData: result length: Mtransform_size];
    [leftTransform setData : result length: Mtransform_size];
    [differenceTransform setDifference: result minus: result length:Mtransform_size mirror: NO];
    [mirroredDifferenceTransform setDifference: result minus: result length:Mtransform_size mirror: YES];

}
#endif



- (void)setImage: (NSString *)imagename {
    // XXX other classes may also need to know the new image
    [mendezView setImage: imagename];
    UIImage *image = [UIImage imageNamed: imagename];
    [leftFunction setImage: image];
    [rightFunction setImage: image];
}

- (void)popupImageSelection:(id)sender {
    NSLog(@"ViewController popupImageSelection called");
    ImageSelectionController    *imageSelectionController = [[ImageSelectionController alloc] init];
    imageSelectionController.viewController = self;
    imageSelectionController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController: imageSelectionController animated: YES completion: nil];
    UIPopoverPresentationController *presentationController = (UIPopoverPresentationController*)imageSelectionController.presentationController;
    presentationController.sourceView = sender;
}


- (void)axisChanged:(id)sender {
    SCNVector3 axis = mendezView.axis;
    float   v[3];
    v[0] = axis.x;
    v[1] = axis.y;
    v[2] = axis.z;
    float   *l = (float*)calloc(Mtransform_size, sizeof(float));
    float   *r = (float*)calloc(Mtransform_size, sizeof(float));
    [mtransform transform: l axis:v function: leftFunction];
    [mtransform transform: r axis:v function: rightFunction];
    [mendezView setTransforms: Mtransform_size left:l right:r];
}

@end
