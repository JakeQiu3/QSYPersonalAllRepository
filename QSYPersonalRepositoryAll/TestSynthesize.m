//
//  TestSynthesize.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/16.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TestSynthesize.h"

@implementation TestSynthesize
@synthesize title = _title;

//重写title属性的setter和getter方法：造成系统不会autoSynthesize 变量。
- (void)setTitle:(NSString *)title {
    _title = title;
}
- (NSString *)title {
    return _title;
}


- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = @"我累个擦擦";
    }
    return self;
}

@end
