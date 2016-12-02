//
//  OrderVideoSelectTime.h
//  Test
//  数据源间无联系的工具
//  Created by 邱少依 on 16/7/14.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SinglePickerView;
typedef void(^ConfirmSelectBlock)(NSMutableArray *selectArray);

@interface SinglePickerView : UIView
// 确定按钮的block回调
@property (nonatomic, copy) ConfirmSelectBlock confirmSelectBlock;

@property (nonatomic, assign) CGFloat bgViewH;// bgView的默认高度，是150
@property (nonatomic, assign) CGFloat rowHeight;//pickerView的行高 默认是35
@property (nonatomic, assign) CGFloat pickerViewY;//pickerView 到bgView 的顶部的Y: 默认是在取消和确认按钮的下沿
@property (nonatomic, assign) CGFloat titleViewY;//titleView 到bgView 的顶部的Y: 默认是同取消和确认按钮
@property (nonatomic, copy) NSString *title;// 标题label:默认为@“”

@property (nonatomic, strong)UIColor *titleColor;//标题的color
@property (nonatomic, strong)UIColor *cancelBtnColor;//取消button的颜色
@property (nonatomic, strong)UIColor *confirmBtnColor;//确定button的颜色

// pickerview默认显示的数据 和 展示控件select的数据
@property (nonatomic, strong)NSArray *firstShowArr;

- (void)setDefaultSelectRowArr:(NSMutableArray *)array isDynamicChange:(BOOL)isDynamic;
// 初始化self
- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;
- (void)showInView;//添加该视图到keywindow
- (void)dismiss;

@end
