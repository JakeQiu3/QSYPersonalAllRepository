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
    NSMutableArray *currentSelectArr;//当前现在cell上的内容数组
    NSArray *totalTimeArr;//时间数组
    NSArray *defaultTimeArr;//默认显示cell的数组
    UIButton *orderBtn;//展示显示内容的button
}
@end

@implementation MulitplePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentSelectArr = @[].mutableCopy;//必须得提前创建
    [self initBtn];
    //    http://blog.csdn.net/zsk_zane/article/details/47303285
    //去掉iOS7后tableview header的延伸高度。。适配iOS7
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //        self.extendedLayoutIncludesOpaqueBars = NO;
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
    // Do any additional setup after loading the view.
}

- (void)initBtn {
    NSDictionary *tempDic = @{@"2016-8-1":@[@[@"10:00:00",@"10:30:00"],@[@"11:00:00",@"11:30:00"],@[@"16:00:00"],@[@"20:00:00",@"20:30:00"]],@"2016-8-2":@[@[@"20:30:00"],@[@"08:30:00"]],@"2016-8-3":@[@[@"6:30:00"],@[@"6:00:00"]]};// 暂时使用假数据字典
    NSMutableArray *dataArr = @[].mutableCopy;// 存放所有数据源的数组
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@======%@",key,obj);
        NSMutableDictionary *mdhDic = @{}.mutableCopy;//存放月日和时数组的字典
        NSArray *dmArr = [key componentsSeparatedByString:@"-"];
        NSInteger dmNum = [dmArr count];
        NSString *yearStr = [NSString stringWithFormat:@"%@年",[dmArr objectAtIndex:0]];
        NSString *dmstr =  [NSString stringWithFormat:@"%@月%@日",[dmArr objectAtIndex:dmNum-2],[dmArr objectAtIndex:dmNum-1]];
        [mdhDic setObject:yearStr forKey:@"yearStr"];//年
        [mdhDic setObject:dmstr forKey:@"mdStr"];//月日
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
#warning  少 按照mdStr顺序排序
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mdStr"
                                                  ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    totalTimeArr = [dataArr sortedArrayUsingDescriptors:sortDescriptors];
    //  设置默认的显示pickerView上的数据
    NSDictionary *firstDic = (NSDictionary *)[totalTimeArr firstObject];
    NSString *mdStr = [firstDic objectForKey:@"mdStr"];//选择的月日
    NSArray *hourArr = [firstDic objectForKey:@"hourArr"];
    NSDictionary *hourDic = [hourArr firstObject];
    NSString *hourStr = [hourDic objectForKey:@"hourStr"];//选择的时
    NSArray *minuteArr = [hourDic objectForKey:@"minuteArr"];
    NSString *minuteStr = [minuteArr firstObject];//选择的分
    defaultTimeArr = @[mdStr,hourStr,minuteStr];
    
    
    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(30, 100 + 45, 200, 30);
    [orderBtn setTitle:[NSString stringWithFormat:@"%@%@%@",mdStr,hourStr,minuteStr] forState:UIControlStateNormal];
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
//    NSArray *totalDataArray = @[@[@"今天20点",@"hahhha",@"我的世界我的世界我的世界",@"我做主"],@[@"220",@"30分",@"222",@"223"]];
    //  初始化pickerView
    MultiplePickerView *selectPickerView = [[MultiplePickerView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) dataArr:totalTimeArr];
    selectPickerView.bgViewH = 200;
    selectPickerView.rowHeight = 35;
    selectPickerView.title = @"";
    selectPickerView.firstShowArr = defaultTimeArr;
    //设置当前显示在控件条上的内容的数组:首次未回调确认,手动设置
    if (![currentSelectArr count]) {
        currentSelectArr = selectPickerView.firstShowArr.mutableCopy;
    }
    [selectPickerView setDefaultSelectRowArr:currentSelectArr isDynamicChange:YES];
    __weak __typeof(self)weakSelf = self;
    selectPickerView.confirmSelectBlock = ^(NSArray *selectDataArr){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        currentSelectArr = selectDataArr.mutableCopy;
        NSMutableString *selectAllStr = @"".mutableCopy;
        for (NSString *str in currentSelectArr) {
            [selectAllStr appendString:str];
        }
        [orderBtn setTitle:selectAllStr forState:UIControlStateNormal];
    };
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
