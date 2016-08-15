//
//  RightCollectionView.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabOrColDelegate.h"
@interface RightCollectionView : UICollectionView
@property (nonatomic, strong) NSArray *dataArray;// 数据源
@property (nonatomic, strong) NSString *selectLeftStr;
@property (nonatomic, strong) NSString *selectLeftId;
@property (nonatomic, weak)id <TabOrColDelegate> selectDelegate;
- (instancetype)initWithFrame:(CGRect)frame;
@end
