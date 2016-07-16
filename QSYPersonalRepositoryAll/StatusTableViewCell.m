//
//  StatusTableViewCell.m
//  tableview使用大全
//
//  Created by 邱少依 on 15/12/25.
//  Copyright © 2015年 QSY. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "WeiboStatus.h"

#define kColor(r,g,b,a) [UIColor colorWithHue:r/255.0 saturation:g/255.0 brightness:b/255.0 alpha:a] //颜色宏定义
#define kStatusTableViewCellSpacing 10 //控件间距
#define kStatusTableViewCellBackgroundColor kColor(251,251,251,1.0)
#define kStatusGrayColor kColor(50,50,50,1.0)
#define kStatusLightGrayColor kColor(120,120,120,1.0)

#define kStatusTableViewCellAvatarWH 40 //头像宽度和高度
#define kStatusTableViewCellMbTypeWH 13 //会员图标宽度和高度
#define kStatusTableViewCellTextFontSize 14
@interface StatusTableViewCell()
{
    UIImageView *_avatarImageView;
    UIImageView *_mbTypeImageView;
    UILabel *_userNameLabel;
    UILabel *_creatTimeLabel;
    UILabel *_fromSourceLabel;
    UILabel *_textLabel;
}

// 对于单行文本数据的显示调用- (CGSize)sizeWithAttributes:(NSDictionary *)attrs;方法来得到文本宽度和高度。

// 对于多行文本数据的显示调用- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context ;方法来得到文本宽度和高度；同时注意在此之前需要设置文本控件的numberOfLines属性为0。
@end
@implementation StatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _avatarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_avatarImageView];
    
    _mbTypeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_mbTypeImageView];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textColor = kStatusGrayColor;
    _userNameLabel.font=[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    [self.contentView addSubview:_userNameLabel];
    
    _creatTimeLabel = [[UILabel alloc] init];
    _creatTimeLabel.textColor = kStatusGrayColor;
    _creatTimeLabel.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    [self.contentView addSubview:_creatTimeLabel];
    
    _fromSourceLabel = [[UILabel alloc] init];
    _fromSourceLabel.textColor = kStatusLightGrayColor;
    _fromSourceLabel.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    [self.contentView addSubview:_fromSourceLabel];
    
    _textLabel=[[UILabel alloc]init];
    _textLabel.textColor=kStatusGrayColor;
    _textLabel.font=[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    _textLabel.numberOfLines=0;
    [self.contentView addSubview:_textLabel];
}

//set方法，设置frame和赋值
- (void)setWeiboStatus:(WeiboStatus *)weiboStatus {
    if (_weiboStatus != weiboStatus) {
        _weiboStatus =weiboStatus;
    }
    //设置头像大小和位置
    CGFloat avatarX=10,avatarY=10;
    CGRect avatarRect=CGRectMake(avatarX, avatarY, kStatusTableViewCellAvatarWH, kStatusTableViewCellAvatarWH);
    _avatarImageView.image=[UIImage imageNamed:_weiboStatus.profileImageUrl];
    _avatarImageView.frame=avatarRect;

    //设置名称大小和位置
    CGFloat userNameX= CGRectGetMaxX(_avatarImageView.frame)+kStatusTableViewCellSpacing ;
    CGFloat userNameY=avatarY;
    
    //根据文本内容取得文本占用空间大小
    CGSize userNameSize = [_weiboStatus.userName sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]}];
    
    CGRect userNameRect=CGRectMake(userNameX, userNameY, userNameSize.width,userNameSize.height);
    _userNameLabel.text=_weiboStatus.userName;
    _userNameLabel.frame=userNameRect;
    
    
    //设置会员图标大小和位置
    CGFloat mbTypeX = CGRectGetMaxX(_userNameLabel.frame)+kStatusTableViewCellSpacing;
    CGFloat mbTypeY = avatarY;
    CGRect mbTypeRect=CGRectMake(mbTypeX, mbTypeY, kStatusTableViewCellMbTypeWH, kStatusTableViewCellMbTypeWH);
    _mbTypeImageView.image=[UIImage imageNamed:_weiboStatus.mbtype];
    _mbTypeImageView.frame=mbTypeRect;
    
    
    //设置发布日期大小和位置
    CGSize createAtSize = [_weiboStatus.createdAt sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]}];
    CGFloat createAtX=userNameX;
    CGFloat createAtY = CGRectGetMaxY(_mbTypeImageView.frame) +kStatusTableViewCellSpacing;
    CGRect createAtRect=CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    _creatTimeLabel.text = _weiboStatus.createdAt;
    _creatTimeLabel.frame = createAtRect;
    
    
    //设置设备信息大小和位置
//   计算当行文本的尺寸
    CGSize sourceSize = [_weiboStatus.source sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize],NSForegroundColorAttributeName : [UIColor grayColor]}];
    CGFloat sourceX=CGRectGetMaxX(_creatTimeLabel.frame)+kStatusTableViewCellSpacing;
    CGFloat sourceY=createAtY;
    CGRect sourceRect=CGRectMake(sourceX, sourceY, sourceSize.width,sourceSize.height);
    _fromSourceLabel.text=_weiboStatus.source;
    _fromSourceLabel.frame=sourceRect;
    
    
    //设置微博内容大小和位置
    CGFloat textX=avatarX;
    CGFloat textY=CGRectGetMaxY(_avatarImageView.frame)+kStatusTableViewCellSpacing;
    CGFloat textWidth=self.frame.size.width-kStatusTableViewCellSpacing*2;
//   计算当行文本的尺寸
    CGSize textSize = [_weiboStatus.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
    
    CGRect textRect=CGRectMake(textX, textY, textSize.width, textSize.height);
    _textLabel.frame=textRect;
    _textLabel.text=_weiboStatus.text;
//    cell的高度
    _height=CGRectGetMaxY(_textLabel.frame)+kStatusTableViewCellSpacing;

}

- (void)awakeFromNib {
    // Initialization code
    [self initSubViews];
}

//重写选择事件，取消选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
