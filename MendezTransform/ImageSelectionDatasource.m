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
#import "GridImage.h"

@implementation ImageSelectionDatasource

static NSString *imageSelectionReuseIdentifier = @"imageselection";

- (NSArray*)fileList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager   *filemanager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *files = [filemanager contentsOfDirectoryAtPath: documentsDirectory error: &error];
    
    NSMutableArray  *resultarray = [NSMutableArray array];
    [resultarray addObject: @"Inbox"];
    for (NSUInteger i = 0; i < [files count]; i++) {
        NSString    *f = (NSString*)[files objectAtIndex: i];
        if (![@"Inbox" isEqualToString: f]) {
            [resultarray addObject: f];
        }
    }
    
    return resultarray;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString    *imagename = [self imageNameAtIndexPath: indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: imageSelectionReuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: imageSelectionReuseIdentifier];
    }
    if ([imagename isEqualToString: @"Inbox"]) {
        cell.textLabel.text = @"Downloaded images:";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.userInteractionEnabled = NO;
    } else {
        cell.textLabel.text = imagename;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.userInteractionEnabled = YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // find the number of file names in the Documents directory
    return [images count] + [[self fileList] count];
}

- (id)init {
    self = [super init];
    if (self) {
        images = [NSArray arrayWithObjects: @"afm.jpg", @"tabea.jpg", @"m42-final.jpg", @"m42-smooth.jpg", @"eth-main-building.jpg", @"hsr.jpg", @"blackwhite.png", @"Stripes", @"Dots", @"Grid", nil];
    }
    return self;
}

- (NSString *)imageNameAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.row < [images count]) {
        return (NSString*)[images objectAtIndex: indexPath.row];
    }
    NSArray *files = [self fileList];
    return (NSString*)[files objectAtIndex: indexPath.row - [images count]];
}

- (UIImage*)imageAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [images count]) {
        NSString *imagename = [self imageNameAtIndexPath: indexPath];
        if ([imagename isEqualToString: @"Stripes"]) {
            return [[StripeImage alloc] initWithSize: CGSizeMake(800,400) stripes: 5].image;
        }
        if ([imagename isEqualToString: @"Dots"]) {
            return [[DotsImage alloc] initWithSize: CGSizeMake(800,400) dots: 70].image;
        }
        if ([imagename isEqualToString: @"Grid"]) {
            return [[GridImage alloc] initWithSize: CGSizeMake(800,400) lines: 6].image;
        }
        return [UIImage imageNamed: imagename];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString    *imagename = [documentsDirectory stringByAppendingPathComponent: [self imageNameAtIndexPath: indexPath]];
    NSData      *imageData = [NSData dataWithContentsOfFile: imagename];
    UIImage     *image = [UIImage imageWithData: imageData];
    return image;
}

@end
