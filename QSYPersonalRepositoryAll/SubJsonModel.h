//
//  SubJsonModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2016/12/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SubJsonModel : JSONModel
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSString *name;
@property (nonatomic) float price;
@end
