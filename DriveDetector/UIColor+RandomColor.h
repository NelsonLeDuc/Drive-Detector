//
//  UIColor+RandomColor.h
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/19/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RandomColor)

+ (UIColor *)randomColor;
+ (UIColor *)randomColorDislike:(UIColor *)color;

@end

@interface UIColor (ConvenienceColor)

+ (UIColor *)colorWithIntegersRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

@end