//
//  MendezTransformResult.h
//  MendezTransform
//
//  Created by Andreas Müller on 21.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MendezTransformResult : NSObject {
    float   *data;
    int  maxoffset;
}

@property (readonly) NSUInteger length;
@property (readonly) NSUInteger dataLength;
@property (readonly) BOOL color;

- (id)init: (NSUInteger)length color: (BOOL)_color;
- (float*)dataAtOffset: (int)offset;

@end
