//
//  Drive.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit
import CoreLocation

class Drive: NSObject
{
    var averageSpeed: Double
    var averageAcceleration: Double
    
    private var speedCount: Int
    private var accelerationCount: Int
    private var previousSpeed: Double
    private var previousTime: NSTimeInterval
    
    override init()
    {
        self.averageSpeed = 0
        self.averageAcceleration = 0
        
        self.accelerationCount = 0
        self.speedCount = 0
        self.previousSpeed = 0
        self.previousTime = 0
    }
    
    func addSpeed(speed: CLLocationSpeed, withTimeStamp timeStamp: NSDate)
    {
        if speed <= 0
        {
            return
        }
        
        self.addAccelerationFromSpeed(self.previousSpeed, atTime: timeStamp.timeIntervalSince1970, toSpeed: speed)
        self.previousSpeed = speed
        
        var calculatedSum = Double(self.speedCount) * self.averageSpeed
        self.speedCount++
        calculatedSum += speed
        self.averageSpeed = calculatedSum / Double(self.speedCount)
    }
    
    
    //MARK: - Private Methods
    private func addAccelerationFromSpeed(sourceSpeed: Double, atTime time: NSTimeInterval, toSpeed destinationSpeed: Double)
    {
        if self.previousTime <= 0
        {
            self.previousTime = time
            return
        }
        
        var timeDif = time - self.previousTime
        self.previousTime = time
        var acceleration = (destinationSpeed - sourceSpeed) / timeDif
        
        var calculatedSum = Double(self.accelerationCount) * self.averageAcceleration
        self.accelerationCount++
        calculatedSum += acceleration
        self.averageAcceleration = calculatedSum / Double(self.accelerationCount)
    }
}
