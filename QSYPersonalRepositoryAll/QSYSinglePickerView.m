//
//  QSYSinglePickerView.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/4.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "QSYSinglePickerView.h"
#import "SinglePickerView.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface QSYSinglePickerView () {
    SinglePickerView *_selectSinglePickerView;
    NSMutableArray *currentSelectAgeArr;
}
@end

@implementation QSYSinglePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    currentSelectAgeArr = @[].mutableCopy;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 164, SCREENW, 100);
    NSMutableString *btnTitle = @"".mutableCopy;
    [currentSelectAgeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [btnTitle appendString:obj];
    }];
    [btn setTitle:[btnTitle length]?btnTitle:@"请选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
    [btn addTarget:self action:@selector(loadBtnInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)loadBtnInfo:(UIButton *)btn {
    NSArray *totalAgeArray = @[@[@"18岁",@"120岁",@"89岁",@"12岁",@"22岁"],@[@"我就是我",@"是颜色不一样的烟火",@"如果你爱我",@"请不要吝啬你的温柔"]];
    _selectSinglePickerView = [[SinglePickerView alloc] initWithFrame:CGRectMake(0,0, SCREENW,SCREENH) dataArr:totalAgeArray];
    _selectSinglePickerView.rowHeight = 30;
    _selectSinglePickerView.firstShowArr =  @[@"89岁",@"如果你爱我"];//PickerView默认显示的数据数组,必须是数据源中的数据
    if (![currentSelectAgeArr count]) {
        currentSelectAgeArr = _selectSinglePickerView.firstShowArr.mutableCopy;
    }
    [_selectSinglePickerView setDefaultSelectRowArr:currentSelectAgeArr isDynamicChange:YES];
    _selectSinglePickerView.confirmSelectBlock = ^(NSArray *selArr){
        currentSelectAgeArr = selArr.mutableCopy;
        NSMutableString *selectAllStr = @"".mutableCopy;
        for (NSString *str in selArr) {
            [selectAllStr appendString:str];
        }
        [btn setTitle:selectAllStr forState:UIControlStateNormal];
    };
    [_selectSinglePickerView showInView];
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
