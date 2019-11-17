//
//  AxisImage.h
//  MendezTransform
//
//  Created by Andreas Müller on 17.11.19.
//  Copyright © 2019 Andreas Müller. All rights reserved.
//

#import "ComputedImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AxisImage : ComputedImage {
    
}

@property (readonly) int direction;

#define DIRECTION_X 0
#define DIRECTION_Y 1
#define DIRECTION_Z 2

- (id)initWithSize: (CGSize)size direction: (int)direction;

@end

NS_ASSUME_NONNULL_END
