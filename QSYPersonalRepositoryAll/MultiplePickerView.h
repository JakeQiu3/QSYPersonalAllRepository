//
//  OrderVideoSelectTime.h
//  Test
//
//  Created by 邱少依 on 16/7/14.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MultiplePickerView;
typedef void(^ConfirmSelectBlock)(NSMutableArray *selectArray);

@interface MultiplePickerView : UIView
// 确定按钮的block回调
@property (nonatomic, copy) ConfirmSelectBlock confirmSelectBlock;

@property (nonatomic, assign) CGFloat bgViewH;//默认是150
@property (nonatomic, assign) CGFloat rowHeight;//pickerView的行高 默认是35

@property (nonatomic, copy) NSString *title;// 标题label:默认为@“”
@property (nonatomic, strong)UIColor *titleColor;//标题的color
@property (nonatomic, strong)UIColor *cancelBtnColor;//取消button的颜色
@property (nonatomic, strong)UIColor *confirmBtnColor;//确定button的颜色
@property (nonatomic, strong)NSArray *firstShowArr;
//动态更新pickerview默认的数据 和 展示控件上的数据
- (void)setDefaultSelectRowArr:(NSMutableArray *)array isDynamicChange:(BOOL)isDynamic;
// 初始化self
- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;
- (void)showInView;//添加该视图到keywindow
- (void)dismiss;

@end
