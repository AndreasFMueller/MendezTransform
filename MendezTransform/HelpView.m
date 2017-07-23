//
//  HelpView.m
//  MendezTransform
//
//  Created by Andreas Müller on 23.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "HelpView.h"

@implementation HelpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    textView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 56);
    dismissButton.frame = CGRectMake((self.bounds.size.width - 120) / 2, self.bounds.size.height - 53, 120, 50);
}

- (void)setupSubviews {
    textView = [[UIWebView alloc] init];
    [self addSubview: textView];
    dismissButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: dismissButton];
    dismissButton.backgroundColor = [UIColor whiteColor];
    [dismissButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [dismissButton setTitle: @"Dismiss" forState: UIControlStateNormal];
}

- (void)addTarget: (id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [dismissButton addTarget:target action:action forControlEvents:controlEvents];
}

- (NSString*)text {
    return nil;
}

- (void)setText:(NSString *)text {
    [textView loadHTMLString:text baseURL:nil];
}

@end
