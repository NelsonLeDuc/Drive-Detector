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
@property (nonatomic, strong) NSTimer *inactivityTimer;
@property (nonatomic, assign, readwrite) BOOL detectingLocation;

- (void)updateDetectionForActivity:(CMMotionActivity *)activity;
- (void)startUpdatingLocationData;
- (void)stopUpdatingLocationData;
- (void)updateInactivityTimer;
- (void)activityFailedToOccurInTime;

@end

@implementation DDDriverDetector

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDistanceFilter:5.0];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [_locationManager setDelegate:self];
        
        _activityManager = [[CMMotionActivityManager alloc] init];
        
        _currentDrive = [[DDDrive alloc] init];
        
        _detectingLocation = NO;
        _ignoreMotionActivity = NO;
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)startDetecting
{
    [self stopDetecting];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (!self.ignoreMotionActivity && [CMMotionActivityManager isActivityAvailable])
            [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
                [self updateDetectionForActivity:activity];
            }];
        else
            [self startUpdatingLocationData];
        
        return YES;
    }
    return NO;
}

- (void)stopDetecting
{
    [self stopUpdatingLocationData];
    [self.activityManager stopActivityUpdates];
}

- (void)restartDrive
{
    self.currentDrive = [[DDDrive alloc] init];
    [self startDetecting];
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
    _detectingLocation = YES;
    [self.locationManager startUpdatingLocation];
    
    if ([self.delegate respondsToSelector:@selector(driveDetectorStoppedUpdatingLocations)])
        [self.delegate driveDetectorBeganUpdatingLocations];
}

- (void)stopUpdatingLocationData
{
    _detectingLocation = NO;
    [self.locationManager startUpdatingLocation];
    
    if ([self.delegate respondsToSelector:@selector(driveDetectorBeganUpdatingLocations)])
        [self.delegate driveDetectorBeganUpdatingLocations];
}

- (void)updateInactivityTimer
{
    [self.inactivityTimer invalidate];
    self.inactivityTimer = nil;
    self.inactivityTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(activityFailedToOccurInTime)  userInfo:nil repeats:NO];
}

- (void)activityFailedToOccurInTime
{
    [self.inactivityTimer invalidate];
    self.inactivityTimer = nil;
    
    [self stopDetecting];
}

#pragma mark - Property Setters/Getters

- (void)setIgnoreMotionActivity:(BOOL)ignoreMotionActivity
{
    if (_ignoreMotionActivity == ignoreMotionActivity)
        return;
    _ignoreMotionActivity = ignoreMotionActivity;
    
    [self startDetecting];
}

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
    
    if ([location horizontalAccuracy] > 5.0)
        return;
    
    [self updateInactivityTimer];
    
    [self.currentDrive addSpeed:[location speed] withTimeStamp:[location timestamp]];
    
    if ([self.delegate respondsToSelector:@selector(driveDetector:didUpdateToLocation:)])
        [self.delegate driveDetector:self didUpdateToLocation:location];
}

@end
