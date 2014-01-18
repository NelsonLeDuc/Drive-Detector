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
@import CoreMotion;

@interface DDDriverDetector () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionActivityManager *activityManager;
@property (nonatomic, strong) DDDrive *currentDrive;
@property (nonatomic, strong) CMMotionActivity *currentActivity;

- (void)updateDetectionForActivity:(CMMotionActivity *)activity;
- (void)startUpdatingLocationData;
- (void)stopUpdatingLocationData;

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
        
        _activityManager = [[CMMotionActivityManager alloc] init];
        
        _currentDrive = [[DDDrive alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)startDetecting
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CMMotionActivityManager isActivityAvailable])
            [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
                [self updateDetectionForActivity:activity];
            }];
        else
            [self startUpdatingLocationData];
        
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (void)updateDetectionForActivity:(CMMotionActivity *)activity
{
    if ([activity confidence] == CMMotionActivityConfidenceLow)
        return;
    
    self.currentActivity = activity;
    
    if ([activity automotive])
        [self startUpdatingLocationData];
    else
        [self stopUpdatingLocationData];
}

- (void)startUpdatingLocationData
{
    [self.locationManager startUpdatingLocation];
    
    if ([self.delegate respondsToSelector:@selector(driveDetectorStoppedUpdatingLocations)])
        [self.delegate driveDetectorBeganUpdatingLocations];
}

- (void)stopUpdatingLocationData
{
    [self.locationManager startUpdatingLocation];
    
    if ([self.delegate respondsToSelector:@selector(driveDetectorBeganUpdatingLocations)])
        [self.delegate driveDetectorBeganUpdatingLocations];
}

#pragma mark - Property Setters/Getters

- (double)averageAcceleration
{
    return [self.currentDrive averageAcceleration];
}

- (double)averageSpeed
{
    return [self.currentDrive averageSpeed];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self.currentDrive addSpeed:[location speed] withTimeStamp:[location timestamp]];
    
    if ([self.delegate respondsToSelector:@selector(locationUpdatedOnDriveDetector:)])
        [self.delegate locationUpdatedOnDriveDetector:self];
}

@end
