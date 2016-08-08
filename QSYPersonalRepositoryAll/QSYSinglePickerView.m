//
//  QSYSinglePickerView.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/4.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "QSYSinglePickerView.h"

@interface QSYSinglePickerView ()

@end

@implementation QSYSinglePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)loadAgeInfo:(UITableViewCell *)cell  {
    NSArray *totalAgeArray = @[@[@"18岁",@"120岁",@"89岁",@"12岁",@"22岁"]];
    _selectSinglePickerView = [[SinglePickerView alloc] initWithFrame:CGRectMake(0,0, screenBoundsWidth,screenBoundsHeight) dataArr:totalAgeArray];
    _selectSinglePickerView.rowHeight = 30;
    _selectSinglePickerView.firstShowArr =  @[@"89岁"];//PickerView默认显示的数据
    if (![currentSelectAgeArr count]) {
        currentSelectAgeArr = _selectSinglePickerView.firstShowArr.mutableCopy;
    }
    [_selectSinglePickerView setDefaultSelectRowArr:currentSelectAgeArr isDynamicChange:YES];        _selectSinglePickerView.confirmSelectBlock = ^(NSArray *selArr){
        currentSelectAgeArr = selArr.mutableCopy;
        NSMutableString *selectAllStr = @"".mutableCopy;
        for (NSString *str in selArr) {
            [selectAllStr appendString:str];
        }
        cell.detailTextLabel.text = selectAllStr;
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
