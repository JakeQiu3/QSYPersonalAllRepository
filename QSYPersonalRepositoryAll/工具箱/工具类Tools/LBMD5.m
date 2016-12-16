//
//  LBMD5.m
//
//
//  Created by qsy on 15-8-20.
//  Copyright (c) 2014年 qsy. All rights reserved.
//

#import "LBMD5.h"

@implementation LBMD5

+ (NSString *)md5ForStr:(NSString *)string{
	if (string == nil) return nil;
	const char *cstr = [string UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cstr, (unsigned int)strlen(cstr), result);
	return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]];
}

+ (NSString *)md5ForFileContent:(NSString *)filePath{
	if(!filePath) return nil;
	NSData * data = [NSData dataWithContentsOfFile:filePath];
	return [LBMD5 md5ForData:data];
}

+ (NSString *) md5ForData:(NSData *)data{
	if( !data || ![data length] ) return nil;
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (unsigned int)[data length], result);
	return [NSString stringWithFormat:
    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}


@end

