//
//  SpheresView.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "SpheresView.h"

@implementation SpheresView

@synthesize axis;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScene];
    }
    return self;
}

- (void)setSphere: (SCNSphere*)sphere image: (NSString*) imagename {
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIImage imageNamed: imagename];
    //material.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
    //material.shininess = 0.5;
    [sphere removeMaterialAtIndex: 0];
    sphere.materials = @[material];
}

- (void)setImage: (NSString*)imagename {
    [self setSphere: leftSphere image: imagename];
    [self setSphere: rightSphere image: imagename];
}

- (void)setupScene {
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];

    scene = [[SCNScene alloc] init];
    
    self.autoenablesDefaultLighting = YES;
    
    leftSphere = [SCNSphere sphereWithRadius: 3];
    leftSphere.segmentCount = 50;
    
    rightSphere = [SCNSphere sphereWithRadius: 3];
    rightSphere.segmentCount = 50;
    
    [self setImage: @"m42-final.jpg"];
    
    leftNode = [SCNNode nodeWithGeometry: leftSphere];
    leftNode.position = SCNVector3Make(-3.3, 0, 0);
    leftNode.rotation = SCNVector4Make(1/sqrtf(3), 1/sqrtf(3), 1/sqrtf(3), M_PI / 6);
    
    rightNode = [SCNNode nodeWithGeometry: rightSphere];
    rightNode.position = SCNVector3Make(3.3, 0, 0);
    
    axisCylinder = [SCNCylinder cylinderWithRadius: 0.1 height: 8];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor redColor];
    material.shininess = 0.5;
    [axisCylinder removeMaterialAtIndex: 0];
    axisCylinder.materials = @[material];
    axisNode = [SCNNode nodeWithGeometry: axisCylinder];
    axisNode.position = SCNVector3Make(-3.3, 0, 0);
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

- (void)addTouchTarget: (id)_target action: (SEL)_action {
    target = _target;
    action = _action;
}

- (void)handleTouches: (NSSet *)touches {
    NSLog(@"handle touches");
    // extract coordinates from the first touch
    if (0 == [touches count]) {
        return;
    }
    UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex: 0];
    CGPoint where = [touch locationInView: self];
    NSLog(@"position: %.0f, %.0f", where.x, where.y);
    
    // build new axis based on these coordinates
    float   theta = M_PI * where.y / self.bounds.size.height;
    float   phi = 2 * M_PI * where.x / self.bounds.size.width;
    NSLog(@"theta = %.3f, phi = %.3f", theta, phi);
    float   z = cosf(theta);
    float   x = sinf(theta);
    float   y = x * sinf(phi);
    x *= cosf(phi);
    axis = SCNVector3Make(x, -z, -y);
    
    // redisplay the axis
    axisNode.rotation = SCNVector4Make(sinf(phi), 0, cosf(phi), theta);
    
    // send action
    if ([target respondsToSelector: action]) {
        [target performSelector: action];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    [self handleTouches: touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    [self handleTouches: touches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded:");
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
}

@end
