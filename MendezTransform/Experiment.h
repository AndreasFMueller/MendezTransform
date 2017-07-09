//
//  Experiment.h
//  MendezTransform
//
//  Created by Andreas Müller on 08.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface Experiment : NSObject {
    UIImage *image;
}

- (id)init: (NSString*)imagefilename;
- (void)run;

@end
