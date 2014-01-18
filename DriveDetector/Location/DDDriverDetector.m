//
//  DDDriverDetector.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDDriverDetector.h"
#import "DDDrive.h"
@import CoreLocation;

@interface DDDriverDetector () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DDDrive *currentDrive;

@end

@implementation DDDriverDetector

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        
        _currentDrive = [[DDDrive alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

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
