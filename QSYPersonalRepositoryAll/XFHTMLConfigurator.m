//
//  XFHTMLConfigurator.m
//  XFNewsContentDemo
//
//  Created by qsy on 16/8/24.
//  Copyright © 2016年 maxthon. All rights reserved.
//

#import "XFHTMLConfigurator.h"

@implementation XFHTMLConfigurator

+ (NSString *)connectToHTMLStringWith:(NSArray<XFContentFragmentModel *> *)fragmentModels {
    NSMutableString *htmlString = [NSMutableString string];
    for (XFContentFragmentModel *model in fragmentModels) {
        switch (model.type) {
            case XFContentFragmentTypeText: {
                [htmlString appendFormat:@"<p class=\"%@\">%@</p>", model.className,model.value];
                break;
            } case XFContentFragmentTypeImage: {
                [htmlString appendFormat:@"<img src = '%@' class=\"%@\">", model.value,model.className];
                break;
            } default: {
                break;
            }
        }
    }
    return htmlString;
}

+ (NSArray<XFContentFragmentModel *> *)breakHTMLFrom:(NSString *)htmlString {
    // 可以参考html的解析器进行解析，具体自行百度，本例中只返回一个空数组
    if (htmlString) {
        NSLog(@"%@",htmlString);
    }
    return [NSArray array];
}

@end
