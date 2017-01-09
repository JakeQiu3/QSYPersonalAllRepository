//
//  NSData+QsyCache.m
//  KNBannerView
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 KNKane. All rights reserved.
//

#import "NSData+QsyCache.h"
#import "NSString+hash.h"
#define QSY_Banner @"BannerCache"
@implementation NSData (QsyCache)
+ (instancetype)getDataFromLocationApplicationCacheWithURL:(NSString *)urlStr {
    NSString *path = [[self getLocationDBPath] stringByAppendingPathComponent:[urlStr md5String]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

+ (void)saveDataIntoLocationApplicationCacheWithURL:(NSString *)urlStr image:(UIImage *)image {
    NSString *path = [[self getLocationDBPath]  stringByAppendingPathComponent:[urlStr md5String]];
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}

+ (void)removeDataWhenReceiveMemeryWarning {
    NSString *path = [self getLocationDBPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

}

+ (NSString *)getLocationDBPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:QSY_Banner];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
@end
