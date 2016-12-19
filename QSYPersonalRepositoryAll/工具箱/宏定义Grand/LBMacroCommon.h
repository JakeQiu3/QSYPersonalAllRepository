//
//  LBMacroCommon.h
//
//
//  Created by qsy on 16/11/10.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：通用宏
 */
#ifndef LBMacroCommon_h
#define LBMacroCommon_h


//-------------------设备信息-------------------------
// version 版本号
#define KVERSION  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

// SystemVersion 系统版本号
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0

//设备型号
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )
//-------------------设备信息-------------------------






//-------------------常用字体-------------------------
//系统默认字体大小
#define KSystemFont(fontsize)  [UIFont systemFontOfSize:fontsize]

#define KFont20 [UIFont systemFontOfSize:20]
#define KFont19 [UIFont systemFontOfSize:19]
#define KFont18 [UIFont systemFontOfSize:18]
#define KFont17 [UIFont systemFontOfSize:17]
#define KFont16 [UIFont systemFontOfSize:16]
#define KFont15 [UIFont systemFontOfSize:15]
#define KFont14 [UIFont systemFontOfSize:14]
#define KFont13 [UIFont systemFontOfSize:13]
#define KFont12 [UIFont systemFontOfSize:12]
#define KFont11 [UIFont systemFontOfSize:11]
#define KFont10 [UIFont systemFontOfSize:10]
//-------------------常用字体-------------------------






//-------------------常用颜色-------------------------
//(0x000000ff)
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
//(0x000000, 0.2)
#define HEXCOLORALPHA(hex, alpha) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define KRGBCOLOR(r,g,b)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define KRGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

//颜色 透明
#define KCOLORCLEAR [UIColor clearColor]
//颜色 白色
#define KCOLORWHITE [UIColor whiteColor]
//颜色 黑色
#define KCOLORBLACK [UIColor blackColor]

//常用背景灰
#define KColorBGF0 HEXCOLOR(0xf0f0f0ff)
//常用文字辅助灰
#define KColorFont80 HEXCOLOR(0x808080ff)
//-------------------常用颜色-------------------------






//-------------------距离尺寸-------------------------
#define KScreenB [UIScreen mainScreen].bounds
#define KScreenH [UIScreen mainScreen].bounds.size.height
#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KHeightTabbar 49

// 自适应宽度（以6s为标准）
#define ADAPTER_WIDTH_BASE(v)       floor((v) / 375.f * [UIScreen mainScreen].bounds.size.width)
// 自适应高度（以6s为标准）
#define ADAPTER_HEIGHT_BASE(v)      floor((v) / 667.f * [UIScreen mainScreen].bounds.size.height)

//get the right bottom origin's x,y of a view
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height )


//get the left top origin's x,y of a view
#define VIEW_X(view) (view.frame.origin.x)
#define VIEW_Y(view) (view.frame.origin.y)
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//get the x,y of the frame
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)
#define FRAME_TW(frame)  (frame.size.width)
#define FRAME_TH(frame)  (frame.size.height)
//-------------------距离尺寸-------------------------






//-------------------打印-------------------------
//LOG一些坐标
#define LogFrame(frame) NSLog(@"frame[X=%.1f,Y=%.1f,W=%.1f,H=%.1f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
#define LogPoint(point) NSLog(@"Point[X=%.1f,Y=%.1f]",point.x,point.y)

//调试打印：类调用了什么方法、行数、方法名
#define LogDebug(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//-------------------打印-------------------------






//-------------------其他------------------------
// 弱引用自身，调用时直接在里面起个名字
#define KWeakSelf(weakSelf)    __weak __typeof(&*self) weakSelf = self;

// 设置view隐藏
#define KHideViewIfExist(view)      {!view ? : [view setHidden:YES];}

// 移除view
#define KRemoveViwIfExist(view)      {if(view && [view superview]) {[view removeFromSuperview]; view = nil;}}
//-------------------其他-------------------------



#endif /* LBMacroCommon_h */
