//
//  ViewController.h
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "MendezView.h"
#import "SphereFunction.h"
#import "Mtransform.h"

@interface ViewController : UIViewController {
    IBOutlet    MendezView  *mendezView;
    SphereFunction  *leftFunction;
    SphereFunction  *rightFunction;
    Mtransform  *mtransform;
    NSUInteger  Mtransform_size;
    BOOL color;
    UIImage *normalImage;
    UIImage *smoothImage;
    BOOL smooth;
}

@property (readwrite) AppVector3 prerotation;

- (void)setImage: (UIImage *)image;
- (void)setImageInternal: (UIImage *)image;
- (void)popupImageSelection: (id)sender;
- (void)axisChanged: (id)sender;
- (void)recompute;
- (void)toggleColor:(id)sender;
- (void)randomAction: (id)sender;
- (void)smoothAction: (id)sender;

@end

