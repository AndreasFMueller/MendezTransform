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
    
    id  target;
    SEL action;
    
    BOOL comparing;
    
    UIImage *opaqueImage;
    UIImage *transparentImage;
}

@property (readonly) SCNVector3 axis;
@property (readwrite)   BOOL comparing;
@property (readwrite)   BOOL fine;
@property (readonly) CGPoint center;

- (id)initWithFrame:(CGRect)frame;
- (void)setupScene;
- (void)rotate: (SCNVector4)rotation;
- (void)rotateAngle: (float)angle;
- (void)setImage: (NSString *)imagename;

- (void)addTouchTarget: (id)target action: (SEL)action;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
