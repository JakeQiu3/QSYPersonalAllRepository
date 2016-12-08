
//
//  ExtensionModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ExtensionModel.h"

@implementation ExtensionModel
+ (instancetype)objectWithKeyValues:(NSDictionary *)dic {
    NSDictionary *dict = @{
                           @"name" : @"Jack",
                           @"Icon" : @"lufy.png",
                           @"age" : @20,
                           @"height" : @"1.55",
                           @"money" : @100.9,
                           @"sex" : @(SexFemale),
                           @"gay" : @"true"

                           };
    [ExtensionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"icon":@"Icon"};
    }];
    
    ExtensionModel *model = [ExtensionModel objectWithKeyValues:dict];
    return model;
}
@end
