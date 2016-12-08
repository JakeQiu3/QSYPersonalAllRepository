//
//  JsonTransferModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/7.
//  Copyright © 2016年 QSY. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>
@class SubJsonModel;
@interface JsonTransferModel : JSONModel

@property (assign, nonatomic) int id;
@property (nonatomic, assign) CGFloat Test;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* dialNumber;
@property (assign, nonatomic) BOOL isInEurope;
@property (nonatomic, strong) SubJsonModel *product;// model中包含subModel
@property (nonatomic, strong) NSArray *numArr;// model中含有array

@end
