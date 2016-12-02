//
//  NSData+QsyCache.h
//  KNBannerView
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 KNKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSData (QsyCache)
/**
 *  get image Data from DB
 *
 *  @param url URL unique identification
 *
 *  @return data of images
 */
+ (instancetype)getDataFromLocationApplicationCacheWithURL:(NSString *)urlStr;
/**
 *  save image data to DB through MD5
 *
 *  @param url url: URL unique identification
 *
 *  @param image data to save
 */
+ (void)saveDataIntoLocationApplicationCacheWithURL:(NSString *)urlStr image:(UIImage *)image;

+ (void)removeDataWhenReceiveMemeryWarning;

@end
