//
//  CacultorFunctionProgram.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CacultorFunctionProgram.h"

@implementation CacultorFunctionProgram
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (CacultorFunctionProgram *)caculator:(NSInteger (^)(NSInteger ))caculator {
    caculator = ^ NSInteger (NSInteger value){
        _result = value;
        return _result;
    };
    return self;

}
- (CacultorFunctionProgram *)equal:(BOOL (^)(NSInteger ))operation {
    operation = ^BOOL(NSInteger value){
        value =  _result;
        return value== _result;
    };
    return self;
}

@end
