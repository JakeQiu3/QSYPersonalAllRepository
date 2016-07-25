//
//  MutlipleTwoTabAndOneTabViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/19.
//  Copyright © 2016年 QSY. All rights reserved.
//
#import "MutlipleTwoTabAndOneTabViewController.h"
#import "QSMultiplePullDownMenu.h"
@interface MutlipleTwoTabAndOneTabViewController ()<QSPullDownMenuDelegate>
{
    QSMultiplePullDownMenu *menu;
}
@end

@implementation MutlipleTwoTabAndOneTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
#warning 少 数据格式必须符合如下形式，才能正确执行。
    //  单个的地区的数据:应该是一个整体,顾需要一次request到3组数据，并添加到大数组中
    NSArray *testArray = @[
                           @[@{ @"provinceName":@"北京",@"citys":@[@"天下无双0",@"南沙市=",@"地上无名0"]},@{@"provinceName":@"广东省",@"citys":@[@"郑州1",@"永城112333",@"广州市1111",@"永城111",@"广州市jjj",@"永城ooo",@"广州市tt",@"永城mm",@"广州市"]},@{ @"provinceName":@"南京",@"citys":@[@"岁月无意2",@"南沙市2",@"人间有情2"]},@{ @"provinceName":@"天津",@"citys":@[@"自然而为3",@"南沙市3",@"关关雎鸠3"]},@{ @"provinceName":@"上海",@"citys":@[@"在河之洲5",@"南沙市5",@"君子好逑5"]},@{@"provinceName":@"广州",@"citys":@[@"商丘市6",@"南沙市6",@"广州市6"]},@{@"provinceName":@"商丘",@"citys":@[@"商丘市7",@"南沙市7",@"广州市7"]}],
                           
                           @[ @{@"provinceName":@"台湾台湾台湾北京",@"citys":@[@"北京市8",@"南沙市8",@"广州市8"]}, @{@"provinceName":@"内科",@"citys":@[@"全部科室",@"圣经内科9",@"天津内科9"]}, @{@"provinceName":@"商丘市",@"citys":@[@"商丘市10",@"南沙市10",@"广州市10"]}],
                           
                           @[@{@"provinceName":@"所有服务",@"citys":@[]},@{@"provinceName":@"预约服务",@"citys":@[]},@{@"provinceName":@"视频服务",@"citys":@[]}] ];
    
    menu = [[QSMultiplePullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor colorWithRed:150/255.0 green:205/255.0 blue:110/255.0 alpha:1.0f] constantTitlesArr:@[@"广州市",@"全部科室",@"服务"]];
    menu.allowUpdataMenuTitle = YES;
    menu.frame = CGRectMake(0, 164,menu.bounds.size.width, menu.bounds.size.height);
    menu.delegate = self;
    [menu showInSupView:self.view];
}

#pragma _mark
- (void)pullDownMenu:(QSMultiplePullDownMenu *)pullDownMenu didSelectColumn:(NSString *)columnStr secondRow:(NSString *)rowStr {
    NSLog(@"第1tab的数据 :%@,第2个tab的数据 :%@",columnStr,rowStr);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

