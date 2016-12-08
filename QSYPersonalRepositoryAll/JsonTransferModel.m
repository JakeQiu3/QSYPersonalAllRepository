
//
//  JsonTransferModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "JsonTransferModel.h"
#import "SubJsonModel.h"

@implementation JsonTransferModel

// keyMapper 修改
+ (JSONKeyMapper *)keyMapper {
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
                                       @{
                                         @"Test": @"test",
                                         @"dialNumber": @"dialCode",
                                         @"numArr":@"numArray"
                                         }
                             ];
    return mapper;
}

//+ (NSMutableArray *)arrayOfDictionariesFromModels:(NSArray *)array {
//    NSArray *aaArr =[];
//}
//+ (NSMutableDictionary *)dictionaryOfDictionariesFromModels:(NSDictionary *)dictionary {
//    
//}
@end
