//
//  HelpView.h
//  MendezTransform
//
//  Created by Andreas Müller on 23.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HelpView : UIView {
    WKWebView  *textView;
    UIButton   *dismissButton;
}

- (id _Nonnull )initWithFrame:(CGRect)frame;
- (void)layoutSubviews;
- (void)setupSubviews;
- (void)addTarget: (id _Nullable )target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)loadURL: (NSURL* _Nonnull)url;

@end
