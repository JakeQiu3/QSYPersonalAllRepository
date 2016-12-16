//
//  NSString+LBHash.h
//
//
//  Created by qsy on 15/7/5.
//  Copyright (c) 2015年 qsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LBHash)

#pragma mark - 散列函数
/**
 *  计算MD5散列结果
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)lb_hashMD5String;

/**
 *  计算SHA1散列结果
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)lb_hashSHA1String;

/**
 *  计算SHA256散列结果
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)lb_hashSHA256String;

/**
 *  计算SHA 512散列结果
 *  @return 128个字符的SHA 512散列字符串
 */
- (NSString *)lb_hashSHA512String;


#pragma mark - HMAC 散列函数

/**
 *  计算HMAC MD5散列结果 
 *  @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)lb_hashHmacMD5StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA1散列结果
 *  @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)lb_hashHmacSHA1StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA256散列结果
 *  @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)lb_hashHmacSHA256StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA512散列结果
 *  @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)lb_hashHmacSHA512StringWithKey:(NSString *)key;


#pragma mark - 文件散列函数

/**
 *  计算文件的MD5散列结果
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)lb_hashFileMD5;

/**
 *  计算文件的SHA1散列结果
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)lb_hashFileSHA1;

/**
 *  计算文件的SHA256散列结果
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)lb_hashFileSHA256;

/**
 *  计算文件的SHA512散列结果
 *  @return 128个字符的SHA512散列字符串
 */
- (NSString *)lb_hashFileSHA512;



/**
 返回base64编码的字符串内容
 */
- (NSString *)base64encode;

/**
 返回base64解码的字符串内容
 */
- (NSString *)base64decode;


@end
