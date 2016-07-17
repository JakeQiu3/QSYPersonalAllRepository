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
//显示的index：默认是第0行
@property (nonatomic, assign)NSInteger showIndex;

@property (nonatomic, assign)CGFloat leftLabW;
@property (nonatomic, assign)CGFloat leftLabCellH;
- (void)showInView:(UIView *)supView;

@property (nonatomic, strong)UITableView *rightSelectTab;
;
@property (nonatomic, strong)RightCollectionView *rightSelectCol;
;
@end
