//
//  RightCollectionView.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftLabRightColViewSelectDelegate <NSObject>
#pragma  mark 点击rightCol或者tab的item的代理方法： 参数-> 分类名  和 产品名
- (void)selectedCategoryName:(NSString *)categoryName
               categoryValue:(NSString *)categoryValue;
@end
@interface RightCollectionView : UICollectionView
/** collectionView dataArray */
@property (nonatomic, strong) NSArray *dataArray;
/** 选择分类delegate */
@property (nonatomic, weak)id<LeftLabRightColViewSelectDelegate> selectDelegate;

/** 重写初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame;

@end
