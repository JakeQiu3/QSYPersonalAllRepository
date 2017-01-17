//
//  XFContentFragmentModel.h
//  XFNewsContentDemo
// 功能：页面的body内容显示具体的对象模型：其中有2种样式的，可通过枚举的方式表示其中的并列关系。常常通过switch case 或 if判断等来获取到具体某个样式执行逻辑处理。
//  Created by qsy on 16/8/24.
//  Copyright © 2016年 maxthon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XFContentFragmentType) {
    XFContentFragmentTypeText,// 文本
    XFContentFragmentTypeImage //图片
};

@interface XFContentFragmentModel : NSObject

@property (nonatomic, assign) XFContentFragmentType type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *className;


@end
