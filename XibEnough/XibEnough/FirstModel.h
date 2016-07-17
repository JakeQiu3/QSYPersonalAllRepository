//
//  FirstModel.h
//  XibEnough
//
//  Created by qsyMac on 16/7/10.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FirstModel : NSObject
//定义plist文件中的keys
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,assign,getter=isVip) BOOL vip;
//定义cell的行高
@property(nonatomic,assign) CGFloat cellHeight;

//构造方法,方便外界创建模型数据
- (instancetype)initWithDicit:(NSDictionary *)dic;
+ (instancetype)firstModelWithDict:(NSDictionary *)dic;

@end
