//
//  RightCollectionViewCell.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "RightCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

#define viewWidth self.bounds.size.width
#define viewHeight self.bounds.size.height

@implementation RightCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _iconImage =[[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        _iconImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImage.frame = CGRectMake((viewWidth-(viewWidth-10))/2, 0,viewWidth-10, viewWidth-10);
    self.nameLabel.frame = CGRectMake((viewWidth-(viewWidth-10))/2, CGRectGetMaxY(self.iconImage.frame),viewWidth-10, 40);
}

#pragma _mark 设置col cell的数据
- (void)setSeaSaleCategoryModel:(PostMallCategoryModel *)seaSaleCategoryModel {
    if (_seaSaleCategoryModel != seaSaleCategoryModel) {
        _seaSaleCategoryModel = seaSaleCategoryModel;
    }
    NSString *imgStr = [NSString stringWithFormat:@"%@%@", @"",@""];
    [self.iconImage setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    self.nameLabel.text = _seaSaleCategoryModel.categoryName;
}
@end
