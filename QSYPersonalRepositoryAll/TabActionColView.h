//
//  TabActionColView.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightCollectionView.h"
@interface TabActionColView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)arr rightCollectionView:(BOOL )isColView;
// 右侧为 tab
@property (nonatomic, strong)UITableView *rightSelectTab;
// 右侧为 CollectionView
@property (nonatomic, strong)RightCollectionView *rightSelectCol;
// 左侧显示的index：默认是第0行
@property (nonatomic, assign)NSInteger showIndex;
// 左侧lab的宽
@property (nonatomic, assign)CGFloat leftLabW;
// 左侧lab的cell高
@property (nonatomic, assign)CGFloat leftLabCellH;
// 添加到superView
- (void)showInView:(UIView *)supView;
// 消失
- (void)dismiss;
/** 选择分类delegate */
@property (nonatomic, weak)id<TabOrColDelegate> delegate;

@end
