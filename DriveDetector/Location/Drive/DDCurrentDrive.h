//
//  DDCurrentDrive.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/18/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CLLocationSpeed
typedef double CLLocationSpeed;
#endif

@interface DDCurrentDrive : NSObject

- (void)addSpeed:(CLLocationSpeed)speed withTimeStamp:(NSDate *)timeStamp;

@end
