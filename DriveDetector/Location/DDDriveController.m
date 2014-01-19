//
//  DDDriveController.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/18/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDDriveController.h"
#import "DDDriverDetector.h"
#import "DDDriveStore.h"

@interface DDDriveController () <DDDriveDetectorControlDelegate>

@property (nonatomic, strong, readwrite) DDDriverDetector *driveDetector;
@property (nonatomic, strong) DDDriveStore *driveStore;

@end

@implementation DDDriveController

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _driveDetector = [[DDDriverDetector alloc] init];
        [_driveDetector setControlDelegate:self];
        
        _driveStore = [[DDDriveStore alloc] init];
    }
    return self;
}

#pragma mark - DDDriveDetectorControlDelegate

- (void)driveDetector:(id<DDDriverDetector>)driveDetector didFinishDrive:(DDDrive *)drive
{
    [self.driveStore addDrive:drive];
}

@end
