//
//  TestJSObject.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/28.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TestJSObject.h"

@implementation TestJSObject
//此处我们测试几种参数的情况
-(void)TestNOParameter {
     NSLog(@"this is ios TestNOParameter");
}

-(void)TestOneParameter:(NSString *)message {
    NSLog(@"this is ios TestOneParameter=%@",message);
}

-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2 {
    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
}


@end
