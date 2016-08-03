//
//  MulitplePickerViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MulitplePickerViewController.h"
#import "MultiplePickerView.h"
@interface MulitplePickerViewController ()
{
    NSMutableArray *currentSelectArr;//当前现在button的内容数组
    UIButton *orderBtn;//展示显示内容的button
}
@end

@implementation MulitplePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentSelectArr = @[].mutableCopy;//必须得提前创建
    [self initBtn];
    // Do any additional setup after loading the view.
}

- (void)initBtn {
    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(30, 100 + 45, 200, 30);
    [orderBtn setTitle:@"今天20点30分" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    orderBtn.showsTouchWhenHighlighted = YES;
    [orderBtn setImage:nil forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
}

- (void)orderPickerView:(UIButton *)btn {
    [self configPickerView];
    
}

- (void)configPickerView {
    //    http://blog.csdn.net/zsk_zane/article/details/47303285
    NSArray *totalDataArray = @[@[@"今天20点",@"hahhha",@"我的世界我的世界我的世界",@"我做主"],@[@"220",@"30分",@"222",@"223"]];
    NSDictionary *tempDic = @{@"8-1":@[@[@"10:00",@"10:30"],@[@"11:00",@"11:30"],@[@"16:00",@"16:30"],@[@"20:00",@"20:30"]],@"8-2":@[@[@"20:00",@"20:30"],@[@"08:00",@"08:30"]]};
    //    NSMutableArray *monthDayArr = @[].mutableCopy;
    //    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    //        NSArray *dmArr = [key componentsSeparatedByString:@"-"];
    //        NSString *str =  [NSString stringWithFormat:@"%@月%@日",[dmArr objectAtIndex:0],[dmArr objectAtIndex:1]];
    //        [monthDayArr addObject:str];
    //    }];
    
    NSMutableArray *dataArr = @[].mutableCopy;
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *mdhDic = @{}.mutableCopy;//存放月日和时数组的字典
        NSArray *dmArr = [key componentsSeparatedByString:@"-"];
        NSString *dmstr =  [NSString stringWithFormat:@"%@月%@日",[dmArr objectAtIndex:0],[dmArr objectAtIndex:1]];
        [mdhDic setObject:dmstr forKey:@"mdStr"];//月日
        
        //        @[@"10:00",@"10:30"]=obj
        NSMutableArray *hmArr = @[].mutableCopy;
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *hmDic = @{}.mutableCopy;//存放小时和分数组的字典
            NSArray *objArr = obj;
            NSString *hour = [objArr objectAtIndex:0];
            NSArray *hmPointArr = [hour componentsSeparatedByString:@":"];
            NSString *hourStr = [NSString stringWithFormat:@"%@点",[hmPointArr objectAtIndex:0]];
            [hmDic setObject:hourStr forKey:@"hourStr"];
            
            NSMutableArray *minArr = @[].mutableCopy;//存放分钟的数组
            [objArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *hmArr = [obj componentsSeparatedByString:@":"];
                NSString *minuteStr = [NSString stringWithFormat:@"%@分",[hmArr objectAtIndex:1]];
                [minArr addObject:minuteStr];
            }];
            [hmDic setObject:minArr forKey:@"minuteArr"];
            
            [hmArr addObject:hmDic];
        }];
        
        [mdhDic setObject:hmArr forKey:@"hourArr"];//月日对应的时的数组
        [dataArr addObject:mdhDic];
}];
    
    
    
    
    //  初始化pickerView
    MultiplePickerView *selectPickerView = [[MultiplePickerView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) dataArr:totalDataArray];
    selectPickerView.bgViewH = 200;
    selectPickerView.rowHeight = 35;
    selectPickerView.title = @"天下无双";
    selectPickerView.firstShowArr =  @[@"今天20点",@"30分"];
    //设置当前显示在控件条上的内容的数组
    if (![currentSelectArr count]) {//首次若未回调确认,手动设置
        currentSelectArr = selectPickerView.firstShowArr.mutableCopy;
    }
    //   不允许动态该改变pickerView默认显示的内容
    [selectPickerView setDefaultSelectRowArr:currentSelectArr isDynamicChange:NO];
    // 允许动态改变： 获取当前显示的数据数组
    [selectPickerView setDefaultSelectRowArr:currentSelectArr isDynamicChange:YES];
    __weak __typeof(self)weakSelf = self;
    //        确认的block回调方法
    selectPickerView.confirmSelectBlock = ^(NSArray *selectArr){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        把选择的内容数组传过来，供展示使用
        currentSelectArr = selectArr.mutableCopy;
        NSMutableString *selectAllStr = @"".mutableCopy;
        for (NSString *str in currentSelectArr) {
            [selectAllStr appendString:str];
        }
        [orderBtn setTitle:selectAllStr forState:UIControlStateNormal];
    };
    //    显示该视图
    [selectPickerView showInView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
