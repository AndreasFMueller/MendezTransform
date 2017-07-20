//
//  SpheresView.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "SpheresView.h"

@implementation SpheresView

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
    material.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
    material.shininess = 0.5;
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
    
    [scene.rootNode addChildNode: leftNode];
    [scene.rootNode addChildNode: rightNode];
    
    self.allowsCameraControl = YES;
    
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

@end
