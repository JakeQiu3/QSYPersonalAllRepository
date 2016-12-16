//
//  UIView+LBFrame.h
//
//
//  Created by qsy on 14-10-7.
//  Copyright (c) 2014年 qsy. All rights reserved.
//

/**
 *  类注释：快速获取坐标点，方便设置frame（UIView扩展类）
 */
#import <UIKit/UIKit.h>

@interface UIView (LBFrame)

/**
 *  x点
 */
@property (nonatomic, assign) CGFloat x;

/**
 *  y点
 */
@property (nonatomic, assign) CGFloat y;

/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  大小(width,height)
 */
@property (nonatomic, assign) CGSize size;

/**
 *  坐标点(x,y)
 */
@property (nonatomic, assign) CGPoint origin;

/**
 *  x坐标中点
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 *  y坐标中点
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 *  x+width
 */
@property (nonatomic, assign) CGFloat RBX;

/**
 *  y+height
 */
@property (nonatomic, assign) CGFloat RBY;

@end
