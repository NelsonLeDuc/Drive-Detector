//
//  DDDriverDetector.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDDriverDetector.h"
#import "DDCurrentDrive.h"
@import CoreLocation;

@interface DDDriverDetector () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DDCurrentDrive *currentDrive;

@end

@implementation DDDriverDetector

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        
        _currentDrive = [[DDCurrentDrive alloc] init];
    }
    return self;
}

- (BOOL)startDetecting
{
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
        return YES;
    }
    return NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self.currentDrive addSpeed:[location speed] withTimeStamp:[location timestamp]];
}

@end
