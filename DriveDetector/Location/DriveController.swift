//
//  DriveController.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit

class DriveController: NSObject, DDDriveDetectorControlDelegate
{
    let driveDetector: DDDriverDetector
    private let driveStore: DriveStore
    
    override init()
    {
        self.driveDetector = DDDriverDetector()
        self.driveStore = DriveStore()
        super.init()
        
        self.driveDetector.controlDelegate = self
    }
    
    //MARK: - DDDriveDetectorControlDelegate
    func driveDetector(driveDetector: DDDriverDetectorProtocol!, didFinishDrive drive: Drive!)
    {
        self.driveStore.addDrive(drive)
    }
    
}
