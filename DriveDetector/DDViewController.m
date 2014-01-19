//
//  DDViewController.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDViewController.h"
#import "DDDriverDetector.h"
#import "DDTrackingMapView.h"
@import CoreLocation;

@interface DDViewController () <DDDriveDetectorDelegate>

@property (nonatomic, strong) id<DDDriverDetector> detector;

- (void)updateViewLabelsWithDriveDetector:(id<DDDriverDetector>)driverDetector;

@end

@implementation DDViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateViewLabelsWithDriveDetector:nil];
    
    [self.trackingMapView setManualLocationTracking:YES];
    [self.trackingMapView setTrackUser:[self.trackSwitch isOn]];
}

#pragma mark - IBOutlets

- (IBAction)restartButtonPressed:(id)sender
{
    [self.detector restartDrive];
    [self updateViewLabelsWithDriveDetector:nil];
}

- (IBAction)motionSwitchChanged:(id)sender
{
    [self.detector setIgnoreMotionActivity:![self.motionSwitch isOn]];
}

- (IBAction)trackSwitchChanged:(id)sender
{
    [self.trackingMapView setTrackUser:[self.trackSwitch isOn]];
}

#pragma mark - Ovveride Setters/Getters

- (void)setDetector:(id<DDDriverDetector>)detector
{
    if (_detector)
        return;
    if (_detector == detector)
        return;
    
    _detector = detector;
    
    [_detector setIgnoreMotionActivity:![self.motionSwitch isOn]];
    [_detector setDelegate:self];
    [_detector startDetecting];
}

#pragma mark - Private Methods

- (void)updateViewLabelsWithDriveDetector:(id<DDDriverDetector>)driverDetector
{
    id<DDDriverDetector> detector = driverDetector;
    if (!detector)
        detector = self.detector;

    [self.speedLabel setText:[NSString stringWithFormat:@"%f", detector.averageSpeed]];
    [self.accelerationLabel setText:[NSString stringWithFormat:@"%f", detector.averageAcceleration]];
    NSString *detectingString = [detector detectingLocation] ? @"Detecting locations" : @"Not detecting locations";
    [self.detectingLabel setText:detectingString];
}

#pragma mark - DDDriveDetectorDelegate

- (void)driveDetectorBeganUpdatingLocations
{
    [self updateViewLabelsWithDriveDetector:nil];
}

- (void)driveDetectorStoppedUpdatingLocations
{
    [self updateViewLabelsWithDriveDetector:nil];
}

- (void)driveDetector:(id<DDDriverDetector>)driveDetector didUpdateToLocation:(CLLocation *)location
{
    [self updateViewLabelsWithDriveDetector:driveDetector];
    [self.trackingMapView updateLineLocation:location];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
