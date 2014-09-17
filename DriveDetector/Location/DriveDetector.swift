//
//  DriveDetector.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class DriveDetector: NSObject, CLLocationManagerDelegate
{
    weak var delegate: DriveDetectorDelegate?
    weak var controlDelegate: DriveDetectorControlDelegate?
    
    var ignoreMotionActivity: Bool {
       didSet {
            self.startDetecting()
        }
    }
    var averageAcceleration: Double {
        if let drive = self.currentDrive
        {
            return drive.averageAcceleration
        }
            
        return 0.0
    }
    var averageSpeed: Double {
        if let drive = self.currentDrive
        {
            return drive.averageSpeed
        }
            
        return 0.0
    }
    var detectingLocation: Bool //editable
    
    private var locationManager: CLLocationManager
    private var activityManager: CMMotionActivityManager
    private var currentDrive: Drive?
    private var currentActivity: CMMotionActivity?
    private var inactivityTimer: NSTimer?
    
    override init()
    {
        
        self.locationManager = CLLocationManager()
        self.locationManager.distanceFilter = 5.0
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestAlwaysAuthorization()
        
        self.activityManager = CMMotionActivityManager()
        self.detectingLocation = false
        self.ignoreMotionActivity = false
        
        super.init()
        self.locationManager.delegate = self
    }
    
    func startDetecting() -> Bool
    {
        if !CLLocationManager.locationServicesEnabled()
        {
            return false
        }
        
        self.currentDrive = Drive()
        
        if !self.ignoreMotionActivity && CMMotionActivityManager.isActivityAvailable()
        {
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue()) { activity in
                self.updateDetectionForActivity(activity)
            }
        }
        else
        {
            self.startUpdatingLocationData()
        }
        
        return true
    }
    
    func stopDetecting()
    {
        self.stopUpdatingLocationData()
        self.activityManager.stopActivityUpdates()
        
        self.controlDelegate?.driveDetector?(self, didFinishDrive: self.currentDrive)
        self.currentDrive = nil
    }
    
    func restartDrive()
    {
        self.currentDrive = Drive()
        self.startDetecting()
    }
    
    //MARK: - Private Methods
    private func updateDetectionForActivity(activity: CMMotionActivity)
    {
        if activity.confidence == .Low
        {
            return
        }
        
        self.currentActivity = activity
        
        if activity.automotive
        {
            self.startUpdatingLocationData()
        }
        else
        {
            self.stopUpdatingLocationData()
        }
    }
    
    private func startUpdatingLocationData()
    {
        self.detectingLocation = true
        self.locationManager.startUpdatingLocation()
        self.delegate?.driveDetectorBeganUpdatingLocations?()
    }
    
    private func stopUpdatingLocationData()
    {
        self.detectingLocation = false
        self.locationManager.stopUpdatingLocation()
        self.delegate?.driveDetectorStoppedUpdatingLocations?()
    }
    
    private func updateInactivityTimer()
    {
        self.inactivityTimer?.invalidate()
        self.inactivityTimer = nil
        self.inactivityTimer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: Selector("activityFailedToOccurInTime"), userInfo: nil, repeats: false)
    }
    
    private func activityFailedToOccurInTime()
    {
        self.inactivityTimer?.invalidate()
        self.inactivityTimer = nil
        
        self.stopDetecting()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if let location = locations.last as? CLLocation
        {
            if location.horizontalAccuracy > 5.0
            {
                return
            }
            
            self.updateInactivityTimer()
            self.currentDrive?.addSpeed(location.speed, withTimeStamp: location.timestamp)
            self.delegate?.driveDetector?(self, didUpdateToLocation: location)
        }
    }
}

@objc protocol DriveDetectorDelegate
{
    optional func driveDetectorBeganUpdatingLocations()
    optional func driveDetectorStoppedUpdatingLocations()
    optional func driveDetector(driveDetector: DriveDetector, didUpdateToLocation location: CLLocation)
}

@objc protocol DriveDetectorControlDelegate
{
    optional func driveDetector(driveDetector: DriveDetector, didFinishDrive drive: Drive?)
}
