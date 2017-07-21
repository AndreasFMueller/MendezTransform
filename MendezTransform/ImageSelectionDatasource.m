//
//  ImageSelectionDatasource.m
//  MendezTransform
//
//  Created by Andreas Müller on 20.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "ImageSelectionDatasource.h"

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
        images = [NSArray arrayWithObjects: @"afm.jpg", @"tabea.jpg", @"m42-final.jpg", @"m42-smooth.jpg", @"blackwhite.png", nil];
    }
    return self;
}

- (NSString *)imageNameAtIndexPath: (NSIndexPath*)indexPath {
    return (NSString*)[images objectAtIndex: indexPath.row];
}

@end
