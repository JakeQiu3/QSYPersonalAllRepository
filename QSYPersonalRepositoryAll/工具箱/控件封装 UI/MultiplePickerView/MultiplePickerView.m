//
//  OrderVideoSelectTime.m
//  Test
//
//  Created by 邱少依 on 16/7/14.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MultiplePickerView.h"

#define QSY_SIGNALTEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define compotentW 100
#define cancelAndconfirmbtnW 50

static NSTimeInterval const animatioinDuration = 0.32;
@interface MultiplePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *bgView;
    UILabel *titleLable;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UIDatePicker *datePicker;
    UIPickerView *qsyPickerView;
    NSArray *dataArray;//数据源数组
    NSArray *firstArr;//1级数组
    NSArray *secondArr;//2级数组
    NSArray *thirdArr;//3级数组
    NSMutableArray *selectArr;// 选择后数据添加到新的数组
    
    NSString *selectFirstStr;
    NSString *selectSecondStr;
    NSString *selectThirdStr;
}

/** 设置默认显示的数据row的数组*/
@property (nonatomic, strong)NSMutableArray *defaultSelectRowArr;
@end

@implementation MultiplePickerView

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.66];
        self.layer.opacity = 0;
        selectArr = @[].mutableCopy;
        dataArray = dataArr;
        _defaultSelectRowArr = @[].mutableCopy;
        _firstShowArr = @[];
    }
    return self;
}

- (void)showInView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 禁止重复添加
    if ([keyWindow.subviews containsObject:self]) {
        return;
    }
    //  将选择时间父视图添加到self上
    [self initSubviews];
    [keyWindow addSubview:self];
    [keyWindow insertSubview:self atIndex:keyWindow.subviews.count-1];
    [self showAnimation];
}

- (void)showAnimation
{
    // 设置table transfrom
    bgView.transform = CGAffineTransformMakeTranslation(0, bgView.bounds.size.height);
    [UIView animateWithDuration:animatioinDuration
                     animations:^{
                         self.layer.opacity = 1;
                         bgView.transform = CGAffineTransformIdentity;
                     }];
}


- (void)initSubviews {
    //  背景父视图
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH-(!_bgViewH?150:_bgViewH), SCREENW,!_bgViewH?150:_bgViewH)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    //    设置标题
    titleLable = [[UILabel alloc]init];
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textColor = !_titleColor?[UIColor grayColor]:_titleColor;
    titleLable.text = ![_title length]?@"":_title;
    CGSize titleSize = QSY_SIGNALTEXTSIZE(titleLable.text, [UIFont systemFontOfSize:17]);
    titleLable.frame = CGRectMake((SCREENW-titleSize.width)*0.5,!_titleViewY ? 10:_titleViewY, titleSize.width, 30);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLable];
    
    // 点击按钮
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelBtn.frame = CGRectMake(20, 10, cancelAndconfirmbtnW, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:!_cancelBtnColor ?[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0f]:_cancelBtnColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmBtn.frame = CGRectMake(SCREENW -cancelAndconfirmbtnW-20,10, cancelAndconfirmbtnW, 30);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:!_confirmBtnColor ? [UIColor colorWithRed:160/255.0 green:200/255.0 blue:115/255.0 alpha:1.0f]:_confirmBtnColor forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confrimBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    //    创建pickerView
    qsyPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(confirmBtn.frame),SCREENW,!_pickerViewY ? (bgView.bounds.size.height - CGRectGetMaxY(confirmBtn.frame)): _pickerViewY)];
    qsyPickerView.dataSource = self;
    qsyPickerView.delegate = self;
    qsyPickerView.showsSelectionIndicator = YES;
    [bgView addSubview:qsyPickerView];
    
    //  设置默认选中数据
    NSDictionary *mdDic = [dataArray objectAtIndex:[[_defaultSelectRowArr objectAtIndex:0] integerValue]];
    NSString *mdStr = [mdDic objectForKey:@"mdStr"];//月日
    NSArray *hourArr = [mdDic objectForKey:@"hourArr"];
    NSDictionary *hourDic = [hourArr objectAtIndex:[[_defaultSelectRowArr objectAtIndex:1] integerValue]];
    NSString *hourStr = [hourDic objectForKey:@"hourStr"];//时
    NSArray *minuteArr = [hourDic objectForKey:@"minuteArr"];
    NSString *minuteStr = [minuteArr objectAtIndex:[[_defaultSelectRowArr objectAtIndex:2] integerValue]];// 分
    [selectArr  addObject:mdStr];
    [selectArr  addObject:hourStr];
    [selectArr  addObject:minuteStr];
    // 设置1级数组、2级数组 和 3级数组
    NSMutableArray *firstTempArr = [[NSMutableArray alloc] init];
    for (NSInteger j=0; j<dataArray.count; j++) {
        NSDictionary *tempDic = [dataArray objectAtIndex:j];
        [firstTempArr addObject:[tempDic objectForKey:@"mdStr"]];
    }
    NSMutableArray *secondTempArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[hourArr count]; i++) {
        NSDictionary *tempDic = [hourArr objectAtIndex:i];
        [secondTempArr addObject:[tempDic objectForKey:@"hourStr"]];
    }
    NSMutableArray *thirdTempArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[minuteArr count]; i++) {
        [thirdTempArr addObject:[minuteArr objectAtIndex:i]];
    }
    firstArr = firstTempArr.copy;
    secondArr = secondTempArr.copy;
    thirdArr = thirdTempArr.copy;
    
    for (NSInteger i = 0; i<_defaultSelectRowArr.count; i++) {
        NSInteger row = [[_defaultSelectRowArr objectAtIndex:i] integerValue];
        [qsyPickerView selectRow:row inComponent:i animated:NO];
    }
}

