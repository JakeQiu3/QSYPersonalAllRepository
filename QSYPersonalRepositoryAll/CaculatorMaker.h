//
//  CaculatorMake.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject

@property (nonatomic, assign)NSInteger result;
//特点： 方法的返回值是 block, block必须有返回值（对象本身），block有参数
//加
- (CaculatorMaker *(^)(NSInteger))add;
//减
- (CaculatorMaker *(^)(NSInteger))subtract;
//乘
- (CaculatorMaker *(^)(NSInteger))multiply;
//除
- (CaculatorMaker *(^)(NSInteger))divide;
@end
