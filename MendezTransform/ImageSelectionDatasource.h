//
//  ImageSelectionDatasource.h
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageSelectionDatasource : NSObject<UITableViewDataSource> {
    NSArray *images;
}

- (id)init;
- (NSString *)imageNameAtIndexPath: (NSIndexPath*)indexPath;
- (UIImage *)imageAtIndexPath: (NSIndexPath*)indexPath;

@end
