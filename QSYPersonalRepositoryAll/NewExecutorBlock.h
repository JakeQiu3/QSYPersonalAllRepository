//
//  NewBlock.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/24.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VoidBlock) (void);

@interface NewExecutorBlock : NSObject

//  block   <->  ^(void)aBblock

@property (nonatomic, copy) VoidBlock block;

/**
 *  初始化方法，用于：创建一个有一定特征（属性和变量）的对象。
 *
 *  @param block 该类的变量 和 属性
 *
 *  @return 该类对象
 */
- (instancetype)initWithBlock:(VoidBlock )aBblock;

@end
