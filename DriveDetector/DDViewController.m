//
//  DDViewController.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDViewController.h"
#import "DDDriverDetector.h"
@import MapKit;

@interface DDViewController () <DDDriveDetectorDelegate, MKMapViewDelegate> {
    BOOL _trackingUser;
}

@property (nonatomic, strong) DDDriverDetector *detector;
@property (nonatomic, strong) NSArray *linePosition;
@property (nonatomic, strong) MKPolyline *polyline;

- (void)updateViewLabelsWithDriveDetector:(DDDriverDetector *)driverDetector;
- (void)addLocationToArray:(CLLocation *)location;
- (void)updateMapViewWithTracking:(NSNumber *)trackingNumber;

@end

@implementation DDViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.linePosition = [NSArray array];
    
    [self.motionSegmentControl setSelectedSegmentIndex:0];
    [self.trackingSegmentControl setSelectedSegmentIndex:0];
    
    [self updateViewLabelsWithDriveDetector:nil];
    [self.mapView setDelegate:self];
    
    _trackingUser = NO;
}

#pragma mark - IBOutlets

- (IBAction)restartButtonPressed:(id)sender
{
    [self.detector restartDrive];
    [self updateViewLabelsWithDriveDetector:nil];
}

- (IBAction)motionSegmentControlChanged:(id)sender
{
    [self.detector setIgnoreMotionActivity:([self.motionSegmentControl selectedSegmentIndex] == 1)];
    [self updateViewLabelsWithDriveDetector:nil];
}

- (IBAction)trackingSegmentControlChanged:(id)sender
{
    [self updateMapViewWithTracking:[NSNumber numberWithBool:([self.trackingSegmentControl selectedSegmentIndex] == 0)]];
}

#pragma mark - Ovveride Setters/Getters

- (void)setDetector:(DDDriverDetector *)detector
{
    if (_detector)
        return;
    if (_detector == detector)
        return;
    
    _detector = detector;
    
    [_detector setIgnoreMotionActivity:([self.motionSegmentControl selectedSegmentIndex] == 1)];
    [_detector setDelegate:self];
    [_detector startDetecting];
}

#pragma mark - Private Methods

- (void)updateViewLabelsWithDriveDetector:(DDDriverDetector *)driverDetector
{
    DDDriverDetector *detector = driverDetector;
    if (!detector)
        detector = self.detector;

    [self.speedLabel setText:[NSString stringWithFormat:@"Speed:   %f", detector.averageSpeed]];
    [self.accelerationLabel setText:[NSString stringWithFormat:@"Acceleration: %f", detector.averageAcceleration]];
    NSString *detectingString = [detector detectingLocation] ? @"Detecting locations" : @"Not detecting locations";
    [self.detectingLabel setText:detectingString];
}

- (void)addLocationToArray:(CLLocation *)location
{
    self.linePosition = [self.linePosition arrayByAddingObject:location];
    CLLocationCoordinate2D* coordinates = malloc([self.linePosition count] * sizeof(CLLocationCoordinate2D));
    for (NSInteger i = 0; i < [self.linePosition count]; i++)
    {
        CLLocation *location = [self.linePosition objectAtIndex:i];
        coordinates[i] = [location coordinate];
    }
    [self.mapView removeOverlay:self.polyline];
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:[self.linePosition count]];
    [self.mapView addOverlay:self.polyline];
}

- (void)updateMapViewWithTracking:(NSNumber *)trackingNumber
{
    BOOL tracking = [trackingNumber boolValue];
    MKUserTrackingMode trackingMode = tracking ? MKUserTrackingModeFollowWithHeading : MKUserTrackingModeNone;
    [self.mapView setUserTrackingMode:trackingMode animated:YES];
    [self.mapView setScrollEnabled:!tracking];
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

- (void)driveDetector:(DDDriverDetector *)driveDetector didUpdateToLocation:(CLLocation *)location
{
    [self updateViewLabelsWithDriveDetector:driveDetector];
    [self addLocationToArray:location];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_trackingUser)
        return;
    
    _trackingUser = YES;
    [self updateMapViewWithTracking:@(YES)];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    [renderer setStrokeColor:[UIColor blueColor]];
    [renderer setLineWidth:2];
    return renderer;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
