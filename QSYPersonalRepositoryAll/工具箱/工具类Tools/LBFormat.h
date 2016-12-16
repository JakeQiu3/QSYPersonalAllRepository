//
//  LBFormat.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：格式化处理
 */
#import <Foundation/Foundation.h>

@interface LBFormat : NSObject

/**
 *  数值四舍五入
 *
 *  @param value   要格式化的数值（例：5.235）
 *  @param decimal 保留的位数，小数位代表保留个数（例：0.00）
 *
 *  @return 格式化后的字符串（例：5.24）
 */
+ (NSString *)formatWithValue:(float)value Decimal:(NSString *)decimal;


/**
 *  数值的百分化 - 带四舍五入
 *
 *  @param valueText  要格式化的数值（例：0.812145）
 *  @param smallPoint 保留几位小数点（例：2）
 *
 *  @return 格式化后的字符串（例：81.21%）
 */
+ (NSString *)formatValuePercent:(id)valueText smallPoint:(NSInteger)smallPoint;


/**
 *  html标签替换
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)htmlEntityDecode:(NSString *)string;


/**
 *  html标签替换后的识别
 *
 *  @param html <#html description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)htmlFilter:(NSString *)html;

    
@end
