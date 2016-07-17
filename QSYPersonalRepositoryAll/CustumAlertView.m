//
//  CustumAlertView.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CustumAlertView.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
static CGFloat const animateDurations = 0.25;
//===============UIView 的分类，实现属性修改frame===============
@interface UIView (QSYExtention)
//分类里的方法是默认实现的. 分类是对原有类的扩展.但不能声明实例变量
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat CenterX;
@property (nonatomic, assign)CGFloat CenterY;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGPoint origin;

@end
@implementation UIView (QSYExtention)
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)CenterX{
    CGPoint center = self.center;
    center.x = CenterX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)CenterY{
    CGPoint center = self.center;
    center.y = CenterY;
    self.center = center;
}

- (CGFloat)CenterX{
    return self.center.x;
}

- (CGFloat)CenterY{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame =frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height= height;
    self.frame =frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return  self.frame.origin;
}

@end

// ================ 遮罩层 ===============
@interface UIBlackOverLayers : UIView
@property (nonatomic, weak) CustumAlertView *alert;

@end

@implementation UIBlackOverLayers

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_alert dismiss];
}

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //梯度颜色
    UIColor *innerColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    UIColor *outerColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //
    NSArray *gradientColors = @[(id)innerColor.CGColor, (id)outerColor.CGColor];
    CGFloat gradientLocations[] = {0, 0.5, 1};
    CGGradientRef radientRef = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:rect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    
    CGContextDrawRadialGradient(context, radientRef, CGPointMake(CGRectGetMaxX(rect) * 0.5, CGRectGetMaxY(rect) * 0.5), rect.size.width/4, CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2), rect.size.width, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    CGGradientRelease(radientRef);
    CGColorSpaceRelease(colorSpace);
}

@end
// ==================本身实现==============
@interface CustumAlertView ()
@property (nonatomic, strong) UIBlackOverLayers *overLayer;

@end

@implementation CustumAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void)setup:(CGRect )frame {
    self.frame = CGRectMake(0, 0, SCREENWIDTH - 80 , 280);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
//   设置标题label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 35)];
    _titleLabel.font = [UIFont systemFontOfSize:16.5f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = 1;
    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    [self addSubview:_titleLabel];
//   设置显示textview
    _contentLabel= [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), self.bounds.size.width - 20, 200)];
   _contentLabel.font = [UIFont systemFontOfSize:14.f];
    _contentLabel.editable = NO;
    _contentLabel.contentSize = _contentLabel.frame.size;
    [self addSubview:_contentLabel];
//    确认button
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.5f];
    _confirmBtn.frame = CGRectMake((self.bounds.size.width -50)*0.5,CGRectGetMaxY(_contentLabel.frame), 50, 35);
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confrimBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmBtn];
}

// 确认按钮的方法
- (void)confrimBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(confirmAlert:withConfirmBtn:)]) {
        [_delegate confirmAlert:self withConfirmBtn:btn];
    }
}

#pragma mark -- AnimatedMethods
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0;
    
    [UIView animateWithDuration:animateDurations animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:animateDurations animations:^{
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self.overLayer removeFromSuperview];
            self.overLayer = nil;
            _window = nil;
            [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
        }
    }];
}

#pragma mark -- public
- (void)show
{
    [self animatedIn];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.windowLevel = UIWindowLevelStatusBar + 1;
    window.opaque = NO;
    _window = window;
    
    _overLayer = [UIBlackOverLayers new];
    _overLayer.opaque = NO;
    _overLayer.alert = self;
    _overLayer.frame = _window.bounds;
    _overLayer.alpha = 0.0f;
    [_window addSubview:_overLayer];
    [_window addSubview:self];
// 控件frame：位置
    self.center = CGPointMake(_window.bounds.size.width/2.0, _window.bounds.size.height / 2.0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_window makeKeyAndVisible];
        // fade in overlayer
        [UIView animateWithDuration:.15
                              delay:0
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             self.overLayer.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             
                         }];
    });
}

- (void)dismiss
{
    [self animatedOut];
}

@end
