//
//  UINavigationBar+Awesome.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/23.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>
static char lbjKey;

@implementation UINavigationBar (Awesome)

- (UIView *)overlay {
    return objc_getAssociatedObject(self, &lbjKey);
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &lbjKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//创建一个uiview
- (void)lbj_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc]initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
         self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)lbj_setElementsAlpha:(CGFloat )alpha {
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        view.alpha = alpha;
    }];
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        view.alpha = alpha;
    }];
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
             *stop = YES;
        }
    }];
}
- (void)lbj_setTranslationY:(CGFloat)translationY {
    self.transform =CGAffineTransformMakeTranslation(0, translationY);

}
- (void)lbj_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
