//
//  FmdbViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FmdbViewController.h"
#import "FmdbHandleObject.h"
@interface FmdbViewController ()

@end

@implementation FmdbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    打开数据库（若数据库表不存在，新创建）
     FmdbHandleObject *fmdbShare = [FmdbHandleObject sharedFmdbDataHandle];
    [fmdbShare openDatabase];
    
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
    
    //  插入数据
    [fmdbShare insertUserData:user1];
    [fmdbShare insertUserData:user2];
    // 查询所有用户信息
    NSArray *userArray = [fmdbShare selectAllUserName];
        NSLog(@"用户数组：%@",userArray);
    //   修改某个具体信息
    [fmdbShare updateUserWithNewName:@"邱少一" oldName:@"我就是我"];
    //   删除数据
    [fmdbShare deleteUserWithName:@"邱少一"];
    //   关闭数据库
    [fmdbShare closeDatabase];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
