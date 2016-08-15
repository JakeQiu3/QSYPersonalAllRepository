//
//  RightColHeaderResuableView.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "RightColHeaderResuableView.h"

static CGFloat const leftMargin = 10.0f;

@implementation RightColHeaderResuableView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0, frame.size.width - leftMargin, frame.size.height)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.label.textAlignment = 0;
        self.label.font = [UIFont boldSystemFontOfSize:14.0f];
        self.label.textColor = [UIColor blackColor];
        [self addSubview:self.label];
    }
    
    return self;
}

// 重用时，把盘子清空
- (void)prepareForReuse {
    [super prepareForReuse];
    self.label.text = nil;
}

@end
