//
//  TabActionColViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TabActionColViewController.h"
#import "TabActionColView.h"
@interface TabActionColViewController ()<TabOrColDelegate>

@end

@implementation TabActionColViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"商品分类数据" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    //    若是2tab
    //        TabActionColView *tabColView = [[TabActionColView alloc] initWithFrame:self.view.bounds dataArray:dataArray rightCollectionView:NO];
    //        [tabColView showInView:self.view];
    //        tabColView.delegate = self;
    //   若是1tab和1col
    TabActionColView *tabColView = [[TabActionColView alloc] initWithFrame:self.view.bounds dataArray:dataArray rightCollectionView:YES];
    [tabColView showInView:self.view];
    tabColView.rightSelectCol.selectDelegate = self;
}

#pragma _mark  右侧item的方法
- (void)selectedCategoryName:(NSString *)categoryName
                  categoryId:(NSString *)categoryId
                 objectValue:(NSString *)objectValue
                    objectId:(NSString *)objectId {
    NSLog(@"分类名：%@ ,分类的Id：%@;商品的分类名:%@ ,商品的Id:%@ ",categoryName,categoryId,objectValue,objectId);
}

@end
