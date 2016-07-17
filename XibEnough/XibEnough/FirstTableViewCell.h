//
//  FirstTableViewCell.h
//  XibEnough
//
//  Created by qsyMac on 16/7/10.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstModel;
@interface FirstTableViewCell : UITableViewCell
@property (nonatomic, strong) FirstModel *firstModel;
@property (assign,nonatomic) CGFloat height;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
