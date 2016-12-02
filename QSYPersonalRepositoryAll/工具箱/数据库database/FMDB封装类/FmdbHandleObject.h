//
//  FmdbObject.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/7.
//  Copyright © 2016年 QSY. All rights reserved.
#warning 少   FMDB常用类
//  FMDatabase ： 一个单1的SQLite数据库，用于执行SQL语句。
//  FMResultSet ：执行查询一个FMDatabase结果集，这个和android的Cursor类似。
//  FMDatabaseQueue ：在多个线程来执行查询和更新时会使用这个类。

#import <Foundation/Foundation.h>
#import "User.h"

@interface FmdbHandleObject : NSObject
//声明一个创建单例的方法
+ (FmdbHandleObject *)sharedFmdbDataHandle;

//声明一个打开数据库的方法
- (void)openDatabase;

//声明关闭数据库的方法
- (void)closeDatabase;

//声明插入用户信息的方法
- (void)insertUserData:(User *)user;

//声明查询用户名字信息的方法
- (NSArray *)selectAllUserName;

//声明删除用户信息的方法；按照电话号码进行删除
- (void)deleteUserWithName:(NSString *)name;

//声明一个修改用户信息的方法；按照名字进行修改
- (void)updateUserWithNewName:(NSString *)newName oldName:(NSString *)oldName;
@end
