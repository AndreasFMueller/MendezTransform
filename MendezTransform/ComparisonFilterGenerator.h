//
//  ComparisonFilterGenerator.h
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface ComparisonFilterGenerator : NSObject<CIFilterConstructor>

- (CIFilter*)filterWithName:(NSString *)name;

@end
