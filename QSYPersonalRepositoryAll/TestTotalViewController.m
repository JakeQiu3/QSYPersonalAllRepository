//
//  ViewController.m
//  Model
//
//  Created by qsyMac on 16/1/22.
//  Copyright © 2016年 QSY. All rights reserved.

#import "TestTotalViewController.h"
#import "UINavigationController+QSYNavControllerPopGesture.h"
@interface TestTotalViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_fileNameArray;
    NSMutableArray *_titileArray;
}

@end

@implementation TestTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
    // 若未添加nav 的category，则默认是系统自带的手势滑动
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //    添加自己nav 的category封装的手势
    [self setQsyInteractivePanGesturePopDisabled:NO];
    [self setQsyInteractivePopMaxAllowedInitialDistanceToLeftEdge:80];
    [self setQsyPrefersNavigationBarHidden:NO];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadData {
    _fileNameArray = @[@"52个高效编码OC的方法",@"知识点 IOS（高级版）",@"某对象连续创建和子视图frame大于父视图问题",@"内存管理",@"多线程 大全",@"iOS的设计模式 MVC介绍",@"iOS的设计模式 MVVM介绍（ReactiveCocoa版见压缩包）",@"iOS的设计模式 MVVM介绍（非ReactiveCocoa版本）",@"drawRect&layoutSubviews方法比较",@"AutoLayout:xib和storyboard使用",@"字典转模型"].mutableCopy;
       _titileArray = @[@"FiftiesEffectiveCodeViewController",@"HighLevelViewController",@"BtnNewAgainViewController",@"MemoryManagerViewController",@"GCDViewController",@"MVCStatusViewController",@"",@"TableViewController",@"Draw_LayoutSubViewsViewController",@"AutoLayoutViewController",@"DicTransferModelViewController"].mutableCopy;
}

- (void)setUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    _tableView.rowHeight = 50;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *qsyIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:qsyIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qsyIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@" %@:  %@",@"邱少一",_fileNameArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls;
    //    不同类型(特指出结构体类型)和字符串之间转换
    cls = NSClassFromString(_titileArray[indexPath.row]);
    UIViewController *viewC = [[cls alloc] init];
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
