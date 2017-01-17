//
//  XFNewsListModel.h
//  XFNewsContentDemo
//  该html中底部：新增的列表的data数据源模型
//  Created by qsy on 16/8/19.
//  Copyright © 2016 www.maxthon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFNewsListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *sourceURL;

@property (nonatomic, weak, readonly) NSString *displayTime;
// 时间戳转化为字符串：包括各种枚举的样式
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval;

@end
