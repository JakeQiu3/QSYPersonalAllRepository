//
//  LBTransform.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBTransform.h"
#import <UIKit/UIKit.h>

@implementation LBTransform

+ (NSString *)transformDictOrAryToJSONString:(id)dictOrAry{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictOrAry
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

+ (NSDictionary *)transformJSONToDict:(NSString *)jsonString {
    if (jsonString == nil) return nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)urlEncodeStringCF:(NSString*)string{
    NSString*encodedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *)urlDecodedStringCF:(NSString *)string{
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString*)urlEncodeStringUTF8:(NSString*)string{
    NSString *encodedString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}

+ (NSString *)urlDecodedStringUTF8:(NSString *)string{
    NSString *decodedString = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return decodedString;
}

+ (NSString *)transformFullToHalfString:(NSString *)string{
    NSMutableString *convertedString=[string mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString,NULL, kCFStringTransformFullwidthHalfwidth, NO);
    return convertedString;
}

+ (NSString *)transformHalfToFullString:(NSString *)string{
    NSMutableString *convertedString=[string mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString,NULL, kCFStringTransformHiraganaKatakana, NO);
    return convertedString;
}


@end
