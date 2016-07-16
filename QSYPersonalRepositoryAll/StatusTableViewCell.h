//
//  StatusTableViewCell.h
//  tableview使用大全
//
//  Created by 邱少依 on 15/12/25.
//  Copyright © 2015年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboStatus;
@interface StatusTableViewCell : UITableViewCell
@property (nonatomic, strong) WeiboStatus *weiboStatus;
@property (assign,nonatomic) CGFloat height;

@end
