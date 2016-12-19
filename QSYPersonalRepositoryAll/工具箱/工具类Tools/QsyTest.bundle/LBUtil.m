//
//  LBUtil.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/15.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBUtil.h"
#import "LBMD5.h"
#import "LBValidate.h"
#import "LBDate.h"
#import "LBTransform.h"
#import "LBFormat.h"
#import "LBCommon.h"

@implementation LBUtil

#pragma mark - LBValidate

+ (BOOL)lb_validate_stringisNil:(NSString*)string{
    return [LBValidate validateStringisNil:string];
}

+ (BOOL)lb_validate_isString:(id)obj{
    return [LBValidate validateIsString:obj];
}

+ (BOOL)lb_validate_isNullObject:(id)obj{
    return [LBValidate validateIsNullObject:obj];
}

+ (BOOL)lb_validate_isDictObj:(id)obj{
    return [LBValidate validateIsDictObj:obj];
}

+ (BOOL)lb_validate_isAryObj:(id)obj{
    return [LBValidate validateIsAryObj:obj];
}

+ (BOOL)lb_validate_isNumber:(NSString *)number{
    return [LBValidate validateIsNumber:number];
}

+ (BOOL)lb_validate_isEmail:(NSString *)email{
    return [LBValidate validateIsEmail:email];
}

+ (BOOL)lb_validate_isMobileNumber:(NSString *)mobileNum{
    return [LBValidate validateIsMobileNumber:mobileNum];
}

+ (BOOL)lb_validate_isPhone:(NSString *)phone{
    return [LBValidate validateIsPhone:phone];
}

+ (BOOL)lb_validate_isIDCardNumber:(NSString *)idNumber{
    return [LBValidate validateIsIDCardNumber:idNumber];
}

+ (NSString *)lb_empty_stringIsNil:(NSString *)string{
    return [LBValidate emptyStringIsNil:string];
}

+ (NSString *)lb_empty_dictKey:(NSDictionary *)dict key:(NSString *)key{
    return [LBValidate emptyDictKey:dict key:key];
}


#pragma mark - LBMD5

+ (NSString *)lb_md5_str:(NSString *)string{
    return [LBMD5 md5ForStr:string];
}

+ (NSString *)lb_md5_fileContent:(NSString *)filePath{
    return [LBMD5 md5ForFileContent:filePath];
}

+ (NSString *)lb_md5_data:(NSData *)data{
    return [LBMD5 md5ForData:data];
}


#pragma mark - LBDate

+ (NSString *)lb_date_currentTime {
    return [LBDate dateCurrentTime];
}

+ (NSInteger)lb_date_DaysInMonth:(NSString *)dateStr{
    return [LBDate dateDaysInMonth:dateStr];
}

+ (long long)lb_date_timeToMilliSeconds:(NSString *)dateString{
    return [LBDate DateTimeToMilliSeconds:dateString];
}

+ (NSDate *)lb_date_milliSecondsToTime:(long long)miliSeconds{
    return [LBDate dateMilliSecondsToTime:miliSeconds];
}

+ (NSString *)lb_date_weekdayForDateNumber:(NSString *)inputDateStr{
    return [LBDate dateWeekdayForDateNumber:inputDateStr];
}

+ (NSString *)lb_date_weekdayForDate:(NSString *)inputDateStr{
    return [LBDate dateWeekdayForDate:inputDateStr];
}

+ (NSString *)lb_date_intervalBetweenfromDate:(NSString *)fromDataString toDate:(NSString *)toDateString{
    return [LBDate dateIntervalBetweenfromDate:fromDataString toDate:toDateString];
}

+ (NSString *)lb_date_formatDateType1:(NSString *)dateStr{
    return [LBDate dateFormatDateType1:dateStr];
}

+ (NSString *)lb_date_formatDateType2:(NSString *)dateStr{
    return [LBDate dateFormatDateType2:dateStr];
}


#pragma mark - LBTransform

+ (NSString *)lb_transform_dictOrAryToJSONString:(id)dictOrAry{
    return [LBTransform transformDictOrAryToJSONString:dictOrAry];
}

+ (NSDictionary *)lb_transform_JSONToDict:(NSString *)jsonString{
    return [LBTransform transformJSONToDict:jsonString];
}

+ (NSString*)urlEncodeStringCF:(NSString*)string{
    return [LBTransform urlEncodeStringCF:string];
}

+ (NSString *)urlDecodedStringCF:(NSString *)string{
    return [LBTransform urlDecodedStringCF:string];
}

+ (NSString*)urlEncodeStringUTF8:(NSString*)string{
    return [LBTransform urlEncodeStringUTF8:string];
}

+ (NSString *)urlDecodedStringUTF8:(NSString *)string{
    return [LBTransform urlDecodedStringUTF8:string];
}

+ (NSString *)lb_transformFullToHalfString:(NSString *)string{
    return [LBTransform transformFullToHalfString:string];
}

+ (NSString *)lb_transformHalfToFullString:(NSString *)string{
    return [LBTransform transformHalfToFullString:string];
}


#pragma mark - LBFormat

+ (NSString *)lb_format_Value:(float)value Decimal:(NSString *)decimal{
    return [LBFormat formatWithValue:value Decimal:decimal];
}

+ (NSString *)lb_format_valuePercent:(id)valueText smallPoint:(NSInteger)smallPoint{
    return [LBFormat formatValuePercent:valueText smallPoint:smallPoint];
}

+ (NSString *)lb_html_entityDecode:(NSString *)string{
    return [LBFormat htmlEntityDecode:string];
}

+ (NSString *)lb_html_Filter:(NSString *)html{
    return [LBFormat htmlFilter:html];
}


#pragma mark - LBCommon

+ (UIViewController *)lb_getCurrentViewController{
    return [LBCommon getCurrentViewController];
}

+ (UIWindow *)lb_getMainWindow{
    return [LBCommon getMainWindow];
}

+ (UIViewController *)lb_getTopViewController:(UIViewController *)viewController{
    return [LBCommon getTopViewController:viewController];
}

+ (UIView*)lb_getFirstResponderView:(UIView *)view{
    return [LBCommon getFirstResponderView:view];
}

+ (NSString *)lb_getLanguageUsing{
    return [LBCommon getLanguageUsing];
}

+ (NSArray *)lb_getLanguageSupport{
    return [LBCommon getLanguageSupport];
}

+ (CGSize)lb_getBigSize:(NSString *)string font:(UIFont *)font width:(CGFloat)width{
    return [LBCommon getBigSize:string font:font width:width];
}


@end
