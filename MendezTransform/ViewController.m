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
#import "VectorTypes.h"
#import "HelpViewController.h"
#import "Debug.h"

@interface ViewController ()

@end

@implementation ViewController

- (AppVector3)prerotation {
    return mendezView.prerotation;
}

- (void)setPrerotation:(AppVector3)prerotation {
    leftFunction.rotation = [[Rotation alloc] initVector: prerotation];
    mendezView.prerotation = prerotation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    mendezView = (MendezView *)self.view;
    [mendezView addSelectionTarget: self action: @selector(popupImageSelection:)];
    [mendezView addAxisChangedTarget: self action: @selector(axisChanged:)];
    [mendezView addColorTarget: self action: @selector(toggleColor:)];
    [mendezView addRandomButtonTarget: self action: @selector(randomAction:)];
    [mendezView addSmoothButtonTarget: self action: @selector(smoothAction:)];
    [mendezView addHelpTarget: self action: @selector(helpAction:)];
    leftFunction = [[SphereFunction alloc] init];
    rightFunction = [[SphereFunction alloc] init];
    
    AppVector3  initialaxis = AppVector3Normalized(AppVector3Make(1, 2, 1));
    //initialaxis = AppVector3Normalized(AppVector3Make(0, 0, 1));
    self.prerotation = initialaxis;
    
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
    AppVector3 axis = mendezView.axis;

    dispatch_group_t group = dispatch_group_create();
    MendezTransformResult __block  *left = nil;
    MendezTransformResult __block   *right = nil;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        left = [self->mtransform transformVector: axis function: self->leftFunction];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        right = [self->mtransform transformVector: axis function: self->rightFunction];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    [mendezView setTransformsLeft: left right: right];
}

- (void)setImage: (UIImage *)image {
    if (nil == image) {
        return;
    }
    normalImage = image;
    smoothImage = nil;
    smooth = NO;
    [self setImageInternal: normalImage];
}

- (void)setImageInternal:(UIImage *)image {
#ifdef DEBUG
    // conditionally initialize the tabearoman property
    mendezView.tabearoman = self.tabearoman;
#endif
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
    color = !color;
    mtransform.color = color;
    [self recompute];
}

// random rotation is the normal situation, turning this off allows
// to control the rotation to be applied for debugging purposes
#define RANDOM_ROTATION 1

- (void)randomAction:(id)sender {
    AppPolar    p;
#if RANDOM_ROTATION
    p.phi = 2 * M_PI * (random() / (float)RAND_MAX);
    float t = 2 * (random() / (float)RAND_MAX) - 1;
    p.theta = acosf(t);
    p.r = 2 * M_PI * (0.5 - (random() / (float)RAND_MAX));
#else
    p.phi = 0 * M_PI;
    p.theta = 0 * M_PI / 4;
    p.r = 0.01 * M_PI;
#endif
    AppVector3  pre = AppPolar2Vector3(p);
    self.prerotation = pre;
    [self recompute];
}

- (void)smoothAction: (id)sender {
    smooth = !smooth;
    if (smooth) {
        if (nil == smoothImage) {
            NSDebug1(@"make smooth");
            CIImage *inputImage = nil;
            CIContext *context = [CIContext contextWithOptions:nil];
            if (normalImage.CIImage != nil) {
                inputImage = normalImage.CIImage;
            }
            if (normalImage.CGImage != nil) {
                NSDebug1(@"have CGImage data");
                inputImage = [CIImage imageWithCGImage: normalImage.CGImage];
            }
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:inputImage forKey:kCIInputImageKey];
            [filter setValue:[NSNumber numberWithDouble:3.0] forKey:@"inputRadius"];
            //CIImage *result = [filter valueForKey:kCIOutputImageKey];
            CIImage *outputImage = [filter outputImage];
            CGImageRef  outputCGImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
            smoothImage = [UIImage imageWithCGImage: outputCGImage];
        }
        [self setImageInternal: smoothImage];
    } else {
        [self setImageInternal: normalImage];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)helpAction:(id)sender {
    HelpViewController  *helpviewcontroller = [[HelpViewController alloc] init];
    helpviewcontroller.modalPresentationStyle = UIModalPresentationPageSheet;
    helpviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController: helpviewcontroller animated: YES completion: nil];
}

@end
