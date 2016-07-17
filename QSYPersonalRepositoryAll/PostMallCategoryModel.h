//
//  PostMallCategoryModel.h
//  VinuxPost
//  
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

/** left categoryName */
@property (nonatomic, copy) NSString *categoryName;

/** 社区id */
@property (nonatomic, copy) NSString *memberId;

/** operatorId 未使用*/
@property (nonatomic, copy) NSString *operatorId;

/*
 * image url
 */
@property (nonatomic, copy) NSString *seaSaleLogoUrl;

#pragma _mark 用于接收内层array的数据: 执行setAttributes 执行
/*
 * colView的数据源
 */
@property (nonatomic, strong) NSArray *children;

@end
