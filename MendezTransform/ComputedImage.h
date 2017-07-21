//
//  ComputedImage.h
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ComputedImage : NSObject

@property (readonly) int width;
@property (readonly) int height;
@property (readonly) UIImage *image;

- (id)initWithSize: (CGSize)size;
- (void)imageFromData:(unsigned char*)data;

@end
