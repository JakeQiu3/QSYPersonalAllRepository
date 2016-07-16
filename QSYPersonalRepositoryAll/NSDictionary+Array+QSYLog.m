//
//  NSDictionary+Array+QSYLog.m
//
//
//  Created by qsy on 15/7/29.
//  Copyright (c) 2015年 QSY. All rights reserved.
//


#import "NSDictionary+Array+QSYLog.h"

@implementation NSDictionary (QSYLog)
- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"{\n"];
    //  遍历数组的所有元素
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n",key,obj];
    }];
    [str appendString:@"}"];
    //   查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        [str deleteCharactersInRange:range];
    }
//    返回字典中的字符串
    return str;
}
@end

@implementation NSArray (QSYLog)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    //    遍历数组中所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n",obj];
    }];
    [str appendString:@"]"];
    //   查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        [str deleteCharactersInRange:range];
    }
    return str;
}

@end
