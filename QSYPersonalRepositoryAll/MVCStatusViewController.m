//
//  StatusViewController.m
//  tableview使用大全
//
//  Created by 邱少依 on 15/12/25.
//  Copyright © 2015年 QSY. All rights reserved.
//

#import "MVCStatusViewController.h"
#import "StatusTableViewCell.h"
#import "WeiboStatus.h"
//总流程：原始数据（字典数组),转为模型（model）,view层拥有model ，重写model的setter方法，设置view。 controller 层拥有model对象的数据源数组，还负责view，以及更新数据源。

static NSString *const cellIndenfiner = @"statusCellIndenfiner";
@interface MVCStatusViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;//数据源
    NSMutableArray *_statusCellsArray; //存储cell，用于计算高度
}

@end

@implementation MVCStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _dataArray = @[].mutableCopy;
    _statusCellsArray = @[].mutableCopy;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"StatusInfo" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        WeiboStatus *statusModel = [WeiboStatus initWithDic:obj];
        [_dataArray addObject:statusModel];
        //       把cell放进数组中。
        StatusTableViewCell *statusCell = [[StatusTableViewCell alloc] init];
        [_statusCellsArray addObject:statusCell];
        
    }];
    
}

- (void)setUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    注册cell
    [_tableView registerClass:[StatusTableViewCell class] forCellReuseIdentifier:cellIndenfiner];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfiner forIndexPath:indexPath];
    cell.weiboStatus = _dataArray[indexPath.row];
    return cell;
}

#pragma  mark delegate
// Cell内部设置多高都没有用，需要重新设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    获取cell数组中的cell
    StatusTableViewCell *statusCell = _statusCellsArray[indexPath.row];
    //   给cell的模型赋值
    statusCell.weiboStatus = _dataArray[indexPath.row];
    return statusCell.height;
}
//预估行高
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark 重写状态样式方法
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
