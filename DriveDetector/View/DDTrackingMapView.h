//
//  DDTrackingMapView.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/19/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface DDTrackingMapView : UIView

@property (nonatomic, assign) BOOL trackUser;
@property (nonatomic, assign) BOOL manualLocationTracking;

- (void)updateLineLocation:(CLLocation *)location;
- (void)endCurrentLine;

@end
