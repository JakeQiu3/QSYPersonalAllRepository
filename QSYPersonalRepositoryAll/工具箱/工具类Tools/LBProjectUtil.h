//
//  LBProjectUtil.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：项目相关帮助类
 */
#import <Foundation/Foundation.h>

@interface LBProjectUtil : NSObject

/**
 * 存储设备Token
 */
+ (void)tokenStore:(NSString *)token;

/**
 * 清除设备token
 */
+ (void)tokenClean;

/**
 * 获取设备token
 */
+ (NSString *)tokenGet;

@end
