//
//  ViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "DicTransferModelViewController.h"
#import "HandleDicTransferModel.h"
#import "SubDicTransferModel.h"
#import "JsonTransferModel.h"
#import "ExtensionModel.h"

@interface DicTransferModelViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;// 文件夹数组
    NSArray *_classArray;// 类名数组
    
}

@end

@implementation DicTransferModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    // Do any additional setup after loading the view.
}


//@property (nonatomic, copy, readonly) NSURL *URL;
//@property (nonatomic, assign, readonly) QSYIssueState state;
//@property (nonatomic, copy, readonly) NSDate *updatedAt;
- (void)initData {
    _classArray = [[NSArray alloc] initWithObjects:@"", nil];
    _dataArray = @[
                   @{
                       @"url":@"www.baidu.com",
                       @"state":@"0",
                       @"updatedAt":@"283682876828753", //时间戳
                       @"id":@1,
                       @"temperature":@"36.8", //温度
                       @"ansNumber":@"12",
                       @"number":@"11",
                       @"question":@"你确定这是你要的东西？",
                       @"answers":@[
                               @{@"answer" : @"是的，是它就是它1"},
                               @{@"answer" : @"不是，不是它1"}
                               ],
                       @"allQueAnswer": @{@"question":@"我就是测测什么鬼1？",@"answer":@"不知道什么鬼，所以测测啊1"}
                       },
                   @{
                       @"url":@"www.alibaba.com",
                       @"state":@"0",
                       @"updatedAt":@"626387168963593",
                       @"id":@2,
                       @"temperature":@"35.3", //温度
                       @"ansNumber":@"22",
                       @"number":@"21",
                       @"question":@"你确定这是你要的东西？",
                       @"answers":@[
                               @{@"answer" : @"是的，是它就是它2"},
                               @{@"answer" : @"不是，不是它2"}
                               ],
                       @"allQueAnswer": @{@"question":@"我就是测测什么鬼2？",@"answer":@"不知道什么鬼，所以测测啊2"}
                       },
                   @{
                       @"url":@"www.tentent.com",
                       @"state":@"1",
                       @"updatedAt":@"123456786498",
                       @"id":@3,
                       @"temperature":@"37.5", //温度
                       @"ansNumber":@"32",
                       @"number":@"31",
                       @"question":@"你确定这是你要的东西？",
                       @"answers":@[
                               @{@"answer" : @"是的，是它就是它3"},
                               @{@"answer" : @"不是，不是它3"}
                               ],
                       @"allQueAnswer": @{@"question":@"我就是测测什么鬼3？",@"answer":@"不知道什么鬼，所以测测啊3"}
                       },
                   ];
    // 手动 字典转 模型
    //    [self manualTransferModel];
    // JsonModel 转模型
    [self jsonTransferModel];
    [self extensionTransferModel];
}

- (void)extensionTransferModel {
    NSDictionary *dict = @{
                           @"name" : @"Jack",
                           @"icon" : @"lufy.png",
                           @"age" : @20,
                           @"height" : @"1.55",
                           @"money" : @100.9,
                           @"sex" : @(SexFemale),
                           @"gay" : @"true"
                           //   @"gay" : @"1"
                           //   @"gay" : @"NO"
                           };
    ExtensionModel *model = [ExtensionModel objectWithKeyValues:dict];
    NSLog(@"%@",model);
}
- (void)manualTransferModel {
    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HandleDicTransferModel *model = [HandleDicTransferModel appWithDic:obj];
        [modelArr addObject:model];
    }];
    NSLog(@"生成的模型数组：%@",modelArr);
    
    [modelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HandleDicTransferModel *model = (HandleDicTransferModel *)obj;
        SubDicTransferModel *subModel = (SubDicTransferModel *)model.allQueAnsModel;
        NSLog(@"模型内有数组：%@,模型内有模型：%@,%@",model.answers,subModel.question,subModel.answer);
    }];
}

- (void)jsonTransferModel {
    NSDictionary*dict =
    @{@"id":@"aaa",
      @"country":@"China",
      @"dialCode":@"ccc",
      @"isInEurope":@"true",
      @"test":@12,
      @"orderId": @104,
      @"totalPrice": @13.45,
      @"product": @{
              @"id": @"123",
              @"name": @"Product name",
              @"price": @"12.95"
              },
      @"numArray":@[ @{@"id":@"ttt",
                       @"name":@"China",
                       @"price":@"true"},
                     @{@"id":@"ttt",
                       @"name":@"China",
                       @"price":@"true"}]
      };
    JsonTransferModel *model = [[JsonTransferModel alloc]initWithDictionary:dict error:nil];
    NSLog(@"%@",model);
}

- (void)setUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    NSLog(@"少：self.view —> %@ \n tableview —> %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(_tableView.frame));
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%li : %@",(long)indexPath.row,_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls;
    cls = NSClassFromString(_classArray[indexPath.row]);
    UIViewController *viewC = [[cls alloc] init];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtnItem;
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
