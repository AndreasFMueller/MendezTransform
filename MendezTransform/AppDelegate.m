//
//  AppDelegate.m
//  MendezTransform
//
//  Created by Andreas Müller on 06.07.17.
//  Copyright © 2017 Andreas Müller. All rights reserved.
//

#import "AppDelegate.h"
#import "ComparisonFilter.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ComparisonFilter class];
    // Override point for customization after application launch.
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString __block   *imagefile = url.path;
    NSData  *imageData = [NSData dataWithContentsOfFile: imagefile];
    if (nil == imageData) {
        return NO;
    }
    UIImage *image = [UIImage imageWithData: imageData];
    if (nil == image) {
        return NO;
    }
    
    ViewController  *vc = (ViewController*)self.window.rootViewController;
    vc.image = image;
    
    UIAlertController   *alert = [UIAlertController alertControllerWithTitle: @"New image" message: @"A new image was opened. Shall we keep this image for future use?" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction   *keepAction = [UIAlertAction actionWithTitle: @"Keep" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"keep image");
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *targetfile = [documentsDirectory stringByAppendingPathComponent: [imagefile lastPathComponent]];
        NSLog(@"writing file to: %@", targetfile);
        if (![[NSFileManager defaultManager] fileExistsAtPath: imagefile]) {
            BOOL    rc = [[NSFileManager defaultManager] copyItemAtPath: imagefile toPath: targetfile error: &error];
            if (!rc) {
                NSLog(@"file not copied: %@", error.description);
            }
        }
        [[NSFileManager defaultManager] removeItemAtURL: url error: &error];
    }];
    UIAlertAction   *forgetAction = [UIAlertAction actionWithTitle: @"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"delete image: %@", imagefile);
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath: imagefile error: &error];
    }];
    [alert addAction: keepAction];
    [alert addAction: forgetAction];
    [vc presentViewController: alert animated: YES completion: nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
