//
//  DDDriverDetector.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDDriveDetectorDelegate;

@interface DDDriverDetector : NSObject

@property (nonatomic, weak, readwrite) id<DDDriveDetectorDelegate> delegate;
@property (nonatomic, assign, readonly) double averageAcceleration;
@property (nonatomic, assign, readonly) double averageSpeed;
@property (nonatomic, assign, readonly) BOOL detectingLocation;

/** Begins updating location activity. If motion activity is available the detector will only detect their location when it can be sure that the user is driving in a car.
 
    @return Returns whether or not the detector was able to start, for example when a user has location data disabled or rejects this app from using it it will return a NO.
 */
- (BOOL)startDetecting;
- (void)stopDetecting;

@end

@protocol DDDriveDetectorDelegate <NSObject>

@optional
- (void)driveDetectorBeganUpdatingLocations;
- (void)driveDetectorStoppedUpdatingLocations;
- (void)locationUpdatedOnDriveDetector:(DDDriverDetector *)driveDetector;

@end
