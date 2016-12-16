//
//  LBMD5.h
//
//
//  Created by qsy on 15-8-20.
//  Copyright (c) 2014年 qsy. All rights reserved.
//

/**
 *  类注释：md5加密
 */
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface LBMD5 : NSObject

/**
 *  md5 加密字符串
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5ForStr:(NSString *)string;

/**
 *  md5 加密文件内容
 *
 *  @param filePath <#filePath description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5ForFileContent:(NSString *)filePath;

/**
 *  md5 加密data
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5ForData:(NSData *)data;

@end

