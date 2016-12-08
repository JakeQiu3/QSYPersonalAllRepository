
//
//  MantleModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MantleModel.h"
#import "SubDicTransferModel.h"

@implementation MantleModel
#warning 少 如果model里面属性有嵌套model 或者 属性需要做转换等就实现 如下：
// date转化为NSDateFormatter
+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

// url转为NSValue
+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


// htmlUrl转为NSValue
+ (NSValueTransformer *)HTMLURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
// 枚举类型
+ (NSValueTransformer *)stateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"writeRead": @(QSYMantleIssueStateWriteRead),
                                                                           @"onlyRead": @(QSYMantleIssueStateOnlyRead)
                                                                           }];
}

// 模型中嵌套模型
+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SubDicTransferModel.class];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"updatedAt"]) {// 处理date类型
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *str = (NSString *)value;
            return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
        } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSDate *date = (NSDate *)value;
            return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
        }];
    } else if ([key isEqualToString:@"answers"]){// 处理Array
        return [MTLJSONAdapter arrayTransformerWithModelClass:answers.class];
    }
}

#warning 少 KVO的形式的转换
//重写协议的一个方法： 类中model的属性和返回json数据中作关联操作
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"URL":@"url",@"state":@"state",@"updatedAt":@"updatedAt",@"ID":@"id",@"num":@"number",@"question":@"question",@"ansNum":@"ansNumber",@"answers":@"answers",@"allQueAnsModel":@"allQueAnswer"};
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (!self)return nil;
    return self;
}

@end
