//
//  ZAxisImage.m
//  MendezTransform
//
//  Created by Andreas Müller on 17.11.19.
//  Copyright © 2019 Andreas Müller. All rights reserved.
//

#import "ZAxisImage.h"

@implementation ZAxisImage

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize: size direction: DIRECTION_Z];
    return self;
}

@end
