//
//  SpheresView.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "SpheresView.h"
#import "VectorTypes.h"

@implementation SpheresView

@synthesize center;

#define SPHERE_SEPARATION   3.3
#define SPHERE_RADIUS       3.0

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        fine = NO;
        showAxis = YES;
        tail = 1;
        [self setupScene];
    }
    return self;
}

- (BOOL)fine {
    return fine;
}

- (void)setFine: (BOOL)f {
    fine = f;
    centerNode.hidden = !f;
}

- (BOOL)showAxis {
    return showAxis;
}

- (void)setShowAxis:(BOOL)s {
    showAxis = s;
    prerotateArrow.hidden = !showAxis;
}

- (void)setSphere: (SCNSphere*)sphere image: (UIImage*) image transparent:(UIImage*)transparent {
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = image;
    if (comparing) {
        material.transparent.contents = transparent;
    } else {
        material.transparent.contents = nil;
    }
    [sphere removeMaterialAtIndex: 0];
    sphere.materials = @[material];
}

- (SCNNode *)arrow: (UIColor*)color {
    // create a node for the left axis arrow
    SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius: 0.1 height: 7.6];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = color;
    material.shininess = 0.5;
    [cylinder removeMaterialAtIndex: 0];
    cylinder.materials = @[material];
    
    SCNNode *shaftNode = [SCNNode nodeWithGeometry: cylinder];
    shaftNode.position = SCNVector3Make(0, -0.2, 0);
    
    SCNCone *cone = [SCNCone coneWithTopRadius: 0 bottomRadius: 0.2 height:0.6];
    [cone removeMaterialAtIndex: 0];
    cone.materials = @[material];
    
    SCNNode *headNode = [SCNNode nodeWithGeometry: cone];
    headNode.position = SCNVector3Make(0, 3.8, 0);
    
    SCNNode *result = [SCNNode node];
    [result addChildNode: shaftNode];
    [result addChildNode: headNode];
    
    return result;
}

- (void)setImage: (UIImage*)image {
    opaqueImage = image;
    
    // convert this image to have the right alpha channel
    CIImage *inputImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    if (opaqueImage.CIImage != nil) {
        inputImage = opaqueImage.CIImage;
    }
    if (opaqueImage.CGImage != nil) {
        NSLog(@"have CGImage data");
        inputImage = [CIImage imageWithCGImage: opaqueImage.CGImage];
    }
    CIFilter *comparisonFilter = [CIFilter filterWithName: @"ComparisonFilter" keysAndValues: kCIInputImageKey, inputImage, nil ];
    CIImage *outputImage = [comparisonFilter outputImage];
    CGImageRef  outputCGImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    transparentImage = [UIImage imageWithCGImage: outputCGImage];
    NSLog(@"image converted to monochrome");
    
    [self setSphere: leftSphere image: opaqueImage transparent: transparentImage];
    [self setSphere: rightSphere image: opaqueImage transparent: nil];
}

- (void)setupScene {
    comparing = NO;
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];

    scene = [[SCNScene alloc] init];
    
    self.autoenablesDefaultLighting = YES;
    
    leftSphere = [SCNSphere sphereWithRadius: SPHERE_RADIUS];
    leftSphere.segmentCount = 50;
    
    rightSphere = [SCNSphere sphereWithRadius: SPHERE_RADIUS];
    rightSphere.segmentCount = 50;
    
    leftInternalNode = [SCNNode nodeWithGeometry: leftSphere];
    //leftInternalNode.rotation = SCNVector4Make(1/sqrtf(3), 1/sqrtf(3), 1/sqrtf(3), M_PI / 2);
    leftNode = [SCNNode node];
    [leftNode addChildNode: leftInternalNode];
    leftNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
    
    rightNode = [SCNNode nodeWithGeometry: rightSphere];
    rightNode.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
    
    leftArrow = [self arrow: [UIColor redColor]];
    rightArrow = [self arrow: [UIColor redColor]];

    leftArrow.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
    rightArrow.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
    
    axis = App2SCN3(AppVector3Normalized(AppVector3Make(1, 1, 1)));
    leftArrow.rotation = [self rotationToAxis: axis];;
    rightArrow.rotation = [self rotationToAxis: axis];;
    
    // create a node for the left axis arrow
    prerotateArrow = [self arrow: [UIColor greenColor]];
    prerotateArrow.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
    prerotateArrow.hidden = YES;
    
    SCNSphere   *centerSphere = [SCNSphere sphereWithRadius: 0.1];
    SCNMaterial *centerMaterial = [SCNMaterial material];
    centerMaterial.diffuse.contents = [UIColor yellowColor];
    centerMaterial.shininess = 0.5;
    [centerSphere removeMaterialAtIndex: 0];
    centerSphere.materials = @[centerMaterial];
    
    centerNode = [SCNNode nodeWithGeometry: centerSphere];
    centerNode.hidden = YES;
    
    [scene.rootNode addChildNode: leftNode];
    [scene.rootNode addChildNode: rightNode];
    [scene.rootNode addChildNode: leftArrow];
    [scene.rootNode addChildNode: rightArrow];
    [scene.rootNode addChildNode: prerotateArrow];
    [scene.rootNode addChildNode: centerNode];
    
    self.allowsCameraControl = NO;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 25);
    cameraNode.camera.xFov = 30;
    [scene.rootNode addChildNode: cameraNode];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    lightNode.light.color = [UIColor colorWithWhite:0.37 alpha:1.0];
    lightNode.position = SCNVector3Make(50, 50, 50);
    [scene.rootNode addChildNode:lightNode];
    
    self.scene = scene;
}

