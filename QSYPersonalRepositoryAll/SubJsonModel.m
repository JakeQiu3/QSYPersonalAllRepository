

//
//  SubJsonModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "SubJsonModel.h"

@implementation SubJsonModel

+ (JSONKeyMapper *)keyMapper {
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                          @"ID":@"id",
                                        }
                             ];
    return mapper;
}
@end
