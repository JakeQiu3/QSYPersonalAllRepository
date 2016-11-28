//
//  UIImage+Resizable.m
//  qq
//
//  Created by MS on 15-8-20.
//  Copyright (c) 2015年 LB. All rights reserved.
//

#import "UIImage+Resizable.h"

@implementation UIImage (Resizable)


//聊天气泡背景拉伸
+(UIImage *)resizableImage:(NSString *)name{
    UIImage *image = [UIImage imageNamed:imageName];
    //自适应：宽度百分之50，高度百分之50
    image =  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return image;
}

@end
