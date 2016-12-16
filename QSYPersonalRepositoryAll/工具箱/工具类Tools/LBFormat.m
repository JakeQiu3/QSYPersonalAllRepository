//
//  LBFormat.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBFormat.h"
#import <UIKit/UIKit.h>

@implementation LBFormat

+ (NSString *)formatWithValue:(float)value Decimal:(NSString *)decimal{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:decimal];
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

+ (NSString *)formatValuePercent:(id)valueText smallPoint:(NSInteger)smallPoint{
    CGFloat floatValue = [valueText floatValue]*100;
    NSString *stringValue = [NSString stringWithFormat:@"%.2f",floatValue];
    if (smallPoint == 0) {
        stringValue = [NSString stringWithFormat:@"%.0f",floatValue];
    }else if(smallPoint == 3){
        stringValue = [NSString stringWithFormat:@"%.3f",floatValue];
    }else if(smallPoint == 1){
        stringValue = [NSString stringWithFormat:@"%.1f",floatValue];
    }
    return [NSString stringWithFormat:@"%@%%",stringValue];
}

+ (NSString *)htmlEntityDecode:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return string;
}

+ (NSString *)htmlFilter:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //标签的起始位置到结束为止，替换字符
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@""];
    return html;
}

@end
