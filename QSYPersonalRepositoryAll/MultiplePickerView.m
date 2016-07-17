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
    NSMutableArray *selectArr;//选择后数据添加到新的数组
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

- (void)showInView
{
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
    titleLable.frame = CGRectMake((SCREENW-titleSize.width)*0.5, 10, titleSize.width, 30);
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
    [confirmBtn setTitleColor:!_confirmBtnColor ? [UIColor greenColor]:_confirmBtnColor forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confrimBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    //    pickerView
    qsyPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(confirmBtn.frame),SCREENW, bgView.bounds.size.height - CGRectGetMaxY(confirmBtn.frame))];
    qsyPickerView.dataSource = self;
    qsyPickerView.delegate = self;
    qsyPickerView.showsSelectionIndicator = YES;
    [bgView addSubview:qsyPickerView];
    //  pickerView 加载完毕，遍历修改该行数
    for (NSInteger i = 0; i<_defaultSelectRowArr.count; i++) {
        //     获取不同分区中默认选中的行数
        NSInteger row = [[_defaultSelectRowArr objectAtIndex:i] integerValue];
        
        [qsyPickerView selectRow:row inComponent:i animated:NO];
        //    设置默认选中数据的数组
        NSArray *arr = [dataArray objectAtIndex:i];
        [selectArr  addObject:arr[row]];
    }
}

#pragma mark -- UIPickerViewDelegate And dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *arr = dataArray[component];
    return  arr.count;
}
//  获取数据源中所有每个分组的数组
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    // 经测试,此方法的reusingView并没什么用,可能是iOS7之后不再使用
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.frame = CGRectMake(0.0, 0.0,compotentW,!_rowHeight?35:_rowHeight);
    myLabel.font = [UIFont systemFontOfSize:14];
    //    获取数据源中每个分组的数据
    NSArray *arr = dataArray[component];
    myLabel.text = arr[row];
    return myLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 获取数据源中每个分组的数据
    NSArray *arr = dataArray[component];
    //   获取到该分组选中的行数的数据
    NSString *selectStr = [arr objectAtIndex:row];
    [selectArr replaceObjectAtIndex:component withObject:selectStr];
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


- (void)setDefaultSelectRowArr:(NSArray *)array isDynamicChange:(BOOL)isDynamic {
    NSArray *getSelArr = array;
    if (!isDynamic) {//不允许动态变化数据
        if ([_defaultSelectRowArr count]) {
            [_defaultSelectRowArr removeAllObjects];
        }
        getSelArr = _firstShowArr;
    }
    //    若已经有旧数据，移除
    if ([_defaultSelectRowArr count]) {
        [_defaultSelectRowArr removeAllObjects];
    }
    
    for (NSInteger i = 0; i<dataArray.count; i++) {
        NSArray *arr = (NSArray *)[dataArray objectAtIndex:i];
        for (NSInteger j = 0; j<arr.count; j++) {
            if ([getSelArr objectAtIndex:i] == [arr objectAtIndex:j]) {
                [_defaultSelectRowArr addObject:[NSNumber numberWithInteger:j]];
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
