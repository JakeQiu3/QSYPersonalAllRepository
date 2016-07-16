//
//  GetCopy.h
//  QSYTest
//  
//  Created by 邱少依 on 16/5/19.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCopy : NSObject <NSCopying, NSMutableCopying>

// 问题5： 如何让自己的类用 copy 或 mutableCopy 修饰符？
// 分析：该类含有2个属性，1个变量：字符串name，整型 age ，和可变数组 friends

//1. 需声明该类遵从 NSCopying 或者 NSMutableCopying协议
//2. 实现 NSCopying 协议。该协议只有一个方法: - (id)copyWithZone:(NSZone *)zone;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger )age;
+ (instancetype)initWithName:(NSString *)name age:(NSUInteger )age;

- (void)addFriend:(UserCopy *)user;
- (void)removeFriend:(UserCopy *)user;

@end
