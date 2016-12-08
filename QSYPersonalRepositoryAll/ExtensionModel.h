//
//  ExtensionModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
typedef enum {
    SexMale,
    SexFemale
} Sex;

@interface ExtensionModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) unsigned int age;
@property (copy, nonatomic) NSString *height;
@property (strong, nonatomic) NSNumber *money;
@property (assign, nonatomic) Sex sex;
@property (assign, nonatomic, getter=isGay) BOOL gay;

+ (instancetype)objectWithKeyValues:(NSDictionary *)dic;
@end
