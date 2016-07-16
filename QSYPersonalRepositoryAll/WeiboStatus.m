//
//  WeiboStatus.m
//  tableview使用大全
//
//  Created by 邱少依 on 15/12/25.
//  Copyright © 2015年 QSY. All rights reserved.
//

#import "WeiboStatus.h"

@implementation WeiboStatus

- (instancetype )initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.Id = [dic[@"Id"] longLongValue];
        self.profileImageUrl = dic[@"profileImageUrl"];
        self.userName = dic[@"userName"];
        self.mbtype = dic[@"mbtype"];
        self.createdAt = dic[@"createdAt"];
        self.source = dic[@"source"];
        self.text = dic[@"text"];
    }
    return self;
}

+ (instancetype )initWithDic:(NSDictionary *)dic {
    WeiboStatus *status = [[WeiboStatus alloc] initWithDic:dic];
    return status;
}

- (NSString *)source {
    return [NSString stringWithFormat:@"来自 %@",_source];
}

@end
