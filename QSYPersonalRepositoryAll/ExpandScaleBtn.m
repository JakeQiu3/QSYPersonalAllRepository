//
//  ExpandBtnScale.m
//  Test
//
//  Created by 邱少依 on 16/9/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ExpandScaleBtn.h"

@implementation ExpandScaleBtn

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    上移90
    CGFloat widthDelta = 90 - bounds.size.width;
    CGFloat heightDelta = 90 - bounds.size.height;
    // 注意这里是负数，扩大了之前的bounds的范围
    bounds =CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
