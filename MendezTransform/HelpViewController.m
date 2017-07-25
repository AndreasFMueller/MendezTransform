//
//  HelpViewController.m
//  MendezTransform
//
//  Created by Andreas Müller on 23.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)loadView {
    helpView = [[HelpView alloc] init];
    self.view = helpView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [helpView addTarget: self action:@selector(dismissAction:) forControlEvents: UIControlEventTouchUpInside];
    
    NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
    NSURL   *url = [bundle URLForResource:@"help" withExtension: @"html"];
    [helpView loadURL: url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismissAction:(id)sender {
    [self dismissViewControllerAnimated: YES completion:nil];
}

@end
