//
//  UIImage+LBExtension.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LBExtension)

/**
 *  颜色转换成图片
 */
+ (UIImage *)lb_imageWithColor:(UIColor *)color;

/**
 *  view转换成图片
 */
+(UIImage *)lb_imageFromView:(UIView *)theView;

/**
 *  图片拉伸
 */
+ (UIImage *)lb_imageResizable:(NSString *)lb_imageName;

/**
 *  从固定Bunlde中读取图片
 *
 *  @param imgName 图片名称
 *
 *  @return 图片
 */
+ (UIImage *)lb_imageFromBundleImageNamed:(NSString *)imgName;

/**
 *  UIImage类目方法 允许从Bundle中获取图片生成UIImage对象
 *
 *  @param name       图片的文件名（不含路径）
 *  @param bundleName Bundle的名称
 *
 *  @return UIImage对象
 */
+ (UIImage *)lb_imageFromCustomBundleImageNamed:(NSString *)name bundleName:(NSString *)bundleName;

/**
 *  创建虚线
 *
 *  @param size      虚线大小
 *  @param dashColor 虚线颜色
 *
 *  @return image
 */
+(UIImage *)lb_imageDashLine:(CGSize)size color:(UIColor *)dashColor;

/**
 *  圆环
 *
 *  @param diameter 圆环的直径
 *  @param color    圆环的颜色
 *  @param width    环的宽度
 *
 *  @return image
 */
+(UIImage *)lb_imageOutRing:(CGFloat)diameter color:(UIColor *)color width:(CGFloat)width;

/**
 *  内外圆环
 *
 *  @param diameter   外环的颜色
 *  @param color      外环环宽
 *  @param innerColor 内圆的颜色
 *  @param width      内环环宽
 *
 *  @return <#return value description#>
 */
+(UIImage *)lb_imageInterOutRing:(CGFloat)diameter ringColor:(UIColor *)color innerColor:(UIColor *)innerColor width:(CGFloat)width;

/**
 *  图片生产圆角图片
 *
 *  @param cornerRadius 圆角大小
 *  @param imageSize    图片大小
 *
 *  @return image
 */
- (UIImage *)lb_imageCorner:(CGFloat)cornerRadius imageSize:(CGSize)imageSize;

@end
