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
#import "AxisChanged.h"
#import "ToggleColor.h"

@interface ViewController : UIViewController<AxisChanged,ToggleColor> {
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
// the tabearoman property is used to control for the special case where
// the image of Tabea is selected. In that case, the left image should
// be that of Roman. The code making this disctinction should only be present
// in the debug version, not in the public version, which is why the property
// is only conditionally defined. This means that all code using the proeprty
// must similarly be conditionally compiled
#if DEBUG
@property (readwrite) BOOL tabearoman;
#endif

- (void)setImage: (UIImage *)image;
- (void)setImageInternal: (UIImage *)image;
- (void)popupImageSelection: (id)sender;
- (void)axisChanged: (id)sender;
- (void)recompute;
- (void)toggleColor:(id)sender;
- (void)randomAction: (id)sender;
- (void)smoothAction: (id)sender;
- (BOOL)prefersStatusBarHidden;

@end

