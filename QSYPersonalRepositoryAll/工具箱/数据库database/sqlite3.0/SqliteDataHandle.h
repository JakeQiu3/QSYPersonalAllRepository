//
//  SqliteDataHandle.h
//  Sqlite3.0数据库工具
//
//  Created by qsy on 15/7/13.
//  Copyright (c) 2015年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"

/**类名User和其属性(字段)*/
@class User;
@interface SqliteDataHandle : NSObject

//声明一个创建单例的方法；
+ (SqliteDataHandle *)sharedSqliteDataHandle;

//声明一个打开数据库的方法
- (void)openSqlite;

//声明关闭数据库的方法
- (void)closeSqlite;

//声明插入用户信息的方法
- (void)insertUserData:(User *)user;

//声明查询所有用户信息的方法
- (NSArray *)selectAllUser;

//声明删除用户信息的方法；按照电话号码进行删除
- (void)deleteUserWithPhone:(NSString *)phone;

//声明一个修改用户信息的方法；按照名字进行修改
- (void)updateUserWithNewName:(NSString *)newName oldName:(NSString *)oldName;


@end
