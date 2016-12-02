//
//  ImageBtn.h
//
//
//  Created by 邱少依 on 16/7/14.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBtn : UIButton

@property(nonatomic, retain) UIImageView *imageV;
@property(nonatomic, retain) UILabel *qsytitle;
@property (nonatomic, assign) CGFloat margin;//图片和文字的间隔
//初始化imgBtn
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image imageWH:(CGFloat)imgWH margin:(CGFloat)margin;
// 若更改title 和图片时,重新布局
- (void)resetdata:(NSString *)title :(UIImage *)Image imageWH:(CGFloat)imgWH margin:(CGFloat)margin;

@end
