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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MendezView *mendezView = (MendezView *)self.view;
    leftTransform = mendezView.leftTransform;
    rightTransform = mendezView.rightTransform;
    differenceTransform = mendezView.differenceTransform;
    mirroredDifferenceTransform = mendezView.mirroredDifferenceTransform;
    spheresView = mendezView.spheresView;
    [mendezView resizeSubviews];
    [self runExperiment];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MendezView *mendezView = (MendezView *)self.view;
    [mendezView resizeSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define Mtransform_size 200

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


@end
