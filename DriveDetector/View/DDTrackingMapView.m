//
//  DDTrackingMapView.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/19/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDTrackingMapView.h"
#import "UIColor+RandomColor.h"
@import MapKit;

@interface DDTrackingMapView () <MKMapViewDelegate> {
    BOOL _trackingUser;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *linePositions;
@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) UIColor *lineColor;

- (void)setUpView;
- (void)updateMapViewWithTracking:(BOOL)tracking;

@end

@implementation DDTrackingMapView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

#pragma mark - Public Methods

- (void)updateLineLocation:(CLLocation *)location
{
    if (self.manualLocationTracking)
        [self addLocationToArray:location];
}

#pragma mark - Private Methods

- (void)setUpView
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    [self.mapView setDelegate:self];
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.mapView];
    
    UIView *mapView = self.mapView;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(mapView);

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:bindings]];
    [self layoutIfNeeded];
    
    _linePositions = [[NSArray alloc] init];
    _manualLocationTracking = NO;
    
    [self updateMapViewWithTracking:YES];
}

- (void)updateMapViewWithTracking:(BOOL)tracking
{
    MKUserTrackingMode trackingMode = tracking ? MKUserTrackingModeFollowWithHeading : MKUserTrackingModeNone;
    [self.mapView setUserTrackingMode:trackingMode animated:YES];
    [self.mapView setScrollEnabled:!tracking];
}

#pragma mark - Ovveride Setters/Getters

- (void)setTrackUser:(BOOL)trackUser
{
    if (_trackUser == trackUser)
        return;
    
    _trackUser = trackUser;
    
    [self updateMapViewWithTracking:_trackUser];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!_trackingUser)
    {
        _trackingUser = YES;
        [self updateMapViewWithTracking:YES];
    }
    if (!self.manualLocationTracking)
        [self addLocationToArray:[userLocation location]];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if (!self.lineColor)
        self.lineColor = [UIColor randomColorDislike:[UIColor colorWithIntegersRed:251 green:211 blue:40 alpha:255]];
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    [renderer setStrokeColor:self.lineColor];
    [renderer setLineWidth:5];
    return renderer;
}

- (void)addLocationToArray:(CLLocation *)location
{
    if (!location)
        return;
    
    CLLocationDistance distance = [location distanceFromLocation:[self.linePositions lastObject]];
    if (distance > 100)
    {
        if ([self.polyline pointCount] < 10)
            [self.mapView removeOverlay:self.polyline];
        self.polyline = nil;
        self.linePositions = [NSArray array];
        self.lineColor = nil;
    }
    
    self.linePositions = [self.linePositions arrayByAddingObject:location];
    CLLocationCoordinate2D* coordinates = malloc([self.linePositions count] * sizeof(CLLocationCoordinate2D));
    for (NSInteger i = 0; i < [self.linePositions count]; i++)
    {
        CLLocation *location = [self.linePositions objectAtIndex:i];
        coordinates[i] = [location coordinate];
    }
    [self.mapView removeOverlay:self.polyline];
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:[self.linePositions count]];
    [self.mapView addOverlay:self.polyline];
}

@end
