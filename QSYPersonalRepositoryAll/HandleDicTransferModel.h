//
//  HandleDicTransferModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger) {
    QSYIssueStateOnlyRead, //只读
    QSYIssueStateWriteRead // 读写
} QSYIssueState;

@class SubDicTransferModel;
@interface HandleDicTransferModel : NSObject
@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, assign, readonly) QSYIssueState state;
@property (nonatomic, copy, readonly) NSDate *updatedAt;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, strong) NSNumber *ansNum;
@property (nonatomic, copy) NSArray *answers; //内含有数组
@property (nonatomic, strong) SubDicTransferModel *allQueAnsModel; //内含有字典

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)appWithDic:(NSDictionary *)dic;

@end
