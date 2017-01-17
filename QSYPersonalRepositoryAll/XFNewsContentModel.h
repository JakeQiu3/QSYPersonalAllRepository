//
//  XFNewsContentModel.h
//  XFNewsContentDemo
//  实现的逻辑：把整个网页的数据拆分成每个具体的对象，然后用一个类来持有该所有的这些对象。
//  Created by qsy on 16/8/19.
//  Copyright © 2016 www.maxthon.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFContentFragmentModel.h"

@interface XFNewsContentModel : NSObject

@property (nonatomic, copy) NSString *source;// 来源
@property (nonatomic, copy) NSString *title;// 标题
@property (nonatomic, copy) NSString *sourceURL;//资源路径
@property (nonatomic, copy) NSString *createdAt;// 创建时间
@property (nonatomic, strong) NSArray<XFContentFragmentModel *> *fragmentModels;// 具体的每个部分模块
@property (nonatomic, copy) NSString *content;// body中显示的内容
@end