- (void)rotate: (SCNVector4)rotation {
    leftNode.rotation = rotation;
}

- (void)rotateAngle: (float)angle {
    [self rotate: SCNVector4Make(axis.x, axis.y, axis.z, angle)];
}

- (void)addAxisChangedTarget: (id)target action: (SEL)action {
    axisChangedTarget = target;
    axisChangedAction = action;
}

- (SCNVector4)rotationToAxis: (SCNVector3)to {
    SCNVector3  from = SCNVector3Make(0, 1, 0);
    SCNVector3  r = SCNVector3Cross(from, to);
    float angle = acosf(SCNVector3Dot(from, to));
    return SCNVector4RotationMake(r, angle);
}

- (void)handleTouches: (NSSet *)touches {
    // extract coordinates from the first touch
    if (0 == [touches count]) {
        return;
    }
    UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex: 0];
    CGPoint where = [touch locationInView: self];
    if (!fine) {
        center = where;
    }
    
    float   phi = 2 * M_PI * where.x / self.bounds.size.width;
    float   theta = 0;
    if (self.comparing) {
        phi = phi - M_PI;
        [self rotateAngle: phi];
        return;
    }
    
    // build new axis based on these coordinates
    if (fine) {
        where.x = center.x + 0.05 * (where.x - self.bounds.size.width / 2);
        where.y = center.y + 0.05 * (where.y - self.bounds.size.height / 2);
    }
    phi = 2 * M_PI * where.x / self.bounds.size.width;
    theta = M_PI * where.y / self.bounds.size.height;
    AppPolar    polar = AppPolarMake(phi, theta, 1);
    NSLog(@"position: %.2f, %.2f, phi = %.3f, theta = %.3f", where.x, where.y, phi, theta);

    self.axis = App2SCN3(AppPolar2Vector3(polar));

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches: touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches: touches];
}

- (BOOL)comparing {
    return comparing;
}

#define ANIMATION_TIME 2.0

- (void)setComparing: (BOOL)_comparing {
    NSLog(@"toggle comparison mode");
    if (comparing == _comparing) {
        return;
    }
    comparing = _comparing;
    SCNMaterial *material = [leftSphere firstMaterial];
    if (comparing) {
        NSLog(@"comparing");
        rightArrow.hidden = YES;
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration: ANIMATION_TIME];
        leftSphere.radius = SPHERE_RADIUS * 1.004;
        leftNode.position = SCNVector3Make(0, 0, 0);
        rightNode.position = SCNVector3Make(0, 0, 0);
        leftArrow.position = SCNVector3Make(0, 0, 0);
        prerotateArrow.position = SCNVector3Make(0, 0, 0);
        material.transparent.contents = transparentImage;
        [SCNTransaction commit];
    } else {
        NSLog(@"not comparing");
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration: ANIMATION_TIME];
        leftSphere.radius = SPHERE_RADIUS;
        leftNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        rightNode.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
        leftArrow.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        prerotateArrow.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        material.transparent.contents = nil;
        [SCNTransaction setCompletionBlock:^{
            rightArrow.hidden = NO;
        }];
        [SCNTransaction commit];
    }
    [leftSphere removeMaterialAtIndex: 0];
    leftSphere.materials = @[material];
}

-(void)toggleAxis:(id)sender {
    self.showAxis = !self.showAxis;
}

- (SCNVector3)prerotation {
    return prerotation;
}

- (void)setPrerotation:(SCNVector3)p {
    NSLog(@"setting prerotation in SpheresView: %.2f, %.2f, %.2f", p.x, p.y, p.z);
    prerotation = p;
    float angle = SCNVector3Length(p);
    if (self.showAxis) {
        prerotateArrow.hidden = (angle == 0);
    }
    leftInternalNode.rotation = SCNVector4RotationMake(prerotation, angle);
    if (angle > 0) {
        SCNVector3  pa = SCNVector3Normalized(p);
        prerotateArrow.rotation = [self rotationToAxis: pa];
    }
}

- (SCNVector3)axis {
    return axis;
}

- (void)setAxis:(SCNVector3)_axis {
    axis = SCNVector3Multiply(_axis, tail);
    NSLog(@"axis. %.2f,%.2f,%.2f", axis.x, axis.y, axis.z);
    
    // redisplay the axis
    leftArrow.rotation = [self rotationToAxis: axis];
    rightArrow.rotation = [self rotationToAxis: axis];
    
    // send action
    if ([axisChangedTarget respondsToSelector: axisChangedAction]) {
        [axisChangedTarget performSelector:axisChangedAction withObject: self];
    }
}

- (void)toggleTail:(id)sender {
    tail = -tail;
}

@end
