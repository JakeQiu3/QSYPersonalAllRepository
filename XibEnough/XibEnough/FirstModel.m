//
//  FirstModel.m
//  XibEnough
//
//  Created by qsyMac on 16/7/10.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FirstModel.h"

@implementation FirstModel

- (instancetype)initWithDicit:(NSDictionary *)dic {
    self = [super init];
    if (self) {
       [self setValuesForKeysWithDictionary:dic];
        self.icon = dic[@"dic"];
        self.name = dic[@"name"];

        self.text = dic[@"text"];

        self.vip = dic[@"vip"];
    }
    return self;
}

+ (instancetype)firstModelWithDict:(NSDictionary *)dic {
    FirstModel *model = [[FirstModel alloc] initWithDicit:dic];
    return model;
}

@end
