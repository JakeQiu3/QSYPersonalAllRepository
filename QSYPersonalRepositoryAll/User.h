//
//  User.h
//  LessonUI19Day
//
//  Created by qsy on 15/7/3.
//  Copyright (c) 2015年 qsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//对可变字符串声明属性时，建议使用copy；防止他会变成一个不可变字符串；
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;

@end
