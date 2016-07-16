//
//  AutoModel.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/6/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TestModel : NSObject
@property (nonatomic, copy)NSString *textStr;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, assign) CGFloat cellHeight;
// 字典转模型
- (TestModel *)initWithDic:(NSDictionary *)dic;
+ (TestModel *)initWithDic:(NSDictionary *)dic;


@end
