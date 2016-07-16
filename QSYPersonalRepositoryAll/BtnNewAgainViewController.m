//
//  BtnNewAgainViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/9.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "BtnNewAgainViewController.h"

@interface BtnNewAgainViewController ()
{
    UIButton *btn;
}

@end

@implementation BtnNewAgainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hh1];
}

- (void)hh1 {
    //    引用计数alloc 1次（btn指向），addsubView 又 1次（self.view指向），共2
//    btn = [UIButton alloc];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 64, 200, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"1我的就是我的" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    NSLog(@"第1次创建该变量btn%p",&btn);
    
    //    测试子视图的frame 大于父视图时
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, 200, 250);
    btn3.backgroundColor = [UIColor cyanColor];
    [btn3 setTitle:@"测试frame子和父" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(tianxia) forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:btn3];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hh2];
}

- (void)hh2 {
    //   btn指向一个新分配的内存， 该新内存引用计数alloc 1次，addsubView 又 1次，共2；
    //   而之前hh1创建的button，btn指向不再指向，仅仅addsubView（self.view指向）， 共1
    //   所以2个创建的button均不被释放。但只有第二次创建的才是该控制器的btn变量。
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, 200, 100);
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"2我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
     NSLog(@"第2次创建该变量btn%p",&btn);
    
}

//btn点击方法：第二次创建的btn才会响应该btn的所有设置。
- (void)tianxia {
    self.view.backgroundColor = [UIColor greenColor];
    //    [btn removeFromSuperview];
    
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
