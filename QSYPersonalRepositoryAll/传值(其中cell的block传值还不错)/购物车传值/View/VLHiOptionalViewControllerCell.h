//
//  VLHiOptionalViewControllerCell.h
//  VoiceLink
//
//  Created by fanyunyu on 16/1/13.
//  Copyright © 2016年 voilink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLHiOptionalModel.h"

@interface VLHiOptionalViewControllerCell : UITableViewCell


@property (nonatomic, strong)  UILabel *productNameLabel;

@property (nonatomic, strong)  UILabel *bidPriceLabel;

@property (nonatomic, strong)  UILabel *priceLabel;

@property (nonatomic, strong)  UILabel *timesLabel ;

@property (nonatomic, strong)  NSIndexPath *indexPath;

-   (void)configCellWithModel:(VLHiOptionalModel*)model;


@property (nonatomic, copy)  void (^myBlock)(NSString *times , NSIndexPath *indexPath);

@end
