//
//  MyString.m
//  Test
//
//  Created by 邱少依 on 16/9/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MyString.h"
#import "NSObject+Swizzle.h"
@implementation MyString
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = object_getClass((id)self);
        [cls swizzleMethod:@selector(resolveInstanceMethod:) withMethod:@selector(myResolveInstanceMethod:)];
    });
}

+ (BOOL)myResolveInstanceMethod:(SEL)sel {
    if (![self myResolveInstanceMethod:sel]) {// 调用原生方法的实现
        NSString *selectSting = NSStringFromSelector(sel);
        if ([selectSting isEqualToString:@"countAll"] || [selectSting isEqualToString:@"pushViewController"]) {
            class_addMethod(self, sel, class_getMethodImplementation(self, @selector(dynamicMethodIMP)), "v@:");
            return YES;
        } else {
            class_addMethod(self, sel, class_getMethodImplementation(self, @selector(noThisSel)),"v@::");
            return NO;
        }
    }
    return YES;
}

- (void)dynamicMethodIMP {
    NSLog(@"我是动态加入的函数");
}

- (void)noThisSel {
    NSLog(@"其实并没有这个方法,能不能别乱调用,小心崩溃...");
}
@end
