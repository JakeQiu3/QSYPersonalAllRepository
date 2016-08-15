//
//  PostMallCategoryModel.m
//  VinuxPost
//
//  Created by qsy on 15/11/25.
//  Copyright © 2015年 qsy. All rights reserved.
//

#import "PostMallCategoryModel.h"

@implementation PostMallCategoryModel

// 在 initWithDic:obj 调用该方法
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
//  若不含数组，无需执行下面的方法
    NSArray *childrenArr = [dataDic objectForKey:@"children"];
    if ([childrenArr isKindOfClass:[NSNull class]]) {
        return;
    }
    NSMutableArray *results = @[].mutableCopy;
    [childrenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PostMallCategoryModel *model = [[PostMallCategoryModel alloc] initWithDataDic:obj];
        [results addObject:model];
    }];
    _children = [results copy];
}

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *dataDict = @{
                               @"categoryId":@"id",
                               @"categoryName":@"catalogName",
                               };
    return dataDict;
}

@end
