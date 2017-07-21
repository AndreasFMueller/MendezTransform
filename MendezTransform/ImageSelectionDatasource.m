//
//  ImageSelectionDatasource.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ImageSelectionDatasource.h"
#import "StripeImage.h"
#import "DotsImage.h"

@implementation ImageSelectionDatasource

static NSString *imageSelectionReuseIdentifier = @"imageselection";

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString    *imagename = [images objectAtIndex: indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: imageSelectionReuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: imageSelectionReuseIdentifier];
    }
    cell.textLabel.text = imagename;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [images count];
}

- (id)init {
    self = [super init];
    if (self) {
        images = [NSArray arrayWithObjects: @"afm.jpg", @"tabea.jpg", @"m42-final.jpg", @"m42-smooth.jpg", @"blackwhite.png", @"Stripes", @"Dots", nil];
    }
    return self;
}

- (NSString *)imageNameAtIndexPath: (NSIndexPath*)indexPath {
    return (NSString*)[images objectAtIndex: indexPath.row];
}

- (UIImage*)imageAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imagename = [self imageNameAtIndexPath: indexPath];
    if ([imagename isEqualToString: @"Stripes"]) {
        return [[StripeImage alloc] initWithSize: CGSizeMake(800,400) stripes: 5].image;
    }
    if ([imagename isEqualToString: @"Dots"]) {
        return [[DotsImage alloc] initWithSize: CGSizeMake(800,400) dots: 50].image;
    }
    return [UIImage imageNamed: imagename];
}

@end
