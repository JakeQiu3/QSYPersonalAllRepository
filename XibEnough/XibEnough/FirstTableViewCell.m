//
//  FirstTableViewCell.m
//  XibEnough
//
//  Created by qsyMac on 16/7/10.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "FirstModel.h"

@interface FirstTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vip;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation FirstTableViewCell

//构造方法的实现
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"firstViewCell";//将cell的创建封装到类内部
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {//缓存池找不到cell时,从xib创建
//        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FirstTableViewCell class]) owner:nil options:nil] lastObject];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstViewCell" owner:self options:nil] lastObject];

    }
    return cell;
}

- (void)awakeFromNib {
    //设置contentLabel的最大宽度,防止layoutIfNeeded方法计算的尺寸偏差.
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
}
    // Initialization code
//重写模型属性的set方法
- (void)setFirstModel:(FirstModel *)firstModel {
    _firstModel = firstModel;
# pragma mark 少 设置模型属性内部子控件的值
    self.nameLabel.text = _firstModel.name;
    
    // 判断vip的状态
    if (_firstModel.isVip) {
        self.vip.hidden = NO;
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.vip.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
//    设置图片
    self.imgName.image = [UIImage imageNamed:_firstModel.icon];
//    设置内容
    self.contentLabel.text = _firstModel.text;
    //强制布局控件
    [self layoutIfNeeded];
    //返回cell的高度
    _firstModel.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
