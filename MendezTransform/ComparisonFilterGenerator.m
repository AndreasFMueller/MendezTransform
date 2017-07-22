//
//  ComparisonFilterGenerator.m
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ComparisonFilterGenerator.h"
#import "ComparisonFilter.h"

@implementation ComparisonFilterGenerator

- (CIFilter*)filterWithName:(NSString *)name {
    CIFilter *filter = [[ComparisonFilter alloc] init];
    return filter;
}

@end
