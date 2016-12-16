//
//  LBCommon.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：通用类
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBCommon : NSObject

/**
 *  获取当前控制器
 *
 //注意 如：UITabbarController——>UINavigationController——>UIViewController——>presentViewController——>UINavigationController——>UIViewController.
 //这种流程的情景下，单单是getCurrentViewController方法就无法正确获取当前屏幕上的ViewController了。
 //于是我补充了getTopViewController:这个方法，来获取当前屏幕显示的viewcontroller。
 *
 *  @return <#return value description#>
 */
+ (UIViewController *)getCurrentViewController;

+ (UIWindow *)getMainWindow;

+ (UIViewController *)getTopViewController:(UIViewController *)viewController;

/**
 *  获得第一响应者
 *
 *  @param view <#view description#>
 *
 *  @return <#return value description#>
 */
+ (UIView*)getFirstResponderView:(UIView *)view;

/**
 *  获取iPhone当前使用的语言
 *
 *  @return <#return value description#>
 */
+ (NSString *)getLanguageUsing;

/**
 *  获取iPhone支持的所有语言
 *
 *  @return <#return value description#>
 */
+ (NSArray *)getLanguageSupport;

/**
 *  获得最大高度(通用)
 *
 *  @param string <#string description#>
 *  @param font   传入的字体大小，传入和设置需保持一致
 *  @param width  <#width description#>
 *
 *  @return <#return value description#>
 */
+ (CGSize)getBigSize:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

@end
