
//
//  SubDicTransferModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/6.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "SubDicTransferModel.h"

@implementation SubDicTransferModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.question = [dic objectForKey:@"question"];
        self.answer = [dic objectForKey:@"answer"];
    }
    return self;
}

@end
