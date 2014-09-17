//
//  DriveController.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit

class DriveController: NSObject, DriveDetectorControlDelegate
{
    let driveDetector: DriveDetector
    private let driveStore: DriveStore
    
    override init()
    {
        self.driveDetector = DriveDetector()
        self.driveStore = DriveStore()
        super.init()
        
        self.driveDetector.controlDelegate = self
    }
    
    //MARK: - DDDriveDetectorControlDelegate
    func driveDetector(driveDetector: DriveDetector, didFinishDrive drive: Drive?)
    {
        if let finishedDrive = drive
        {
            self.driveStore.addDrive(finishedDrive)
        }
    }
    
}
