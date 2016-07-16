//
//  UINavigationController+QSYNavControllerPopGesture.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/1.
//  Copyright © 2016年 QSY. All rights reserved.
//
#pragma mark 1
/**
 *  runtime setter 方法
 *
 *  @param self                                                 要绑定到的对象
 *  @param key                                                 方法或者常量字符串地址
 *  @param value
 属性名 （若是基本数据类型，需强转）
 * @param objc_AssociationPolicy
 属性修饰
 */
#pragma mark 2
// delegate 可以做文章：delegate 本身可以单抽出一个类来拆分，同时在该类中实现某些协议方法。

#import "UINavigationController+QSYNavControllerPopGesture.h"
#import <objc/runtime.h>
#pragma mark 声明实现代理类：类1
@interface QsyFullScreenPopGestureRecognizerDelegate:NSObject<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation QsyFullScreenPopGestureRecognizerDelegate
// 1.手势开始的方法: 排除一切不符合pop手势的操作
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.qsyInteractivePanGesturePopDisabled) {        return NO;
    }
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance>0 && beginningLocation.x>maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore panGesture when the navigation controller is currently in transition.
    // get the ivarList of self.navigationController.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler  when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return YES;
}

@end

#pragma mark UIViewController 的分类的声明和实现：PopGesturePrivate：：类2
typedef void (^QsyViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (QsyFullScreenPopGesturePrivate)

@property (nonatomic, copy)QsyViewControllerWillAppearInjectBlock qsyWillAppearInjectBlock;
@end
//2. 加载UIViewController，用runtime重写 viewWillAppear： 方法
//1. 调用所有的Framework中的初始化方法\
2. 调用所有的+load方法\
3. 调用C++的静态初始化方及C/C++中的__attribute__(constructor)函数\
4.调用所有链接到目标文件的framework中的初始化方法\
故早于rootviewcontroller 执行。

@implementation UIViewController (QsyFullScreenPopGesturePrivate)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      Class cls = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swappedSelector = @selector(qsyViewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swappedMethod = class_getInstanceMethod(cls, swappedSelector);
        
        BOOL success = class_addMethod(cls, originalSelector, method_getImplementation(swappedMethod), method_getTypeEncoding(swappedMethod));
        if (success) {
            class_replaceMethod(cls, swappedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swappedMethod);
        }
    });
////    或者直接方法2
//    Class cls = [self class];
//    SEL originalSelector = @selector(viewWillAppear:);
//    SEL swappedSelector = @selector(qsyViewWillAppear:);
//    
//    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
//    Method swappedMethod = class_getInstanceMethod(cls, swappedSelector);
//      method_exchangeImplementations(originalMethod, swappedMethod);// 将1方法的实现转换成实现方法2
}

- (void)qsyViewWillAppear:(BOOL )animated {
    // Forward to primary implementation.
    [self qsyViewWillAppear:animated];
    
    if (self.qsyWillAppearInjectBlock) {
        self.qsyWillAppearInjectBlock(self,animated);
    }

}
// qsyWillAppearInjectBlock的getter 和 setter方法
- (QsyViewControllerWillAppearInjectBlock )qsyWillAppearInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setQsyWillAppearInjectBlock:(QsyViewControllerWillAppearInjectBlock)qsyWillAppearInjectBlock {
    SEL selector = @selector(qsyWillAppearInjectBlock);
    objc_setAssociatedObject(self, selector, qsyWillAppearInjectBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark UINavigationController 的分类的实现:QSYNavControllerPopGesture：类3
//3. 用runtime重写 pushViewController:animated: 方法
@implementation UINavigationController (QSYNavControllerPopGesture)
//1. 调用所有的Framework中的初始化方法\
2. 调用所有的+load方法\
3. 调用C++的静态初始化方及C/C++中的__attribute__(constructor)函数\
4.调用所有链接到目标文件的framework中的初始化方法\
故早于rootviewcontroller 执行。
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        SEL originSelector = @selector(pushViewController:animated:);
        SEL swappedSelector = @selector(qsyPushViewController:animated:);
        
        Method originMethod = class_getInstanceMethod(cls, originSelector);
        Method swappedMethod = class_getInstanceMethod(cls, swappedSelector);
        
        BOOL success = class_addMethod(cls, originSelector, method_getImplementation(swappedMethod), method_getTypeEncoding(swappedMethod));
        if (success) {
            class_replaceMethod(cls, swappedSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swappedMethod);
        }
    });
    
