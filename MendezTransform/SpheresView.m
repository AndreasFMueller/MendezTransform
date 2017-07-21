//
//  SpheresView.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "SpheresView.h"

@implementation SpheresView

@synthesize axis, fine, center;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#define SPHERE_SEPARATION   3.3
#define SPHERE_RADIUS       3.0

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        fine = NO;
        [self setupScene];
    }
    return self;
}

- (void)setSphere: (SCNSphere*)sphere image: (UIImage*) image transparent:(UIImage*)transparent {
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = image;
    if (comparing) {
        material.transparent.contents = transparent;
    } else {
        material.transparent.contents = nil;
    }
    //material.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
    //material.shininess = 0.5;
    [sphere removeMaterialAtIndex: 0];
    sphere.materials = @[material];
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
    CIFilter *monoFilter = [CIFilter filterWithName:@"CIPhotoEffectMono" keysAndValues: kCIInputImageKey, inputImage, nil];
    CIImage *monoImage = [monoFilter outputImage];
    
    CIFilter *invertFilter = [CIFilter filterWithName: @"CIColorInvert" keysAndValues: kCIInputImageKey, monoImage, nil];
    CIImage *invertedImage = [invertFilter outputImage];
    
    CIFilter *maskFilter = [CIFilter filterWithName: @"CIMaskToAlpha" keysAndValues:kCIInputImageKey, monoImage, nil];
    CIImage *maskImage = [maskFilter outputImage];
    
    CIImage *backgroundImage = [CIImage imageWithColor: [[CIColor alloc] initWithRed: 0 green: 0 blue: 0 alpha: 0]];
    
    CIFilter *blendFilter = [CIFilter filterWithName: @"CIBlendWithAlphaMask" keysAndValues:kCIInputImageKey, inputImage, @"inputBackgroundImage", backgroundImage, @"inputMaskImage", maskImage, nil];
    
    CIImage *outputImage = [blendFilter outputImage];
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
    leftInternalNode.rotation = SCNVector4Make(1/sqrtf(3), 1/sqrtf(3), 1/sqrtf(3), M_PI / 2);
    leftNode = [SCNNode node];
    [leftNode addChildNode: leftInternalNode];
    leftNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
    
    rightNode = [SCNNode nodeWithGeometry: rightSphere];
    rightNode.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
    
    axisCylinder = [SCNCylinder cylinderWithRadius: 0.1 height: 8];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor redColor];
    material.shininess = 0.5;
    [axisCylinder removeMaterialAtIndex: 0];
    axisCylinder.materials = @[material];
    axisNode = [SCNNode nodeWithGeometry: axisCylinder];
    axisNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
    axisNode.rotation = SCNVector4Make(1/sqrtf(3), 1/sqrtf(3), 1/sqrtf(3), M_PI / 6);
    
    [scene.rootNode addChildNode: leftNode];
    [scene.rootNode addChildNode: rightNode];
    [scene.rootNode addChildNode: axisNode];
    
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

- (void)addTouchTarget: (id)_target action: (SEL)_action {
    target = _target;
    action = _action;
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
        [self rotateAngle: -phi];
        return;
    }
    
    // build new axis based on these coordinates
    if (fine) {
        where.x = center.x + 0.05 * (where.x - self.bounds.size.width / 2);
        where.y = center.y + 0.05 * (where.y - self.bounds.size.height / 2);
    }
    NSLog(@"position: %.2f, %.2f", where.x, where.y);
    phi = 2 * M_PI * where.x / self.bounds.size.width;
    theta = M_PI * where.y / self.bounds.size.height;
    //NSLog(@"theta = %.3f, phi = %.3f", theta, phi);
    float   z = cosf(theta);
    float   x = sinf(theta);
    float   y = x * sinf(phi);
    x *= cosf(phi);
    axis = SCNVector3Make(x, -z, -y);
    
    // redisplay the axis
    axisNode.rotation = SCNVector4Make(sinf(phi), 0, cosf(phi), theta);
    
    // send action
    if ([target respondsToSelector: action]) {
        [target performSelector:action withObject: self];
    }
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

- (void)setComparing: (BOOL)_comparing {
    NSLog(@"toggle comparison mode");
    if (comparing == _comparing) {
        return;
    }
    comparing = _comparing;
    SCNMaterial *material = [leftSphere firstMaterial];
    if (comparing) {
        NSLog(@"comparing");
        leftSphere.radius = SPHERE_RADIUS * 1.004;
        leftNode.position = SCNVector3Make(0, 0, 0);
        rightNode.position = SCNVector3Make(0, 0, 0);
        axisNode.position = SCNVector3Make(0, 0, 0);
        material.transparent.contents = transparentImage;
    } else {
        NSLog(@"not comparing");
        leftSphere.radius = SPHERE_RADIUS;
        leftNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        rightNode.position = SCNVector3Make(SPHERE_SEPARATION, 0, 0);
        axisNode.position = SCNVector3Make(-SPHERE_SEPARATION, 0, 0);
        material.transparent.contents = nil;
    }
    [leftSphere removeMaterialAtIndex: 0];
    leftSphere.materials = @[material];
}

@end
