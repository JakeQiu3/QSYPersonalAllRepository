//
//  UIColor+LBExtension.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LBExtension)

/**
 *  产生随机颜色
 */
+ (UIColor *)lb_colorRandom;

/**
 *  hexColor -> UIColor
 */
+ (UIColor*)lb_colorWithHex:(long)hexColor;

/**
 *  hexColor -> UIColor(带有alpha)
 */
+ (UIColor *)lb_colorWithHex:(long)hexColor alpha:(float)opacity;

@end