////   绑定替换push方法
//    Method originMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
//    Method swappedMethod = class_getInstanceMethod(self, @selector(qsyPushViewController:animated:));
//    method_exchangeImplementations(originMethod, swappedMethod);
////   绑定替换pop方法
//    Method originPopMethod = class_getInstanceMethod(self, @selector(popViewControllerAnimated:));
//    Method swappedPopMethod = class_getInstanceMethod(self, @selector(qsyPopViewControllerAnimated:));
//    method_exchangeImplementations(originPopMethod, swappedPopMethod);
}

- (void)qsyPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 获取 导航控制器活跃的手势对应的view，该view获取所有的手势 ，判断是否包含该_qsyPopGestureRecognizer手势
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.qsyPopGestureRecognizer]) {
        // Disable the onboard gesture recognizer
        self.interactivePopGestureRecognizer.enabled = NO;
        // Add our own gesture recognizer to where the onboard screen edge panGesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.qsyPopGestureRecognizer];
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        //   gesture和对应的view 本身数据持久化是dic
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];//获取活跃手势 targets对应的values（各种view）
        
        id internalTarget = [[internalTargets firstObject] valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.qsyPopGestureRecognizer.delegate = self.qsyPopGestureRecognizerDelegate;
        [self.qsyPopGestureRecognizer addTarget:internalTarget action:internalAction];
    }
    // Handle perferred navigation bar appearance.
    [self qsySetupViewControllerNavigationBarAppearanceIfNeeded:viewController];
    //转发执行该push方法： Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
         [self qsyPushViewController:viewController animated:animated];
    }
}

//- (void)qsyPopViewControllerAnimated:(BOOL )animated {
//   //    执行pop操作
//    [self qsyPopViewControllerAnimated:animated];
//    
//}

- (void)qsySetupViewControllerNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController {
    //  导航条不出现
    if (!self.qsyViewControllerNavigationBarAppearanceEnabled) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    QsyViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController,BOOL animated){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.qsyPrefersNavigationBarHidden animated:animated];
        }
    };
    appearingViewController.qsyWillAppearInjectBlock = block;
    
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.qsyWillAppearInjectBlock) {
        disappearingViewController.qsyWillAppearInjectBlock = block;
    }
}

//qsyPopGestureRecognizerDelegate  getter 方法
- (QsyFullScreenPopGestureRecognizerDelegate *)qsyPopGestureRecognizerDelegate {
    QsyFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[QsyFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return delegate;
}
//qsyPopGestureRecognizer  getter 方法
- (UIPanGestureRecognizer *)qsyPopGestureRecognizer {
    //  self 和 _cmd 把方法名作为identifier的key在self取出该属性变量。
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}
//qsyViewControllerBasedNavigationBarAppearanceEnabled  getter 和setter 方法
- (BOOL )qsyViewControllerNavigationBarAppearanceEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.qsyViewControllerNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setQsyViewControllerNavigationBarAppearanceEnabled:(BOOL)qsyViewControllerNavigationBarAppearanceEnabled{
    SEL key = @selector(qsyViewControllerNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(qsyViewControllerNavigationBarAppearanceEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

#pragma mark -- UIViewController(QSYNavControllerPopGesture)的分类
@implementation UIViewController (QSYNavControllerPopGesture)
//qsyInteractivePanGesturePopDisabled  getter 和setter 方法
- (BOOL)qsyInteractivePanGesturePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setQsyInteractivePanGesturePopDisabled:(BOOL)qsyInteractivePanGesturePopDisabled {
    objc_setAssociatedObject(self, @selector(qsyInteractivePanGesturePopDisabled), @(qsyInteractivePanGesturePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//qsyPrefersNavigationBarHidden  getter 和setter 方法
- (BOOL)qsyPrefersNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setQsyPrefersNavigationBarHidden:(BOOL)qsyPrefersNavigationBarHidden {
    objc_setAssociatedObject(self, @selector(qsyPrefersNavigationBarHidden), @(qsyPrefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge  getter 和setter 方法
- (CGFloat )qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge {
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setQsyInteractivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge {
    objc_setAssociatedObject(self, @selector(qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge),@(MAX(0, qsyInteractivePopMaxAllowedInitialDistanceToLeftEdge)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
