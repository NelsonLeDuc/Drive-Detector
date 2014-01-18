//
//  DDCurrentDrive.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/18/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDCurrentDrive.h"

@interface DDCurrentDrive () {
    NSInteger _speedCount, _accelerationCount;
    double _previousSpeed;
    NSTimeInterval _previousTime;
}

@property (nonatomic, assign) double averageSpeed;
@property (nonatomic, assign) double averageAcceleration;

- (void)addAccelerationFromSpeed:(double)sourceSpeed atTime:(NSTimeInterval)time toSpeed:(double)destinationSpeed;

@end

@implementation DDCurrentDrive

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _averageSpeed = 0.0;
    }
    return self;
}

#pragma mark - Public Methods

- (void)addSpeed:(CLLocationSpeed)speed withTimeStamp:(NSDate *)timeStamp
{
    if (speed <= 0)
        return;
    
    [self addAccelerationFromSpeed:_previousSpeed atTime:[timeStamp timeIntervalSince1970] toSpeed:speed];
    _previousSpeed = speed;
    
    double calculatedSum = (((double)_speedCount) * _averageSpeed);
    _speedCount++;
    calculatedSum += speed;
    _averageSpeed = (calculatedSum / ((double)_speedCount));
}

#pragma mark - Private Methods

- (void)addAccelerationFromSpeed:(double)sourceSpeed atTime:(NSTimeInterval)time toSpeed:(double)destinationSpeed
{
    if (_previousTime <= 0)
    {
        _previousTime = time;
        return;
    }
    
    NSTimeInterval timeDif = time - _previousTime;
    _previousTime = time;
    double acceleration = (destinationSpeed - sourceSpeed) / timeDif;
    
    double calculatedSum = (((double)_accelerationCount) * _averageAcceleration);
    _accelerationCount++;
    calculatedSum += acceleration;
    _averageAcceleration = (calculatedSum / ((double)_accelerationCount));
}

@end
