//
//  DDViewController.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class DDDriverDetector;

@interface DDViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *accelerationLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel *detectingLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *motionSegmentControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *trackingSegmentControl;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

- (IBAction)restartButtonPressed:(id)sender;
- (IBAction)motionSegmentControlChanged:(id)sender;
- (IBAction)trackingSegmentControlChanged:(id)sender;
- (void)setDetector:(DDDriverDetector *)detector;

@end
