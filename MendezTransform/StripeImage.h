//
//  StripeImage.h
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ComputedImage.h"

@interface StripeImage : ComputedImage {
    
}

@property (readonly) int stripes;

- (id)initWithSize: (CGSize)size stripes: (int)s;

@end
