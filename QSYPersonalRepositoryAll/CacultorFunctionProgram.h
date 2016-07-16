//
//  CacultorFunctionProgram.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacultorFunctionProgram : NSObject
@property (nonatomic, assign) BOOL isEqule;
@property (nonatomic, assign) NSInteger result;
// 必须有返回值（对象本身）；函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）
- (CacultorFunctionProgram *)caculator:(NSInteger (^)(NSInteger ))caculator;
- (CacultorFunctionProgram *)equal:(BOOL (^)(NSInteger ))operation;
@end
