//
//  UIImage+LBExtension.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "UIImage+LBExtension.h"

#define PI 3.14159265358979323846
@implementation UIImage (LBExtension)

+ (UIImage *)lb_imageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)lb_imageFromView:(UIView *)theView{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)lb_imageResizable:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    //自适应：宽度百分之50，高度百分之50
    image =  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return image;
}

+ (UIImage *)lb_imageFromBundleImageNamed:(NSString *)imgName{
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *imageName = [NSString stringWithFormat:@"%@%@",imgName,@".png"];
    if ([imgName hasSuffix:@".jpg"]) imageName = imgName;
    else if ([imgName hasSuffix:@".png"]) imageName = imgName;
    NSString *imageFilePath = [mainBundlePath stringByAppendingString:[NSString stringWithFormat:@"/LBResource.bundle/%@",imageName]];
    return [UIImage imageWithContentsOfFile:imageFilePath];
}

+ (UIImage *)lb_imageFromCustomBundleImageNamed:(NSString *)name bundleName:(NSString *)bundleName {
    NSString * mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString * str = nil;
    if ([UIScreen mainScreen].scale == 3 && [UIScreen mainScreen].bounds.size.width == 414) str = @"@3x";
    else if ([UIScreen mainScreen].scale == 1) str = @"@2x";
    else str = @"@2x";
    NSArray * arr = [name componentsSeparatedByString:@"."];
    NSString *imageFilePath = [mainBundlePath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@%@.%@",bundleName,[arr objectAtIndex:0],str,[arr objectAtIndex:1]]];
    return [UIImage imageWithContentsOfFile:imageFilePath];
}

+(UIImage *)lb_imageDashLine:(CGSize)size color:(UIColor *)dashColor{
    UIGraphicsBeginImageContext(size);   //开始画线
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[] = {4,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, dashColor.CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0,0.0);    //开始画线
    CGContextAddLineToPoint(line,size.width,0);
    CGContextStrokePath(line);
    
    UIImage *dashLineImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return dashLineImage;
}

+(UIImage *)lb_imageOutRing:(CGFloat)diameter color:(UIColor *)color width:(CGFloat)width{
    return [self lb_imageInterOutRing:diameter ringColor:color innerColor:[UIColor clearColor] width:width];
}

+(UIImage *)lb_imageInterOutRing:(CGFloat)diameter ringColor:(UIColor *)color innerColor:(UIColor *)innerColor width:(CGFloat)width{
    CGFloat innerDiameter=diameter-width;
    // 创建一个bitmap的context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画内部圆
    //填充圆，无边框
    CGContextSetFillColorWithColor(context, innerColor.CGColor);//填充颜色
    CGContextAddArc(context,diameter/2.0, diameter/2.0, innerDiameter/2.0, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    //边框圆
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, diameter/2.0, diameter/2.0, innerDiameter/2.0, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *ringImage=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return ringImage;
}

- (UIImage *)lb_imageCorner:(CGFloat)cornerRadius imageSize:(CGSize)imageSize{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    [self drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
