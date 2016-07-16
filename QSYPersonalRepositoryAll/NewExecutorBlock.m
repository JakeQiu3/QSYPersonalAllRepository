
//
//  NewBlock.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/24.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "NewExecutorBlock.h"

@implementation NewExecutorBlock

- (instancetype)initWithBlock:(VoidBlock )aBblock {
    self = [super init];
    if (self) {
        _block = [aBblock copy];
    }
    return self;
}

- (void)dealloc {
    
    if (_block) {
        _block();//核心代码，执行到此开始执行block 的代码块
        _block = nil;
    }
}

@end
