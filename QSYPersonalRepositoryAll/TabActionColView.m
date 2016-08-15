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
static NSTimeInterval const animatioinDuration = 0.35;

@interface TabActionColView()<UITableViewDataSource,UITableViewDelegate> {
    BOOL rightIsColView;
    
    NSMutableArray *dataAllArr; //总模型数组
    UITableView *leftSelectTab;
    NSArray *rightTabArray;//右侧是tab的数组
    
    NSString *selectLeftStr;// 左侧的选择内容
    NSString *selectRightStr;// 右侧的选择内容
    NSString *selectLeftId;// 左侧的选择Id
    NSString *selectRightId;// 右侧的选择Id
}

@end
@implementation TabActionColView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)arr rightCollectionView:(BOOL )isColView {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        dataAllArr = @[].mutableCopy;
        rightTabArray = @[];
        rightIsColView = isColView;
        selectLeftStr = @"";
        selectRightStr = @"";
        selectLeftId = @"";
        selectRightId = @"";
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PostMallCategoryModel *model = [[PostMallCategoryModel alloc] initWithDataDic:obj];
            [dataAllArr addObject:model];
        }];
    }
    return self;
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
    // rightTableDefault
    PostMallCategoryModel *model = (PostMallCategoryModel *)[dataAllArr objectAtIndex:selectedIndex];
    selectLeftStr = model.categoryName;
    selectLeftId = model.categoryId;
    if (rightIsColView) {//右侧是colView
        _rightSelectCol.dataArray = model.children;
        _rightSelectCol.selectLeftStr = selectLeftStr;
        _rightSelectCol.selectLeftId = selectLeftId;
    } else {
        rightTabArray = model.children;
    }
}

- (void)initSubViews {
    // 左侧选择列表
    leftSelectTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, !_leftLabW ? defaultLeftLabWidth : _leftLabW, self.bounds.size.height) style:UITableViewStylePlain];
    leftSelectTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    leftSelectTab.delegate = self;
    leftSelectTab.dataSource = self;
    leftSelectTab.rowHeight = !_leftLabCellH ? defaultLeftLabCellH : _leftLabCellH;
    leftSelectTab.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0f];
    leftSelectTab.showsVerticalScrollIndicator = NO;
    leftSelectTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:leftSelectTab];
    
    if (rightIsColView) {// 若右侧是CollectionView
        _rightSelectCol = [[RightCollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftSelectTab.frame), 64, self.bounds.size.width - (!_leftLabW?defaultLeftLabWidth : _leftLabW), self.bounds.size.height)];
        [self addSubview:_rightSelectCol];
    } else
        // 左侧选择列表 占屏宽80
    _rightSelectTab = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftSelectTab.frame), 64, self.bounds.size.width - (!_leftLabW?defaultLeftLabWidth : _leftLabW), self.bounds.size.height) style:UITableViewStylePlain];
    _rightSelectTab.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _rightSelectTab.delegate = self;
    _rightSelectTab.dataSource = self;
    _rightSelectTab.rowHeight = !_leftLabCellH ? defaultLeftLabCellH : _leftLabCellH;
    _rightSelectTab.showsVerticalScrollIndicator = NO;
    _rightSelectTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:_rightSelectTab];
}

#pragma mark -- UITableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!rightIsColView) {// 右侧是tableview
        if ([tableView isEqual:leftSelectTab]) {
            return [dataAllArr count];
        } else return [rightTabArray count];
    } else {
        return [dataAllArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *leftCellIdentifier = @"leftCellIdentifier";
    static NSString *rightCellIdentifier = @"rightCellIdentifier";
    NSString *cellIdentifier = @"";
    NSArray *dataArr = @[];
    UIColor *bgColor;
    if ([tableView isEqual:leftSelectTab]) {
        cellIdentifier = leftCellIdentifier;
        dataArr = dataAllArr;
        bgColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0f];
    } else if ([tableView isEqual:_rightSelectTab]) {
        cellIdentifier = rightCellIdentifier;
        dataArr = rightTabArray;
        bgColor = [UIColor whiteColor];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = bgColor;
    }
    // 设置cell的数据
    PostMallCategoryModel *model = [dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.categoryName;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel sizeToFit];
    return cell;
}

// 点击 左侧tab 执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == leftSelectTab) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        PostMallCategoryModel *model = [dataAllArr objectAtIndex:indexPath.row];
        selectLeftStr = model.categoryName;
        selectLeftId = model.categoryId;
        if (rightIsColView) {//右侧是colView
            _rightSelectCol.selectLeftStr = selectLeftStr;
            _rightSelectCol.selectLeftId = selectLeftId;
        }
        !rightIsColView ? (rightTabArray = model.children):(_rightSelectCol.dataArray = model.children);
        !rightIsColView ?([_rightSelectTab reloadData]):([_rightSelectCol reloadData]);
    } else if (tableView == _rightSelectTab) {
        PostMallCategoryModel *model = [rightTabArray objectAtIndex:indexPath.row];
        selectRightStr = model.categoryName;
        selectRightId = model.categoryId;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCategoryName:categoryId:objectValue:objectId:)]) {
            [self.delegate selectedCategoryName:selectLeftStr categoryId:selectLeftId objectValue:selectRightStr objectId:selectRightId];
        }
    }
}

#pragma _mark dismiss methods
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


@end
