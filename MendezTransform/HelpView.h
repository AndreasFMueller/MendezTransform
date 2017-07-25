//
//  HelpView.h
//  MendezTransform
//
//  Created by Andreas Müller on 23.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpView : UIView {
    UIWebView  *textView;
    UIButton   *dismissButton;
}

- (id)initWithFrame:(CGRect)frame;
- (void)layoutSubviews;
- (void)setupSubviews;
- (void)addTarget: (id _Nullable )target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)loadURL: (NSURL*)url;

@end
