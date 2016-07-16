//
//  NSObject+runAtDeallocBlock.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/15.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "NSObject+RunAtDeallocBlock.h"
@implementation NSObject (RunAtDeallocBlock)

- (void)qsy_runAtDealloc:(VoidBlock )block {
    if (block) {
        NewExecutorBlock *executor = [[NewExecutorBlock alloc] initWithBlock:block];
        objc_setAssociatedObject(self, (__bridge const void *)(runAtDeallocBlockKey), executor, OBJC_ASSOCIATION_RETAIN);
    }
}


@end
