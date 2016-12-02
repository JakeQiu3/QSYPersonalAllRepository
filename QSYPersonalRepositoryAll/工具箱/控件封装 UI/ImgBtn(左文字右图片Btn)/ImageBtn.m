
//
//  ImageBtn.m

//  Created by 邱少依 on 16/7/14.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ImageBtn.h"

@implementation ImageBtn


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image imageWH:(CGFloat)imgWH margin:(CGFloat)margin {
    self = [super initWithFrame:frame];
    if (self) {
//       添加label
        _qsytitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _qsytitle.numberOfLines = 0;
        _qsytitle.font = [UIFont systemFontOfSize:14.f];
        _qsytitle.backgroundColor = [UIColor clearColor];
        _qsytitle.text = title;
        CGSize size = [_qsytitle.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
//_qsytitle与图片、按钮边缘间隔都是margin,图片大小imgWH*imgWH
        if (size.width>self.frame.size.width-margin*3-imgWH) {
            size.width =self.frame.size.width-margin*3-imgWH;
        }
        _qsytitle.frame = CGRectMake(margin, 0, size.width, self.frame.size.height);
        [self addSubview:_qsytitle];
//    添加image
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(_qsytitle.frame.size.width + _qsytitle.frame.origin.x + margin, (self.frame.size.height-imgWH)/2, imgWH, imgWH)];
        _imageV.image = image;
        _imageV.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageV];
    }
    return self;
}

- (void)resetdata:(NSString *)title :(UIImage *)Image imageWH:(CGFloat)imgWH margin:(CGFloat)margin {
    _qsytitle.text = title;
    CGSize size = [_qsytitle.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
    if (size.width>self.frame.size.width-margin*3-imgWH) {
        size.width =self.frame.size.width-margin*3-imgWH;
    }
    _qsytitle.frame = CGRectMake(margin, 0, size.width, self.frame.size.height);
    _imageV.frame = CGRectMake(_qsytitle.frame.size.width+_qsytitle.frame.origin.x+margin, (self.frame.size.height-imgWH)/2, imgWH, imgWH);
}


@end
