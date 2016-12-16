//
//  UIColor+LBExtension.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "UIColor+LBExtension.h"

@implementation UIColor (LBExtension)

+ (UIColor *)lb_colorRandom{
    CGFloat hue = (arc4random()%256/256.0); //0.0 to 1.0
    CGFloat saturation = (arc4random()%128/256.0)+0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = (arc4random()%128/256.0)+0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor*)lb_colorWithHex:(long)hexColor;{
    return [UIColor lb_colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)lb_colorWithHex:(long)hexColor alpha:(float)opacity{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

@end
