//
//  PostMallCategoryModel.h
//  VinuxPost
//  实体商城商品分类model
//  Created by MR-zhang on 15/11/25.
//  Copyright © 2015年 Ricky. All rights reserved.
//

#import "BaseModel.h"

@protocol PostMallCategoryModel;

@interface PostMallCategoryModel : BaseModel

/** categoryId */
@property (nonatomic, copy) NSString *categoryId;

/** orderNumber */
@property (nonatomic, copy) NSString *orderNumber;

/** categoryName */
@property (nonatomic, copy) NSString *categoryName;

/** 社区id */
@property (nonatomic, copy) NSString *memberId;

/** operatorId */
@property (nonatomic, copy) NSString *operatorId;

@property (nonatomic, copy) NSString *seaSaleLogoUrl;


//============= 内层数组====================
@property (nonatomic, strong) NSArray *children;

@end
