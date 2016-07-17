//
//  LoginNextViewController.m
//  storyBoardEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "LoginNextViewController.h"

@interface LoginNextViewController ()

@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"数据字典：%@，账号：%@ 密码：%@",_logNameAndPasswordDic,[_logNameAndPasswordDic objectForKey:@"loginName"],[_logNameAndPasswordDic objectForKey:@"password"]);
    // Do any additional setup after loading the view.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
