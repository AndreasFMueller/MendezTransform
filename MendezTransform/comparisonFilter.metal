//
//  comparisonFilter.metal
//  MendezTransform
//
//  Created by Andreas Müller on 14.11.21.
//  Copyright © 2021 Andreas Müller. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {

float4  comparisonMask(sampler src, float level, float alpha) {
    float4  pixelColor = src.sample(src.coord());
    float   f = (pixelColor.r > pixelColor.g) ? pixelColor.r : pixelColor.g;
    f = (f > pixelColor.b) ? f : pixelColor.b;
    pixelColor.a = (f > level) ? alpha : 0.0;
    return pixelColor;
}

}}


