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

@interface ViewController : UIViewController {
    IBOutlet MendezTransformView    *leftTransform;
    IBOutlet MendezTransformView    *rightTransform;
    IBOutlet MendezTransformView    *differenceTransform;
    IBOutlet MendezTransformView    *mirroredDifferenceTransform;
    IBOutlet SCNView    *sceneView;
}

- (void)runExperiment;

@end

