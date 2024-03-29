//
//  SpheresView.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "SpheresView.h"
#import "VectorTypes.h"
#import "simd/quaternion.h"
#import "Debug.h"

@implementation SpheresView

@synthesize center;

#define SPHERE_SEPARATION   3.3
#define SPHERE_RADIUS       3.0

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        opaqueImage = nil;
        transparentImage = nil;
        
        fine = NO;
        showAxis = YES;
        tail = 1;
        leftPosition = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        rightPosition = SCNVector3Make(SPHERE_SEPARATION, 0, 0);

        [self setupScene];
    }
    return self;
}

- (BOOL)fine {
    return fine;
}

- (void)setFine: (BOOL)f {
    fine = f;
}

- (BOOL)showAxis {
    return showAxis;
}

- (void)setShowAxis:(BOOL)s {
    showAxis = s;
    prerotateArrow.hidden = !showAxis;
}

- (void)setSphere: (SCNSphere*)sphere image: (UIImage*) image transparent:(UIImage*)transparent {
    NSDebug(@"setting the image on the sphere=%@ image=%@, transparent=%@", [sphere description], [image description], [transparent description]);
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = image;
    NSDebug1(@"diffuse image set");
    if (comparing) {
        NSDebug(@"setting the transparent image: %@", [transparent description]);
        material.transparent.contents = transparent;
    } else {
        NSDebug1(@"setting no transparent image");
        material.transparent.contents = nil;
    }
    [sphere removeMaterialAtIndex: 0];
    sphere.materials = @[material];
    NSDebug1(@"material set");
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

- (void)setLeftImage: (UIImage*)image {
    NSDebug(@"setLeftImage called with %p", image);
    opaqueImage = image;
    if (opaqueImage == nil) {
        NSDebug1(@"no image found");
        return;
    }
    
    // convert this image to have the right alpha channel
    CIImage *inputImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    if (image.CIImage != nil) {
        NSDebug1(@"have CIImage already");
        inputImage = opaqueImage.CIImage;
    } else if (image.CGImage != nil) {
        // convert the CGImage to a CIImage
        NSDebug1(@"have to convert CGImage data");
        //inputImage = [CIImage imageWithCGImage: image.CGImage];
        inputImage = [[CIImage alloc] initWithCGImage: image.CGImage];
    }

    CIFilter *comparisonFilter = [CIFilter filterWithName: @"ComparisonFilter" keysAndValues: kCIInputImageKey, inputImage, nil ];
    CIImage *outputImage = [comparisonFilter outputImage];
    CGImageRef  outputCGImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    transparentImage = [UIImage imageWithCGImage: outputCGImage];
    NSDebug1(@"constructed the transparentImage");
    
    [self setSphere: leftSphere image: opaqueImage transparent: transparentImage];
    //[self setSphere: rightSphere image: opaqueImage transparent: nil];
    
    [SCNTransaction flush]; // needed so that imported images update immediately
}

- (void)setRightImage: (UIImage*)image {
    [self setSphere: rightSphere image: image transparent: nil];
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
    //leftInternalNode.rotation = SCNVector4Make(0, 1, 0, M_PI/2);
    leftNode = [SCNNode node];
    [leftNode addChildNode: leftInternalNode];
    leftNode.position = leftPosition;
    
    rightNode = [SCNNode nodeWithGeometry: rightSphere];
    rightNode.position = rightPosition;
    rightNode.rotation = SCNVector4Make(0, 1, 0, -M_PI/2);
    
    leftArrow = [self arrow: [UIColor redColor]];
    rightArrow = [self arrow: [UIColor redColor]];

    leftArrow.position = leftPosition;
    rightArrow.position = rightPosition;
    
    axis = App2SCN3(AppVector3Normalized(AppVector3Make(1, 1, 1)));
    leftArrow.rotation = [self rotationToAxis: axis];;
    rightArrow.rotation = [self rotationToAxis: axis];;
    
    // create a node for the left axis arrow
    prerotateArrow = [self arrow: [UIColor greenColor]];
    prerotateArrow.position = leftPosition;
    prerotateArrow.hidden = YES;
    
    [scene.rootNode addChildNode: leftNode];
    [scene.rootNode addChildNode: rightNode];
    [scene.rootNode addChildNode: leftArrow];
    [scene.rootNode addChildNode: rightArrow];
    [scene.rootNode addChildNode: prerotateArrow];
    
    self.allowsCameraControl = NO;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 25);
    cameraNode.camera.fieldOfView = 16;
    [scene.rootNode addChildNode: cameraNode];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    lightNode.light.color = [UIColor colorWithWhite:0.37 alpha:1.0];
    lightNode.position = SCNVector3Make(50, 50, 50);
    [scene.rootNode addChildNode:lightNode];
    
    self.scene = scene;
}

