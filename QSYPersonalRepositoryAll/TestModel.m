//
//  AutoModel.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/6/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

- (TestModel *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.detailText = dic[@"detailText"];
        self.textStr = dic[@"textStr"];
//        [self setValuesForKeysWithDictionary:dic];// 转模型
    }
    return self;
}

+ (TestModel *)initWithDic:(NSDictionary *)dic {
    TestModel *model = [[self alloc] initWithDic:dic];
    return model;
}
@end
