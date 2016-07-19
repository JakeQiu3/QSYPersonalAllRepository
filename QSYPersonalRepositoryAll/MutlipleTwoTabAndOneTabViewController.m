//
//  MutlipleTwoTabAndOneTabViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/19.
//  Copyright © 2016年 QSY. All rights reserved.
//
#import "MutlipleTwoTabAndOneTabViewController.h"
#import "QSPullDownMenu.h"
@interface MutlipleTwoTabAndOneTabViewController ()<QSPullDownMenuDelegate>
{
    QSPullDownMenu *menu;
}
@end

@implementation MutlipleTwoTabAndOneTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //  单个的地区的数据:应该是一个整体,顾需要一次request到3组数据，并添加到大数组中
    NSArray *testArray = @[
                           @[@{ @"provinceName":@"北京",@"citys":@[@"天下无双",@"南沙市",@"地上无名"]},@{@"provinceName":@"河南",@"citys":@[@"郑州",@"商丘",@"永城",]},@{ @"provinceName":@"南京",@"citys":@[@"岁月无意",@"南沙市",@"人间有情"]},@{ @"provinceName":@"天津",@"citys":@[@"自然而为",@"南沙市",@"关关雎鸠"]},@{ @"provinceName":@"上海",@"citys":@[@"在河之洲",@"南沙市",@"君子好逑"]},@{@"provinceName":@"广州",@"citys":@[@"商丘市",@"南沙市",@"广州市"]},@{@"provinceName":@"商丘",@"citys":@[@"商丘市",@"南沙市",@"广州市"]}],
                           @[ @{@"provinceName":@"北京",@"citys":@[@"北京市",@"南沙市",@"广州市"]}, @{@"provinceName":@"河北",@"citys":@[@"山东",@"南沙市",@"广州市"]}, @{@"provinceName":@"商丘市",@"citys":@[@"商丘市",@"南沙市",@"广州市"]}],
                           @[@{@"provinceName":@"台湾",@"citys":@[]},@{@"provinceName":@"山西",@"citys":@[]}] ];
    
    menu = [[QSPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor colorWithRed:150/255.0 green:205/255.0 blue:110/255.0 alpha:1.0f] constantTitlesArr:@[@"地区",@"科室",@"服务"]];
    menu.frame = CGRectMake(0, 164,menu.bounds.size.width, menu.bounds.size.height);
    menu.delegate = self;
    [menu showInSupView:self.view];
}

#pragma _mark
- (void)pullDownMenu:(QSPullDownMenu *)pullDownMenu didSelectColumn:(NSString *)columnStr secondRow:(NSString *)rowStr {
    NSLog(@"第1tab的数据 :%@,第2个tab的数据 :%@",columnStr,rowStr);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

