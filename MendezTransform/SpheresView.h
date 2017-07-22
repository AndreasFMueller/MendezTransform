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
    SCNNode *leftInternalNode;
    
    SCNSphere   *rightSphere;
    SCNNode *rightNode;
    
    SCNCylinder *axisCylinder;
    SCNNode *axisNode;
    
    SCNCylinder *axisLeftCylinder;
    SCNNode *axisLeftNode;
    SCNVector3 axisLeft;
    BOOL showAxis;
    
    id  target;
    SEL action;
    
    BOOL comparing;
    
    UIImage *opaqueImage;
    UIImage *transparentImage;
    
    SCNVector3 prerotation;
}

@property (readonly) SCNVector3 axis;
@property (readwrite) SCNVector3 axisLeft;
@property (readwrite) BOOL showAxis;
@property (readwrite)   BOOL comparing;
@property (readwrite)   BOOL fine;
@property (readonly) CGPoint center;
@property (readwrite) SCNVector3 prerotation;

- (id)initWithFrame:(CGRect)frame;
- (void)setupScene;
- (void)rotate: (SCNVector4)rotation;
- (void)rotateAngle: (float)angle;
- (void)setImage: (UIImage *)image;

- (void)addTouchTarget: (id)target action: (SEL)action;

- (SCNVector3)axisPhi: (float)phi theta: (float)theta;
- (SCNVector4)rotationPhi: (float)phi theta: (float)theta;
- (SCNVector4)rotationAxis: (SCNVector3)_axis;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)toggleAxis: (id)sender;

@end
