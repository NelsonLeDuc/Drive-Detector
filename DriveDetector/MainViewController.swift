//
//  MainViewController.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, DDDriveDetectorDelegate
{
    @IBOutlet var accelerationLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var detectingLabel: UILabel!
    @IBOutlet var motionSwitch: UISwitch!
    @IBOutlet var trackSwitch: UISwitch!
    @IBOutlet var trackingMapView: TrackingMapView!
    
    private var detector: DDDriverDetectorProtocol?
    
    //MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(self.view.description)
        self.updateViewLabelsWithDriverDetector(self.detector)
        
        self.trackingMapView.manualLocationTracking = true
        self.trackingMapView.trackUser = self.trackSwitch.on
    }

    //MARK: - IBAction
    @IBAction func restartButtonPressed(sender: UIButton)
    {
        self.detector?.restartDrive()
        self.updateViewLabelsWithDriverDetector(self.detector)
        self.trackingMapView.endCurrentLine()
    }
    
    @IBAction func motionSwitchChanged(sender: UISwitch)
    {
        self.detector?.ignoreMotionActivity = self.motionSwitch.on
    }
    
    @IBAction func trackSwitchChanged(sender: UISwitch)
    {
        self.trackingMapView.trackUser = self.trackSwitch.on
    }
    
    func setDetector(detector: DDDriverDetectorProtocol)
    {
        detector.ignoreMotionActivity = self.motionSwitch.on
        detector.delegate = self
        detector.startDetecting()
    }
    
    //MARK: - DDDriveDetectorDelegate
    func driveDetectorBeganUpdatingLocations()
    {
        self.updateViewLabelsWithDriverDetector(self.detector)
    }
    
    func driveDetectorStoppedUpdatingLocations()
    {
        self.updateViewLabelsWithDriverDetector(self.detector)
    }
    
    func driveDetector(driveDetector: DDDriverDetectorProtocol!, didUpdateToLocation location: CLLocation!)
    {
        self.updateViewLabelsWithDriverDetector(self.detector)
        self.trackingMapView.updateLineLocation(location)
    }
    
    //MARK: - Overrides
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    //MARK: - Private Methods
    func updateViewLabelsWithDriverDetector(driverDetector: DDDriverDetectorProtocol?)
    {
        var string = "Not detecting locations"
        if let detector = driverDetector
        {
            self.speedLabel.text = "\(detector.averageSpeed)"
            self.accelerationLabel.text = "\(detector.averageAcceleration)"
            
            string = detector.detectingLocation ? "Detecting locations" : "Not detecting locations"
        }
        self.detectingLabel.text = string
    }
}
