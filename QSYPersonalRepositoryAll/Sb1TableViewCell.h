//
//  SbTableViewCell.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/4.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Sb1Model;
@interface Sb1TableViewCell : UITableViewCell

@property (nonatomic, strong)Sb1Model *model;
+ (instancetype)cellWithTalbeView:(UITableView *)tableView;

@end
