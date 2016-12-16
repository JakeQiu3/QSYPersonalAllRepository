//
//  LBTransform.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：数据类型转化和编码
 */
#import <Foundation/Foundation.h>

@interface LBTransform : NSObject

/**
 *  NSdictionary/NSArray -> jsonData
 *
 *  @param dictOrAry <#dictOrAry description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)transformDictOrAryToJSONString:(id)dictOrAry;

/**
 *  jsonData -> NSdictionary
 *
 *  @param jsonString <#jsonString description#>
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)transformJSONToDict:(NSString *)jsonString;

/**
 *  URL编码 - CF
 *
 *  @param string 传入的中文字符串（例：我是LB）
 *
 *  @return 经CF编码后的字符串（例：%E6%88%91%E6%98%AFLB）
 */
+ (NSString*)urlEncodeStringCF:(NSString*)string;

/**
 *  URL解码decoded - CF
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)urlDecodedStringCF:(NSString *)string;

/**
 *  URL编码 - UTF8
 *
 *  @param string 传入的中文字符串（例：我是LB）
 *
 *  @return 经UTF8编码后的字符串（例：%E6%88%91%E6%98%AFLB）
 */
+ (NSString*)urlEncodeStringUTF8:(NSString*)string;

/**
 *  URL解码decoded - UTF8
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)urlDecodedStringUTF8:(NSString *)string;

/**
 *  全角 -> 半角（全角：一个字符占用两个标准字符位置，如汉字； 半角：一字符占用一个标准的字符位置，如英文字母、数字键、符号键）
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)transformFullToHalfString:(NSString *)string;

/**
 *  半角 -> 全角
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)transformHalfToFullString:(NSString *)string;


@end
