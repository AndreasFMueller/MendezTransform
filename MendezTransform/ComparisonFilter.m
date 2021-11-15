//
//  ComparisonFilter.m
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ComparisonFilter.h"
#import "ComparisonFilterGenerator.h"
#import "Debug.h"

@implementation ComparisonFilter

@synthesize level, alpha;

static CIKernel     *comparisonFilterKernel = nil;
static ComparisonFilterGenerator    *filterGenerator = nil;

+ (void)initialize {
    NSDebug1(@"filter initialization");
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
    NSDebug1(@"create a filter instance");
    if (comparisonFilterKernel == nil) {
        NSError* error = nil;
        NSURL   *url = [[NSBundle mainBundle] URLForResource: @"default" withExtension: @"metallib"];
        NSDebug(@"URL for metal library: %@", [url description]);
        NSData  *data = [NSData dataWithContentsOfURL: url];
        comparisonFilterKernel = [CIKernel kernelWithFunctionName: @"comparisonMask" fromMetalLibraryData: data error: &error];
    }
    self = [super init];
    if (self) {
        level = 0.2;
        alpha = 0.7;
    }
    return self;
}

+ (NSDictionary*)customAttributes {
    NSDebug1(@"customAttributes");
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
    NSDebug1(@"applying the filter");
    CISampler *src = [CISampler samplerWithImage: inputImage];
    NSDebug(@"input image: %p", src);
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
