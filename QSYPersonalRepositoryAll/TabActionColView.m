//
//  TabActionColView.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TabActionColView.h"
#import "RightCollectionView.h"
#import "PostMallCategoryModel.h"

#define defaultLeftLabCellH 45
#define defaultLeftLabWidth 90
static NSTimeInterval const animatioinDuration = 0.32;

@interface TabActionColView()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL rightIsColView;
    
    NSMutableArray *dataAllArr; //总模型数组
    UITableView *leftSelectTab;
    
    NSArray *rightTabArray;//右侧是tab
    
}

@end
@implementation TabActionColView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)arr rightCollectionView:(BOOL )isColView {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.3;
        self.layer.opacity = 0;
        dataAllArr = @[].mutableCopy;
    
        rightTabArray = @[];
        rightIsColView = isColView;
// 转模型：设置默认显示的数据
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PostMallCategoryModel *model = [[PostMallCategoryModel alloc] initWithDataDic:obj];
            [dataAllArr addObject:model];
        }];
    }
    return self;
}

- (void)dismiss {
    [self dismissAnimation:^{
        [leftSelectTab removeFromSuperview];
        leftSelectTab = nil;
        
        [_rightSelectCol removeFromSuperview];
        _rightSelectCol = nil;
        
        [_rightSelectTab removeFromSuperview];
        _rightSelectTab = nil;
        [self removeFromSuperview];
    }];
}

- (void)dismissAnimation:(void(^)(void))block
{
    [UIView animateWithDuration:animatioinDuration
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
                         self.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         !block ? : block();
                     }];
}

- (void)showInView:(UIView *)supView {
    [supView addSubview:self];
    [self initSubViews];
    [self setDefaultShow];
}

- (void)setDefaultShow {
    // leftTableDefault
    NSInteger selectedIndex = !_showIndex? 0 : _showIndex;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [leftSelectTab selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //   rightTableDefault
    PostMallCategoryModel *model = (PostMallCategoryModel *)[dataAllArr objectAtIndex:selectedIndex];
    if (rightIsColView) {//右侧是colView
        _rightSelectCol.dataArray = model.children;
    } else {
        rightTabArray = model.children;
    }
}

- (void)initSubViews {
    // 左侧选择列表
    leftSelectTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, !_leftLabW?defaultLeftLabWidth : _leftLabW, self.bounds.size.height) style:UITableViewStylePlain];
    leftSelectTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    leftSelectTab.delegate = self;
    leftSelectTab.dataSource = self;
    leftSelectTab.rowHeight = !_leftLabCellH ? defaultLeftLabCellH : _leftLabCellH;
    leftSelectTab.showsVerticalScrollIndicator = NO;
    leftSelectTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:leftSelectTab];
    
    if (rightIsColView) {//若右侧是CollectionView
        
        _rightSelectCol = [[RightCollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftSelectTab.frame), 0, self.bounds.size.width - (!_leftLabW?defaultLeftLabWidth : _leftLabW), self.bounds.size.height)];
        [self addSubview:_rightSelectCol];
    } else {
        // 左侧选择列表 占屏宽80
        _rightSelectTab = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftSelectTab.frame), 0, self.bounds.size.width - (!_leftLabW?defaultLeftLabWidth : _leftLabW), self.bounds.size.height) style:UITableViewStylePlain];
        _rightSelectTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _rightSelectTab.delegate = self;
        _rightSelectTab.dataSource = self;
        _rightSelectTab.rowHeight = !_leftLabCellH ? defaultLeftLabCellH : _leftLabCellH;
        _rightSelectTab.showsVerticalScrollIndicator = NO;
        _rightSelectTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_rightSelectTab];
    }
}

#pragma mark -- UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataAllArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, !(!_leftLabCellH ? defaultLeftLabCellH : _leftLabCellH) - 0.8,!_leftLabW?defaultLeftLabWidth : _leftLabW, 0.8)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    
    //    设置cell的数据
    PostMallCategoryModel *model = [dataAllArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.categoryName;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel sizeToFit];
    return cell;
}

// 点击 左侧tab 执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == leftSelectTab) {//左侧的tab
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        PostMallCategoryModel *model = [dataAllArr objectAtIndex:indexPath.row];
        _rightSelectCol.dataArray = model.children;
    }
   
}


@end
