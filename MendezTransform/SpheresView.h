//
//  SpheresView.h
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface SpheresView : SCNView {
    SCNScene    *scene;
    
    SCNSphere   *leftSphere;
    SCNNode *leftNode;
    
    SCNSphere   *rightSphere;
    SCNNode *rightNode;
}

- (id)initWithFrame:(CGRect)frame;
- (void)setupScene;
- (void)rotate: (SCNVector4)rotation;
- (void)setImage: (NSString *)imagename;

@end
