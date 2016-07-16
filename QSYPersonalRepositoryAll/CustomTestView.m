//
//  CustomTest.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CustomTestView.h"

@implementation CustomTestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
// init code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code ：手动调用 setneedDisplay 或者在viewwillAppear 后执行
}


@end
