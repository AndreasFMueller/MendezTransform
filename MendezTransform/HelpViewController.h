//
//  HelpViewController.h
//  MendezTransform
//
//  Created by Andreas Müller on 23.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpView.h"

@interface HelpViewController : UIViewController {
    HelpView    *helpView;
}

- (void)dismissAction:(id)sender;

@end
