//
//  LBDate.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBDate.h"

static NSString *DATE_FORMATE=@"yyyy-MM-dd HH:mm:ss";// 若hh为小写，则是12小时制的时间。
@implementation LBDate

+ (NSString *)dateCurrentTime{
    NSDate * date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];// 若 hh为小写则为12小时制的时间。
    NSString *currentTimeString = [dateFormatter stringFromDate:date];
    return currentTimeString;
}

+ (NSInteger)dateDaysInMonth:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:[dateFormatter dateFromString:dateStr]];
    return range.length;
}

+ (long long)DateTimeToMilliSeconds:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//指定区时为东8区
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:DATE_FORMATE];
    NSDate *date =[dateFormatter dateFromString:dateString];
    
    //时间戳、1479469093.000000
    NSTimeInterval interval = [date timeIntervalSince1970];
    //总毫秒数、1479469093000
    long long totalMilliseconds = interval*1000;
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

+ (NSDate *)dateMilliSecondsToTime:(long long)miliSeconds{
    NSTimeInterval tempMilli = miliSeconds;
    //传入的时间戳(这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致)
    NSTimeInterval seconds = tempMilli/1000.0;
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

+ (NSString *)dateWeekdayForDateNumber:(NSString *)inputDateStr{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_FORMATE];
    NSDate *date =[dateFormat dateFromString:inputDateStr];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%ld",(long)theComponents.weekday];
}

+ (NSString *)dateWeekdayForDate:(NSString *)inputDateStr{
    // 此处可自定义，将星期数转换成对应内容
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    return [weekdays objectAtIndex:[[LBDate dateWeekdayForDateNumber:inputDateStr] intValue]];
}

+ (NSString *)dateIntervalBetweenfromDate:(NSString *)fromDataString toDate:(NSString *)toDateString{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:fromDataString]];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[dateFormatter dateFromString:toDateString]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    // 取天数差的绝对值
    NSString *day=[NSString stringWithFormat:@"%@",@(dayComponents.day)];
    day=[day stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return day;
}

+ (NSString *)dateFormatDateType1:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    NSDate *pTimeDate = [dateFormatter dateFromString:dateStr];
    NSTimeInterval seconds = -[pTimeDate timeIntervalSinceNow];
    NSString *datePastString;
    if (seconds < 60) {
        datePastString = [NSString stringWithFormat:@"%ld秒前",(unsigned long)seconds];
    }
    else if (seconds >= 60 && seconds < 3600) {
        datePastString = [NSString stringWithFormat:@"%ld分钟前",(unsigned long)seconds / 60];
    }
    else if (3600 <= seconds && seconds < 24 * 3600) {
        datePastString = [NSString stringWithFormat:@"%ld小时前",(unsigned long)seconds / 3600];
    }
    else if (seconds >= 24 * 3600 && seconds < 24 * 30 * 3600) {
        datePastString = [NSString stringWithFormat:@"%ld天前",(unsigned long)seconds / 3600 / 24];
    }
    else if (seconds >= 30 * 24 * 3600) {
        datePastString = [NSString stringWithFormat:@"%ld个月前",(unsigned long)seconds / 3600 / 24 / 30];
    }
    return datePastString;
}

+ (NSString *)dateFormatDateType2:(NSString *)dateStr{
    NSString * timeSinceTimeString;
    NSDate *nowDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    NSDate *targetDate = [dateFormatter dateFromString:dateStr];
    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
    NSString *todayDateString = [NSString stringWithFormat:@"%@ 00:00:00",[nowDateString substringToIndex:10]];
    NSTimeInterval durationFromToday = [[dateFormatter dateFromString:todayDateString] timeIntervalSinceDate:targetDate];
    NSTimeInterval duration = [nowDate timeIntervalSinceDate:targetDate];
    if (duration / 60.0f < 2.0f) {
        timeSinceTimeString = @"1分钟前";
    }
    else if (duration / 60 >= 2.0f && duration / 60 < 60.0f) {
        timeSinceTimeString = [NSString stringWithFormat:@"%ld分钟前",(long)(duration / 60.0f)];
    }
    else if (duration / 60.0f / 60.0f >= 1.0f && duration < [nowDate timeIntervalSinceDate:[dateFormatter dateFromString:todayDateString]]) {
        timeSinceTimeString = [NSString stringWithFormat:@"%ld小时前",(long)(duration / 60.0f / 60.0f)];
    }
    else if (durationFromToday && durationFromToday / 60.0f / 60.0f / 24.0f < 1.0f) {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeSinceTimeString = [dateFormatter stringFromDate:targetDate];
        timeSinceTimeString = [NSString stringWithFormat:@"昨天 %@",timeSinceTimeString];
    }
    else if (durationFromToday / 60.0f / 60.0f / 24.0f > 1 && [[dateStr substringToIndex:4] integerValue] == [[nowDateString substringToIndex:4] integerValue]) {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        timeSinceTimeString = [dateFormatter stringFromDate:targetDate];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeSinceTimeString = [dateFormatter stringFromDate:targetDate];
    }
    return timeSinceTimeString;
}

@end
