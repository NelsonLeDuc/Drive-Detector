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

@property (nonatomic, assign, readonly) double averageAcceleration;
@property (nonatomic, assign, readonly) double averageSpeed;

/**
    Begins updating location activity. If motion activity is
    available the detector will only detect their location when 
    it can sure that the user is driving in a car.
**/
- (BOOL)startDetecting;

@end

@protocol DDDriveDetectorDelegate <NSObject>



@end
