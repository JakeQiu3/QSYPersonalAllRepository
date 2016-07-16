//
//  GetCopy.m
//  QSYTest
//
//  Created by 邱少依 on 16/5/19.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "UserCopy.h"

@interface UserCopy()
{
     NSMutableArray *_friends;
}
@end

@implementation UserCopy

// 1. name 属性的copy setter方法
// [user setName:@“我”]; 等于  user.name = @"我"; 等于 下面的方法
// 6. 如何重写带 copy 或 mutableCopy 关键字的 setter？

- (void)setName:(NSString *)name {
    _name = [name copy];
}

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age {
    self = [super init];
    if (self) {
        _name = [name copy];
        _age = age;
        _friends = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)initWithName:(NSString *)name age:(NSUInteger)age {
    UserCopy *user = [[UserCopy alloc] initWithName:name age:age];
    return user;
}

//2. 实现NSCoping协议方法：产生一个不可变，从而实现重写copy方法  浅拷贝
- (id)copyWithZone:(NSZone *)zone {
    UserCopy *user = [[[self class] allocWithZone:zone] initWithName:_name age:_age];
    user->_friends = [_friends mutableCopy];
    return user;
}

//3. 实现NSMutableCoping协议方法：产生一个可变，从而实现重写mutableCopy方法. 深拷贝
- (id)mutableCopyWithZone:(NSZone *)zone {
    UserCopy *user = [[[self class] allocWithZone:zone] initWithName:_name age:_age];
    user->_friends = [[NSMutableArray alloc] initWithArray:_friends copyItems:YES];
    return user;
}

//添加该对象到集合
- (void)addFriend:(UserCopy *)user {
    [_friends addObject:user];
}

//移除该对象到集合
- (void)removeFriend:(UserCopy *)user {
    [_friends removeObject:user];
}

//测试if需要的场景：用于逻辑判断
- (void)setAge:(NSInteger)age {
    
    if (age < 0) {
        age = 0;
    }
    if (age > 300) {
        age = 300;
    }
    _age = age;
}
@end
