//
//  MainViewController.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, DriveDetectorDelegate
{
    @IBOutlet var accelerationLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var detectingLabel: UILabel!
    @IBOutlet var motionSwitch: UISwitch!
    @IBOutlet var trackSwitch: UISwitch!
    @IBOutlet var trackingMapView: TrackingMapView!
    @IBOutlet var containerView: UIView!
    
    var blurView: UIView?
    var detector: DriveDetector?
    
    //MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updateViewLabelsWithDriverDetector()
        
        self.trackingMapView.manualLocationTracking = true
        self.trackingMapView.trackUser = self.trackSwitch.on
        
        self.detector?.delegate = self
        self.detector?.ignoreMotionActivity = self.motionSwitch.on
        self.detector?.displayingMapView = self.trackingMapView
        self.detector?.startDetecting()
    }

    override func viewWillLayoutSubviews()
    {
        self.blurView?.removeFromSuperview()
        
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        self.blurView!.frame = self.containerView.bounds
        self.containerView.addSubview(blurView!)
        self.containerView.sendSubviewToBack(blurView!)
    }
    
    //MARK: - IBAction
    @IBAction func restartButtonPressed(sender: UIButton)
    {
        self.detector?.restartDrive()
        self.updateViewLabelsWithDriverDetector()
    }
    
    @IBAction func motionSwitchChanged(sender: UISwitch)
    {
        self.detector?.ignoreMotionActivity = self.motionSwitch.on
    }
    
    @IBAction func trackSwitchChanged(sender: UISwitch)
    {
        self.trackingMapView.trackUser = self.trackSwitch.on
    }
    
    //MARK: - DDDriveDetectorDelegate
    func driveDetectorBeganUpdatingLocations()
    {
        self.updateViewLabelsWithDriverDetector()
    }
    
    func driveDetectorStoppedUpdatingLocations()
    {
        self.updateViewLabelsWithDriverDetector()
    }
    
    func driveDetector(driveDetector: DriveDetector!, didUpdateToLocation location: CLLocation!)
    {
        self.updateViewLabelsWithDriverDetector()
    }
    
    //MARK: - Overrides
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    //MARK: - Private Methods
    func updateViewLabelsWithDriverDetector()
    {
        var string = "Not detecting locations"
        if let detector = self.detector
        {
            let MPH = MPHfromMetersPerSecond(CGFloat(detector.averageSpeed))
            let meterAccel = MetersAccelToMilesAccel(detector.averageAcceleration)
            
            self.speedLabel.text = "\(MPH)"
            self.accelerationLabel.text = "\(meterAccel)"
            
            string = detector.detectingLocation ? "Detecting locations" : "Not detecting locations"
        }
        self.detectingLabel.text = string
    }
}
