//
//  DDViewController.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *accelerationLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel *detectingLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)restartButtonPressed:(id)sender;
- (IBAction)segmentControlChanged:(id)sender;

@end
