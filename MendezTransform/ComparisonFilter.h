//
//  ComparisonFilter.h
//  MendezTransform
//
//  Created by Andreas Müller on 22.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface ComparisonFilter : CIFilter {
    CIImage *inputImage;
}

@property (readwrite) float level;
@property (readwrite) float alpha;

@end
