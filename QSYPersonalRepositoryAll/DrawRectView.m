//
//  DrawRectView.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/31.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "DrawRectView.h"

@implementation DrawRectView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    NSString *str = @"我就是看看不说话";
    [str drawInRect:CGRectMake(0, 0, rect.size.width, 2*rect.size.height/3) withAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
    UIImage *marginImage = [UIImage imageNamed:@"navigation_close.png"];
    [marginImage drawInRect:CGRectMake(0, 2*rect.size.height/3, 20, 20)];
}
/*
*/

@end
