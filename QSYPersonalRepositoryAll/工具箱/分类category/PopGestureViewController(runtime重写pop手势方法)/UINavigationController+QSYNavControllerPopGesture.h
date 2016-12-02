//
//  UINavigationController+QSYNavControllerPopGesture.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/1.
//  Copyright © 2016年 QSY. All rights reserved.
// 逻辑：pushviewcontroller:animated: 设置block setter，执行push,同时创建了一个qsyPopGestureRecognizer 手势，并获取到实现的方法; VC的viewwillAppear时执行private的block方法，实现设置导航条的隐藏或显示。 

#import <UIKit/UIKit.h>
//导航控制器的分类：功能： 添加pop手势
@interface UINavigationController (QSYNavControllerPopGesture)

// 导航控制器添加手势属性，导航条可显示的属性。
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *qsyPopGestureRecognizer;
@property (nonatomic, assign)IBInspectable BOOL qsyViewControllerNavigationBarAppearanceEnabled;//
@end

//控制器的分类：实现的功能： 添加pop手势
@interface UIViewController(QSYNavControllerPopGesture)
@property (nonatomic, assign) IBInspectable BOOL qsyInteractivePanGesturePopDisabled;// 是否允许手势的执行pool
//qsyInteractivePopDisabled
@property (nonatomic, assign) IBInspectable BOOL qsyPrefersNavigationBarHidden;// 是否隐藏导航条
@property (nonatomic, assign) IBInspectable CGFloat qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge;//最大允许的pop的距离（距离左侧边距的最大响应手势的距离）

@end