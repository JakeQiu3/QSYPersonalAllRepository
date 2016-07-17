//
//  ThirdViewController.m
//  XibEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    // Do any additional setup after loading the view.
}

- (void)setNav {
    self.title = NSStringFromClass([self class]);
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"navigation_back_green.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"navigation_back_green.png"] forState:UIControlStateHighlighted];
    _backButton.frame = CGRectMake(0, 0, 30, 30);
    _backButton.showsTouchWhenHighlighted = 1;
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backAction:(UIButton *)btn {
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
