
//
//  NavBarViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/23.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "NavBarViewController.h"
#import "UINavigationBar+Awesome.h"
#define NAVBAR_CHANGE_POINT 50
@interface NavBarViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma  mark 核心代码1
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, (offsetY-NAVBAR_CHANGE_POINT)/64);
        [self.navigationController.navigationBar lbj_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lbj_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lbj_reset];
}

#pragma  mark 核心代码2
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > 0) {
//        if (offsetY >= 44) {
//            [self setNavigationBarTransformProgress:1];
//        } else {
//            [self setNavigationBarTransformProgress:(offsetY / 44)];
//        }
//    } else {
//        [self setNavigationBarTransformProgress:0];
//        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
//    }
//}
//
//- (void)setNavigationBarTransformProgress:(CGFloat)progress
//{
//    
//    [self.navigationController.navigationBar lbj_setTranslationY:(-44 * progress)];
//    [self.navigationController.navigationBar lbj_setTranslationY:(1-progress)];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lbj_reset];
//}

@end
