//
//  MXPullDownMenu000.h
//  MXPullDownMenu
//
//  Created by macMx on 14-8-21.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@class MXPullDownMenu;

typedef enum
{
    IndicatorStateShow = 0,
    IndicatorStateHide
}
IndicatorStatus;

typedef enum
{
    BackGroundViewStatusShow = 0,
    BackGroundViewStatusHide
}
BackGroundViewStatus;

@protocol MXPullDownMenuDelegate <NSObject>

@optional
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row;

@end

@interface MXPullDownMenu : UIView<UITableViewDelegate, UITableViewDataSource>

/**
 *  初始化控件
 *
 *  @param array 数据源数组：内的数组数量，为item的个数
 *  @param color 选择时的颜色
 *  @param itemHeight item的高度
 *
 *  @return 该下拉菜单控件
 */
- (MXPullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)color itemHeight:(CGFloat )itemHeight;
/**
 * 设置不同的菜单栏默认选中的item
 */
@property (nonatomic, assign) int defaultItem;//默认每个tableview都是 0

/**
 *  设置tableview可视的cell的个数，设置tableview的可视高度
 */
@property (nonatomic, assign) int tableVHeightNumMax;//default 是 3


@property (nonatomic,weak) id<MXPullDownMenuDelegate> delegate;

@end


// CALayerCategory
@interface CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath;

@end