#pragma mark -- UIPickerViewDelegate And dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [firstArr count];
    } else if (component == 1){
        return [secondArr count];
    } else if (component == 2){
        return [thirdArr count];
    }
    return  0;
}

//  获取数据源中所有每个分组的数组
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    // 经测试,此方法的reusingView并没什么用,可能是iOS7之后不再使用
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.frame = CGRectMake(0.0, 0.0,compotentW,!_rowHeight?35:_rowHeight);
    myLabel.font = [UIFont systemFontOfSize:14];
    if (component == 0) {
        myLabel.text = [firstArr objectAtIndex:row];
    } else if (component == 1) {
        myLabel.text = [secondArr objectAtIndex:row];
    } else if (component == 2) {
        myLabel.text = [thirdArr objectAtIndex:row];
    }
    return myLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selectStr = @"";
    if (component == 0) {
//      获取2级数据和3级数据,刷新pickerView
        NSDictionary *mdDic = [dataArray objectAtIndex:row];
        NSArray *hourArr = [mdDic objectForKey:@"hourArr"];
        NSMutableArray *hourTempArr = @[].mutableCopy;
        for (NSInteger i =0 ; i<[hourArr count]; i++) {
            NSDictionary *hourDic = [hourArr objectAtIndex:i];
            NSString *hourStr = [hourDic objectForKey:@"hourStr"];
            [hourTempArr addObject:hourStr];
        }
        secondArr = hourTempArr.copy;
        NSDictionary *hourDic = [hourArr objectAtIndex:0];
        thirdArr = [hourDic objectForKey:@"minuteArr"];
        selectFirstStr = [firstArr objectAtIndex:row];
        selectSecondStr = [secondArr objectAtIndex:0];
        selectThirdStr = [thirdArr objectAtIndex:0];
//      再次设置默认选择的数据
        [selectArr replaceObjectAtIndex:0 withObject:selectFirstStr];
        [selectArr replaceObjectAtIndex:1 withObject:selectSecondStr];
        [selectArr replaceObjectAtIndex:2 withObject:selectThirdStr];
//      刷新PickerView:移动到对应0位置
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        //   再次设置默认选择的数据
        selectSecondStr = [secondArr objectAtIndex:row];
        NSString *firstSelectStr = [selectArr objectAtIndex:0];
        for (NSDictionary *dic in dataArray) {
            if ([[dic objectForKey:@"mdStr"] isEqualToString:firstSelectStr]) {
                NSArray *hourArr = [dic objectForKey:@"hourArr"];
                for (NSDictionary *hourDic in hourArr) {
                    if ([[hourDic objectForKey:@"hourStr"] isEqualToString:selectSecondStr]) {
                      thirdArr = [hourDic objectForKey:@"minuteArr"];
                    }
                }
            }
        }
        
        selectThirdStr =  [thirdArr objectAtIndex:0];
        [selectArr replaceObjectAtIndex:1 withObject:selectSecondStr];
        [selectArr replaceObjectAtIndex:2 withObject:selectThirdStr];
        //      刷新PickerView
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 2) {
         selectThirdStr = [thirdArr objectAtIndex:row];
         [selectArr replaceObjectAtIndex:2 withObject:selectThirdStr];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = compotentW;
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return (!_rowHeight?35:_rowHeight);
}

