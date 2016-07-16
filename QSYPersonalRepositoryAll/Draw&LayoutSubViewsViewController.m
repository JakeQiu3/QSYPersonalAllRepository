
//
//  Draw&LayoutSubViewsViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/31.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "Draw&LayoutSubViewsViewController.h"
#import "DrawRectView.h"
#import "LayoutSubView.h"
@interface Draw_LayoutSubViewsViewController ()
{
    DrawRectView *drawView;
    LayoutSubView *layoutSubBiew;
}
@end

@implementation Draw_LayoutSubViewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDrawRectViewUI];
    [self setlayoutSubViewUI];
}
#warning 少 测试 drawRect 方法被触发方法
//某个视图的drawRect 方法被触发方法：
// 1. 视图对应的控制器===必须走完===：viewWillAppear方法后才执行。
// 2. 在1方法之外，直接调用 setNeedsDisplay
- (void)setDrawRectViewUI {
    drawView = [[DrawRectView alloc] initWithFrame:CGRectMake(0, 64, 200, 60)];
    [self.view addSubview:drawView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //并不能调用drawRect方法，因为viewWillAppear并未走完
    [drawView setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#warning 少
    [drawView setNeedsDisplay];
    [layoutSubBiew setNeedsLayout];
    //然并卵 的下面方法
    // [drawView  sizeToFit];
    // drawView.contentMode = UIViewContentModeRedraw;
    // drawView.frame = CGRectMake(0, 164, 200, 60);
    //    layoutSubBiew.frame = CGRectMake(220, 184, 200, 60);
    //    layoutSubBiew.nameLabel.frame = CGRectMake(0, 64, 100, 100);
    
}

#warning 少 测试 layoutSubView 方法被触发方法
// 某个视图的layoutSubView 方法被触发方法：
// 1. 视图对应的控制器的：addSubview。
// 2. 直接调用 setNeedsLayout
// 3. 滚动scrollview视图
- (void)setlayoutSubViewUI {
    layoutSubBiew =  [[LayoutSubView alloc] initWithFrame:CGRectMake(100, 184, 200, 60)];
    [self.view addSubview:layoutSubBiew];
}

@end
