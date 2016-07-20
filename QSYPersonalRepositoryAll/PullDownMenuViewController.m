//
//  PullDownMenuViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/4/25.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "PullDownMenuViewController.h"
#import "MXPullDownMenu.h"
@interface PullDownMenuViewController ()<MXPullDownMenuDelegate>

@end

@implementation PullDownMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *testArray;
    testArray = @[ @[ @"这是长字符串的测试数据,所以要足够长", @"通过实现", @"代理来对", @"下拉菜单", @"的点击做" , @"出反馈" , @"就是这样" ], @[@"使用数组", @"进行初始化"], @[@"食物", @"水果", @"面食", @"肉类", @"素食"] ];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor greenColor] itemHeight:44];
    menu.frame = CGRectMake(0, 164, menu.frame.size.width, menu.frame.size.height);
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 实现代理.
#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"第%ld -- 第%ld行", (long)column, (long)row);
}


@end
