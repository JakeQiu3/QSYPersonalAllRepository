//
//  FmdbObject.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FmdbHandleObject.h"
#import "FMDatabase.h"

#define KDatabasePath @"/QSYDocument.db"

@interface FmdbHandleObject ()
{
    FMDatabase *db;
}
@end
@implementation FmdbHandleObject

//创建单例类方法
+ (FmdbHandleObject *)sharedFmdbDataHandle {
    static FmdbHandleObject *fmdbShare = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbShare = [[FmdbHandleObject alloc]init];
    });
    return fmdbShare;
}

//声明一个打开数据库的方法
- (void)openDatabase {
    //  获取拼接数据库地址
    NSArray *fileArray =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *fileDoc = [fileArray lastObject];
    NSString *dbFilePath = [fileDoc stringByAppendingPathComponent:KDatabasePath];
NSLog(@"数据库文件路径 %@",dbFilePath);
    //  创建数据库
    db = [FMDatabase databaseWithPath:dbFilePath];
    //  创建一个User表
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS User (user_id integer PRIMARY KEY AUTOINCREMENT,user_name text NOT NULL,user_address text NOT NULL,user_phone text NOT NULL,user_password text NOT NULL)"];
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    }
}

- (void)insertUserData:(User *)user {
   
    if ([db open]) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO User(user_id,user_name, user_password, user_phone, user_address) values ('%ld','%@', '%@', '%@', '%@');",(long)[user.userId integerValue], user.name, user.password, user.phone, user.address];
        BOOL result = [db executeStatements:insertSQL];
            if (result) {
                NSLog(@"插入新数据成功");
            } else {
                NSLog(@"插入新数据失败");
        }
    }
}
    
- (void)closeDatabase {
    [db close];
}

- (NSArray *)selectAllUserName {
    if ([db open]) {
        FMResultSet *resultSet =[db executeQuery:@"SELECT *FROM User;"];
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"user_name"];
            [nameArray addObject:name];
        }
        return nameArray;
   }
    return nil;
}
 
- (void)deleteUserWithName:(NSString *)name {
    if ([db open]) {
         NSString *deleteSQL = [NSString stringWithFormat:@"delete from user where user_name = '%@'", name];
        BOOL result = [db executeUpdate:deleteSQL];
        if (result) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }
}

- (void)updateUserWithNewName:(NSString *)newName oldName:(NSString *)oldName {
    
    if ([db open]) {
        NSString *modifyStr = [NSString stringWithFormat:@"update User set user_name = '%@' where user_name = '%@';",newName,oldName];
        BOOL result = [db executeUpdate:modifyStr];
        if (result) {
            NSLog(@"修改名字成功");
        } else {
            NSLog(@"修改名字失败");
        }
    }

}

@end
