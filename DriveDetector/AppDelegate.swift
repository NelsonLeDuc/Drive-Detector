//
//  DDAppDelegate.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/16/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit

@UIApplicationMain
class DDAppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var driveController: DriveController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        self.driveController = DriveController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var driveViewController = storyboard.instantiateInitialViewController() as MainViewController
//        driveViewController.setDetector(self.driveController.driveDetector)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = driveViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
