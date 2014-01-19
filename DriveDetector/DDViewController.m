//
//  DDViewController.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDViewController.h"
#import "DDDriverDetector.h"

@interface DDViewController () <DDDriveDetectorDelegate>

@property (nonatomic, strong) DDDriverDetector *detector;

- (void)updateViewLabelsWithDriveDetector:(DDDriverDetector *)driveDetector;

@end

@implementation DDViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.segmentControl setSelectedSegmentIndex:0];
    
    self.detector = [[DDDriverDetector alloc] init];
    [self.detector setIgnoreMotionActivity:([self.segmentControl selectedSegmentIndex] == 1)];
    [self.detector setDelegate:self];
    [self.detector startDetecting];
    
    [self updateViewLabelsWithDriveDetector:nil];
}

#pragma mark - IBOutlets

- (IBAction)restartButtonPressed:(id)sender
{
    [self.detector restartDrive];
}

- (IBAction)segmentControlChanged:(id)sender
{
    [self.detector setIgnoreMotionActivity:([self.segmentControl selectedSegmentIndex] == 1)];
}

#pragma mark - Private Methods

- (void)updateViewLabelsWithDriveDetector:(DDDriverDetector *)driveDetector
{
    DDDriverDetector *detector = driveDetector;
    if (!driveDetector)
        driveDetector = self.detector;

    [self.speedLabel setText:[NSString stringWithFormat:@"Speed:   %f", detector.averageSpeed]];
    [self.accelerationLabel setText:[NSString stringWithFormat:@"Acceleration: %f", detector.averageAcceleration]];
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

- (void)locationUpdatedOnDriveDetector:(DDDriverDetector *)driveDetector
{
    [self updateViewLabelsWithDriveDetector:driveDetector];
}

@end
