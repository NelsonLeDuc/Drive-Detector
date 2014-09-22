//
//  Extensions.swift
//  DriveDetector
//
//  Created by Nelson LeDuc on 9/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit
import Foundation

let kDifferenceAmount: CGFloat = 15.0

extension UIColor
{
    class func randomColor(alpha: Float = 1.0) -> UIColor
    {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    
    class func randomColorDislike(color: UIColor) -> UIColor
    {
        var randomColor: UIColor
        var counter = 0
        do {
            randomColor = self.randomColor()
            counter++
        } while self.randomColor(randomColor, isDifferentThan: color) && counter < 100
        
        return randomColor
    }
    
    private class func randomColor(color: UIColor, isDifferentThan: UIColor) -> Bool
    {
        var dislikeRed: CGFloat = 0
        var dislikeGreen: CGFloat = 0
        var dislikeBlue: CGFloat = 0
        var dislikeAlpha: CGFloat = 0
        color.getRed(&dislikeRed, green: &dislikeGreen, blue: &dislikeBlue, alpha: &dislikeAlpha)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if abs(red - dislikeRed) < kDifferenceAmount
        {
            return false
        }
        
        if abs(green - dislikeGreen) < kDifferenceAmount
        {
            return false
        }
        
        if abs(blue - dislikeBlue) < kDifferenceAmount
        {
            return false
        }
        
        return true
    }
    
    class func color(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor
    {
        let redFloat = CGFloat(red) / 255
        let greenFloat = CGFloat(green) / 255
        let blueFloat = CGFloat(blue) / 255
        let alphaFloat = CGFloat(alpha) / 255
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
    }
    
}

let kMeterAccelToMilesAccelFactor = 8052.9706513958

public func MetersAccelToMilesAccel(metersAccel: Double) -> Double
{
    return kMeterAccelToMilesAccelFactor * metersAccel
}