// method to rotate the left sphere (outernode) around the axis.
// this currently works correctly, but the image is not displayed correctly, probably
// has to do with the internal Node rotation
- (void)rotate: (SCNVector4)rotation {
    NSDebug(@"rotate: %f, %f, %f, %f", rotation.x, rotation.y, rotation.z, rotation.w);
#if 0
    SCNVector4  fixOrientation = SCNVector4Make(0, 1, 0, M_PI/2);
    simd_quatf  f = simd_quaternion(fixOrientation.x, fixOrientation.y, fixOrientation.z, fixOrientation.w);
    simd_quatf  r = simd_quaternion(rotation.x, rotation.y, rotation.z, rotation.w);
    simd_quatf  prod = simd_mul(r, f);
    leftNode.rotation = SCNVector4FromFloat4(prod.vector);
#else
    leftNode.rotation = rotation;
#endif
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

- (AppPolar)polar: (CGPoint)where {
    return AppPolarMake(2 * M_PI * where.x / self.bounds.size.width,
                        M_PI * where.y / self.bounds.size.height, 1);
}

- (float)angle {
    return leftNode.rotation.w;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 0) {
        return;
    }
    UITouch *touch = (UITouch*)[[touches allObjects] objectAtIndex:0];
    start = [self polar: [touch locationInView: self]];
    if (self.comparing) {
        startangle = [self angle];
    } else {
        AppVector3  v = SCN2App3(self.axis);
        startaxis = AppVector32Polar(v);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 0) {
        return;
    }
    UITouch *touch = (UITouch*)[[touches allObjects] objectAtIndex:0];
    AppPolar current = [self polar: [touch locationInView: self]];
    AppPolar    delta = AppPolarSub(current, start);
    if (fine) {
        delta = AppPolarMultiply(delta, 0.05);
    }
    if (self.comparing) {
        [self rotateAngle: startangle + delta.phi];
    } else {
        AppPolar polar = AppPolarAdd(startaxis, delta);
        self.axis = App2SCN3(AppPolar2Vector3(polar));
    }
}

// the following two methods must be overriden because we don't call the superclass
// and the documentation says that we have to override them in that case
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (BOOL)comparing {
    return comparing;
}

#define ANIMATION_TIME 2.0

- (void)setComparing: (BOOL)_comparing {
    NSDebug1(@"toggle comparison mode");
    if (comparing == _comparing) {
        return;
    }
    comparing = _comparing;
    SCNMaterial *material = [leftSphere firstMaterial];
    if (comparing) {
        NSDebug1(@"comparing");
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration: ANIMATION_TIME];
        leftSphere.radius = SPHERE_RADIUS * 1.004;
        leftNode.position = SCNVector3Make(0, 0, 0);
        rightNode.position = SCNVector3Make(0, 0, 0);
        rightArrow.position = SCNVector3Make(0, 0, 0);
        leftArrow.position = SCNVector3Make(0, 0, 0);
        prerotateArrow.position = SCNVector3Make(0, 0, 0);
        [SCNTransaction setCompletionBlock:^{
            material.transparent.contents = self->transparentImage;
            self->rightArrow.hidden = YES;
        }];
        [SCNTransaction commit];
    } else {
        NSDebug1(@"not comparing");
        rightArrow.hidden = NO;
        material.transparent.contents = nil;
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration: ANIMATION_TIME];
        leftSphere.radius = SPHERE_RADIUS;
        leftNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        rightNode.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
        leftArrow.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        rightArrow.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
        prerotateArrow.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        [SCNTransaction setCompletionBlock:^{
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

// prerotation only affects the internal node
- (void)setPrerotation:(SCNVector3)p {
    NSDebug(@"setting prerotation in SpheresView: %.2f, %.2f, %.2f", p.x, p.y, p.z);
    prerotation = p;
    
    // quaternion for the rotation around
    simd_quatf  f = simd_quaternion(0.f, -sinf(M_PI/4), 0.f, cosf(M_PI/4));
    
    // compute rotation angle
    float angle = SCNVector3Length(p);
    NSDebug(@"rotation angle = %f", angle);
    
    // compute the quaternion product
    float   s = -sinf(angle/2) / angle;
    simd_quatf  r = simd_quaternion(s * p.x, s * p.y, s * p.z, cosf(angle/2));
    simd_quatf  prod = simd_mul(r, f);
    NSDebug(@"rotation quaternion: %f, %f, %f, %f", prod.vector[0], prod.vector[1], prod.vector[2], prod.vector[3]);
    SCNVector3  axis2 = SCNVector3Make(prod.vector[0], prod.vector[1], prod.vector[2]);
    float angle2 = 2 * acosf(prod.vector[3]);
    leftInternalNode.rotation = SCNVector4RotationMake(axis2, angle2);
    
    // handle special values of the angle
    if (self.showAxis) {
        prerotateArrow.hidden = (angle == 0) ? YES : NO;
    }
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
    NSDebug(@"axis. %.2f,%.2f,%.2f", axis.x, axis.y, axis.z);
    
    // redisplay the axis
    leftArrow.rotation = [self rotationToAxis: axis];
    rightArrow.rotation = [self rotationToAxis: axis];
    [SCNTransaction flush];
    
    // send action
    [axisChangedTarget axisChanged: self];
}

- (void)toggleTail:(id)sender {
    tail = -tail;
}

@end
