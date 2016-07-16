//
//  TestSynthesize.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/16.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestSynthesize : NSObject
// 问题1： 重写title属性的setter和getter方法：造成系统不会autoSynthesize 变量。
// 解决办法：1.手动创建 ivar； 2. 使用@synthesize foo = _foo, 关联@property 与 ivar。见下

// 问题2：@synthesize还有哪些使用场景？
// 解决办法：同时重写了 setter 和 getter 时；使用了 @dynamic 时；重写了只读属性的 getter 时;在 @protocol 中定义的所有属性；在 category 中定义的所有属性；重载的属性。
{
    NSString *_title;
}
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;

@end
