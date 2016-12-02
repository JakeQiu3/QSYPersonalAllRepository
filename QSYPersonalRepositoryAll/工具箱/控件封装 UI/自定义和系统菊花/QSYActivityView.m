//
//  QSYActivityView.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/16.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "QSYActivityView.h"
#import "ActivityView.h"

@interface QSYActivityView ()

@property (nonatomic, weak) ActivityView *currentView;// 自定义的菊花
@property (nonatomic, weak) UIActivityIndicatorView *sysView;// 系统菊花
@property (nonatomic, assign) BOOL isSystemActivityView;;

@end

@implementation QSYActivityView
+ (instancetype)shareInstance {
    static QSYActivityView *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

+ (void)startAnimatingInSuperView:(UIView *)superView isSystem:(BOOL)isSystem{
    //  获取该单利对象并添加到父视图上
    QSYActivityView *activityFatherView = [QSYActivityView shareInstance];
    activityFatherView.frame = superView.frame;
    activityFatherView.backgroundColor = [UIColor clearColor];
    [superView addSubview:activityFatherView];
    activityFatherView.isSystemActivityView = isSystem;
    if (!activityFatherView.isSystemActivityView) {
        ActivityView  *myView=[[ActivityView alloc] initWithFrame:CGRectZero];
        myView.center = activityFatherView.center;
        myView.hidesWhenStopped = YES;
        [activityFatherView addSubview:myView];// 也可以添加到keywindow
        activityFatherView.currentView = myView;
        [activityFatherView.currentView startAnimating];
        
    } else {
        //    系统的菊花
        UIActivityIndicatorView * systemView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        systemView.center = superView.center;
        systemView.color = [UIColor redColor];// 修改颜色
        [activityFatherView addSubview:systemView];// 也可以添加到keywindow
        activityFatherView.sysView = systemView;
        [activityFatherView.sysView startAnimating];
    }
}

+ (void)stopAnimating {
    QSYActivityView *activityFatherView = [QSYActivityView shareInstance];
    
    if (!activityFatherView.isSystemActivityView) {
        [activityFatherView.currentView stopAnimating];
        [activityFatherView.currentView removeFromSuperview];
        activityFatherView.currentView = nil;
    } else {
        [activityFatherView.sysView stopAnimating];
        [activityFatherView.sysView removeFromSuperview];
        activityFatherView.sysView = nil;
    }
    [activityFatherView removeFromSuperview];
}

+ (BOOL)isAnimating {
    QSYActivityView *activityFatherView = [QSYActivityView shareInstance];
    if (!activityFatherView.isSystemActivityView) {
        return activityFatherView.currentView.isAnimationRunning;
    }
    return activityFatherView.sysView.isAnimating;
    
}

@end
