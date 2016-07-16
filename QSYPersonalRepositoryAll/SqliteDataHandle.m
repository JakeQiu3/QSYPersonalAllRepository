//
//  SqliteDataHandle.m
//  Sqlite3.0数据库
//
//  Created by qsy on 15/7/13.
//  Copyright (c) 2015年 QSY. All rights reserved.
//

#import "SqliteDataHandle.h"
static SqliteDataHandle *shareSqlite = nil;
#define KSqliteUserPath @"/qsySqlite3.sqlite"

@implementation SqliteDataHandle

+ (SqliteDataHandle *)sharedSqliteDataHandle{
      //加上线程锁，保证访问安全
    @synchronized (self){
        if (!shareSqlite) {
            shareSqlite = [[SqliteDataHandle alloc] init];
        }
        return shareSqlite;
    }
}

//声明一个数据库指针，用它来操作我们的数据库
static sqlite3 *sq = nil;
#pragma mark - 打开数据库 -
//声明一个打开数据库的方法
- (void)openSqlite{
     //1、找到sqlite的路径
    NSArray *fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [fileArray lastObject];
/**数据库名字*/
    NSString *sqlitePath = [documentPath stringByAppendingPathComponent:KSqliteUserPath];
    
    //2、创建数据表
    //打开数据库
    int openResult = sqlite3_open([sqlitePath UTF8String], &sq);
    //如果打开数据库失败，直接跳出
    if (openResult != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return;
    }
    //建表 primary key
    NSString *creatSQL = @"create table user(user_id text primary key not NULL, user_name text not NULL, user_password text not NULL, user_phone text not NULL, user_address text not NULL)";
    //运行sql语句
    char *error = nil;
    int result = sqlite3_exec(sq, [creatSQL UTF8String], NULL, NULL, &error);
    //3、判断表是否创建成功
    if (result == SQLITE_OK) {
        NSLog(@"数据表创建成功");
    } else {
        NSLog(@"数据表创建失败：%s", error);
    }
    NSLog(@"打开数据库路径：%@",documentPath);
}

#pragma mark - 关闭数据库 -
//声明关闭数据库的方法
- (void)closeSqlite{
    int result = sqlite3_close(sq);
    if (result == SQLITE_OK) {
        sq = nil;
        NSLog(@"关闭数据库");
    }
}

#pragma mark - 插入用户信息 -
//声明插入用户信息的方法
/**方法名更改*/
- (void)insertUserData:(User *)user{
    //1、插入数据的sql语句； insert into 表名(字段1,字段2...) values ('值1','值2'...)
    /**更改类的字段属性*/
    NSString *insertSQL = [NSString stringWithFormat:@"insert into user(user_id,user_name, user_password, user_phone, user_address) values ('%@','%@', '%@', '%@', '%@')",user.userId, user.name, user.password, user.phone, user.address];
    //2、执行
    char *error = nil;
    int result = sqlite3_exec(sq, [insertSQL UTF8String], nil, nil, &error);
    //3、判断
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败：%s", error);
    }

}

#pragma mark - 查询所有用户 -
//声明查询所有用户信息的方法
- (NSArray *)selectAllUser{
    //1、查询的sql的语句； 当我们按照条件去查询表中的数据时，sql语句的格式是 select *from 表名 where 字段1='值1' and 字段2='值2'；
    NSString *selectSQL = @"select * from user";
    
    //2、创建一个跟随指针
    sqlite3_stmt *stm = nil;
    
    //3、执行sql语句
    int result = sqlite3_prepare_v2(sq, [selectSQL UTF8String], -1, &stm, nil);
    
    NSMutableArray *userArray = [NSMutableArray array];
    //4、执行成功就去取值
    if (result == SQLITE_OK) {
        //通过循环去一个一个的去取值
        while (sqlite3_step(stm) == SQLITE_ROW) {
            //取值; 当我们没有自增id，数据表会给我们生成rowid字段，但是这个字段没有计算在表的字段内；
            char *name = (char *)sqlite3_column_text(stm, 0);
            char *password = (char *)sqlite3_column_text(stm, 1);
            char *phone = (char *)sqlite3_column_text(stm, 2);
            char *address = (char *)sqlite3_column_text(stm, 3);
            
            //创建user对象
            User *user = [[User alloc] init];
            user.name = [NSString stringWithUTF8String:name];
            user.password = [NSString stringWithUTF8String:password];
            user.phone = [NSString stringWithUTF8String:phone];
            user.address = [NSString stringWithUTF8String:address];
            
            [userArray addObject:user];
        }
    }else {
        NSLog(@"执行错误");
    }
    
    //释放跟随指针
    sqlite3_finalize(stm);
    return userArray;
}

#pragma mark - 删除 -
//声明删除用户信息的方法：按照电话号码进行删除
- (void)deleteUserWithPhone:(NSString *)phone{
    //1、删除的sql语句； 格式：delete from 表名 where 字段='值'
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from user where user_phone = '%@'", phone];
    //2、执行sql语句
    char *error = nil;
    int result = sqlite3_exec(sq, [deleteSQL UTF8String], nil, nil, &error);
    //3、判断执行结果
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败：%s", error);
    }
}

#pragma mark - 修改用户信息 -
//声明一个修改用户信息的方法:按照名字进行修改
- (void)updateUserWithNewName:(NSString *)newName oldName:(NSString *)oldName {
    //1、修改的sql语句， 格式是：update 表名 set 字段1='值1', 字段2='值2' where 字段=值
    NSString *updateSQL = [NSString stringWithFormat:@"update user set user_name = '%@' where user_name = '%@'",newName, oldName];
    //2、执行语句
    char *error = nil;
    int result = sqlite3_exec(sq, [updateSQL UTF8String], nil, nil, &error);
    //3、判断结果
    if (result == SQLITE_OK) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败：%s", error);
    }

}

@end
