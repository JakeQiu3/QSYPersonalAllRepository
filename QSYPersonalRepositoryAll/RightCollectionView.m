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
{
    NSString *selectRightStr;
    NSString *selectRightId;
}
@end
@implementation RightCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(SCREENWIDTH,44);
    flowLayout.minimumInteritemSpacing = margin;
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
    selectRightStr = @"";
    selectRightId = @"";
}

- (void)addIdenfier {
    [self registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:categoryCell];
    [self registerClass:[RightColHeaderResuableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:categoryHeaderIdentifier];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RightColHeaderResuableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:categoryHeaderIdentifier forIndexPath:indexPath];
        PostMallCategoryModel *model = [_dataArray objectAtIndex:indexPath.section];
        view.label.text = model.categoryName;
        return view;
    }
    return nil;
}

#pragma mark - collection数据源代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  [_dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    PostMallCategoryModel *sectionModel = [_dataArray objectAtIndex:section];
    return [sectionModel.children count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCell forIndexPath:indexPath];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PostMallCategoryModel *sectionModel = [_dataArray objectAtIndex:indexPath.section];
    PostMallCategoryModel *itemModel = [sectionModel.children objectAtIndex:indexPath.item];
    if ([itemModel.categoryName length] == 0 ||[itemModel.categoryId length] == 0) {
        return;
    }
    selectRightStr = itemModel.categoryName;
    selectRightId = itemModel.categoryId;
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(selectedCategoryName:categoryId:objectValue:objectId:)]) {
        [self.selectDelegate selectedCategoryName:self.selectLeftStr categoryId:self.selectLeftId objectValue:selectRightStr objectId:selectRightId];
    }
}

@end
