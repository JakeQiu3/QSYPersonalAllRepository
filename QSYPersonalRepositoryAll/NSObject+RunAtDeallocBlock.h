//
//  NSObject+runAtDeallocBlock.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/15.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NewExecutorBlock.h"
static NSString  const * runAtDeallocBlockKey = @"runAtDeallocBlockKey";
@interface NSObject (RunAtDeallocBlock)
// 给NSObject NewExecutor 的dealloc执行
- (void)qsy_runAtDealloc:(VoidBlock)block;

@end
