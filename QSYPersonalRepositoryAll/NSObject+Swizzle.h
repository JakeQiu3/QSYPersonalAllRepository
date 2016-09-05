//
//  NSObject+Swizzle.h
//  Test
//
//  Created by 邱少依 on 16/9/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (Swizzle)
+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)newSel;
@end
