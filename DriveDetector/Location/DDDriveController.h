//
//  DDDriveController.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/18/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDDriverDetector;

@interface DDDriveController : NSObject

@property (nonatomic, strong, readonly) DDDriverDetector *driveDetector;

@end
