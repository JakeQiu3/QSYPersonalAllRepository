//
//  TapAExitOtherViewController.m
//  QSYPersonalPackageAll
//
//  Created by qsyMac on 16/4/13.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TapAExitOtherViewController.h"

@interface TapAExitOtherViewController ()
{
    UIView *a;
}
@end

@implementation TapAExitOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor magentaColor];
    [btn addTarget: self action:@selector(creataView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)creataView {
    //    创建a视图
    a = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 250, 250)];
    a.backgroundColor = [UIColor greenColor];
    [self.view addSubview:a];
    //    添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenOtherView:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
- (void)hiddenOtherView:(UITapGestureRecognizer *)sender {
    //    获取点击的位置
    CGPoint tapPoint = [sender locationInView:nil];
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (![a pointInside:[a convertPoint:tapPoint fromView:self.view] withEvent:nil]) {//点击手势的点不在a视图上
            [a removeFromSuperview];
        } else {//点击的是在a视图上
//            a.backgroundColor = [UIColor redColor];
        }
    }
    
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
