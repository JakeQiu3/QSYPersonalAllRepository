//
//  RightColViewDelegate.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
// 协议和方法的声明 类
@protocol LeftLabRightColViewSelectDelegate <NSObject>

#pragma  mark 点击rightCol或者tab的方法的tableviewcell的代理方法
- (void)selectedCategoryName:(NSString *)categoryName
                      categoryValue:(NSString *)categoryValue;
@end
