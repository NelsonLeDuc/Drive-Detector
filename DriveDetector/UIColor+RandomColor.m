//
//  UIColor+RandomColor.m
//  DriveDetector
//
//  Created by Nelson LeDuc on 1/19/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "UIColor+RandomColor.h"

#define kDifferenceAmount 10.0

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor
{
    CGFloat red = ((CGFloat)arc4random_uniform(256)) / 255;
    CGFloat blue = ((CGFloat)arc4random_uniform(256)) / 255;
    CGFloat green = ((CGFloat)arc4random_uniform(256)) / 255;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)randomColorDislike:(UIColor *)color
{
    UIColor *randomColor;
    NSInteger counter = 0;
    do
    {
        randomColor = [UIColor randomColor];
        counter++;
    } while ([self randomColor:randomColor isDifferentThan:color] && counter < 100);
    
    return randomColor;
}

+ (BOOL)randomColor:(UIColor *)randomColor isDifferentThan:(UIColor *)color
{
    CGFloat dislikeRed, dislikeGreen, dislikeBlue, dislikeAlpha;
    [color getRed:&dislikeRed green:&dislikeGreen blue:&dislikeBlue alpha:&dislikeAlpha];
    
    CGFloat red, green, blue, alpha;
    [randomColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (ABS(red - dislikeRed) < kDifferenceAmount)
        return NO;
    
    if (ABS(green - dislikeGreen) < kDifferenceAmount)
        return NO;
    
    if (ABS(blue - dislikeBlue) < kDifferenceAmount)
        return NO;
    
    return YES;
}

@end

@implementation UIColor (ConvenienceColor)

+ (UIColor *)colorWithIntegersRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha
{
    CGFloat redFloat, greenFloat, blueFloat, alphaFloat;
    redFloat = ((CGFloat) red) / 255.0;
    greenFloat = ((CGFloat) green) / 255.0;
    blueFloat = ((CGFloat) blue) / 255.0;
    alphaFloat = ((CGFloat) alpha) / 255.0;
    
    return [UIColor colorWithRed:redFloat green:greenFloat blue:blueFloat alpha:alphaFloat];
}

@end
