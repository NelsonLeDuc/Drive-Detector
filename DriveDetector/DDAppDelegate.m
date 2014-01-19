//
//  DDAppDelegate.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDViewController.h"
#import "DDDriveController.h"

@interface DDAppDelegate ()

@property (nonatomic, strong) DDDriveController *driveController;

@end

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.driveController = [[DDDriveController alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DDViewController *driveViewController = (DDViewController *)[storyboard instantiateInitialViewController];
    [driveViewController setDetector:[self.driveController driveDetector]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:driveViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
