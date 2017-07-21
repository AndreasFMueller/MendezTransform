//
//  DotsImage.h
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ComputedImage.h"

@interface DotsImage : ComputedImage {
    
}

@property (readonly) NSUInteger dots;

- (id)initWithSize: (CGSize)size dots: (NSUInteger)dots;

@end
