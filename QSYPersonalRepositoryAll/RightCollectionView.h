//
//  RightCollectionView.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftLabRightColViewSelectDelegate.h"
@interface RightCollectionView : UICollectionView
/** collectionView dataArray */
@property (nonatomic, strong) NSArray *dataArray;
/** 选择分类delegate */
@property (nonatomic, weak)id<LeftLabRightColViewSelectDelegate> selectDelegate;

/** 重写初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame;

@end
