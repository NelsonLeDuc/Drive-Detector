//
//  DDDriveController.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/18/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDDriveController.h"
#import "DDDriverDetector.h"

@interface DDDriveController ()

@property (nonatomic, strong, readwrite) DDDriverDetector *driveDetector;

@end

@implementation DDDriveController

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _driveDetector = [[DDDriverDetector alloc] init];
    }
    return self;
}

@end
