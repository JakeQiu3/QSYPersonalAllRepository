//
//  XFHTMLConfigurator.h
//  XFNewsContentDemo
//  功能：把数组模型转化为html可识别的标签；把可识别的html字符串转化为具体的数组模型
//  Created by qsy on 16/8/24.
//  Copyright © 2016年 maxthon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFContentFragmentModel.h"

@interface XFHTMLConfigurator : NSObject

+ (NSString *)connectToHTMLStringWith:(NSArray<XFContentFragmentModel *> *)fragmentModels;

+ (NSArray<XFContentFragmentModel *> *)breakHTMLFrom:(NSString *)htmlString;

@end
