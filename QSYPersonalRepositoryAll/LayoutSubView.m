//
//  LayoutSubView.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/31.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "LayoutSubView.h"

@implementation LayoutSubView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectNull];
    _nameLabel.text = @"加油";
    _nameLabel.textColor = [UIColor greenColor];
    [self addSubview:_nameLabel];
}

- (void)layoutSubviews {
    NSLog(@"layoutSubView");
    _nameLabel.frame = CGRectMake(0, 0,50,30);
}


@end
