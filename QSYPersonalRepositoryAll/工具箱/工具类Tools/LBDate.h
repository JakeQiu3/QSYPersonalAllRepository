//
//  LBDate.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：日期相关的处理
 */
#import <Foundation/Foundation.h>

@class LBDate;
@interface LBDate : NSObject

/**
 *  获取当前时间
 *
 * @return 当前时间（例：2016-11-17 10:27:48）
 */
+ (NSString *)dateCurrentTime;

/**
 *  获取某月的天数
 *
 *  @param dateStr 日期（例：2016-11-17 10:27:48）
 *
 *  @return 该日期对应月份的天数（例：30）
 */
+ (NSInteger)dateDaysInMonth:(NSString *)dateStr;

/**
 *  时间(日期) -> 时间戳（毫秒）
 *
 *  @param dateString 日期（例：2016-11-18 11:38:13）
 *
 *  @return 时间戳，单位：毫秒（例：1479469093000）
 */
+ (long long)DateTimeToMilliSeconds:(NSString *)dateString;

/**
 *  时间戳（毫秒）-> 时间(日期)
 *
 *  @param miliSeconds 时间戳，单位：毫秒（例：1479469093000）
 *
 *  @return 日期（例：2016-11-18 11:38:13 +0000）
 */
+ (NSDate *)dateMilliSecondsToTime:(long long)miliSeconds;

/**
 *  计算日期的对应星期数
 *
 *  @param inputDateStr 日期（例：2016-11-17 10:27:48）
 *
 *  @return 星期（例：5（周日为1；周一为2；周二为3；周三为4；周四为5；周五为6；周六为7；））
 */
+ (NSString *)dateWeekdayForDateNumber:(NSString *)inputDateStr;

/**
 *  计算日期是星期几
 *
 *  @param inputDateStr 日期（例：2016-11-17 10:27:48）
 *
 *  @return 星期（例：周四）
 */
+ (NSString *)dateWeekdayForDate:(NSString *)inputDateStr;

/**
 *  计算两个日期天数差
 *
 *  @param fromDataString 从哪天（例：2016-11-13 10:27:48）
 *  @param toDateString   到哪天（例：2016-11-17 10:27:48）
 *
 *  @return 天数差绝对值（例：4）
 */
+ (NSString *)dateIntervalBetweenfromDate:(NSString *)fromDataString toDate:(NSString *)toDateString;

/**
 *  日期格式化Type1 - 与当前日期进行比较
 *
 *  @param dateStr 日期（例：2016-11-16 10:27:48）
 *
 *  @return 格式化后的时间字符串（例：1天前）
 */
+ (NSString *)dateFormatDateType1:(NSString *)dateStr;

/**
 *  日期格式化Type2 - 与当前日期进行比较
 *
 *  @param dateStr 日期（例：2016-11-16 10:27:48）
 *
 *  @return 格式化后的时间字符串（例：昨天 10:55）
 */
+ (NSString *)dateFormatDateType2:(NSString *)dateStr;

@end
