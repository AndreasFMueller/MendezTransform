//
//  ViewController.h
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "MendezTransformView.h"
#import "SpheresView.h"

@interface ViewController : UIViewController {
    IBOutlet MendezTransformView    *leftTransform;
    IBOutlet MendezTransformView    *rightTransform;
    IBOutlet MendezTransformView    *differenceTransform;
    IBOutlet MendezTransformView    *mirroredDifferenceTransform;
    IBOutlet SpheresView    *spheresView;
}

- (void)runExperiment;

- (void)setImage: (NSString *)imagename;
- (void)popupImageSelection: (id)sender;

@end

