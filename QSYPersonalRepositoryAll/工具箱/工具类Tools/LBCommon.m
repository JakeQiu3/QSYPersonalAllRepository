//
//  LBCommon.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBCommon.h"

@implementation LBCommon

+ (UIViewController *)getCurrentViewController{
    UIViewController *result = nil;
    UIWindow * window = [self getMainWindow];
    UIView *frontView = [[window subviews] lastObject];
    id nextResponder = [frontView nextResponder];
    while ([nextResponder nextResponder]) {
        nextResponder = [nextResponder nextResponder];
    }
    if ([nextResponder isKindOfClass:[UIViewController class]]) result = nextResponder;
    else result = window.rootViewController;
    return [self getTopViewController:result];
}

+ (UIWindow *)getMainWindow{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (UIViewController *)getTopViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
    } else if (viewController.presentedViewController) {
        return [self getTopViewController:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

+ (UIView*)getFirstResponderView:(UIView *)view{
    for (UIView* childView in view.subviews) {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] && ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UITextView class]]))
            return childView;
        UIView* result = [self getFirstResponderView:childView];
        if (result)
            return result;
    }
    return nil;
}

+ (NSString *)getLanguageUsing{
    NSArray *languages=[NSLocale preferredLanguages];
    NSString *currentLanguage=[languages objectAtIndex:0];
    return currentLanguage;
}

+ (NSArray *)getLanguageSupport{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *languages=[defaults objectForKey:@"AppleLanguages"];
    return languages;
}

+ (CGSize)getBigSize:(NSString *)string font:(UIFont *)font width:(CGFloat)width{
    //如有换行需要，需设置换行
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    //设置属性参数
    NSDictionary *attrs = @{NSFontAttributeName :font,
                            NSParagraphStyleAttributeName:paragraphStyle};
    CGSize bigSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return bigSize;
}


@end
