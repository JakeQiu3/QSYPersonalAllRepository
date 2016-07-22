//
//  ThirdViewController.m
//  XibEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ThirdViewController.h"


#warning 少 给scrollView内部的子控件添加约束：
//两个原则：1、scrollView内部子控件的尺寸不能以scrollView的尺寸为参照
//        2、scrollView内部的子控件的约束必须完整: 也就是说-> 子控件在水平及竖直方向上的约束要把scrollView"撑满"：-> 子控件的宽高和位置都定下来。

// 原因：子控件的约束决定了container scrollview的尺寸(contentSize)

//解决： 1.添加到scrollView 的子控件尺寸和位置都定死（常不用）； 2.将子控件的约束和控制器的view一致/或者直接在scrollView上添加一个view（固定高度宽度位置后），等其上子控件添加完，再去掉这个view的高度的约束，约束内容View距离底部最后一个控件View的间距
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
