//
//  ClearCacheObject.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/4/29.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "GetCacheObject.h"

@implementation GetCacheObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (float )folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

- (float) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    long long singleFileSize = 0;
    if ([manager fileExistsAtPath:filePath]){
        singleFileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        return singleFileSize/(1024.0*1024.0);
    }
    return 0;
}

- (BOOL)removeFloderOrFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:path error:&error];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"移除失败");
        return NO;
    } else NSLog(@"移除成功");
    return YES;
    
}


@end
