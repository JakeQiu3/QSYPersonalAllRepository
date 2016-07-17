//
//  QsyViewController.m
//  storyBoardEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "QsyViewController.h"
#import "SecViewController.h"
@interface QsyViewController ()

@end

@implementation QsyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}
#pragma mark storyboard的使用步骤：1.创建storyboard 2.添加控制器（若何类关联，需要在storyboard中的Custom class 进行设置） 3.添加segue（iphone 3种方式）

#pragma mark  在storyboard中，segue有几种不同的类型.且都是单向操作。在iphone和ipad的开发中，segue的类型是不同的。
//  iphone 中有show，present，custom（自定义）3种； popover(iPad only);Replace (iPad only). 在ipad中，有push，modal，popover，replace和custom五种不同的类型。
#pragma mark  Restoration ID 是系统进入后台或者应用被终止，app重新起来时的用于恢复时使用。storyboard ID 是某控制器在该storyboard中的identifier


// 获取storyboard的某个控制器窗体，并跳转至该窗体
- (IBAction)clickBtn:(id)sender {
    //   获取该storyboard
    UIStoryboard *secondBoard = [UIStoryboard storyboardWithName:@"Second" bundle:[NSBundle mainBundle]];
#pragma mark 方法1
    // 获取该storyboard初始化的控制器
    UIViewController *vc = [secondBoard instantiateInitialViewController];
    vc.hidesBottomBarWhenPushed = YES;//隐藏tabbar
    [self.navigationController pushViewController:vc animated:YES];
    
#pragma mark 方法2
    //    根据Storyboard ID来表，示某个控制器的identifier获取storyboard中初始的控制器
        SecViewController *secVC = [secondBoard instantiateViewControllerWithIdentifier:@"second2"];
    secVC.hidesBottomBarWhenPushed = YES;//隐藏tabbar
        [self.navigationController pushViewController:secVC animated:YES];
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
