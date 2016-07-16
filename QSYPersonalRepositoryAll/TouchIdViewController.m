//
//  TouchIdViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TouchIdViewController.h"
#import "TouchIdManager.h"
@interface TouchIdViewController ()

@end

@implementation TouchIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 164, 200, 30);
    [btn setTitle:@"检测使用touchId" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}

- (void)btnClick:(UIButton *)btn {
    TouchIdManager *manager = [[TouchIdManager alloc] init];
    if (![manager isSupportTouchId]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持 or 没有设置 Touch ID" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:^{
        }];
        return;
    }
    [manager touchIdReply:^(BOOL success, NSError *error) {
        if (success) {
              NSLog(@"成功");
        }  else {
            NSLog(@"%@",error.debugDescription);
            switch (error.code) {
                case LAErrorUserCancel:
                case LAErrorSystemCancel:
                case LAErrorAppCancel/*AVAILABLE iOS9.0*/:
                    NSLog(@"取消");
                    break;
                case LAErrorAuthenticationFailed:
                    NSLog(@"认证失败");
                    break;
                case LAErrorUserFallback:
                    NSLog(@"用户选择输入密码");
                    break;
                case LAErrorTouchIDLockout/*AVAILABLE iOS9.0*/:
                    NSLog(@"用户输入多次TouchID，错误需求输入密码，系统做处理");
                    break;
                default:
                    break;
            }
            
        }

    }];
   
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
