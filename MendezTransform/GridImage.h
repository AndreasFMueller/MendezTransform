//
//  GridImage.h
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ComputedImage.h"

@interface GridImage : ComputedImage {
    
}

@property (readonly) NSUInteger lines;

- (id)initWithSize: (CGSize)size lines: (NSUInteger)lines;


@end
