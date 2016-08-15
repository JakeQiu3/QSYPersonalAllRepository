//
//  PostMallCategoryModel.h
//  VinuxPost
//  实体商城商品分类model
//  Created by qsyMac on 15/11/25.
//  Copyright © 2015年 qsy. All rights reserved.
//

#import "BaseModel.h"

@protocol PostMallCategoryModel;

@interface PostMallCategoryModel : BaseModel

/** categoryId */
@property (nonatomic, copy) NSString *categoryId;

/** categoryName */
@property (nonatomic, copy) NSString *categoryName;

/** 内层的模型数组 */
@property (nonatomic, strong) NSArray *children;

@end
