//
//  LBUtil.h
//  LBExpandDemo
#pragma mark 少
//  验证各种字符串、字典、数组、邮箱、电话、身份证、MD5加密、
//  时间和日期的转换
//  获取当前控制器、第一响应者、最大的size、iphone支持的语言。
//
//  Created by qsy on 16/11/15.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LBUtil;
@interface LBUtil : NSObject

#pragma mark - LBValidate

/**
 *  验证 字符串是否为空
 */
+ (BOOL)lb_validate_stringisNil:(NSString*)string;

/**
 *  验证是否是 字符串stirng
 */
+ (BOOL)lb_validate_isString:(id)obj;

/**
 *  验证是否是 空对象nullObject
 */
+ (BOOL)lb_validate_isNullObject:(id)obj;

/**
 *  验证是否是 字典dict
 */
+ (BOOL)lb_validate_isDictObj:(id)obj;

/**
 *  验证是否是 数组ary
 */
+ (BOOL)lb_validate_isAryObj:(id)obj;

/**
 *  验证是否是 数字
 */
+ (BOOL)lb_validate_isNumber:(NSString *)number;

/**
 *  验证 邮箱
 */
+ (BOOL)lb_validate_isEmail:(NSString *)email;

/**
 *  验证 手机号
 */
+ (BOOL)lb_validate_isMobileNumber:(NSString *)mobileNum;

/**
 *  验证 电话号（包括固话及小灵通）
 */
+ (BOOL)lb_validate_isPhone:(NSString *)phone;

/**
 *  验证 身份证号
 */
+ (BOOL)lb_validate_isIDCardNumber:(NSString *)idNumber;

/**
 *  字符串违法置空
 */
+ (NSString *)lb_empty_stringIsNil:(NSString *)string;

/**
 *  字典不包含key置空
 */
+ (NSString *)lb_empty_dictKey:(NSDictionary *)dict key:(NSString *)key;


#pragma mark - LBMD5

/**
 *  md5 加密字符串
 */
+ (NSString *)lb_md5_str:(NSString *)string;

/**
 *  md5 加密文件内容
 */
+ (NSString *)lb_md5_fileContent:(NSString *)filePath;

/**
 *  md5 加密data
 */
+ (NSString *)lb_md5_data:(NSData *)data;


#pragma mark - LBDate

/**
 * 获取当前时间
 */
+ (NSString *)lb_date_currentTime;

/**
 *  获取某月的天数
 */
+ (NSInteger)lb_date_DaysInMonth:(NSString *)dateStr;

/**
 *  时间(日期) -> 时间戳（毫秒）
 */
+ (long long)lb_date_timeToMilliSeconds:(NSString *)dateString;

/**
 *  时间戳（毫秒）-> 时间(日期)
 */
+ (NSDate *)lb_date_milliSecondsToTime:(long long)miliSeconds;

/**
 *  计算日期的对应星期数
 */
+ (NSString *)lb_date_weekdayForDateNumber:(NSString *)inputDateStr;

/**
 *  计算日期是星期几
 */
+ (NSString *)lb_date_weekdayForDate:(NSString *)inputDateStr;

/**
 *  计算两个日期天数差
 */
+ (NSString *)lb_date_intervalBetweenfromDate:(NSString *)fromDataString toDate:(NSString *)toDateString;
/**
 *  日期格式化Type1
 */
+ (NSString *)lb_date_formatDateType1:(NSString *)dateStr;

/**
 *  日期格式化Type2
 */
+ (NSString *)lb_date_formatDateType2:(NSString *)dateStr;


#pragma mark - LBTransform

/**
 *  NSdictionary/NSArray -> jsonData
 */
+ (NSString *)lb_transform_dictOrAryToJSONString:(id)dictOrAry;

/**
 *  jsonData -> NSdictionary
 */
+ (NSDictionary *)lb_transform_JSONToDict:(NSString *)jsonString;

/**
 *  URL编码 - CF
 */
+ (NSString*)urlEncodeStringCF:(NSString*)string;

/**
 *  URL解码decoded - CF
 */
+ (NSString *)urlDecodedStringCF:(NSString *)string;

/**
 *  URL编码 - UTF8
 */
+ (NSString*)urlEncodeStringUTF8:(NSString*)string;

/**
 *  URL解码decoded - UTF8
 */
+ (NSString *)urlDecodedStringUTF8:(NSString *)string;

/**
 *  全角 -> 半角
 */
+ (NSString *)lb_transformFullToHalfString:(NSString *)string;

/**
 *  半角 -> 全角
 */
+ (NSString *)lb_transformHalfToFullString:(NSString *)string;


#pragma mark - LBFormat

/**
 *  数值四舍五入
 */
+ (NSString *)lb_format_Value:(float)value Decimal:(NSString *)decimal;

/**
 *  数值的百分化 - 带四舍五入
 */
+ (NSString *)lb_format_valuePercent:(id)valueText smallPoint:(NSInteger)smallPoint;

/**
 *  html标签替换
 */
+ (NSString *)lb_html_entityDecode:(NSString *)string;

/**
 *  html标签替换后的识别
 */
+ (NSString *)lb_html_Filter:(NSString *)html;


#pragma mark - LBCommon

/**
 *  获取当前控制器
 */
+ (UIViewController *)lb_getCurrentViewController;

+ (UIWindow *)lb_getMainWindow;

+ (UIViewController *)lb_getTopViewController:(UIViewController *)viewController;

/**
 *  获得第一响应者
 */
+ (UIView*)lb_getFirstResponderView:(UIView *)view;

/**
 *  获取iPhone当前使用的语言
 */
+ (NSString *)lb_getLanguageUsing;

/**
 *  获取iPhone支持的所有语言
 */
+ (NSArray *)lb_getLanguageSupport;

/**
 *  获得最大Size
 */
+ (CGSize)lb_getBigSize:(NSString *)string font:(UIFont *)font width:(CGFloat)width;


@end
