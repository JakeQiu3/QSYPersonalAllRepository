//
//  UserDefinedLoadingViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/16.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "UserDefinedLoadingViewController.h"
#import "QSYActivityView.h"
@interface UserDefinedLoadingViewController ()
{
    QSYActivityView         * myView;
}
@end

@implementation UserDefinedLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addIndicatorView];
    // Do any additional setup after loading the view.
}

- (void)addIndicatorView {
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.frame = CGRectMake(0, 164, 100, 50);
    [testBtn setTitle:@"我就是在测测" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    testBtn.showsTouchWhenHighlighted = YES;
    [testBtn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    //    自定义的菊花
    [QSYActivityView startAnimatingInSuperView:self.view isSystem:NO];

}

- (void)testBtn:(UIButton *)btn {
    NSLog(@"点击了这个测试button");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [QSYActivityView stopAnimating];
//    [sysView stopAnimating];
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
