//
//  MendezTransformViewController.m
//  MendezTransform
//
//  Created by Andreas Müller on 09.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "MendezTransformViewController.h"
#import "MendezTransformView.h"
#import "SphereFunction.h"
#import "Mtransform.h"
#import "SpherePoint.h"

@interface MendezTransformViewController ()

@end

@implementation MendezTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    [super viewDidAppear:animated];
    //Your Code here
    [self runExperiment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#define Mtransform_size 200

- (void)runExperiment {
    NSLog(@"running experiment");
    UIImage *image = [UIImage imageNamed: @"blackwhite.png"];
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
    MendezTransformView *mview = (MendezTransformView*)self.view;
    [mview setData: result length: Mtransform_size];
}

@end
