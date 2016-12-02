//
//  NSObject+Swizzle.m
//  Test
//
//  Created by 邱少依 on 16/9/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "NSObject+Swizzle.h"
@implementation NSObject (Swizzle)
// category里重写 现有方法 会有警告,并不提倡，所以得用新方法替换掉. 替换的逻辑：SEL 和 Method 的交叉互换
+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)newSel {
    Method originalMehtod = class_getInstanceMethod(self, origSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    BOOL didAddMethod = class_addMethod(self, origSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));// 将SEL origSel 的实现，替换成新的method
    if (originalMehtod && newMethod) {
        if (didAddMethod) {
            class_replaceMethod(self, newSel, method_getImplementation(originalMehtod), method_getTypeEncoding(originalMehtod));//将 newSel的实现，替换成旧的method
        } else {
            method_exchangeImplementations(originalMehtod, newMethod);
        }
        return YES;
    }
    return NO;
}

@end
