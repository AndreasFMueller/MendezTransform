//
//  SpheresView.h
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "VectorTypes.h"
#import "AxisChanged.h"

@interface SpheresView : SCNView {
    SCNScene    *scene;
    
    SCNVector3  leftPosition;
    SCNVector3  rightPosition;
    
    SCNSphere   *leftSphere;
    SCNNode *leftNode;
    SCNNode *leftInternalNode;
    
    SCNSphere   *rightSphere;
    SCNNode *rightNode;
        
    SCNNode *leftArrow;
    SCNNode *rightArrow;
    
    SCNNode *prerotateArrow;
    SCNVector3 prerotateAxis; // in View coordinates
    BOOL showAxis;
    
    id  axisChangedTarget;
    SEL axisChangedAction;
    
    BOOL comparing;
    BOOL fine;
    
    int tail;
    
    UIImage *opaqueImage;
    UIImage *transparentImage;
    
    SCNVector3 prerotation;
    SCNVector3 axis;
    
    AppPolar    start;
    AppPolar    startaxis;
    float   startangle;
}

@property (readwrite) SCNVector3 axis; // scene coordinates
@property (readwrite) BOOL showAxis;
@property (readwrite)   BOOL comparing;
@property (readwrite)   BOOL fine;
@property (readonly) CGPoint center;
@property (readwrite) SCNVector3 prerotation; // scene coordinates

- (id)initWithFrame:(CGRect)frame;
- (void)setupScene;
- (void)rotate: (SCNVector4)rotation;
- (void)rotateAngle: (float)angle;
- (float)angle;
- (void)setLeftImage: (UIImage *)image;
- (void)setRightImage: (UIImage *)image;
- (SCNNode*)arrow: (UIColor*)color;

- (void)addAxisChangedTarget: (id<AxisChanged>)target action: (SEL)action;

- (SCNVector4)rotationToAxis: (SCNVector3)_axis;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)toggleAxis: (id)sender;
- (void)toggleTail: (id)sender;

@end
