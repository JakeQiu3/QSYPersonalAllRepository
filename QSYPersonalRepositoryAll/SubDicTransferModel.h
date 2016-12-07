//
//  SubDicTransferModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/6.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubDicTransferModel : NSObject
@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
