//
//  MantleModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Mantle/Mantle.h>
typedef NS_ENUM(NSUInteger) {
    QSYMantleIssueStateOnlyRead, //只读
    QSYMantleIssueStateWriteRead // 读写
} QSYMantleIssueState;

@class SubDicTransferModel;
@interface MantleModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, assign, readonly) QSYMantleIssueState state;
@property (nonatomic, copy, readonly) NSDate *updatedAt;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, strong) NSNumber *ansNum;
@property (nonatomic, copy) NSArray *answers; //内含有数组
@property (nonatomic, strong) SubDicTransferModel *allQueAnsModel; //内含有字典
//
//1.下载Mantle
//
//2.创建model时候必须继承：MTLModel
//
//3.model必须实现协议：MTLJSONSerializing
//
//4.重写协议的一个方法：
//
//使用Mantle必须实现的协议  KVO的形式
//
//+(NSDictionary *)JSONKeyPathsByPropertyKey
//
//5.如果model里面属性有嵌套model 或者 属性需要做转换等就实现
//+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key
//
//
//6.模型或者数组的映射model主要涉及的类：MTLJSONAdapter

@end
