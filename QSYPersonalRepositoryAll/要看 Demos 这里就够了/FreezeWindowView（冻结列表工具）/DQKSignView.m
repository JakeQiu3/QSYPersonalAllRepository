//
//  DQKFreezeView.m
//  DQKFreezeWindowView
//
//  Created by --- on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKSignView.h"

@interface DQKSignView ()

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation DQKSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentLabel.center = self.center;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

@end
