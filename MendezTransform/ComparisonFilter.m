//
//  ComparisonFilter.m
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ComparisonFilter.h"
#import "ComparisonFilterGenerator.h"

@implementation ComparisonFilter

@synthesize level, alpha;

static CIKernel     *comparisonFilterKernel = nil;
static ComparisonFilterGenerator    *filterGenerator = nil;

+ (void)initialize {
    NSLog(@"filter initialization");
    if (nil != filterGenerator) {
        return;
    }
    filterGenerator = [[ComparisonFilterGenerator alloc] init];
    [CIFilter registerFilterName: @"ComparisonFilter"
                     constructor: filterGenerator
                 classAttributes: @{
                                        kCIAttributeFilterDisplayName: @"ComparisonFilter",
                                        kCIAttributeFilterCategories: @[
                                                kCICategoryVideo, kCICategoryStillImage
                                                ]
                                    }
     ];
}

- (id)init {
    NSLog(@"create a filter instance");
    if (comparisonFilterKernel == nil) {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        NSError* error = nil;
        NSString    *code = [NSString stringWithContentsOfFile: [bundle pathForResource: @"ComparisonFilter" ofType:@"cikernel"] encoding: NSUTF8StringEncoding error:&error];
        comparisonFilterKernel = [CIKernel kernelWithString: code];
    }
    self = [super init];
    if (self) {
        level = 0.2;
        alpha = 0.7;
    }
    return self;
}

+ (NSDictionary*)customAttributes {
    NSLog(@"customAttributes");
    return @{
             @"level" : @{
                     kCIAttributeMin: @0.0,
                     kCIAttributeMax: @1.0,
                     kCIAttributeSliderMin: @0.0,
                     kCIAttributeSliderMax: @1.0,
                     kCIAttributeDefault: @0.5,
                     kCIAttributeIdentity: @1.0,
                     kCIAttributeType: kCIAttributeTypeScalar
                     },
             @"alpha" : @{
                     kCIAttributeMin: @0.0,
                     kCIAttributeMax: @1.0,
                     kCIAttributeSliderMin: @0.0,
                     kCIAttributeSliderMax: @1.0,
                     kCIAttributeDefault: @0.7,
                     kCIAttributeIdentity: @1.0,
                     kCIAttributeType: kCIAttributeTypeScalar
                     }
             };
}

- (CIImage*)outputImage {
    NSLog(@"applying the filter");
    CISampler *src = [CISampler samplerWithImage: inputImage];
    NSLog(@"input image: %p", src);
    NSNumber *l = [[NSNumber alloc] initWithFloat: self.level];
    NSNumber *a = [[NSNumber alloc] initWithFloat: self.alpha];
    NSArray *arguments = [NSArray arrayWithObjects: src, l, a, nil];
    return [comparisonFilterKernel applyWithExtent: [inputImage extent]
                                       roiCallback:^CGRect(int index, CGRect destRect) {
                                                        return destRect;
                                                    }
                                         arguments:arguments];
}

@end
