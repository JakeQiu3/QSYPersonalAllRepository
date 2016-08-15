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
    [self addPullDownMenu];
}

- (void)addPullDownMenu {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"departmentCitysServices" ofType:@"plist"];
    NSArray *totalArr = [[NSArray alloc] initWithContentsOfFile:filePath];
    menu = [[QSMultiplePullDownMenu alloc] initWithArray:totalArr selectedColor:[UIColor colorWithRed:150/255.0 green:205/255.0 blue:110/255.0 alpha:1.0f] constantTitlesArr:@[@"广州",@"全部内科",@"全部服务"]];
    menu.frame = CGRectMake(0,164,menu.bounds.size.width, menu.bounds.size.height);
    menu.allowUpdataMenuTitle = YES;
    menu.indicatorColor = [UIColor blackColor];
    menu.titleAndPicMargin = 10;
    menu.delegate = self;
    [menu showInSupView:self.view];
}

#pragma _mark
- (void)pullDownMenu:(QSMultiplePullDownMenu *)pullDownMenu didSelectColumn:(NSString *)columnStr secondRow:(NSString *)rowStr selectId:(NSString *)selectId selectColumnId:(NSInteger)columnId {
    NSLog(@"第1tab的数据 :%@,第2个tab的数据 :%@,最后一个选项的Id:%@ 选择的行数columnId:%ld",columnStr,rowStr,selectId,(long)columnId);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

