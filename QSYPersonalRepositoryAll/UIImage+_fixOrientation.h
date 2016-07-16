//
//  UIImage+_fixOrientation.h
//  VinuxPost
//  图片方向的修正: 如果该图片大于2M，会自动旋转90度；否则不旋转
//  像素处理或者drawInRect等操作之后，imageOrientaion信息被删除了，imageOrientaion被重设为0,照片内容和imageOrientaion
//  Created by qsy on 15/12/4.
//  Copyright © 2015年 qsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (_fixOrientation)
- (UIImage *)fixOrientation;
@end
