//
//  ImageSelectionController.h
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSelectionDatasource.h"
#import "ViewController.h"

@interface ImageSelectionController : UITableViewController {
    ImageSelectionDatasource    *data;
}

@property (readwrite,retain) ViewController *viewController;

@end
