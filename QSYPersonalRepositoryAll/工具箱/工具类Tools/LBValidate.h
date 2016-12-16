//
//  LBValidate.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/16.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：合法性验证及处理
 */
#import <Foundation/Foundation.h>

@class LBValidate;
@interface LBValidate : NSObject

/**
 *  验证 字符串是否为空
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateStringisNil:(NSString*)string;

/**
 *  验证是否是 字符串stirng
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsString:(id)obj;

/**
 *  验证是否是 空对象nullObject
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsNullObject:(id)obj;

/**
 *  验证是否是 字典dict
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsDictObj:(id)obj;

/**
 *  验证是否是 数组ary
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsAryObj:(id)obj;

/**
 *  验证是否是 数字
 *
 *  @param number <#number description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsNumber:(NSString *)number;

/**
 *  验证 邮箱
 *
 *  @param email <#email description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsEmail:(NSString *)email;

/**
 *  验证 手机号
 *
 *  @param mobileNum <#mobileNum description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsMobileNumber:(NSString *)mobileNum;

/**
 *  验证 电话号（包括固话及小灵通）
 *
 *  @param phone <#phone description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsPhone:(NSString *)phone;

/**
 *  验证 身份证号
 *
 *  @param idNumber <#idNumber description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateIsIDCardNumber:(NSString *)idNumber;

/**
 *  字符串违法时置@""
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)emptyStringIsNil:(NSString *)string;

/**
 *  字典不包含某key时置空处理
 *
 *  @param dict <#dict description#>
 *  @param key  <#key description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)emptyDictKey:(NSDictionary *)dict key:(NSString *)key;

@end
