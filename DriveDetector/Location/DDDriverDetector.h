//
//  DDDriverDetector.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDriverDetector : NSObject

@property (nonatomic, assign, readonly) double averageAcceleration;
@property (nonatomic, assign, readonly) double averageSpeed;

- (BOOL)startDetecting;

@end
