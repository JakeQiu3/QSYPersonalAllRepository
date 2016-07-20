//
//  TabActionColViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TabActionColViewController.h"
#import "TabActionColView.h"
@interface TabActionColViewController ()<LeftLabRightColViewSelectDelegate>

@end

@implementation TabActionColViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"商品分类假数据" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    TabActionColView *tabColView = [[TabActionColView alloc] initWithFrame:self.view.bounds dataArray:dataArray rightCollectionView:YES];
    [tabColView showInView:self.view];
    tabColView.rightSelectCol.selectDelegate = self;
    // Do any additional setup after loading the view.
}

#pragma _mark 点击右侧item的方法
- (void)selectedCategoryName:(NSString *)categoryName categoryValue:(NSString *)categoryValue {
    NSLog(@"测测：%@ ,%@",categoryName,categoryValue);
}

@end
