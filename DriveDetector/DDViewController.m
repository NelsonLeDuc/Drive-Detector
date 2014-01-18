//
//  DDViewController.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "DDViewController.h"
#import "DDDriverDetector.h"

@interface DDViewController ()

@property (nonatomic, strong) DDDriverDetector *detector;

@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detector = [[DDDriverDetector alloc] init];
    [self.detector startDetecting];
}

@end