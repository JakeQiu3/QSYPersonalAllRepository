//
//  SbTableViewCell.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/4.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "Sb1TableViewCell.h"
#import "Sb1Model.h"

@interface Sb1TableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@end

@implementation Sb1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTalbeView:(UITableView *)tableView {
    static NSString *ID = @"sb1Cell";
    Sb1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([Sb1TableViewCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
    
}

- (void)setModel:(Sb1Model *)model {
    _model = model;
    self.picImageView.image = [UIImage imageNamed:_model.picStr];
    self.titile.text = _model.titleStr;
    self.detailTitle.text = _model.detailTitleStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
