
//  ViewController.h
//  PullDemo
//
//  Created by 邱少依 on 16/7/18.
//  Copyright © 2016年 QSY. All rights reserved.

#import <UIKit/UIKit.h>

@class QSMultiplePullDownMenu;
#define QSMultiplePullMenuShowNotification @"QSMultiplePullMenuShowNotification"
typedef NS_ENUM (NSInteger,IndicatorStatus) {
    IndicatorStateShow = 0,
    IndicatorStateHide
};

typedef NS_ENUM (NSInteger,BackGroundViewStatus) {
    BackGroundViewStatusShow = 0,
    BackGroundViewStatusHide
};

@protocol QSPullDownMenuDelegate <NSObject>

@optional

- (void)pullDownMenu:(QSMultiplePullDownMenu *)pullDownMenu didSelectColumn:(NSString *)columnStr secondRow:(NSString *)rowStr;

@end

@interface QSMultiplePullDownMenu : UIView <UITableViewDelegate, UITableViewDataSource>

/**
 *  初始化控件
 *
 *  @param array 数据源数组：内的数组数量，为item的个数
 *  @param color 选择数据时的颜色
 *  @param titlesArr menu的title的数组是固定不变：若不是，传@[]
 *
 *  @return 该下拉菜单控件
 */

- (QSMultiplePullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)selectedColor constantTitlesArr:(NSArray *)titlesArr;
// 是否显示menu的下拉tabview
@property (nonatomic, assign) BOOL isShowTab;

// 是否更新该menu的title: 默认是NO
@property (nonatomic, assign) BOOL allowUpdataMenuTitle;

@property (nonatomic, assign) CGFloat titleAndPicMargin;// 绘制的文字和图片的间距
@property (nonatomic, assign)CGFloat titleFontSize;//文字字体的大小：默认是15
@property (nonatomic, assign)CGFloat lineWidth;//中间分割线的宽度：默认是1
@property (nonatomic, strong)UIColor *indicatorColor;//指示图标的颜色:默认同title
@property (nonatomic, assign)CGFloat leftLabWidth;//左侧lab宽度：默认是120

/**
 *  设置tableview可视的cell的个数，设置tableview的可视高度
 */
@property (nonatomic, assign) int tableVHeightNumMax;// default 是 6

@property (nonatomic,weak) id<QSPullDownMenuDelegate> delegate;

- (void)showInSupView:(UIView *)superView;//添加到父控件上

- (void)dismissPullDownView; //下拉菜单消失

@end


// CALayerCategory
@interface CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath;

@end
