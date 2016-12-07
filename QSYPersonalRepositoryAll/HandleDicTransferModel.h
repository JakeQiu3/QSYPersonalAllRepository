//
//  HandleDicTransferModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubDicTransferModel;
@interface HandleDicTransferModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, strong) NSNumber *ansNum;
@property (nonatomic, copy) NSArray *answers; //内含有数组
@property (nonatomic, strong) SubDicTransferModel *allQueAnsModel; //内含有字典

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)appWithDic:(NSDictionary *)dic;

@end
