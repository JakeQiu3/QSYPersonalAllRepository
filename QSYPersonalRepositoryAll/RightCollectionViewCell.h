//
//  RightCollectionViewCell.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostMallCategoryModel.h"

@interface RightCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic, strong)PostMallCategoryModel *seaSaleCategoryModel;
@end
