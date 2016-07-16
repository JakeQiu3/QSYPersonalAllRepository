//
//  SqliteDatabaseViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "SqliteDatabaseViewController.h"
#import "SqliteDataHandle.h"
#import "User.h"
@interface SqliteDatabaseViewController ()

@end

@implementation SqliteDatabaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    打开数据库（若数据库表不存在，新创建）
    SqliteDataHandle *sqliteShare = [SqliteDataHandle sharedSqliteDataHandle];
    [sqliteShare openSqlite];
    User *user1 = [[User alloc] init];
    user1.userId = @"3";
    user1.name = @"我就是我";
    user1.address = @"蒋口镇后楼村邱庄";
    user1.phone = @"18910154026";
    user1.password = @"富兰克林啊";
    User *user2 = [[User alloc] init];
    user2.userId = @"6";
    user2.name = @"你就是你";
    user2.address = @"蒋口镇后楼村邱庄";
    user2.phone = @"18910154026";
    user2.password = @"富兰克林啊";

//    插入数据
    [sqliteShare insertUserData:user1];
    [sqliteShare insertUserData:user2];
//    查询所有用户信息
    NSArray *userArray = [sqliteShare selectAllUser];
    [userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        User *queryUser = (User *)obj;
        NSLog(@"%@",queryUser.name);
    }];
    
//   修改某个具体信息
    [sqliteShare updateUserWithNewName:@"邱少一" oldName:@"我就是我"];
//    删除数据
    [sqliteShare deleteUserWithPhone:@"18910154026"];
//    关闭数据库
    [sqliteShare closeSqlite];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
