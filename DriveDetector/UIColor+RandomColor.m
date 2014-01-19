//
//  UIColor+RandomColor.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/19/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor
{
    CGFloat red = ((CGFloat)arc4random_uniform(256)) / 255;
    CGFloat blue = ((CGFloat)arc4random_uniform(256)) / 255;
    CGFloat green = ((CGFloat)arc4random_uniform(256)) / 255;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
