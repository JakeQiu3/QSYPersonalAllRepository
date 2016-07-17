//
//  PostMallCategoryModel.m
//  VinuxPost
//
//  Created by MR-zhang on 15/11/25.
//  Copyright © 2015年 Ricky. All rights reserved.
//

#import "PostMallCategoryModel.h"

@implementation PostMallCategoryModel

// 在 initWithDic:obj 调用该方法
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    NSArray *children = [dataDic objectForKey:@"children"];
    
    if ([children isKindOfClass:[NSNull class]]) {
        return;
    }
    
    NSMutableArray *results = @[].mutableCopy;
    
    [children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PostMallCategoryModel *model = [[PostMallCategoryModel alloc] initWithDataDic:obj];
        [results addObject:model];
    }];
    
    _children = [results copy];
}

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *dataDict = @{
                               @"categoryId":@"id",
                               @"orderNumber":@"orderNum",
                               @"categoryName":@"catalogName",
                               @"memberId":@"memberId",
                               @"operatorId":@"operatorId",
                               @"seaSaleLogoUrl":@"logoUrl"
                               };
    return dataDict;
}

@end
