//
//  DDViewController.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDTrackingMapView;
@protocol DDDriverDetector;

@interface DDViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *accelerationLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel *detectingLabel;
@property (nonatomic, weak) IBOutlet UISwitch *motionSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *trackSwitch;
@property (nonatomic, weak) IBOutlet DDTrackingMapView *trackingMapView;

- (IBAction)restartButtonPressed:(id)sender;
- (IBAction)motionSwitchChanged:(id)sender;
- (IBAction)trackSwitchChanged:(id)sender;
- (void)setDetector:(id<DDDriverDetector>)detector;

@end
