//
//  RequestViewModel.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/13.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "Book.h"
// url:https://api.douban.com/v2/book/search?q=基础
@interface RequestViewModel : NSObject<UITableViewDataSource>
// 请求命令
@property (nonatomic, strong, readonly) RACCommand *reuqesCommand;
//模型数组
@property (nonatomic, strong) NSArray *modelsArray;

@end
