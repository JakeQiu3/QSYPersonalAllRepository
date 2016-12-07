//
//  HandleDicTransferModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "HandleDicTransferModel.h"
#import "SubDicTransferModel.h"
@interface HandleDicTransferModel ()

@end
@implementation HandleDicTransferModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.ID = [dic objectForKey:@"id"];
        self.num = [dic objectForKey:@"number"];
        self.question = [dic objectForKey:@"question"];
        self.ansNum = [dic objectForKey:@"ansNumber"];
        //处理数组
        self.answers = [dic objectForKey:@"answers"];
        // 处理字典转model
        self.allQueAnsModel = [[SubDicTransferModel alloc] initWithDic:[dic objectForKey:@"allQueAnswer"]];
    }
    return self;
}

+ (instancetype)appWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}

// 若是键值对不对应
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
//}

@end
