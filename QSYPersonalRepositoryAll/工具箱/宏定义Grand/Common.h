
//
//  Common.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/30.
//  Copyright © 2016年 QSY. All rights reserved.
//

#ifndef Common_h
#define Common_h

// =====================Colors ===========================
//RGB颜色
#define QSYColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//随机色
#define QSYRandomColor  QSYColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(2)/1.0)
// 16进制的颜色
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]
//=======================Views======================
#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

//=======================NSLog======================
#ifdef DEBUG //开发阶段
#define QSYLog(...) NSLog(__VA_ARGS__)
#else //发布阶段(自动注掉打印的内容)
#define QSYLog(...)
#endif
//======================System Version======================
#define iOS7_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//======================Text Info======================
//仅单行显示文本
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif
//多行显示文本
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#endif /* Common_h */
