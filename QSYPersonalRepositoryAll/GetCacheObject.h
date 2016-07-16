//
//  ClearCacheObject.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/4/29.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCacheObject : NSObject

//获取沙盒缓存路径： NSString *Cachepath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

// NSString *path1=[Cachepath stringByAppendingPathComponent:@"邱少一"];

/**
 *  计算文件夹的大小
 *
 *  @param filePath 文件夹的路径
 *
 *  @return 文件夹的大小：单位是M
 */
- (float )folderSizeAtPath:(NSString*) folderPath;

/**
 *  计算某个具体文件的大小
 *
 *  @param filePath 文件的具体路径
 *
 *  @return 文件的大小：单位是M
 */

- (float) fileSizeAtPath:(NSString*) filePath;

/**
 *  移除某个文件夹及其中的所有文件 OR 具体某个文件
 *
 *  @param path 文件夹或文件路径
 *
 *  @return 判断移除情况 YES：移除成功 NO :失败
 */
- (BOOL)removeFloderOrFile:(NSString *)path;


@end
