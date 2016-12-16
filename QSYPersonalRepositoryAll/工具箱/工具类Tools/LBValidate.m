//
//  LBValidate.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/16.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBValidate.h"

@implementation LBValidate

+ (BOOL)validateStringisNil:(NSString*)string{
    NSString *temp=[NSString stringWithFormat:@"%@",string];
    if (!temp||[temp isEqualToString:@""]||[temp isEqualToString:@"null"]||[temp isEqualToString:@"NULL"]||[temp isEqualToString:@"nil"]||[temp isEqualToString:@"(null)"]){
        return YES;
    }
    return NO;
}

+ (BOOL)validateIsString:(id)obj{
    if (!obj||[obj isEqual:[NSNull null]]) return NO;
    NSString *objString = [NSString stringWithFormat:@"%@",obj];
    if ([LBValidate validateStringisNil:objString]) return NO;
    return YES;
}

+ (BOOL)validateIsNullObject:(id)obj{
    if (!obj||[obj isEqual:[NSNull null]]) return YES;
    return NO;
}

+ (BOOL)validateIsDictObj:(id)obj{
    if (!obj||[obj isEqual:[NSNull null]])return NO;
    if (![obj isKindOfClass:[NSDictionary class]]) return NO;
    return YES;
}

+ (BOOL)validateIsAryObj:(id)obj{
    if (!obj||[obj isEqual:[NSNull null]]) return NO;
    if (![obj isKindOfClass:[NSArray class]]) return NO;
    return YES;
}

+ (BOOL)validateIsNumber:(NSString *)number{
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *reg = @"^[0-9]*[1-9][0-9]*$";
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [numberPredicate evaluateWithObject:number];
}

+ (BOOL)validateIsEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateIsMobileNumber:(NSString *)mobileNum{
    //手机号以13、15、18开头，八个\d数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}

+ (BOOL)validateIsPhone:(NSString *)phone{
    /**
     * 手机号码(11位)
     * 移动(China Mobile)：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通(China Unicom)：130,131,132,152,155,156,185,186
     * 电信(China Telecom)：133,1349,153,180,189
     *
     * 大陆地区固话及小灵通(7位或8位) - PHS
     * 区号：010,020,021,022,023,024,025,027,028,029
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES)) return YES;
    else return NO;
}

+ (BOOL)validateIsIDCardNumber:(NSString *)idNumber {
    idNumber = [idNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger length =0;
    if (!idNumber) return NO;
    else{
        length = idNumber.length;
        if (length !=15 && length !=18) return NO;
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [idNumber substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) return false;
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length){
        case 15:
            year = [idNumber substringWithRange:NSMakeRange(6,2)].intValue +1900;
            //测试出生日期的合法性
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            else  regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            numberofMatch = [regularExpression numberOfMatchesInString:idNumber options:NSMatchingReportProgress range:NSMakeRange(0, idNumber.length)];
            if(numberofMatch >0) return YES;
            else return NO;
        case 18:{
            year = [idNumber substringWithRange:NSMakeRange(6,4)].intValue;
            //测试出生日期的合法性
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive  error:nil];
            else regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];
            
            numberofMatch = [regularExpression numberOfMatchesInString:idNumber options:NSMatchingReportProgress range:NSMakeRange(0, idNumber.length)];
            if(numberofMatch >0) {
                int S = ([idNumber substringWithRange:NSMakeRange(0,1)].intValue + [idNumber substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([idNumber substringWithRange:NSMakeRange(1,1)].intValue + [idNumber substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([idNumber substringWithRange:NSMakeRange(2,1)].intValue + [idNumber substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([idNumber substringWithRange:NSMakeRange(3,1)].intValue + [idNumber substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([idNumber substringWithRange:NSMakeRange(4,1)].intValue + [idNumber substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([idNumber substringWithRange:NSMakeRange(5,1)].intValue + [idNumber substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([idNumber substringWithRange:NSMakeRange(6,1)].intValue + [idNumber substringWithRange:NSMakeRange(16,1)].intValue) *2 + [idNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [idNumber substringWithRange:NSMakeRange(8,1)].intValue *6 + [idNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[idNumber substringWithRange:NSMakeRange(17,1)]]) return YES;// 检测ID的校验位
                else return NO;
            }
            else return NO;
        }
        default:
            return false;
    }
}

+ (NSString *)emptyStringIsNil:(NSString *)string{
    NSString *temp = [NSString stringWithFormat:@"%@",string];
    if (!temp || [temp isEqualToString:@""] || [temp isEqualToString:@"null"] || [temp isEqualToString:@"NULL"] || [temp isEqualToString:@"nil"]||[temp isEqualToString:@"(null)"] || [temp isEqualToString:@"<null>"]){
        return @"";
    }
    return temp;
}

+ (NSString *)emptyDictKey:(NSDictionary *)dict key:(NSString *)key{
    if (![[dict allKeys]containsObject:key]) return @"";
    return dict[key];
}


@end
