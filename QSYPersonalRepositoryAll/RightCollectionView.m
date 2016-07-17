//
//  RightCollectionView.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "RightCollectionView.h"
#import "RightColHeaderResuableView.h"
#import "RightCollectionViewCell.h"
#import "PostMallCategoryModel.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
static NSString *const categoryCell = @"categoryCellIdenfier";
static NSString *const categoryHeaderIdentifier = @"categoryHeaderView";
static CGFloat const margin = 0;
static CGFloat const lineCount = 3;

@interface RightCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
@implementation RightCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(SCREENWIDTH,44);
    flowLayout.minimumInteritemSpacing = margin; //item左右最小间隔
    flowLayout.minimumLineSpacing = margin;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addIdenfier];
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)addIdenfier {
    [self registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:categoryCell];
    [self registerClass:[RightColHeaderResuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:categoryHeaderIdentifier];
}

#pragma mark -- setter
- (void)setDataArray:(NSArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    [self reloadData];
}

//设置头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RightColHeaderResuableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:categoryHeaderIdentifier forIndexPath:indexPath];
//  设置头部视图的数据
        PostMallCategoryModel *model = [_dataArray objectAtIndex:indexPath.section];
        view.label.text = model.categoryName;
        return view;
    }
    return nil;
}

#pragma mark - collection数据源代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    PostMallCategoryModel *sectionModel = [_dataArray objectAtIndex:section];
    return sectionModel.children.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCell forIndexPath:indexPath];
//    设置cell数据
    PostMallCategoryModel *sectionModel = [_dataArray objectAtIndex:indexPath.section];
    PostMallCategoryModel *itemModel = [sectionModel.children objectAtIndex:indexPath.item];
    cell.seaSaleCategoryModel = itemModel;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width/lineCount, self.bounds.size.width/lineCount + 40);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    RightCollectionViewCell *cell = (RightCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.nameLabel setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    RightCollectionViewCell *cell = (RightCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell.nameLabel setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark cell的点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //    获取对应的点击模型
    PostMallCategoryModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section];
    PostMallCategoryModel *itemModel = [sectionModel.children objectAtIndex:indexPath.item];
    
    if ([itemModel.categoryName length] == 0) {
        return;
    }
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(selectedCategoryName:categoryValue:)]) {
        [_selectDelegate selectedCategoryName:itemModel.categoryId categoryValue:itemModel.categoryName];
    }
}

@end