#pragma _mark cancelBtnAndconfrimBtn method
- (void)cancelBtn:(UIButton *)btn {
    [self dismiss];
}

- (void)confrimBtn:(UIButton *)btn {
    if (self.confirmSelectBlock) {
        self.confirmSelectBlock(selectArr);
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismiss];
        });
    }
}

// 设置默认选择行的：SelectRowArr
- (void)setDefaultSelectRowArr:(NSArray *)array isDynamicChange:(BOOL)isDynamic {
    //   获取已经选择的内容数组
    NSArray *getSelArr = array;
    if (!isDynamic) {//不允许动态变化数据
        if ([_defaultSelectRowArr count]) {
            [_defaultSelectRowArr removeAllObjects];
        }
        getSelArr = _firstShowArr;
    }
    //  若已经有旧数据，移除
    if ([_defaultSelectRowArr count]) {
        [_defaultSelectRowArr removeAllObjects];
    }
    
    for (NSInteger i = 0; i< [dataArray count]; i++) {
        NSDictionary *mdDic = [dataArray objectAtIndex:i];
        if ([[mdDic objectForKey:@"mdStr"] isEqualToString:[getSelArr objectAtIndex:0]]) {
            NSArray *hourArr = [mdDic objectForKey:@"hourArr"];
            for (NSInteger j=0; j<[hourArr count]; j++) {
                NSDictionary *hourDic = [hourArr objectAtIndex:j];
                if ([[hourDic objectForKey:@"hourStr"]isEqualToString:[getSelArr objectAtIndex:1]]) {
                    NSArray *minuteArr = [hourDic objectForKey:@"minuteArr"];
                    for (NSInteger k = 0; k<[minuteArr count]; k++) {
                        if ([[minuteArr objectAtIndex:k] isEqualToString:[getSelArr objectAtIndex:2]]) {
                            [_defaultSelectRowArr addObject:[NSNumber numberWithInteger:i]];//月日的row
                            [_defaultSelectRowArr addObject:[NSNumber numberWithInteger:j]];//时的row
                            [_defaultSelectRowArr addObject:[NSNumber numberWithInteger:k]];//分的row
                            NSLog(@"少：_defaultSelectRowArr:%@",_defaultSelectRowArr);
                        }
                    }
                }
            }
        }
    }
}

#pragma _mark dismiss
- (void)dismiss {
    [self dismissAnimation:^{
        [bgView removeFromSuperview];
        bgView = nil;
        [self removeFromSuperview];
    }];
}

- (void)dismissAnimation:(void(^)(void))block
{
    [UIView animateWithDuration:animatioinDuration
                     animations:^{
                         bgView.transform = CGAffineTransformMakeTranslation(0, bgView.bounds.size.height);
                         self.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         !block ? : block();
                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch preciseLocationInView:self];
    if (currentPoint.y <= SCREENH-(!_bgViewH?150:_bgViewH)) {
        [self dismiss];
    }
}

@end
